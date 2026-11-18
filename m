Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017605;
	b=2LBy1IfUSwgRei0ZJxQ7d1pwtddp//0D/AgmpDZgxjAnAEeW9PDDMRlgyF+Zv7BnD3rm
	 WAaib5xENY1dw+zfKpta+MgMGXsCqnygJvMAv+8kWCpDLvn+meIZSMKDOJ537o74NYuY2
	 7NNxzZT+3RZnFNCfKK60hdJC8JmJ8U1M13x/mqSxifPky5BmdTXAACN2EWbfShHEfZa+s
	 M/9LYNqkYjncvU5daf7sEzvVdKVkmD3MehnFz33aKAK0/+s9p1Ay53CSrk/cFqCUz/b9J
	 NLdYRuktlFtEwZNi1zwS7WPCLRpm0PZKyRra+FdOowq4K7G6oIb2ws7hU8VwdwmYEPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6s8hGAEuEuip09WqK4xGWVT/AxtkJp9NZnBVToXDQH4=;
	b=Srf5CppQTMUK4otpTZVb7H6nXzeRlyHsDoTAEEOgbtk94LlTIJphzaWFCmlVqBZirVNW
	 vHjJlstduEPJ38FyrQlL8E67gEiQqlGbFjucN2OLz5HD7qyY9kaIETYJEoBHqj6o8oGxr
	 XXVhgAoFZqL49hUKa4Lvvzqon4I8sVP7/7ORo36xLl+tAwFNZZn07MaGpt+5OjOibecbU
	 TQD0LPk79kyzudv5nn+vImk6gwz1wtPn0axu3Q6ol3j3kxrHjFBaq48KgTsqy+6Wi8LYx
	 b+bKLErk75jOhOawiVfQUlCWRcw+hG9MSUa1ucP5M7A4Hxn5Bi8ZGll0kbxoOnF3Xgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvH6+S2y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C144C606A333;
	Wed, 18 Nov 2026 16:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvH6+S2y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0CE1F000C4;
	Wed, 18 Nov 2026 16:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017605;
	bh=6s8hGAEuEuip09WqK4xGWVT/AxtkJp9NZnBVToXDQH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvH6+S2yPgi3SuzaZKI1EN+7gO6274nzcOkSMuc1Ym/x65l2Yc/OYxXygtaHfXiBM
	 9eYSbQ8UniUS3jEnNxMAImBlcAdsDqwpkld1IbpohsDnfkk5jZ8FNKPB56C35GNw+A
	 OLmGO6l7Y13eZ0HdCjt6fMwbOOUrZeCKCQcC/cUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0943/2651] ASoC: amd: acp-es8336: Use an owned codec device reference
Date: Wed, 18 Nov 2026 15:36:23 +0100
Message-ID: <20261118150321.845381025@linuxfoundation.org>
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
index 34e953d1a3a76..0cb0ee76191d0 100644
--- a/sound/soc/amd/acp-es8336.c
+++ b/sound/soc/amd/acp-es8336.c
@@ -30,7 +30,6 @@
 
 static unsigned long acp2x_machine_id;
 static struct snd_soc_jack st_jack;
-static struct device *codec_dev;
 static struct gpio_desc *gpio_pa;
 
 static int sof_es8316_speaker_power_event(struct snd_soc_dapm_widget *w,
@@ -191,6 +190,7 @@ static const struct acpi_gpio_mapping acpi_es8336_gpios[] = {
 
 static int st_es8336_late_probe(struct snd_soc_card *card)
 {
+	struct device *codec_dev __free(put_device) = NULL;
 	struct acpi_device *adev;
 	int ret;
 
@@ -213,7 +213,6 @@ static int st_es8336_late_probe(struct snd_soc_card *card)
 	if (IS_ERR(gpio_pa)) {
 		ret = dev_err_probe(card->dev, PTR_ERR(gpio_pa),
 				    "could not get pa-enable GPIO\n");
-		put_device(codec_dev);
 		return ret;
 	}
 	return 0;
-- 
2.53.0



