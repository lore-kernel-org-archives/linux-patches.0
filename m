Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAC23806B8;
	Tue, 10 Mar 2026 11:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141649; cv=none; b=Sy/LeiLzrcgDoMChwpcYT1MyEFPx09406oyJx5+c3X8oTWVUXKW087elfjJSe3blLItXakPIY9SM/8xDW2/5Jo7QqPIVnfLclMNzguZsS//OLa/RiYQ5jdMfrk5+jMpSyXQpW8dz1NqzLsn0Cq8yON83hlD4sB1/JipwlPYfi80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141649; c=relaxed/simple;
	bh=r5mfS4UQO8FydChOYBUZKC9ttMYt1aGPgwEvn6xM/aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GG996JUCL1cfpcAqDUk9q0LcNnghJU60lzMQmZGHA7CRXcrM5P9Cf0I2RrRNZ2Zc6rfCzbpXPJNRNax/sN2I/1D8VZnURXeUeQYFhRNAARM9t5Imh4jwfzPpgwys6RwAIN8zQOQ5nxJ6ViecXqoa6qlO9HhefOxKfKj/L2ckmXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJsqeqQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJsqeqQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A520AC2BC9E;
	Tue, 10 Mar 2026 11:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141649;
	bh=r5mfS4UQO8FydChOYBUZKC9ttMYt1aGPgwEvn6xM/aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJsqeqQ04lQ5o93z46EkpEzZE8r8rdF5SaQZxqMiZ5T9vfm+XiwveXIOsd5J410e/
	 L4Zh967cYrDsYiAw/j/aeysziORWy8A/2P00Vd50H6vFAk4Sn4FNDyS+TZ3OXdjqD+
	 9MEayGUm73wEuGclqlqIwAdC6GBxUboEkBFL8O95Mn6NsHa4g27zIPGt+CbW0mhE7W
	 ddcJ4NG/PKUY1SHv04E3LR1FWQwHp2vzcoWpkc2HHQTqjllhdor0jqQB+rbkPWK/EQ
	 dkEM1bmwr9XFMtFpAd5PbE9fbYyBG2NEhs8RG0YJAVDi4+sGWEG3G+KlC6/JSBHvZH
	 Hgttz+P5s8z3w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/314] ALSA: usb-audio: Remove VALIDATE_RATES quirk for Focusrite devices
Date: Tue, 10 Mar 2026 07:14:34 -0400
Message-ID: <78469cb52ea0f7b8d6d390654f92e19086d80a0d.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Geoffrey D. Bennett" <g@b4.vu>

[ Upstream commit a8cc55bf81a45772cad44c83ea7bb0e98431094a ]

Remove QUIRK_FLAG_VALIDATE_RATES for Focusrite. With the previous
commit, focusrite_valid_sample_rate() produces correct rate tables
without USB probing.

QUIRK_FLAG_VALIDATE_RATES sends SET_CUR requests for each rate (~25ms
each) and leaves the device at 192kHz. This is a problem because that
rate: 1) disables the internal mixer, so outputs are silent until an
application opens the PCM and sets a lower rate, and 2) the Air and
Safe modes get disabled.

Fixes: 5963e5262180 ("ALSA: usb-audio: Enable rate validation for Scarlett devices")
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/09b9c012024c998c4ca14bd876ef0dce0d0b6101.1771594828.git.g@b4.vu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 6860b5bd55f1e..ea5de072c36a1 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2421,7 +2421,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	VENDOR_FLG(0x07fd, /* MOTU */
 		   QUIRK_FLAG_VALIDATE_RATES),
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
-		   QUIRK_FLAG_VALIDATE_RATES),
+		   0),
 	VENDOR_FLG(0x1511, /* AURALiC */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x152a, /* Thesycon devices */
-- 
2.51.0

