Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591603;
	b=gPuQAJ/C0SPuN4m6NvXrwuQcMn4aIyh8Pv77HrqQNBz/ca2bbIQaANQWN5QR4ba4Iy9+
	 z6YEhi8ebPBivGYy8EFSVVwuxx4SKuOd1mStcVDGwb76CHpJQR5vw1GbP2MwxiPdWbsVJ
	 Tlj694eq6U6C4SJogsY8yQzw8T9j4IeqDhpHQ3rjts02nKPK1ZcHML9w7XRHZF2J97qg3
	 nfp0VnfxK52G28Lil+IMkKOhj4XJ3nhmG4kvr/kYD3++TqifVUzCGhjJA6Q1UnFg/2ISl
	 6lyGxnj3rqpUT9WlRSEDeE0P+/eT9e1qmJj2hKUbE0j5RnGEoX+51b4DAnO9dYaejIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KVfzsIYk9L4UyC+ZKc0iswjwit9itqVhxfJ5NJIeEzk=;
	b=l5YcxW/UGcpvCufXwmkoeQbFw72ijsmrXE8/QMEhmI1R0IT3RwSVt9BC4G5s65qetr6E
	 mgyaVhxP83f4izg0hWPCb2Vsb3LMPude8N22ZvPl841nECFhMj2PiN8x7JohVpMj9c6WN
	 cSpSPXmfBUM/mF5icMZ38+nZ8AP9jctq35E4d/WTIdaEaJe9XTDNVr4EKLckAQA81Mrd1
	 OQ/S6LtR+j+6Im1zwLOcMD6teQueTf9kcxPfbdz4q8+ri/13mcA794CBBDK5npku+H12H
	 FxwHntRjnEkMl8zLg9ceMAvciyU8tszOZkmE5tORuAUx4kmBknqJPbksEMnvzMMZo1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fFU162ZX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420B9606B454;
	Fri, 13 Nov 2026 17:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fFU162ZX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B0A1F000C4;
	Fri, 13 Nov 2026 17:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591603;
	bh=KVfzsIYk9L4UyC+ZKc0iswjwit9itqVhxfJ5NJIeEzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fFU162ZXCycfEqVwrWaYXfL+2BbG69l8i+9+8TR52+OB3KVLW6iTJiPWnhZSyJcXy
	 8cJsWhCC2tfSTBpU1e8575Nm5PIGs+/3MfKlDfK951IaK4htAer0n9V/qkM+oyHuzS
	 M6+182XI0qSPA1qj/g6QWIFOgFRjjW9Zj85eyDWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 609/670] ASoC: hdac_hda: Allocate the private data at codec driver bind
Date: Fri, 13 Nov 2026 10:52:53 -0500
Message-ID: <20261113153832.456309984@linuxfoundation.org>
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

[ Upstream commit 7d357eae973a1e1933f81f55aa1b3b4e3064570f ]

The SOF HDA code allocates struct hdac_hda_priv and stores it as drvdata
of the codec device before the codec driver is bound. The driver core
clears drvdata on unbind, so after unbinding the codec driver via sysfs
a subsequent bind dereferences a NULL pointer in hdac_hda_dev_probe().

All information in the private data can be derived from the codec
device itself, so allocate and set it up in hdac_hda_dev_probe() as a
device managed resource, which is released on unbind.

Remove the allocation from SOF, keeping the check for iDisp codecs
without display audio component.

Fixes: 3fd63658caed ("ASoC: Intel: Drop hdac_ext usage for codec device creation")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261027083840.28813-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 08a44bde821d ("ASoC: hdac_hda: Restore the codec device type on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c     | 13 ++++++++++++-
 sound/soc/sof/intel/hda-codec.c | 23 ++++-------------------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index 25a145cb8a510..26c2cc1d6a18c 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -637,10 +637,21 @@ static const struct snd_soc_component_driver hdac_hda_hdmi_codec = {
 
 static int hdac_hda_dev_probe(struct hdac_device *hdev)
 {
-	struct hdac_hda_priv *hda_pvt = dev_get_drvdata(&hdev->dev);
+	struct hdac_hda_priv *hda_pvt;
 	struct hdac_ext_link *hlink;
 	int ret;
 
+	hda_pvt = devm_kzalloc(&hdev->dev, sizeof(*hda_pvt), GFP_KERNEL);
+	if (!hda_pvt)
+		return -ENOMEM;
+
+	hda_pvt->codec = dev_to_hda_codec(&hdev->dev);
+	hda_pvt->dev_index = hdev->addr;
+	/* Intel iDisp (HDMI/DP) codec */
+	if (((hdev->vendor_id >> 16) & 0xFFFF) == 0x8086)
+		hda_pvt->need_display_power = true;
+	dev_set_drvdata(&hdev->dev, hda_pvt);
+
 	/* hold the ref while we probe */
 	hlink = snd_hdac_ext_bus_get_hlink_by_name(hdev->bus, dev_name(&hdev->dev));
 	if (!hlink) {
diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index c0c58b4297155..57998d3d8d15b 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -15,8 +15,6 @@
 #include "hda.h"
 
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC)
-#include "../../codecs/hdac_hda.h"
-
 #define CODEC_PROBE_RETRIES	3
 
 #define IDISP_VID_INTEL	0x80860000
@@ -148,7 +146,6 @@ static struct hda_codec *hda_codec_device_init(struct hdac_bus *bus, int addr, i
 /* probe individual codec */
 static int hda_codec_probe(struct snd_sof_dev *sdev, int address)
 {
-	struct hdac_hda_priv *hda_priv;
 	struct hda_bus *hbus = sof_to_hbus(sdev);
 	struct hda_codec *codec;
 	u32 hda_cmd = (address << 28) | (AC_NODE_ROOT << 20) |
@@ -168,27 +165,15 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address)
 	dev_dbg(sdev->dev, "HDA codec #%d probed OK: response: %x\n",
 		address, resp);
 
-	hda_priv = devm_kzalloc(sdev->dev, sizeof(*hda_priv), GFP_KERNEL);
-	if (!hda_priv)
-		return -ENOMEM;
-
 	codec = hda_codec_device_init(&hbus->core, address, HDA_DEV_LEGACY);
 	ret = PTR_ERR_OR_ZERO(codec);
 	if (ret < 0)
 		return ret;
 
-	hda_priv->codec = codec;
-	hda_priv->dev_index = address;
-	dev_set_drvdata(&codec->core.dev, hda_priv);
-
-	if ((resp & 0xFFFF0000) == IDISP_VID_INTEL) {
-		if (!hbus->core.audio_component) {
-			dev_dbg(sdev->dev,
-				"iDisp hw present but no driver\n");
-			ret = -ENOENT;
-			goto out;
-		}
-		hda_priv->need_display_power = true;
+	if ((resp & 0xFFFF0000) == IDISP_VID_INTEL && !hbus->core.audio_component) {
+		dev_dbg(sdev->dev, "iDisp hw present but no driver\n");
+		ret = -ENOENT;
+		goto out;
 	}
 
 	if (is_generic_config(hbus))
-- 
2.53.0



