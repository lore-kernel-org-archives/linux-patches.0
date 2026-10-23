Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774793;
	b=yH+Pzd5Jns8a2Lv5QY0fXjSf2WdCOCDuSsBIXTGwvJXZtHub9JzLtuepmuXhvv+kcZ0Q
	 goD0otehsuDxb5l7Hb8IWmeOpZI9SuE6kEzJubQ4Ir5SOqt3Zc+nKKE8iJ37PwEeykx3W
	 nEIMHZ0ORKuNC5jPg6IO+XaPmqomtPRzQJ4RwZXNsbE1dDKpUuPU5iBdEX2aOXXSv/PtT
	 nE4zwv9cH6IVYoVFP+QbSvfl+ycfcn5BhiX3sFD+u7gudJVtc5V/64nKGjKY0ZWNcvBDR
	 QJVyAkQ8/WA6AJyNpDiTgsIgEq0PA3zEiyCGxTgil424K6iJ2LdGGp9QoLMOR067OIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UhQJ1SiWL9uJoHIQuXzKZMsosv6y9BxI0WUZyhLLM9I=;
	b=3cysp1PmsHLaQSjW64RHI0nhcwRj5cMaqiYEW0eCkcQj58u/5lshFOlTul3+SgMaL212
	 cEqnKYV1W8408JqEbwCkL2M2B0ZU68NhF2559czXYFJR8NUwm/++06BiZvZYKYQVo5m+j
	 KWMVlWF0ilo6WVxbVkwlRivEZCKt3fLC+1SUJrgbxMFIYL6R2+7Iug45srLQ1/djvFHJ0
	 +VTNocRsKTTi9+7+Zy41UKYrK/xiy1T9ZgE3Ae5m8trsEPSa7CPAYYWzCX2nK999Q7WpE
	 1qa0kR/bshK+iv7fIcMAcKwgTR/MMgEWU0V+0AEDpxDpJhdT1AzMUtrkq5sy8bGBXgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5QlhMs2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33D8606A31A;
	Fri, 23 Oct 2026 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5QlhMs2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CD41F01825;
	Fri, 23 Oct 2026 16:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774792;
	bh=UhQJ1SiWL9uJoHIQuXzKZMsosv6y9BxI0WUZyhLLM9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5QlhMs23sKrXiXX8hLy5QkvmA13EE0VYUWnnAnAImhQ4NDqu9haB3AHaQbfnuc/J
	 LG5YXcDq2Vg7kOLvh5Uufla19w33s4NQYvCHDPfFw5NquX5gX9ku8vOlcCbtrM/q4u
	 3JrZJBf19CqPpK0OHW4rsWyrcMucyTS2VRVN0jh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 159/242] drm/amdgpu: report the BO alignment in bytes in GEM_LIST_HANDLES
Date: Fri, 23 Oct 2026 18:40:01 +0200
Message-ID: <20261023163717.541815221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit d65a459dbc9a6c3b051e22c96f73598e34b31bfc upstream.

The uapi documents drm_amdgpu_gem_list_handles_entry.alignment as
"physical start_addr alignment in bytes", and GEM_OP
GET_GEM_CREATE_INFO returns the same value in bytes, but
GEM_LIST_HANDLES returns tbo.page_alignment, which is in pages. For a BO
created with a 64 KiB alignment on navi31:

  GET_GEM_CREATE_INFO: alignment=65536
  GEM_LIST_HANDLES:    alignment=16

so a user such as CRIU that recreates BOs from this list uses the wrong
alignment. Convert it to bytes.

Fixes: f9db1fc52ceb ("drm/amdgpu: Add ioctl to get all gem handles for a process")
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit aa4493ae949c13e79aba0731394dd7a7e431342b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -1241,7 +1241,7 @@ int amdgpu_gem_list_handles_ioctl(struct
 		bo_entry->alloc_flags = bo->flags & AMDGPU_GEM_CREATE_SETTABLE_MASK;
 		bo_entry->preferred_domains = bo->preferred_domains;
 		bo_entry->gem_handle = id;
-		bo_entry->alignment = bo->tbo.page_alignment;
+		bo_entry->alignment = (u64)bo->tbo.page_alignment << PAGE_SHIFT;
 
 		if (bo->tbo.base.import_attach)
 			bo_entry->flags |= AMDGPU_GEM_LIST_HANDLES_FLAG_IS_IMPORT;


