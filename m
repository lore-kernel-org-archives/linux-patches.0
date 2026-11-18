Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047142;
	b=eh4YSAWCKq2UoQ0/GMHq7Vb6jlgenCKtbkDplhvrTfq0Dq1TO9vEww2stxG5cwzkQ8li
	 gW7ULs5SJUbGsPcdaziEjmVzWAvmb3C7BRUfKWkKOuz5FvAZN8fzGwIM/kCax1eFfOTWL
	 f0w3mSyz5cZtR0hdFhuslR0oEH4RkwMNJhFwYPsxPepLd+hrIbkWPz0kQRDYIMofvCzd2
	 p+eDTIA2VL5h3+h9YO49x/vTK7CHB5CfG5q9ZgY/KncDTiLMe4F1hUR2vAoBshe69sfU4
	 8/62mWVKEhZIlYHhEsgQx2nplreQISafNddLrKuklG1gGJo1A0mu6JcyZdtSOCPY5sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+XJ7fKKAz84ihznKEsxIIiHoB3qDP7qqSgmwPbUIhKc=;
	b=POsZlA12syW8CHvLfZOH/xm+EgjDUZoeWlMmgjVB6WxNUmbEfo76OGNuj/SeunTEB+oJ
	 CUDAcWlMcVuqcdY8aiwVNTTWSa62mEYNSNWBTfI3U+ltATS7/VkCa2cTTaDFSOjKz6cRC
	 OWc4aCC9G3w1krYW+hxMeVqF1h6+k4dTflvNOjRSvhCRbzOkOs21CPx2LNO9IVLlnUWcL
	 nC2XKayiDOP0nZrLmyli0SFvbRH/qfsq6HcxbJZ3OoXTaKThxsCKsPeuwYS7rbqNGpd/P
	 fd4S5XjJLz17SAmJwboYRSCZGOGofXPkRhoL8CXTzOhTVo1iXu3rYEpSly4tcrTJHKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RgG3+12W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D811606A320;
	Thu, 19 Nov 2026 00:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RgG3+12W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11121F000C4;
	Thu, 19 Nov 2026 00:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047142;
	bh=+XJ7fKKAz84ihznKEsxIIiHoB3qDP7qqSgmwPbUIhKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RgG3+12WT9MdXuy49EQCuoZVhH0AUlj5UgrrAyX+tkcDorUZwKU7TPcE1LzT3n4Rh
	 +99eFtMTlu39tXFgPpampRwdKYKaER5bZsBbpaHymkGkabtOgq67tK3oamws4cXXBg
	 4UPXY8siGJup5oTuWD4eR0RcjZQxOSM2FYG5MFVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1533/2857] ASoC: hdac_hda: Restore the codec device type on unbind
Date: Wed, 18 Nov 2026 15:42:47 +0100
Message-ID: <20261118150256.515465347@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 08a44bde821d4fe22c0b6e63da04b3c59ac243a8 ]

hdac_hda_codec_probe() changes the type of the codec device to
HDA_DEV_ASOC to prevent snd_hda_codec_unregister() from unregistering
the device when the card is freed.

The type is never restored, and hda_bus_match() requires the device and
driver types to be equal. After unbinding the codec driver via sysfs the
HDA_DEV_LEGACY codec drivers no longer match the device and bind fails
with -ENODEV.

Restore HDA_DEV_LEGACY with a device managed action registered before
the component, so it runs after the component and the card are gone.

Fixes: b60ee2e281b6 ("ASoC: hdac_hda: overwrite hdev type to HDA_DEV_ASOC")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261027083840.28813-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index e1f53e8fb8295..8fd6849e0ddbb 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -604,6 +604,13 @@ static const struct snd_soc_component_driver hdac_hda_hdmi_codec = {
 	.endianness		= 1,
 };
 
+static void hdac_hda_restore_dev_type(void *data)
+{
+	struct hdac_device *hdev = data;
+
+	hdev->type = HDA_DEV_LEGACY;
+}
+
 static int hdac_hda_dev_probe(struct hdac_device *hdev)
 {
 	struct hdac_hda_priv *hda_pvt;
@@ -620,6 +627,11 @@ static int hdac_hda_dev_probe(struct hdac_device *hdev)
 		hda_pvt->need_display_power = true;
 	dev_set_drvdata(&hdev->dev, hda_pvt);
 
+	/* Allow the legacy codec driver to match again after unbind */
+	ret = devm_add_action(&hdev->dev, hdac_hda_restore_dev_type, hdev);
+	if (ret)
+		return ret;
+
 	/* hold the ref while we probe */
 	hlink = snd_hdac_ext_bus_get_link(hdev->bus, dev_name(&hdev->dev));
 	if (!hlink) {
-- 
2.53.0



