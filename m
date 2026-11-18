Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041577;
	b=gVplgdWKy2dDK5l6NcrQ/sPKu88xQrFad4cWbZdyTlg67N98bd5VxRdBK7YxMHZh8uB2
	 j9OQRs+3RvYaxzQNTUpUcUAdkCswaMvqDgXmJF8HaA2B/J24+eaLnLt/sjPHie8oVTz7e
	 o0mfONDSvf7pdfkIwDiTUm3fMaPGCtXNxP5uAFd3pgYZKyzZxf01RdfvKiLK+wKaBXHyg
	 WTTeQA6+21WM6zjxQAWT0J2v7UbSKnCpMaQtOxcqTenuaGdDRqlnPXMBdCi3XV3aMcT7X
	 QzUhA8F6aPG3WsG20+mevw+xGTvblmb5aoIebApz7ULzkXiI6k5EfHfUJOqr+cQlo/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PuyRnxBn/XGs4QrqG7KIpGRWT2ZqNZKj8Q4aTzdKBDY=;
	b=5Jlxb9nmjJnG8YKNB17OsSeh/nGrWNaJ2StyUT7Og/jrFtpIJB0Hw379hvoNgdf80tzf
	 qKTShYvN8z2xv+gaTtukWb4N1EJkx9jMU3x5jo3/7CtCf2X0e2UBg1lSAp2CmXaoHonEX
	 YM6pTbSgK8Pzr+1H9xp/eV1iYm3PAar8gE8tCRa+AMIXvt0OeKBgofl4wJzfWFFW/Zgtq
	 Gp/n2kdHt1fmx4q2/xiJ+sK2l8w6A2eCBPLUq8gNFAhbj6fSY1L81J4jQ3MkNnVIMGoo4
	 Td62/C/aYq3gulGAlVf41gyTrEntVRCCgXZY/IKtm78xdDfdlICAEV6/c0HvLR52u1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bD55FeHU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F308606A332;
	Wed, 18 Nov 2026 22:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bD55FeHU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A231F000C4;
	Wed, 18 Nov 2026 22:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041577;
	bh=PuyRnxBn/XGs4QrqG7KIpGRWT2ZqNZKj8Q4aTzdKBDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bD55FeHULkIx4Umpkaho/rELzenULULrCp2BYwXvbsF8j03NjhqyGdt+C4I7Tq/nX
	 v6hU6kW1GwgW2LwSqcTMMTTnZUPuf2nDz/rI+rql4L9S42rRu89T8+/BwlSjC6V81X
	 4NrLo/vIy/+TIHdDyqhT6i6hGiTcsgcN9AI1uajM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2864/3318] ASoC: codecs: wm8737: Fix definition of zero cross switches
Date: Wed, 18 Nov 2026 15:58:06 +0100
Message-ID: <20261118150446.498550307@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 121963197200ca89050f05a704f53c281702ec16 ]

The mic (xMZC) and PGA (xPZC) zero cross bits are bits 3 and 2 of each
channel's Audio Path register. SOC_DOUBLE takes one register and two
shifts, so both controls only write the left register. Use
SOC_DOUBLE_R, as the Mic Boost Switch next to them does.

Fixes: 2a9ae13a2641 ("ASoC: Add initial WM8737 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/36cab58287bd24955e73bfe3a6fb24cae8fad7b8.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8737.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8737.c b/sound/soc/codecs/wm8737.c
index 0d231c289ef33..6bca58404bc20 100644
--- a/sound/soc/codecs/wm8737.c
+++ b/sound/soc/codecs/wm8737.c
@@ -149,13 +149,13 @@ SOC_DOUBLE_R_TLV("Mic Boost Volume", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
 		 6, 3, 0, micboost_tlv),
 SOC_DOUBLE_R("Mic Boost Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
 	     4, 1, 0),
-SOC_DOUBLE("Mic ZC Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
-	   3, 1, 0),
+SOC_DOUBLE_R("Mic ZC Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
+	     3, 1, 0),
 
 SOC_DOUBLE_R_TLV("Capture Volume", WM8737_LEFT_PGA_VOLUME,
 		 WM8737_RIGHT_PGA_VOLUME, 0, 255, 0, pga_tlv),
-SOC_DOUBLE("Capture ZC Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
-	   2, 1, 0),
+SOC_DOUBLE_R("Capture ZC Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
+	     2, 1, 0),
 
 SOC_DOUBLE("INPUT1 DC Bias Switch", WM8737_MISC_BIAS_CONTROL, 0, 1, 1, 0),
 
-- 
2.53.0



