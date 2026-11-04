Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829300;
	b=m4w9YslA22SXwuZt5N0ZY+6v6f15orwPmR74Wb4fmLTP6Ath9FKMqlN1n19ca04VPd1a
	 vwc2vCp93HhGWnNhz/seAg91c2T7Gkhd7Tq6Diu239VHorg0iwut0m+7Uomd5JNVrzWRp
	 g/kXaDpOuH0F/NJznJ0WUo+uQQz+W/Qh79r1UrUeuj+LTtfiDwRbyvxL+AIK4OwwsvIae
	 REjwAx1xtbUhE1KvJeJ1cUzUdt0Wr5iNNiaGxr7A3+MRKdbiCwaHWDBEenqV3/EyQRUrJ
	 XjpZn2dIqrr92efrx5X6XUTKIkuWthpnCXx23gNuWwocG80DmyyiI6xHspY9GzgVeKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gtXa5TOGasT3xnX0uy72JYS3oRrbSBo0eee3X6Z6wYM=;
	b=uoVnA4wr0iiNdGq2OCKPdmnjJ+N4cBtLGrXA8onTkCdnC6hZofhncGODDAJRSQsmWWNq
	 OajH5KvE72jDHtt3FCylBUp7JS7ZXAAFJ05EfWlgW69H0SLsAMm9tn5UbR4muhWYDkw3V
	 3LrOR3V3oiY7iqId9ZtfuCK4/mxjc+sgXSu0KEMHhYM32VkJ9DTmVogLtw/iA45etE72k
	 AymjE1vWe9dZIFFtxxTK2CNlWr+pDHq4ODr0DDyCDdrCgKrCRPiGcSVI+Klm43bJx4yVS
	 uWg7yk9qorrml9LhNUtnfD2qMh7Caa8thVbRxy5A1FaidIEpg3QdXFNj54D9E6+mIVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TAutp3so;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36676086604;
	Wed,  4 Nov 2026 21:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TAutp3so
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BD61F000C1;
	Wed,  4 Nov 2026 21:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829299;
	bh=gtXa5TOGasT3xnX0uy72JYS3oRrbSBo0eee3X6Z6wYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TAutp3so8+Mc6mGtQDyI9I/O4jRIrXaV/aZlubg3EJiV6E5PG0eZuT80hfxUX3Ot7
	 pFHGiU6gy+t6l84D1Wz/9vPebowHOwU0mBoW/osJGjqhWLoVwXlJv+6w6KQrn7IbDj
	 C105XkODr4XYgi6faUEfIKvkjodT8shm6eAjwmz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0037/1005] ASoC: tlv320aic26: remove keyclick sysfs file
Date: Wed,  4 Nov 2026 15:56:10 -0500
Message-ID: <20261104211044.609401527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index e5dfb3d752a3a..84e954311c1b2 100644
--- a/sound/soc/codecs/tlv320aic26.c
+++ b/sound/soc/codecs/tlv320aic26.c
@@ -320,8 +320,14 @@ static int aic26_probe(struct snd_soc_component *component)
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



