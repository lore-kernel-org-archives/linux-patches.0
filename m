Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030228;
	b=QHg0X+luT55DXSNWYQtDkxVmtb/Xy2a2SCwoUXkiTHrmVRC/snMpcaj6YhstcFABxQI7
	 XSwKzxY0BkbyN/89C1C51r5jInYZbTcRt+4WgdM+1+P7XLL2hQlPsDqyVSWJfG7/x0X9E
	 LOOGGFBhZBOGRAq0x4REogxa1Un3Mmho3dpH/FPF8gkkdRXryEv7/I9RMHruDRpbEbHtH
	 1BtmsAWteAhYv5OsChZGVpUG/Veno9kvO3CkZtB0RAEWDf6fbnyWN6mQm+qtaRFam5esF
	 4pN5WHe6QiGyOIHVhXHR6VPS9J51c+gcIv0XHOcNmXr54CGw0gCdtArobfccP/ryCpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7sgbiAsuQpXtwus2uxOQsvDfkZ+6dyWRWl1f3JASmgA=;
	b=yRd+rlU4LsQsp6f7028pqIZq3FqV3aWRdlX0L8IKRxtyAB/Kf/Wc4VSpKSHJVBBvRj9i
	 v+YireUDezTVskRIVcTzj8+B1lBQumnAZBmRZr00YRpnYAyCe2hP14E1SLUvoUKOUb427
	 0J9LZDpKE0LrNFuDzG+RcyFaxFYaF6qP/o81NUpdIvr5KMJw3i51rqK0HfS9ivLnkY3/I
	 4qeAQ6gVcyhfDw+SeHBYluBYGRvpCMzxBws9O+mSjzNGWPtJhjESCf2O8WkfF/MzlwMdu
	 SovU1+/BrA1PEC391M/k0ngChvHkJet/oMw5bbv8RUhzuxuHd7sAWWvFAHnDUtyTTkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OCXz073x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D587606E7E9;
	Wed, 18 Nov 2026 19:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OCXz073x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA7B1F000CD;
	Wed, 18 Nov 2026 19:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030228;
	bh=7sgbiAsuQpXtwus2uxOQsvDfkZ+6dyWRWl1f3JASmgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCXz073xTiAvCPOPuYTsmToY5kr8tuHG5odtxDZ5dw90Ynjt2PEO0PAXmj27QB+EA
	 Qk8XFXuAyAgvrVowiZ/Awn/qJKKonQNClCYQPdGOOUst/CHjVh5/3+tD33S9HoUYjq
	 3j0OpmaejHKb+vqqveXGC1uXFoexeNlV63KJB/aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0630/1756] ASoC: amd: acp-es8336: Use an owned codec device reference
Date: Wed, 18 Nov 2026 15:45:57 +0100
Message-ID: <20261118150033.955981050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6ccaf87a080db..6ccf9ccd03fd9 100644
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



