Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057632;
	b=k/ACUaKd4S0YbFcpjgXGOJqKU/3SIj1mvR1RnKlQaraIKdtETphuBSpDY1+1JD24RBgY
	 gxOWcDCGQEyL/kidedJnE+2483og4VOwpL4AX1Ml7QI9zOySR6QFK+R8iEAC+KfSnP0YD
	 ZmOMO87kBLpbH3cY38tp9YtdNzi7rPZ425cGdAm5F9VGHLcfkvfOovUz9zDosdq+Idkp1
	 DdeJGTf4ED8XcqAbAqU20HQMLthwngD4+0S4EidnR3WFTCEK+fNQpOvGdjfpE8JDGagC4
	 W1HO35xkRzjCvwCzBdLAH9Ow5TMSJ1YWpOQz89cwUXXdXIeF8qch3NnnF4EIW2iARqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JzKujyKXS49hLUtek5vH2CUv2xPMtslfIY+yhqrmNok=;
	b=5g+LWG+uGEgSBhX4IIRdeRtmUYsbT3VE7EPHNGM1hAQM8Nmynd7lqcXgjpnfQyHlvOFH
	 CZFpm1rrvo/JS2hR22P8Io+6MS6ipC/Cqi9KD0jUI3MahwcaVJi7eOnksSXj8GzrjwV1P
	 BRUur4SMmLNs7sbVEg7h+XFFgX1Tehpnl1nYnw1nq9xYNJQKu1/AAzkSPh+UzKyfMq0/L
	 YPdNpx5m2IY+t9JqFXHqV6kYFK39CxrbHY+JIgfhh27M9DnwjalG0OUIitS1sCKbsICO1
	 937H0+TvhSjwLl0I5Z6+AYAFsMhtDOnKTkj0AV9qg/+olk3OlLd8DqmZ2rvqBlr56wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bWI8HzX9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5961860A2600;
	Thu, 19 Nov 2026 03:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bWI8HzX9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D3B1F000C4;
	Thu, 19 Nov 2026 03:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057632;
	bh=JzKujyKXS49hLUtek5vH2CUv2xPMtslfIY+yhqrmNok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWI8HzX9f3TVk9RL+fmoGVlpHDw1HKGT4+ShWVWyn6d8Es1KVTl+kLVWvK9PYM4gh
	 kNBVdKc8wiQTgtG3lqn9/cZ3+aGwzV8Fsd6BKXagyx3lKs3ErHoRoKJ+bDZYqPBmSR
	 BhOXR0y2OWBWb564i6KQJvyE00LU6iDYCRpzeYgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hernan Ganzo <gp@sneemgp.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0199/1848] ALSA: hda/realtek: Limit internal mic boost on HP Pavilion 15 (103c:2164)
Date: Wed, 18 Nov 2026 15:37:17 +0100
Message-ID: <20261118145920.150095626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hernan Ganzo <gp@sneemgp.com>

[ Upstream commit 786fb6b3f513937f712db5a9ba6a12cbc6982ba9 ]

The HP Pavilion 15 with the ALC3227 codec (SSID 103c:2164) exposes the full
four-step internal mic boost on pin 0x12: nsteps=3 with stepsize=0x2f, that is
0, 12, 24 and 36 dB. Combined with the ADC capture gain of +30 dB the analogue
cascade reaches 66 dB, and the internal microphone clips on the ambient noise of
a quiet room; the upper two steps are unusable at any useful input level. This
is the defect class ALC269_FIXUP_LIMIT_INT_MIC_BOOST exists for.

The machine matches no SSID quirk and falls through to the pin table, which
selects ALC269_FIXUP_HP_MUTE_LED_MIC1 through a pin signature shared with
several other HP models. Add an SSID entry instead, using
ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED: the existing fixup that applies
alc269_fixup_limit_int_mic_boost() and chains to the same mute LED fixup, as
already done for 103c:218b. The boost becomes 0 or 12 dB and the LED handling is
unchanged.

Tested on the affected machine by selecting the same fixup through the model
string (snd-hda-intel.model), which bypasses the SSID and pin tables, with the
driver confirming the selection:

  snd_hda_codec_alc269 hdaudioC1D0: ALC3227: picked fixup limit-mic-boost (model specified)

With that, Internal Mic Boost reports Limits 0 - 1 (0 or 12 dB) instead of 0 - 3
(0 to 36 dB), so alc269_fixup_limit_int_mic_boost() clamps this codec's internal
mic pin as intended. Note that /proc/asound/card1/codec#0 keeps printing the
unclamped hardware caps (nsteps=0x03): that file reads codec parameters uncached
by design, while the fixup overrides the driver's cached parameter that the
control is built from.

This does not by itself make the default capture volume sane -- the remaining
12 dB on top of the +30 dB ADC gain is still hotter than this machine's usable
operating point. It removes the two unusable steps from the hardware range, which
is what a quirk of this class can do.

Signed-off-by: Hernan Ganzo <gp@sneemgp.com>
Link: https://patch.msgid.link/20260921205538.41192-1-gp@sneemgp.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f6a96dddee145..69f59dceb6b59 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9182,6 +9182,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
 	SND_PCI_QUIRK(0x103c, 0x18e6, "HP", ALC269_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x2164, "HP Pavilion 15 Notebook PC", ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x218b, "HP", ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x21f9, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x2210, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
-- 
2.53.0



