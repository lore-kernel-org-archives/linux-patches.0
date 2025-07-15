Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302842737E1;
	Tue, 15 Jul 2025 23:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752623431; cv=none; b=IUbLWLjhDQ2Lc4Iv9/iXqtYKZ2Wkc3uKCNpvtcb5e4ueLiMxLGjmKHBsYzSTWhbb8KXdEAHdx1WDVLhCvAIpFbdoSbtZJIE7Py8slwIxVpaJjmTU8uwvzYmii/ELv/lW5vTEnbnA95/2bWZAG65nwCC31ZTatU89RcOsBdaAmA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752623431; c=relaxed/simple;
	bh=Nf8MGDEz/wJIUoJIk2RVv3x0hqsujGvfE8FJIJ4fYmo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=UzOoGC9c2NFelxY+U38dsUUyyH8Bn0OGNBhjMdJuFGmcXd6MbqeGx8k2dHK34nijGrYGLPUKv73icl1GH3QvhdLLWXjcxRABcPSEwD4icl8aF4gJJgTFaUms+FPWERu+Hw3ACFB2Q5dj2gp0XFllG/EFgMRdYqJPUZ474HUI798=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TjBQFreH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TjBQFreH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA453C4CEE3;
	Tue, 15 Jul 2025 23:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752623430;
	bh=Nf8MGDEz/wJIUoJIk2RVv3x0hqsujGvfE8FJIJ4fYmo=;
	h=From:Date:Subject:To:Cc:From;
	b=TjBQFreHWuefSp915+rubod8P2TLSGEow/uNmGnraiIN6EDDk32klOHKVzfR2J690
	 YmyDhzShGG0ukxB0BOEWb4rzldeDFhv1JizD7dFeI3AhkRBvBKH/tEld4G9qJu3oKo
	 2YYMoEZ/kU67hxM9O+A8MRDUDMmbp4QlaK079nUCxQXd1NkfgwULVmz3Cos900m0H+
	 3v6rGLYoUwe3ZfJiNrMOjs+Gi4W66sCFVcdrUhG0HDFl+0r7crQAu+d1u65SGNsjB7
	 lHPSVozqBawxkM7kSRMZxktK4jmzNsdQBNI3fgGIQYkldP2Y5AVJqG48ARXbEsVwzZ
	 Omz2lI3bylVAQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 15 Jul 2025 16:50:22 -0700
Subject: [PATCH] drm/amdgpu: Initialize data to NULL in
 imu_v12_0_program_rlc_ram()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250715-drm-amdgpu-fix-const-uninit-warning-v1-1-9683661f3197@kernel.org>
X-B4-Tracking: v=1; b=H4sIAD3pdmgC/x2NQQqDQAxFryJZN+AoY8GrSBdTE6dZGCWjbUG8u
 8Hde/D4/4DCJlygrw4w/kqRRV3Co4LxkzQzCrlDUzexfoaIZDOmmfK64yR/HBctG+4qKhv+kjl
 kpHcXJo4U2pjAl1Zjb++X4XWeFw79tWh1AAAA
X-Change-ID: 20250715-drm-amdgpu-fix-const-uninit-warning-db61fe5d135a
To: Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Likun Gao <Likun.Gao@amd.com>, Hawking Zhang <Hawking.Zhang@amd.com>, 
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2109; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Nf8MGDEz/wJIUoJIk2RVv3x0hqsujGvfE8FJIJ4fYmo=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBllL11COO+WX17P3z/DtWp10GLvvwn6EtOmrxK2WjLZv
 kLkwJUpHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiqz0Y/mmllKq0rMrV2mLF
 zNRS8FErvmTdvbLypLZF+fVMTrbnnzIynMmWkd1SY561+i+TzUZ+D1G/mIVLrwbfsluyZW+zJIM
 8CwA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After a recent change in clang to expose uninitialized warnings from
const variables and pointers [1], there is a warning in
imu_v12_0_program_rlc_ram() because data is passed uninitialized to
program_imu_rlc_ram():

  drivers/gpu/drm/amd/amdgpu/imu_v12_0.c:374:30: error: variable 'data' is uninitialized when used here [-Werror,-Wuninitialized]
    374 |                         program_imu_rlc_ram(adev, data, (const u32)size);
        |                                                   ^~~~

As this warning happens early in clang's frontend, it does not realize
that due to the assignment of r to -EINVAL, program_imu_rlc_ram() is
never actually called, and even if it were, data would not be
dereferenced because size is 0.

Just initialize data to NULL to silence the warning, as the commit that
added program_imu_rlc_ram() mentioned it would eventually be used over
the old method, at which point data can be properly initialized and
used.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2107
Fixes: 56159fffaab5 ("drm/amdgpu: use new method to program rlc ram")
Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/imu_v12_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/imu_v12_0.c b/drivers/gpu/drm/amd/amdgpu/imu_v12_0.c
index df898dbb746e..8cb6b1854d24 100644
--- a/drivers/gpu/drm/amd/amdgpu/imu_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/imu_v12_0.c
@@ -362,7 +362,7 @@ static void program_imu_rlc_ram(struct amdgpu_device *adev,
 static void imu_v12_0_program_rlc_ram(struct amdgpu_device *adev)
 {
 	u32 reg_data, size = 0;
-	const u32 *data;
+	const u32 *data = NULL;
 	int r = -EINVAL;
 
 	WREG32_SOC15(GC, 0, regGFX_IMU_RLC_RAM_INDEX, 0x2);

---
base-commit: fff8e0504499a929f26e2fb7cf7e2c9854e37b91
change-id: 20250715-drm-amdgpu-fix-const-uninit-warning-db61fe5d135a

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

