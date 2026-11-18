Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042922;
	b=lKT4c3AdP2UilJCSmXITox9+XlwSfy8FAjJkIhIPUMetARpuMJNsMIuOVorjxTdvAa7n
	 nMzCL8CiHe9T1jELliOmX65QFRh2Dl2tQasHX5XP9m7PculhJPhYz4LvcJnWTmF1Zr+qa
	 X6D5nwHFeCDdFx9Abn2gHnFJPGN6Ln4l6kkfdnkY0eOv+tqO7PCMYaEIYBgZt/eEGOyWt
	 npgyWaXXpPR+B3pX152h3i3lZjSJOAJRcVWdYd8khLv713h46IUeOaK+BbUWz/AStV9cl
	 BYIWC64vN+74HOMjs0MbfgQb9jTuiAE8h36cMmLbOdO4Gj3a62s7/yXIQM0+Fy4UwoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iFyyXnEVtnXANQGta48CMCkrvnkOLxPBV8aVUkxRiV4=;
	b=mdiSXLjthCCG715izMF+bRuw+YEFeTLOVEItxDMGKNvkxaQGylk+OD695Cm+gU4ugay/
	 ipBxt9+XjXLbUMhN+ogaJRcWWT2Q/uGBjDbImQnR2+qWE4sE+sreLLkFtAAk9xYQFyioC
	 lPxqnRTnL4iN1TWUdC+zc7KUMz/vz30/W+eJi2zOLpnGIa0l6rlRIghtW5yPXE8VmLwgS
	 /Pw30RoaFsQBq1AFoh7lrHQbS8F/6MW5+EzMQykochq0mzz/2JvP37VVFn+mVFC6fvoIg
	 YWP4hBWAa6n1J7KI6dODyVJ5JV6o2MPblW1siqAd5RclMMLUqWqoVihICaiH3tGnkOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RAU/gG+2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179F3606A31C;
	Wed, 18 Nov 2026 23:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAU/gG+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EF91F000C4;
	Wed, 18 Nov 2026 23:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042922;
	bh=iFyyXnEVtnXANQGta48CMCkrvnkOLxPBV8aVUkxRiV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAU/gG+2a+FAGiSAaQECtSSFLtvpyjr4fc806hhRyzFpRRj94HZGyhONc7bQoMw1M
	 R/MJ/OFiPz8wlBCkjZC8GKultJxvU0afDPc0ROof+ZMvAn+s8IHrRmhBwac7EcHL5e
	 2rEHSVUdYmidGq+H+PagAoBNH9/z1AUdbDZrq7Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0028/2857] ASoC: hdac_hdmi: Fix resource cleanup on probe failure
Date: Wed, 18 Nov 2026 15:17:42 +0100
Message-ID: <20261118150202.364394702@linuxfoundation.org>
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
index b9e2e5a960139..f11a60c092cf8 100644
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



