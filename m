Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571331B3928;
	Mon, 23 Dec 2024 16:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970705; cv=none; b=Si1hBMKi7UO5QpyRANh9tsQ0Y9b/f8VZfxA21bE9WBfggNAtXEyBPOD3mIxWyz/6bGnbrry2DSGEaJcE5dlVlOTnLV/sTC92v9t/W8+Z+QVV6KtQy1q/E2/QRBUKh6SNTwyfde6K0h3dBdrjARhUIY+xIykRBrxAh13/CPV6rT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970705; c=relaxed/simple;
	bh=mtisTr0MCmSrpP6vcSrQHBeVsXONs1zu/f+1UJVteks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LswpydqgV1wF60q1ydveN7kMQl7Uug975ahTlfCczTUuU5KvFoI3Ocnz1wglQaAnaKQI4mK6vwgPRr/ZZMg5OGgsavAI5KEYvujTpSNtkH7X72T6mDMjTbKoimPfk/XZgeoJENFzlIzCW+RT1hCX5DoBFV7Mnj9XTdMl312fyCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P46Ug9mm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P46Ug9mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0552C4CED3;
	Mon, 23 Dec 2024 16:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970705;
	bh=mtisTr0MCmSrpP6vcSrQHBeVsXONs1zu/f+1UJVteks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P46Ug9mmlxWWrNu6o7PX7IT3zomvugjcsybCw8KMDOOiCDkek3mJxUFPDyUtGaY4v
	 IYOuWsA4HfKoGlzgwn/g9mvVWVBX2/YJMkPEurjd7i2rWzwmIn0VKI3kWPmdBCUQLu
	 1e8AT0VYF33RO0PhbCBQ/8LZV487xtt589gnX6Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 45/83] drm/panel: novatek-nt35950: fix return value check in nt35950_probe()
Date: Mon, 23 Dec 2024 16:59:24 +0100
Message-ID: <20241223155355.375873912@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f8fd0968eff52cf092c0d517d17507ea2f6e5ea5 ]

mipi_dsi_device_register_full() never returns NULL pointer, it
will return ERR_PTR() when it fails, so replace the check with
IS_ERR().

Fixes: 623a3531e9cf ("drm/panel: Add driver for Novatek NT35950 DSI DriverIC panels")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241029123957.1588-1-yangyingliang@huaweicloud.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241029123957.1588-1-yangyingliang@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt35950.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-novatek-nt35950.c b/drivers/gpu/drm/panel/panel-novatek-nt35950.c
index ec2780be74d1..a92a7cd697f4 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt35950.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35950.c
@@ -577,9 +577,9 @@ static int nt35950_probe(struct mipi_dsi_device *dsi)
 			return dev_err_probe(dev, -EPROBE_DEFER, "Cannot get secondary DSI host\n");
 
 		nt->dsi[1] = mipi_dsi_device_register_full(dsi_r_host, info);
-		if (!nt->dsi[1]) {
+		if (IS_ERR(nt->dsi[1])) {
 			dev_err(dev, "Cannot get secondary DSI node\n");
-			return -ENODEV;
+			return PTR_ERR(nt->dsi[1]);
 		}
 		num_dsis++;
 	}
-- 
2.39.5



