Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDC928D8E8;
	Thu, 27 Nov 2025 14:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255459; cv=none; b=l42NeUpFNWkoYTd5Op3+OMzD5OtqlzH2AarwZOHhPcXlxbRMRtuuXNDrLU9FNueaD8njBVqEabNyq680SUrXixxBcF8AzmRLbSyOPoQa8uzXk6H6aaM5Ruy8p21j7oMcgPA+za+iCpvjKNBz9jGT3Kr/bny0RNP6lTs3yKKWzTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255459; c=relaxed/simple;
	bh=+UVHPNN+ea1zW76Y7GYJl93pcaioZcXaoGU+dS3AlII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZlN+xTpTOdwqkyjeA3q7VwzJhFysEYhaO88BGfzLGH2AQTeGVTbfxkoIKU3Kh+qnjHmlgqjnamhABeks/F3Q5ZG/kk8q1UDsiUDC5J6sR+VsdC2+ufDbJqkv13llSZLSihNKg72Kcp30JPlqoODE+WNTo73ZdSTwa9mx3B1t5A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFQ+9S8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFQ+9S8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A9AC4CEF8;
	Thu, 27 Nov 2025 14:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255459;
	bh=+UVHPNN+ea1zW76Y7GYJl93pcaioZcXaoGU+dS3AlII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFQ+9S8V5xjXEBlK/KOtLFqo6YAPVN0nQjkJcjTZn1O7QGRfSWSAUx/oonv8M6+T3
	 /NCgBhyGh9ACcc977jO04kEppDok8/e72XkhUg8op6Jl7nDbG2WQERocDNg4ikHygg
	 Lqt7du4dRpiABMiiNnvV10bGwqfwDS8tsYn0AJHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/112] ALSA: usb-audio: fix uac2 clock source at terminal parser
Date: Thu, 27 Nov 2025 15:46:40 +0100
Message-ID: <20251127144036.428458464@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4853336f0e6b5..7307e29c60b75 100644
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



