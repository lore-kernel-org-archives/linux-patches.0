Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038571;
	b=pAF4ex4vFQKST7DsEpbaL9fYy0oBa59ido50kHk2MGGWdKDnyVt4njWKKG0352x//kGG
	 Xjr645NY5jtIAwZBsJ8gdRuVUcvK6M3UAQALRS/qwZRnBUuBJdA6puDncAL4Caq4Vo7S/
	 p8qaIsaFfTmVmUzNXPBOFyW3HPdE76EaswO48bC2Z9sH7vorLmZwLkSGwD/dfaC3tw+9u
	 /NQkon4FUxbrxT3fNrFF5wKnkrpIA8OjpSl7HeeTtGKmCm6hpQ3dqPttb9o45ZE8fGKbq
	 zJcpv6LucHvBeIvo9uDQ1mrOWYm1aeUDdCM2TQzdjhMmMFqmUpvClYWxNMN9b8vafVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8QKIuWNmei5hfpKjP/Xnb1piSJ/ZfPp/o6qE9I9CnjM=;
	b=y9AYs3GCbDTLvvoXFgE3QhWbWzGEAve6j+4BfHuU+M09M9qUOYjP7m5OpbdFXhiU6nNW
	 9SRfF9Xb3vuR05fgovyfT1SG5Pz6+Zs4GAIkda3N8QfdjrTrJoLjc17kVaG35mXGnHtL3
	 hAJwkKFNb6XrdrO5Q7U0Zvd+++1ycD0dyZ+bwMXWDVhFFh8Nj4bQ0R5e3EUof8sDbYgSR
	 8RjfJObYvzCou+PBc1h0xV7GZ87JRaT9KGC3B49jDFfKa/4xhz/im41oN3SiBALDLappi
	 Y/s+vvpuDc2+nUrvqYWCDy1xXsowi85Ka+jhNgxXPiB1oel17sff1s13VQzETqexfbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KxKVqEn3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56602606A32A;
	Wed, 18 Nov 2026 21:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KxKVqEn3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7107D1F000C8;
	Wed, 18 Nov 2026 21:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038571;
	bh=8QKIuWNmei5hfpKjP/Xnb1piSJ/ZfPp/o6qE9I9CnjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KxKVqEn3xupc1wcQzoY1Upkz60lLeVmwFLrH2wh6AT7hF2tHFCRx9fIfvL+/CkrD9
	 UzQW5jv/tT7HjxRxi+2nIFJxNtF28kYgn+zoc0+CK8wBYECyiHqxOQjQkGnspS3qhx
	 RhOGZhZUtlJSdW9jyBdAuwcAG50z7fGtK08iNshY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1791/3318] ASoC: hdac_hda: Restore the codec device type on unbind
Date: Wed, 18 Nov 2026 15:40:13 +0100
Message-ID: <20261118150415.589035730@linuxfoundation.org>
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
index 5a196a756aaf4..d39f93aefcbf3 100644
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
 	hlink = snd_hdac_ext_bus_get_hlink_by_name(hdev->bus, dev_name(&hdev->dev));
 	if (!hlink) {
-- 
2.53.0



