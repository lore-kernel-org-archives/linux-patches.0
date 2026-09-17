Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9568749D584;
	Thu, 17 Sep 2026 16:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664310; cv=none; b=hh9EWh7e9DD3TGluDxPPJog+c/cbx+XG+5eUiETg3eDRF9S7sG0963igL38U2rsBAbQdh/XO3Pfp9CAXe/Jl8qnGurlelBwK7dSV2v4YeRJnbevZThkOYKoW5rM43PU5blg1b94WoR6GYhn0DMvN/tFS9GtmDxvnwbePRyMpciI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664310; c=relaxed/simple;
	bh=cjsdw6x7td9sIk4HAXx/IcXvFJ23fPYs1fS8Kl9wrn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4ComKgi7rcZKl7YlFH9NP4MUXMs4vftFx3EzC948G9qwobuEJG3QWsXrlDz87vPPM9BrNwFIw/GiLJk8C4o9FxFzIviPZm++VsXJDxXwvDYYjdCxlLinwGgum1ViOUqxKy2QlDGHgTXwjfiN25tMmKnUKVMIF6bGfeZtvL0Wr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0Sp0he0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0Sp0he0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E580C1F000FF;
	Thu, 17 Sep 2026 16:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664309;
	bh=h0v5eutCDy8wj/hreSyATy+gJWY9rHHmjEw1FY+0WwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0Sp0he0XR53ERxSCiqeFVqxyjZGZvYlsW7aRFWod6HY6OIUHeJV8F/XkO9UkAjIX
	 5pwoxDgxxZT6r8LEweyRQZmVpqtzvkL4r8aATH65y/M81r4N3W3NNYwxs3IX+R8Uo9
	 rz9zCnbTQXaYXi6lxsObfUCMRfBmXPRTzZ+f1RpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Faleichyk <andrei.faleichyk@noogadev.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0328/1250] ALSA: hda/realtek: Add quirk for ASUS VivoBook X509DAP
Date: Thu, 17 Sep 2026 16:02:03 +0100
Message-ID: <20260917151600.984053998@linuxfoundation.org>
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

From: Andrei Faleichyk <andrei.faleichyk@noogadev.com>

[ Upstream commit 3580bc53520ce4efc94ece5886ad3670b93667ba ]

The internal microphone on ASUS VivoBook X509DAP (subsystem ID
0x1043:0x197e) is not detected without a quirk entry. Add
ALC256_FIXUP_ASUS_MIC_NO_PRESENCE to fix the issue.

Signed-off-by: Andrei Faleichyk <andrei.faleichyk@noogadev.com>
Link: https://patch.msgid.link/20260603213313.6298-1-andrei.faleichyk@noogadev.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 2e2e90d037874..fde9fdcd96d14 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7118,6 +7118,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x194e, "ASUS UX563FD", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1970, "ASUS UX550VE", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x197e, "ASUS VivoBook X509DAP", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1982, "ASUS B1400CEPE", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.53.0



