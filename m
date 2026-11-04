Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831283;
	b=AUWK+ZWKlM59l7J6PpRvAasYlTliiQrYAlxlHJ9iwFHwMkPV68oRUqwSbrQlXHSf7JO2
	 4Wmzgl8yJvKNmv+fIYF3d7KEe61LnhfDQAsElZHLiZO7CDzmuRKuVg1VZ45In/kro0bkf
	 A8zpi12E0iRZnbyrzs9iPpS+W1Ik9jBxDp2QzlPEWJ9KRXigE+sd5suLH9LOuWkgG5WDh
	 ACiw4woqixEwQcZosTloJMY9pA45MVJFKxgh2TKm02WrW389zgO0grH5kNGdZLXG3I/Rz
	 /09V6y0+xI9fIyIJJ0SPXgZAvt2oCKImbwYncP/JtWJS05XBdhy8JoSaEWlOJ83NxjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+fk8KQWsbGIZYkY4heptzTg8gT32J9epGYeqKvLXTwQ=;
	b=OQFLO3PEWr0MYlIm4k1+PJUfkl315CHfeev7thWDvcImbNBLeC2TVmmWGfu3O2WFPtrj
	 8CdlgLmbC2+H4HowNXrBos12O0z5yig0HGPD58MIsAA/HF8xffqmt5bMImd1G5aGZ4MR3
	 IZfLRfrKq5+4w6XTDT5zCbpN3D9clHqsxl731HDrG7zG10XpUVxuIvme/+mVt3nuAA4Ew
	 tWULq1DPohsytyNDkbU1EZ8GM+g2dbSIQYGAsGmAwJAaqMJSkrd5zA54FAfimpClfct6d
	 ji5rvnCNcstcWGODZfQavdZdpXe1XlGQt2UnikhZqfvFu1nI07l28xOXwTOvinAkI/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rwRTMcvm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6912B606A335;
	Wed,  4 Nov 2026 22:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rwRTMcvm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044F31F00919;
	Wed,  4 Nov 2026 22:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831283;
	bh=+fk8KQWsbGIZYkY4heptzTg8gT32J9epGYeqKvLXTwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rwRTMcvmNn/Jd7NBKW9bCRUWs5R9EJdT5LL+lN6kjVPn8abp9OrVoX6uDWg8W/0pY
	 IRWWd9s+9Uf5pvT/u4Ayp/C/s9QyPjCM26JXsSwydcw79xVhRTYgjpawC7g9Pcf4aw
	 /ftaIQFq00yv+cqOdfMuhL+oPbPnSW6bRrvXuy/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0611/1005] drm/amdgpu: remove gart_window_lock usage from gmc v12
Date: Wed,  4 Nov 2026 16:05:44 -0500
Message-ID: <20261104211100.960325716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

[ Upstream commit c79cf5a7d903a16459846b4296fc3cd988837c54 ]

This lock was part of the SDMA workaround originally implemented in
gmc_v10_0_flush_gpu_tlb (a70cb2176f7ef6f moved it to
amdgpu_gmc_flush_gpu_tlb).

This means this lock is useless and be safely dropped.

Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 0bfb1bfc82e8 ("drm/amdgpu/gmc12: properly pass flush_type to gmc_v12_0_flush_vm_hub()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
index 3746d39182707..f22b4197a1c96 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
@@ -339,9 +339,7 @@ static void gmc_v12_0_flush_gpu_tlb(struct amdgpu_device *adev, uint32_t vmid,
 		return;
 	}
 
-	mutex_lock(&adev->mman.gtt_window_lock);
 	gmc_v12_0_flush_vm_hub(adev, vmid, vmhub, 0);
-	mutex_unlock(&adev->mman.gtt_window_lock);
 	return;
 }
 
-- 
2.53.0



