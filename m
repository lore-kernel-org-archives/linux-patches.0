Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B82150390B;
	Thu, 17 Sep 2026 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664967; cv=none; b=Ejl8g/wVa7I0oTLUSNAhRnwm5t/k5D76jx4Hk/1pGxVPUJzUnZGctMWmrlDOi1WURXb/XZSKmU2MmscuwJdlw4a5Dq6gNiFiNhQpfkdq7SCUoKGUblI+5LrrVyHBHijnMWUDCvWAagRaYwgkq+28XHyZjrzKgHHlzNjVswS8Q2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664967; c=relaxed/simple;
	bh=dS7X9lC9mfGqLAmGmiRG+oW7Gv6Ny3pqinRtmXG2714=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOzlfYgYnr33jFLbAfYjTQMBKdtPqxYe7sE7lV9r+ukYSYQrWMqhp8a339ibXvMjPK+XWDTgVRGv/GF80JtJ9x5oDvpbx0ViX0vcXizwds8wlS/1bDPYpUAcLAuDAret8T14RO/yutwku/izh5RN8EpeRAAJQoeWIhxDIbtROpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLm/qXnn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLm/qXnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DED1F000FF;
	Thu, 17 Sep 2026 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664966;
	bh=YLvw6r0xnL0WQJSVgwwHxppDTl64UiWhHvtInDYMIPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLm/qXnn5tfwe0/2MuuWOnrKzvuTuxyJXv4xOuSSTYqNj3Hm9SMArpZH2HQecfF73
	 uq40OUKc02m3Yc0pImcaNSmGRff1rXw/pPlKM/WepHXAFcu5/Cnh0NuG0mXwqoqtmB
	 V+vF4487Vx6LunSNG506v9rwNVnwJzdDP/uuANPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhavender Singh <madhav@disroot.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0547/1250] ALSA: hda/realtek: Add mute LED quirk for HP Laptop 14s-dr1xxx
Date: Thu, 17 Sep 2026 16:05:42 +0100
Message-ID: <20260917151606.762268636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhavender Singh <madhav@disroot.org>

[ Upstream commit bf4fc9f33ec21595143132a3e7fb8b5d2c2261cd ]

This laptop with an ALC236 codec requires the
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2
fixup for its mute LED to function correctly.

Add the subsystem ID 0x103c:0x86c8 to the quirk table to apply this
fixup.

Signed-off-by: Madhavender Singh <madhav@disroot.org>
Link: https://patch.msgid.link/20260723104736.23386-1-madhav@disroot.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index e454e164223ed..34edda8c2de42 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6762,6 +6762,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x86c8, "HP Laptop 14s-dr1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86e7, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x863e, "HP Spectre x360 15-df1xxx", ALC285_FIXUP_HP_SPECTRE_X360_DF1),
 	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
-- 
2.53.0



