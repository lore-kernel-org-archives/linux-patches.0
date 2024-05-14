Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF63136651;
	Tue, 14 May 2024 10:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683060; cv=none; b=EFOCXAf2lxex5uj5wOMsFBedsMN9F3trvIniHBOwj4IaGc1x+apu5kGB1P+gvYi53WcmwLbkiS0/pLBRaB8W73UTogFiG7o70gitJXh+VAGxqT83ageUKYXYFwSDXgEj+OUc5Ky2VIvMfqgSjbXn2mRnRY3A1zZHSuc4bPaRSnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683060; c=relaxed/simple;
	bh=fXZkLPV3T71KBlt0ObUgITgTZJdOs4NPFb7n6uH8qGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuzeXunptnAHldwDy4728Cp5Bjel+RnCB0pOB4oGAr8tRRJ5j/nCl9cz+4SZVO5vrq+J/anYgijcaLKAeW2a0/UL94cO56a6AQc/cWpj1Ie87RWsPcF3pxnYVQtJaPThoH3fLp69j5ycEqRKGviAeYCi6oC5kuNzeW2vKpkFpGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsEzsoGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsEzsoGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA02C2BD10;
	Tue, 14 May 2024 10:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683060;
	bh=fXZkLPV3T71KBlt0ObUgITgTZJdOs4NPFb7n6uH8qGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsEzsoGR+v/JqqPJNPFnN1VvorpNPjhTRXkoGx2k7NwUzxpKz9AOFADNGqS49oFy8
	 P8ggcgJmGsqc2civOXuzB/NcJG6zX5wBQkbHrtZeWgU3OBexVa6FgapUQY91JwRs05
	 Nh1x08ZTbFkY/iVF01V568WuhDVMzfD15NalibAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ma <li.ma@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 160/336] drm/amd/display: add DCN 351 version for microcode load
Date: Tue, 14 May 2024 12:16:04 +0200
Message-ID: <20240514101044.643253632@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Ma <li.ma@amd.com>

[ Upstream commit d4396924c3d44f34d0643f650e70892e07f3677f ]

There is a new DCN veriosn 3.5.1 need to load

Signed-off-by: Li Ma <li.ma@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 718e533ab46dd..0d3e553647993 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -147,6 +147,9 @@ MODULE_FIRMWARE(FIRMWARE_NAVI12_DMCU);
 #define FIRMWARE_DCN_35_DMUB "amdgpu/dcn_3_5_dmcub.bin"
 MODULE_FIRMWARE(FIRMWARE_DCN_35_DMUB);
 
+#define FIRMWARE_DCN_351_DMUB "amdgpu/dcn_3_5_1_dmcub.bin"
+MODULE_FIRMWARE(FIRMWARE_DCN_351_DMUB);
+
 /* Number of bytes in PSP header for firmware. */
 #define PSP_HEADER_BYTES 0x100
 
@@ -4776,6 +4779,9 @@ static int dm_init_microcode(struct amdgpu_device *adev)
 	case IP_VERSION(3, 5, 0):
 		fw_name_dmub = FIRMWARE_DCN_35_DMUB;
 		break;
+	case IP_VERSION(3, 5, 1):
+		fw_name_dmub = FIRMWARE_DCN_351_DMUB;
+		break;
 	default:
 		/* ASIC doesn't support DMUB. */
 		return 0;
-- 
2.43.0



