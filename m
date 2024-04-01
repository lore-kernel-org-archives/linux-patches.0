Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FEA482DF;
	Mon,  1 Apr 2024 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990386; cv=none; b=KIjkHzxMILecvJyY+09AsriHTznoqMe7S/633WfeTbacLj4GEFiQ+n90u81pLcKq/vsl0XNdbuO9EBI5c6CPh8KG2Ulb+X3huAD1X7VzplSTTl2VtcNLiJzfVW1wfpSbXMqfusz3X8EWsaVXJWGfL4dkUXAbQTjvtH6I4NB6v/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990386; c=relaxed/simple;
	bh=SSNocstk5yNM0Y7zBiP5PGbMKS6G0TDALDrXCV0IJeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luoRHCeVQRMw9T9qEFVwu3k1Ctg2tldE1e67MBrzQlbQxWZkaycyYLbOhEXDFxAZJ4z98BmtwEe2HbplcNUzywhGi2ufUdE46ZZJmB1dbd4laA8I+BrYRMO5GuGX+yHk3Cy9A06F+hRjlcC+z8tfkStaFofOAiz51KCBudqbqVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss0V1tkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss0V1tkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5976BC433C7;
	Mon,  1 Apr 2024 16:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990386;
	bh=SSNocstk5yNM0Y7zBiP5PGbMKS6G0TDALDrXCV0IJeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ss0V1tkcI5ycY/E5VsIdc0qyE73ywbhOr1UpolMX2MrTE1xvloFy2FGeG+NsD0K3N
	 cSk3Sq0Iv7HNQCpO6T4XkwcRAEGhLuydwWfy3yRHOhlpKymoA5lPJHT0JyXdkynfiY
	 mEUHCXTgW+EzzEoPfTp+Ru+EIxnzscqeSWNB3N3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 308/396] ALSA: hda/tas2781: remove digital gain kcontrol
Date: Mon,  1 Apr 2024 17:45:57 +0200
Message-ID: <20240401152557.097794207@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


