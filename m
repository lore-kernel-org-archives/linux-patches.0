Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DF1413252;
	Mon, 20 Apr 2026 13:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691646; cv=none; b=K51qjUkkJMN8ky+8h9NDZ6g92V1aTSnEKvVlwUm8lMYJNRIOIK7sPu9OkC7gNtLH9Doh+aHylrqs9cDl8V9mSc3fwG1gClD7+c/VRYdKX2HV/k0UdjktN73OLFgjH0hkx1QB180rPFFxAM9/WxAYcPBJZB/S0DawHbe9IdAPCKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691646; c=relaxed/simple;
	bh=w47rgBfYGSbSzG+HVB8huDwnvznmbvL3xTLQvYHlpIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBGrbTUHCBmSjEEgv7mearKUPHKIo2zX0bHF1k9i9Wz+My9P8a9TdDdqtnXFOXr+gGyq+YWvtUTCzcCRcLSoKX92rxDYE6aBS6IiupDqbA48lVHT/blSLQNA4BeEiChvQmr0ap7eNo3AuSGK5e7J3AjvVk8RByt4Gy+VsSkhHfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NHyESipr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NHyESipr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9ACDC2BCB4;
	Mon, 20 Apr 2026 13:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691646;
	bh=w47rgBfYGSbSzG+HVB8huDwnvznmbvL3xTLQvYHlpIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHyESipri3fnOFb//mcsYCLrI0mgIITjVxFxUuLVxvOQ/gpGVxSO3whXbQ1F/YJcr
	 iBKTkCcijwFvBZlT6E8IaTQf0D5FqyIiu24BnjMJGFTbgJNHOXvyjX8pPyI7hLBv+t
	 Rdf/dnPwugWfS4IH8sUSUrwCQICAuXRyGVb7AHGnrK+tMnl+JBiUgoluA69ayrNBOx
	 9NW0NSEPRJ2pfao5YkW4uUCP/rKHAnGv0p4AsJYnJ05qOgd8io+v0pIS+3zs7zFjKP
	 6pQxpJQkcWjO25g8jPpGHTj6N5tRObUsxSYynvD3Pe/SXRO2mpthVQjtjbEjuD0SZ9
	 kKyx7S1hIYddQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Phil Willoughby <willerz@gmail.com>,
	Yue Wang <yuleopen@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: usb-audio: Fix quirk flags for NeuralDSP Quad Cortex
Date: Mon, 20 Apr 2026 09:19:04 -0400
Message-ID: <20260420132314.1023554-150-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Phil Willoughby <willerz@gmail.com>

[ Upstream commit bc5b4e5ae1a67700a618328217b6a3bd0f296e97 ]

The NeuralDSP Quad Cortex does not support DSD playback. We need
this product-specific entry with zero quirks because otherwise it
falls through to the vendor-specific entry which marks it as
supporting DSD playback.

Cc: Yue Wang <yuleopen@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Phil Willoughby <willerz@gmail.com>
Link: https://patch.msgid.link/20260328080921.3310-1-willerz@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 9f585dbc770cb..a2c039a1b3cd6 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2296,6 +2296,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_PLAYBACK_FIRST | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x13e5, 0x0001, /* Serato Phono */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x152a, 0x880a, /* NeuralDSP Quad Cortex */
+		   0), /* Doesn't have the vendor quirk which would otherwise apply */
 	DEVICE_FLG(0x154e, 0x1002, /* Denon DCD-1500RE */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x154e, 0x1003, /* Denon DA-300USB */
-- 
2.53.0

