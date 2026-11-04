Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829301;
	b=LfiY/NVMs56lMrVwAQu0HpsNiV+nj0D+o4ccH7vgK6jokkO7QeuwGGgu4zQlev1SXWYO
	 S3jz13T4/2vya6SxHnbNWWkd6djR1C4qtjMXsmt6mrE35uOydnSdBeZ37s2+NakjyzeeA
	 gRYVaamV5CERQ9HNHV9VGgIT2hx5esFD7t0J7gVy1m4ASb9asCFyA5ghIRTfArjiqi1cS
	 jR1VV+A/keNOGq2I/79IQZGmyiOwqRoiC0mbPo5Aoth3nNflmZg7Ob1ZI0zZSyVLfo2kS
	 1QiOshY0CAWSfCuFKit/1gGFRGkwQ5GZm0ELq8+fpCTyNyyveE+djwtR9X5oMRH+vWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x193mdMzCOoo60wz4FvgTENx8aBJ9MF6paEP57ZJ+/U=;
	b=EvENGqvD1nzlKmBwFbecFcq9u90nQoeLhWgHkFQbfdx+3yVQyqorvpp/C4FksmFImJx/
	 Fsq4o8pD611cNpBwveR5bgGx6Aahaoluk1yuUe2b4B+ASRXv8uXCirnEGAEIbp7vMtsUH
	 BkNAvDIBvvjDATRH8Ger9RR33yoNJSWQD3m7nrGY2+YNuFMKCgPkJHBdwjNApAP5Nt8dI
	 Mb5jz82wbVE4vHJ75Ptx8xnSflxMUCkD23jH8dU8vIK6e69cMnW9nGhdVXfQXJkSzmwZI
	 lNhJQ/q9ZTAJBWFYiy3+Q0MwxlWtcQOxn91CLgHem2LpAy/tbLi2tTQxapB/0aTM/lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vSOioADN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ECD6086604;
	Wed,  4 Nov 2026 21:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vSOioADN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F0A1F000C1;
	Wed,  4 Nov 2026 21:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829301;
	bh=x193mdMzCOoo60wz4FvgTENx8aBJ9MF6paEP57ZJ+/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vSOioADNi2yDvN57vngv8SlbcJpxMZG2dwgvzGbnzWjCO0HNXkbc4EXHbO+5ycxfQ
	 y/XCmanrpR9ui2zxVKe63YsPIrbrRA8eHxyeYt4X6QKIpmYt6xrox1HMQ7rPqE/Ode
	 kLHEC1bvmq4HEMxx7sMJaOMH7+BBAy9SpggB8wl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0038/1005] ASoC: hdac_hdmi: Fix resource cleanup on probe failure
Date: Wed,  4 Nov 2026 15:56:11 -0500
Message-ID: <20261104211044.639995985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 2385e18127a33..1ca5e7aa42aca 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -1861,8 +1861,10 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	snd_hdac_ext_bus_link_get(hdev->bus, hlink);
 
 	hdmi_priv = devm_kzalloc(&hdev->dev, sizeof(*hdmi_priv), GFP_KERNEL);
-	if (hdmi_priv == NULL)
+	if (hdmi_priv == NULL) {
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 		return -ENOMEM;
+	}
 
 	snd_hdac_register_chmap_ops(hdev, &hdmi_priv->chmap);
 	hdmi_priv->chmap.ops.get_chmap = hdac_hdmi_get_chmap;
@@ -1871,8 +1873,10 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	hdmi_priv->chmap.ops.get_spk_alloc = hdac_hdmi_get_spk_alloc;
 	hdmi_priv->hdev = hdev;
 
-	if (!hdac_id)
+	if (!hdac_id) {
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 		return -ENODEV;
+	}
 
 	if (hdac_id->driver_data)
 		hdmi_priv->drv_data =
@@ -1897,6 +1901,8 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
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



