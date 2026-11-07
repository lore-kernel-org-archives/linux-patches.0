Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060602;
	b=AA9LdIi3IDzp5VPW50TyatD2UKxps5b2CRJp08fXn+AA+upul4GlF+h9oBmcz/LMq2E7
	 tMiwyOdWjgYEldyVy+oC5mk91xhNoCFhWipR1ynRNk02gMrCx7X15DfpIbNystYiO6TJQ
	 jtGBAz9fnpGJGOAXla8SP7Kle5FrGJCb5DepID1DJ3S4ryDK9w1IdYg5MiFIJOp0h6IPf
	 RGrhbwjrveD/O7av0kcSvlOHzKUtFfaoa515pnMcgXiQ+TJJAgzDs62z52f8AOWm7VxsY
	 62tfpEY5lc0zoUYoWfE8RrEs3GvZ0gzyZsyA0AxlhP4r5YZmZf0p+dtG0e/fY6hwp8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bxuU7MPmSOSh0sw9wgg6QwupPLxlVB8tag09DuC4sH8=;
	b=IOzYYiaCKGK2xy1mRpyASSwWJyKuEQ2NsKZ+ssq/QPA1YLdjDDZNWeC82csrO8pIYtOd
	 xbxl21Y8Gh3/izDHrcp0HlgloBMllctobt9BaR5bVF6qdrtQoXh1cNc8bOMUQ+Efd9M2K
	 iOLKfIK5PF1ZXfpArkewdexIEK0aI3FUcQ1cDhFJIebKGwY3E4mkvTRqKzt3UEsOtFDYD
	 ta0kV4lH9ABj75++0RYjPAYzbKz3FGlgriQkTlsaokp4nzjwQl9lp7OkOxRR2KsTag+XC
	 d/uMBuvkiE57jkcgwUZ+KwtEtqGxxebwczzNsKPjuseR5sfrwLXEq4P+ORgnFoZPiIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CzeKQZ05;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8F6606A32C;
	Sat,  7 Nov 2026 14:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CzeKQZ05
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397B11F0089F;
	Sat,  7 Nov 2026 14:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060601;
	bh=bxuU7MPmSOSh0sw9wgg6QwupPLxlVB8tag09DuC4sH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzeKQZ058l9PSB0xpoYdyeBi/NJ+7ZyKRYjLlbq4dh/kFXzuQZauWMa8JTtD3mV7a
	 gNzzmAMh4JEvhQbdokKZWaYY/m7qmZ1CMK65qoZQl0Lc+aGjeG/6cdgvO4EWqvzUu+
	 7FjGRiOWJ6ILcbMA9aOCUAFrTuCN9vc0d69SIfik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0038/1536] ASoC: hdac_hdmi: Fix resource cleanup on probe failure
Date: Sat,  7 Nov 2026 08:34:14 -0500
Message-ID: <20261107134958.733967084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 183c5a50a4e37..eef142ac4ad76 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -2164,8 +2164,10 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	snd_hdac_ext_bus_link_get(hdev->bus, hlink);
 
 	hdmi_priv = devm_kzalloc(&hdev->dev, sizeof(*hdmi_priv), GFP_KERNEL);
-	if (hdmi_priv == NULL)
+	if (hdmi_priv == NULL) {
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 		return -ENOMEM;
+	}
 
 	snd_hdac_register_chmap_ops(hdev, &hdmi_priv->chmap);
 	hdmi_priv->chmap.ops.get_chmap = hdac_hdmi_get_chmap;
@@ -2174,8 +2176,10 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	hdmi_priv->chmap.ops.get_spk_alloc = hdac_hdmi_get_spk_alloc;
 	hdmi_priv->hdev = hdev;
 
-	if (!hdac_id)
+	if (!hdac_id) {
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 		return -ENODEV;
+	}
 
 	if (hdac_id->driver_data)
 		hdmi_priv->drv_data =
@@ -2200,6 +2204,8 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
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



