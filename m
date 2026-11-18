Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024657;
	b=v7gHlToUKcEqmE4CNfSl/GJRwR9mpjMufBOZ21/Tw8oYL4+GohhcnYfW0xxMRQGKtBo2
	 c0ql+Cl4/SIaCPWMCS4hbJusKxZEkfWvVnv9PKCn0yHnkV3hij13dunq2gP5RpQ4/A43q
	 VfcOC39FpLgP0mTUWq/HiGFwyQGSUDGg7UFyRe236OXrGHhegQo/QaRUeMUZrycK5Uhoa
	 kQUiKKkywgEf5D+hjEzQwshei9/ylkRXU5XEraRGRcOd7fcWTpEKn7eaL9cCZzByJzBCE
	 pU5S3x+F/GoOnZYkpKiid55XpLO8Y5stXH1sg/noD6QsrGn8MHwtLHk4AmR7Ni71GFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b7cv47W6FV7X4CixKv1ghaaKC1O3ZVSyJ7YiT0MHHwk=;
	b=TjVswHERe9DcIqQzYWbZeoSBgYk/9LcT4FfyDRRee0o07v/RBOiayofmZ7WNbgL/w+Ua
	 lrahTibBkS6swBVGG9xx35vN3LhYBSZQFGPzR+ShIgVQmlYtLC0I6595OmrwQ9wPxC0MR
	 vRgf1ubK2t22T3BmSWqB+l+P/yhB4esKXb2z5A7iF6f6pHBu1lR8GSIrOOsJ6lx2oBdyr
	 bcuVR2HFoxulELM7xNRh12SLFnfSpAhlFQCH0l0G43y4vWQLF+YPlcj52jHsHVY05VghQ
	 V/kdvaZoy6LYGsUMiASYUWfRX9M7MxQhANlGwxGRPp+dLgRLr78GUe4IdJeQqge9YiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TbNJXtJv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6FE606A31C;
	Wed, 18 Nov 2026 17:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TbNJXtJv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818B01F000C4;
	Wed, 18 Nov 2026 17:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024657;
	bh=b7cv47W6FV7X4CixKv1ghaaKC1O3ZVSyJ7YiT0MHHwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbNJXtJvQJCp/dY6alCIHTRKGOAH5J55hHYqiatGD8+niMzdY67ecYn3+sp/NNxxr
	 OXTltIEKoRIQy8Xi3vdps8CW64ziyX6F73/wpL8qjYH24OTklRKpwTGWtahLAh7ZLt
	 WfLLAnIyQLlugJslHrFBSofzsG3tnDdpCOewYZaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0803/2151] ASoC: amd: acp-es8336: Use an owned codec device reference
Date: Wed, 18 Nov 2026 15:42:18 +0100
Message-ID: <20261118150151.316723159@linuxfoundation.org>
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
index 7593eaef5859a..e254c5d99de53 100644
--- a/sound/soc/amd/acp-es8336.c
+++ b/sound/soc/amd/acp-es8336.c
@@ -31,7 +31,6 @@
 
 static unsigned long acp2x_machine_id;
 static struct snd_soc_jack st_jack;
-static struct device *codec_dev;
 static struct gpio_desc *gpio_pa;
 
 static int sof_es8316_speaker_power_event(struct snd_soc_dapm_widget *w,
@@ -192,6 +191,7 @@ static const struct acpi_gpio_mapping acpi_es8336_gpios[] = {
 
 static int st_es8336_late_probe(struct snd_soc_card *card)
 {
+	struct device *codec_dev __free(put_device) = NULL;
 	struct acpi_device *adev;
 	int ret;
 
@@ -214,7 +214,6 @@ static int st_es8336_late_probe(struct snd_soc_card *card)
 	if (IS_ERR(gpio_pa)) {
 		ret = dev_err_probe(card->dev, PTR_ERR(gpio_pa),
 				    "could not get pa-enable GPIO\n");
-		put_device(codec_dev);
 		return ret;
 	}
 	return 0;
-- 
2.53.0



