Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB4A17727;
	Mon, 27 May 2024 19:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838465; cv=none; b=NN3+vvfPq3phGNZcuzY8TjLm8Qjg6BktLi3uxg/bEPpSebCnehmGyGPahGZ9xNUaRCxsUYGjMMY+s9T9X7mHNGnvMjWskIRZu710r7gjVbB28Zkw5aDkU+/9mtVBrhR4qxyeiTpx0wqPdp92TrrbOXXMLqJ2y+bCYJoNxtcsK/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838465; c=relaxed/simple;
	bh=Fxc6NiPff9R+ubeYaiy0JYdxtKMikoX46fgL9ReRK7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A2r3QL+SmY9vBMYGWPG8uBJd5LQ4sgreJ5bRlGiubGVhphLedha3rvXYPUNrOjRdbVe5d4mPxmInlDJRBToQsgfXSiMimEM+pimjukDg2rRQdhdMmt9RjTeXXqhVxmLW40nz/377wovdN5HQ4djwwK7xu10Z8M2dohME59pT2qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RYCVQO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RYCVQO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65E8C2BBFC;
	Mon, 27 May 2024 19:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838465;
	bh=Fxc6NiPff9R+ubeYaiy0JYdxtKMikoX46fgL9ReRK7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RYCVQO4gjW96Mec5CUFYQYHixdjOH8iM7GovBxrP4YRQz1Psh5P8hRKWHFIRuEVx
	 JbnUdwl0aJC9Hd+WJe4fC3+RYFEVb7vc8U+A7GGXwYML+UN1eqUc6hix5KrWiGlmFs
	 JfVsjVw/Fk1Yh5nX7kTP9bTx/8Qb1Yj3y4La+4l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 404/493] drm/bridge: anx7625: Dont log an error when DSI host cant be found
Date: Mon, 27 May 2024 20:56:46 +0200
Message-ID: <20240527185643.502349344@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit ef4a9204d594fe959cdbc7418273caf4001535c8 ]

Given that failing to find a DSI host causes the driver to defer probe,
make use of dev_err_probe() to log the reason. This makes the defer
probe reason available and avoids alerting userspace about something
that is not necessarily an error.

Fixes: 269332997a16 ("drm/bridge: anx7625: Return -EPROBE_DEFER if the dsi host was not found")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415-anx7625-defer-log-no-dsi-host-v3-1-619a28148e5c@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 29d91493b101a..4ee5614a26236 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2076,10 +2076,8 @@ static int anx7625_setup_dsi_device(struct anx7625_data *ctx)
 	};
 
 	host = of_find_mipi_dsi_host_by_node(ctx->pdata.mipi_host_node);
-	if (!host) {
-		DRM_DEV_ERROR(dev, "fail to find dsi host.\n");
-		return -EPROBE_DEFER;
-	}
+	if (!host)
+		return dev_err_probe(dev, -EPROBE_DEFER, "fail to find dsi host.\n");
 
 	dsi = devm_mipi_dsi_device_register_full(dev, host, &info);
 	if (IS_ERR(dsi)) {
-- 
2.43.0



