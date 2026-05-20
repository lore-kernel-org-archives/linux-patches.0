Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E933E95A4;
	Wed, 20 May 2026 18:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300463; cv=none; b=fucEtZcRMJCOWLWGNHknLIm3Fm/7sVjUu3bSKhJWzit8X272KwYemVLYOwk8WzXDX0pH9JheHS4xz43K1RqrF64zJ8zQ2qoWoks3iWOFEBGTWsXEQ53uK+jDq9eE9MVp44fOdczKx7qHASv6vvwpC68bnnGiL8enQrlRJTKi6u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300463; c=relaxed/simple;
	bh=mBSe6ZRmOpHueXTM15SkDxyo5yqBAPeAR/zPtITaNvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NG1tAJH0S5NiIWTmOe90pqIN0EnMWBssEL2jHGxwNPYBYS96FTCdLWWcTJ2/oBt3YP4PmRbj2HCnMmPMmMP74YyROtVeZtegs+1tuzYbnRzrmZmTCG4/mvVLkRC2Nx5m1SYjC2FS2G39scsvsMjQ3pVo2YCv0JG2WrjL0GgJlrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppx2ZBTe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppx2ZBTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713F81F000E9;
	Wed, 20 May 2026 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300461;
	bh=k9rc4WIvFVme5qVMt4ez0GMBOmvmuErh40deCilwOpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppx2ZBTeDPWmTIwtgPOCQxyE/5/J8vnzXK52qNKGU04G0GM7jL8UY9AgIEI+gPhSL
	 5r0czGhHXsKTzp6WTK1NxLoyK9WFGo1ajerSWaMIdFi3LgsUfKzOMYxCy8wFV1Vx3P
	 swjDChtvithwl+Rh6jLHLNYrdHF/oYzK/wigenU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/666] drm/amdgpu: update the handle ptr in dump_ip_state
Date: Wed, 20 May 2026 18:16:35 +0200
Message-ID: <20260520162115.190471963@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit fa73462dc0482644416c2a2ee042c11d93a89663 ]

Update the ptr handle to amdgpu_ip_block ptr in all
the functions.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 8b3e8fa6d7bd ("drm/amdgpu/uvd4.2: Don't initialize UVD 4.2 when DPM is disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c    | 2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c     | 4 ++--
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c     | 4 ++--
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c     | 4 ++--
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c      | 4 ++--
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c    | 4 ++--
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c     | 4 ++--
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c   | 4 ++--
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c     | 4 ++--
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c     | 4 ++--
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c     | 4 ++--
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c     | 4 ++--
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c      | 4 ++--
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c      | 4 ++--
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c      | 4 ++--
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c      | 4 ++--
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c      | 4 ++--
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c    | 4 ++--
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c    | 4 ++--
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c    | 4 ++--
 drivers/gpu/drm/amd/include/amd_shared.h   | 4 +++-
 22 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 1183d671d0606..778a0fcc34488 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5466,7 +5466,7 @@ int amdgpu_device_pre_asic_reset(struct amdgpu_device *adev,
 			for (i = 0; i < tmp_adev->num_ip_blocks; i++)
 				if (tmp_adev->ip_blocks[i].version->funcs->dump_ip_state)
 					tmp_adev->ip_blocks[i].version->funcs
-						->dump_ip_state((void *)tmp_adev);
+						->dump_ip_state((void *)&tmp_adev->ip_blocks[i]);
 			dev_info(tmp_adev->dev, "Dumping IP State Completed\n");
 		}
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index ba9a9adca0bff..70762c7fcfe46 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -42,7 +42,7 @@ static void amdgpu_job_do_core_dump(struct amdgpu_device *adev,
 	for (i = 0; i < adev->num_ip_blocks; i++)
 		if (adev->ip_blocks[i].version->funcs->dump_ip_state)
 			adev->ip_blocks[i].version->funcs
-				->dump_ip_state((void *)adev);
+				->dump_ip_state((void *)&adev->ip_blocks[i]);
 	dev_info(adev->dev, "Dumping IP State Completed\n");
 
 	amdgpu_coredump(adev, true, false, job);
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 7d5609e3dd412..a715c7796f94b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -9630,9 +9630,9 @@ static void gfx_v10_ip_print(void *handle, struct drm_printer *p)
 	}
 }
 
-static void gfx_v10_ip_dump(void *handle)
+static void gfx_v10_ip_dump(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	uint32_t i, j, k, reg, index = 0;
 	uint32_t reg_count = ARRAY_SIZE(gc_reg_list_10_1);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 7cb6b11257199..0e99122ced4fb 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -6746,9 +6746,9 @@ static void gfx_v11_ip_print(void *handle, struct drm_printer *p)
 	}
 }
 
-static void gfx_v11_ip_dump(void *handle)
+static void gfx_v11_ip_dump(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	uint32_t i, j, k, reg, index = 0;
 	uint32_t reg_count = ARRAY_SIZE(gc_reg_list_11_0);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index 0f4896a5f82c1..3f3f44b9fdaf9 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -5096,9 +5096,9 @@ static void gfx_v12_ip_print(void *handle, struct drm_printer *p)
 	}
 }
 
-static void gfx_v12_ip_dump(void *handle)
+static void gfx_v12_ip_dump(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	uint32_t i, j, k, reg, index = 0;
 	uint32_t reg_count = ARRAY_SIZE(gc_reg_list_12_0);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index a081fe118c26e..8c9d21854f820 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -7364,9 +7364,9 @@ static void gfx_v9_ip_print(void *handle, struct drm_printer *p)
 
 }
 
-static void gfx_v9_ip_dump(void *handle)
+static void gfx_v9_ip_dump(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	uint32_t i, j, k, reg, index = 0;
 	uint32_t reg_count = ARRAY_SIZE(gc_reg_list_9);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index 26c2d8d9e2463..a6426dd37fbcc 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -4644,9 +4644,9 @@ static void gfx_v9_4_3_ip_print(void *handle, struct drm_printer *p)
 	}
 }
 
-static void gfx_v9_4_3_ip_dump(void *handle)
+static void gfx_v9_4_3_ip_dump(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	uint32_t i, j, k;
 	uint32_t num_xcc, reg, num_inst;
 	uint32_t xcc_id, xcc_offset, inst_offset;
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 37bb0857d8f88..4798c2681b606 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -2371,9 +2371,9 @@ static void sdma_v4_0_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void sdma_v4_0_dump_ip_state(void *handle)
+static void sdma_v4_0_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	uint32_t instance_offset;
 	uint32_t reg_count = ARRAY_SIZE(sdma_reg_list_4_0);
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
index 1e4ce06f5f2c3..c378668044c34 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -1884,9 +1884,9 @@ static void sdma_v4_4_2_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void sdma_v4_4_2_dump_ip_state(void *handle)
+static void sdma_v4_4_2_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	uint32_t instance_offset;
 	uint32_t reg_count = ARRAY_SIZE(sdma_reg_list_4_4_2);
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
index 3e48ea38385de..3ecf77ce2f1af 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -1799,9 +1799,9 @@ static void sdma_v5_0_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void sdma_v5_0_dump_ip_state(void *handle)
+static void sdma_v5_0_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	uint32_t instance_offset;
 	uint32_t reg_count = ARRAY_SIZE(sdma_reg_list_5_0);
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
index bc9b240a3488e..d19dde1d6fc5b 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -1757,9 +1757,9 @@ static void sdma_v5_2_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void sdma_v5_2_dump_ip_state(void *handle)
+static void sdma_v5_2_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	uint32_t instance_offset;
 	uint32_t reg_count = ARRAY_SIZE(sdma_reg_list_5_2);
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
index 208a1fa9d4e7f..981b63a74cfc8 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
@@ -1577,9 +1577,9 @@ static void sdma_v6_0_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void sdma_v6_0_dump_ip_state(void *handle)
+static void sdma_v6_0_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	uint32_t instance_offset;
 	uint32_t reg_count = ARRAY_SIZE(sdma_reg_list_6_0);
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
index 843e6b46deee8..b5897c98ebf05 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
@@ -1565,9 +1565,9 @@ static void sdma_v7_0_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void sdma_v7_0_dump_ip_state(void *handle)
+static void sdma_v7_0_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	uint32_t instance_offset;
 	uint32_t reg_count = ARRAY_SIZE(sdma_reg_list_7_0);
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
index ecdfbfefd66ad..78dfcd02d8da4 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
@@ -1957,9 +1957,9 @@ static void vcn_v1_0_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void vcn_v1_0_dump_ip_state(void *handle)
+static void vcn_v1_0_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	bool is_powered;
 	uint32_t inst_off;
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
index 9479bf9ea30fe..ca144ff63dc83 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
@@ -2074,9 +2074,9 @@ static void vcn_v2_0_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void vcn_v2_0_dump_ip_state(void *handle)
+static void vcn_v2_0_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	bool is_powered;
 	uint32_t inst_off;
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
index 274d5063e9a26..90bebead51969 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -1965,9 +1965,9 @@ static void vcn_v2_5_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void vcn_v2_5_dump_ip_state(void *handle)
+static void vcn_v2_5_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	bool is_powered;
 	uint32_t inst_off;
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index f4ac8bcdb70a5..99e9679b4752a 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -2312,9 +2312,9 @@ static void vcn_v3_0_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void vcn_v3_0_dump_ip_state(void *handle)
+static void vcn_v3_0_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	bool is_powered;
 	uint32_t inst_off;
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
index 2f8d07a7b60ba..fd8774745e771 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -2210,9 +2210,9 @@ static void vcn_v4_0_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void vcn_v4_0_dump_ip_state(void *handle)
+static void vcn_v4_0_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	bool is_powered;
 	uint32_t inst_off;
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
index 2094357a931c4..65a78a2e1b69f 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -1787,9 +1787,9 @@ static void vcn_v4_0_3_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void vcn_v4_0_3_dump_ip_state(void *handle)
+static void vcn_v4_0_3_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	bool is_powered;
 	uint32_t inst_off, inst_id;
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
index 48cb61a9c13fe..a739e667e6158 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -1663,9 +1663,9 @@ static void vcn_v4_0_5_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void vcn_v4_0_5_dump_ip_state(void *handle)
+static void vcn_v4_0_5_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	bool is_powered;
 	uint32_t inst_off;
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
index 3aa715830fbe8..019bc6b1cd3b4 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
@@ -1386,9 +1386,9 @@ static void vcn_v5_0_print_ip_state(void *handle, struct drm_printer *p)
 	}
 }
 
-static void vcn_v5_0_dump_ip_state(void *handle)
+static void vcn_v5_0_dump_ip_state(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_device *adev = ip_block->adev;
 	int i, j;
 	bool is_powered;
 	uint32_t inst_off;
diff --git a/drivers/gpu/drm/amd/include/amd_shared.h b/drivers/gpu/drm/amd/include/amd_shared.h
index 3f91926a50e99..cbb19895ddaf5 100644
--- a/drivers/gpu/drm/amd/include/amd_shared.h
+++ b/drivers/gpu/drm/amd/include/amd_shared.h
@@ -375,6 +375,8 @@ enum amd_dpm_forced_level;
  * making calls to hooks from each IP block. This list is ordered to ensure
  * that the driver initializes the IP blocks in a safe sequence.
  */
+struct amdgpu_ip_block;
+
 struct amd_ip_funcs {
 	char *name;
 	int (*early_init)(void *handle);
@@ -399,7 +401,7 @@ struct amd_ip_funcs {
 	int (*set_powergating_state)(void *handle,
 				     enum amd_powergating_state state);
 	void (*get_clockgating_state)(void *handle, u64 *flags);
-	void (*dump_ip_state)(void *handle);
+	void (*dump_ip_state)(struct amdgpu_ip_block *ip_block);
 	void (*print_ip_state)(void *handle, struct drm_printer *p);
 };
 
-- 
2.53.0



