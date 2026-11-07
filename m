Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061441;
	b=ieBMurILwy0TtEN/CrSW8OictFyDASUE43zHBT2DSo7hc973qQveAY9zTunLvgZvVc99
	 4x9CbTz8NxyrJlSzDIcZWiZGN68VVUG18nsFquKI46gIw/AKSox5dU3kxEqzQZ/pmTsfl
	 67tBp3roLwVT/sxCmVjW6JvvuhGKqOdS+v2o1rzZR+8TO6a9tSZeoAzY2gLn/j+YuclTH
	 2qlu7odZdLW4CYrEgZRh7SLROIyvs4vJYyFqh4IFtZqAJxvsDUeEB7lWy8JJ2AgGVBV3c
	 o0HD/5ZdF7nvdZbheqlItYkh6MEwXE4jBMUVYmPaPFSxDUs/edphdcj+/eZAQGMG5mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=8/MA8SMJMZe2yodOep9AqynevA7lsEk6QXvnLv7GbZw=;
	b=RHJzo2vLzEJ8v4eNwIRpG/VG05SWg/hoT7jSNunS5kNltgRezRvcPpkNzsSuU//Y90n5
	 O/RTHhjvsR3olXuilqcElFIj1vD6Br9YaAixf6lJCV20mJZ+ERVhjEPbrg26FxPAIhAzA
	 +OOLsiSJpxG9PGaNgjGXK7mGH1KFv90JBqXhvXz926dQUNA7mcL1modC05TL1ouHFrx7G
	 69T0wHqXjwqTsW5QUgsDSRa77Eoo+HWmGOoMGCub6iyjS393DfVCNXbEXcieBZ+2/jdXw
	 PBhGDGRAoejixFCaoiX2TP2XcAXCdNx1BIjVqUlpMvrfT8SE5R6HCjSoDdcIjWIxZkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SHphR7g0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7190606A326;
	Sat,  7 Nov 2026 14:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SHphR7g0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F101F0089F;
	Sat,  7 Nov 2026 14:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061440;
	bh=8/MA8SMJMZe2yodOep9AqynevA7lsEk6QXvnLv7GbZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHphR7g0Jenn/Q6SbtXAMUXXFLII3EfiwAFOho7GYf9kQ7oUjvv6aWhPODdZq/ZIF
	 fHASz3at+LtAUjWNd2HRkH1JqsHjTNezW2df6aN8f6HpkLaPGey2gr4PHTxq6wllao
	 eQ3meOA34/goabIOxSI6b+9xU1d0PYikb6vqJm3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0549/1536] drm/amdgpu: remove gart_window_lock usage from gmc v12
Date: Sat,  7 Nov 2026 08:42:45 -0500
Message-ID: <20261107135013.025866251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aaa6307254ff1..7e70d6f8726af 100644
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



