Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064129;
	b=XdAD0AwEbO8w3d15owQV0cJqgfu+Zk5AqFxeZTrGODGHcapgZx+LhEEgwQdco9747wsC
	 2UbbtfKHaKd5oMLABL1szXg7HP4ChmbokjDjY8Qgd9oqSmF6Fv/Y5rYTB2qRFmg4lt12l
	 cC46AcGBOMyucQttp6ZODDTl77o/zz90QSC4q2XIavHI8MiqpKmrEspeVNzCmZbL7A42Q
	 eG4mcr/tgFfpQdcBsRuk8JkTAgrQHZgdLIG/uKchsVwLBXyWBjPaSSbrm9EPJRbJrpqoF
	 EnEOCfQFg9l1JPuWfiEb0j8GxuJkU2ZJGYbtGM8FjkOG9z5+qdkoQq6L9XQLW04/g1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4cW+wW7zpRulCRbNK/q7l+zCnUOZViYKRcl++sKthvU=;
	b=lfmw8n4CPddO+dRjOYU80/TnwaIPK8PfenARq8UBkg1DjXLToHjRCaQYoa7LWtQXshAR
	 HGR+nzzsH1KhGKDu37LOuw3bSSZfIke/kURuvnQE9CWrBcmLhhZa/vOh38pfpACVXx1Gr
	 8fWTxKzLeTiBaMS/UAKPiTD1xPTlBMcGAKbv4p/6/xM8/yS2nr+/KCST7mMDTnFmB7SXC
	 qpxNNFCiHd16dq56oPuXENfO2jI7wfom0TuPr95uCtSxXbXF1DSZqoJFsXgxUvc3t0xmv
	 9JG8JYh1h4BbQvz6zu83Tcu3NpCCUUIyow8ESveszU0YH9pYLTlU0hi+DhIEhijlFug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UodayXkT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005CE606A9CF;
	Sat,  7 Nov 2026 15:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UodayXkT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77761F0089F;
	Sat,  7 Nov 2026 15:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064128;
	bh=4cW+wW7zpRulCRbNK/q7l+zCnUOZViYKRcl++sKthvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UodayXkTvwTgkzPMDfGNqXC+JjwAEfBOjWZnKtvRBw2G1l2bB0TEL3TuHyx8b90LJ
	 1Ufln0MKEgnFIKDVVtriDK0QNjE0L/JuV4y3rLYjpO0cvA7GZ4fwWKbFTYB2B16JjQ
	 putwlLqJusmBia+AfQVKDJ5arX2Xhvc31Gp/E2gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	Marco Mattiolo <marco.mattiolo@hotmail.it>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0281/1257] drm/panel: ebbg-ft8719: Set prepare_prev_first
Date: Sat,  7 Nov 2026 08:42:57 -0500
Message-ID: <20261107134947.235403939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit 4eeeac9d7c3600a6cae75b2a7bc9c5b67530923c ]

This corrects the host initialisation sequence so that we can send
DSI/DCS commands in prepare().

Cc: stable@vger.kernel.org
Fixes: b00de0e237da ("drm/panel: introduce ebbg,ft8719 panel")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Tested-by: Marco Mattiolo <marco.mattiolo@hotmail.it>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260908-ebbg-ft8719-fixups-v2-1-5454ae1f5581@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ebbg-ft8719.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-ebbg-ft8719.c b/drivers/gpu/drm/panel/panel-ebbg-ft8719.c
index fb9f9f42be4f2..1ab09c50a6306 100644
--- a/drivers/gpu/drm/panel/panel-ebbg-ft8719.c
+++ b/drivers/gpu/drm/panel/panel-ebbg-ft8719.c
@@ -198,6 +198,8 @@ static int ebbg_ft8719_probe(struct mipi_dsi_device *dsi)
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST |
 			  MIPI_DSI_CLOCK_NON_CONTINUOUS;
 
+	ctx->panel.prepare_prev_first = true;
+
 	ret = drm_panel_of_backlight(&ctx->panel);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to get backlight\n");
-- 
2.53.0



