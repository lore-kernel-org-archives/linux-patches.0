Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065047;
	b=XQL01HERcsg0H3Vf1dX9dmjRhKBSYBYWnBgEkPXxAV9OH1y4dR30dBiWe+9IxGffHtAA
	 3V1UJgkycnjh//NAK5cVW/Dg5MeHVJMRWpEnJrLyJSTAb/Ud/Tc8tRkWtrvUsKCZwdxvv
	 +K6dHyN+aaaDVhXCl1YalcfMGWjp2YK3ZH1n1U29m559Bb0oRJ0FebUHtTCUtvqjeAn2B
	 wlKpmtvyfT/H4Uwg2r/jtMpWJSrA/wWQKXMylIaoevLXiFsly9ZTpXzWk4ZqNxsWGWwMQ
	 mSn9FoPKdc12lXUNGNQXc9JyWitzdma4QfQQoH/vfsp4gofEjr4/ylYphUvl0j0InmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2goDbU+HDU91M1VC7nj/fnsHTKHd2x277XOqlgQTjZs=;
	b=0eEZ9ctq6j+y5+dzEeFBLQaOTUxBTtdpKohCWKFOp6ZITxCSI0vSNZj1046LGgclEQGu
	 LXGtyWZrX59yNHRO4s5Y6O3VsClPS133CFMDdVWwxOR+jEPURgSg5SHLq8JaYiGPXPfk0
	 dmwEXXn0KNAy6xLgzkFAwjTB0qkND8lkqPtvvacKj0/NkikbTNIIDSweNcJm6Sun9EIWC
	 90ENVuZwyxie5NddeSUdxAEFLBYZRmNwDz+6VYPwxjzriySyWRkCG0edwOLaFekAqLyZv
	 67vmFrVXAKHmq+q1UI+a/N4Zv3FFoNKpn2KxUJyVvpGiL63+Qox8KDz38ONEZyA755Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1RKxo8sZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1A0606A32C;
	Sat,  7 Nov 2026 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1RKxo8sZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364A41F0089F;
	Sat,  7 Nov 2026 15:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065047;
	bh=2goDbU+HDU91M1VC7nj/fnsHTKHd2x277XOqlgQTjZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1RKxo8sZFR0ehu5BdcND/iwyJ2LxRXcwoMHrm5Wd+3evCyWMsyjvHMHca3HWu6v3w
	 yErzZVTlZRRnanFyZOY33U0YlFgXNYzcSiqktCqEhWAIrGHpls0K9pjeuBi7HntTzg
	 LFkjZjAh732GrGnnXoIZ5mchtzFeqJwDe56XzWqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Nemer <thomas.nemer@fortytwo.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0899/1257] ALSA: usb-audio: Skip sample-rate read-back on PreSonus AudioBox USB
Date: Sat,  7 Nov 2026 08:53:15 -0500
Message-ID: <20261107135004.158417024@linuxfoundation.org>
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

[ Upstream commit 20b9cae98ddcff87828d033e35b31f9e6a14dd6a ]

The AudioBox USB stalls the UAC1 GET_CUR SAMPLING_FREQ request on both
streaming endpoints. After the sample rate is set, the read-back
verification in set_sample_rate_v1() fails and logs

  usb 1-3.1.2: 2:1: cannot get freq at ep 0x1
  usb 1-3.1.2: 3:1: cannot get freq at ep 0x82

on each endpoint configuration until the sample_rate_read_error counter
gives up. Set QUIRK_FLAG_GET_SAMPLE_RATE to skip the read-back on this
device.

Fixes: 1869c47e5d59 ("ALSA: usb-audio: Fix missing sample-rate control for PreSonus AudioBox USB")

Cc: stable@vger.kernel.org
Signed-off-by: Thomas Nemer <thomas.nemer@fortytwo.fr>
Link: https://patch.msgid.link/20261019204944.28302-1-thomas.nemer@fortytwo.fr
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index b9e89e94e95f5..b96cb3421cc15 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2462,6 +2462,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1901, 0x0191, /* GE B850V3 CP2114 audio interface */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x194f, 0x0301, /* PreSonus AudioBox USB */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x19f7, 0x0003, /* RODE NT-USB */
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x19f7, 0x0035, /* RODE NT-USB+ */
-- 
2.53.0



