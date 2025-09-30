Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1E7173;
	Tue, 30 Sep 2025 15:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245695; cv=none; b=fIopkB7RpHbpczaWamdaOlUvpfqZN8/Svtbal9Yrf7oUlqf67LyW+VWGvgSRM8Gp18sgafLcIYLXBaJcM/eaRn5xVceBXcZ4XVkIcvwLLS1xLF0uqnxzwF/yyRhv+agTbLF79HvQgHjKNiDJIZK9syA41QF3e8jnm1fmN1+VQ+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245695; c=relaxed/simple;
	bh=WRASG/Hf5+tgH3LVrM9mRFT59u/ZhopYHV72TRV672Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyaeQJaYJ6poIthd4wltMIc/5qDV1Ri4ZMUGvuEufrA0G/DPY3jKpMqr956NknBuLa/1idHFxT4Jst8+S2AWDxPENXhZv4j56llR2fxWYelpperS4RRBUqKzZ3+o5Xlqs3i6qSzd2A3wdKVo6Y9cZqbnkrdXcHQdYTWe/plc3j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4ZWH2yL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4ZWH2yL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C6CC4CEF0;
	Tue, 30 Sep 2025 15:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245695;
	bh=WRASG/Hf5+tgH3LVrM9mRFT59u/ZhopYHV72TRV672Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4ZWH2yLHTnhgTq97DlQ+yUXcXk1Wg3JjlbadBAG4oJd+jmF0uf0/qgjvMhRnhegJ
	 u3y4vA3cXuUt4VjqsqJPXUuxW+wDGtP735Tc7W1hQ6KrJ6BKQP8wrLHkuEUCDQCCxf
	 vaYxgK9UNktoQ1P8URGqm1LL/7LAgHbiyQaBrQDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 06/91] ALSA: usb-audio: Simplify NULL comparison in mixer_quirks
Date: Tue, 30 Sep 2025 16:47:05 +0200
Message-ID: <20250930143821.382569138@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit f2d6d660e8fd5f4467e80743f82119201e67fa9c ]

Handle report from checkpatch.pl:

  CHECK: Comparison to NULL could be written "t->name"

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250526-dualsense-alsa-jack-v1-7-1a821463b632@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index f91dbc9255f12..9a5e8c47ce0d2 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -126,7 +126,7 @@ static int snd_create_std_mono_table(struct usb_mixer_interface *mixer,
 {
 	int err;
 
-	while (t->name != NULL) {
+	while (t->name) {
 		err = snd_create_std_mono_ctl(mixer, t->unitid, t->control,
 				t->cmask, t->val_type, t->name, t->tlv_callback);
 		if (err < 0)
-- 
2.51.0



