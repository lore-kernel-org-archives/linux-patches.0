Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E003C129;
	Mon,  1 Apr 2024 16:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988931; cv=none; b=Z05n4KkJiycv4sTJ/SYU70ISzMynJekONeu85yqqT3pTWtaPXBKnGVkUNNngG/w0prirQKD73Ax6FEMFANP3u2xslPB2+KnY+DzRoh1PuQr6gcpPpxN0izzHDXFafoKWLSb7fHZRFxs/fMc/haUH52HIQsD8zoEK1diDdp7Ra8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988931; c=relaxed/simple;
	bh=4aRNAbVyUKXiM6+B/hAXh3gqjhvKKqYZIZSGcMnZghI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYcFmdZRFwnQjC4GrhoIKSr7YVJfIpnRFUbjpa0/pA/2AO8Bu5vBpAebFKKJd5ZNCWz6yg50nmJXt4ELo7s00/omAI3TmccUyU0uHTq4cDSJ5bnodrtK6dPSIsxn3e9U2DOuvOgQrDh3jOKltHUZaykM3YzHybqwfhpDCQc4Ez8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaQPqutW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaQPqutW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D022EC433C7;
	Mon,  1 Apr 2024 16:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988931;
	bh=4aRNAbVyUKXiM6+B/hAXh3gqjhvKKqYZIZSGcMnZghI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eaQPqutWRI48k0nH6zR0Yvjs9fGEKxjcuLQJoJ71TzD++Sz0cj1GpOrCwczzJ9ppF
	 aM3U7frVSrPzulfNrZo8YA7Szarj4mkJueudSSP4k/zPY5WIKsGHQ3e4c5elJYQnLm
	 YmLfc61GyRaw4/1mTtF+q3pESHEIx8PLY9pY3osE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 332/432] ALSA: hda/tas2781: remove digital gain kcontrol
Date: Mon,  1 Apr 2024 17:45:19 +0200
Message-ID: <20240401152603.114778315@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

commit ae065d0ce9e36ca4efdfb9b96ce3395bd1c19372 upstream.

The "Speaker Digital Gain" kcontrol controls the TAS2781_DVC_LVL (0x1A)
register. Unfortunately the tas2563 does not have DVC_LVL, but has
INT_MASK0 in 0x1A, which has been misused so far.

Since commit c1947ce61ff4 ("ALSA: hda/realtek: tas2781: enable subwoofer
volume control") the volume of the tas2781 amplifiers can be controlled
by the master volume, so this digital gain kcontrol is not needed.

Remove it.

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
CC: stable@vger.kernel.org
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Message-ID: <741fc21db994efd58f83e7aef38931204961e5b2.1711469583.git.soyer@irl.hu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda_i2c.c |   37 +------------------------------------
 1 file changed, 1 insertion(+), 36 deletions(-)

--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -71,7 +71,7 @@ struct tas2781_hda {
 	struct snd_kcontrol *dsp_prog_ctl;
 	struct snd_kcontrol *dsp_conf_ctl;
 	struct snd_kcontrol *prof_ctl;
-	struct snd_kcontrol *snd_ctls[3];
+	struct snd_kcontrol *snd_ctls[2];
 };
 
 static int tas2781_get_i2c_res(struct acpi_resource *ares, void *data)
@@ -288,27 +288,6 @@ static int tasdevice_config_put(struct s
 	return ret;
 }
 
-/*
- * tas2781_digital_getvol - get the volum control
- * @kcontrol: control pointer
- * @ucontrol: User data
- * Customer Kcontrol for tas2781 is primarily for regmap booking, paging
- * depends on internal regmap mechanism.
- * tas2781 contains book and page two-level register map, especially
- * book switching will set the register BXXP00R7F, after switching to the
- * correct book, then leverage the mechanism for paging to access the
- * register.
- */
-static int tas2781_digital_getvol(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
-	struct soc_mixer_control *mc =
-		(struct soc_mixer_control *)kcontrol->private_value;
-
-	return tasdevice_digital_getvol(tas_priv, ucontrol, mc);
-}
-
 static int tas2781_amp_getvol(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol)
 {
@@ -319,17 +298,6 @@ static int tas2781_amp_getvol(struct snd
 	return tasdevice_amp_getvol(tas_priv, ucontrol, mc);
 }
 
-static int tas2781_digital_putvol(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
-	struct soc_mixer_control *mc =
-		(struct soc_mixer_control *)kcontrol->private_value;
-
-	/* The check of the given value is in tasdevice_digital_putvol. */
-	return tasdevice_digital_putvol(tas_priv, ucontrol, mc);
-}
-
 static int tas2781_amp_putvol(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol)
 {
@@ -375,9 +343,6 @@ static const struct snd_kcontrol_new tas
 	ACARD_SINGLE_RANGE_EXT_TLV("Speaker Analog Gain", TAS2781_AMP_LEVEL,
 		1, 0, 20, 0, tas2781_amp_getvol,
 		tas2781_amp_putvol, amp_vol_tlv),
-	ACARD_SINGLE_RANGE_EXT_TLV("Speaker Digital Gain", TAS2781_DVC_LVL,
-		0, 0, 200, 1, tas2781_digital_getvol,
-		tas2781_digital_putvol, dvc_tlv),
 	ACARD_SINGLE_BOOL_EXT("Speaker Force Firmware Load", 0,
 		tas2781_force_fwload_get, tas2781_force_fwload_put),
 };


