Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE58BF510;
	Wed,  5 Feb 2025 14:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764340; cv=none; b=b+2O/sDHgmeerX3YJ1A5TUijB5mtp0/i3idHMJYdRkTIxpn9vaS+S+F0+LO7lX2aWabixOfAglhqkdAaQx+5x25/rDB+Ljog7sBr3j6JhPUQrE4Mi3+GKTLXBqgY9jRTh0k19VdDjg443L8swti9zsYPy64/bcsuyg1lpWrKbxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764340; c=relaxed/simple;
	bh=2GhGc52CwLJAuavqlSCXLBMjSCGzEz4nxHNuf/7CD0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdvP6bgIJvpln/OxEcupttyyNj54/eJXTUhOrV2tRZVor5VeN5COMvImsp+Mb9WgJiu+1+gEAjbkcoIxoKcxVdgmavmNErYhQa2EniQU9tD4cvm7THrSCmsnEELYC0j3YOhftf0O0c9fgaNCN+lpOfpLuJWlnPExiCdw+KbpDAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGV2SVBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGV2SVBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17486C4CED1;
	Wed,  5 Feb 2025 14:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764340;
	bh=2GhGc52CwLJAuavqlSCXLBMjSCGzEz4nxHNuf/7CD0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGV2SVBUJ4CGiVdarg6lnEyZFX3jahD7RwRGoOfDY3ixwWzRsP7PonHboOdyv3h1a
	 1+HutlkGjY+E3RDAMB/ML6BvCdAllzR5x/GLXCaF7DbMg3XL+GJocQVxkntbFr2XZR
	 pT3LTXDvNYuHY82VmNjSQqXCM5i3wqWXZThOyHto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/393] ASoC: renesas: rz-ssi: Use only the proper amount of dividers
Date: Wed,  5 Feb 2025 14:41:22 +0100
Message-ID: <20250205134426.535278444@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 55c209cd4318c701e6e88e0b2512a0f12dd02a7d ]

There is no need to populate the ckdv[] with invalid dividers as that
part will not be indexed anyway. The ssi->audio_mck/bclk_rate should
always be >= 0. While at it, change the ckdv type as u8, as the divider
128 was previously using the s8 sign bit.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Fixes: 03e786bd43410fa9 ("ASoC: sh: Add RZ/G2L SSIF-2 driver")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20241210170953.2936724-6-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rz-ssi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/sh/rz-ssi.c b/sound/soc/sh/rz-ssi.c
index 1588b93cc35d0..353863f49b313 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -245,8 +245,7 @@ static void rz_ssi_stream_quit(struct rz_ssi_priv *ssi,
 static int rz_ssi_clk_setup(struct rz_ssi_priv *ssi, unsigned int rate,
 			    unsigned int channels)
 {
-	static s8 ckdv[16] = { 1,  2,  4,  8, 16, 32, 64, 128,
-			       6, 12, 24, 48, 96, -1, -1, -1 };
+	static u8 ckdv[] = { 1,  2,  4,  8, 16, 32, 64, 128, 6, 12, 24, 48, 96 };
 	unsigned int channel_bits = 32;	/* System Word Length */
 	unsigned long bclk_rate = rate * channels * channel_bits;
 	unsigned int div;
-- 
2.39.5



