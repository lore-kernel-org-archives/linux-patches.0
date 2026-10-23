Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774053;
	b=mkMGtHIzjSxzF5SooQPy+VEhftiNWwY6ahC4CJALmZxEEipd4EcU/t6rgJm9wnBWcqJA
	 ZCQ1/plLA7EJN7Zu1D48oFQlJkKw+i+W+0D9Y30WfeaveS6O4Hq37rgTTtMvO/IDVryYo
	 wiOhiEqmG4G2pcYE2LCnJ/WZiBTTD4vwVSi4F7wDy9xuE6QfAG6oN2bi5goIi66p0fwii
	 0+o3ep5h5RzHbGj/9tbjp7//qK3SXL96wv3WrQI9imHvVZ70SWimKSjzPWye23AeD8zFN
	 B2fGfS9357bCEA+NKZr0v5WyFxkvr2tCLQGIUVBRS7Q9vpLWvOLAgO09LYV98vhhuMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AH8kFViWnPiAx/xkJ+64FoZtK95kk5rmYrTh1A7Im/E=;
	b=48++IQ6gP0SXnWS9SYwSt6nflIR650QAE6/huN+58KwgwjGATwvp0xqHYcrfBkuO6d23
	 Ik3g1bbnfCkoUGDcuGvZ2rsbkgr9NbFl4EbROAMSDzEp4S6vN9ana4pXrrVJa9HWKWZcS
	 R4B4YTRoW43R4FuyEr6TLRj1w4Wx6rimvIG+Q2LbUhl3iIA5DW3Sr8E08WYEWi3naUF61
	 eXcyw10Gnnc12N++9b6gLikCxSFoLlGw10VNOQXvZM5BWVTJcuZLqW0MJ9GBFYryoG5wF
	 qkg5CH8gAcCuWonfQboDIwrVGDBdufZEba+vS29lUy+iDpFEWmIjtjGdnetYSG2j5xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFYRXiAu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A70606A31B;
	Fri, 23 Oct 2026 16:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFYRXiAu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B761F01828;
	Fri, 23 Oct 2026 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774053;
	bh=AH8kFViWnPiAx/xkJ+64FoZtK95kk5rmYrTh1A7Im/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFYRXiAuICWAv7uVqq9ppKkd91QLKejAyaUwgRfPC3AommybdRxoX1bSwrHh8fmuP
	 c6oAxmKzh8vfu8GIt1+Za3HpxGA0g3rMqYaXIXKhCoODjqaAGiOuqnG5MT4LSxJ2Vq
	 R3sPlwtv1WcxogZFcSVeicWrxFLwCFsPpW4CUa+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 106/193] drm/amdgpu: report the BO alignment in bytes in GEM_LIST_HANDLES
Date: Fri, 23 Oct 2026 18:36:23 +0200
Message-ID: <20261023163716.715962828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1217,7 +1217,7 @@ int amdgpu_gem_list_handles_ioctl(struct
 		bo_entry->alloc_flags = bo->flags & AMDGPU_GEM_CREATE_SETTABLE_MASK;
 		bo_entry->preferred_domains = bo->preferred_domains;
 		bo_entry->gem_handle = id;
-		bo_entry->alignment = bo->tbo.page_alignment;
+		bo_entry->alignment = (u64)bo->tbo.page_alignment << PAGE_SHIFT;
 
 		if (bo->tbo.base.import_attach)
 			bo_entry->flags |= AMDGPU_GEM_LIST_HANDLES_FLAG_IS_IMPORT;


