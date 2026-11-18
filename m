Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043608;
	b=eUJbvNNfPNxsh79AK/KR/X/hGdHFRl/N3OUYv/aZJMwHiJFc2BpVvGtyctlOyvz5m24m
	 nEDKc3/7svgdbBUPMnNk9aHgTc00yhFMxnfmBHNV1L/uQhQgXrptou3emHe68VSUUYSCg
	 3pNkSpK5tEVL6oT3z6IVFRtgi0Sy5D+zhVuC4CFhm/3R/0O6iN4MZfBdTntr2OiYkP5mn
	 uX5P88wAv4Q/fg4E2n2QLSu0o3B7wrh0mXAsoOVEXHBFwyuzOFRfuBWZtKgHast/8FwCE
	 a9IlXwDS+jzbjEKLgHownpiAyS1e3GYBtAUzy+w157irllr1oF28wD15i1PWnUnEI2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tEK26QYKSk5ESMjfw2sJBh/ulJD1+W1whX7BYa2ktn8=;
	b=Pq8QNSzZRtCfa7oJQsmBeDKsSTpRI5UuHpYqypqbvyZhCnQJoStmQ/+hYH80G/Y/pJsN
	 iBPCCmj+iDNhf3YFHxdkphODsiWRJ2be0mapxNvWU26Um9+i0G86pvG3UFkjakrD9mwvB
	 v6zLYPXwvrwIOkkevRP+jWWJdRPSdX55kHPJVvyXOaD/q2ctIBLMlhGAcPpBHqEP2Kbmd
	 46pf+YWxc+10ZKUTfOfT8JZiMrg0nZizqCD+2q0OWxjBa4zr3lH+ZUqIuAGgJdtHpFoxa
	 44Pv4UcKWLm8hYoaUDhe4Vtm7FBSI84Nk0jPH99GTOBOHrLLN/gbX9Wysfauv5AG9ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YrKr3IyF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E89606A325;
	Wed, 18 Nov 2026 23:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YrKr3IyF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9B01F000C4;
	Wed, 18 Nov 2026 23:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043608;
	bh=tEK26QYKSk5ESMjfw2sJBh/ulJD1+W1whX7BYa2ktn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YrKr3IyFc3AfxvzVjSPw0MeicO06FmOZ4NyjFhOSxbODVgLr2mNfgX7i3ForF0BL0
	 Bf8AcWilapNB8MZFT7QP7VjZsQSXauDnrM8KGY/OSWAfa4NTCgTgJaraKxyPHtkeBn
	 6xlLrXq82BqNFMhrtRsDvwEA+3gPDlOAhLsyWl5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Porter <mrwillporter@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0270/2857] ALSA: usb-audio: Add iD14 MkI to monitor-mix volume quirk
Date: Wed, 18 Nov 2026 15:21:44 +0100
Message-ID: <20261118150211.150531817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Porter <mrwillporter@gmail.com>

[ Upstream commit 17056a36d276a740f09dca723de1bc6aa3eb4ef9 ]

Add the iD14 MkI USB ID to the existing audient_id14_map. This
names feature unit 12 Monitor Mix Playback Volume.

Live meter A/B testing on MkI USB ID 2708:0002 reproduced the same
asymmetric attenuation seen on MkII. At ALSA value 104, the right
channel was 23.07 dB below the left. At 127, both channels were equal.

The misleading Speaker Playback Volume name causes PipeWire to adopt
FU12 as the stream master. Reuse the existing map to keep the control
available while preventing that selection.

Hardware-tested on Bazzite 7.2.0-ogc4.1.fc44.x86_64 with this change
backported. ALSA exposed Monitor Mix Playback Volume after module load
and USB reconnect. PipeWire volume changes from 100% to 35% and back
left all four FU12 values at 127. Channel-isolated left/right playback
remained balanced after reconnect.

Build-tested with CONFIG_SND_USB_AUDIO=m using the focused sound/usb
target.

Assisted-by: Codex:gpt-5
Signed-off-by: Will Porter <mrwillporter@gmail.com>
Link: https://patch.msgid.link/20260823015353.686080-1-mrwillporter@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_maps.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 8046d5987d5b1..ace4ccad8f51c 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -505,13 +505,13 @@ static const struct usbmix_connector_map gigabyte_b450_connector_map[] = {
 	{}
 };
 
-/* Audient iD14: FU 12 advertises Volume on only 4 of its 6 logical channels
- * and sits on the monitor mixer branch, but it is traced through to the
- * Speaker output terminal and gets named "Speaker Playback Volume".  Userspace
- * then adopts it as the stream's hardware volume, and any setting below 0 dB
- * attenuates some channels but not others (20 dB imbalance at 80%).  Give it a
- * non-standard name so that it is no longer taken for the stream's master
- * volume, while remaining reachable for anyone who wants the monitor gain.
+/* Audient iD14 MkI and MkII: FU 12 sits on the monitor mixer branch but is
+ * traced through to the Speaker output terminal, so it is named "Speaker
+ * Playback Volume".  On MkII it controls only 4 of 6 playback channels.  MkI
+ * testing found asymmetric attenuation within the main stereo pair.  Userspace
+ * adopts this control as the stream's hardware volume, causing imbalance below
+ * 0 dB.  Give it a non-standard name so that userspace no longer treats it as
+ * the stream master, while keeping the monitor gain reachable.
  */
 static const struct usbmix_name_map audient_id14_map[] = {
 	{ 12, "Monitor Mix Playback" },	/* FU, partial coverage */
@@ -602,7 +602,12 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.map = maya44_map,
 	},
 	{
-		/* Audient iD14 */
+		/* Audient iD14 MkI */
+		.id = USB_ID(0x2708, 0x0002),
+		.map = audient_id14_map,
+	},
+	{
+		/* Audient iD14 MkII */
 		.id = USB_ID(0x2708, 0x0008),
 		.map = audient_id14_map,
 	},
-- 
2.53.0



