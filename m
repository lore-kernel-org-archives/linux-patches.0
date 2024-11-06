Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92EA1D416E;
	Wed,  6 Nov 2024 12:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895344; cv=none; b=VQGFXweOgDZ4khhiHAKfCqQgcKY7d7brKcE8b0RyJekQdGtkiCkNIbo2VcgWD56vr0WVg/srxnf2MCPGHqTJmxeQxoH1Ih13O6EVDTltUYwc8ZD0F1LWCOPTNXbwMJnROgmh9H8RG1ERIdF9OCNh/q0l+glqZ+dWO5YLb+Bhd2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895344; c=relaxed/simple;
	bh=p+LN+9uj9Z6ABJkSYochajBuz8CFJuv3v+El3cNjDxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hlO95RTIoBpKUSXAUnblRLZ+Zftj++951aboLoXiNoLmILooLJKK8JW6uHPBrgIm7vIV1lsMmASOy/gPc3nOa11uqGa5R1sdqVAM+JANty9tCgc47pcWJl00na19JgMTnyB+eopRG5w6XEGCRCe9uyjKqw0PTiITXQzVbNbZdJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fShl/Irw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fShl/Irw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA131C4CECD;
	Wed,  6 Nov 2024 12:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895344;
	bh=p+LN+9uj9Z6ABJkSYochajBuz8CFJuv3v+El3cNjDxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fShl/IrwUzdogCHIRNZKLi6m1+iB4UlA0QIQpo3G/9xYBB0XX9sKaWQySNjvu2VVP
	 b8jIggksCG+M0EAqOhv8t1vjqXjCpxbtFBQ31IZwzgcW3tL7V7lv+Ulx0iFW5pfcoZ
	 wzVq3wFaa+pePG5/cBGN5HNjnnBvOgSExMMVAR6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 187/350] ALSA: core: add isascii() check to card ID generator
Date: Wed,  6 Nov 2024 13:01:55 +0100
Message-ID: <20241106120325.569808247@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaroslav Kysela <perex@perex.cz>

commit d278a9de5e1837edbe57b2f1f95a104ff6c84846 upstream.

The card identifier should contain only safe ASCII characters. The isalnum()
returns true also for characters for non-ASCII characters.

Link: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/4135
Link: https://lore.kernel.org/linux-sound/yk3WTvKkwheOon_LzZlJ43PPInz6byYfBzpKkbasww1yzuiMRqn7n6Y8vZcXB-xwFCu_vb8hoNjv7DTNwH5TWjpEuiVsyn9HPCEXqwF4120=@protonmail.com/
Cc: stable@vger.kernel.org
Reported-by: Barnabás Pőcze <pobrn@protonmail.com>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://patch.msgid.link/20241002194649.1944696-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/init.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -548,13 +548,19 @@ int snd_card_free(struct snd_card *card)
 }
 EXPORT_SYMBOL(snd_card_free);
 
+/* check, if the character is in the valid ASCII range */
+static inline bool safe_ascii_char(char c)
+{
+	return isascii(c) && isalnum(c);
+}
+
 /* retrieve the last word of shortname or longname */
 static const char *retrieve_id_from_card_name(const char *name)
 {
 	const char *spos = name;
 
 	while (*name) {
-		if (isspace(*name) && isalnum(name[1]))
+		if (isspace(*name) && safe_ascii_char(name[1]))
 			spos = name + 1;
 		name++;
 	}
@@ -581,12 +587,12 @@ static void copy_valid_id_string(struct
 {
 	char *id = card->id;
 
-	while (*nid && !isalnum(*nid))
+	while (*nid && !safe_ascii_char(*nid))
 		nid++;
 	if (isdigit(*nid))
 		*id++ = isalpha(*src) ? *src : 'D';
 	while (*nid && (size_t)(id - card->id) < sizeof(card->id) - 1) {
-		if (isalnum(*nid))
+		if (safe_ascii_char(*nid))
 			*id++ = *nid;
 		nid++;
 	}
@@ -684,7 +690,7 @@ card_id_store_attr(struct device *dev, s
 
 	for (idx = 0; idx < copy; idx++) {
 		c = buf[idx];
-		if (!isalnum(c) && c != '_' && c != '-')
+		if (!safe_ascii_char(c) && c != '_' && c != '-')
 			return -EINVAL;
 	}
 	memcpy(buf1, buf, copy);


