Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF1851123D;
	Wed, 30 Sep 2026 17:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791188; cv=none; b=rXjozOmoIAsUSIVAPmf8LnBmySmAfUF4upT9VgzZ+Fg7fAsaVaYretPJOI2ni/Q5hpoogscLKtMte7B8+jIOW3Zpt0x53VERk5GRHDR4oQPP+QnWDuCREEO+wMfEtWcU0X1oBI/WC5BO36YBj+M8xadMPMCZqLI/dR4viu/vb/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791188; c=relaxed/simple;
	bh=HX7FDDskjmDrlodGqdLNTJijVkVyCHv4gQI4QaCxhYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9AW5BMyoNW2elE1sqv72VUk58PIWfsu+L5aCLOheKbY28AmksX16Tt3of4/pnH64L0jDTgSijrIanuYujeBTA7vgtGbi4af0VH0oRXpnBxi9M60lIySRa9FOCpz4gTPNLbcCXOKlIEwvkDEHqTWe0gD+P1WyHXA0FrdeCPyio4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoDfp+df; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoDfp+df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3063D1F000FF;
	Wed, 30 Sep 2026 17:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791187;
	bh=85k7NfWDuMwmorPp46Oyv/HpZ+gQ0hPnU0ouDMoXfjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xoDfp+dfnkusQ0JHohBUD0vIYc+HH/t7apnaf5G+ZBjeh+xXMI/H7GEIUga2O06jK
	 xXf63geCbUxsF1Y6qwswV2atX3s5uh2NyBmKmbXDpwBWwBvzxVOAd00K4gP7tDygTf
	 Ey+IqIu7+zh30ZHjlZQPGxZG56QjYgWbpJzx+Uv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Daniel C. Ribeiro" <dcoutinho.96@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/752] ALSA: usb-audio: Add FIXED_RATE quirk for JBL Quantum650 Wireless
Date: Wed, 30 Sep 2026 17:21:23 +0200
Message-ID: <20260930152402.852151261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel C. Ribeiro <dcoutinho.96@gmail.com>

[ Upstream commit f6d6a4147ace0c417035f65b021027c209c75190 ]

JBL Quantum650 Wireless (0ecb:2125) requires the same workaround that
was used for JBL Quantum610 and Quantum810 for limiting the sample rate.
Without it, the capture (microphone) stream fails to work.  Setting the
QUIRK_FLAG_FIXED_RATE flag, as done for the sibling models, makes both
playback and capture work correctly.

Signed-off-by: Daniel C. Ribeiro <dcoutinho.96@gmail.com>
Link: https://patch.msgid.link/20260719090037.40149-1-dcoutinho.96@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 9cb0e24004db6..1278d8a3cc128 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1851,6 +1851,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
+	DEVICE_FLG(0x0ecb, 0x2125, /* JBL Quantum650 Wireless */
+		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0fd9, 0x0008, /* Hauppauge HVR-950Q */
-- 
2.53.0



