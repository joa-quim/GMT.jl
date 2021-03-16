# This sub-module is made entirely with code 'subtracted' from the GDAL (https://github.com/JuliaGeo/GDAL.jl)
# and ArcgGDAL https://github.com/yeesian/ArchGDAL.jl packages so credits goes entirely for the authors
# of those packages (Martijn Visser @visr and Yeesian Ng @yeesian).
#
# Why this 'stealing' instead of adding those packages as dependencies?
# Well, first because I wanted to use only a small subset of the full GDAL wrapper and didn't want to add
# a bunch of new dependencies.
# Second because I don't like the idea that the GDAL binary has to come from GDAL_JLL which has a significantly
# lower number of drivers then the system installed ones, especially on Windows. And also, why install a bunch
# more of files if GMT already has them?
#
# It turned out that this file grew more than I anticipated, so maybe I'll revert the decision ... but not yet.

module Gdal

using GMT

#const cacert = joinpath(@__DIR__, "cacert.pem")

@static Sys.iswindows() ?
	(Sys.WORD_SIZE == 64 ? (const libgdal = "gdal_w64") : (const libgdal = "gdal_w32")) : (
		Sys.isapple() ? (const libgdal = Symbol(split(readlines(pipeline(`otool -L $(GMT.thelib)`, `grep libgdal`))[1])[1])) : (
			Sys.isunix() ? (const libgdal = Symbol(split(readlines(pipeline(`ldd $(GMT.thelib)`, `grep libgdal`))[1])[3])) :
			error("Don't know how to install this package in this OS.")
		)
	)

const GDT_Unknown = UInt32(0)
const GDT_Byte = UInt32(1)
const GDT_UInt16 = UInt32(2)
const GDT_Int16 = UInt32(3)
const GDT_UInt32 = UInt32(4)
const GDT_Int32 = UInt32(5)
const GDT_Float32 = UInt32(6)
const GDT_Float64 = UInt32(7)
const GDT_CInt16 = UInt32(8)
const GDT_CInt32 = UInt32(9)
const GDT_CFloat32 = UInt32(10)
const GDT_CFloat64 = UInt32(11)
const GDT_TypeCount = UInt32(12)

const CE_None = UInt32(0)
const CE_Debug = UInt32(1)
const CE_Warning = UInt32(2)
const CE_Failure = UInt32(3)
const CE_Fatal = UInt32(4)
const OGRERR_NONE = UInt32(0)

const GF_Read  = UInt32(0)
const GF_Write = UInt32(1)

const GDAL_OF_READONLY = 0x00				# Open in read-only mode
const GDAL_OF_VERBOSE_ERROR = 0x40			# Emit error message in case of failed open

const OAMS_TRADITIONAL_GIS_ORDER = Int32(0)

const OFTInteger = UInt32(0)
const OFTIntegerList = UInt32(1)
const OFTReal = UInt32(2)
const OFTRealList = UInt32(3)
const OFTString = UInt32(4)
const OFTStringList = UInt32(5)
const OFTWideString = UInt32(6)
const OFTWideStringList = UInt32(7)
const OFTBinary = UInt32(8)
const OFTDate = UInt32(9)
const OFTTime = UInt32(10)
const OFTDateTime = UInt32(11)
const OFTInteger64 = UInt32(12)
const OFTInteger64List = UInt32(13)
const OFTMaxType = UInt32(13)

const wkbUnknown = UInt32(0)
const wkbPoint = UInt32(1)
const wkbLineString = UInt32(2)
const wkbPolygon = UInt32(3)
const wkbMultiPoint = UInt32(4)
const wkbMultiLineString = UInt32(5)
const wkbMultiPolygon = UInt32(6)
const wkbGeometryCollection = UInt32(7)
const wkbCircularString = UInt32(8)
const wkbCompoundCurve = UInt32(9)
const wkbCurvePolygon = UInt32(10)
const wkbMultiCurve = UInt32(11)
const wkbMultiSurface = UInt32(12)
const wkbCurve = UInt32(13)
const wkbSurface = UInt32(14)
const wkbPolyhedralSurface = UInt32(15)
const wkbTIN = UInt32(16)
const wkbTriangle = UInt32(17)
const wkbNone = UInt32(100)
const wkbLinearRing = UInt32(101)
const wkbCircularStringZ = UInt32(1008)
const wkbCompoundCurveZ = UInt32(1009)
const wkbCurvePolygonZ = UInt32(1010)
const wkbMultiCurveZ = UInt32(1011)
const wkbMultiSurfaceZ = UInt32(1012)
const wkbCurveZ = UInt32(1013)
const wkbSurfaceZ = UInt32(1014)
const wkbPolyhedralSurfaceZ = UInt32(1015)
const wkbTINZ = UInt32(1016)
const wkbTriangleZ = UInt32(1017)
const wkbPointM = UInt32(2001)
const wkbLineStringM = UInt32(2002)
const wkbPolygonM = UInt32(2003)
const wkbMultiPointM = UInt32(2004)
const wkbMultiLineStringM = UInt32(2005)
const wkbMultiPolygonM = UInt32(2006)
const wkbGeometryCollectionM = UInt32(2007)
const wkbCircularStringM = UInt32(2008)
const wkbCompoundCurveM = UInt32(2009)
const wkbCurvePolygonM = UInt32(2010)
const wkbMultiCurveM = UInt32(2011)
const wkbMultiSurfaceM = UInt32(2012)
const wkbCurveM = UInt32(2013)
const wkbSurfaceM = UInt32(2014)
const wkbPolyhedralSurfaceM = UInt32(2015)
const wkbTINM = UInt32(2016)
const wkbTriangleM = UInt32(2017)
const wkbPointZM = UInt32(3001)
const wkbLineStringZM = UInt32(3002)
const wkbPolygonZM = UInt32(3003)
const wkbMultiPointZM = UInt32(3004)
const wkbMultiLineStringZM = UInt32(3005)
const wkbMultiPolygonZM = UInt32(3006)
const wkbGeometryCollectionZM = UInt32(3007)
const wkbCircularStringZM = UInt32(3008)
const wkbCompoundCurveZM = UInt32(3009)
const wkbCurvePolygonZM = UInt32(3010)
const wkbMultiCurveZM = UInt32(3011)
const wkbMultiSurfaceZM = UInt32(3012)
const wkbCurveZM = UInt32(3013)
const wkbSurfaceZM = UInt32(3014)
const wkbPolyhedralSurfaceZM = UInt32(3015)
const wkbTINZM = UInt32(3016)
const wkbTriangleZM = UInt32(3017)
const wkbPoint25D = UInt32(2147483649)
const wkbLineString25D = UInt32(2147483650)
const wkbPolygon25D = UInt32(2147483651)
const wkbMultiPoint25D = UInt32(2147483652)
const wkbMultiLineString25D = UInt32(2147483653)
const wkbMultiPolygon25D = UInt32(2147483654)
const wkbGeometryCollection25D = UInt32(2147483655)

struct GDALRasterIOExtraArg
	nVersion::Cint
	eResampleAlg::UInt32
	pfnProgress::Ptr{Cvoid}
	pProgressData::Ptr{Cvoid}
	bFloatingPointWindowValidity::Cint
	dfXOff::Cdouble
	dfYOff::Cdouble
	dfXSize::Cdouble
	dfYSize::Cdouble
end

struct GDALColorEntry
	c1::Int16
	c2::Int16
	c3::Int16
	c4::Int16
end

struct GDALError <: Exception
	class::Cint
	code::Cint
	msg::String
	# reset GDAL's error stack on construction
	function GDALError(class, code, msg)
		CPLErrorReset()
		new(class, code, msg)
	end
end

function GDALError()
	class = CPLGetLastErrorType()
	code = CPLGetLastErrorNo()
	msg = CPLGetLastErrorMsg()
	GDALError(class, code, msg)
end

GDALAllRegister() = aftercare(ccall((:GDALAllRegister, libgdal), Cvoid, ()))
GDALDestroyDriverManager() = aftercare(ccall((:GDALDestroyDriverManager, libgdal), Cvoid, ()))

CPLErrorReset() = ccall((:CPLErrorReset, libgdal), Cvoid, ())
CPLGetLastErrorType() = ccall((:CPLGetLastErrorType, libgdal), Cint, ())
CPLGetLastErrorNo()   = ccall((:CPLGetLastErrorNo, libgdal), Cint, ())
CPLGetLastErrorMsg()  = unsafe_string(ccall((:CPLGetLastErrorMsg, libgdal), Cstring, ()))
CPLPushErrorHandler(a1) = ccall((:CPLPushErrorHandler, libgdal), Cvoid, (Ptr{Cvoid},), a1)
CPLQuietErrorHandler(a1, a2, a3) = ccall((:CPLQuietErrorHandler, libgdal), Cvoid, (UInt32, Cint, Cstring), a1, a2, a3)
CPLPopErrorHandler() = ccall((:CPLPopErrorHandler, libgdal), Cvoid, ())

VSIFree(a1) = aftercare(ccall((:VSIFree, libgdal), Cvoid, (Ptr{Cvoid},), a1))

function Base.showerror(io::IO, err::GDALError)
	println(io, string("GDALError (", err.class, ", code ", err.code, "):\n\t", err.msg))
end

function aftercare(x)
	maybe_throw()
	x
end

function aftercare(ptr::Cstring, free::Bool)	# For string pointers, load them to String, and free them if we should.
	maybe_throw()
	(ptr == C_NULL) && return nothing
	s = unsafe_string(ptr)
	free && VSIFree(convert(Ptr{Cvoid}, ptr))
	return s
end

function aftercare(ptr::Ptr{Cstring})
	maybe_throw()
	strings = Vector{String}()
	(ptr == C_NULL) && return strings
	i = 1
	cstring = unsafe_load(ptr, i)
	while cstring != C_NULL
		push!(strings, unsafe_string(cstring))
		i += 1
		cstring = unsafe_load(ptr, i)
	end
	# TODO it seems that, like aftercare(::Cstring), we need to
	# free the memory ourselves with CSLDestroy (not currently wrapped)
	# not sure if that is true for some or all functions
	strings
end

function maybe_throw()		# Check the last error type and throw a GDALError if it is a failure
	(CPLGetLastErrorType() === CE_Failure) && throw(GDALError())
	nothing
end

GDALDestroyDriver(a1) = aftercare(ccall((:GDALDestroyDriver, libgdal), Cvoid, (Ptr{Cvoid},), a1))

function GDALCreate(hDriver, a1, a2, a3, a4, a5, a6)
	aftercare(ccall((:GDALCreate, libgdal), Ptr{Cvoid}, (Ptr{Cvoid}, Cstring, Cint, Cint, Cint, UInt32, Ptr{Cstring}), hDriver, a1, a2, a3, a4, a5, a6))
end

GDALGetDataTypeByName(a1) = aftercare(ccall((:GDALGetDataTypeByName, libgdal), UInt32, (Cstring,), a1))
GDALGetRasterBand(a1, a2) = aftercare(ccall((:GDALGetRasterBand, libgdal), Ptr{Cvoid}, (Ptr{Cvoid}, Cint), a1, a2))

GDALSetProjection(a1, a2) = aftercare(ccall((:GDALSetProjection, libgdal), UInt32, (Ptr{Cvoid}, Cstring), a1, a2))

GDALGetRasterDataType(a1) = aftercare(ccall((:GDALGetRasterDataType, libgdal), UInt32, (Ptr{Cvoid},), a1))
GDALGetProjectionRef(a1) = aftercare(ccall((:GDALGetProjectionRef, libgdal), Cstring, (Ptr{Cvoid},), a1), false)
GDALGetDatasetDriver(a1) = aftercare(ccall((:GDALGetDatasetDriver, libgdal), Ptr{Cvoid}, (Ptr{Cvoid},), a1))
GDALGetDriver(a1) = aftercare(ccall((:GDALGetDriver, libgdal), Ptr{Cvoid}, (Cint,), a1))
GDALGetDriverByName(a1) = aftercare(ccall((:GDALGetDriverByName, libgdal), Ptr{Cvoid}, (Cstring,), a1))
GDALGetDriverShortName(a1) = aftercare(ccall((:GDALGetDriverShortName, libgdal), Cstring, (Ptr{Cvoid},), a1), false)
GDALGetDriverLongName(a1) = aftercare(ccall((:GDALGetDriverLongName, libgdal), Cstring, (Ptr{Cvoid},), a1), false)
GDALGetDriverCreationOptionList(a1) = aftercare(ccall((:GDALGetDriverCreationOptionList, libgdal), Cstring, (Ptr{Cvoid},), a1), false)
GDALDatasetGetLayer(a1, a2) = aftercare(ccall((:GDALDatasetGetLayer, libgdal), Ptr{Cvoid}, (Ptr{Cvoid}, Cint), a1, a2))
function GDALDatasetGetLayerByName(a1, a2)
	aftercare(ccall((:GDALDatasetGetLayerByName, libgdal), Ptr{Cvoid}, (Ptr{Cvoid}, Cstring), a1, a2))
end
GDALGetRasterBandXSize(a1) = aftercare(ccall((:GDALGetRasterBandXSize, libgdal), Cint, (Ptr{Cvoid},), a1))
GDALGetRasterBandYSize(a1) = aftercare(ccall((:GDALGetRasterBandYSize, libgdal), Cint, (Ptr{Cvoid},), a1))
GDALGetRasterXSize(a1)     = aftercare(ccall((:GDALGetRasterXSize, libgdal), Cint, (Ptr{Cvoid},), a1))
GDALGetRasterYSize(a1)     = aftercare(ccall((:GDALGetRasterYSize, libgdal), Cint, (Ptr{Cvoid},), a1))
GDALGetRasterColorTable(a1) = aftercare(ccall((:GDALGetRasterColorTable, libgdal), Ptr{Cvoid}, (Ptr{Cvoid},), a1))
GDALDatasetGetLayerCount(a1) = aftercare(ccall((:GDALDatasetGetLayerCount, libgdal), Cint, (Ptr{Cvoid},), a1))
GDALGetRasterCount(a1)  = aftercare(ccall((:GDALGetRasterCount, libgdal), Cint, (Ptr{Cvoid},), a1))
GDALGetFileList(a1)     = aftercare(ccall((:GDALGetFileList, libgdal), Ptr{Cstring}, (Ptr{Cvoid},), a1))
GDALGetRasterAccess(a1) = aftercare(ccall((:GDALGetRasterAccess, libgdal), UInt32, (Ptr{Cvoid},), a1))
GDALGetBandNumber(a1)   = aftercare(ccall((:GDALGetBandNumber, libgdal), Cint, (Ptr{Cvoid},), a1))
GDALGetDriverCount()    = aftercare(ccall((:GDALGetDriverCount, libgdal), Cint, ()))

function GDALGetRasterColorInterpretation(a1)
	aftercare(ccall((:GDALGetRasterColorInterpretation, libgdal), UInt32, (Ptr{Cvoid},), a1))
end

function GDALGetColorInterpretationName(a1)
	aftercare(ccall((:GDALGetColorInterpretationName, libgdal), Cstring, (UInt32,), a1), false)
end
function GDALGetPaletteInterpretationName(a1)
	aftercare(ccall((:GDALGetPaletteInterpretationName, libgdal), Cstring, (UInt32,), a1), false)
end
GDALGetPaletteInterpretation(a1) = aftercare(ccall((:GDALGetPaletteInterpretation, libgdal), UInt32, (Ptr{Cvoid},), a1))
GDALGetColorEntryCount(a1) = aftercare(ccall((:GDALGetColorEntryCount, libgdal), Cint, (Ptr{Cvoid},), a1))
GDALGetColorEntry(a1, a2) = aftercare(ccall((:GDALGetColorEntry, libgdal), Ptr{GDALColorEntry}, (Ptr{Cvoid}, Cint), a1, a2))

function GDALGetGeoTransform(a1, a2)
	aftercare(ccall((:GDALGetGeoTransform, libgdal), UInt32, (Ptr{Cvoid}, Ptr{Cdouble}), a1, a2))
end
function GDALSetGeoTransform(a1, a2)
	aftercare(ccall((:GDALSetGeoTransform, libgdal), UInt32, (Ptr{Cvoid}, Ptr{Cdouble}), a1, a2))
end

function GDALOpenEx(pszFilename, nOpenFlags, papszAllowedDrivers, papszOpenOptions, papszSiblingFiles)
	aftercare(ccall((:GDALOpenEx, libgdal), Ptr{Cvoid}, (Cstring, UInt32, Ptr{Cstring}, Ptr{Cstring}, Ptr{Cstring}), pszFilename, nOpenFlags, papszAllowedDrivers, papszOpenOptions, papszSiblingFiles))
end

GDALClose(a1) = aftercare(ccall((:GDALClose, libgdal), Cvoid, (Ptr{Cvoid},), a1))
GDALVersionInfo(a1) = aftercare(ccall((:GDALVersionInfo, libgdal), Cstring, (Cstring,), a1), false)

function GDALRasterIOEx(hRBand, eRWFlag, nDSXOff, nDSYOff, nDSXSize, nDSYSize, pBuffer, nBXSize, nBYSize, eBDataType, nPixelSpace, nLineSpace, psExtraArg)
	aftercare(ccall((:GDALRasterIOEx, libgdal), UInt32, (Ptr{Cvoid}, UInt32, Cint, Cint, Cint, Cint, UInt32, Cint, Cint, Ptr{Cvoid}, Clonglong, Clonglong, Ptr{GDALRasterIOExtraArg}), hRBand, eRWFlag, nDSXOff, nDSYOff, nDSXSize, nDSYSize, pBuffer, nBXSize, nBYSize, eBDataType, nPixelSpace, nLineSpace, psExtraArg))
end

function GDALDatasetRasterIOEx(hDS, eRWFlag, nDSXOff, nDSYOff, nDSXSize, nDSYSize, pBuffer, nBXSize, nBYSize, eBDataType, nBandCount, panBandCount, nPixelSpace, nLineSpace, nBandSpace, psExtraArg)
	aftercare(ccall((:GDALDatasetRasterIOEx, libgdal), UInt32, (Ptr{Cvoid}, UInt32, Cint, Cint, Cint, Cint, Ptr{Cvoid}, Cint, Cint, UInt32, Cint, Ptr{Cint}, Clonglong, Clonglong, Clonglong, Ptr{GDALRasterIOExtraArg}), hDS, eRWFlag, nDSXOff, nDSYOff, nDSXSize, nDSYSize, pBuffer, nBXSize, nBYSize, eBDataType, nBandCount, panBandCount, nPixelSpace, nLineSpace, nBandSpace, psExtraArg))
end

function GDALDummyProgress(a1, a2, a3)
	aftercare(ccall((:GDALDummyProgress, libgdal), Cint, (Cdouble, Cstring, Ptr{Cvoid}), a1, a2, a3))
end
function GDALCreateCopy(a1, a2, a3, a4, a5, a6, a7)
	aftercare(ccall((:GDALCreateCopy, libgdal), Ptr{Cvoid}, (Ptr{Cvoid}, Cstring, Ptr{Cvoid}, Cint, Ptr{Cstring}, Ptr{Cvoid}, Ptr{Cvoid}), a1, a2, a3, a4, a5, a6, a7))
end

CPLSetConfigOption(a1, a2) = aftercare(ccall((:CPLSetConfigOption, libgdal), Cvoid, (Cstring, Cstring), a1, a2))

OSRDestroySpatialReference(a1) = aftercare(ccall((:OSRDestroySpatialReference, libgdal), Cvoid, (Ptr{Cvoid},), a1))
function OCTDestroyCoordinateTransformation(a1)
	aftercare(ccall((:OCTDestroyCoordinateTransformation, libgdal), Cvoid, (Ptr{Cvoid},), a1))
end

OSRExportToWkt(a1, a2) = aftercare(ccall((:OSRExportToWkt, libgdal), Cint, (Ptr{Cvoid}, Ptr{Cstring}), a1, a2))

function OSRExportToPrettyWkt(a1, a2, a3)
	aftercare(ccall((:OSRExportToPrettyWkt, libgdal), Cint, (Ptr{Cvoid}, Ptr{Cstring}, Cint), a1, a2, a3))
end

OSRExportToProj4(a1, a2) = aftercare(ccall((:OSRExportToProj4, libgdal), Cint, (Ptr{Cvoid}, Ptr{Cstring}), a1, a2))
OSRImportFromWkt(a1, a2) = aftercare(ccall((:OSRImportFromWkt, libgdal), Cint, (Ptr{Cvoid}, Ptr{Cstring}), a1, a2))
OSRImportFromProj4(a1, a2) = aftercare(ccall((:OSRImportFromProj4, libgdal), Cint, (Ptr{Cvoid}, Cstring), a1, a2))
OSRImportFromEPSG(a1, a2) = aftercare(ccall((:OSRImportFromEPSG, libgdal), Cint, (Ptr{Cvoid}, Cint), a1, a2))
OSRNewSpatialReference(a1) = aftercare(ccall((:OSRNewSpatialReference, libgdal), Ptr{Cvoid}, (Cstring,), a1))

function OSRSetAxisMappingStrategy(hSRS, strategy)
	(Gdal.GDALVERSION[] < v"3.0.0") && return
	aftercare(ccall((:OSRSetAxisMappingStrategy, libgdal), Cvoid, (Ptr{Cvoid}, UInt32), hSRS, strategy))
end

OGR_F_Create(a1) = aftercare(ccall((:OGR_F_Create, libgdal), Ptr{Cvoid}, (Ptr{Cvoid},), a1))
OGR_F_Destroy(a1) = aftercare(ccall((:OGR_F_Destroy, libgdal), Cvoid, (Ptr{Cvoid},), a1))
OGR_F_GetGeometryRef(a1) = aftercare(ccall((:OGR_F_GetGeometryRef, libgdal), Ptr{Cvoid}, (Ptr{Cvoid},), a1))
OGR_F_GetGeomFieldCount(hFeat) = aftercare(ccall((:OGR_F_GetGeomFieldCount, libgdal), Cint, (Ptr{Cvoid},), hFeat))
OGR_F_GetFieldCount(a1) = aftercare(ccall((:OGR_F_GetFieldCount, libgdal), Cint, (Ptr{Cvoid},), a1))
OGR_F_GetFieldDefnRef(a1, a2) = aftercare(ccall((:OGR_F_GetFieldDefnRef, libgdal), Ptr{Cvoid}, (Ptr{Cvoid}, Cint), a1, a2))
OGR_F_GetFieldIndex(a1, a2) = aftercare(ccall((:OGR_F_GetFieldIndex, libgdal), Cint, (Ptr{Cvoid}, Cstring), a1, a2))
OGR_F_IsFieldSet(a1, a2) = aftercare(ccall((:OGR_F_IsFieldSet, libgdal), Cint, (Ptr{Cvoid}, Cint), a1, a2))
OGR_F_GetFieldAsInteger(a1, a2) = aftercare(ccall((:OGR_F_GetFieldAsInteger, libgdal), Cint, (Ptr{Cvoid}, Cint), a1, a2))
OGR_F_GetFieldAsInteger64(a1, a2) = aftercare(ccall((:OGR_F_GetFieldAsInteger64, libgdal), Clonglong, (Ptr{Cvoid}, Cint), a1, a2))
OGR_F_GetFieldAsDouble(a1, a2) = aftercare(ccall((:OGR_F_GetFieldAsDouble, libgdal), Cdouble, (Ptr{Cvoid}, Cint), a1, a2))
OGR_F_GetFieldAsString(a1, a2) = aftercare(ccall((:OGR_F_GetFieldAsString, libgdal), Cstring, (Ptr{Cvoid}, Cint), a1, a2), false)
OGR_F_GetFieldAsStringList(a1, a2) = aftercare(ccall((:OGR_F_GetFieldAsStringList, libgdal), Ptr{Cstring}, (Ptr{Cvoid}, Cint), a1, a2))
function OGR_F_GetFieldAsIntegerList(a1, a2, a3)
	aftercare(ccall((:OGR_F_GetFieldAsIntegerList, libgdal), Ptr{Cint}, (Ptr{Cvoid}, Cint, Ptr{Cint}), a1, a2, a3))
end
function OGR_F_GetFieldAsInteger64List(a1, a2, a3)
	aftercare(ccall((:OGR_F_GetFieldAsInteger64List, libgdal), Ptr{Clonglong}, (Ptr{Cvoid}, Cint, Ptr{Cint}), a1, a2, a3))
end
function OGR_F_GetFieldAsDoubleList(a1, a2, a3)
	aftercare(ccall((:OGR_F_GetFieldAsDoubleList, libgdal), Ptr{Cdouble}, (Ptr{Cvoid}, Cint, Ptr{Cint}), a1, a2, a3))
end
function OGR_F_GetFieldAsBinary(a1, a2, a3)
	aftercare(ccall((:OGR_F_GetFieldAsBinary, libgdal), Ptr{Cuchar}, (Ptr{Cvoid}, Cint, Ptr{Cint}), a1, a2, a3))
end
function OGR_F_GetFieldAsDateTime(a1, a2, a3, a4, arg5, arg6, arg7, arg8, arg9)
	aftercare(ccall((:OGR_F_GetFieldAsDateTime, libgdal), Cint, (Ptr{Cvoid}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), a1, a2, a3, a4, arg5, arg6, arg7, arg8, arg9))
end
function OGR_F_GetGeomFieldDefnRef(hFeat, iField)
	aftercare(ccall((:OGR_F_GetGeomFieldDefnRef, libgdal), Ptr{Cvoid}, (Ptr{Cvoid}, Cint), hFeat, iField))
end
function OGR_F_GetGeomFieldRef(hFeat, iField)
	aftercare(ccall((:OGR_F_GetGeomFieldRef, libgdal), Ptr{Cvoid}, (Ptr{Cvoid}, Cint), hFeat, iField))
end
OGR_F_SetGeometry(a1, a2) = aftercare(ccall((:OGR_F_SetGeometry, libgdal), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), a1, a2))
function OGR_F_SetGeomField(hFeat, iField, hGeom)
	aftercare(ccall((:OGR_F_SetGeomField, libgdal), Cint, (Ptr{Cvoid}, Cint, Ptr{Cvoid}), hFeat, iField, hGeom))
end

OGR_FD_AddFieldDefn(a1, a2) = aftercare(ccall((:OGR_FD_AddFieldDefn, libgdal), Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}), a1, a2))
OGR_FD_Destroy(a1) = aftercare(ccall((:OGR_FD_Destroy, libgdal), Cvoid, (Ptr{Cvoid},), a1))
OGR_FD_GetFieldCount(a1) = aftercare(ccall((:OGR_FD_GetFieldCount, libgdal), Cint, (Ptr{Cvoid},), a1))
OGR_FD_GetFieldDefn(a1, a2) = aftercare(ccall((:OGR_FD_GetFieldDefn, libgdal), Ptr{Cvoid}, (Ptr{Cvoid}, Cint), a1, a2))
OGR_FD_GetFieldIndex(a1, a2) = aftercare(ccall((:OGR_FD_GetFieldIndex, libgdal), Cint, (Ptr{Cvoid}, Cstring), a1, a2))
OGR_FD_GetName(a1) = aftercare(ccall((:OGR_FD_GetName, libgdal), Cstring, (Ptr{Cvoid},), a1), false)
OGR_FD_GetGeomType(a1)    = aftercare(ccall((:OGR_FD_GetGeomType, libgdal), UInt32, (Ptr{Cvoid},), a1))
OGR_FD_GetGeomFieldCount(hFDefn) = aftercare(ccall((:OGR_FD_GetGeomFieldCount, libgdal), Cint, (Ptr{Cvoid},), hFDefn))
function OGR_FD_GetGeomFieldDefn(hFDefn, i)
	aftercare(ccall((:OGR_FD_GetGeomFieldDefn, libgdal), Ptr{Cvoid}, (Ptr{Cvoid}, Cint), hFDefn, i))
end
OGR_Fld_Create(a1, a2) = aftercare(ccall((:OGR_Fld_Create, libgdal), Ptr{Cvoid}, (Cstring, UInt32), a1, a2))
OGR_Fld_Destroy(a1) = aftercare(ccall((:OGR_Fld_Destroy, libgdal), Cvoid, (Ptr{Cvoid},), a1))
OGR_Fld_GetDefault(hDefn) = aftercare(ccall((:OGR_Fld_GetDefault, libgdal), Cstring, (Ptr{Cvoid},), hDefn), false)
OGR_Fld_GetNameRef(a1) = aftercare(ccall((:OGR_Fld_GetNameRef, libgdal), Cstring, (Ptr{Cvoid},), a1), false)
OGR_Fld_GetType(a1) = aftercare(ccall((:OGR_Fld_GetType, libgdal), UInt32, (Ptr{Cvoid},), a1))
OGR_GFld_Destroy(a1) = aftercare(ccall((:OGR_GFld_Destroy, libgdal), Cvoid, (Ptr{Cvoid},), a1))
OGR_GFld_GetType(a1) = aftercare(ccall((:OGR_GFld_GetType, libgdal), UInt32, (Ptr{Cvoid},), a1))
function OGR_Fld_Set(a1, a2, a3, a4, a5, a6)
	aftercare(ccall((:OGR_Fld_Set, libgdal), Cvoid, (Ptr{Cvoid}, Cstring, UInt32, Cint, Cint, UInt32), a1, a2, a3, a4, a5, a6))
end
OGR_G_AddGeometry(a1, a2) = aftercare(ccall((:OGR_G_AddGeometry, libgdal), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), a1, a2))
OGR_G_AddGeometryDirectly(a1, a2) = aftercare(ccall((:OGR_G_AddGeometryDirectly, libgdal), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), a1, a2))
OGR_G_Clone(a1) = aftercare(ccall((:OGR_G_Clone, libgdal), Ptr{Cvoid}, (Ptr{Cvoid},), a1))
OGR_G_CreateGeometry(a1) = aftercare(ccall((:OGR_G_CreateGeometry, libgdal), Ptr{Cvoid}, (UInt32,), a1))
OGR_G_DestroyGeometry(a1) = aftercare(ccall((:OGR_G_DestroyGeometry, libgdal), Cvoid, (Ptr{Cvoid},), a1))
OGR_G_ExportToWkt(a1, a2) = aftercare(ccall((:OGR_G_ExportToWkt, libgdal), Cint, (Ptr{Cvoid}, Ptr{Cstring}), a1, a2))
OGR_G_GetGeometryType(a1) = aftercare(ccall((:OGR_G_GetGeometryType, libgdal), UInt32, (Ptr{Cvoid},), a1))
OGR_G_GetGeometryCount(a1) = aftercare(ccall((:OGR_G_GetGeometryCount, libgdal), Cint, (Ptr{Cvoid},), a1))
OGR_G_GetPointCount(a1) = aftercare(ccall((:OGR_G_GetPointCount, libgdal), Cint, (Ptr{Cvoid},), a1))
OGR_G_GetX(a1, a2) = aftercare(ccall((:OGR_G_GetX, libgdal), Cdouble, (Ptr{Cvoid}, Cint), a1, a2))
OGR_G_GetY(a1, a2) = aftercare(ccall((:OGR_G_GetY, libgdal), Cdouble, (Ptr{Cvoid}, Cint), a1, a2))
OGR_G_GetZ(a1, a2) = aftercare(ccall((:OGR_G_GetZ, libgdal), Cdouble, (Ptr{Cvoid}, Cint), a1, a2))
function OGR_G_GetPoint(a1, iPoint, a2, a3, a4)
	aftercare(ccall((:OGR_G_GetPoint, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), a1, iPoint, a2, a3, a4))
end
function OGR_G_SetPoints(hGeom, nPointsIn, pabyX, nXStride, pabyY, nYStride, pabyZ, nZStride)
	aftercare(ccall((:OGR_G_SetPoints, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Ptr{Cvoid}, Cint, Ptr{Cvoid}, Cint, Ptr{Cvoid}, Cint), hGeom, nPointsIn, pabyX, nXStride, pabyY, nYStride, pabyZ, nZStride))
end
function OGR_G_SetPoint(a1, iPt, a2, a3, a4)
	aftercare(ccall((:OGR_G_SetPoint, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Cdouble, Cdouble, Cdouble), a1, iPt, a2, a3, a4))
end
function OGR_G_SetPoint_2D(a1, iPt, a2, a3)
    aftercare(ccall((:OGR_G_SetPoint_2D, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Cdouble, Cdouble), a1, iPt, a2, a3))
end
OGR_L_CreateFeature(a1, a2) = aftercare(ccall((:OGR_L_CreateFeature, libgdal), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), a1, a2))
OGR_L_GetFeatureCount(a1, a2) = aftercare(ccall((:OGR_L_GetFeatureCount, libgdal), Clonglong, (Ptr{Cvoid}, Cint), a1, a2))
OGR_L_GetName(a1)  = aftercare(ccall((:OGR_L_GetName, libgdal), Cstring, (Ptr{Cvoid},), a1), false)
OGR_L_GetGeomType(a1)  = aftercare(ccall((:OGR_L_GetGeomType, libgdal), UInt32, (Ptr{Cvoid},), a1))
OGR_L_GetLayerDefn(a1) = aftercare(ccall((:OGR_L_GetLayerDefn, libgdal), Ptr{Cvoid}, (Ptr{Cvoid},), a1))
OGR_L_GetNextFeature(a1) = aftercare(ccall((:OGR_L_GetNextFeature, libgdal), Ptr{Cvoid}, (Ptr{Cvoid},), a1))
OGR_L_ResetReading(a1) = aftercare(ccall((:OGR_L_ResetReading, libgdal), Cvoid, (Ptr{Cvoid},), a1))
OGR_L_SetFeature(a1, a2) = aftercare(ccall((:OGR_L_SetFeature, libgdal), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), a1, a2))
#OGR_GetFieldTypeName(a1)  = aftercare(ccall((:OGR_GetFieldTypeName, libgdal), Cstring, (UInt32,), a1), false)
#OGR_GetFieldSubTypeName(a1) = aftercare(ccall((:OGR_GetFieldSubTypeName, libgdal), Cstring, (UInt32,), a1), false)
OGRGetDriverCount() = aftercare(ccall((:OGRGetDriverCount, libgdal), Cint, ()))

function OGR_G_AddPoint(a1, a2, a3, a4)
	aftercare(ccall((:OGR_G_AddPoint, libgdal), Cvoid, (Ptr{Cvoid}, Cdouble, Cdouble, Cdouble), a1, a2, a3, a4))
end
function OGR_G_AddPoint_2D(a1, a2, a3)
	aftercare(ccall((:OGR_G_AddPoint_2D, libgdal), Cvoid, (Ptr{Cvoid}, Cdouble, Cdouble), a1, a2, a3))
end

function OGR_L_CreateField(a1, a2, a3)
	aftercare(ccall((:OGR_L_CreateField, libgdal), Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Cint), a1, a2, a3))
end
function OGR_L_FindFieldIndex(a1, a2, bExactMatch)
	aftercare(ccall((:OGR_L_FindFieldIndex, libgdal), Cint, (Ptr{Cvoid}, Cstring, Cint), a1, a2, bExactMatch))
end

OGR_F_SetFieldInteger(a1, a2, a3) = aftercare(ccall((:OGR_F_SetFieldInteger, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Cint), a1, a2, a3))
OGR_F_SetFieldInteger64(a1, a2, a3) = aftercare(ccall((:OGR_F_SetFieldInteger64, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Clonglong), a1, a2, a3))
OGR_F_SetFieldDouble(a1, a2, a3) = aftercare(ccall((:OGR_F_SetFieldDouble, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Cdouble), a1, a2, a3))
OGR_F_SetFieldString(a1, a2, a3) = aftercare(ccall((:OGR_F_SetFieldString, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Cstring), a1, a2, a3))
function OGR_F_SetFieldIntegerList(a1, a2, a3, a4)
	aftercare(ccall((:OGR_F_SetFieldIntegerList, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Cint, Ptr{Cint}), a1, a2, a3, a4))
end
function OGR_F_SetFieldInteger64List(a1, a2, a3, a4)
	aftercare(ccall((:OGR_F_SetFieldInteger64List, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Cint, Ptr{Clonglong}), a1, a2, a3, a4))
end
function OGR_F_SetFieldDoubleList(a1, a2, a3, a4)
	aftercare(ccall((:OGR_F_SetFieldDoubleList, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Cint, Ptr{Cdouble}), a1, a2, a3, a4))
end
function OGR_F_SetFieldStringList(a1, a2, a3)
	aftercare(ccall((:OGR_F_SetFieldStringList, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Ptr{Cstring}), a1, a2, a3))
end
function OGR_F_SetFieldBinary(a1, a2, a3, a4)
	aftercare(ccall((:OGR_F_SetFieldBinary, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Cint, Ptr{Cvoid}), a1, a2, a3, a4))
end
function OGR_F_SetFieldDateTime(a1, a2, a3, a4, a5, a6, a7, a8, a9)
	aftercare(ccall((:OGR_F_SetFieldDateTime, libgdal), Cvoid, (Ptr{Cvoid}, Cint, Cint, Cint, Cint, Cint, Cint, Cint, Cint), a1, a2, a3, a4, a5, a6, a7, a8, a9))
end

function GDALDatasetCreateLayer(a1, a2, a3, a4, a5)
	aftercare(ccall((:GDALDatasetCreateLayer, libgdal), Ptr{Cvoid}, (Ptr{Cvoid}, Cstring, Ptr{Cvoid}, UInt32, Ptr{Cstring}), a1, a2, a3, a4, a5))
end

function GDALInfoOptionsNew(pArgv, psOFB)
	aftercare(ccall((:GDALInfoOptionsNew, libgdal), Ptr{Cvoid}, (Ptr{Cstring}, Ptr{Cvoid}), pArgv, psOFB))
end

GDALInfoOptionsFree(psO) = aftercare(ccall((:GDALInfoOptionsFree, libgdal), Cvoid, (Ptr{Cvoid},), psO))
GDALInfo(hDataset, psO) = aftercare(ccall((:GDALInfo, libgdal), Cstring, (Ptr{Cvoid}, Ptr{Cvoid}), hDataset, psO), true)

function GDALTranslateOptionsNew(pArgv, psOFB)
	aftercare(ccall((:GDALTranslateOptionsNew, libgdal), Ptr{Cvoid}, (Ptr{Cstring}, Ptr{Cvoid}), pArgv, psOFB))
end

function GDALTranslate(pszDestFilename, hSrcDataset, psOptions, pbUsageError)
	aftercare(ccall((:GDALTranslate, libgdal), Ptr{Cvoid}, (Cstring, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}), pszDestFilename, hSrcDataset, psOptions, pbUsageError))
end

GDALTranslateOptionsFree(psO) = aftercare(ccall((:GDALTranslateOptionsFree, libgdal), Cvoid, (Ptr{Cvoid},), psO))

function GDALDEMProcessingOptionsNew(pArgv, psOFB)
	aftercare(ccall((:GDALDEMProcessingOptionsNew, libgdal), Ptr{Cvoid}, (Ptr{Cstring}, Ptr{Cvoid}), pArgv, psOFB))
end

function GDALDEMProcessingOptionsFree(psO)
	aftercare(ccall((:GDALDEMProcessingOptionsFree, libgdal), Cvoid, (Ptr{Cvoid},), psO))
end

function GDALDEMProcessing(pszDestFilename, hSrcDataset, pszProcessing, pszColorFilename, psOptions, pbUE)
	aftercare(ccall((:GDALDEMProcessing, libgdal), Ptr{Cvoid}, (Cstring, Ptr{Cvoid}, Cstring, Cstring, Ptr{Cvoid}, Ptr{Cint}), pszDestFilename, hSrcDataset, pszProcessing, pszColorFilename, psOptions, pbUE))
end

function GDALGridOptionsNew(pArgv, psOFB)
	aftercare(ccall((:GDALGridOptionsNew, libgdal), Ptr{Cvoid}, (Ptr{Cstring}, Ptr{Cvoid}), pArgv, psOFB))
end

GDALGridOptionsFree(psO) = aftercare(ccall((:GDALGridOptionsFree, libgdal), Cvoid, (Ptr{Cvoid},), psO))

function GDALGrid(pDest, hSrcDS, psO, pbUE)
	aftercare(ccall((:GDALGrid, libgdal), Ptr{Cvoid}, (Cstring, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}), pDest, hSrcDS, psO, pbUE))
end

function GDALVectorTranslateOptionsNew(pArgv, psOFB)
	aftercare(ccall((:GDALVectorTranslateOptionsNew, libgdal), Ptr{Cvoid}, (Ptr{Cstring}, Ptr{Cvoid}), pArgv, psOFB))
end

function GDALVectorTranslateOptionsFree(psO)
	aftercare(ccall((:GDALVectorTranslateOptionsFree, libgdal), Cvoid, (Ptr{Cvoid},), psO))
end

function GDALVectorTranslate(pszDest, hDstDS, nSrcCount, pahSrcDS, psO, pbUE)
	aftercare(ccall((:GDALVectorTranslate, libgdal), Ptr{Cvoid}, (Cstring, Ptr{Cvoid}, Cint, Ptr{Ptr{Cvoid}}, Ptr{Cvoid}, Ptr{Cint}), pszDest, hDstDS, nSrcCount, pahSrcDS, psO, pbUE))
end

function GDALWarp(pszDest, hDstDS, nSrcCount, pahSrcDS, psO, pbUE)
	aftercare(ccall((:GDALWarp, libgdal), Ptr{Cvoid}, (Cstring, Ptr{Cvoid}, Cint, Ptr{Ptr{Cvoid}}, Ptr{Cvoid}, Ptr{Cint}), pszDest, hDstDS, nSrcCount, pahSrcDS, psO, pbUE))
end

GDALWarpAppOptionsFree(psO) = aftercare(ccall((:GDALWarpAppOptionsFree, libgdal), Cvoid, (Ptr{Cvoid},), psO))

function GDALWarpAppOptionsNew(pArgv, psOFB)
	aftercare(ccall((:GDALWarpAppOptionsNew, libgdal), Ptr{Cvoid}, (Ptr{Cstring}, Ptr{Cvoid}), pArgv, psOFB))
end

# ------------------------------------------- ArchGDAL stuff ----------------------------------------------------------

abstract type AbstractDataset end			# needs to have a `ptr::GDALDataset` attribute
abstract type AbstractSpatialRef end		# needs to have a `ptr::GDALSpatialRef` attribute
#abstract type AbstractRasterBand{T} <: AbstractDiskArray{T,2} end # needs to have a `ptr::GDALDataset` attribute
abstract type AbstractRasterBand{T} end		# needs to have a `ptr::GDALDataset` attribute
#abstract type AbstractGeometry <: GeoInterface.AbstractGeometry end	# needs to have a `ptr::GDALGeometry` attribute
abstract type AbstractGeometry  end			# needs to have a `ptr::GDALGeometry` attribute
abstract type AbstractFeatureDefn end		# needs to have a `ptr::GDALFeatureDefn` attribute
abstract type AbstractFeatureLayer end		# needs to have a `ptr::GDALDataset` attribute
abstract type AbstractFieldDefn end			# needs to have a `ptr::GDALFieldDefn` attribute
abstract type AbstractGeomFieldDefn end		# needs to have a `ptr::GDALGeomFieldDefn` attribute

	mutable struct CoordTransform
		ptr::Ptr{Cvoid}
	end

	mutable struct Dataset <: AbstractDataset
		ptr::Ptr{Cvoid}
		Dataset(ptr::Ptr{Cvoid}=C_NULL) = new(ptr)
	end

	mutable struct IDataset <: AbstractDataset
		ptr::Ptr{Cvoid}
		function IDataset(ptr::Ptr{Cvoid}=C_NULL)
			dataset = new(ptr)
			finalizer(destroy, dataset)
			return dataset
		end
	end

	mutable struct Driver
		ptr::Ptr{Cvoid}
	end

	mutable struct FieldDefn <: AbstractFieldDefn
		ptr::Ptr{Cvoid}
	end

	mutable struct IFieldDefnView <: AbstractFieldDefn
		ptr::Ptr{Cvoid}
		function IFieldDefnView(ptr::Ptr{Cvoid} = C_NULL)
			fielddefn = new(ptr)
			finalizer(destroy, fielddefn)
			return fielddefn
		end
	end

	mutable struct RasterBand{T} <: AbstractRasterBand{T}
		ptr::Ptr{Cvoid}
	end
	function RasterBand(ptr::Ptr{Cvoid})
		t = _JLTYPE[GDALGetRasterDataType(ptr)]
		RasterBand{t}(ptr)
	end

	mutable struct IRasterBand{T} <: AbstractRasterBand{T}
		ptr::Ptr{Cvoid}
		ownedby::AbstractDataset
		function IRasterBand{T}(ptr::Ptr{Cvoid}=C_NULL; ownedby::AbstractDataset=Dataset()) where T
			rasterband = new(ptr, ownedby)
			finalizer(destroy, rasterband)
			return rasterband
		end
	end

	function IRasterBand(ptr::Ptr{Cvoid}; ownedby = Dataset())
		t = _JLTYPE[GDALGetRasterDataType(ptr)]
		IRasterBand{t}(ptr, ownedby=ownedby)
	end

	mutable struct SpatialRef <: AbstractSpatialRef
		ptr::Ptr{Cvoid}
		SpatialRef(ptr::Ptr{Cvoid} = C_NULL) = new(ptr)
	end

	mutable struct ISpatialRef <: AbstractSpatialRef
		ptr::Ptr{Cvoid}
		function ISpatialRef(ptr::Ptr{Cvoid}=C_NULL)
			spref = new(ptr)
			finalizer(destroy, spref)
			return spref
		end
	end

	mutable struct Geometry <: AbstractGeometry
		ptr::Ptr{Cvoid}
		Geometry(ptr::Ptr{Cvoid} = C_NULL) = new(ptr)
	end
	
	mutable struct IGeometry <: AbstractGeometry
		ptr::Ptr{Cvoid}
		function IGeometry(ptr::Ptr{Cvoid} = C_NULL)
			geom = new(ptr)
			finalizer(destroy, geom)
			return geom
		end
	end

	mutable struct FeatureLayer <: AbstractFeatureLayer
		ptr::Ptr{Cvoid}
	end

	mutable struct IFeatureLayer <: AbstractFeatureLayer
		ptr::Ptr{Cvoid}
		ownedby::AbstractDataset
		spatialref::AbstractSpatialRef
		function IFeatureLayer(ptr::Ptr{Cvoid}=C_NULL; ownedby::AbstractDataset=Dataset(),
				spatialref::AbstractSpatialRef=SpatialRef())
			layer = new(ptr, ownedby, spatialref)
			finalizer(destroy, layer)
			return layer
		end
	end

	mutable struct Feature
		ptr::Ptr{Cvoid}
	end
	
	mutable struct FeatureDefn <: AbstractFeatureDefn
		ptr::Ptr{Cvoid}
	end
	
	mutable struct IFeatureDefnView <: AbstractFeatureDefn
		ptr::Ptr{Cvoid}
		function IFeatureDefnView(ptr::Ptr{Cvoid} = C_NULL)
			featuredefn = new(ptr)
			finalizer(destroy, featuredefn)
			return featuredefn
		end
	end

	mutable struct IGeomFieldDefnView <: AbstractGeomFieldDefn
		ptr::Ptr{Cvoid}
		function IGeomFieldDefnView(ptr::Ptr{Cvoid} = C_NULL)
			geomdefn = new(ptr)
			finalizer(destroy, geomdefn)
			return geomdefn
		end
	end

	mutable struct GeomFieldDefn <: AbstractGeomFieldDefn
		ptr::Ptr{Cvoid}
		spatialref::AbstractSpatialRef
		function GeomFieldDefn(ptr::Ptr{Cvoid}=C_NULL; spatialref::AbstractSpatialRef = SpatialRef())
			return new(ptr, spatialref)
		end
	end

	mutable struct ColorTable ptr::Ptr{Cvoid} end

	mutable struct DriverManager
		function DriverManager()
			drivermanager = new()
			GDALAllRegister()
			finalizer((dm,) -> GDALDestroyDriverManager(), drivermanager)
			return drivermanager
		end
	end

	const _GDALTYPE = Dict{DataType, Int32}(
		Any     => GDT_Unknown,
		UInt8   => GDT_Byte,
		UInt16  => GDT_UInt16,
		Int16   => GDT_Int16,
		UInt32  => GDT_UInt32,
		Int32   => GDT_Int32,
		Float32 => GDT_Float32,
		Float64 => GDT_Float64)

	const _JLTYPE = Dict{Int32, DataType}(
		GDT_Unknown    => Any,
		GDT_Byte       => UInt8,
		GDT_UInt16     => UInt16,
		GDT_Int16      => Int16,
		GDT_UInt32     => UInt32,
		GDT_Int32      => Int32,
		GDT_Float32    => Float32,
		GDT_Float64    => Float64)

	macro gdal(args...)
		@assert length(args) > 0
		@assert args[1].head == :(::)
		fhead = (args[1].args[1], libgdal)
		returntype = args[1].args[2]
		argtypes = Expr(:tuple, [esc(a.args[2]) for a in args[2:end]]...)
		args = [esc(a.args[1]) for a in args[2:end]]
		return quote ccall($fhead, $returntype, $argtypes, $(args...)) end
	end

	macro cplerr(code, message)
		return quote
			($(esc(code)) != CE_None) && error($message)
		end
	end

	macro cplwarn(code, message)
		return quote
			if $(esc(code)) != GDAL.CE_None
				@warn $message
			end
		end
	end

	macro cplprogress(progressfunc)
		@cfunction($(esc(progressfunc)),Cint,(Cdouble,Cstring,Ptr{Cvoid}))
	end

	macro ogrerr(code, message)
		return quote
			($(esc(code)) != OGRERR_NONE) && error($message)
		end
	end

	struct RasterDataset{T,DS}
		ds::DS
		size::Tuple{Int,Int,Int}
	end

	RasterDataset(ds::RasterDataset) = RasterDataset(ds.ds)

	function RasterDataset(ds::AbstractDataset)
		iszero(nraster(ds)) && throw(ArgumentError("The Dataset does not contain any raster bands"))
		s = _common_size(ds)
		RasterDataset{_dataset_type(ds), typeof(ds)}(ds, s)
	end

	# Forward a few functions
	# Here we try to include all functions that are relevant for raster-like datasets.
	for f in (:getgeotransform, :nraster, :getband, :getproj,
		:width, :height, :destroy, :getdriver, :filelist, :listcapability, 
		:ngcp, :copy, :write, :testcapability, :setproj!, :buildoverviews!)
		eval(:($(f)(x::RasterDataset, args...; kwargs...) = $(f)(x.ds, args...; kwargs...)))
	end

	function getgeotransform!(dataset::AbstractDataset, transform::Vector{Cdouble})
		@assert length(transform) == 6
		result = GDALGetGeoTransform(dataset.ptr, pointer(transform))
		@cplerr result "Failed to get geotransform"
		return transform
	end
	getgeotransform(dataset::AbstractDataset) = getgeotransform!(dataset, Array{Cdouble}(undef, 6))
	
	function setgeotransform!(dataset::AbstractDataset, transform::Vector{Cdouble})
		@assert length(transform) == 6
		result = GDALSetGeoTransform(dataset.ptr, pointer(transform))
		@cplerr result "Failed to transform raster dataset"
		return dataset
	end

	function setproj!(dataset::AbstractDataset, projstring::AbstractString)
		result = GDALSetProjection(dataset.ptr, projstring)
		@cplerr result "Could not set projection"
		return dataset
	end

	function createlayer(; name::AbstractString="", dataset::AbstractDataset=create(getdriver("Memory")),
		geom::UInt32=wkbUnknown, spatialref::AbstractSpatialRef=SpatialRef(), options=Ptr{Cstring}(C_NULL))
		return IFeatureLayer(GDALDatasetCreateLayer(dataset.ptr, name, spatialref.ptr, geom, options),
							 ownedby=dataset, spatialref=spatialref)
	end
	#= function unsafe_createlayer(; name::AbstractString="", dataset::AbstractDataset=create(getdriver("Memory")),
		geom::UInt32=wkbUnknown, spatialref::AbstractSpatialRef=SpatialRef(), options=Ptr{Cstring}(C_NULL))
	return FeatureLayer(GDAL.gdaldatasetcreatelayer(dataset.ptr, name, spatialref.ptr, geom, options))
	end =#

	unsafe_createfielddefn(name::AbstractString, etype::UInt32) = FieldDefn(OGR_Fld_Create(name, etype))

	function addfielddefn!(layer::AbstractFeatureLayer, name::AbstractString, etype::UInt32; nwidth::Integer=0,
						   nprecision::Integer=0, justify::UInt32=UInt32(0), approx::Bool=false)
		fielddefn = unsafe_createfielddefn(name, etype)
		setparams!(fielddefn, name, etype, nwidth=nwidth, nprecision=nprecision, justify=justify)
		addfielddefn!(layer, fielddefn)
		destroy(fielddefn)
		layer
	end

	function addfielddefn!(featuredefn::FeatureDefn, fielddefn::FieldDefn)
		OGR_FD_AddFieldDefn(featuredefn.ptr, fielddefn.ptr)
		return featuredefn
	end

	function addfielddefn!(layer::AbstractFeatureLayer, field::AbstractFieldDefn, approx::Bool=false)
		result = OGR_L_CreateField(layer.ptr, field.ptr, approx)
		@ogrerr result "Failed to create new field"
		return layer
	end

	function createfeature(f::Function, featuredefn::FeatureDefn)
		feature = unsafe_createfeature(featuredefn)
		reference(featuredefn)
		try
			f(feature)
		finally
			destroy(feature)
			dereference(featuredefn)
		end
	end

	unsafe_createfeature(layer::AbstractFeatureLayer) = unsafe_createfeature(layerdefn(layer))
	unsafe_createfeature(featuredefn::AbstractFeatureDefn) = Feature(Ptr{Cvoid}(OGR_F_Create(featuredefn.ptr)))

	function createfeature(f::Function, layer::AbstractFeatureLayer)
		feature = unsafe_createfeature(layer)
		try
			f(feature)
			setfeature!(layer, feature)
		finally
			destroy(feature)
		end
	end

	function setfeature!(layer::AbstractFeatureLayer, feature::Feature)
		result = OGR_L_SetFeature(layer.ptr, feature.ptr)
		@ogrerr result "Failed to set feature."
		return layer
	end

	function addfeature!(layer::AbstractFeatureLayer, feature::Feature)
		result = OGR_L_CreateFeature(layer.ptr, feature.ptr)
		@ogrerr result "Failed to create and write feature in layer."
		return layer
	end

	function setparams!(fielddefn::FieldDefn, name::AbstractString, etype::UInt32;
						nwidth::Integer=0, nprecision::Integer=0, justify::UInt32=UInt32(0))
		OGR_Fld_Set(fielddefn.ptr, name, etype, nwidth, nprecision, justify)
		return fielddefn
	end

	function setpoint!(geom::AbstractGeometry, i::Integer, x::Real, y::Real, z::Real)
		OGR_G_SetPoint(geom.ptr, i, x, y, z);	return geom
	end

	function setpoint!(geom::AbstractGeometry, i::Integer, x::Real, y::Real)
		OGR_G_SetPoint_2D(geom.ptr, i, x, y);	return geom
	end

	function _dataset_type(ds::AbstractDataset)
		alldatatypes = map(1:nraster(ds)) do i
			b = getband(ds, i)
			pixeltype(b)
		end
		reduce(promote_type, alldatatypes)
	end

	function _common_size(ds::AbstractDataset)
		nr = nraster(ds)
		allsizes = map(1:nr) do i
			b = getband(ds, i)
			size(b)
		end
		s = unique(allsizes)
		length(s) == 1 || throw(DimensionMismatch("Can not coerce bands to single dataset, different sizes found"))
		Int.((s[1]..., nr))
	end

	function destroy(drv::Driver)
		GDALDestroyDriver(drv.ptr);	drv.ptr = C_NULL
	end

	function destroy(dataset::AbstractDataset)
		GDALClose(dataset.ptr);		dataset.ptr = C_NULL
	end

	function destroy(spref::AbstractSpatialRef)
		OSRDestroySpatialReference(spref.ptr)
		spref.ptr = C_NULL
	end
	
	function destroy(obj::CoordTransform)
		OCTDestroyCoordinateTransformation(obj.ptr)
		obj.ptr = C_NULL
	end

	function destroy(band::AbstractRasterBand)
		band.ptr = Ptr{Cvoid}(C_NULL)
		return band
	end

	function destroy(band::IRasterBand)
		band.ptr = Ptr{Cvoid}(C_NULL)
		band.ownedby = Dataset()
		return band
	end

	function destroy(layer::AbstractFeatureLayer)
		layer.ptr = Ptr{Cvoid}(C_NULL)
	end
	
	function destroy(layer::IFeatureLayer)
		layer.ptr = Ptr{Cvoid}(C_NULL)
		layer.ownedby = Dataset()
		layer.spatialref = SpatialRef()
	end

	function destroy(featuredefn::IFeatureDefnView)
		featuredefn.ptr = C_NULL
		return featuredefn
	end

	function destroy(feature::Feature)
		OGR_F_Destroy(feature.ptr)
		feature.ptr = C_NULL
	end

	function destroy(featuredefn::FeatureDefn)
		OGR_FD_Destroy(featuredefn.ptr)
		featuredefn.ptr = C_NULL
		return featuredefn
	end

	function destroy(geom::AbstractGeometry)
		OGR_G_DestroyGeometry(geom.ptr)
		geom.ptr = C_NULL
	end

	function destroy(fielddefn::FieldDefn)
		OGR_Fld_Destroy(fielddefn.ptr)
		fielddefn.ptr = C_NULL
		return fielddefn
	end

	function destroy(geomdefn::GeomFieldDefn)
		OGR_GFld_Destroy(geomdefn.ptr)
		geomdefn.ptr = C_NULL
		geomdefn.spatialref = SpatialRef()
		return geomdefn
	end

	function destroy(fielddefn::IFieldDefnView)
		fielddefn.ptr = C_NULL
		return fielddefn
	end	

	function destroy(geomdefn::IGeomFieldDefnView)
		geomdefn.ptr = C_NULL
		return geomdefn
	end

	function create(fname::AbstractString; driver::Driver=identifydriver(fname), width::Integer=0,
		height::Integer=0, nbands::Integer=0, dtype::DataType=Any, options=Ptr{Cstring}(C_NULL), I::Bool=true)
		r = GDALCreate(driver.ptr, fname, width, height, nbands, _GDALTYPE[dtype], options)
		return (I) ? IDataset(r) : Dataset(r)
	end
	unsafe_create(fname::AbstractString; driver::Driver=identifydriver(fname), width::Integer=0,
		height::Integer=0, nbands::Integer=0, dtype::DataType=Any, options=Ptr{Cstring}(C_NULL), I::Bool=false) =
		create(fname; driver=driver, width=width, height=height, nbands=nbands, dtype=dtype, options=options, I=I)

	function create(driver::Driver; fname::AbstractString=string("/vsimem/$(gensym())"), width::Integer=0,
		height::Integer=0, nbands::Integer=0, dtype::DataType=Any, options=Ptr{Cstring}(C_NULL), I::Bool=true)
		r = GDALCreate(driver.ptr, fname, width, height, nbands, _GDALTYPE[dtype], options)
		return (I) ? IDataset(r) : Dataset(r)
	end
	unsafe_create(driver::Driver; fname::AbstractString=string("/vsimem/$(gensym())"), width::Integer=0,
		height::Integer=0, nbands::Integer=0, dtype::DataType=Any, options=Ptr{Cstring}(C_NULL), I::Bool=false) =
		create(driver; fname=fname, width=width, height=height, nbands=nbands, dtype=dtype, options=options, I=I)

	function read(filename::AbstractString; flags = GDAL_OF_READONLY | GDAL_OF_VERBOSE_ERROR,
		alloweddrivers=Ptr{Cstring}(C_NULL), options=Ptr{Cstring}(C_NULL), siblingfiles=Ptr{Cstring}(C_NULL), I::Bool=true)
		r = GDALOpenEx(filename, Int(flags), alloweddrivers, options, siblingfiles)
		return (I) ? IDataset(r) : Dataset(r)
	end
	unsafe_read(fname::AbstractString; flags=GDAL_OF_READONLY | GDAL_OF_VERBOSE_ERROR, alloweddrivers=Ptr{Cstring}(C_NULL),
		options=Ptr{Cstring}(C_NULL), siblingfiles=Ptr{Cstring}(C_NULL), I::Bool=false) =
		read(fname; flags=flags, alloweddrivers=alloweddrivers, options=options, siblingfiles=siblingfiles, I=I)

	read!(rb::AbstractRasterBand, buffer::Matrix{<:Real}) = rasterio!(rb, buffer, GF_Read)

	function read!(rb::AbstractRasterBand, buffer::Matrix{<:Real}, xoffset::Integer, yoffset::Integer,
			xsize::Integer, ysize::Integer)
		rasterio!(rb, buffer, xoffset, yoffset, xsize, ysize)
		return buffer
	end

	function read!(rb::AbstractRasterBand, buffer::Matrix{<:Real}, rows::UnitRange{<:Integer}, cols::UnitRange{<:Integer})
		rasterio!(rb, buffer, rows, cols);		return buffer
	end

	read(rb::AbstractRasterBand) = rasterio!(rb, Array{pixeltype(rb)}(undef, width(rb), height(rb)))

	function read(rb::AbstractRasterBand, xoffset::Integer, yoffset::Integer, xsize::Integer, ysize::Integer)
		buffer = Array{pixeltype(rb)}(undef, xsize, ysize)
		rasterio!(rb, buffer, xoffset, yoffset, xsize, ysize);		return buffer
	end

	function read(rb::AbstractRasterBand, rows::UnitRange{<:Integer}, cols::UnitRange{<:Integer})
		buffer = Array{pixeltype(rb)}(undef, length(cols), length(rows))
		rasterio!(rb, buffer, rows, cols);		return buffer
	end

	function read!(dataset::AbstractDataset, buffer::Matrix{<:Real}, i::Integer)
		read!(getband(dataset, i), buffer);		return buffer
	end
	
	function read!(dataset::AbstractDataset, buffer::Array{<:Real, 3}, indices)
		rasterio!(dataset, buffer, indices, GF_Read);	return buffer
	end
	
	function read!(dataset::AbstractDataset, buffer::Array{<:Real, 3})
		nband = nraster(dataset)
		@assert size(buffer, 3) == nband
		rasterio!(dataset, buffer, collect(Cint, 1:nband), GF_Read)
		return buffer
	end
	#read!(ds::IDataset, buffer::Array{<:Real, 3}) = read!(Dataset(ds.ptr), buffer)
	
	function read!(dataset::AbstractDataset, buffer::Matrix{<:Real}, i::Integer, xoffset::Integer,
			yoffset::Integer, xsize::Integer, ysize::Integer)
		read!(getband(dataset, i), buffer, xoffset, yoffset, xsize, ysize)
		return buffer
	end
	
	function read!(dataset::AbstractDataset, buffer::Array{<:Real, 3}, indices, xoffset::Integer,
			yoffset::Integer, xsize::Integer, ysize::Integer)
		rasterio!(dataset, buffer, indices, xoffset, yoffset, xsize, ysize)
		return buffer
	end
	
	function read!(dataset::AbstractDataset, buffer::Matrix{<:Real}, i::Integer,
			rows::UnitRange{<:Integer}, cols::UnitRange{<:Integer})
		read!(getband(dataset, i), buffer, rows, cols)
		return buffer
	end
	
	function read!(dataset::AbstractDataset, buffer::Array{<:Real, 3}, indices,
			rows::UnitRange{<:Integer}, cols::UnitRange{<:Integer})
		rasterio!(dataset, buffer, indices, rows, cols);	return buffer
	end
	
	read(dataset::AbstractDataset, i::Integer) = read(getband(dataset, i))
	
	function read(dataset::AbstractDataset, indices)
		buffer = Array{pixeltype(getband(dataset, indices[1]))}(undef, width(dataset), height(dataset), length(indices))
		rasterio!(dataset, buffer, indices);		return buffer
	end
	
	function read(dataset::AbstractDataset)
		buffer = Array{pixeltype(getband(dataset, 1))}(undef, width(dataset), height(dataset), nraster(dataset))
		read!(dataset, buffer);		return buffer
	end
	read(dataset::RasterDataset) = read(dataset.ds)
	
	function read(dataset::AbstractDataset, i::Integer, xoffset::Integer, yoffset::Integer, xsize::Integer, ysize::Integer)
		buffer = read(getband(dataset, i), xoffset, yoffset, xsize, ysize)
		return buffer
	end
	
	function read(dataset::AbstractDataset, indices, xoffset::Integer, yoffset::Integer, xsize::Integer, ysize::Integer)
		buffer = Array{pixeltype(getband(dataset, indices[1]))}(undef, xsize, ysize, length(indices))
		rasterio!(dataset, buffer, indices, xsize, ysize, xoffset, yoffset)
		return buffer
	end
	
	function read(dataset::AbstractDataset, i::Integer, rows::UnitRange{<:Integer}, cols::UnitRange{<:Integer})
		buffer = read(getband(dataset, i), rows, cols);		return buffer
	end
	
	function read(dataset::AbstractDataset, indices, rows::UnitRange{<:Integer}, cols::UnitRange{<:Integer})
		buffer = Array{pixeltype(getband(dataset, indices[1]))}(undef, length(cols), length(rows), length(indices))
		rasterio!(dataset, buffer, indices, rows, cols);	return buffer
	end

	function rasterio!(dataset::AbstractDataset, buffer::Array{<:Real, 3}, bands, access::UInt32=GF_Read,
		pxspace::Integer=0, linespace::Integer=0, bandspace::Integer=0)
		rasterio!(dataset, buffer, bands, 0, 0, size(buffer, 1), size(buffer, 2), access, pxspace, linespace, bandspace)
		return buffer
	end

	function rasterio!(dataset::AbstractDataset, buffer::Array{<:Real, 3}, bands, rows::UnitRange{<:Integer},
			cols::UnitRange{<:Integer}, access::UInt32=GF_Read, pxspace::Integer=0, linespace::Integer=0, bandspace::Integer=0)
		xsize = cols[end] - cols[1] + 1; xsize < 0 && error("invalid window width")
		ysize = rows[end] - rows[1] + 1; ysize < 0 && error("invalid window height")
		rasterio!(dataset, buffer, bands, cols[1], rows[1], xsize, ysize, access, pxspace, linespace, bandspace)
		return buffer
	end

	function rasterio!(rasterband::AbstractRasterBand, buffer::Matrix{<:Real}, access::UInt32=GF_Read,
			pxspace::Integer=0, linespace::Integer=0)
		rasterio!(rasterband, buffer, 0, 0, width(rasterband), height(rasterband), access, pxspace, linespace)
		return buffer
	end

	function rasterio!(rasterband::AbstractRasterBand, buffer::Matrix{<:Real}, rows::UnitRange{<:Integer},
			cols::UnitRange{<:Integer}, access::UInt32=GF_Read, pxspace::Integer=0, linespace::Integer=0)
		xsize = length(cols); xsize < 1 && error("invalid window width")
		ysize = length(rows); ysize < 1 && error("invalid window height")
		rasterio!(rasterband, buffer, cols[1]-1, rows[1]-1, xsize, ysize, access, pxspace, linespace)
		return buffer
	end

	for (T,GT) in _GDALTYPE
		eval(quote
			function rasterio!(dataset::AbstractDataset, buffer::Array{$T, 3}, bands, xoffset::Integer, yoffset::Integer,
					xsize::Integer, ysize::Integer, access::UInt32=GF_Read, pxspace::Integer=0, linespace::Integer=0,
					bandspace::Integer=0, extraargs=Ptr{GDALRasterIOExtraArg}(C_NULL), pad::Int=0)
				(dataset == C_NULL) && error("Can't read invalid rasterband")
				xbsize, ybsize, zbsize = size(buffer)
				nband = length(bands)
				bands = isa(bands, Vector{Cint}) ? bands : Cint.(collect(bands))
				@assert nband == zbsize
				poffset = 0
				if (pad != 0)
					linespace = xbsize * sizeof($T)
					poffset = (pad * xbsize + pad) * sizeof($T)
					xbsize, ybsize = xsize, ysize
				end
				result = ccall((:GDALDatasetRasterIOEx,libgdal), UInt32, 
							   (Ptr{Cvoid}, UInt32, Cint, Cint, Cint, Cint, Ptr{Cvoid}, Cint, Cint, UInt32, Cint,
							   Ptr{Cint}, Clonglong, Clonglong, Clonglong, Ptr{GDALRasterIOExtraArg}),
							   dataset.ptr, access, xoffset, yoffset, xsize, ysize, pointer(buffer)+poffset, xbsize,
							   ybsize, $GT, nband, pointer(bands), pxspace, linespace, bandspace, extraargs)
				@cplerr result "Access in DatasetRasterIO failed."
				return buffer
			end

			function rasterio!(rasterband::AbstractRasterBand, buffer::Matrix{$T}, xoffset::Integer, yoffset::Integer,
					xsize::Integer, ysize::Integer, access::UInt32=GF_Read, pxspace::Integer=0,
					linespace::Integer=0, extraargs=Ptr{GDALRasterIOExtraArg}(C_NULL), pad::Int=0)
				(rasterband == C_NULL) && error("Can't read invalid rasterband")
				xbsize, ybsize = size(buffer)
				poffset = 0
				if (pad != 0)
					linespace = xbsize * sizeof($T)
					poffset = (pad * xbsize + pad) * sizeof($T)
					xbsize, ybsize = xsize, ysize
				end
				result = ccall((:GDALRasterIOEx,libgdal),UInt32,
					(Ptr{Cvoid},UInt32,Cint,Cint,Cint,Cint,Ptr{Cvoid}, Cint,Cint,UInt32,Clonglong, Clonglong,
					Ptr{GDALRasterIOExtraArg}),
					rasterband.ptr,access,xoffset, yoffset,xsize,ysize,pointer(buffer)+poffset,xbsize,ybsize,$GT,
					pxspace, linespace, extraargs)
				@cplerr result "Access in RasterIO failed."
				return buffer
			end
		end)
	end

	function write!(rb::AbstractRasterBand, buffer::Matrix{<:Real})
		rasterio!(rb, buffer, GF_Write)
		return buffer
	end

	function write!(rb::AbstractRasterBand, buffer::Matrix{<:Real}, xoffset::Integer, yoffset::Integer,
		xsize::Integer, ysize::Integer)
		rasterio!(rb, buffer, xoffset, yoffset, xsize, ysize, GF_Write)
		return buffer
	end

	function write!(rb::AbstractRasterBand, buffer::Matrix{<:Real}, rows::UnitRange{<:Integer}, cols::UnitRange{<:Integer})
		rasterio!(rb, buffer, rows, cols, GF_Write)
		return buffer
	end

	function write!(dataset::AbstractDataset, buffer::Matrix{<:Real}, i::Integer)
		write!(getband(dataset, i), buffer)
		return dataset
	end
	
	function write!(dataset::AbstractDataset, buffer::Array{<:Real, 3}, indices)
		rasterio!(dataset, buffer, indices, GF_Write)
		return dataset
	end
	
	function write!(dataset::AbstractDataset, buffer::Matrix{<:Real}, i::Integer, xoffset::Integer,
			yoffset::Integer, xsize::Integer, ysize::Integer)
		write!(getband(dataset, i), buffer, xoffset, yoffset, xsize, ysize)
		return dataset
	end
	
	function write!(dataset::AbstractDataset, buffer::Array{<:Real, 3}, indices, xoffset::Integer,
			yoffset::Integer, xsize::Integer, ysize::Integer)
		rasterio!(dataset, buffer, indices, xoffset, yoffset, xsize, ysize, GF_Write)
		return dataset
	end
	
	function write!(dataset::AbstractDataset, buffer::Matrix{<:Real}, i::Integer,
			rows::UnitRange{<:Integer}, cols::UnitRange{<:Integer})
		write!(getband(dataset, i), buffer, rows, cols)
		return dataset
	end
	
	function write!(dataset::AbstractDataset, buffer::Array{<:Real, 3}, indices,
			rows::UnitRange{<:Integer}, cols::UnitRange{<:Integer})
		rasterio!(dataset, buffer, indices, rows, cols, GF_Write)
		return dataset
	end

	write(ds::AbstractDataset, fname::AbstractString; kw...) = destroy(unsafe_copy(ds, filename=fname; kw...))

	function unsafe_copy(dataset::AbstractDataset; filename::AbstractString=string("/vsimem/$(gensym())"),
		driver::Driver=getdriver(dataset), strict::Bool=false, options=Ptr{Cstring}(C_NULL),
		progressfunc::Function=GDALDummyProgress, progressdata=C_NULL)
		return Dataset(GDALCreateCopy(driver.ptr, filename, dataset.ptr, strict, options,
		               @cplprogress(progressfunc), progressdata))
	end

	getdriver(dataset::AbstractDataset) = Driver(GDALGetDatasetDriver(dataset.ptr))
	getdriver(i::Integer) = Driver(GDALGetDriver(i))
	getdriver(name::AbstractString) = Driver(GDALGetDriverByName(name))

	getband(dataset::AbstractDataset, i::Integer=1) = IRasterBand(GDALGetRasterBand(dataset.ptr, i), ownedby=dataset)
	getband(ds::RasterDataset, i::Integer=1) = getband(ds.ds, i)
	getproj(dataset::AbstractDataset) = GDALGetProjectionRef(dataset.ptr)

	getpoint(geom::AbstractGeometry, i::Integer) = getpoint!(geom, i, Ref{Cdouble}(), Ref{Cdouble}(), Ref{Cdouble}())
	function getpoint!(geom::AbstractGeometry, i::Integer, x, y, z)
		OGR_G_GetPoint(geom.ptr, i, x, y, z)
		return (x[], y[], z[])
	end
	getx(geom::AbstractGeometry, i::Integer) = OGR_G_GetX(geom.ptr, i)
	gety(geom::AbstractGeometry, i::Integer) = GDAL.ogr_g_gety(geom.ptr, i)
	getz(geom::AbstractGeometry, i::Integer) = GDAL.ogr_g_getz(geom.ptr, i)
#=
function OGR_G_GetPoints(hGeom, pabyX, nXStride, pabyY, nYStride, pabyZ, nZStride)
	aftercare(ccall((:OGR_G_GetPoints, libgdal), Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Cint, Ptr{Cvoid}, Cint, Ptr{Cvoid}, Cint),
	                 hGeom, pabyX, nXStride, pabyY, nYStride, pabyZ, nZStride))
end

	getpoints(geom::AbstractGeometry) = getpoints!(geom, Ref{Cdouble}(), nx, Ref{Cdouble}(), nx, Ref{Cdouble}(), nz)
	function getpoints!(hGeom::Ptr{Ptr{Cvoid}}, x, nXStride::Integer, y, nYStride::Integer, z, nZStride::Integer)
		OGR_G_GetPoints(geom.ptr, x, nXstride, y, nYstride, z, nZstride)
		return (x[], y[], z[])
	end
=#

	#readraster(s::String; kwargs...) = RasterDataset(read(s; kwargs...))
	readraster(args...; kwargs...) = RasterDataset(unsafe_read(args...; kwargs...))

	shortname(drv::Driver) = GDALGetDriverShortName(drv.ptr)
	longname(drv::Driver) = GDALGetDriverLongName(drv.ptr)
	options(drv::Driver) = GDALGetDriverCreationOptionList(drv.ptr)
	driveroptions(name::AbstractString) = options(getdriver(name))

	function gdalwarp(datasets::Vector{Dataset}, options=String[]; dest = "/vsimem/tmp")
		options = GDALWarpAppOptionsNew(options, C_NULL)
		usage_error = Ref{Cint}()
		result = GDALWarp(dest, C_NULL, length(datasets), [ds.ptr for ds in datasets], options, usage_error)
		GDALWarpAppOptionsFree(options)
		return Dataset(result)
	end
	gdalwarp(ds::Dataset, opts=String[]; dest="/vsimem/tmp") = gdalwarp([ds], opts; dest=dest)
	gdalwarp(ds::IDataset, opts=String[]; dest="/vsimem/tmp") = gdalwarp([Dataset(ds.ptr)], opts; dest=dest)

	function gdaltranslate(dataset::Dataset, options = String[]; dest = "/vsimem/tmp")
		options = GDALTranslateOptionsNew(options, C_NULL)
		usage_error = Ref{Cint}()
		result = GDALTranslate(dest, dataset.ptr, options, usage_error)
		GDALTranslateOptionsFree(options)
		return Dataset(result)
	end
	gdaltranslate(ds::IDataset, opts=String[]; dest="/vsimem/tmp") = gdaltranslate(Dataset(ds.ptr), opts; dest=dest)

	function gdalinfo(ds::Dataset, options=String[])
		options = GDALInfoOptionsNew(options, C_NULL)
		result = GDALInfo(ds.ptr, options)
		GDALInfoOptionsFree(options)
		return result
	end
	gdalinfo(ds::IDataset, opts=String[]) = gdalinfo(Dataset(ds.ptr), opts)
	function gdalinfo(fname::AbstractString, opts=String[])
		CPLPushErrorHandler(@cfunction(CPLQuietErrorHandler, Cvoid, (UInt32, Cint, Cstring)))	# WTF is this needed?
		o = gdalinfo(unsafe_read(fname; options=opts), opts)
		CPLPopErrorHandler();
		return o
	end

	function gdaldem(dataset::Dataset, processing::String, options=String[]; dest="/vsimem/tmp", colorfile=C_NULL)
		if processing == "color-relief"
			@assert colorfile != C_NULL
		end
		options = GDALDEMProcessingOptionsNew(options, C_NULL)
		usage_error = Ref{Cint}()
		result = GDALDEMProcessing(dest, dataset.ptr, processing, colorfile, options, usage_error)
		GDALDEMProcessingOptionsFree(options)
		return Dataset(result)
	end
	gdaldem(ds::IDataset, processing::String, opts=String[]; dest="/vsimem/tmp", colorfile=C_NULL) = gdaldem(Dataset(ds.ptr), processing, opts; dest=dest, colorfile=colorfile)

	function gdalgrid(dataset::Dataset, options=String[]; dest="/vsimem/tmp")
		options = GDALGridOptionsNew(options, C_NULL)
		usage_error = Ref{Cint}()
		result = GDALGrid(dest, dataset.ptr, options, usage_error)
		GDALGridOptionsFree(options)
		return Dataset(result)
	end
	gdalgrid(ds::IDataset, opts=String[]; dest="/vsimem/tmp") = gdalgrid(Dataset(ds.ptr), opts; dest=dest)

	function gdalvectortranslate(datasets::Vector{Dataset}, options=String[]; dest="/vsimem/tmp")
		options = GDALVectorTranslateOptionsNew(options, C_NULL)
		usage_error = Ref{Cint}()
		result = GDALVectorTranslate(dest, C_NULL, length(datasets), [ds.ptr for ds in datasets], options, usage_error)
		GDALVectorTranslateOptionsFree(options)
		return Dataset(result)
	end
	gdalvectortranslate(ds::Dataset, opts=String[]; dest="/vsimem/tmp") = gdalvectortranslate([ds], opts; dest=dest)
	gdalvectortranslate(ds::IDataset, opts=String[]; dest="/vsimem/tmp") = gdalvectortranslate([Dataset(ds.ptr)], opts; dest=dest)

	function toWKT(spref::AbstractSpatialRef)
		wktptr = Ref{Cstring}()
		result = OSRExportToWkt(spref.ptr, wktptr)
		@ogrerr result "Failed to convert this SRS into WKT format"
		return unsafe_string(wktptr[])
	end

	function toWKT(spref::AbstractSpatialRef, simplify::Bool)
		wktptr = Ref{Cstring}()
		result = OSRExportToPrettyWkt(spref.ptr, wktptr, simplify)
		@ogrerr result "Failed to convert this SRS into pretty WKT"
		return unsafe_string(wktptr[])
	end

	function toWKT(geom::AbstractGeometry)
		wkt_ptr = Ref(Cstring(C_NULL))
		result = OGR_G_ExportToWkt(geom.ptr, wkt_ptr)
		@ogrerr result "OGRErr $result: failed to export geometry to WKT"
		wkt = unsafe_string(wkt_ptr[])
		VSIFree(pointer(wkt_ptr[]))
		return wkt
	end

	function toPROJ4(spref::AbstractSpatialRef)
		projptr = Ref{Cstring}()
		result = OSRExportToProj4(spref.ptr, projptr)
		@ogrerr result "Failed to export this SRS to PROJ.4 format"
		return unsafe_string(projptr[])
	end

	function importWKT!(spref::AbstractSpatialRef, wktstr::AbstractString)
		result = OSRImportFromWkt(spref.ptr, [wktstr])
		@ogrerr result "Failed to initialize SRS based on WKT string"
		return spref
	end
	importWKT(wktstr::AbstractString; kwargs...) = newspatialref(wktstr; kwargs...)

	function importEPSG!(spref::AbstractSpatialRef, code::Integer)
		result = OSRImportFromEPSG(spref.ptr, code)
		@ogrerr result "Failed to initialize SRS based on EPSG"
		return spref
	end
	importEPSG(code::Integer; kwargs...) = importEPSG!(newspatialref(; kwargs...), code)

	newspatialref(wkt::AbstractString = ""; order=:trad) = maybesetaxisorder!(ISpatialRef(OSRNewSpatialReference(wkt)), order)

	function importPROJ4!(spref::AbstractSpatialRef, projstr::AbstractString)
		result = OSRImportFromProj4(spref.ptr, projstr)
		@ogrerr result "Failed to initialize SRS based on PROJ4 string"
		return spref
	end
	importPROJ4(projstr::AbstractString; kwargs...) = importPROJ4!(newspatialref(; kwargs...), projstr)

	function maybesetaxisorder!(sr::AbstractSpatialRef, order)
		if order == :trad
			OSRSetAxisMappingStrategy(sr.ptr, OAMS_TRADITIONAL_GIS_ORDER)
		elseif order != :compliant
			throw(ArgumentError("order $order is not supported. Use :trad or :compliant"))
		end
		sr
	end

	getlayer(ds::AbstractDataset, i::Integer) = IFeatureLayer(GDALDatasetGetLayer(ds.ptr, i), ownedby=ds)
	function getlayer(ds::AbstractDataset, name::AbstractString)
		IFeatureLayer(GDALDatasetGetLayerByName(ds.ptr, name), ownedby = ds)
	end
	unsafe_getlayer(ds::AbstractDataset, i::Integer) = FeatureLayer(GDALDatasetGetLayer(ds.ptr, i))
	unsafe_getlayer(ds::AbstractDataset, name::AbstractString) = FeatureLayer(GDAL.GDALDatasetGetLayerByName(ds.ptr, name))

	width(band::AbstractRasterBand)    = GDALGetRasterBandXSize(band.ptr)
	width(dataset::AbstractDataset)    = GDALGetRasterXSize(dataset.ptr)
	height(band::AbstractRasterBand)   = GDALGetRasterBandYSize(band.ptr)
	height(dataset::AbstractDataset)   = GDALGetRasterYSize(dataset.ptr)
	nlayer(dataset::AbstractDataset)   = GDALDatasetGetLayerCount(dataset.ptr)
	nraster(dataset::AbstractDataset)  = GDALGetRasterCount(dataset.ptr)
	filelist(dataset::AbstractDataset) = GDALGetFileList(dataset.ptr)
	nfeature(layer::AbstractFeatureLayer, force::Bool = false) = OGR_L_GetFeatureCount(layer.ptr, force)

	getname(featuredefn::AbstractFeatureDefn) = OGR_FD_GetName(featuredefn.ptr)
	getname(layer::AbstractFeatureLayer)  = OGR_L_GetName(layer.ptr)
	getname(fielddefn::AbstractFieldDefn) = OGR_Fld_GetNameRef(fielddefn.ptr)
	getname(obj::UInt32) = GDALGetColorInterpretationName(obj)
	getname(geomdefn::AbstractGeomFieldDefn) = OGR_Fld_GetNameRef(geomdefn.ptr)
	#getname(obj::GDALPaletteInterp) = GDALGetPaletteInterpretationName(obj)
	#getname(obj::OGRFieldType)      = OGR_GetFieldTypeName(obj)
	#getname(obj::OGRFieldSubType)   = OGR_GetFieldSubTypeName(obj)

	getgeomtype(featuredefn::AbstractFeatureDefn) = OGR_FD_GetGeomType(featuredefn.ptr)
	getgeomtype(layer::AbstractFeatureLayer) = OGR_L_GetGeomType(layer.ptr)
	getgeomtype(geom::AbstractGeometry)  = OGR_G_GetGeometryType(geom.ptr)

	gettype(name::AbstractString) = GDALGetDataTypeByName(name)
	gettype(fielddefn::AbstractFieldDefn) = OGR_Fld_GetType(fielddefn.ptr)
	gettype(geomdefn::AbstractGeomFieldDefn) = OGR_GFld_GetType(geomdefn.ptr)

	accessflag(band::AbstractRasterBand) = GDALGetRasterAccess(band.ptr)
	indexof(band::AbstractRasterBand)    = GDALGetBandNumber(band.ptr)
	pixeltype(band::AbstractRasterBand{T}) where T = T
	getcolorinterp(band::AbstractRasterBand) = GDALGetRasterColorInterpretation(band.ptr)
	getcolortable(band::AbstractRasterBand) = ColorTable(Ptr{Cvoid}(GDALGetRasterColorTable(band.ptr)))

	paletteinterp(ct::ColorTable) = GDALGetPaletteInterpretation(ct.ptr)
	ncolorentry(ct::ColorTable) = GDALGetColorEntryCount(ct.ptr)
	getcolorentry(ct::ColorTable, i::Integer) = unsafe_load(GDALGetColorEntry(ct.ptr, i))

	asint(feature::Feature, i::Integer) = OGR_F_GetFieldAsInteger(feature.ptr, i)
	asint64(feature::Feature, i::Integer) = OGR_F_GetFieldAsInteger64(feature.ptr, i)
	asdouble(feature::Feature, i::Integer) = OGR_F_GetFieldAsDouble(feature.ptr, i)
	asstring(feature::Feature, i::Integer) = OGR_F_GetFieldAsString(feature.ptr, i)
	asstringlist(feature::Feature, i::Integer) = OGR_F_GetFieldAsStringList(feature.ptr, i)
	function asintlist(feature::Feature, i::Integer)
		n = Ref{Cint}()
		ptr = OGR_F_GetFieldAsIntegerList(feature.ptr, i, n)
		return (n.x == 0) ? Int32[] : unsafe_wrap(Array{Int32}, ptr, n.x)
	end
	function asint64list(feature::Feature, i::Integer)
		n = Ref{Cint}()
		ptr = OGR_F_GetFieldAsInteger64List(feature.ptr, i, n)
		return (n.x == 0) ? Int64[] : unsafe_wrap(Array{Int64}, ptr, n.x)
	end
	function asdoublelist(feature::Feature, i::Integer)
		n = Ref{Cint}()
		ptr = OGR_F_GetFieldAsDoubleList(feature.ptr, i, n)
		return (n.x == 0) ? Float64[] : unsafe_wrap(Array{Float64}, ptr, n.x)
	end
	function asbinary(feature::Feature, i::Integer)
		n = Ref{Cint}()
		ptr = OGR_F_GetFieldAsBinary(feature.ptr, i, n)
		return (n.x == 0) ? UInt8[] : unsafe_wrap(Array{UInt8}, ptr, n.x)
	end
	function asdatetime(feature::Feature, i::Integer)
		pyr = Ref{Cint}(); pmth = Ref{Cint}(); pday = Ref{Cint}()
		phr = Ref{Cint}(); pmin = Ref{Cint}(); psec = Ref{Cint}(); ptz=Ref{Cint}()
		result = Bool(OGR_F_GetFieldAsDateTime(feature.ptr, i, pyr, pmth, pday, phr, pmin, psec, ptz))
		(result == false) && error("Failed to fetch datetime at index $i")
		return DateTime(pyr[], pmth[], pday[], phr[], pmin[], psec[])
	end

	layerdefn(layer::AbstractFeatureLayer) = IFeatureDefnView(OGR_L_GetLayerDefn(layer.ptr))
	ngeom(feature::Feature) = OGR_F_GetGeomFieldCount(feature.ptr)
	ngeom(featuredefn::AbstractFeatureDefn) = OGR_FD_GetGeomFieldCount(featuredefn.ptr)
	ngeom(layer::AbstractFeatureLayer) = ngeom(layerdefn(layer))
	function ngeom(geom::AbstractGeometry)
		n = OGR_G_GetPointCount(geom.ptr)
		n == 0 ? OGR_G_GetGeometryCount(geom.ptr) : n
	end
	getgeomdefn(feature::Feature, i::Integer) = IGeomFieldDefnView(OGR_F_GetGeomFieldDefnRef(feature.ptr, i))
	getgeomdefn(fdfn::FeatureDefn, i::Integer = 0) = GeomFieldDefn(OGR_FD_GetGeomFieldDefn(fdfn.ptr, i))
	getgeomdefn(fdfn::IFeatureDefnView, i::Integer = 0) = IGeomFieldDefnView(OGR_FD_GetGeomFieldDefn(fdfn.ptr, i))

	function getgeom(feature::Feature)
		result = OGR_F_GetGeometryRef(feature.ptr)
		return (result == C_NULL) ? IGeometry() : IGeometry(OGR_G_Clone(result))
	end

	function getgeom(feature::Feature, i::Integer)
		result = OGR_F_GetGeomFieldRef(feature.ptr, i)
		return (result == C_NULL) ? IGeometry() : IGeometry(OGR_G_Clone(result))
	end

	function setgeom!(feature::Feature, geom::AbstractGeometry)
		result = OGR_F_SetGeometry(feature.ptr, geom.ptr)
		@ogrerr result "OGRErr $result: Failed to set feature geometry."
	end
	function setgeom!(feature::Feature, i::Integer, geom::AbstractGeometry)
		result = OGR_F_SetGeomField(feature.ptr, i, geom.ptr)
		@ogrerr result "OGRErr $result: Failed to set feature geometry"
		return feature
	end

	function addpoint!(geom::AbstractGeometry, x::Real, y::Real, z::Real)
		OGR_G_AddPoint(geom.ptr, x, y, z);	return geom
	end
	function addpoint!(geom::AbstractGeometry, x::Real, y::Real)
		OGR_G_AddPoint_2D(geom.ptr, x, y);	return geom
	end

	function addgeom!(geomcontainer::AbstractGeometry, subgeom::AbstractGeometry)
		result = OGR_G_AddGeometry(geomcontainer.ptr, subgeom.ptr)
		@ogrerr result "Failed to add geometry. The geometry type could be illegal"
		return geomcontainer
	end

	nfield(feature::Feature) = OGR_F_GetFieldCount(feature.ptr)
	nfield(featuredefn::AbstractFeatureDefn) = OGR_FD_GetFieldCount(featuredefn.ptr)
	nfield(layer::AbstractFeatureLayer) = nfield(layerdefn(layer))

	getfielddefn(feature::Feature, i::Integer) = IFieldDefnView(OGR_F_GetFieldDefnRef(feature.ptr, i))
	getfielddefn(featuredefn::FeatureDefn, i::Integer) = FieldDefn(OGR_FD_GetFieldDefn(featuredefn.ptr, i))
	getfielddefn(featuredefn::IFeatureDefnView, i::Integer) = IFieldDefnView(OGR_FD_GetFieldDefn(featuredefn.ptr, i))

	function getfield(feature::Feature, i::Integer)
		if isfieldset(feature, i)
			_fieldtype = gettype(getfielddefn(feature, i))
			_fetchfield = get(_FETCHFIELD, _fieldtype, getdefault)
			return _fetchfield(feature, i)
		else
			return getdefault(feature, i)
		end
	end
	getfield(feature::Feature, name::Union{AbstractString, Symbol}) = getfield(feature, findfieldindex(feature, name))


	function setfield!(feature::Feature, i::Integer, value::Cint)
		OGR_F_SetFieldInteger(feature.ptr, i, value);	return feature
	end
	
	function setfield!(feature::Feature, i::Integer, value::Int64)
		OGR_F_SetFieldInteger64(feature.ptr, i, value);	return feature
	end
	
	function setfield!(feature::Feature, i::Integer, value::Cdouble)
		OGR_F_SetFieldDouble(feature.ptr, i, value);	return feature
	end
	
	function setfield!(feature::Feature, i::Integer, value::AbstractString)
		OGR_F_SetFieldString(feature.ptr, i, value);	return feature
	end
	
	function setfield!(feature::Feature, i::Integer, value::Vector{Cint})
		OGR_F_SetFieldIntegerList(feature.ptr, i, length(value), value);	return feature
	end
	
	function setfield!(feature::Feature, i::Integer, value::Vector{Clonglong})
		OGR_F_SetFieldInteger64List(feature.ptr, i, length(value), value);	return feature
	end
	
	function setfield!(feature::Feature, i::Integer, value::Vector{Cdouble})
		OGR_F_SetFieldDoubleList(feature.ptr, i, length(value), value);		return feature
	end
	
	function setfield!(feature::Feature, i::Integer, value::Vector{T}) where T <: AbstractString
		OGR_F_SetFieldStringList(feature.ptr, i, value);	return feature
	end

	function setfield!(feature::Feature, i::Integer, value::Vector{Cuchar})
		OGR_F_SetFieldBinary(feature.ptr, i, sizeof(value), value);	return feature
	end

	#=
	function setfield!(feature::Feature, i::Integer, dt::DateTime, tzflag::Int = 0)
		OGR_F_SetFieldDateTime(feature.ptr, i, Dates.year(dt), Dates.month(dt), Dates.day(dt), Dates.hour(dt), Dates.minute(dt), Dates.second(dt), tzflag)
		return feature
	end
	=#

	isfieldset(feature::Feature, i::Integer) = Bool(OGR_F_IsFieldSet(feature.ptr, i))
	getdefault(feature::Feature, i::Integer) = getdefault(getfielddefn(feature, i))

	findfieldindex(feature::Feature, name::Union{AbstractString, Symbol}) = OGR_F_GetFieldIndex(feature.ptr, name)
	findfieldindex(fdefn::AbstractFeatureDefn, name::Union{AbstractString, Symbol}) = OGR_FD_GetFieldIndex(fdefn.ptr, name)
	function findfieldindex(layer::AbstractFeatureLayer, field::Union{AbstractString, Symbol}, exactmatch::Bool)
		return OGR_L_FindFieldIndex(layer.ptr, field, exactmatch)
	end

	const _FETCHFIELD = Dict{UInt32, Function}(
		OFTInteger       => asint,           #0-
		OFTIntegerList   => asintlist,       #1-
		OFTReal          => asdouble,        #2-
		OFTRealList      => asdoublelist,    #3-
		OFTString        => asstring,        #4-
		OFTStringList    => asstringlist,    #5-
		OFTBinary        => asbinary,        #8-
		OFTDateTime      => asdatetime,      #11
		OFTInteger64     => asint64,         #12-
		OFTInteger64List => asint64list      #13-
	)

	function getdefault(fielddefn::AbstractFieldDefn)
		result = @gdal(OGR_Fld_GetDefault::Cstring, fielddefn.ptr::Ptr{Cvoid})
		return (result == C_NULL) ? "" : unsafe_string(result)
	end

	function resetreading!(layer::AbstractFeatureLayer)
		OGR_L_ResetReading(layer.ptr)
		return layer
	end	

	creategeom(geomtype::UInt32) = IGeometry(OGR_G_CreateGeometry(geomtype))
	unsafe_creategeom(geomtype::UInt32) = Geometry(OGR_G_CreateGeometry(geomtype))

#=
	for gdalfunc in (
			:boundary, :buffer, :centroid, :clone, :convexhull, :create,
			:createcolortable, :createcoordtrans, :copy, :createfeaturedefn,
			:createfielddefn, :creategeom, :creategeomcollection,
			:creategeomfieldcollection, :creategeomdefn, :createlayer,
			:createlinearring, :createlinestring, :createmultilinestring,
			:createmultipoint, :createmultipolygon, :createmultipolygon_noholes,
			:createpoint, :createpolygon, :createRAT, :createstylemanager,
			:createstyletable, :createstyletool, :curvegeom, :delaunaytriangulation,
			:difference, :forceto, :fromGML, :fromJSON, :fromWKB, :fromWKT,
			:gdalbuildvrt, :gdaldem, :gdalgrid, :gdalnearblack, :gdalrasterize,
			:gdaltranslate, :gdalvectortranslate, :gdalwarp, :getband,
			:getcolortable, :getfeature, :getgeom, :getlayer, :getmaskband,
			:getoverview, :getpart, :getspatialref, :importCRS, :intersection, :importEPSG,
			:importEPSGA, :importESRI, :importPROJ4, :importWKT, :importXML,
			:importURL, :lineargeom, :newspatialref, :nextfeature, :pointalongline,
			:pointonsurface, :polygonfromedges, :polygonize, :read, :sampleoverview,
			:simplify, :simplifypreservetopology, :symdifference, :union, :update,
			:readraster,
		)
		eval(quote
			function $(gdalfunc)(f::Function, args...; kwargs...)
				obj = $(Symbol("unsafe_$gdalfunc"))(args...; kwargs...)
				try
					f(obj)
				finally
					destroy(obj)
				end
			end
		end)
	end
=#

	for (geom, wkbgeom) in ((:geomcollection,       wkbGeometryCollection),
							(:linestring,           wkbLineString),
							(:linearring,           wkbLinearRing),
							(:multilinestring,      wkbMultiLineString),
							(:multipoint,           wkbMultiPoint),
							(:multipolygon,         wkbMultiPolygon),
							(:multipolygon_noholes, wkbMultiPolygon),
							(:point,                wkbPoint),
							(:polygon,              wkbPolygon))
		eval(quote
			$(Symbol("create$geom"))() = creategeom($wkbgeom)
			$(Symbol("unsafe_create$geom"))() = unsafe_creategeom($wkbgeom)
		end)
	end

	for f in (:create, :unsafe_create)
		for (args, typedargs) in ( ((:x,:y), (:(x::Real),:(y::Real))), ((:x,:y,:z), (:(x::Real),:(y::Real),:(z::Real))))
			eval(quote
				function $(Symbol("$(f)point"))($(typedargs...))
					geom = $(Symbol("$(f)point"))()
					addpoint!(geom, $(args...))
					return geom
				end
			end)
		end

		for (args, typedargs) in ( ((:xs,:ys), (:(xs::Vector{Cdouble}), :(ys::Vector{Cdouble}))),
				((:xs,:ys,:zs), (:(xs::Vector{Cdouble}), :(ys::Vector{Cdouble}), :(zs::Vector{Cdouble}))))
			for geom in (:linestring, :linearring)
				eval(quote
					function $(Symbol("$f$geom"))($(typedargs...))
						geom = $(Symbol("$f$geom"))()
						for pt in zip($(args...))
							addpoint!(geom, pt...)
						end
						return geom
					end
				end)
			end

			for (geom,component) in ((:polygon, :linearring),)
				eval(quote
					function $(Symbol("$f$geom"))($(typedargs...))
						geom = $(Symbol("$f$geom"))()
						subgeom = $(Symbol("unsafe_create$component"))($(args...))
						result = OGR_G_AddGeometryDirectly(geom.ptr, subgeom.ptr)
						@ogrerr result "Failed to add $component."
						return geom
					end
				end)
			end

			for (geom,component) in ((:multipoint, :point),)
				eval(quote
					function $(Symbol("$f$geom"))($(typedargs...))
						geom = $(Symbol("$f$geom"))()
						for pt in zip($(args...))
							subgeom = $(Symbol("unsafe_create$component"))(pt)
							result = OGR_G_AddGeometryDirectly(geom.ptr, subgeom.ptr)
							@ogrerr result "Failed to add point."
						end
						return geom
					end
				end)
			end
		end

		for typeargs in (Vector{<:Real}, Tuple{<:Real,<:Real}, Tuple{<:Real,<:Real,<:Real})
			eval(quote
				function $(Symbol("$(f)point"))(coords::$typeargs)
					geom = $(Symbol("$(f)point"))()
					addpoint!(geom, coords...)
					return geom
				end
			end)
		end

		for typeargs in (Vector{Tuple{Cdouble,Cdouble}}, Vector{Tuple{Cdouble,Cdouble,Cdouble}}, Vector{Vector{Cdouble}})
			for geom in (:linestring, :linearring)
				eval(quote
					function $(Symbol("$f$geom"))(coords::$typeargs)
						geom = $(Symbol("$f$geom"))()
						for coord in coords
							addpoint!(geom, coord...)
						end
						return geom
					end
				end)
			end

			for (geom,component) in ((:polygon, :linearring),)
				eval(quote
					function $(Symbol("$f$geom"))(coords::$typeargs)
						geom = $(Symbol("$f$geom"))()
						subgeom = $(Symbol("unsafe_create$component"))(coords)
						result = OGR_G_AddGeometryDirectly(geom.ptr, subgeom.ptr)
						@ogrerr result "Failed to add $component."
						return geom
					end
				end)
			end
		end

		for (variants,typeargs) in ( (((:multipoint, :point),),
				(Vector{Tuple{Cdouble,Cdouble}}, Vector{Tuple{Cdouble,Cdouble,Cdouble}}, Vector{Vector{Cdouble}})),
	
				(((:polygon, :linearring), (:multilinestring, :linestring), (:multipolygon_noholes, :polygon)),
				 (Vector{Vector{Tuple{Cdouble,Cdouble}}}, Vector{Vector{Tuple{Cdouble,Cdouble,Cdouble}}},
				  Vector{Vector{Vector{Cdouble}}})),
	
				(((:multipolygon, :polygon),), (Vector{Vector{Vector{Tuple{Cdouble,Cdouble}}}},
				  Vector{Vector{Vector{Tuple{Cdouble,Cdouble,Cdouble}}}}, Vector{Vector{Vector{Vector{Cdouble}}}}))
			)
			for typearg in typeargs, (geom, component) in variants
				eval(quote
					function $(Symbol("$f$geom"))(coords::$typearg)
						geom = $(Symbol("$f$geom"))()
						for coord in coords
							subgeom = $(Symbol("unsafe_create$component"))(coord)
							result = OGR_G_AddGeometryDirectly(geom.ptr, subgeom.ptr)
							@ogrerr result "Failed to add $component."
						end
						return geom
					end
				end)
			end
		end
	end

	Base.size(band::AbstractRasterBand) = (width(band), height(band))
	Base.size(dataset::RasterDataset) = dataset.size

	function Base.show(io::IO, drv::Driver)
		drv.ptr == C_NULL && (return print(io, "NULL Driver"))
		print(io, "Driver: $(shortname(drv))/$(longname(drv))")
	end

	function Base.show(io::IO, dataset::AbstractDataset)
		dataset.ptr == C_NULL && (return print(io, "NULL Dataset"))
		println(io, "GDAL Dataset ($(getdriver(dataset)))")
		println(io, "File(s): ")
		for (i,filename) in enumerate(filelist(dataset))
			println(io, "  $filename")
			if i > 5
				println(io, "  ...")
				break
			end
		end
		nrasters = nraster(dataset)
		if nrasters > 0
			print(io, "\nDataset (width x height): ")
			println(io, "$(width(dataset)) x $(height(dataset)) (pixels)")
			println(io, "Number of raster bands: $nrasters")
			for i = 1:min(nrasters, 3)
				print(io, "  ")
				summarize(io, getband(dataset, i))
			end
			nrasters > 3 && println(io, "  ...")
		end

		nlayers = nlayer(dataset)
		if nlayers > 0
			println(io, "\nNumber of feature layers: $nlayers")
			ndisplay = min(nlayers, 5) # display up to 5 layers
			for i = 1:ndisplay
				layer = getlayer(dataset, i-1)
				layergeomtype = getgeomtype(layer)
				println(io, "  Layer $(i-1): $(getname(layer)) ($layergeomtype)")
			end
			if nlayers > 5
				print(io, "  Remaining layers: ")
				for i = 6:nlayers
					print(io, "$(getname(getlayer(dataset, i-1))) ")
					if i % 5 == 0 println() end		# display up to 5 layer names per line
				end
			end
		end
	end

	Base.show(io::IO, raster::RasterDataset) = show(io, raster.ds)
	Base.show(io::IO, ::MIME"text/plain", raster::RasterDataset) = show(io, raster.ds)

	function summarize(io::IO, rasterband::AbstractRasterBand)
		(rasterband.ptr == C_NULL) && return print(io, "NULL RasterBand")
		access = accessflag(rasterband)
		color = getname(getcolorinterp(rasterband))
		xsize = width(rasterband)
		ysize = height(rasterband)
		i = indexof(rasterband)
		pxtype = pixeltype(rasterband)
		println(io, "[$access] Band $i ($color): $xsize x $ysize ($pxtype)")
	end

	# assumes that the layer is reset, and will reset it after display
	function Base.show(io::IO, layer::AbstractFeatureLayer)
		layer.ptr == C_NULL && (return println(io, "NULL Layer"))
		layergeomtype = getgeomtype(layer)
		println(io, "Layer: $(getname(layer))")
		featuredefn = layerdefn(layer)

		# Print Geometries
		n = ngeom(featuredefn)
		ngeomdisplay = min(n, 3)
		for i in 1:ngeomdisplay
			gfd = getgeomdefn(featuredefn, i-1)
			display = "  Geometry $(i-1) ($(getname(gfd))): [$(gettype(gfd))]"
			if length(display) > 75
				println(io, "$display[1:70]...")
				continue
			end
			if ngeomdisplay == 1 # only support printing of a single geom column
				for f in layer
					geomwkt = toWKT(getgeom(f))
					length(geomwkt) > 25 && (geomwkt = "$(geomwkt[1:20])...)")
					newdisplay = "$display, $geomwkt"
					if length(newdisplay) > 75
						display = "$display, ..."
						break
					else
						display = newdisplay
					end
				end
			end
			println(io, display)
			resetreading!(layer)
		end
		n > 3 && println(io, "  ...\n  Number of Geometries: $n")

		# Print Features
		n = nfield(featuredefn)
		nfielddisplay = min(n, 5)
		for i in 1:nfielddisplay
			fd = getfielddefn(featuredefn, i-1)
			display = "     Field $(i-1) ($(getname(fd))): [$(gettype(fd))]"
			if length(display) > 75
				println(io, "$display[1:70]...")
				continue
			end
			for f in layer
				field = string(getfield(f, i-1))
				length(field) > 25 && (field = "$(field[1:20])...")
				newdisplay = "$display, $field"
				if length(newdisplay) > 75
					display = "$display, ..."
					break
				else
					display = newdisplay
				end
			end
			println(io, display)
			resetreading!(layer)
		end
		n > 5 && print(io, "...\n Number of Fields: $n")
	end

	function Base.iterate(layer::AbstractFeatureLayer, state::Int=0)
		layer.ptr == C_NULL && return nothing
		state == 0 && resetreading!(layer)
		ptr = OGR_L_GetNextFeature(layer.ptr)
		if ptr == C_NULL
			resetreading!(layer)
			return nothing
		else
			return (Feature(ptr), state+1)
		end
	end

	# ------------ Aliases ------------
	const creategd = create
	const ogr2ogr  = gdalvectortranslate
	const readgd   = read
	const readgd!  = read!
	const writegd! = write!
	# ---------------------------------

	export
		creategd, getband, getdriver, getproj, getgeotransform, toPROJ4, toWKT, importPROJ4, importWKT,
		importEPSG, gdalinfo, gdalwarp, gdaldem, gdaltranslate, gdalgrid, gdalvectortranslate, ogr2ogr,
		readgd, readgd!, readraster, writegd!, setgeotransform!, setproj!

	const DRIVER_MANAGER = Ref{DriverManager}()
	const GDALVERSION = Ref{VersionNumber}()

	function __init__()

		versionstring = GDALVersionInfo("RELEASE_NAME")
		GDALVERSION[] = VersionNumber(versionstring)

		DRIVER_MANAGER[] = DriverManager()
		CPLSetConfigOption("GDAL_HTTP_UNSAFESSL", "YES")
	end

"""
Small subset of the GDAL and ArcGDAL packages but with no extra dependencies.
For the time being this sub-module is not intended to much direct use so it has no further
documentation. Interested people should consult the GDAL & ArchGDAL docs.
"""
Gdal

end			# End module