namespace Therapy_Companion_API.Application.Common.Interfaces
{
    public interface ICacheKeyProvider
    {
        string GetCacheKey();
        string? GetCacheProfile();
    }
}


