Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033605;
	b=5dlZLXkzlmkT5lnzeiBimMZaJQnTVoUA2PYry76RPhRJq+F/vG8x0aXnwUat3F9Iv4wT
	 GbuG0LAsgrg8/sE4cyem6Ds0V6QcWeAHFHzsVTR0TgJmbvdROcDIFRIRTqS6/45zpGNv2
	 H908PWVyizwtOnwysvt7R8pI3mEOLmtukKG4PiYHOkkQaPECuBswBkDAeJi8XsuF7iec4
	 tuLPUDv4qz0DZ7UHIvPVAPAWC2K5BSWo7KEmA5DJrrJAN+q7jPTxrO7waW4nOQ74Z7y2L
	 mk4ud/DD3XuYpKU5T6lrbqJTdpRXDcr9MXW/qxgQNL8stV5flQrxOkLOlaAQPRK11kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CCyippY+3NnnztdJY2/pqtVnt4PZ2rO+dZmAeEhHcwk=;
	b=wuniCg5tJBwg0NiDuUIqsJa2UJ4mNldoDj8lGZx9SJ6V9ioHwIurj2/bcaeSuAoT+Z5h
	 7esDcyYY84GVuzplornp/7gukx8TZ/J3wEEsMyt4fx5pIbPtuL8b7lUAFGUV/OCB7DL0P
	 uyTempRU/WTUvRpuWdxjIuvzaSQLqipmlgdPcbjaLoC+xaDxnSJ1gWt2KP6IGVE+6cIAr
	 /8x9CJ7urPPm8sCIu+/7bgiSVwoldpLJXUXXR4wkABF5PD9QY8oxyVy5QAmod4+edr0UC
	 deVirSSaDc4lkg5nWZSWmkqJzewt2QO8eZ1MpyYQbh5gE5nJUxT7gk60m00BKljLR6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ji9RL0Kf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBD3606A31C;
	Wed, 18 Nov 2026 20:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ji9RL0Kf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C285C1F000C4;
	Wed, 18 Nov 2026 20:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033605;
	bh=CCyippY+3NnnztdJY2/pqtVnt4PZ2rO+dZmAeEhHcwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ji9RL0KfTvIzgxuzMnV+8RGTYFSlTCELFvCzj5To35nEHb2/Wuf4/OyMuyCV3uVri
	 JZUfwPFrNx/U9VuszgohOMkqAL1yYPxP+eoSqV1SAnehDMVXK5OvIc/h3+7gEdB9d2
	 UXRSEsNLtXzIobfPM19xYiPPbYwLD4zKqcqn4Z78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0032/3318] ASoC: hdac_hdmi: Fix resource cleanup on probe failure
Date: Wed, 18 Nov 2026 15:10:54 +0100
Message-ID: <20261118150314.767415339@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 785903b7770f19ea05b8a76081dff691c56fa771 ]

hdac_hdmi_dev_probe() gets the HDA link before allocating and
initializing the HDMI codec private data. Several later error
paths return directly without dropping the link reference,
leaving the hlink refcount unbalanced.

Release the link reference on probe failures. Also turn display
power off if the failure happens after it has been enabled.

This issue was dicussed in:
https://lore.kernel.org/all/s5h1s0esk8o.wl-tiwai@suse.de/
I think the paths fixed here are probe failure paths: the device
has not been fully initialized or bound, and runtime PM suspend
cannot be relied on to balance the reference taken during probe.

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20260622151127.1198196-1-haoxiang_li2024@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hdmi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/hdac_hdmi.c b/sound/soc/codecs/hdac_hdmi.c
index 7707f0b5562d4..4ff3c1d9eaa07 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -2162,8 +2162,10 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	snd_hdac_ext_bus_link_get(hdev->bus, hlink);
 
 	hdmi_priv = devm_kzalloc(&hdev->dev, sizeof(*hdmi_priv), GFP_KERNEL);
-	if (hdmi_priv == NULL)
+	if (hdmi_priv == NULL) {
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 		return -ENOMEM;
+	}
 
 	snd_hdac_register_chmap_ops(hdev, &hdmi_priv->chmap);
 	hdmi_priv->chmap.ops.get_chmap = hdac_hdmi_get_chmap;
@@ -2172,8 +2174,10 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	hdmi_priv->chmap.ops.get_spk_alloc = hdac_hdmi_get_spk_alloc;
 	hdmi_priv->hdev = hdev;
 
-	if (!hdac_id)
+	if (!hdac_id) {
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 		return -ENODEV;
+	}
 
 	if (hdac_id->driver_data)
 		hdmi_priv->drv_data =
@@ -2198,6 +2202,8 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	if (ret < 0) {
 		dev_err(&hdev->dev,
 			"Failed in parse and map nid with err: %d\n", ret);
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
+		snd_hdac_display_power(hdev->bus, hdev->addr, false);
 		return ret;
 	}
 	snd_hdac_refresh_widgets(hdev);
-- 
2.53.0



