Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4D8216E0A;
	Tue, 12 Nov 2024 10:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407706; cv=none; b=sCHKpAViLMuGlXFlWoHQrvuTefnokyxxml/OT5h7tw8P6+5E/tL3YcAK6QkjrHk9usRbn0nIMcwq0xoCYDMavPiLMELzFDAtrip3H0HFF8KFEfcimubzat5PpbMMdZlqHUl/DiA5+JGmwJNqs54OMLBE14zaCROWvy7FQcaCztQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407706; c=relaxed/simple;
	bh=dTboJT77+WrOVsbETKIMcmmchE3jPBDcRu5U3fmBLeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EX0PUmeZagQnclMlTwpxT8RJCnZqVsW/suHAtA7bFvOyjI/TH42hqgOdUwPU71tE8/pLwRvDTfe5B/HBObMBxj+GrWVFxU6d1QlZhsz+Zb9Fqqy2pQ4st5jgBElImz5tSRuSGDb9yDWyekwpNLIySOx64fqF61DtBzAkgbH1gKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTxhf2AX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTxhf2AX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04C1C4CECD;
	Tue, 12 Nov 2024 10:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407706;
	bh=dTboJT77+WrOVsbETKIMcmmchE3jPBDcRu5U3fmBLeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTxhf2AX8z2+i0jv6JyOLQMERB8iTZZNy7HwKYeeg7NAkmhHhf9kj89vVeQEBQVba
	 yxXT2AtHpWnBeC4Ss4POi27NBMrEUnexqbfA4sAIr7TFiZbXI0kbKRlx+dRYrY9Hq1
	 n+wFxTKOdDrA4H5bZ52Chj8T0amx4d+kth6UmQHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/119] ALSA: firewire-lib: fix return value on fail in amdtp_tscm_init()
Date: Tue, 12 Nov 2024 11:21:04 +0100
Message-ID: <20241112101850.857770720@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@maxima.ru>

[ Upstream commit 8abbf1f01d6a2ef9f911f793e30f7382154b5a3a ]

If amdtp_stream_init() fails in amdtp_tscm_init(), the latter returns zero,
though it's supposed to return error code, which is checked inside
init_stream() in file tascam-stream.c.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 47faeea25ef3 ("ALSA: firewire-tascam: add data block processing layer")
Signed-off-by: Murad Masimov <m.masimov@maxima.ru>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241101185517.1819-1-m.masimov@maxima.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/tascam/amdtp-tascam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/tascam/amdtp-tascam.c b/sound/firewire/tascam/amdtp-tascam.c
index 0b42d65590081..079afa4bd3811 100644
--- a/sound/firewire/tascam/amdtp-tascam.c
+++ b/sound/firewire/tascam/amdtp-tascam.c
@@ -238,7 +238,7 @@ int amdtp_tscm_init(struct amdtp_stream *s, struct fw_unit *unit,
 	err = amdtp_stream_init(s, unit, dir, flags, fmt,
 			process_ctx_payloads, sizeof(struct amdtp_tscm));
 	if (err < 0)
-		return 0;
+		return err;
 
 	if (dir == AMDTP_OUT_STREAM) {
 		// Use fixed value for FDF field.
-- 
2.43.0



