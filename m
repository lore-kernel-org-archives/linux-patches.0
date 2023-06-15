Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E428C14B
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 17:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570C8C433C0;
	Thu, 15 Jun 2023 17:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686848784;
	bh=asEfz/75vspGdinpvKRL1iHutMtcwa53kraukBRsmfQ=;
	h=From:Subject:Date:To:Cc:From;
	b=j5JH4avbj2tG9JUBccBSUjSeCNBfNdJfhzbk/N91SscvL7lXdFDzCo/BwZT0Fpv1d
	 Vs/j0gFQRnO/z/j5V6bX5wgIMEZ7gHPJvpL3h4QS3BBYI6zr3W7r9BxkUH7uMV8FP1
	 47jfj4AkVt+XoBXUN+nmOlSJcxz4kt9tqGAmFBM1N5lU62uKQV6WrW/QoVFjrc47+S
	 k1dGae7xtJFHhXsP81GX5crAKf/qBBIpyeYsLnq1EfEWZ4DyXwD+dRfyRv9nMjyPZB
	 qAToGsEnJA936R/rMFMp5Cxd7rCqgGAE9bLbHJ4WgH6Tm+TXeIKrQfqDLa0dNchpkZ
	 I7z0ZMRde2l/g==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/2] drm/amdgpu: Fix instances of -Wunused-const-variable
 with CONFIG_DEBUG_FS=n
Date: Thu, 15 Jun 2023 10:06:07 -0700
Message-Id: <20230615-amdgpu-wunused-const-variable-wo-debugfs-v1-0-06efd224aebb@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAP9Ei2QC/x3Oyw6CMBCF4VcxXTuRixf0VYwh03aAidI2HQomh
 He3uPwX58tZlVBkEvU4rCrSzMLe5SiPB2UGdD0B29yqKqq6uJYXwNH2IcGSXBKyYLyTCWaMjPp
 DsHiwpFPfCdRFY6ih8lZXd5U5jUKgIzoz7KA+n0YOAiPGd1YitXOg1vjkJkABdjztqxCp4+//4
 PO1bT9H0NI8sAAAAA==
To: alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com
Cc: amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=861; i=nathan@kernel.org;
 h=from:subject:message-id; bh=asEfz/75vspGdinpvKRL1iHutMtcwa53kraukBRsmfQ=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCndrvwfOm5yblpuEylxNKxC4+nx/wful17VV2E/Jc337
 rvp3JyPHaUsDGIcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAi7zYwMrw8vl6mzfHJwwP3
 fjrveXpEKaHvZmbMz2arPxFq65VNrPYxMvT4d4u/mXeS3d6cvcfgyXmurR3OV9Wld/zaL/XHaMk
 zcUYA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Hi all,

After commit a25a9dae2067 ("drm/amd/amdgpu: enable W=1 for amdgpu"),
I see a few instances of -Wunused-const-variable with configurations
that do not enable CONFIG_DEBUG_FS, such as Alpine Linux's. This series
includes two patches to resolve each warning I see.

---
Nathan Chancellor (2):
      drm/amdgpu: Remove CONFIG_DEBUG_FS guard around body of amdgpu_rap_debugfs_init()
      drm/amdgpu: Move clocks closer to its only usage in amdgpu_parse_cg_state()

 drivers/gpu/drm/amd/amdgpu/amdgpu_rap.c |  2 -
 drivers/gpu/drm/amd/pm/amdgpu_pm.c      | 76 ++++++++++++++++-----------------
 2 files changed, 38 insertions(+), 40 deletions(-)
---
base-commit: d297eedf83f5af96751c0da1e4355c19244a55a2
change-id: 20230615-amdgpu-wunused-const-variable-wo-debugfs-308ce8e17329

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

