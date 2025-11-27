Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBE428135D;
	Thu, 27 Nov 2025 15:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255906; cv=none; b=gVfmzAUOMcusQlm4q9byPQu/UxT1EC5pPeZbAXrtsYU4Rrcxz3t6XPcBnK36pqTVfqipJyPXBG+mLTZFx+YK9m3MSgRRG7bnhJvsroHwh6F+YdgRVW6aY+3qDkIBulF9Z/7YENzqVzZLK2ZD0X4NDLvo+76wUB+vKRQV/R8YWr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255906; c=relaxed/simple;
	bh=q8F707h2itHh21ADG4bm+WfQ8Rrje5tiiTHAjfySpRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AgEoo7TMW02jebMKVgGfCChOKleDsJlylHMkkwwXkPAd/KrIPl8eE3EVAj1B19UC3ASXN4AmqKGJ9YoaW3HC2uU9Gnf9pjMglsJ3ig4YNV7mCPr93WI0/qywa/jxUtRMTbURrIh2Z+2loHiCVYQGM1u6HTKbJvh8Id7gVcdWx9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gx/oSPvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gx/oSPvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF24FC4CEF8;
	Thu, 27 Nov 2025 15:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255906;
	bh=q8F707h2itHh21ADG4bm+WfQ8Rrje5tiiTHAjfySpRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gx/oSPvj7hbaPU4UQ49BUMEET60TdtQYkHq5NKgA4ZGKC6ZPPKTWSUJaAFkjP4Kwy
	 e5H8TJuPu3e38U6RWBll8fPGsUnFg1+c4XOYGN39NJYmTU0ah1L3RZ62eJe7GS3kdc
	 9JqgYVaamFeRUi6GiHOrunPmKxLZr6iXwJEJJiWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 155/175] ALSA: usb-audio: fix uac2 clock source at terminal parser
Date: Thu, 27 Nov 2025 15:46:48 +0100
Message-ID: <20251127144048.615038164@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index f2058eb71fc8d..572ef02074538 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -930,7 +930,7 @@ static int parse_term_uac2_clock_source(struct mixer_build *state,
 {
 	struct uac_clock_source_descriptor *d = p1;
 
-	term->type = UAC3_CLOCK_SOURCE << 16; /* virtual type */
+	term->type = UAC2_CLOCK_SOURCE << 16; /* virtual type */
 	term->id = id;
 	term->name = d->iClockSource;
 	return 0;
-- 
2.51.0



