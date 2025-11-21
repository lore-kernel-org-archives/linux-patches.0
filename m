Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03D82989A2;
	Fri, 21 Nov 2025 13:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730916; cv=none; b=sp1O6/sDncKVg6paye04fmDvlYMPbQPBmwvIn/NATh5f7ayhH6l4+MbxWUQQ8q+eg+iOhz3a2q5WGjD8TpNcvjzzi81L0PXKgJ9yaZjrn8y1jSObyDlq7ISRlGcAVkYylvxiSEMBS0h07Z9xEkP0E9J7/I+qrn3tHibu5WV7ggw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730916; c=relaxed/simple;
	bh=WfPc+S4EWYIBQhZ17M33wGFOm2vMjgTCgUMV0CU/1w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WDDssi1oRZHXMdYh0ENj7uW7IE5e+zTdCO+yvUPCWkiZo6DTZWu02dWgEJeuLtt7di0QroG14gm9KsEusdMVDb3eSsk9AL2zj2a8naumrQypCW6HqlgPcsrpIBo7OpMsvhGMORlRMD/E0W/tZR4w2gHaylRceIfJqD2WZxCwHjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhIVNjBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhIVNjBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F2CC4CEFB;
	Fri, 21 Nov 2025 13:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730916;
	bh=WfPc+S4EWYIBQhZ17M33wGFOm2vMjgTCgUMV0CU/1w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhIVNjBFN1jEqVSlkjB/YObqEIqGvFbkQFgVH1oVfBl7moIplm/YYgtENNKkeLQMZ
	 z8tqpLHCV66vmeElIqBA8Iv9JpCCUlABcJR4rINWP1DKM5jK5JZlFjDYYr+uBdxAKH
	 kZMdW1tuNV436P0NaDLfSeJI17vg3fKvG8w1vdw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 027/247] drm/amdgpu: hide VRAM sysfs attributes on GPUs without VRAM
Date: Fri, 21 Nov 2025 14:09:34 +0100
Message-ID: <20251121130155.579249466@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 33cc891b56b93cad1a83263eaf2e417436f70c82 ]

Otherwise accessing them can cause a crash.

Signed-off-by: Christian König <christian.koenig@amd.com>
Tested-by: Mangesh Gadre <Mangesh.Gadre@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 78f9e86ccc099..832ab87eb3451 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -234,6 +234,9 @@ static umode_t amdgpu_vram_attrs_is_visible(struct kobject *kobj,
 	    !adev->gmc.vram_vendor)
 		return 0;
 
+	if (!ttm_resource_manager_used(&adev->mman.vram_mgr.manager))
+		return 0;
+
 	return attr->mode;
 }
 
-- 
2.51.0



