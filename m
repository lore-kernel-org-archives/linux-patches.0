Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020580;
	b=SPU4eQI+p06zHZF3tatjob+EE5Y59c536q8hsz5b4hMTmpySKiOIQiGMHyY1EdT6BzbN
	 jrDPKbJOMYhWcTMRrCV1MbmoxdFEhBj5x74AmJmr/DmxIfC37E8Pb+1ksCLqhQ0xeVU2K
	 A887I73LmKSw0SPU0DeYlALCHh8GSeU8DLE8w+rMyoCIOChKj6DW/WtLKUrqzosMBllcA
	 CHxPrY3TmBndZRprKyyjTZ+6r+qQOpMRcughSFDX7sLoRbzyZrOSQETPWXY0oI28RAbf7
	 Mh1xOpbqPypRt0hsHirda2Ub4dfiEi2GNXb6m6JSjlcu8oRGBsLDn0TXr9istUS8Znw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SeO9jMvH2Y/AkGOzFNfunJvOHGvfpxe3JUmVD+A1g/Y=;
	b=p1Vntk4+6P1xZZ49jMQ/7ulq4wZABo5B9T6hHHF2P2PztI1AeAuo+nOtt1Kk1JuoIKZ3
	 uD9yhwtF4utbaBZefBhNwb/IwhnAc/WRKbqkuwBo+BP3T+GP0ZM+DMqXc8YCubDHoOjC7
	 RZs+LwKOzmS4ubCTppFlTIfrEG82lUAstloN99ysFw3/d8ox8+Yi4Qzr4WZHdtFLZFjeF
	 emduyluVygN4r/kUHnKu0F3025LYICiNyhmwm8vXmRqQBzo/IVYNOa+1VUySH11JqveY+
	 jMycTmK7L5cEmjfcfn4+xH23vhAs/A55zcTEiFDb0A6IDcITJoafI9OSSHpanJy3NYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQWNgnwl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B436606A31C;
	Wed, 18 Nov 2026 16:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQWNgnwl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23BF1F000C5;
	Wed, 18 Nov 2026 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020580;
	bh=SeO9jMvH2Y/AkGOzFNfunJvOHGvfpxe3JUmVD+A1g/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQWNgnwl8Q7RiqO4Hnpv5SHaG3HjstT0aD71iHxCpE2iDkU8z2UsknreQQpzxOqcL
	 Ywnx0Apg+27JMciKeXB6St63xyDYKWN5ODkmQLCjbCotspobu4cOe9POY+AANnTNmc
	 HAVrfbguXalgNBNt6bc0GqeA1/5BpF0dfUn92xPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2001/2651] ASoC: mediatek: mt8195: Propagate IRQ lookup errors
Date: Wed, 18 Nov 2026 15:54:01 +0100
Message-ID: <20261118150358.346678666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 9d5dedb285fb61a40e04f337d9e06fc59c065857 ]

Propagate the error returned by platform_get_irq() instead of
replacing it with -ENXIO.

This preserves errors such as -EPROBE_DEFER for proper handling
by the caller.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Reviewed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-12-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index 74999ea531bd2..8e38c50a8bd44 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -3132,7 +3132,7 @@ static int mt8195_afe_pcm_dev_probe(struct platform_device *pdev)
 	/* request irq */
 	irq_id = platform_get_irq(pdev, 0);
 	if (irq_id < 0)
-		return -ENXIO;
+		return irq_id;
 
 	ret = devm_request_irq(dev, irq_id, mt8195_afe_irq_handler,
 			       IRQF_TRIGGER_NONE, "asys-isr", (void *)afe);
-- 
2.53.0



