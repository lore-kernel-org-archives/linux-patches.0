Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031251;
	b=B6qutMX/BGnbOOZo3UMRnXLvPRr50LIoriMe3H6gl2r6BKifXz6vDCB2hAeHVzW6H0gL
	 THwJtBwWN1Hx8nJr5dwyGMsT4XyStTXc0/Q4aFwMJI7TvGpD27Sh2m5N8kRuOfohnvd7J
	 5xnJHM2QOeXtnkZkAtTfqUwfErb6PG5DS3nmRKdk0BLRyD5bAk/6XaDyOYMdQuBJgdae+
	 7x19o7YHxYb2JE+J8LFlnPevzPXDvq1rtyxer7JRgLEzvhxz8DRCt/Atz2UZRx7sUSNMf
	 Eadi60DHvtlDauJcz6pcL6jvCU5C4MAQeFYeHs1aYGYaWZTyLlb9AqG0JgSYEGN3lOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AJRu1nR9W7J2EpU1zaTrWvOdZtFdYuCnUcy477mEWqw=;
	b=o5LueK5Fo1GhOjLcfnJGNyblrIJCFMgygfCEdKe9vDaTPN687jNxUISRE7z21dKyi6RD
	 chCL15SeIzP/AoQL9vqaJiQ+r3KzSU6oSIevIBICrdkTZOE3BVAR35f95ITjauc1uZO7N
	 HNaKfcrSy+nfClVcJd70/7txUp9LahE/xG+T2ttBulfOiOUfH79lt6n4TT12h/thpypxf
	 xUvsv+NQK65pbn9PEJH4YWF3T8YUyGO3cmI/cF2pUt5fEkBH71NYCrOb/iMBK6FQIVK94
	 UAhd0ETmGa3Di0ZeTiZbno/VLlpmjeAQEINJ2H4Ik7bPYaCvNwooZQfjAST5QU8G6Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sQ/G1f09";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32588606A31C;
	Wed, 18 Nov 2026 19:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sQ/G1f09
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888831F000C4;
	Wed, 18 Nov 2026 19:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031251;
	bh=AJRu1nR9W7J2EpU1zaTrWvOdZtFdYuCnUcy477mEWqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQ/G1f09NBOyt1UOroxfLzMq7b1GwOSpvTPr61reCwkiggJLwUbqvNHSMjECOdbGI
	 IadOhCL61k7T6g8V1kf9xI5f7wZmP7yc7YBbqIp3ZwKEF4DNG2JqBMFQZ2c+oZHdgf
	 lwtpCHmbr65QAdUW/sh1H0K737hjMtSslpN0Q5Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0992/1756] ALSA: usb-audio: Check mixer matrix size for UAC2/3 at parsing
Date: Wed, 18 Nov 2026 15:51:59 +0100
Message-ID: <20261118150049.678013237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 22185ffd7b31885d03fdeb20055a8707779a70f9 ]

The matrix of input/output channels specified in a UAC2/3 mixer unit
must fit to the upper limit 256.  Add a sanity check and returns an
error if an invalid size is detected.

Link: https://lore.kernel.org/d46fcac6-bd7e-4fc4-95e1-4e8d39f92ad3@zipdox.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260930155356.348608-2-tiwai@suse.de
Stable-dep-of: c01fb2ed90c0 ("ALSA: usb-audio: Fix invalid UAC2/3 mixer unit matrix evaluation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 45145ef7db7c5..cb685fa0e03ea 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2284,6 +2284,16 @@ static int parse_audio_mixer_unit(struct mixer_build *state, int unitid,
 	num_outs = err;
 	input_pins = desc->bNrInPins;
 
+	if (state->mixer->protocol == UAC_VERSION_2 ||
+	    state->mixer->protocol == UAC_VERSION_3) {
+		if (input_pins * num_outs > 256) {
+			usb_audio_err(state->chip,
+				      "invalid channels for MIXER UNIT %d: input=%d, output=%d\n",
+				      unitid, input_pins, num_outs);
+			return -EINVAL;
+		}
+	}
+
 	num_ins = 0;
 	ich = 0;
 	for (pin = 0; pin < input_pins; pin++) {
-- 
2.53.0



