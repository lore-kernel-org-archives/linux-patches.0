Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7052DC129;
	Mon,  1 Apr 2024 16:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988885; cv=none; b=gCgd4s/8oHwZP44mxi0hPSjbhnBohLbW8/j6iSDT8w29braWObkBfQdgccCD2JBSVUqQUkHAa6Z6O7rJHvOXeZ1uXN5JjhT6ZQ4wgIDFtpQGlf61FzUrjtZrsLs6MRwbu1UN07ZCx+um9O36EUm8ShnN33/TNhaZOomAyoQ1GCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988885; c=relaxed/simple;
	bh=wdFGNrBfZW1E3ISOJhfHktdoAltlc96DRsBHp1Nd6ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fObYx75Bpg2QWab7B8qcPunTWAfrjpznlJOOnbWGgPlReCDN/1ivyAUtS+g4P6VU9LqSGsnOm7ZEeIPftnXzYLfzaaTTN3Q0dkrz33i2kAG7V3g/rrenDG0YIxANFp7vJqKk9A2lQ20LgFPBA3dLKu94sIsQW6AK+O8hKs++EqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0w3XJsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0w3XJsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D3FC433F1;
	Mon,  1 Apr 2024 16:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988885;
	bh=wdFGNrBfZW1E3ISOJhfHktdoAltlc96DRsBHp1Nd6ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0w3XJsnFKcqBmPO3WEa/yx+RmIr4mWgpPm2e2J5+SmmEHxEp4jUmfqeHJ1KGmNLy
	 68ggXHFqUN3liVjdP2WFBwKSz/gwDd78qfDkDSF14+NmCU2gXMg1MMUftdineXaUbD
	 WYoeEldNnmbqdZWZt3f2DFZTAeVw2QEe1gvjfkQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ma <li.ma@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 290/432] drm/amd/swsmu: modify the gfx activity scaling
Date: Mon,  1 Apr 2024 17:44:37 +0200
Message-ID: <20240401152601.819004215@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Ma <li.ma@amd.com>

commit 6601c15c8a0680edb0d23a13151adb8023959149 upstream.

Add an if condition for gfx activity because the scaling has been changed after smu fw version 5d4600.
And remove a warning log.

Signed-off-by: Li Ma <li.ma@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.7.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c       |    2 --
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c |    5 ++++-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
@@ -229,8 +229,6 @@ int smu_v14_0_check_fw_version(struct sm
 		smu->smc_driver_if_version = SMU14_DRIVER_IF_VERSION_SMU_V14_0_2;
 		break;
 	case IP_VERSION(14, 0, 0):
-		if ((smu->smc_fw_version < 0x5d3a00))
-			dev_warn(smu->adev->dev, "The PMFW version(%x) is behind in this BIOS!\n", smu->smc_fw_version);
 		smu->smc_driver_if_version = SMU14_DRIVER_IF_VERSION_SMU_V14_0_0;
 		break;
 	default:
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c
@@ -261,7 +261,10 @@ static int smu_v14_0_0_get_smu_metrics_d
 		*value = metrics->MpipuclkFrequency;
 		break;
 	case METRICS_AVERAGE_GFXACTIVITY:
-		*value = metrics->GfxActivity / 100;
+		if ((smu->smc_fw_version > 0x5d4600))
+			*value = metrics->GfxActivity;
+		else
+			*value = metrics->GfxActivity / 100;
 		break;
 	case METRICS_AVERAGE_VCNACTIVITY:
 		*value = metrics->VcnActivity / 100;


