Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E9F54765;
	Wed,  6 Nov 2024 13:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899097; cv=none; b=TUZnE+8xTbk/RtTfBEFl/bw/oZ2nmrLvb50xyAUw2VBRxE43kzIbS+bRfKCIiOQ1gNpM5M53cc/Fia1OHjkLpFQkMe96ybqVYLUQV1MDafw9tZuKjiHorNIN1d6o3DucaXjkbVYm+6dFYwPxt7/fqFhtPG38o8f+fFekRXkp7c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899097; c=relaxed/simple;
	bh=ozgyNJ/9Hmdz/kGsY/ziSCDULa4UdbdcFUQYjgAt3sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xen85IdtAYOMlawS+01bkl1IqnnqPIHQUvS2hKsl0JQYRR/F0Qpg7VraGOF7V+R/PZD2UJ3KTkXeaQs8+XZHGNxb7jJNCjxFBtnVtYNZrZB6905OSPF0jJezRpqfaf0ymLPpz8n/iGZkmQtFDzWJTIGyfhj+wVual4FZsh8NPWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrbzTb23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrbzTb23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5E1C4CECD;
	Wed,  6 Nov 2024 13:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899096;
	bh=ozgyNJ/9Hmdz/kGsY/ziSCDULa4UdbdcFUQYjgAt3sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrbzTb2365KCe1N1/5sNbElIqdEQxbbxEXISEdJ3tQoIva4AaDZvYEJFlN6T2TMR2
	 T+YSe5zhN/dyIEqrR0Wy8vVZY76JwXs+Dt9LaqPgs+K/nKU34vK14dbVkkE1H/nbsJ
	 OWTm78DbcjgBaypFyta29dGojgmwd3eYV4mtGMYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>
Subject: [PATCH 5.4 459/462] Revert "drm/mipi-dsi: Set the fwnode for mipi_dsi_device"
Date: Wed,  6 Nov 2024 13:05:52 +0100
Message-ID: <20241106120342.840494585@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Jason-JH.Lin" <jason-jh.lin@mediatek.com>

This reverts commit 22b8ac608af5b8a859ed9dc0b15f31dea26cdbb0 which is
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
 


