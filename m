Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F00AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1BCC433EF;
	Wed,  4 Jan 2023 16:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849237;
	bh=zrfU231GJK/axSv6kEzBi+LS+JM7t34THONAJX0/JrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjQc6KJWCpmn65bVfIGPbm9n1PARG13RxGQQqNHlFXeYAfDU88JRh0M1Wkwf8omFU
	 Cqy7y+dSbCYynUu4iR6EkI1SIcYN3ql0lWbWBeCD28nmZOlGT/+b1heibLevrC14Jq
	 UYKP53tD7W27aXo9MpaLpKCT/HZhNOR0bD5bpM9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <KevinYang.Wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 087/177] drm/amdgpu: fix mmhub register base coding error
Date: Wed,  4 Jan 2023 17:06:18 +0100
Message-Id: <20230104160510.282788013@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Wang <KevinYang.Wang@amd.com>

commit 347fafe0eb46df941965c355c77ce480e4d49f1f upstream.

fix MMHUB register base coding error.

Fixes: ec6837591f992 ("drm/amdgpu/gmc10: program the smallK fragment size")

Signed-off-by: Yang Wang <KevinYang.Wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c   |    2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c   |    2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c   |    2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c |    2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
@@ -319,7 +319,7 @@ static void mmhub_v2_0_init_cache_regs(s
 
 	tmp = mmMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, mmMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, mmMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v2_0_enable_system_domain(struct amdgpu_device *adev)
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
@@ -243,7 +243,7 @@ static void mmhub_v2_3_init_cache_regs(s
 
 	tmp = mmMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, mmMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, mmMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v2_3_enable_system_domain(struct amdgpu_device *adev)
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
@@ -275,7 +275,7 @@ static void mmhub_v3_0_init_cache_regs(s
 
 	tmp = regMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, regMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, regMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v3_0_enable_system_domain(struct amdgpu_device *adev)
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
@@ -269,7 +269,7 @@ static void mmhub_v3_0_1_init_cache_regs
 
 	tmp = regMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, regMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, regMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v3_0_1_enable_system_domain(struct amdgpu_device *adev)
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c
@@ -268,7 +268,7 @@ static void mmhub_v3_0_2_init_cache_regs
 
 	tmp = regMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, regMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, regMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v3_0_2_enable_system_domain(struct amdgpu_device *adev)


