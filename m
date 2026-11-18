Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057438;
	b=T+b8N5GW78JPxbXQw3MBqGymCaaDuy4U+N/+nvX8pVrKr1JOhKj0RjtoGV8YEcBbd73y
	 UJ14AFjc4ldhmCpGXDko0Y6xLfckPYT/2yA5UT8rqNvKCkmX4PEoOnVtxR46sGZ0jvaTc
	 ydoTnCgXP6hWme1uocUrhz1aLRSheYsoc9KrXnFBnCclsXpzKf17oonqp+Kp8PnTmZ0Tf
	 kSYIEb8MX7mUUof8YJUps0xzXBdsHzAYnsVwvy7ASC3j6rXBnAcBfN40VDZ8O9mfxJE8a
	 VRLQP+3dmYFqLV7c7qtAd3vm9HY4Vz++HP1wKLu11WnKeQVDslHdo9zVC1C6kBOhcBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p42+ykpSWVeBWCbFs3WGWuaVjMXHQL5BhuH9mYrGFW8=;
	b=zc/1k6s8PkiQK+9PNUTwicHp7HMdQcMEpCIM/9mgzrJTnOURmxOlf8Tih3ogVJXBvCpv
	 HRYr47N2sgmpLzJw5EoF80KQr/pYaFH6htycQJKSIPGjs8aOwivb9k9INJ5/ycn8Ntn+L
	 LXtSY3RxcaCNz+cZc9WFJoM899mtlyGhDAJQm53c5a1yka18HiKIDCcdflBGAoKGn+thT
	 QWhzk//jcW0nFGp+AZDd7+i0rsjz4F9OlsXfQfRndgS/C8QyC+EO3DljRVwxocxPw8w65
	 o44xXDHHY9YoVmZQHRSxQuWn5nOzlrIsmh0mVojXrAq6quDWGUmMhEZRGydMuEjvKMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJsUfWKV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2577360A2610;
	Thu, 19 Nov 2026 03:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJsUfWKV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AAF1F000C4;
	Thu, 19 Nov 2026 03:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057438;
	bh=p42+ykpSWVeBWCbFs3WGWuaVjMXHQL5BhuH9mYrGFW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJsUfWKVrQFd45tExMoog48ctnPezoM5wVbv3tWLw7vwZsuojW+Ggl2GZfY4Gl7KA
	 /hp15J/7TLAVLxZuPTSthzouC3GVNcdz5xxP9EmF1+F47kIGUlX8AV1h9ilLO0UYGu
	 lkxdn2bE58JxuyDTwYN7tKrvpS6QFzrgYowhZ1z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0129/1848] ALSA: hda/conexant: Add NULL check for dc_mode_path
Date: Wed, 18 Nov 2026 15:36:07 +0100
Message-ID: <20261118145916.534966527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 273806f38ce95c95c288a03d3de1e423cd3e5543 ]

snd_hda_add_new_path() returns NULL when no path exists between the
given NIDs, but olpc_xo_update_mic_pins() passes dc_mode_path
straight to snd_hda_activate_path() which dereferences it without
checking. Add the missing NULL guards, same as the local path
variable already has in the same function.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260729070935.548050-2-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 6a7fcb4c77dda..3a4c874f727dd 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -397,7 +397,8 @@ static void olpc_xo_update_mic_pins(struct hda_codec *codec)
 	if (!spec->dc_enable) {
 		/* disable DC bias path and pin for port F */
 		update_mic_pin(codec, 0x1e, 0);
-		snd_hda_activate_path(codec, spec->dc_mode_path, false, false);
+		if (spec->dc_mode_path)
+			snd_hda_activate_path(codec, spec->dc_mode_path, false, false);
 
 		/* update port B (ext mic) and C (int mic) */
 		/* OLPC defers mic widget control until when capture is
@@ -433,7 +434,8 @@ static void olpc_xo_update_mic_pins(struct hda_codec *codec)
 		update_mic_pin(codec, 0x1b, 0);
 		/* enable DC bias path and pin */
 		update_mic_pin(codec, 0x1e, spec->recording ? PIN_IN : 0);
-		snd_hda_activate_path(codec, spec->dc_mode_path, true, false);
+		if (spec->dc_mode_path)
+			snd_hda_activate_path(codec, spec->dc_mode_path, true, false);
 	}
 }
 
-- 
2.53.0



