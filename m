Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6D217E90E;
	Mon, 27 May 2024 19:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837165; cv=none; b=UGxMrnSX/dDsrHSt63nNl+vsy2HoabaWQMhNSJDdjxSclFokek52Y/3IW7j5fJIrBhwCOwO2h+djS4xz2XgwzH6xUU3RWvvawIIvopTqjykRKMtsZEUu2DjRNPccZ57Cbu9LhpIWI1ifHdIdUU3Y6sHkdT6ZepJ7fz4g4Y2UNXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837165; c=relaxed/simple;
	bh=jcb1mabQ332I/TRlyIxIOV6ygtbBP8cwbMHjZ1O8NN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=isiLAJkL9S0iYFE+lK2IPGt9pXTzV6WdqhdLsqjgh9HhjzrijXfvYIQ/gBrccT2/5PqD+n0RIMboNQF5sc5nXzpRbq5W9YloY5k5rwlKhd4YSHv7j1g/yraqG8go8X/d+5B0LLMes9G/KZoQgjFrI7FTZFDhdhskfAibHoX9M3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBcf60Tg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBcf60Tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035C3C2BBFC;
	Mon, 27 May 2024 19:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837165;
	bh=jcb1mabQ332I/TRlyIxIOV6ygtbBP8cwbMHjZ1O8NN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBcf60TgXvkNQgBGoca4X45XNLvxLycE2PlMDaojGHu1+WFy8cOA3psGXf6k3t/4r
	 XxTiCc5LH6wu+YnMMQx9IGzbmj78yPkzrFCZPqCbY/5mV7Zmr91Z0qssRa9EKC7I6T
	 ea5sJGvsz6tO/6Lzq4dlbwLKagY0mHF6SwuChTr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 335/427] drm/bridge: tc358775: Dont log an error when DSI host cant be found
Date: Mon, 27 May 2024 20:56:22 +0200
Message-ID: <20240527185632.521624023@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 272377aa0e3dddeec3f568c8bb9d12c7a79d8ef5 ]

Given that failing to find a DSI host causes the driver to defer probe,
make use of dev_err_probe() to log the reason. This makes the defer
probe reason available and avoids alerting userspace about something
that is not necessarily an error.

Fixes: b26975593b17 ("display/drm/bridge: TC358775 DSI/LVDS driver")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415-anx7625-defer-log-no-dsi-host-v3-6-619a28148e5c@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358775.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358775.c b/drivers/gpu/drm/bridge/tc358775.c
index 90a89d70d8328..fea4f00a20f83 100644
--- a/drivers/gpu/drm/bridge/tc358775.c
+++ b/drivers/gpu/drm/bridge/tc358775.c
@@ -610,10 +610,8 @@ static int tc_attach_host(struct tc_data *tc)
 						};
 
 	host = of_find_mipi_dsi_host_by_node(tc->host_node);
-	if (!host) {
-		dev_err(dev, "failed to find dsi host\n");
-		return -EPROBE_DEFER;
-	}
+	if (!host)
+		return dev_err_probe(dev, -EPROBE_DEFER, "failed to find dsi host\n");
 
 	dsi = devm_mipi_dsi_device_register_full(dev, host, &info);
 	if (IS_ERR(dsi)) {
-- 
2.43.0



