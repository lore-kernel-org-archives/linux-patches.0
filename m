Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065059;
	b=guwygFC/OD8ngb+DRDvbXOiqL8HyV1mzZevWSofG/DHvsPJcPWaZVM9JxRCBRMOGdZLA
	 Ss3OUS3uBe3YN3M3TtiNq35TI+eIfBZDgYO+i9SX7/4Jh9t7hSFVZi3yqLnMWbNNxixlP
	 7zMfgBkffAhi+973JHl5BCISuiC7sr1FUpGJVp/FWMGYjDksX0Vfr42PriK/rAitvlkdo
	 CjTwD26DSjzBmQwwRNCdqpQsX2Joqskxv2UYhR3cYwNdkpy9g/2KRYV4zzE931y17wSgW
	 ZN4awdu/diQzGVHE5nkhntJBGb9jgIuYs4q4uuf1tP+HcvZiS5kqjmeJDfmiBZdxyHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pj2Y3WUQFIo8yI5OAe3mc4xalcMH76I2+xFnnVtMel8=;
	b=kSNMvJFfIRyMlWWjqj6eHIeYsyCClNgGXANWW0RGpvPM8GRaULCFCFtoG2/sRH8g0A7B
	 MPhaB1GXt+A+zSC9wmXpGlEyFBwgfX/bELMU6jLsPhHUbrUVLtyV5cJTlaHq98pTA1i4c
	 pGh7SnfNsWG7YgZnOaWh/VExZet1chmCxnjaLy74nez6DvDbcR2IgHf5qWyNPVW3l4q4o
	 beH1mmfwrFUJ0zLjHM5kWuzysTgty8gw8d5bkAykYVb8f6r6qvZ2B0dfVDKUbqby2jwnL
	 eiW+A8a4LslmpHbD5q03UegHNQdrJOvOYXm2c6GVJfarS4wODueWo3a1Y+r6F541oRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i9V/SjV2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3DB606A32F;
	Sat,  7 Nov 2026 15:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9V/SjV2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A96F1F008A1;
	Sat,  7 Nov 2026 15:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065058;
	bh=pj2Y3WUQFIo8yI5OAe3mc4xalcMH76I2+xFnnVtMel8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9V/SjV2jbAV4IX3+lj+0nL2s2Zw1Kk1eSd3J+EbE8jasMH6H+EUp5bOkyGQKPx4U
	 Oo2JW5NYsA+TQfaq+6/BCtIc0yKS70OmdFPMeLWn3bCx/zQpPWEiGH1SL5cEnDjj+g
	 cijQCmzBVzWNcOa1tzbRRx6HizFgrnQCdbjRT5m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Nemer <thomas.nemer@fortytwo.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0878/1257] ALSA: usb-audio: Fix missing sample-rate control for PreSonus AudioBox USB
Date: Sat,  7 Nov 2026 08:52:54 -0500
Message-ID: <20261107135003.574509433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Nemer <thomas.nemer@fortytwo.fr>

[ Upstream commit 1869c47e5d59c6940823a58d58b647645cb69017 ]

The fixed audio formats for the PreSonus AudioBox USB declare
.attributes = 0, dropping UAC_EP_CS_ATTR_SAMPLE_RATE that the device
advertises in its class-specific endpoint descriptors (EP_GENERAL
bmAttributes 0x01 on both EP 0x01 and EP 0x82).

As a result set_sample_rate_v1() bails out and the kernel never sends
the UAC1 SET_CUR SAMPLING_FREQ request, leaving the device on its
power-on default clock. Playback and capture then run distorted
whenever the stream rate differs from that default. The device keeps
the last rate set by a host as long as it stays powered, which made the
regression look intermittent (e.g. it disappears after the device was
initialized by a host running a kernel without this quirk entry).

Restore the sample-rate attribute on both streams.

Fixes: 34fe4a9df247 ("ALSA: usb-audio: Add quirk for PreSonus AudioBox USB")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Nemer <thomas.nemer@fortytwo.fr>
Link: https://patch.msgid.link/20261018111519.191844-1-thomas.nemer@fortytwo.fr
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index dd02c6294edf2..0426cbda314b0 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2719,7 +2719,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.iface = 2,
 					.altsetting = 1,
 					.altset_idx = 1,
-					.attributes = 0,
+					.attributes = UAC_EP_CS_ATTR_SAMPLE_RATE,
 					.endpoint = 0x01,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC,
 					.rates = SNDRV_PCM_RATE_44100 |
@@ -2740,7 +2740,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.iface = 3,
 					.altsetting = 1,
 					.altset_idx = 1,
-					.attributes = 0,
+					.attributes = UAC_EP_CS_ATTR_SAMPLE_RATE,
 					.endpoint = 0x82,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC,
 					.rates = SNDRV_PCM_RATE_44100 |
-- 
2.53.0



