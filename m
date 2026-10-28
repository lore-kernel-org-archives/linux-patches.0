Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215287;
	b=CkUjziRcueLR1g1LfVHmzQEBVSYBJmaaU2ouluRdo0xC7KME+2b/52urzOxFul72EpIx
	 U6wWXNinB6SPVRiAHb9f5E0tYwMVYBmP32XXQSkqDDea1ZJEnglK70XC5iLhNTo4Hfbph
	 v2RSbRgQPbCepju7RmAipPvr+/dD+NuA0zh/CnRX8FhV/rtQ5qooPc3xHmx9OVUaIiWZR
	 O0tLIKnwvsm+s724MJdVceFnv4Pf5cWEPZxxU4fTeOrlEx5haBYDIoGPEtm0kSthxluFS
	 K4qObKK5OYJwIxsD3wad3rh6DYUd5zjAB1wdH8ahwnP1WiXE2w3ePua03R+URjn+MqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rdzQ3K7tlmTauTHWd8+Kc/WhsCZkOLhsIKmc8T29kMc=;
	b=rDmYrPBTqmWNje5IR49EjQK4MmLdH5CXp9ixPSMNJ2fKhtIMVCyJ/1uLxGc1w0ooFpGA
	 NUYuGSonSbQwxfuidccbDsoKZzMNwM+sdUe3fPZeU/xd3aYwVUGWJ06/ZhntCyoxXLSmT
	 mZpB2G8gv4j6QM6U883puhOM+odfm/XZs1SEdGW24DUrxGNNe1pFZKoZQnV5h9t8TC/OY
	 2UVtqhJBbLne1DlFiQR+UZlZBaJjjKeDOkrsWIHbuBvJ1Ts+LUphpiVWa2mKIxfNUgyPZ
	 T/ErMATq0FrbAEaPWTNzRmNSQ/q38LrB+/gF1q5K8qUOMVU9BUzfPKRf2WILqNPNCMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hUvA3IZo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A2C606A31E;
	Wed, 28 Oct 2026 19:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hUvA3IZo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589381F01825;
	Wed, 28 Oct 2026 19:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215286;
	bh=rdzQ3K7tlmTauTHWd8+Kc/WhsCZkOLhsIKmc8T29kMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUvA3IZoZfwYbSuHb3yrBt6wFtIJ4Y0ek1YNN0wtTUtrh0FHCNLtTp052JUJRjR3+
	 xMr1V1cdKag92HyDkT3Z2HIXnSSDUCIphZnJBdfiYU0pRr9eEKLXw8wYbSMhTrZcXU
	 AaH+yaJU1axE7K2lxM/MKrw1EIOTGWykR9GTMNmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1158/1887] ALSA: hda/cs35l41: Fix firmware load work teardown
Date: Wed, 28 Oct 2026 17:54:14 +0100
Message-ID: <20261028170525.756317056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit b65020d5398f499c09498c9786dba6d67ae57664 ]

cs35l41_hda creates ALSA controls whose private data points at the
cs35l41_hda object. The firmware load control can also queue
fw_load_work.

Those controls are not removed on component unbind, and device remove
only cancels fw_load_work through cs35l41_remove_dsp(). That helper is
skipped when halo_initialized is false. With firmware_autostart
disabled, a firmware load can be requested before the DSP has been
initialized. If the component or device is removed before the queued
work runs, the worker can run after teardown and dereference driver
state that is no longer valid.

Track the created controls and remove them on unbind so no new control
callback can reach the driver data or queue more work. Then cancel
fw_load_work to drain any request that was already queued. Also cancel
the work unconditionally during device remove before runtime PM teardown.

Fixes: 47ceabd99a28 ("ALSA: hda: cs35l41: Support Firmware switching and reloading")
Fixes: 4c870513fbb0 ("ALSA: hda: cs35l41: Add read-only ALSA control for forced mute")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Reviewed-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260511-alsa-hda-cs35l41-fw-work-teardown-v1-1-1184e9bc4f25@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda.c | 74 ++++++++++++++++++++++++++++---------
 sound/pci/hda/cs35l41_hda.h |  4 ++
 2 files changed, 61 insertions(+), 17 deletions(-)

diff --git a/sound/pci/hda/cs35l41_hda.c b/sound/pci/hda/cs35l41_hda.c
index 63395d2bf45c2..5f2bf06c0fbcb 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -894,6 +894,44 @@ static int cs35l41_fw_type_ctl_info(struct snd_kcontrol *kcontrol, struct snd_ct
 	return snd_ctl_enum_info(uinfo, 1, ARRAY_SIZE(hda_cs_dsp_fw_ids), hda_cs_dsp_fw_ids);
 }
 
+static void cs35l41_remove_controls(struct cs35l41_hda *cs35l41)
+{
+	if (!cs35l41->codec)
+		return;
+
+	if (cs35l41->fw_load_ctl) {
+		snd_ctl_remove(cs35l41->codec->card, cs35l41->fw_load_ctl);
+		cs35l41->fw_load_ctl = NULL;
+	}
+
+	if (cs35l41->fw_type_ctl) {
+		snd_ctl_remove(cs35l41->codec->card, cs35l41->fw_type_ctl);
+		cs35l41->fw_type_ctl = NULL;
+	}
+}
+
+static int cs35l41_add_control(struct cs35l41_hda *cs35l41,
+			       struct snd_kcontrol_new *ctl,
+			       struct snd_kcontrol **kctl)
+{
+	int ret;
+
+	*kctl = snd_ctl_new1(ctl, cs35l41);
+	if (!*kctl)
+		return -ENOMEM;
+
+	ret = snd_ctl_add(cs35l41->codec->card, *kctl);
+	if (ret) {
+		dev_err(cs35l41->dev, "Failed to add KControl %s = %d\n", ctl->name, ret);
+		*kctl = NULL;
+		return ret;
+	}
+
+	dev_dbg(cs35l41->dev, "Added Control %s\n", ctl->name);
+
+	return 0;
+}
+
 static int cs35l41_create_controls(struct cs35l41_hda *cs35l41)
 {
 	char fw_type_ctl_name[SNDRV_CTL_ELEM_ID_NAME_MAXLEN];
@@ -919,23 +957,19 @@ static int cs35l41_create_controls(struct cs35l41_hda *cs35l41)
 	scnprintf(fw_load_ctl_name, SNDRV_CTL_ELEM_ID_NAME_MAXLEN, "%s DSP1 Firmware Load",
 		  cs35l41->amp_name);
 
-	ret = snd_ctl_add(cs35l41->codec->card, snd_ctl_new1(&fw_type_ctl, cs35l41));
-	if (ret) {
-		dev_err(cs35l41->dev, "Failed to add KControl %s = %d\n", fw_type_ctl.name, ret);
-		return ret;
-	}
-
-	dev_dbg(cs35l41->dev, "Added Control %s\n", fw_type_ctl.name);
-
-	ret = snd_ctl_add(cs35l41->codec->card, snd_ctl_new1(&fw_load_ctl, cs35l41));
-	if (ret) {
-		dev_err(cs35l41->dev, "Failed to add KControl %s = %d\n", fw_load_ctl.name, ret);
-		return ret;
-	}
+	ret = cs35l41_add_control(cs35l41, &fw_type_ctl, &cs35l41->fw_type_ctl);
+	if (ret)
+		goto err;
 
-	dev_dbg(cs35l41->dev, "Added Control %s\n", fw_load_ctl.name);
+	ret = cs35l41_add_control(cs35l41, &fw_load_ctl, &cs35l41->fw_load_ctl);
+	if (ret)
+		goto err;
 
 	return 0;
+
+err:
+	cs35l41_remove_controls(cs35l41);
+	return ret;
 }
 
 static int cs35l41_hda_bind(struct device *dev, struct device *master, void *master_data)
@@ -990,8 +1024,13 @@ static void cs35l41_hda_unbind(struct device *dev, struct device *master, void *
 	struct cs35l41_hda *cs35l41 = dev_get_drvdata(dev);
 	struct hda_component *comps = master_data;
 
-	if (comps[cs35l41->index].dev == dev)
+	if (comps[cs35l41->index].dev == dev) {
 		memset(&comps[cs35l41->index], 0, sizeof(*comps));
+
+		cs35l41_remove_controls(cs35l41);
+		cancel_work_sync(&cs35l41->fw_load_work);
+		cs35l41->codec = NULL;
+	}
 }
 
 static const struct component_ops cs35l41_hda_comp_ops = {
@@ -1529,6 +1568,9 @@ void cs35l41_hda_remove(struct device *dev)
 {
 	struct cs35l41_hda *cs35l41 = dev_get_drvdata(dev);
 
+	component_del(cs35l41->dev, &cs35l41_hda_comp_ops);
+	cancel_work_sync(&cs35l41->fw_load_work);
+
 	pm_runtime_get_sync(cs35l41->dev);
 	pm_runtime_dont_use_autosuspend(cs35l41->dev);
 	pm_runtime_disable(cs35l41->dev);
@@ -1536,8 +1578,6 @@ void cs35l41_hda_remove(struct device *dev)
 	if (cs35l41->halo_initialized)
 		cs35l41_remove_dsp(cs35l41);
 
-	component_del(cs35l41->dev, &cs35l41_hda_comp_ops);
-
 	pm_runtime_put_noidle(cs35l41->dev);
 
 	if (cs35l41_safe_reset(cs35l41->regmap, cs35l41->hw_cfg.bst_type))
diff --git a/sound/pci/hda/cs35l41_hda.h b/sound/pci/hda/cs35l41_hda.h
index bdb35f3be68a6..f6b4358fa4350 100644
--- a/sound/pci/hda/cs35l41_hda.h
+++ b/sound/pci/hda/cs35l41_hda.h
@@ -45,6 +45,8 @@ enum cs35l41_hda_gpio_function {
 	CS35l41_SYNC,
 };
 
+struct snd_kcontrol;
+
 struct cs35l41_hda {
 	struct device *dev;
 	struct regmap *regmap;
@@ -62,6 +64,8 @@ struct cs35l41_hda {
 	int speaker_id;
 	struct mutex fw_mutex;
 	struct work_struct fw_load_work;
+	struct snd_kcontrol *fw_type_ctl;
+	struct snd_kcontrol *fw_load_ctl;
 
 	struct regmap_irq_chip_data *irq_data;
 	bool firmware_running;
-- 
2.53.0



