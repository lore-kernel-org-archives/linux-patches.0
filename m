Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830960;
	b=bY42BFGIEPEuZ/dBtwXr+aR/tIp7v7+KoeCLdTimDk3xFSCSUh+tS+1N+BGtCDaRignl
	 kHdZEo44EeYNS4q9aJsQlQBNItGuEcEsffh6jaKTwJPVaPuN1SSewhtcB48KOkD+Rq0hG
	 xdchvQaYk5WbToXFcQ4v/FFLAJaCs6B+wqfYGv7JFlvRIXsDK8MdKdnE6+3aHFQY/jNRZ
	 ItTpsLzhXMpVBKX55o9VTcq6/EsCP/DZw9N5tCIZ9TwFdTV7lJE6jA/KNPqpV3A4BzKT9
	 QCJMPUOuUVPzV01sKw/EcWRV7OPvS5/VgOay0VOtQhJwcLGRfYEBA0wr6HgS/vcl32Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7HwAdo7GuLRKL5VSJj9d/UY4N+TDz3oMOxGY1Yv7kp0=;
	b=lQ713KcJJ8Kal57cKk2PBIODMcPatNQarRThTWpNI0pm5VmtmeyCw6FAFAavbJsPGwCC
	 eT5PRNJ9/QtltyvSSLl665y00/PtS99SJgpDYgUpIs/Hbnrrr06X6Ljmmr3mo8siIWTLQ
	 fK92poDih5SXcnWvpGNzZY5ERKrF+yp5N2g1x8IfZK4aRDjqykG8vyIR5JxtXkY0yTg7b
	 glCyuZLue+lKRCI8exqqZRw5dtWzBm3EIKPSELpMsMc2aNaaGdhkRIM0DmUSce7lLtWZb
	 VH1Ww9+a2Oz1usOMWr/dpQXpslYsd1tALtXpa2QzoB/TVgitarzk2AdFn3/+3ErJS4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xN4ybw8J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB27B606A876;
	Wed,  4 Nov 2026 22:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xN4ybw8J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540D21F00A17;
	Wed,  4 Nov 2026 22:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830959;
	bh=7HwAdo7GuLRKL5VSJj9d/UY4N+TDz3oMOxGY1Yv7kp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xN4ybw8Jln9YoW8lGLrKTghpPcv5HOwjyFxxt+fGW9drAFAbrcBI0GixuiCWqclev
	 G2LVg3oNGLL3wptpDal82V+3qFqYnt8i6goc8pYEPoiW9ewx9ryxwJmkMKORLaV52n
	 dLU1OEtTTqMROH9bHeXce/srAnUAeID0OAFhQKXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Moroziuk <dmorozyk1@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0386/1005] ALSA: hda/conexant: Add mute LED quirk for HP ProBook 440 G5
Date: Wed,  4 Nov 2026 16:01:59 -0500
Message-ID: <20261104211054.900283551@linuxfoundation.org>
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

From: Dmytro Moroziuk <dmorozyk1@gmail.com>

[ Upstream commit 191fe151eb85ff6cb24189fc88c970745497c057 ]

The HP ProBook 440 G5 requires the CXT_FIXUP_MUTE_LED_GPIO quirk to
properly toggle the physical mute and mic-mute LEDs via the CX8200 codec.
Without this quirk, the LEDs remain permanently dark.

Signed-off-by: Dmytro Moroziuk <dmorozyk1@gmail.com>
Link: https://patch.msgid.link/20260812121856.30353-1-dmorozyk1@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/conexant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/conexant.c b/sound/hda/codecs/conexant.c
index ef40f1cb1158e..862fcbe74e4f0 100644
--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -1115,6 +1115,7 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x82b4, "HP ProDesk 600 G3", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x836e, "HP ProBook 455 G5", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x837b, "HP ProBook 440 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x837f, "HP ProBook 470 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x83b3, "HP EliteBook 830 G5", CXT_FIXUP_HP_DOCK),
-- 
2.53.0



