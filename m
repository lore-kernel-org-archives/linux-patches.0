Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217D33ACA4D;
	Sat, 30 May 2026 18:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166325; cv=none; b=puu67XtrdLDVo8F4DrchvaFmAqlv6jvfvDi2gCN6W7pYVNxTdysQwecXz4RjzMMlpwnFWBRzLIv/atRu7pVgCNDojiGmEX+YSdlY1wejyisGdh9YUaLBtyY32VfxGbSt0mmBz6G0sIqN/U49KuQhpwu/V+ANnT37qnAwbsrsflI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166325; c=relaxed/simple;
	bh=olzEY6Ajse+q0095HNscoFgbyrz0SpvNrhnlt/ov6Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xf55PSOOTF4GCLosKlGLYnnMZXA4kg30slvuBEqRpv5BrabcxIZ8OAG3brGrO1KbRjb6SstYyAhLosX+jpqNIkWkNpX95MLd6lY+tHHzhZrjaXx8n8ARqsgvI7FRBoTWMD23u7OkPQsjoBnCVTm/Fexm2B9umrFw4eF+QFyvAuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTy0hdCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTy0hdCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631EC1F00893;
	Sat, 30 May 2026 18:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166324;
	bh=qkWfA3952HLfIuRV3o7pv4ysPiGzcPwqOlPLBB48NGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTy0hdCqyrDe3/g1CQWnr8puKrEjGg0jS9F1h7zaaMRcN2v9TFTPIfc90ownbFa6k
	 +Q9/JNrGzLO2cBRLibeYp1NUTFQ2BbUc8/Bw7BaKzt9SHCpMwVvypoGzjkdNwsoSzd
	 TxYDvRyAS5xSVmslj5Tf4Fka0gApyUsbJ2/Hkc8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 339/589] drm/amd/pm/ci: Fix powertune defaults for Hawaii 0x67B0
Date: Sat, 30 May 2026 18:03:40 +0200
Message-ID: <20260530160233.805977814@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit d784759c07924280f3c313f205fc48eb62d7cb71 ]

There is no AMD GPU with the ID 0x66B0, this looks like a typo.
It should be 0x67B0 which is actually part of the PCI ID list,
and should use the Hawaii XT powertune defaults according to
the old radeon driver.

Fixes: 9f4b35411cfe ("drm/amd/powerplay: add CI asics support to smumgr (v3)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
index 581ade4111426..04e2e7e44e7ce 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -244,7 +244,7 @@ static void ci_initialize_power_tune_defaults(struct pp_hwmgr *hwmgr)
 		smu_data->power_tune_defaults = &defaults_hawaii_pro;
 		break;
 	case 0x67B8:
-	case 0x66B0:
+	case 0x67B0:
 		smu_data->power_tune_defaults = &defaults_hawaii_xt;
 		break;
 	case 0x6640:
-- 
2.53.0



