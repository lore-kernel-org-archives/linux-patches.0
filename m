Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050945;
	b=YxiuP1OK1pmF4WBhpGU93dtw+fTzKxSVQzD0cCR1u0VeKVtE3kTr154ks8Ps1XlXyZEk
	 AdLEG2LHVC37zRTxTd9jGnMnQbxVJGdX0yznvS3lQk5+gm/wsDAAoCwm6Ytt8ogxSBYtb
	 3baOaBFgwYIuzFnthfUbnYLXcoGmoOQTeCgeizBiZum6AGIRoCivAJn4uF6/UDPu1Hk9p
	 RF5pU2omRSw6QsyiXzS2syQaostL8+noK/MrmkuhLgWMgY0qh60udXV4XvDyWGrnkTtCt
	 HmfD6JX0HaOh2tXmt5XFjR8G8616iI/nAaHw10KCWibn3+1A0p8kXjGdVTgCxBUgjtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yrR0wy/PjCmWDdfa4tuDflgV+EKvFtmZoiVtUcyOm1Q=;
	b=h3gUIgXHQfFI++DDZZGIQvt3O8byDbOxivVQauzpScvguo0s8uRDRikuj7FQ2momuFW8
	 ZOLaXdZcMw8y3jbpq6Ys9wyN/pj+gG26tb4HUOqbyOQulzG46DdMKGHahAAzaKsYBWF03
	 gfDKFZc/3kzofDbSt0lzJBZkP2V9w+g1KzYDOMe1nV3PGlqDOvuS2SDnFnBWw6vF7CV13
	 /3oj5axhZAPDSerhcc65MBsVpBYJP/O1uiNYyX8Tt1JjeThcipovTYCtEgNiLdFVZ+UWr
	 I2m88D0YGePbvt8ziHD4K20z/TTDOpX62yaNBeqOcuRCgiAzPlCBgd3V19rq4EI9qcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZME3pe+j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983A9606A330;
	Thu, 19 Nov 2026 01:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZME3pe+j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15D61F000CB;
	Thu, 19 Nov 2026 01:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050945;
	bh=yrR0wy/PjCmWDdfa4tuDflgV+EKvFtmZoiVtUcyOm1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZME3pe+jrNHihDesqcL2pMKKABTfyp5oD6BvVMhyfxtSHG5G0/kcFvES4IM8awcg6
	 NrHAE6jwqBtBig5EwR8yKbpvTkE4nW/9W7KHfZPy6PkxtSplqbQ1zVkfL0C7DgDhUw
	 obUrlPPHUYsMMXODMnMo54zZT2r6SVxXsW0xXudo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0033/2214] ASoC: tlv320aic26: remove keyclick sysfs file
Date: Wed, 18 Nov 2026 15:28:29 +0100
Message-ID: <20261118150011.413137041@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit ae375f8d063d71e598c0d7e14fc056154c84d7a7 ]

aic26_probe() creates the keyclick sysfs file on the component device.
The file callback uses the ASoC component pointer stored in the driver
private data.

There is no matching remove callback, so the sysfs file can remain after
the component is removed while its backing component state is gone.

Add a component remove callback that removes the keyclick file.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260615064549.34110-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic26.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/codecs/tlv320aic26.c b/sound/soc/codecs/tlv320aic26.c
index 077415a572255..a863cd54b9528 100644
--- a/sound/soc/codecs/tlv320aic26.c
+++ b/sound/soc/codecs/tlv320aic26.c
@@ -321,8 +321,14 @@ static int aic26_probe(struct snd_soc_component *component)
 	return 0;
 }
 
+static void aic26_remove(struct snd_soc_component *component)
+{
+	device_remove_file(component->dev, &dev_attr_keyclick);
+}
+
 static const struct snd_soc_component_driver aic26_soc_component_dev = {
 	.probe			= aic26_probe,
+	.remove			= aic26_remove,
 	.controls		= aic26_snd_controls,
 	.num_controls		= ARRAY_SIZE(aic26_snd_controls),
 	.dapm_widgets		= tlv320aic26_dapm_widgets,
-- 
2.53.0



