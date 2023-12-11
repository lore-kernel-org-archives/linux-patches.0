Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205A05101A;
	Mon, 11 Dec 2023 18:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SL7ezGWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F0DC433C8;
	Mon, 11 Dec 2023 18:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319271;
	bh=bPNL699qXSHgY9+3JT/qCtw9PgO4EXV5MLEWX+aK/UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SL7ezGWIVdhL4k+tVqwVXabb9ExVpmVWTVE5pOdBLqvU2yCZAl5OmIBs2zEL983/L
	 6pztiG++GEoFgce81B23+teLrQWWsJByDeugPsnOATYyqqvAwSJyYZxcqGe3Ud6mrP
	 Mbsw9ZUmBAbj3zDFkA1ok3uCU7CDcmCGadTyfX0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Le Ma <le.ma@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/244] drm/amdgpu: finalizing mem_partitions at the end of GMC v9 sw_fini
Date: Mon, 11 Dec 2023 19:18:27 +0100
Message-ID: <20231211182046.407242073@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Le Ma <le.ma@amd.com>

[ Upstream commit bdb72185d310fc8049c7ea95221d640e9e7165e5 ]

The valid num_mem_partitions is required during ttm pool fini,
thus move the cleanup at the end of the function.

Signed-off-by: Le Ma <le.ma@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index f9a5a2c0573e4..89550d3df68d8 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -2220,8 +2220,6 @@ static int gmc_v9_0_sw_fini(void *handle)
 
 	if (adev->ip_versions[GC_HWIP][0] == IP_VERSION(9, 4, 3))
 		amdgpu_gmc_sysfs_fini(adev);
-	adev->gmc.num_mem_partitions = 0;
-	kfree(adev->gmc.mem_partitions);
 
 	amdgpu_gmc_ras_fini(adev);
 	amdgpu_gem_force_release(adev);
@@ -2235,6 +2233,9 @@ static int gmc_v9_0_sw_fini(void *handle)
 	amdgpu_bo_free_kernel(&adev->gmc.pdb0_bo, NULL, &adev->gmc.ptr_pdb0);
 	amdgpu_bo_fini(adev);
 
+	adev->gmc.num_mem_partitions = 0;
+	kfree(adev->gmc.mem_partitions);
+
 	return 0;
 }
 
-- 
2.42.0



