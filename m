Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585922;
	b=Mm/emyiXHz/uu7eU/EeBcoZj/ox3yLOf1F7EJqpQuEW47IImLHtA8xcRyHk5ge5mdJ+P
	 nSir710sfmkl1iQTAT+1wYd7cxu5bzxlLSIn37zpMZ82rB3HRTgcTp5Uk7AVmrtgCq8te
	 rVfExzl8O4cXoKcUsYnmn3gV5QHsMFubVmspO8cRkkHV9dXVAN784SGROi8t3oDPJ9MAA
	 7QrtLXAm3murTbjEY6IU+UayZuwbC6g2mD+D1sUubKKOGEFtqEXxCXbSRCWMS//quFu9n
	 GaSC9oecM0hf+87Ve7qL9rv+J8MNKGE7WiitzBlOJaKSmXtQ8a8WuURBdw/bl8qYWww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vX3AHTkVxNqTF3Nz+KPWwdreqzWSOboF51DH/NOxa8k=;
	b=zvJ+ta9+jrDWDSw7Bq8cq9yuGWtFRlPlqqLnwPUhh2BTk88BVu2EO18jgNVj75PRHMdw
	 EwBP0MgwEpCPGgI1bTUoIErgGXowM5mYNuT/53E1rNlWAtEJJNwI8W4l2PYyEh1TVuh3O
	 QYkRC3A0QTKgE7xXIR6SJFuzhMJQVCJpqJTK/JF23xBUhhV1ytuBrWpAnAn+Y3GN9D/U5
	 K5nBN5VciyRPaXoFfbXPtDBqfAw5XRzVrAaz7wDUpdc7yEEGSFA5pYkY59AU8tFtGzKDa
	 xelNzsGNMWSmzp36aq93TDmGMpFttSw3WGhiueE9uZ1HK27alzJ/HOEgmb6DyxgeXvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+kEXtfJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD97C606A895;
	Fri, 13 Nov 2026 16:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+kEXtfJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F8F1F000C4;
	Fri, 13 Nov 2026 16:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585922;
	bh=vX3AHTkVxNqTF3Nz+KPWwdreqzWSOboF51DH/NOxa8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+kEXtfJXxGj0s7iF5oMfqSn4AJmzvO2eIbn9Uol+hjJzu0hRmUbHQKBwfSAjNI2l
	 aWjWGpNJ+IkgxNWSeYJQnMy7f6hzaD8cFdqhIe9N9kg5rTDgPft7/vvczUWtJu4qFB
	 FufT/hE5r4/+iownBLsl1eMR2aiGNbfV1SuOlnfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 483/507] ASoC: hdac_hda: Restore the codec device type on unbind
Date: Fri, 13 Nov 2026 10:53:07 -0500
Message-ID: <20261113153813.457219852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 0604315a1f0f3..9e45b20940f2f 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -633,6 +633,13 @@ static const struct snd_soc_component_driver hdac_hda_hdmi_codec = {
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
@@ -650,6 +657,11 @@ static int hdac_hda_dev_probe(struct hdac_device *hdev)
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



