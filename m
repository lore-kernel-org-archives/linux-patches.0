Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DA71DE89D;
	Tue,  8 Oct 2024 12:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392299; cv=none; b=JHUZ62ttS0O3Kewf3QwbqZiQXeVDpd2BY1pLRMrWBxQlIhv9dNYuj2UYmQV/v5n99AAREhpvuNntAMkKzmH5YJ+zDo9NMpJMVasn902twx419cPFVpQB6RGeCBaELw2Ge5YHd92c0wKGsDlfgiYS8PncZJp3dYHPaY4O25MFOZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392299; c=relaxed/simple;
	bh=eWdvvsG6Y2OILL3tJfF3ri2BGVcBxXT/sOIVOL8Kfic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UN2SqLL1Kd+V69L+NiAOixeruAggvXUq8Y4eMHh6OZko44xiVEsw4Hq/7vxKHOOAxvzn+kyfYEVX+IblbzRLpSuXTcVgnCMjIVFGivAn9dGI+z2k9bq0U1CF4NEnWEcwwtYQJIIhekToievozzFj/0yrjjsCom8/dPUwmRk1ikE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIkMMsYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIkMMsYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C76C4CEC7;
	Tue,  8 Oct 2024 12:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392299;
	bh=eWdvvsG6Y2OILL3tJfF3ri2BGVcBxXT/sOIVOL8Kfic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIkMMsYlFeNHeDdtKvQCzp/6vLHwjnALR7r4jpNrgdNT0vCYd2exDOEzUG5q4Dnxw
	 RnuZPEHdqbaFIq2jnzD1ULr4VAt7S3ePR8U2+YdMQQFLrvmScx6jJ3dznV8T79b9+a
	 trV1uWam3AKb2bTLYVLZa1RoSRijnMSc6JWOkc5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 373/558] ALSA: core: add isascii() check to card ID generator
Date: Tue,  8 Oct 2024 14:06:43 +0200
Message-ID: <20241008115716.973629715@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -654,13 +654,19 @@ void snd_card_free(struct snd_card *card
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
@@ -687,12 +693,12 @@ static void copy_valid_id_string(struct
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
@@ -787,7 +793,7 @@ static ssize_t id_store(struct device *d
 
 	for (idx = 0; idx < copy; idx++) {
 		c = buf[idx];
-		if (!isalnum(c) && c != '_' && c != '-')
+		if (!safe_ascii_char(c) && c != '_' && c != '-')
 			return -EINVAL;
 	}
 	memcpy(buf1, buf, copy);


