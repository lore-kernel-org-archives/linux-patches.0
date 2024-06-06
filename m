Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D011B1436;
	Thu,  6 Jun 2024 14:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683380; cv=none; b=dvgw9+S/xRt63gtnZQhq/5KT4ZNICa2Ljetdha5oKZLXnYUZF8ykC4QS/3zo79vjF5vtI0hxsSp3pAFtIWNea5Mr6C1p/QeL4M1G9skw4o05blTQoHeX3xsNjU7/bTr9R8SV8IUD808GZeetOkvYQhhaAjo8fCJ1rUl9ooUZE+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683380; c=relaxed/simple;
	bh=Y9+9hqjKZtMDdb20D8ZezZ1PCVkg+wYI0nmOV3PN3EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XLOGOJkRfY92Xlf9mYIjhmMH2Z9DJSzOPcq8Zj4SxUFVHlu0GSarp4RdKHMsYaTP3bcKUMHGsxOhRNmWH2Q/2wFNQc/PWa0k3qRnDn2fAp+AUFYbYaLMBeBhw/vJvhi14OGbPM5UTS+qm7ZpEHsQONJZpfjzkjQJYI8o0XqajPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzFvFuVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzFvFuVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F06C32781;
	Thu,  6 Jun 2024 14:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683380;
	bh=Y9+9hqjKZtMDdb20D8ZezZ1PCVkg+wYI0nmOV3PN3EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzFvFuVC0K3b1g40MmLxSFhxPnSlODi1LZ3xh4lZ59VITT+2mDxop4afxV3W2IPT2
	 v9UC4BA2O7RFwr8hTBEPC4xcmDXOoN+nRMkGG/gaQwPVt7moWnuMrxe7pjY4FdLHlF
	 Fug/2cfdDWGmZ3ahgOZZPaIhsbbq1g0FCkCWb1dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 322/744] drm/bridge: lt9611: Dont log an error when DSI host cant be found
Date: Thu,  6 Jun 2024 15:59:54 +0200
Message-ID: <20240606131742.769202232@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit cd0a2c6a081ff67007323725b9ff07d9934b1ed8 ]

Given that failing to find a DSI host causes the driver to defer probe,
make use of dev_err_probe() to log the reason. This makes the defer
probe reason available and avoids alerting userspace about something
that is not necessarily an error.

Fixes: 23278bf54afe ("drm/bridge: Introduce LT9611 DSI to HDMI bridge")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415-anx7625-defer-log-no-dsi-host-v3-4-619a28148e5c@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
index 9663601ce0981..89bdd938757e1 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -760,10 +760,8 @@ static struct mipi_dsi_device *lt9611_attach_dsi(struct lt9611 *lt9611,
 	int ret;
 
 	host = of_find_mipi_dsi_host_by_node(dsi_node);
-	if (!host) {
-		dev_err(lt9611->dev, "failed to find dsi host\n");
-		return ERR_PTR(-EPROBE_DEFER);
-	}
+	if (!host)
+		return ERR_PTR(dev_err_probe(lt9611->dev, -EPROBE_DEFER, "failed to find dsi host\n"));
 
 	dsi = devm_mipi_dsi_device_register_full(dev, host, &info);
 	if (IS_ERR(dsi)) {
-- 
2.43.0



