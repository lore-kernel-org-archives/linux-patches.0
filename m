Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E406118DB2A;
	Wed, 25 Feb 2026 01:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983118; cv=none; b=tAs+oeaY+hV65NUz27k7KVNS0RCOSh68VbsT3MJQzyil9pPPTJ3LJu/EQVZ3SnOmZgYk2+TiUKEpLszsY2DZKK50EXfOnoDbCY+KOhxGlXejVs8sFCHTP985OfcL/xvxUxzxd2COzBrIu2g9528owQVBb9f+t6JYtszuv2UWfPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983118; c=relaxed/simple;
	bh=RiEiJ+9DEwbr6MbPAzW1LHlDvLJZ3WmOESu580ShAmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtbrQRtJdYtlw0mZt8UsJCBolNeb62jF5y129vFZCrCP5Z/i6v0bL7V+x/za0kK+OovNI/mUDIDNZSykdWoShVgjsb9m0v+wq2cdBgC9qcfMdE36br3F+roy/tSqhFGMsOZF9pC7SF6dSQw4O023HxPHFNi/6DsgtyTKLkKAF6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIkFS5Dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIkFS5Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC66C116D0;
	Wed, 25 Feb 2026 01:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983117;
	bh=RiEiJ+9DEwbr6MbPAzW1LHlDvLJZ3WmOESu580ShAmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIkFS5DcMHoMvFzx3BQCtJqfHzrEl04MyVFmz0cVdm7HX0ZrBWdYdBaoZgLLKzeA8
	 GoliCskv91poVvRh1ZeYET7kRQ8N9IxP1j+OL4k4fppAOl2+BsVUJAajO4K2zzw5Q7
	 BhoLcbmIlSjtjZnuyp6tVP2rnTWdXvVOcVUOdc/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 277/781] drm/amd/pm: Fix unneeded semicolon warning
Date: Tue, 24 Feb 2026 17:16:26 -0800
Message-ID: <20260225012406.490736511@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 05138e8ff287188be7b1bedf022c8b4fd1f09a25 ]

Fix the warning reported.
drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_12_ppt.c:909:3-4: Unneeded semicolon

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601182157.r1AfndME-lkp@intel.com/
Fixes: b480f573a8ab ("drm/amd/pm: Use gpu metrics 1.9 for SMUv13.0.12")
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_12_ppt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_12_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_12_ppt.c
index 9e635f733fbfd..370326ec65d94 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_12_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_12_ppt.c
@@ -922,7 +922,7 @@ void smu_v13_0_12_get_gpu_metrics(struct smu_context *smu, void **table,
 			gpu_metrics->gfx_below_host_limit_total_acc
 				[i] = SMUQ10_ROUND(
 				metrics->GfxclkBelowHostLimitTotalAcc[inst]);
-		};
+		}
 	}
 
 	gpu_metrics->xgmi_link_width = metrics->XgmiWidth;
-- 
2.51.0



