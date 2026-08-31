Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB9D34214A;
	Mon, 31 Aug 2026 13:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184271; cv=none; b=Ze2+/1HL2LP1dRrtH/Km4r7N/V72A40FlId1K8UVsDjbbmE7rUGjbnH7lxAh7O2Rw09MtSdb5ELXab00ThPxm88aFiH/w6YcdHMl3edPg8H+0qnxPhACZNf6TW+hVtKkXBjjNDNGHJ7i98Lsue/zeiIRNyGuJxEsJlVDq0dX5LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184271; c=relaxed/simple;
	bh=ggP8ipUmBNFoGyvIK0cu6rT47ZuwNmsk2u/VjCC13iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JZRr0xyqCnveeSKDy/AS++3PxUQ6JyPL8nHZlEVx33RFAmLA3P9z+MPRzbV7Pu+VprrNuZSPNlNejPqw8+nynfFaiqCI9CCfxTxI+A1Oma6T6Y3y4ludiH2ez8jDZy+64tkO12AF9xO9OInsnsC8QbK6vb/QVH43+e3jImQQ7l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=en3wkUs/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="en3wkUs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7089B1F000E9;
	Mon, 31 Aug 2026 13:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184269;
	bh=OUzm3cehU4MLQPRmD8ZyhIwC3gbPvktaipUmUPH37xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=en3wkUs/XVgYWZpwa+E6Qf1dXExYaBDKjDBDf7N6vdCIzP/GF/tkd8N3tvYac9I3S
	 E1Br32N4Ce6Xdu8P22SxDfSeV9BHZpkT2EnieGKFbK216hNRiqT/yYb3m6iUfGmTGw
	 hdDLevB+3rETe9vF8E7wX/81NdXvK0hCIIv+53rwmDS/XMMVEthKivFXV7+uC3tFVT
	 QZI2Fz92AfhPlFMoOl6rOsgRqM5rSCGXqpeAOxd6OTBZ9budBLhgQwciBfclsSShdv
	 Krt7Zpjmue9VI3J96s5x80vxJd+53R6IyseQzzkLHZ1MX12MED1aWdHgQxUEY2RoCF
	 D1ALaYFws0FzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: usb-audio: Add delay quirk for iBasso DC-Elite
Date: Mon, 31 Aug 2026 09:30:20 -0400
Message-ID: <20260831133314.4125787-592-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lianqin Hu <hulianqin@vivo.com>

[ Upstream commit 5caf27a2bf7f86f92f03e851d252901b64ed498c ]

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

usb 1-1: New USB device found, idVendor=2fc6, idProduct=f0b5
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: iBasso DC-Elite
usb 1-1: Manufacturer: iBasso
usb 1-1: SerialNumber: CTUA171130B

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/TYUPR06MB6217D8FF419F24378196FCEFD2FA2@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background checks finished and match the earlier analysis:

- **Upstream commit** `5caf27a2bf7f8` (“Add delay quirk for iBasso DC-
  Elite”) is on `master` only.
- It is **not** in `stable/linux-6.18.y` (no DC-Elite entry in that
  branch’s history).
- Merge-base with stable is `7d0a66e4bb908`.

So the quirk still needs to be backported to 6.18.y — a 2-line insert
between the existing Moonriver2 Ti and DC07 Pro entries in
`sound/usb/quirks.c`. Verdict remains **YES**.

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index c5b06374044da..a1bdb77843448 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2402,6 +2402,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x2fc6, 0xf06b, /* MOONDROP Moonriver2 Ti */
 		   QUIRK_FLAG_CTL_MSG_DELAY),
+	DEVICE_FLG(0x2fc6, 0xf0b5, /* iBasso DC-Elite */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2fc6, 0xf0b7, /* iBasso DC07 Pro */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
-- 
2.53.0

