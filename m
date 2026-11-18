Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038138;
	b=NUiN1+GR0c2xd7nl0PAytLYUAbJ3d2fjAGPDZpf/hQGYCFov6vQzD490bpJrYYoIk/0b
	 2zqWO1dG0L7q9INmD0Op/O56wP9AnTLc9Ed73laJL5fQ4uif5/g6wzFzbG0JSsW7WyuKQ
	 KoQ/D4KPJ7NCFCB/3L/fZ484eys528bRFIVttXkJ9+Bw13k6KEzFcNlfZ6NE0zy5ZOXMj
	 J8gxdiCUYNbehA3MQdc/kUtZezBCotyehhP1Xhw2LUWFTiLzcEkwgAFC/v5pgQoX7yPFx
	 H9FHQPjQZkXl+97Inqsm6f0AFfoT9+aZx6+amRTqogis7BdIYxoW6MlEuUVO17TQJ5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ny8+bHfJMCpG+At/UIKLYhxhgWKUYxleAzNbBZQtIKw=;
	b=dJ7qsmKB3pFdvIYupF0S0TuL0q3ogAgYAguWi+jWXBeDMSVGT7buJqyW29DHh4ApbiG8
	 FBPQ8/pwB8c2Idvdex2FbugfusvkD6bxz0joccPtSDuSIyyilWOScMnxrYpX2fhkRzrhi
	 aRdphUAqOZCthKDVYnXMnmmDmDbYVfJbINWA29VWd4WokEgXGmPtUmdsiq6DJzEpcJz9M
	 FonruK1GLNkDQsHt4xPz0c6PgafwXrGkUwwwkZVMPPHjhAMnsz12Xxkfm8y860mNhSxIC
	 /xovjs2gE+q6sHgyZVW7X8m+GjnmQJw12rQrvb+37M2VxQp968IgCDrLcwExl8Gtdpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0aoVHyy3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AD7606A33F;
	Wed, 18 Nov 2026 21:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0aoVHyy3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E63C1F000C5;
	Wed, 18 Nov 2026 21:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038138;
	bh=ny8+bHfJMCpG+At/UIKLYhxhgWKUYxleAzNbBZQtIKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0aoVHyy3o45lllfrJgbxCB80erjVgkIETjqFDplZ4OpRd4lW1VD5LFNxGtWYOPq26
	 H0+n43ze+VEKwHr28VsratlofwNK8zDIBgduaW/JI1M/ZEfP0tI+qJrRVGkll8+D5L
	 5u2967qRUieC7NS1QPeCyZp5ctNu+Gc772IgkAFk=
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
Subject: [PATCH 6.6 1638/3318] drm/panel: ebbg-ft8719: Set prepare_prev_first
Date: Wed, 18 Nov 2026 15:37:40 +0100
Message-ID: <20261118150410.897894197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 74b56ee42fa49..c97825177693f 100644
--- a/drivers/gpu/drm/panel/panel-ebbg-ft8719.c
+++ b/drivers/gpu/drm/panel/panel-ebbg-ft8719.c
@@ -233,6 +233,8 @@ static int ebbg_ft8719_probe(struct mipi_dsi_device *dsi)
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST |
 			  MIPI_DSI_CLOCK_NON_CONTINUOUS;
 
+	ctx->panel.prepare_prev_first = true;
+
 	ret = drm_panel_of_backlight(&ctx->panel);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to get backlight\n");
-- 
2.53.0



