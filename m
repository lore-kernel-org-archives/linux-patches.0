Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057171;
	b=G59g5/L4apJ3tpedprDJN1RRIxXMNDYK64n/aOyoAz93YnymoZeLChBnfRQ3ICuT7PHV
	 UcMYcyFxV0zAriT15KzeGHBoI5pbylTPoA8/tAJ2BEEKlv+/6WycHRV4TgW+7tnULI/ls
	 Nm5p56vmzCDcB5QVvxlpimwrUh0MQ3taGa/+xgv00cR/ojdgTxL8Dcsa0CQs9zZa0Gkg6
	 rnzP/GWvXcEd4/MlWNSH5tePXHH1Pbcy+6aoMZTjk9Ua5aEnieNHxzNhC7hoVOOFXFsGF
	 NA5RhIozwItUVxhAHlk+B6/rFWBn9h0PLANEwa5+cd1yEkeaJzvVOdgNuuPPYThlK5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qRAkSu4SILTKXOExc7CKd9f6r3YmumwozV5KXLpT78M=;
	b=TGg87/wJVTjn35eka09D584k7clGatzbaOjH7iwgkNI2uExVw+ikU3tdJocGZKgllrQq
	 J+sKvmboQVB4XcPu3Fks2mUWGW82y822tBUJa5WJF19dn4RDvVL2Rvh+OgaBfYJwSf8RV
	 /uE5y7S5q+EoOuuYc45aNjbuCRGc0eJpygfAOpQC7X/AJgecgEbIevbyed7yuoEhtHlkT
	 qJd3w7Vc58POnrynMC2v9FyV6Qa2znKwMIT4X6DM3N/+6RSc6v1UympujeqsedXFzQ7DC
	 XZ8Ly35PtTyHyGCt1EdLXacXror2eNh6C5aubYMtU6Brx44lUgZxHAO+jriwSg6Pk0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X4g3LmXu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBE4606A333;
	Thu, 19 Nov 2026 02:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X4g3LmXu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5CC1F000C6;
	Thu, 19 Nov 2026 02:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057171;
	bh=qRAkSu4SILTKXOExc7CKd9f6r3YmumwozV5KXLpT78M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4g3LmXuBGi6psvLQ3mvfmqFfvJGRSaiHaJeOu6X9mYbh0xx5scwa/ysJ6TFnE80U
	 KVEqDaHKu1ZWcOAf7qRUZmK1V61EJeSwe1bvYQw/swoqqylOwD6SQGka73QMsa3hd9
	 xjo4iyajVFj68VaOON74Zv3dF5Yh72kly2aF9H3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0035/1848] ASoC: hdac_hdmi: Fix resource cleanup on probe failure
Date: Wed, 18 Nov 2026 15:34:33 +0100
Message-ID: <20261118145912.619054373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 76e06c88f2796..8ee569f015883 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -2161,8 +2161,10 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	snd_hdac_ext_bus_link_get(hdev->bus, hlink);
 
 	hdmi_priv = devm_kzalloc(&hdev->dev, sizeof(*hdmi_priv), GFP_KERNEL);
-	if (hdmi_priv == NULL)
+	if (hdmi_priv == NULL) {
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 		return -ENOMEM;
+	}
 
 	snd_hdac_register_chmap_ops(hdev, &hdmi_priv->chmap);
 	hdmi_priv->chmap.ops.get_chmap = hdac_hdmi_get_chmap;
@@ -2171,8 +2173,10 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	hdmi_priv->chmap.ops.get_spk_alloc = hdac_hdmi_get_spk_alloc;
 	hdmi_priv->hdev = hdev;
 
-	if (!hdac_id)
+	if (!hdac_id) {
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 		return -ENODEV;
+	}
 
 	if (hdac_id->driver_data)
 		hdmi_priv->drv_data =
@@ -2197,6 +2201,8 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
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



