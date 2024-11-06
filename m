Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCA6646;
	Wed,  6 Nov 2024 13:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899309; cv=none; b=luw46ougDomOsBvXr50tc7U4odeS/8AHzZfmYDg8jfX5G9fZZ5AhlpunD5kq2Hox1SwhXvzNbV5RWldv1+RfaXUiWyClDRZhaXNrBZDfpznvAPpkBloxtN7tsy6MLl3SUs6Kcx8RAWvsSzjCQGx3Yp6wEOcOdnoe7It5qw11BCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899309; c=relaxed/simple;
	bh=G8/w+zWSLFfSMm1LOb6vi35ctVeM8FhHf3aH03otxpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BP5hVcZljXoycYsO1aXoj6/4EHvxRDRgDSgciqqT9QcdZw/Wzs8N7LSmGbiCi+zDcaDV0HD7IN1ZMD5874z9vkuTA7c628lOln7UI2caaIp/AQA5U/VFl2dGaZrY9fybej/lJvF42k43zocdRWWGl8NbSMld5S0MnbmVAr5tQE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/t8JOQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/t8JOQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BA5C4CECD;
	Wed,  6 Nov 2024 13:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899309;
	bh=G8/w+zWSLFfSMm1LOb6vi35ctVeM8FhHf3aH03otxpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/t8JOQQn9QAeRPyMcV/S/RWOd2C55/sBxQJk2lQx35w9mk7htorlMBCiCoxjjAg8
	 Pl8T9hsD+sV3UGkuxolcNUWx41tNm6wR9oAZyKV2huD2GnLh2Osjd8dJjT2rfesEM1
	 NGCY2BnvDaQqEImpQI+f0PKHjXtHpv59P1DGE+QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>
Subject: [PATCH 5.15 70/73] Revert "drm/mipi-dsi: Set the fwnode for mipi_dsi_device"
Date: Wed,  6 Nov 2024 13:06:14 +0100
Message-ID: <20241106120302.034028025@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Jason-JH.Lin" <jason-jh.lin@mediatek.com>

This reverts commit ac88a1f41f93499df6f50fd18ea835e6ff4f3200 which is
commit a26cc2934331b57b5a7164bff344f0a2ec245fc0 upstream.

Reason for revert:
1. The commit [1] does not land on linux-5.15, so this patch does not
fix anything.

2. Since the fw_devlink improvements series [2] does not land on
linux-5.15, using device_set_fwnode() causes the panel to flash during
bootup.

Incorrect link management may lead to incorrect device initialization,
affecting firmware node links and consumer relationships.
The fwnode setting of panel to the DSI device would cause a DSI
initialization error without series[2], so this patch was reverted to
avoid using the incomplete fw_devlink functionality.

[1] commit 3fb16866b51d ("driver core: fw_devlink: Make cycle detection more robust")
[2] Link: https://lore.kernel.org/all/20230207014207.1678715-1-saravanak@google.com

Cc: stable@vger.kernel.org # 5.15.169
Cc: stable@vger.kernel.org # 5.10.228
Cc: stable@vger.kernel.org # 5.4.284
Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_mipi_dsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -221,7 +221,7 @@ mipi_dsi_device_register_full(struct mip
 		return dsi;
 	}
 
-	device_set_node(&dsi->dev, of_fwnode_handle(info->node));
+	dsi->dev.of_node = info->node;
 	dsi->channel = info->channel;
 	strlcpy(dsi->name, info->type, sizeof(dsi->name));
 


