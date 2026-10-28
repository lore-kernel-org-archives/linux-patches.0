Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208551;
	b=hXkTg5SGM4R3yxDxPJ53HzORSmIILstg69EZuq3dlXyh20ZkAFwwbVkFVyNDVYgBOTip
	 czduhlQy+/VSViXvvNeu2HZr25D0BODBXvBCdmd5T5u/9REqMGlZjffHZ9vWFdu3CBvn0
	 aY/CK8pzkENkqvY5ofLDXupWTduzWeEFlheHi8EUUcgRv7MqZEHAlhvu1UAaXlpHGCDdK
	 WSfQh/sPrZAd16+EcALYff0RBPL5r7K2dF+xGCN41sV/gMGSbeYeMtv0TJphH7dNFCzPT
	 tSrh9MQTMilQm7moEFb2jSBKKLEp8pP/mmm5CZMRcIL02PZCc1Ns9QVJPgNbHHI6Cuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bCXfMPMQgiTQ57yjXyo5Zs/KXWsjit713QBCh32Mvhg=;
	b=g9KH99ILm8YTxWxxHg7GYMf4S5G+2DziMT5tgrGPwdXwhJNr57sXHtAp3Q/H1bwLn4Es
	 VOOzce7Uj8Zxlj2lVA7dDlHpGcwyBLTxA/Br9P5kXsnf2gylsjGM3ZC9xxxtZhHGz4O9r
	 VX/uFHACSYCE7Mg9wXQ2PHPd3jWzYInTxY8+mfPMwoO/Vzz96GldBlvaU8O0tqiIz+Wmp
	 F+xaEI1HGyLqQz97mErb90FRWPjazItyVvPXWXvUfjImkDYLcbdX4hg0U0O6w9tg9/3VM
	 8sGQbtoCb2jSZgbAIlWuT3awGbjvbe6xqNQNEURuo8l19X3RXs9IiZBcgTIGa10co5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qa/rFE7m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A79B606A31A;
	Wed, 28 Oct 2026 17:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qa/rFE7m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3799B1F01828;
	Wed, 28 Oct 2026 17:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208550;
	bh=bCXfMPMQgiTQ57yjXyo5Zs/KXWsjit713QBCh32Mvhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qa/rFE7mo0av++VooJsbVIj2M5ykYoDixAkclSHHX9rQZ2SGDxpTfCm1q6jyvRht3
	 X8+0qm0y2RSewDFsWXybiXO33155iYAkpTPqSm26VeRcrv+sis3dTLAYiRDEHJPjve
	 pHIbxZsS6BYferZFWXSdMfRdgWBH3c6ajJbltNNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/516] ASoC: wm8903: Move the DRC QR threshold to the register that holds it
Date: Wed, 28 Oct 2026 17:55:12 +0100
Message-ID: <20261028170007.295991263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit e31ae4aeb049983fe3be0cf1e12c8074811a7685 ]

The DRC_THRESH_QR field is bits 7 and 6 of DRC_1, but the control sits on
DRC_0. Its shift and max are right for the field, only the register is
wrong.

Those bits of DRC_0 belong to DRC_STARTUP_GAIN, which "DRC Startup
Volume" claims as bits 10 to 6. So the two controls share bits 7 and 6.
Writing either one moves the other, and the quick release threshold is
never reached at all.

The six fields of DRC_1 tile it exactly, so there is nowhere else the
threshold could live. Point the control at DRC_1.

Found by a sweep for two controls claiming the same bits of one
register. No board with this codec was to hand, the register map is
the driver's own wm8903.h.

Fixes: f1c0a02f32f8 ("ALSA: ASoC: Add WM8903 CODEC driver")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Assisted-by: Claude:claude-opus-5
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260920135327.3628704-1-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8903.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index 09f4980630c7e..698dd106e4b86 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -678,7 +678,7 @@ SOC_ENUM("DRC Decay Rate", drc_decay),
 SOC_ENUM("DRC FF Delay", drc_ff_delay),
 SOC_SINGLE("DRC Anticlip Switch", WM8903_DRC_0, 1, 1, 0),
 SOC_SINGLE("DRC QR Switch", WM8903_DRC_0, 2, 1, 0),
-SOC_SINGLE_TLV("DRC QR Threshold Volume", WM8903_DRC_0, 6, 3, 0, drc_tlv_max),
+SOC_SINGLE_TLV("DRC QR Threshold Volume", WM8903_DRC_1, 6, 3, 0, drc_tlv_max),
 SOC_ENUM("DRC QR Decay Rate", drc_qr_decay),
 SOC_SINGLE("DRC Smoothing Switch", WM8903_DRC_0, 3, 1, 0),
 SOC_SINGLE("DRC Smoothing Hysteresis Switch", WM8903_DRC_0, 0, 1, 0),
-- 
2.53.0



