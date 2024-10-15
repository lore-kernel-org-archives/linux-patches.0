Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087251D1512;
	Tue, 15 Oct 2024 12:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993728; cv=none; b=fXE8HdPRDVPdPL3f1rIwYwKFRQNL8QW/Be+MLmxh13YwLW9ps+CCMp7p7/XvYz6/FB/nL/lU5IWdB+IujKeg8MG1KePIaosUBSSmSVu/uPdWT2J1xNdeTBtll/7BtOOYutWwmu0sDa+F4s/Ps5pypymH40diNZ0sCPBACljoTuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993728; c=relaxed/simple;
	bh=iGAKntFJkbLUQW/8iCl1c6JIfXmSBUbxNufdbI1qiuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=accVGmqezqcPtUWwKXCPnKe6/Qml/o4w1jcZCQO8GZzYYLQEpzFVsIPUCpGJpimrXGO5EUtJHTL4Jz763om0Edzap8PP5pHJAatoXOPCGPByBdp3GQyXSLLQWcxzWGgJihE0O7v1nVqZh/K73eV/1ubIvLT0tQX85gZWyFuB6WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xEd+ZtEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xEd+ZtEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F739C4CEC6;
	Tue, 15 Oct 2024 12:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993727;
	bh=iGAKntFJkbLUQW/8iCl1c6JIfXmSBUbxNufdbI1qiuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xEd+ZtEbMW5hggwgjBOe10FfPF20bBuiE1BvkmdMeYreIwtKcqE/QwlIyvqfIgqgd
	 MnRwVWhMWvGajx0riudLeT5NSsnGrj079bl5VQZyyVsuatQuG1dNdDJRnyrX4DObtH
	 YhDjSmRhqlBBVtlvLblFV9kaZZgxdltj4Cxggy0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 498/691] ALSA: core: add isascii() check to card ID generator
Date: Tue, 15 Oct 2024 13:27:26 +0200
Message-ID: <20241015112500.109914291@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -660,13 +660,19 @@ int snd_card_free(struct snd_card *card)
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
@@ -693,12 +699,12 @@ static void copy_valid_id_string(struct
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
@@ -794,7 +800,7 @@ static ssize_t id_store(struct device *d
 
 	for (idx = 0; idx < copy; idx++) {
 		c = buf[idx];
-		if (!isalnum(c) && c != '_' && c != '-')
+		if (!safe_ascii_char(c) && c != '_' && c != '-')
 			return -EINVAL;
 	}
 	memcpy(buf1, buf, copy);


