Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147941B14E7;
	Thu,  6 Jun 2024 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683385; cv=none; b=QzTGh3A9bmd0UBO16jlYYwrAKBCmLVw1nVc92iO0rmA9ofPQAg7gv7UMkID/pTHDMmU0pdZix/ypTNmfSszMa3QMsPGuZeMTKh7jku3Zk93N+zSrSa2njAwYM1j8acAzR7sTR0hjkRqN0jKDltTGFcnYDu7S23M8iHYFwinIDSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683385; c=relaxed/simple;
	bh=GAU+hJ8KZZxU14Cvusjj9zOkQ+y/xWlCUll4PbAr9iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lORBVqMzztMoA0h6OKFRAfV2zivJdIpEKJqw4eBiYlXIRC0vgNO+jxnI+jcDyyGQeNFpT2M9VCkKflD6hTQEL2hR1uRB6LhbdSGKHTn7Ems2TFo+d9frELaZpdbgTvT2UmK2QnbEK9UNqtXMc0jLunTjO1HGltKD8Q1xmPFfeX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVoriWe8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVoriWe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A04C32781;
	Thu,  6 Jun 2024 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683385;
	bh=GAU+hJ8KZZxU14Cvusjj9zOkQ+y/xWlCUll4PbAr9iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVoriWe82bfoDLrMx8q3u3/Sw6JiaiOQ4j8q2N0eHTmUZqTGQtXkEBdX0bS4dOotB
	 f5WddjhiYa6EHaobMzqrt5CSX0TOxqGq4bgrlOF921vtQRVRJOmM6ZUDboHSm5E0nK
	 uI0Fs8NZILqOuKG58BhDVgOqaeab7OOh3fqtrzbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 326/744] drm/panel: novatek-nt35950: Dont log an error when DSI host cant be found
Date: Thu,  6 Jun 2024 15:59:58 +0200
Message-ID: <20240606131742.892791271@linuxfoundation.org>
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

[ Upstream commit 5ff5505b9a2d827cae3f95dceba258c963138175 ]

Given that failing to find a DSI host causes the driver to defer probe,
make use of dev_err_probe() to log the reason. This makes the defer
probe reason available and avoids alerting userspace about something
that is not necessarily an error.

Fixes: 623a3531e9cf ("drm/panel: Add driver for Novatek NT35950 DSI DriverIC panels")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415-anx7625-defer-log-no-dsi-host-v3-8-619a28148e5c@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt35950.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-novatek-nt35950.c b/drivers/gpu/drm/panel/panel-novatek-nt35950.c
index 412ca84d05811..4be5013330ec2 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt35950.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35950.c
@@ -565,10 +565,8 @@ static int nt35950_probe(struct mipi_dsi_device *dsi)
 		}
 		dsi_r_host = of_find_mipi_dsi_host_by_node(dsi_r);
 		of_node_put(dsi_r);
-		if (!dsi_r_host) {
-			dev_err(dev, "Cannot get secondary DSI host\n");
-			return -EPROBE_DEFER;
-		}
+		if (!dsi_r_host)
+			return dev_err_probe(dev, -EPROBE_DEFER, "Cannot get secondary DSI host\n");
 
 		nt->dsi[1] = mipi_dsi_device_register_full(dsi_r_host, info);
 		if (!nt->dsi[1]) {
-- 
2.43.0



