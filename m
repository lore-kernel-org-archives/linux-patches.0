Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048699;
	b=ioY3m0uuGqC/TQ784Re5rsTpBF+EFCSegbqGkNVGlntijmj3hU6ozJJXUXCYk3nsjIiv
	 PV63LNFZhoQ1l/WDctbRzQ7YRbkfsSAVBYm679IqFFrj70VEVwodJ73oIzpROT1P/Yz++
	 Ue0hVuYwnVGrVwm+vUeke8enXIc4Gtd/A1KILCMShhAWg8AoKzNo18jtKomFA28vy56sU
	 X74fXgS0nstXax9Iz5R6aP0XAxlguxWPncwfPvZ73qbIgaRYYsn8J1+oUHROubDzARNfu
	 bjEX02LpbdlU2CvI08l3O5xRPPkqnhrUq0VkC/EVO07HZkeARC3rA1+os1tlsTJyfpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xaGR1LWllbgoukR5vHJC/yYKGLdy+qXTRKUKN65BESE=;
	b=wn5mkFtMfHVfK3FwCMimK9bFrkV+FWnego2TrlDrO1yXHXQNOK2sBDgM31Qd8qcKOasZ
	 TmbAnqMHNoc+QHu/X+qD0IzCX030DdIjQYUXu3jm1ReGeTlsyv0iDcJtRvo/Z0CEb4rww
	 ki6Q2Q1O3PoOTIp11na99sdu5tQtGM788Xitl5NBzjiCbM7H0HoBi3pz6xpMqkkGPdArZ
	 Kx/bwVP9PGNYmeAZhSr53TKHmwPXuiXntfpTURyEddRoROVOkt3XY6j0aHDGSQuzJ9zpi
	 wpcvhcPdmrdkHmw+TD6BBn/XicJqXsEx6k8wFbabf2X+8rvbZaK7BE+hDxTchlz9sMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrOrgWdg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48C6606A320;
	Thu, 19 Nov 2026 00:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrOrgWdg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3071F000C4;
	Thu, 19 Nov 2026 00:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048699;
	bh=xaGR1LWllbgoukR5vHJC/yYKGLdy+qXTRKUKN65BESE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrOrgWdgGBmujqNsogPfJMca902UodSuI6U8ZBdlyAiJMQx+dprqOyuGtUVuhNBAB
	 fqvVn/I5S68xI3rujNePdjcSMrvZuWLsFvcTLxgl/bQ1VIQhGQIvq0wHmjByofQqYH
	 HnmzFr3vEqGMVWDZ57Ys92pnJspfYgqVDWQR41tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2089/2857] ASoC: amd: acp-es8336: Use an owned codec device reference
Date: Wed, 18 Nov 2026 15:52:03 +0100
Message-ID: <20261118150316.624593272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0b4a6e84e3bea..903478949b6b7 100644
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



