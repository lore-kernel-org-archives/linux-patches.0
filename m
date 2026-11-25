Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618517;
	b=JZ2LSkD0GPSwQRVKb9bNKfhbvNzywFr2Typ1m6XBcMoSo4ala/MyOvZzpEMIy+Bn9gIs
	 dEBRUDjxjXwTrjP2TsLIOQTfj4J5GzlJIyzI1Fda6bX/t/c+e+QDaG2vPir13m335fYdd
	 eliMrvAIuF0OEA6l74yV/BgTdyPZGy9ZYQ0JFIFXkTmcTwWD/U/Bw5/wJ2eXa8ZlJfwUa
	 AKkLDrB7RUli2MBlkkPGGxJlCvQbU53tNviOY37hPi9h0yPjcIHj8Jw4Ue8TLLeQ+ZrjN
	 XOrhvXq37TJy1fo0GHpCO6/Gt9NyOhkRrrr0IqngHvHbdQps5Kw3mvXD8C6pcoPyoPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QuSaKZTdEYVlphVuqCSSxPAPwRFV9NVOynzHEt0vXmE=;
	b=1tu7Nb11+6OQ4vIW8Z23/GspCr4M7spb9bJhuNocASQVXtzzXGfDf9AKnUeuCi7Lhvm7
	 aI+QOShUJ7BPT1mPzxjbQeFvrLOgpS1APiQur9FIYBxLCE4zbgYdsmvPoXEYAYE+GlkiO
	 m5kiUikmwSO4+QFhxIprjGimX6hkBFTR6rj5tC8+Z0scglk8yUD2oU3/HE5KE0EE1CMwZ
	 X2TMDdqHccHL+bR4VneqUWrDRqj7w6qKUU9pnO70Q5VJ6bKT5ISW7RqyY/U9cPAtaa73x
	 7O7T6qrd8vMj8sotnOYcFgyz7paaazm4tLL14DsMcRlDRc+BOyGGhIVUiEPHDB4GjRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D7BAeiek;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563B0606A32C;
	Wed, 25 Nov 2026 14:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D7BAeiek
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1D81F000CA;
	Wed, 25 Nov 2026 14:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618516;
	bh=QuSaKZTdEYVlphVuqCSSxPAPwRFV9NVOynzHEt0vXmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D7BAeiek+6VlacFFNQecC61AqpitMOF8frNmwxRhsrd4qL1tJaqYYeiT1pnrFA2Xr
	 MFzrWafGQhcDFYyCAa8hZaokO6JYoSnJASRbKs3T5bB/TUKBT76ceZZ/SKywRbc99G
	 G7j8Fsm6DoXjxYUZd7LdCwVcjH+I2oTahoVODgd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0303/1005] ALSA: hda: cs35l56: Fix mixed cleanup and goto in cs35l56_hda_fw_load()
Date: Wed, 25 Nov 2026 15:27:21 +0100
Message-ID: <20261125143828.833849140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit d2895945d37e3426191894a010f94db31c206e10 ]

Remove the gotos from cs35l56_hda_fw_load() to prevent mixing
auto-cleanup and goto-cleanup in the same function. Replace them with
returns and remove the goto cleanup code, as there's no need to "undo"
a cs_dsp_power_up() with a cs_dsp_power_down() here.

Two previous commits added auto-cleanup to cs35l56_hda_fw_load() but
didn't remove the goto, which leaves mixed cleanup and goto.

commit 0ff22680e51f4 ("ALSA: hda/cs35l56: Clean up with
PM_RUNTIME_ACQUIRE*() macros")

commit 185841c94accc ("ALSA: hda: cs35l56: Use auto-cleanup for firmware
loading")

There's actually no need to call cs_dsp_power_down() here. On the
CS35L54/56/57 amps it doesn't control the DSP subsystem power (that is all
managed by the firmware), so it's perfectly safe to just return if there
are any errors after a successful cs_dsp_power_up(). As cs_dsp_power_up()
was successful it is valid to leave cs_dsp in this state, which matches
the state of the hardware.

The two places that cs_dsp_power_down() is called conditionally have been
changed to check the cs_dsp.booted flag, now the fw_patched flag is not
a guaranteed proxy. The booted flag is directly indicating that there has
been a successful cs_dsp_power_up() so this is more correct anyway.

Fixes: 0ff22680e51f4 ("ALSA: hda/cs35l56: Clean up with PM_RUNTIME_ACQUIRE*() macros")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20261104111121.1054077-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/cs35l56_hda.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/cs35l56_hda.c b/sound/hda/codecs/side-codecs/cs35l56_hda.c
index bc207ab5b020a..148d760987fdd 100644
--- a/sound/hda/codecs/side-codecs/cs35l56_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l56_hda.c
@@ -562,7 +562,7 @@ static void cs35l56_hda_fw_load(struct cs35l56_hda *cs35l56)
 	 * downloaded previously then it needs to be powered down so that it
 	 * can be updated.
 	 */
-	if (cs35l56->base.fw_patched)
+	if (cs35l56->cs_dsp.booted)
 		cs_dsp_power_down(&cs35l56->cs_dsp);
 
 	cs35l56->base.fw_patched = false;
@@ -634,7 +634,7 @@ static void cs35l56_hda_fw_load(struct cs35l56_hda *cs35l56)
 		regcache_mark_dirty(cs35l56->base.regmap);
 		ret = cs35l56_wait_for_firmware_boot(&cs35l56->base);
 		if (ret)
-			goto err_powered_up;
+			return;
 
 		regcache_cache_only(cs35l56->base.regmap, false);
 	}
@@ -642,7 +642,7 @@ static void cs35l56_hda_fw_load(struct cs35l56_hda *cs35l56)
 	/* Disable auto-hibernate so that runtime_pm has control */
 	ret = cs35l56_mbox_send(&cs35l56->base, CS35L56_MBOX_CMD_PREVENT_AUTO_HIBERNATE);
 	if (ret)
-		goto err_powered_up;
+		return;
 
 	regcache_sync(cs35l56->base.regmap);
 
@@ -663,10 +663,6 @@ static void cs35l56_hda_fw_load(struct cs35l56_hda *cs35l56)
 		cs_dsp_stop(&cs35l56->cs_dsp);
 
 	cs35l56_log_tuning(&cs35l56->base, &cs35l56->cs_dsp);
-
-err_powered_up:
-	if (!cs35l56->base.fw_patched)
-		cs_dsp_power_down(&cs35l56->cs_dsp);
 }
 
 static void cs35l56_hda_dsp_work(struct work_struct *work)
@@ -814,7 +810,7 @@ static void cs35l56_hda_unbind(struct device *dev, struct device *master, void *
 	debugfs_remove_recursive(cs35l56->debugfs_root);
 #endif
 
-	if (cs35l56->base.fw_patched)
+	if (cs35l56->cs_dsp.booted)
 		cs_dsp_power_down(&cs35l56->cs_dsp);
 
 	comp = hda_component_from_index(parent, cs35l56->index);
-- 
2.53.0



