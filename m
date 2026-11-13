Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591610;
	b=p9nuRof64wMpeje6DbO94TezJRxeElwKAxcmpYeX2TlhEonjP8H1VD+/xsV66BCrYJID
	 RDDt0GEp1MdKHRCP4UKMVjZv0jM+ouqgQ7dWQl5yMLPxDVZmtU12AVFB+9upR6oy1+60c
	 CcLbVeVf8KhtqnQo9/vJSX5ukW/nwnLY/LEId+pfv9xlXeQfswWT5qQcQEnr0kd603QCn
	 7RnasEWdSePVV2K0EPyK6rGrDoaZM5CX+cwSDFcn9kxZ+mYOImwbbC7Z1uGaOc1LyXUVv
	 KKbQFisNKM9/pNKTbcjOq/Ijb+2THEO3C12ES3vJ/5FDgGiuWaszCCy1qsoNuwfjOKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gavxagfj07vI/xva/nIAm4lfoQj4FgpSClcq5DcfvhU=;
	b=Y1UAX4xLnSHbPPJ7ON1VhTb6rfGFoVr2BgiKVP82G7JvdZknnC9ZI5ETU9YX2eQrH58I
	 lyXk+dPrJbt4vhar9tSwZy4P3oOdZsBxJR272HeGugPQdFeDUL0Oxks14YVH9WwMIVuQl
	 vFcaXXpIqRIu2F1utSk7XZHn9Nl+J8TVjXpNFYf3goapds4xPYFJBMQmNuO8AUMcN1JH1
	 QTZewyWRqNti1RGVBJwD0fCGJksBFzlFishM9LaOR8F2tuYQvXm6sV71Inz37q5mVE0iZ
	 exg0aS/rDN1ZfO9qQRBBVY244WraYOv6IWHkFsfGgF4q4/K9JtSeYEQNi2MITcyddFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+qP5Iku;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1366606B45B;
	Fri, 13 Nov 2026 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+qP5Iku
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5AF1F000C6;
	Fri, 13 Nov 2026 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591610;
	bh=gavxagfj07vI/xva/nIAm4lfoQj4FgpSClcq5DcfvhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+qP5IkuzYAMYP5GS1VSAbpcAidBd27ADRcLWjjc8ZN1Ci/kTsDiNEc4btZ9FFgw3
	 D7HDA0/0L5URSD8eIcnbvsjJQ6xCJPGZuT6zhGLcOyq1N2rbBmKdosiGMv5Pwx42FU
	 glATzmoebhpzYz5b0JHaaeKJC8bj+Nr4xPzuauxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 610/670] ASoC: hdac_hda: Restore the codec device type on unbind
Date: Fri, 13 Nov 2026 10:52:54 -0500
Message-ID: <20261113153832.489104727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 26c2cc1d6a18c..fc5067edd5302 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -635,6 +635,13 @@ static const struct snd_soc_component_driver hdac_hda_hdmi_codec = {
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
@@ -652,6 +659,11 @@ static int hdac_hda_dev_probe(struct hdac_device *hdev)
 		hda_pvt->need_display_power = true;
 	dev_set_drvdata(&hdev->dev, hda_pvt);
 
+	/* Allow the legacy codec driver to match again after unbind */
+	ret = devm_add_action(&hdev->dev, hdac_hda_restore_dev_type, hdev);
+	if (ret)
+		return ret;
+
 	/* hold the ref while we probe */
 	hlink = snd_hdac_ext_bus_get_hlink_by_name(hdev->bus, dev_name(&hdev->dev));
 	if (!hlink) {
-- 
2.53.0



