Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829678;
	b=aZLc3LnVr+NN71lyng7LgJBvu1g1QVNaaHKkhvhvZ8tj5U9Abbn/NLdT7rER6f5uqiPS
	 8YDNr0b2OGLPxqzARO1r7NM/4LBUlE7LZ5i91qCZQAKjqKezLO7BxQmfovkLAj+XV6zsk
	 RCqbS9Q5Bn9WZ8EzqdTr7w8NaX/1vs1HoKJpBZ4AkkuXbx5GspMjFtE4tMtVp7QqLRaAy
	 68YUxut4cAws90aro0S/ewW6H8604rGbDA0kNeV0gAKH+9uwjjEpE5I7aD9RMBkyWi+iO
	 dSYIB3pjCnzEfW751S/BqqimLJ781m69zc1b6DZ93wLj/Ahw2Xb5vjuJRbC97Flob+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IfMQ9GM79e1ByQAJNR/YmseU/YqUwq2e3eCu/YcRkDQ=;
	b=widyDpU4WCMB/D98WHlYiu/FdlstOIw5+RT6Fvk8ieVe24zvg4c5OdDMWv7Yz1kKPJDG
	 G+BpPoPKmAcSXlO8qLE5VQ9KVLd7RDYUrlhCXRucuAmn1dD9JRo57VApd/0JsovJ8Mg1o
	 3jpZr8Zzyo6mDiB5olE7gQwLZBKLM5kb1J5UBqNHyFhPqReoLcfPxkoVTZbsVodRGYqhs
	 GcyTL78e1SjCDI445sIH3/29GI0xtaId26E0xF00/khgY1VTlTRssFxq2iEWGzOh5/2PK
	 tZcwtodMfW1sGbt/BwVin9VJKQBNawXi72573Xc5V3wJDVk23MY7Z2EoP2ZYmjWCM0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYhscBor;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E695D606C58E;
	Wed,  4 Nov 2026 22:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYhscBor
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8170F1F000C1;
	Wed,  4 Nov 2026 22:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829677;
	bh=IfMQ9GM79e1ByQAJNR/YmseU/YqUwq2e3eCu/YcRkDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYhscBorK+hfh3X22LBRdNIa1AiMnKxYDnbUYNgw9/eQk38yHqm72Yys15oWs9oOC
	 ZBG45LUc1YhWfyIC26VjyZ9VmF1vRLSi2SkpDcHeeJOf+a7AtbW+RUaPSvBPuWenq7
	 JOYMn9JxWF/HnF7/Z26frUHPR9U+oG1BaSX8wDRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0275/1005] ALSA: hda/conexant: Add NULL check for dc_mode_path
Date: Wed,  4 Nov 2026 16:00:08 -0500
Message-ID: <20261104211051.589165775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 sound/hda/codecs/conexant.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/hda/codecs/conexant.c b/sound/hda/codecs/conexant.c
index fe7445fabb887..56d6fbdd9b06d 100644
--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -457,7 +457,8 @@ static void olpc_xo_update_mic_pins(struct hda_codec *codec)
 	if (!spec->dc_enable) {
 		/* disable DC bias path and pin for port F */
 		update_mic_pin(codec, 0x1e, 0);
-		snd_hda_activate_path(codec, spec->dc_mode_path, false, false);
+		if (spec->dc_mode_path)
+			snd_hda_activate_path(codec, spec->dc_mode_path, false, false);
 
 		/* update port B (ext mic) and C (int mic) */
 		/* OLPC defers mic widget control until when capture is
@@ -493,7 +494,8 @@ static void olpc_xo_update_mic_pins(struct hda_codec *codec)
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



