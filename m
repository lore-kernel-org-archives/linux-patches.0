Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019369;
	b=AdMAzHWyRkOJ9dY6dQ/MtAt/5i55/gRYnx79C+f6ohdIPMpp4NfM2VesDemjSf0QqpMN
	 13R8S63pIFMXTDNtjzGmc6LrogNCtWl94MU2sndbBY52ao9BprWtqZvgiA5ApJBqv6RRP
	 ZQCU8C+MaEgXTN7PKs7lvj70xvu4t1pg8HDhgjC+aCTxjgi/BJolT160vq1IIvYaJoVt5
	 iMuOwff1ChyEr7nsMLMuFLR4bDvyyTqF5/92a6NBox2/iv5ipgIjLO+BHw7vKynTx6SLZ
	 bTVwtEutpLKAu5nNQ7RALc53fjov2wZ1v7YWm2nifyAiIXZRq7CojznJT8WW9tmf32Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CoKk0sS+mxQ60OTy0vO14aZFrZx+jTpNHeB3p1Yxf4g=;
	b=WNUyIAXMA/nOrc6B5qzt+Aa/MGV6C4RBCcqi0t8TrOaM3LCKhp45USpTIQpDFLNdic4w
	 A+vDiUNrUHa12xH5E9s+W4v/q8FMkMY1Oj4vDd73/ViVQPX/N0VeEhcmdE+JtZM4cHLc9
	 6PiZ/DWu+598hmRYCDb0coxAWlv8STrXFmQakOvATwHw61TzZvycGUTeNCGLp5wDhb6tB
	 9LhY96SMTfCxfA3XJYtD/ti4JkEk2dJvK3G3iJWbCelH9ko4Pf82EOixkJ8xLKWOxDEf6
	 KGGnRdVuctwDPMTUDTQqNilWv7LBoK1gzyD92ia1MtHoX3KIMuE63HYgoVb5aKEi1eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AXCw8LZM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4997060A2607;
	Wed, 18 Nov 2026 16:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AXCw8LZM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9979D1F000C4;
	Wed, 18 Nov 2026 16:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019369;
	bh=CoKk0sS+mxQ60OTy0vO14aZFrZx+jTpNHeB3p1Yxf4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AXCw8LZM166AT+BDzVBRbwdGY39U7qkyuKt+Bqkelw/vMQxBXiIVMd5W5wtxCZ+u7
	 e8MXEYedYlte/JwBZhyVOtsRI3GzUZZyVz7aDBpW8pHzRHEi9LOxjdRV14q9H0r8yK
	 x5M+ORnlfW7b7MvGSjA6vf1nVqC0ie88sIdNqdno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1530/2651] ALSA: hda: Dont free card at probe error in vga_switcheroo handler
Date: Wed, 18 Nov 2026 15:46:10 +0100
Message-ID: <20261118150343.059067938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 sound/hda/controllers/intel.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index 068fc522658a6..88b0207fde9cd 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -1184,7 +1184,7 @@ static const struct dev_pm_ops azx_pm = {
 };
 
 
-static int azx_probe_continue(struct azx *chip);
+static int azx_probe_continue(struct azx *chip, bool free_on_error);
 
 #ifdef SUPPORT_VGA_SWITCHEROO
 static struct pci_dev *get_bound_vga(struct pci_dev *pci);
@@ -1211,8 +1211,10 @@ static void azx_vs_set_state(struct pci_dev *pci,
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
@@ -1251,8 +1253,6 @@ static bool azx_vs_can_switch(struct pci_dev *pci)
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 
 	wait_for_completion(&hda->probe_wait);
-	if (hda->init_failed)
-		return false;
 	if (chip->disabled || !hda->probe_continued)
 		return true;
 	if (snd_hda_lock_devices(&chip->bus))
@@ -1737,7 +1737,7 @@ static void azx_check_snoop_available(struct azx *chip)
 static void azx_probe_work(struct work_struct *work)
 {
 	struct hda_intel *hda = container_of(work, struct hda_intel, probe_work.work);
-	azx_probe_continue(&hda->chip);
+	azx_probe_continue(&hda->chip, true);
 }
 
 static int default_bdl_pos_adj(struct azx *chip)
@@ -2355,7 +2355,7 @@ static const unsigned int azx_max_codecs[AZX_NUM_DRIVERS] = {
 	[AZX_DRIVER_TERA] = 1,
 };
 
-static int azx_probe_continue(struct azx *chip)
+static int azx_probe_continue(struct azx *chip, bool free_on_error)
 {
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 	struct hdac_bus *bus = azx_bus(chip);
@@ -2446,10 +2446,12 @@ static int azx_probe_continue(struct azx *chip)
 
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



