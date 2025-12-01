Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC473255F2D;
	Mon,  1 Dec 2025 11:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588791; cv=none; b=cd824ssf8Ra/lwu/4vyytgyHTZMsUO91BWzOaMM/Plq3VDdCD156mw68qyP/3xzSHdAWzcfJcpRUvHS5IdLl97dCS5Ju7eFV88Swnz+3aRJaPR7Yiq+rM1q0Ojq/+nff+a72FJ/6oEZtGuZrzqAxGxp6umtPeVOQo+JInVN/wD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588791; c=relaxed/simple;
	bh=ZqFFSZyAMyun/A6XNbhgPbbalKqvXzM67FHT5+3UV7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jLIF/3xhpedJTYTXj/a7usNNkyE9lj7OQyhJL7FDXxuVOEaIGo47uC6xg0T5tONcaOvTNh0ClkfBhgE8tOJJKHwAXWD6VXwa+xnMpzs1WAIDFJU2lqZOalQkm2eUvEuYDHe7eUs9Zp78PmKzr7qrsnZKFWCWvE1H9cfi7mAjhrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9GEy19Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9GEy19Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D8DC113D0;
	Mon,  1 Dec 2025 11:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588791;
	bh=ZqFFSZyAMyun/A6XNbhgPbbalKqvXzM67FHT5+3UV7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9GEy19QhJv1EMgB4inLg+SksQucQ2pschPuH3Jfrxkggi4vePpH75E2Wv13Nsfi4
	 bDHeHFmjhZY3wyAxgPbGWqGAQj0O8F96oPrV+gv4Sbit5XsXzUc4wAPc9Iydtp0HUV
	 80FLhS1SQltEg0Pi5tmo1QF3n2KJxjgh5UA9oqo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 172/187] ALSA: usb-audio: fix uac2 clock source at terminal parser
Date: Mon,  1 Dec 2025 12:24:40 +0100
Message-ID: <20251201112247.422913064@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: René Rebe <rene@exactco.de>

[ Upstream commit d26e9f669cc0a6a85cf17180c09a6686db9f4002 ]

Since 8b3a087f7f65 ("ALSA: usb-audio: Unify virtual type units type to
UAC3 values") usb-audio is using UAC3_CLOCK_SOURCE instead of
bDescriptorSubtype, later refactored with e0ccdef9265 ("ALSA: usb-audio:
Clean up check_input_term()") into parse_term_uac2_clock_source().

This breaks the clock source selection for at least my
1397:0003 BEHRINGER International GmbH FCA610 Pro.

Fix by using UAC2_CLOCK_SOURCE in parse_term_uac2_clock_source().

Fixes: 8b3a087f7f65 ("ALSA: usb-audio: Unify virtual type units type to UAC3 values")
Signed-off-by: René Rebe <rene@exactco.de>
Link: https://patch.msgid.link/20251125.154149.1121389544970412061.rene@exactco.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 11a74cc0e94d8..d6dfa2b40067f 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -914,7 +914,7 @@ static int parse_term_uac2_clock_source(struct mixer_build *state,
 {
 	struct uac_clock_source_descriptor *d = p1;
 
-	term->type = UAC3_CLOCK_SOURCE << 16; /* virtual type */
+	term->type = UAC2_CLOCK_SOURCE << 16; /* virtual type */
 	term->id = id;
 	term->name = d->iClockSource;
 	return 0;
-- 
2.51.0



