Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031276;
	b=ZnDWBFk0xzaDeFURvQdrEg0ZgJW6DBvdFKSAylTq0eEof0d7723raMAnrZUNWA836QcK
	 F4jHQ5uhllbiwAVFesnz0uBZJsP2QkVeD6iG5jVJyY/YaxwgTZ+U3+T2pTwjQbjEAiBJE
	 FVfnPfAXc0+uwPpvgauwzU1K4sBK6IYA9wr1ocYwzzHU2LzOGzt/+A9XbjTT06mceR6rg
	 1EPu/fDaiaB3jC5xKG4hPeLTuEZGUQKj5yxvotIcJuVvER55stctl/OnpHkxK6YhROrOs
	 WVXN+shlRgYogW6xIpaEnjOqaNSpx05IfDLY+Clf3Ybn5L+Q1bKu2cLYFgzBnl60nRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+gx6KfaXeTSrcDw21E75GwyXtAeMEBSftC+kjECwm6M=;
	b=r7qvbZjf5wWfrB/Far1Wua0Gk3WPllengXdiNXcUogMWpZpnyoGMtTZ4aTFzJJz5mRZ7
	 Bis/oB8m/F0XW+XvPBq5FOGP9FAQ7flZD1m7ZNaSDitDpKni2Xw28NM5LsaxhTZVxD49i
	 vMx28KORE8wsxItbef77eirLLsfWQc54TU+GbxfdO/CiUKEFLwGmwpeHTvdVXec5OVJ4r
	 ioRHb2esYM5oj7AFeKYmMNzF/3VwXA3HWuyU9WKSlIG2AtbyHG+rZ5ecB2nMczD9onBq0
	 OAy+7Kv60zsfEE+yvRifWLlnGpTMP4jPEyVrNhLHT+AkB1BWGvFKdpoi8e0D9TgY/2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YAG1rEMa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384B1606A31C;
	Wed, 18 Nov 2026 19:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YAG1rEMa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE411F000C4;
	Wed, 18 Nov 2026 19:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031276;
	bh=+gx6KfaXeTSrcDw21E75GwyXtAeMEBSftC+kjECwm6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YAG1rEMaA62EaNqORXMkecAuhm66ctGEAm0EAW3mGhi7Zkp/PoJbgqY41SpEzKy5h
	 /8eg2kU0vt2YkP8vKMW8RIiKWP2tInLLZwk3BAtDiH6+Pj1TjHsHuMy0qNEVOaytyz
	 L6WqrTBnET5937YdbVuZURZ5FH9HdQU3KHM6RFqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1000/1756] ALSA: hda: Dont free card at probe error in vga_switcheroo handler
Date: Wed, 18 Nov 2026 15:52:07 +0100
Message-ID: <20261118150049.977111698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7e1ad3c55baa80399f1727dfd2303fa4d1558d9a ]

The vga_switcheroo handler azx_vs_set_state() calls
azx_probe_contine() for enabling the audio, and if an error happens
during the probe, azx_probe_continue() releases its associated sound
card object at the error path.  The card release procedure includes
the call of vga_switcheroo_unregister_client(), and this triggers the
vgasr_mutex lock again that had been already held by the caller
(vga_switcheroo_process_delayed_switch()) -- leading to a deadlock.

(Moreover, the card release will cause a potential UAF at the error
message in azx_vs_set_state() since the card object is already gone;
this was the original report by Sashiko.)

For avoiding the unneeded crash, it's better to avoid the card release
in this error path, so we make azx_probe_continue() behaving
conditionally.  In return, set hda->init_failed flag, so that any
further (re-)attempts will be filtered after that point.

The check of hda->init_failed is dropped from azx_vs_can_switch().
It's because otherwise vga_switcheroo can't be switched to turn off
GPU once when a probe error happens at the audio side.

Fixes: 39173303c838 ("ALSA: hda: Free card instance properly at probe errors")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261007213728.155092-1-tiwai%40suse.de
Link: https://patch.msgid.link/20261007223448.172443-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index d5142861d2865..58a51c11a2e8d 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1175,7 +1175,7 @@ static const struct dev_pm_ops azx_pm = {
 };
 
 
-static int azx_probe_continue(struct azx *chip);
+static int azx_probe_continue(struct azx *chip, bool free_on_error);
 
 #ifdef SUPPORT_VGA_SWITCHEROO
 static struct pci_dev *get_bound_vga(struct pci_dev *pci);
@@ -1202,8 +1202,10 @@ static void azx_vs_set_state(struct pci_dev *pci,
 		if (!disabled) {
 			dev_info(chip->card->dev,
 				 "Start delayed initialization\n");
-			if (azx_probe_continue(chip) < 0)
+			if (azx_probe_continue(chip, false) < 0) {
+				hda->init_failed = 1;
 				dev_err(chip->card->dev, "initialization error\n");
+			}
 		}
 	} else {
 		dev_info(chip->card->dev, "%s via vga_switcheroo\n",
@@ -1242,8 +1244,6 @@ static bool azx_vs_can_switch(struct pci_dev *pci)
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 
 	wait_for_completion(&hda->probe_wait);
-	if (hda->init_failed)
-		return false;
 	if (chip->disabled || !hda->probe_continued)
 		return true;
 	if (snd_hda_lock_devices(&chip->bus))
@@ -1728,7 +1728,7 @@ static void azx_check_snoop_available(struct azx *chip)
 static void azx_probe_work(struct work_struct *work)
 {
 	struct hda_intel *hda = container_of(work, struct hda_intel, probe_work.work);
-	azx_probe_continue(&hda->chip);
+	azx_probe_continue(&hda->chip, true);
 }
 
 static int default_bdl_pos_adj(struct azx *chip)
@@ -2290,7 +2290,7 @@ static const unsigned int azx_max_codecs[AZX_NUM_DRIVERS] = {
 	[AZX_DRIVER_TERA] = 1,
 };
 
-static int azx_probe_continue(struct azx *chip)
+static int azx_probe_continue(struct azx *chip, bool free_on_error)
 {
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 	struct hdac_bus *bus = azx_bus(chip);
@@ -2382,10 +2382,12 @@ static int azx_probe_continue(struct azx *chip)
 
 out_free:
 	if (err < 0) {
-		pci_set_drvdata(pci, NULL);
 		if (hda->vga_switcheroo_registered)
 			dev_warn(&pci->dev, "GPU sound probed, but not operational: please add a quirk to driver_denylist\n");
-		snd_card_free(chip->card);
+		if (free_on_error) {
+			pci_set_drvdata(pci, NULL);
+			snd_card_free(chip->card);
+		}
 		return err;
 	}
 
-- 
2.53.0



