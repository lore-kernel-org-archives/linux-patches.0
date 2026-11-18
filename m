Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047023;
	b=kVAaKZ9SElvykbypod9MWvr8oB565115UUcNqXy5wrdvQDfv6cp+J9myQIFs9q00fCuW
	 LAK3cO/9/pN+nmPFxYsfjohvleBkYAkEiUU619dWNeE/VTcLLuRkQuVhwk6JkL1QHxy9l
	 +aO/WJXuGSRe9QlMxIZ+9jWgQHAe4nN5m8/86OoQ4IsFytvojvceGIV90kEyvxTMG2mmF
	 JtsKiY7O80IgEOqucjhOlp5I2uuPR+ug3HBUybhKj+RJvvT5CqtG1SJl/SnRVojuNzxEO
	 9rQ7FSAb52uRc4ZWpxd/fsEaqHzjxuXxhRqNGffN0u9Y9SoR63tMq8MIDp8aA/Fpe+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ABVRms4j6XH/DvAC0bafaFFaMcAJqYKDyfX08w0PwNw=;
	b=TMPhXe8z6PNsVqtLlooEcQyV5jNTxA9zUsktBQJ/VK+9cSEER1V2UogYuzQkML9Fh7mb
	 8WN/EELqrRmXfNEOAeZle7s1xGPD4/8etWnlv5GTwK2ilJFZdN7hHehSwFU1ZEsE9SB0U
	 VItRqb1agrzVdjgr6NTH2M5M+AFXjsbEGOHdaZ/0KcLOmiizP1iVtHGvTmVA6uDsM5lgW
	 rmzKvE1a4XHZxPsgTLpa/0d3RAxIPG5gZSror3oYc/zfb19X1CZscV6ebqeE8TmZ+p2df
	 7tOmzuuwlfSQZ0MiL66944QL3CBcRvgu//dYJjLwNPD05VUPx1cB2wVWzofxdJuFUDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rDbWpi0j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBB1606A334;
	Thu, 19 Nov 2026 00:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rDbWpi0j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD761F000C5;
	Thu, 19 Nov 2026 00:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047023;
	bh=ABVRms4j6XH/DvAC0bafaFFaMcAJqYKDyfX08w0PwNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDbWpi0jnB3prNwQM3tW35VZC92CBGrqtDh92KApvtJw4O5fW9QPIo3d5FDynWzz2
	 EpWHcO9tDXz9b6UKdiXTi+6CGOYOyANcuKj3v/+Vcl3IOsQ14xCtDWd7/OR5Crh77s
	 ql8iQ7ZcsUNoTa+r+Sw+9vOHF8ykLaXpVuNybbNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1490/2857] ALSA: emux: prune unused parameter from snd_soundfont_load_guspatch()
Date: Wed, 18 Nov 2026 15:42:04 +0100
Message-ID: <20261118150254.979920043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



