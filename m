Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040369;
	b=dZ8GrObSIfBjd2CMV8IA2ZpltdD302j4ruaBftpjIPhxmVo87r0gy5DjPdzJR887tGST
	 4toYzvM6gmaNday7eKzssI5mgaLak6uxJIOd9lJbUifOREsaFIPc+LGXhLlqqaOVzblR7
	 NmJM2Pi0OBIoSdFx4l1JtAHrkTBd1DKzAfMyus6+WWJWd1i3Iozyb5oWlMBcu0K5Edpd+
	 6w1zcxVyxzRg590rbaaHfCw46dJUqw1eKhaYtp0uSZFzagXYeInj+uUV4rVwP4vOgTa0S
	 W36Kqco9yajg+4XH0g/rzsQoV3VyGQ3w/wjms4hCJYx+JKQq3ICXQ7xoCf+6SD5yv7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0joB0/ecl4Z4H+yzofQBTpj2RqP++rgv8QdujZqxyTk=;
	b=2/vNps1fo/D0xIEftGTsiE2YOo7JBFNWJI8cSDWpK4VTyl1ikcSjQgLp6cLrB7PamLWu
	 JVwdXHJFfa0hBN+MV4TnNYIlcYdAcoAm65qZ7Rlo8q85pRBiRJrfVU1PoroEk2QIJWhbk
	 gCNQy3Oi6x5YBfTkcDYX+ZNh4bNATgwImg4nsTOvW3PR+wggspunuyVSDpjBHkh7i8zpw
	 7QRdfRXKVUSGMNoZKydNrO2IeuobV/Mm3p+VcmFlPXpb8qRrQvmDdJaCoY5vck9aOyenj
	 Kab3jQjdARkbV4WbuRnqaUGAytyiP9CvX7TPh3BTmY2yDWPnx+YFdEdTIExPEfRTFiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Az6ACTR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146DD606A32A;
	Wed, 18 Nov 2026 22:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Az6ACTR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667DC1F000C8;
	Wed, 18 Nov 2026 22:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040368;
	bh=0joB0/ecl4Z4H+yzofQBTpj2RqP++rgv8QdujZqxyTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Az6ACTRDP4udEY5yxd3On4HDzFKeMH8OHIsxqeb661XOLbWg2YR1HqUa9L3uVXGF
	 pfcQAaaSBSxrza8pHR0HS8njxvGkJfYP1bPOdH6vQSHJn8oeoUbUlI9kaqgC/Y1Nx9
	 ZoF27RR9U+BFpXU7jj99oEZqiNrE6QI2okwAkSHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2405/3318] ASoC: amd: acp-es8336: Use an owned codec device reference
Date: Wed, 18 Nov 2026 15:50:27 +0100
Message-ID: <20261118150433.647682296@linuxfoundation.org>
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

From: Yibo Tan <lhfff@tju.edu.cn>

[ Upstream commit c257e3bcb36f4597d6dbb6fbc546e466ef53e385 ]

acpi_get_first_physical_node() returns a borrowed device pointer. If the
pa-enable GPIO lookup fails, st_es8336_late_probe() puts that pointer
despite not owning a reference. A later physical-node teardown can then
release the device while device_del() is still using it.

This was reproduced on current mainline with the real static late-probe
callback and normal platform-device unregister. The GPIO lookup returned
-EPROBE_DEFER and KASAN reported a slab-use-after-free in device_del(),
with the object freed by acpi_unbind_one().

Use acpi_bus_get_primary_device(), which obtains a stable device
reference under the physical-node lock, and release it at callback exit
with scoped cleanup. Keep the reference callback-local because late probe
can be retried; registering one devres action per attempt would accumulate
references.

The same KASAN guest with this change reached the same -EPROBE_DEFER and
unregister path without KASAN, WARNING, Oops or panic. The test directly
invoked the production callback and did not emulate a complete ASoC card or
physical AMD hardware.

Fixes: 02527c3f2300 ("ASoC: amd: add Machine driver for Jadeite platform")
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Link: https://patch.msgid.link/20260922185057.954150-2-lhfff@tju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-es8336.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/amd/acp-es8336.c b/sound/soc/amd/acp-es8336.c
index 0800c50bc9df3..7fc53a9a83009 100644
--- a/sound/soc/amd/acp-es8336.c
+++ b/sound/soc/amd/acp-es8336.c
@@ -31,7 +31,6 @@
 
 static unsigned long acp2x_machine_id;
 static struct snd_soc_jack st_jack;
-static struct device *codec_dev;
 static struct gpio_desc *gpio_pa;
 
 static int sof_es8316_speaker_power_event(struct snd_soc_dapm_widget *w,
@@ -194,6 +193,7 @@ static const struct acpi_gpio_mapping acpi_es8336_gpios[] = {
 
 static int st_es8336_late_probe(struct snd_soc_card *card)
 {
+	struct device *codec_dev __free(put_device) = NULL;
 	struct acpi_device *adev;
 	int ret;
 
@@ -216,7 +216,6 @@ static int st_es8336_late_probe(struct snd_soc_card *card)
 	if (IS_ERR(gpio_pa)) {
 		ret = dev_err_probe(card->dev, PTR_ERR(gpio_pa),
 				    "could not get pa-enable GPIO\n");
-		put_device(codec_dev);
 		return ret;
 	}
 	return 0;
-- 
2.53.0



