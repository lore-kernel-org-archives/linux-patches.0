Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053057;
	b=wHjBJ1eatroOvXm+0AxsQGRpRHeguvBFCHoJu7alUiuWc2ldQ9n2kc+goX+4mlntXICn
	 Bx+ulBlGKQ9mR7yQvuwlr+FtbSJWZ1BORlNzkxT3/IY6IKq88XGi5D77+muprzn5GtrSW
	 sqHpDZYh/sT0zV9+0qSkCzt3XpCBWTIs77RfPRHe5YHmZBRkd/0U8L61TQxGKcXwrCg5j
	 r5tXjG7PBd0zp45evtREQG8dajLebDJPCa+LlwFVHDEwTFQM9SD8bPQC+LDGzY4fCRQuI
	 Ni/OWnfbqFA265rPtwYYGTKmSzI6PNu/ZKD/vomt4E9s0aESir8g2h3lITpR++Uvu2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n0J1FbDHV2jZawdFCKwlVjXr/dXvS8DRbya7yoP/QNo=;
	b=iNuZ/w1OZReJj4VYl2kI4tShQLR1i5GYRn1SKa5U7Sy46KDhQjKiRubiaRRL+xD85m33
	 +yti5TAsw0Co3a5lHM69kSodHQGXPzexLGm5psLdLUzCkW9g7Pvm8UXBMmyg2PY/fMqVk
	 aCL34RoLrjCOyN50CUXMQGMBa/LWggi/shAYmo19on41k2gqNYIgwfjrl1nCC96t3myJB
	 jChageYVzCLBEvrkBgNXZ9BLMn+wbJ4ikpCjuIZvn/Rlb6qN8s+hTP6b/sKCcQ2IsCjJ+
	 vGVKF0m54zZbp6bhYISbiiuwTZrKTK9VMAt8qjs3ylH0Ynb3yLy7iWQvEFSwrapovdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PWoLhPH1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B712606A32A;
	Thu, 19 Nov 2026 01:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PWoLhPH1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21091F000C4;
	Thu, 19 Nov 2026 01:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053057;
	bh=n0J1FbDHV2jZawdFCKwlVjXr/dXvS8DRbya7yoP/QNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWoLhPH1O/UPGbJYSJZoJSWZ6lDMpl4rqJfdQnyuxk5iygOk5pz/DnaBWt9c/gHs6
	 bNYMlDYXGxmd9KRnVRvo2WYO+gyuWUw75amPHIRyqvA6sqGBkj6e1dvRXpFf/IzyTj
	 keMw6lemgsBDtz70w+hlbAh33+cq4veBN8NT/3dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0737/2214] ASoC: hdac_hda: Keep runtime PM state in sync across codec remove/probe
Date: Wed, 18 Nov 2026 15:40:13 +0100
Message-ID: <20261118150041.308162665@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 99203e8d8968def973e82bb712ea959c6a46c16e ]

After the codec has been removed, its runtime PM status is
RPM_SUSPENDED while hdac_hda_codec_probe() powers the codec up via
snd_hda_codec_device_new(). The pm_runtime_put()/snd_hda_power_down()
calls on probe and registration then see an already suspended device,
the codec suspend callback is not called and the codec, its HDA link and
the codec_powered bit stay set, preventing the controller from runtime
suspending.

The remove has a similar problem with the codec link accounting:
hdac_hda_codec_remove() drops the link reference taken in probe without
looking at the runtime PM state of the codec. If the codec was already
runtime suspended, the link reference has been dropped by the codec
suspend callback and the remove drops it a second time.

Resume the codec in hdac_hda_codec_remove() before disabling runtime PM
so that the link reference and the codec_powered bit are always in the
same state as after the probe, and mark the device active on probe once
the codec has been powered up.

Finally mark the codec device suspended at the end of the remove. Its
runtime PM is disabled at this point and if only the ASoC card is
unbound (e.g. by unbinding the machine driver), a following system
suspend would otherwise call the runtime suspend callback on the already
cleaned up codec via pm_runtime_force_suspend().

This is a followup patch to address Sashiko reports.

Link: https://lore.kernel.org/linux-sound/20261027083840.28813-4-peter.ujfalusi@linux.intel.com/
Fixes: c3ec8ac82105 ("ASoC: hdac_hda: fix memleak on module unload")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261027144655.31988-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index 02936e5f8f64a..b113b33133e88 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -481,6 +481,9 @@ static int hdac_hda_codec_probe(struct snd_soc_component *component)
 		snd_hdac_display_power(hdev->bus,
 				       HDA_CODEC_IDX_CONTROLLER, false);
 
+	/* The codec is in D0, the status is RPM_SUSPENDED after a previous unbind */
+	pm_runtime_set_active(&hdev->dev);
+
 	/* match for forbid call in snd_hda_codec_device_new() */
 	pm_runtime_allow(&hdev->dev);
 
@@ -520,6 +523,12 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 		return;
 	}
 
+	/*
+	 * Resume the codec to have its link reference (dropped below) and
+	 * codec_powered bit in the same state as after the probe.
+	 */
+	pm_runtime_get_sync(&hdev->dev);
+
 	/* prevent runtime PM callbacks while the link and the codec are torn down */
 	pm_runtime_disable(&hdev->dev);
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
@@ -531,6 +540,9 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 
 	/* Balances the disable above, cleanup_for_unbind keeps runtime PM disabled */
 	pm_runtime_enable(&hdev->dev);
+	pm_runtime_put_noidle(&hdev->dev);
+	/* The codec is cleaned up, system suspend must skip it from now on */
+	pm_runtime_set_suspended(&hdev->dev);
 }
 
 static const struct snd_soc_dapm_route hdac_hda_dapm_routes[] = {
-- 
2.53.0



