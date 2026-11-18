Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056558;
	b=MBItX+nkkNqbHAgGP8Wrd3NxBwu+LrM8/mSkdDeIL5l0idOFLqy0a3Is0X2XFYX+Vqfl
	 8XOMmHYMYzdddtTCfsu+pSCx2ssYPvbE+CJHbQiePb8QqjuDt2+fuVjlMdWaanlIEiboP
	 kvgGtr83rr9u3x2MlOhDoUEAZPlwyLt/KTDA/0p7GaT9Vg/t/CVJpB5rhP5AU5Nge6MoN
	 K6huD6AuAtfO/uNWfZof8OyL0wMP20oxMycvnhoSpZTCVjbNE6TyPkeXkkhVneIDrBCkC
	 SiOU9i2LWTVfQ2qno5HCXY8uie84lpeFDyJGQF8gMbla23lzaB1JeFLvQU7VlVyiAHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eos1qW92VA+ygd5EzJeme+heUn0Pfv2/NbNQmvNo4Mw=;
	b=uTQkwZV7l5JuODME2q6Wj9ECMtiTii3I99eywuQzz/VbHEbx/AtV7FS2qeXU3uXIT57i
	 rGT5VPOB8bfZkzcOZXYG+r3YkorsTDPRwxvYu4518hrGVdjF6ZiVTZDTcc4l7xnujmdOY
	 +IDRpKu4fAhxq9CZP6Jjexh3O56MtBJYm77NkZN/kLFbm3J1TFhCbsWPi4pVG4eDEGKhI
	 NTZtgO8f0ZGeyK1wWpVzoFm6w1Sfj8vNHXDN5J1dm9OmtAhZND9p2sjOF0m7SfgjiN52z
	 D5Ymcbmqf8/mE0XrmMnoymOW4u24jBnsotTNknjlr/59iOXascyW2GwB2GzaexXft5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGJXRssV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D60606A32A;
	Thu, 19 Nov 2026 02:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGJXRssV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533EE1F000C4;
	Thu, 19 Nov 2026 02:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056557;
	bh=eos1qW92VA+ygd5EzJeme+heUn0Pfv2/NbNQmvNo4Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yGJXRssVZ+H5GUNmK8x1v4CTc5gFBEoGjpNw1wzGwCD+LMxPJB00/nNBX0i/JWao5
	 PU8mO9AKUqJSeoqV8o+FarVzqMxnBGziMY5QPiRp3cZWAExI4sLcJ/QFqf9pNgJIz6
	 cOAv0jUSdtE/+O1Lz7Dl+pGeUOEypAaFgRcOE9aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1993/2214] ASoC: mediatek: mt8195: Fix ETDM MCLK error handling
Date: Wed, 18 Nov 2026 16:01:09 +0100
Message-ID: <20261118150130.536541223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 91dce9c7eec25e95b5ca32e17e60e2c27333d411 ]

Propagate errors from mt8195_afe_enable_clk() when enabling the
ETDM MCLK instead of always returning success.

This allows callers to properly handle failures when enabling the
MCLK.

Fixes: 1de9a54acafb ("ASoC: mediatek: mt8195: support etdm in platform driver")
Reviewed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-13-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
index 9031d410bbd0a..ee3d8270f957c 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -1500,9 +1500,7 @@ static int mtk_dai_etdm_enable_mclk(struct mtk_base_afe *afe, int dai_id)
 	if (clkdiv_id < 0)
 		return -EINVAL;
 
-	mt8195_afe_enable_clk(afe, afe_priv->clk[clkdiv_id]);
-
-	return 0;
+	return mt8195_afe_enable_clk(afe, afe_priv->clk[clkdiv_id]);
 }
 
 static int mtk_dai_etdm_disable_mclk(struct mtk_base_afe *afe, int dai_id)
-- 
2.53.0



