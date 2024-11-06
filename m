Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB621DFE31;
	Wed,  6 Nov 2024 13:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898456; cv=none; b=NTogohX5MhFU99fN9GmgbbMSxSun/CpiEfQpzLl+yDzT/xlCuKJFyUH3DqOpTJI5Wz80qr6uR1nJqyV+mRssnU2uDgGOQU9DjGQO3fq0ErYKBw0md9cPIxJxHttGqQdfbLQB+W/6BL8oW1CcGEir7XM2/J8DMEnIfI2U2U/7nJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898456; c=relaxed/simple;
	bh=2EwuI7dNrf4qhbFCCSHywN/go1LrVUEaUkDeHawhYVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=giAN9JhWXkZZw2satVKWLlthKfVP/xCq+fP39Bwu2KRgz3/gpq7GZVkhPeDi2yBRVr/26KufFh9CZXrJ/piAx3LqBXczK6RiAhQjh9bVDikh0563rUGHFR2bNuiM3eEyA5/zoNRNOdRPBHCMZ7dsraKfpWeqXxHDCS+E5nbuL/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6oOC+jH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6oOC+jH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97B1C4CECD;
	Wed,  6 Nov 2024 13:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898456;
	bh=2EwuI7dNrf4qhbFCCSHywN/go1LrVUEaUkDeHawhYVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6oOC+jHEPAmFTgFVjFMdMGSf04SBNox+EduiXHCkZYXrgLGS+M6iNP9SMUfG9tH4
	 B2uP+YdiFpM5RP/dVsuw6723beeuIiYzhOB+LNwpAPi7+8CvxKfeiiZyslsew6U+vW
	 USjDzkG0YouoQIqfJT4SCD/9inCxMUE8Xge9Zfss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 245/462] ALSA: core: add isascii() check to card ID generator
Date: Wed,  6 Nov 2024 13:02:18 +0100
Message-ID: <20241106120337.577545206@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -527,13 +527,19 @@ int snd_card_free(struct snd_card *card)
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
@@ -560,12 +566,12 @@ static void copy_valid_id_string(struct
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
@@ -663,7 +669,7 @@ card_id_store_attr(struct device *dev, s
 
 	for (idx = 0; idx < copy; idx++) {
 		c = buf[idx];
-		if (!isalnum(c) && c != '_' && c != '-')
+		if (!safe_ascii_char(c) && c != '_' && c != '-')
 			return -EINVAL;
 	}
 	memcpy(buf1, buf, copy);


