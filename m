Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591361;
	b=AFQoCw6Fhlz8mlpEVgukh3Qrw9LWikVImj3YAnWtPf9wY6R1yxT0rk9EoqnNirU1VRXu
	 ZwzGu20j1r7tPclnesBvczFBbGc9QHwKeiIl1sAT/DXSdp14x3zlIsTYUfz+3E7ojTsSD
	 7YWOE11rxsuYaBNgQWNPpaebZaaj/1vNTHSqBl9QIhqWggcmdkgF41jTRhVVEYhqAgX/y
	 Hf/39lRVKeKoFEEdAEd1g4dOSfpN8yZTMWtue6LazAK5hP5MpLDi/uI/KTxSlWPEFgBdK
	 SA9FYWibGJta6u1UR0+HGrVDcRu9ymZOJe8ieE+fi/w2SXWDRW14f02qY315pK52U7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=it9Va9H2PUL15xiLlHKF4pzdvD3bzP94RK5l3cYSFZ4=;
	b=s/CPR73hC6rA9XM6NN+CcoWrzwKjSZir14e2Zd18NyJJxePTg5oZai56Xamq7Og5zir0
	 gbsNu+j7rAQavX9L3JBmfG1Em9UL0OjUJ8DovEE9wF3ssa9MUXPmLFxlMURu3lKzFQMkt
	 JdQgGNNeJf3QJwhxCUVvktNMzXjTUZw14jh6QtioFOfWfjaDeCeFxA2VbmmJnzXMwYwOs
	 A2XEV034GWli8dg0hGeN3atn+Tv7qG3rC0Mvn3a+gHa5VeyVsolo5uptdjzV4yTTf1OKm
	 J4Wa3yyQx79SH2kHk4IqdaeU+aYTclgxKfrnlZNp6nnsCRicp1wpbCmC75kd9YwJP8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wtfyPCJI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6EF606B22D;
	Fri, 13 Nov 2026 17:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wtfyPCJI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07291F000C4;
	Fri, 13 Nov 2026 17:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591361;
	bh=it9Va9H2PUL15xiLlHKF4pzdvD3bzP94RK5l3cYSFZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wtfyPCJIq82lE912tRCVXESDCEWEGAVm64KMe80k8EU36ePq402HPsfbeDWrbQnPY
	 Yo0WZpPffSaqXJ2p2URCwhnnGTF8pvCDKgvdLlFfofXvb9P3G0TP4REDxk6hkzGq9k
	 FqALJx3wBw9wtmqVSy2tDUPXPWLRHVWzuPxQiM2w=
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
Subject: [PATCH 6.12 464/670] drm/panel: ebbg-ft8719: Set prepare_prev_first
Date: Fri, 13 Nov 2026 10:50:28 -0500
Message-ID: <20261113153827.676178491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



