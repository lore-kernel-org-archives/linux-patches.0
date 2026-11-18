Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038454;
	b=FsG3xVy7EoCuvcCKW8GXrt6+wFOpydH7LBmuy1Th2Bg0xs9LmvuQyFvr4OrFO3FPmeM5
	 bMpudLQeyG6fznAyBadzhtwTpqH8WwY8LhR4nvP1unofGl5zpZCkZS40dWMglWzsFPrbo
	 RrCVKh3gzJ8UE3OzlTKhnYGlQhzsnT7aOiZ77VMw7pHpwqacJxLo4cty8XkYEuUArgL9x
	 Rzgh43VhFa6RZibsoU24VNBBoiioJjMNQzZ51i4U0hW6oGB+J+Dsnpq7TsunZk+Wveqff
	 8g1qRabk9WSrGKOyX6mGwCEGBiII9mAw5EYXJCgcLv56QuUTzhcZhos5GDlcmkXtjxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0aOj4uoFJTrZv6VcK/QCjb8kNMffNBRF6RmtkFUgaPw=;
	b=DeEiCO1ClDKN43dgVUw2fD2YpT75tPkt8SMRsFW0MNwLWQjJW4JOQVjilemfrauGi4pN
	 P9u1f7+Spk3/YZON3HFKgLUZS/ZSBhQ0+mGJCeBcQ2wN02FjqK82h6OmwbTwBhMxMc990
	 uAuk/wIsYGlhkhq7pzVt1zzey9SfPNPMPHNkMzEXApxLfoUbk085qTAxHTuJ1r79Ok7gh
	 9Esh1uRAVHhthO056T4veKhWzExJDvtm0ZrIJbTZV+Duk40ryg6ZVgTFMrJgnM7+SdJIG
	 bbQFTeIV7sxY/6mtwLp0fysxsCw8R3KV66NfIMBM97pLifoNtqR1eiJqwpKs7TqqoJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JvcEM7US;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2031E606A320;
	Wed, 18 Nov 2026 21:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JvcEM7US
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDC91F000C4;
	Wed, 18 Nov 2026 21:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038454;
	bh=0aOj4uoFJTrZv6VcK/QCjb8kNMffNBRF6RmtkFUgaPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JvcEM7USurXmap+O5jBjPZZwoz67kyGf0G2Rx4NPnmSsbq9cA1xJWl94EvJ9izS6a
	 id3wEGgg2liLyMNHrBaeJYGU4nVCG/lRRrFC7vodh528UBlcXb8JmIUeNGfe5QYY+F
	 ka12VIDTdgSy0kskhp9LPi44OwIkKZoHhTZMk0Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1750/3318] ALSA: emux: prune unused parameter from snd_soundfont_load_guspatch()
Date: Wed, 18 Nov 2026 15:39:32 +0100
Message-ID: <20261118150414.360475062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

[ Upstream commit 3f3e0dfc83d586fe9204936fccae771754a9dbc2 ]

The `client` parameter was not used, so eliminate it from the call
chain.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Message-ID: <20240406064830.1029573-3-oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 34e3e04b8a17 ("ALSA: emux: Fix UAF of soundfont zones at note-on")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soundfont.h     | 2 +-
 sound/synth/emux/emux_hwdep.c | 3 +--
 sound/synth/emux/emux_oss.c   | 3 +--
 sound/synth/emux/soundfont.c  | 7 +++----
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/sound/soundfont.h b/include/sound/soundfont.h
index e445688a4f4f9..98ed98d89d6de 100644
--- a/include/sound/soundfont.h
+++ b/include/sound/soundfont.h
@@ -89,7 +89,7 @@ struct snd_sf_list {
 int snd_soundfont_load(struct snd_sf_list *sflist, const void __user *data,
 		       long count, int client);
 int snd_soundfont_load_guspatch(struct snd_sf_list *sflist, const char __user *data,
-				long count, int client);
+				long count);
 int snd_soundfont_close_check(struct snd_sf_list *sflist, int client);
 
 struct snd_sf_list *snd_sf_new(struct snd_sf_callback *callback,
diff --git a/sound/synth/emux/emux_hwdep.c b/sound/synth/emux/emux_hwdep.c
index 81719bfb8ed73..fd8f978cde1c6 100644
--- a/sound/synth/emux/emux_hwdep.c
+++ b/sound/synth/emux/emux_hwdep.c
@@ -27,8 +27,7 @@ snd_emux_hwdep_load_patch(struct snd_emux *emu, void __user *arg)
 
 	if (patch.key == GUS_PATCH)
 		return snd_soundfont_load_guspatch(emu->sflist, arg,
-						   patch.len + sizeof(patch),
-						   TMP_CLIENT_ID);
+						   patch.len + sizeof(patch));
 
 	if (patch.type >= SNDRV_SFNT_LOAD_INFO &&
 	    patch.type <= SNDRV_SFNT_PROBE_DATA) {
diff --git a/sound/synth/emux/emux_oss.c b/sound/synth/emux/emux_oss.c
index d8d32671f7038..04df46b269d37 100644
--- a/sound/synth/emux/emux_oss.c
+++ b/sound/synth/emux/emux_oss.c
@@ -205,8 +205,7 @@ snd_emux_load_patch_seq_oss(struct snd_seq_oss_arg *arg, int format,
 		return -ENXIO;
 
 	if (format == GUS_PATCH)
-		rc = snd_soundfont_load_guspatch(emu->sflist, buf, count,
-						 SF_CLIENT_NO(p->chset.port));
+		rc = snd_soundfont_load_guspatch(emu->sflist, buf, count);
 	else if (format == SNDRV_OSS_SOUNDFONT_PATCH) {
 		struct soundfont_patch_info patch;
 		if (count < (int)sizeof(patch))
diff --git a/sound/synth/emux/soundfont.c b/sound/synth/emux/soundfont.c
index eed47e4830248..77144fe221cf2 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -944,8 +944,7 @@ int snd_sf_vol_table[128] = {
 
 /* load GUS patch */
 static int
-load_guspatch(struct snd_sf_list *sflist, const char __user *data,
-	      long count, int client)
+load_guspatch(struct snd_sf_list *sflist, const char __user *data, long count)
 {
 	struct patch_info patch;
 	struct snd_soundfont *sf;
@@ -1127,11 +1126,11 @@ load_guspatch(struct snd_sf_list *sflist, const char __user *data,
 /* load GUS patch */
 int
 snd_soundfont_load_guspatch(struct snd_sf_list *sflist, const char __user *data,
-			    long count, int client)
+			    long count)
 {
 	int rc;
 	lock_preset(sflist);
-	rc = load_guspatch(sflist, data, count, client);
+	rc = load_guspatch(sflist, data, count);
 	unlock_preset(sflist);
 	return rc;
 }
-- 
2.53.0



