Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026645;
	b=qfrx16VANZKXxIji2lbrygGnaaFaC1/eXao62b5ACRXRMEMulDmnJ2k7CHZVJlx+OE8V
	 hLyadLSj7K+yq+a6Xk8QR3w8AD6tKDP9Nb0QPco/fouh6Dp0w3IT0yHriRlu1k+syepPD
	 qWGIxJJ7VkyDGzVoUyGxlEycdf4x9knC2Z0yidqsVqbyCwS+6b7lsg6YWFIZcyeqXm+Aj
	 hUquasWkH/Bi+mBhKbDK0DAuHpIj+aY0Qr/yHLKe6iFZ3WnDsitnN7oMJq1NQyI9lnxwM
	 9NomoQhpFFJ+5tCuD16fUUfN/IjLwjPzXdpo225NYVIGp6u5Lboj4BfqMyYM/t1GkuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r8ER4r6R0HxGxBOS527z6WS3jlFIZKOen/dXPDTNFtU=;
	b=bsfgvg/jUNptxojCwpOB5MPKn5xb6/pF3xASv5bgI8x8p7ktSRZiQyIsAl1zuz+/JN7j
	 jDmYtegjYX0FHYF3t/Q1rY1UCK1uPlqJdVwKtvZGRTfHpnUFL/s4VAok/My5LgIHfUK5R
	 faofEkiI6F1HeB8xWHJn9Gn+GvB4yTMFyZ+ntbKPO4Kt/senYrEkURH7LGZBqRNWHei8+
	 ZXCTnnBjeUd59rA0Lw5IApa4l6uUy0iL6Tpl2JvoBdAiy1Y4jxzPbRzwdvHyiXfj26gqw
	 230TbNPcuHEkyKl/+BFYyg7f4NtMUHNsGiHqKSIJeScnLg1z8i9ViXKU6Rrv1vKY0SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kvyopxm1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E02606A31C;
	Wed, 18 Nov 2026 18:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kvyopxm1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31AA1F000C4;
	Wed, 18 Nov 2026 18:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026645;
	bh=r8ER4r6R0HxGxBOS527z6WS3jlFIZKOen/dXPDTNFtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kvyopxm1nJ3aqCrk4y3qSlLdp3BIBb5k4Q5gm0KxCJeoRyAu3Oh9wfkR+m+k61ZDW
	 xbIc5j+p9wp0aI+FaFg5I8ZsWyyYTOzF8O+LYL+DeG92ZcuJUFe7dlHvp2X9o+sTXg
	 dybt+8E6nhYoAwmyIRfTPmph5Tos9lS6yAmgAmLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1506/2151] ASoC: codecs: wm8991: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 15:54:01 +0100
Message-ID: <20261118150216.728521638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit fee722db39c2a1f18c944f747271fd1e131910a6 ]

The LOMIX AINLMUX bypass volume (LLBLOVOL) is at bits 2:0 of Output
Mixer5, not at bits 5:3, which hold the AINRMUX bypass volume
(LRBLOVOL).

Fixes: 203db220718c ("ASoC: WM8991: Add initial WM8991 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/c6e230b0e7d7e3db2136cc751e0b563030dbc16d.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8991.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index c2cb07b532403..078e61a3a79a0 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -184,7 +184,7 @@ static const struct snd_kcontrol_new wm8991_snd_controls[] = {
 	SOC_SINGLE_TLV("LOMIX AINRMUX Bypass Volume", WM8991_OUTPUT_MIXER5,
 		WM8991_LRBLOVOL_SHIFT, WM8991_LRBLOVOL_MASK, 1, out_mix_tlv),
 	SOC_SINGLE_TLV("LOMIX AINLMUX Bypass Volume", WM8991_OUTPUT_MIXER5,
-		WM8991_LRBLOVOL_SHIFT, WM8991_LRBLOVOL_MASK, 1, out_mix_tlv),
+		WM8991_LLBLOVOL_SHIFT, WM8991_LLBLOVOL_MASK, 1, out_mix_tlv),
 
 	/* ROMIX */
 	SOC_SINGLE_TLV("ROMIX RIN3 Bypass Volume", WM8991_OUTPUT_MIXER4,
-- 
2.53.0



