Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830906;
	b=m5vdjZkXehzZW1gEsDbKwAZpAwpYzCUGc1sTDOVDvw0fsHcXOFYPzyN30ErZiS21w3Cj
	 Y6S2aU+HdMW1viKIplsX05CRHoPynQDU3ynbEHFQeVapGEu96cZCGuDIpJHIB08QiWe+n
	 ZcAja+vaT4YvGv4xyQkZsT5ByutwdzyqhuuiQZCoxt9x9mKzwdV0aQ6rBIsrhiMwXdGNR
	 5bIEY2r3oke4qCrEbawb36mcbhjhx/iJbEYf55LuTsC+L+61RxNONQg/8qEb7MF8XBAu+
	 13TOlv2sdtuGVNBL2/X9O+v8pAj/358I5IptMQIGmiavDCrziZtxNNnHZAmMNFe/78w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3iYmyjGVg3x0+YRzcxy41UFoatmju4t1N9umJbkal/s=;
	b=dJRdy5lBRk6Qmtpe5vMKUSlOTQ4/rP9aSPWmi6I2cmizlI3q6CrbxmeROJhvXAbm6g4d
	 DHz9rB8H/lyh+Hkl+96Cb/V8cjpmTlTjOFfSnxGe2t7HBCfdODTl0y4GD7r+C1K5hITTX
	 FJZiwygGuxOuoLMN6SsDUke65Q3jhRMj5x81t2yahrk/XHkd4mOuIz/hDgOYzrS3rHXYZ
	 ugDgz3kqWlqDaJl5WeXUuebDb5maMunke2sQQ1SuMAWSnEwUQjcI1S4bCAHhHjEKtshX5
	 PTfiPxVzTFtYTEmxmkwONL0PSUhXag+VA+VbH/XcnO2/D1LoK3aILlkgKVv/5hV7o1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=skhTSXTn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F6F606A848;
	Wed,  4 Nov 2026 22:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=skhTSXTn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426EA1F000C1;
	Wed,  4 Nov 2026 22:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830905;
	bh=3iYmyjGVg3x0+YRzcxy41UFoatmju4t1N9umJbkal/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skhTSXTnRI57hiiKl7E1D1LtxospFdWyxqaDabZax8LrDOILEBAaeEd3OjSV1iEnx
	 oCc5d0PovFchc0lBbvrN3Yw0ki7ytgDwqMxHT6il6aYyNQBzhygI9UyvmFU2cL1Elo
	 fOVYXVvXt4DbZQwdXTlUEOo5b0PMsb+VT2+8Uyzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Andrews <neil@androos.io>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0394/1005] ALSA: usb-audio: Rename the Audient iD14 monitor mix volume control
Date: Wed,  4 Nov 2026 16:02:07 -0500
Message-ID: <20261104211055.112325727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Andrews <neil@androos.io>

[ Upstream commit 9c0564fcc21aec4f5b7648f61865ce3fc2b84a7f ]

On the Audient iD14 (2708:0008), feature unit 12 is traced through to
the Speaker output terminal and is therefore exported as "Speaker
Playback Volume".  The name fits it badly.  It advertises Volume on
only four of its six logical channels, which the driver records as
cmask=0xf, channels=4 on a 6-channel playback stream, and it sits on
the monitor mixer branch rather than in the direct playback path:

  INPUT_TERMINAL 2 (USB streaming, 6ch) -> EXTENSION_UNIT 51 ->
    FEATURE_UNIT 10 (no controls) -> OUTPUT_TERMINAL 20 (Speaker)

while FU 12 hangs off MIXER_UNIT 60 and feeds back into
EXTENSION_UNIT 51.

Userspace adopts the control as the stream's hardware playback volume,
so any setting below 0 dB attenuates part of the stream and not the
rest.  Measured over the device's own digital loopback, with one
-12 dBFS tone per channel played straight to hw:, PCM channel 0 is
unaffected while channel 1 tracks the control: at 107/127 (-20 dB) the
two read -15.89 and -35.89 dBFS, a 20.00 dB imbalance, and at 127/127
both read -15.89 dBFS.

Give the unit a non-standard name so that it is no longer taken for
the stream's master volume.  Dropping the control instead also fixes
the imbalance, but FU 12 keeps its value across a module reload, so
dropping it strands a device that is already attenuated with nothing
able to reset it.  Renaming leaves the monitor gain reachable and that
recovery path intact.

The mapped name ends in "Playback" because a name from the map
suppresses the automatic " Playback" but still gets " Volume"
appended; the control comes out as "Monitor Mix Playback Volume".

Tested on the ACP path with PipeWire, which is where the problem
reproduces: the control now stays at 127 at every volume setting and
the imbalance is 0.00 dB, and setting it by hand to 107 and back to
127 gives 20.00 dB and 0.00 dB as before.

Link: https://lore.kernel.org/linux-sound/0102019fed22f9d3-fa294ec5-02f1-4fd3-b3fa-76efc14331cc-000000@eu-west-1.amazonses.com/T/#u
Signed-off-by: Neil Andrews <neil@androos.io>
Link: https://patch.msgid.link/0102019ffcdbb1e6-9b59d3cc-ef05-4df1-8f9f-fb2f425bcda2-000000@eu-west-1.amazonses.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_maps.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index ce27fc871f513..8046d5987d5b1 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -505,6 +505,19 @@ static const struct usbmix_connector_map gigabyte_b450_connector_map[] = {
 	{}
 };
 
+/* Audient iD14: FU 12 advertises Volume on only 4 of its 6 logical channels
+ * and sits on the monitor mixer branch, but it is traced through to the
+ * Speaker output terminal and gets named "Speaker Playback Volume".  Userspace
+ * then adopts it as the stream's hardware volume, and any setting below 0 dB
+ * attenuates some channels but not others (20 dB imbalance at 80%).  Give it a
+ * non-standard name so that it is no longer taken for the stream's master
+ * volume, while remaining reachable for anyone who wants the monitor gain.
+ */
+static const struct usbmix_name_map audient_id14_map[] = {
+	{ 12, "Monitor Mix Playback" },	/* FU, partial coverage */
+	{}
+};
+
 /*
  * Control map entries
  */
@@ -588,6 +601,11 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x2573, 0x0008),
 		.map = maya44_map,
 	},
+	{
+		/* Audient iD14 */
+		.id = USB_ID(0x2708, 0x0008),
+		.map = audient_id14_map,
+	},
 	{
 		/* KEF X300A */
 		.id = USB_ID(0x27ac, 0x1000),
-- 
2.53.0



