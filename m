Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050948;
	b=O7jZJCgy7eBc5ZZU+SEETdD8aJq9AWr8URbKRJouBbUFIb9Ug9uhWKjk7+6gisnHowF7
	 AGU+goY38A/k1/bH9pXNjpLmUOMpsIwoUvDQdRZB7/x3XRW09h+YF7RDfFfA6cuDnsPRr
	 FDUgbhKaO7mxUAS+4+5oLtv2MuY6wqokpRl/7yOFMnccd+3O5FO+yn1cTb5kZG6xGjD5i
	 ntl9JOaoPXTdcWbzm4T6Vgb9xBfvT3goUFUdGgzudqwkSysljYv3UGl+6CjkauwIopMT2
	 nbOOQaXXKpxSeVVKDdCRv8tHXErx7eGFzrF6lccqir66FrYpk8aCu0pXVC4UnaZMKVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ypXlzOCO/bEd3DYT5Rv1M4UBUPAHwGJ1DNfwXqjBAnE=;
	b=wlmjXmS9sSNDAs1a2NMKprSnkIAVjsKiZqe+GBLlN9NMP8HEXBJ9P94cQBRwg5OmR4oj
	 jHkdlvt1OErv9oE5Mn1wdx4PbgW3rDk5kjS6EbnhR0hJhwI0lFEAKqvlRYkl2QWoP+HmM
	 NBkf9eHrkUmF+x1v0K8/d4T7DEIgZuwsMRLAV5LZx/Roz0KeVGL6S5wXWdgTnB6hktCBv
	 E8jRzpGI04MpHvd+0b0ouugN15VEbcE1JwaQvXsfQQRArQKhE7fyJmReQJ1vig8l0/J5p
	 F5bNoN0JbueBIYixZJzhdo9KHefkYXTvJvqZkLhO7uxKnbBiLqiyp19yjinyvTYYXkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yLLl4nIV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D74606A33F;
	Thu, 19 Nov 2026 01:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yLLl4nIV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3AD1F000CA;
	Thu, 19 Nov 2026 01:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050948;
	bh=ypXlzOCO/bEd3DYT5Rv1M4UBUPAHwGJ1DNfwXqjBAnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yLLl4nIV43JxGBfPIU2Hm22EGqrKNnbpzcYtLsmXOuyr0rPA+c+PxEBCJVGROUNfl
	 H7Yug8+QT9Joq0P2PNfLpRsWZKK8HdWyBeQbyGvdBQAWeEh447nezPAAod91AlAhPG
	 ku54pNZWEu6tKH7BCJbMTMIvQtbtGGe9XB8+nDDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0034/2214] ASoC: hdac_hdmi: Fix resource cleanup on probe failure
Date: Wed, 18 Nov 2026 15:28:30 +0100
Message-ID: <20261118150011.453804884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6a17926fa8692..7bfb3ee325212 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -2163,8 +2163,10 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	snd_hdac_ext_bus_link_get(hdev->bus, hlink);
 
 	hdmi_priv = devm_kzalloc(&hdev->dev, sizeof(*hdmi_priv), GFP_KERNEL);
-	if (hdmi_priv == NULL)
+	if (hdmi_priv == NULL) {
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 		return -ENOMEM;
+	}
 
 	snd_hdac_register_chmap_ops(hdev, &hdmi_priv->chmap);
 	hdmi_priv->chmap.ops.get_chmap = hdac_hdmi_get_chmap;
@@ -2173,8 +2175,10 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	hdmi_priv->chmap.ops.get_spk_alloc = hdac_hdmi_get_spk_alloc;
 	hdmi_priv->hdev = hdev;
 
-	if (!hdac_id)
+	if (!hdac_id) {
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 		return -ENODEV;
+	}
 
 	if (hdac_id->driver_data)
 		hdmi_priv->drv_data =
@@ -2199,6 +2203,8 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
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



