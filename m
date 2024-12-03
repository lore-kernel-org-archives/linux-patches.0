Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470101E3DF9;
	Tue,  3 Dec 2024 15:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238404; cv=none; b=pfRuQY5ioOLYdTQeOn5JM52rissigExXZ5zG1/TAxJDJWnJkqCFFU37v1k3ExaF0gJ7E4vFiN9bhhK7cUnLuHrsdWjBNAXVSjRq9NrX8VHYKG2C9yfHB8oynUQ7lwa5ge9PCgkwxJBUY2WxkI1tinpt+j9yMwsrs56L9XiPqd+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238404; c=relaxed/simple;
	bh=8EXJr3xud3klhrVKmhD0+BXiAY87Is9TGdU8PvQN1Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fh2wrq/07qKV+imrWK5ukFVJ9Z9cLR18SoRhHIkMVB8stx8jwjdiiVCshDVuObXkdAeL1uX62lhikxpPexjgeH8vXr1NKnniE+h5gYWqo4xKnmUZFbxbu0LQ1HsHFhYmfSOuQS8arReMU5aow/ZiaGbrXzXiBYS1KnlRPyDRgTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d95Elg5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d95Elg5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0871C4CECF;
	Tue,  3 Dec 2024 15:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238404;
	bh=8EXJr3xud3klhrVKmhD0+BXiAY87Is9TGdU8PvQN1Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d95Elg5ZHUsB6iWbZFsjy80kKIpzXD8WijctoHWtx6mFbnl7xgYix7A2uI2kLFq1s
	 vTBJ/XTGZLGQo92S1zx6t19lBiNCbQ+eEvIaxyebfbAk019uFKx6kVEiPt1eltE3vz
	 jdCnHFcw0tP/AUkrTYWKiw+nRDqI+F3TRJaJ9/5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 238/817] drm/imx: Add missing DRM_BRIDGE_CONNECTOR dependency
Date: Tue,  3 Dec 2024 15:36:50 +0100
Message-ID: <20241203144005.048854796@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit f673055a46784ccea04465b9213e999f7bc5187e ]

When drm/bridge-connector was moved to DRM_DISPLAY_HELPER not all
users were updated. Add missing Kconfig selections.

Fixes: 9da7ec9b19d8 ("drm/bridge-connector: move to DRM_DISPLAY_HELPER module")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240906063857.2223442-1-alexander.stein@ew.tq-group.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/imx/ipuv3/Kconfig b/drivers/gpu/drm/imx/ipuv3/Kconfig
index f083d313d1d3a..7a427551f4341 100644
--- a/drivers/gpu/drm/imx/ipuv3/Kconfig
+++ b/drivers/gpu/drm/imx/ipuv3/Kconfig
@@ -13,6 +13,7 @@ config DRM_IMX_PARALLEL_DISPLAY
 	tristate "Support for parallel displays"
 	depends on DRM_IMX
 	select DRM_BRIDGE
+	select DRM_BRIDGE_CONNECTOR
 	select DRM_PANEL_BRIDGE
 	select VIDEOMODE_HELPERS
 
@@ -31,6 +32,7 @@ config DRM_IMX_LDB
 	depends on COMMON_CLK
 	select MFD_SYSCON
 	select DRM_BRIDGE
+	select DRM_BRIDGE_CONNECTOR
 	select DRM_PANEL_BRIDGE
 	help
 	  Choose this to enable the internal LVDS Display Bridge (LDB)
-- 
2.43.0



