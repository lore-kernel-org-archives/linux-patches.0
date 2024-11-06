Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222E91E25F7;
	Wed,  6 Nov 2024 12:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896913; cv=none; b=ku8iHay9dnWc2F7bBrxR0ikly08IcUj+pg+MgbLBcJIVeEfkN7ksev9XOrdftkEkMnyZFOMDjAkrgWCYQQEMQGPyO97XvWDMGTXs836o2jaLf4eEmL0iQ9XSaCOQoGOKRcgDoUVoDD2ZnFJWZFf5qZxNiwXGHjXHLDBvaDHQ1xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896913; c=relaxed/simple;
	bh=KpjctIwnKaryIfKDlqnaGWLnbKDM8XKwRGIN4BC+EQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4NTcQ7yREGLqom8yiiUlNStmV1JHDFlGwDvrxfRX+gUHwAG57PIpKRiZaAsiX/lahfhF8FGxLe+1wlVBP2W7btoHNdLuOzOXGstU2QgukeA8R8uaG7rfWBlyoSeLIbriSNwK138M9O67nuVwtb1ulV2kkdnl/Yc+qtmbrgCI2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeGBLhJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeGBLhJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EEFC4CECD;
	Wed,  6 Nov 2024 12:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896912;
	bh=KpjctIwnKaryIfKDlqnaGWLnbKDM8XKwRGIN4BC+EQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aeGBLhJkx12Y9u/jNTvDELXWi+oZOvj/CJuuDDnvlEFzzix0UGYySVIK8CreL/gV+
	 elMGEeG5WNlK0LhgnMJXi0sk7epYNdASH7EuSAe3ts0kX1MA5rJTNgDHSXOirDlVDh
	 zQNnCGFcYEAzjvVO+QqpP+RyqE+KU0S+e5tfrUuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>
Subject: [PATCH 5.10 107/110] Revert "drm/mipi-dsi: Set the fwnode for mipi_dsi_device"
Date: Wed,  6 Nov 2024 13:05:13 +0100
Message-ID: <20241106120306.127049335@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Jason-JH.Lin" <jason-jh.lin@mediatek.com>

This reverts commit 139c27648f8d3b2283f74715d8e7f0df7f5e55ca which is
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
 


