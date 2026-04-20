Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4080F329E44;
	Mon, 20 Apr 2026 15:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700749; cv=none; b=A7yJCo7K4+70FVKlf7pSjKwZNedtKjzgjFcfeFEh2dekcmRicSu5N/vnfKMBAd2QYFh5ANaGsCwrHYBHP3UEsFWIQtgWwUlJ0pr3jZ4ptjZkyDCIX1NptuC2UZLXyJXaCA40Ko0dM2elGlyiGmjPxAsCO5vQjZrbjyZD2iLHdBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700749; c=relaxed/simple;
	bh=vupX0sITVuvpKDClANtyrJmaujiU+kNjXWVrtiBdlqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUcEFrUTiTGmcYkfS8iBYd7MyFEonmMmyxZZ50+cQfn6W8j7LZ171Kjrwreol7t5txhzZ0SZcSjrfDyoXs5k71OcvJvjg87365HvMqDLruB1MXO6LhJ+VEtEHURRyitSsiV+QgNuU7SK+fQW+z/FeC+SvyO63K48BMtZzaTKDUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnMVvIC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnMVvIC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEC6C19425;
	Mon, 20 Apr 2026 15:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700749;
	bh=vupX0sITVuvpKDClANtyrJmaujiU+kNjXWVrtiBdlqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnMVvIC+1OH6nEeg7ulGTOew01KI1bB1GbxHiAEuONnSy9/9LQFE4vNQVyy2XyG2a
	 O86PxGebLO/iNzjIBmbjPRpSZZbVhTozZIhwHuPrMfn0qesJ9L64O92veQerCBk32/
	 lAZlqiNbI5MNN2WKOiEPntX9Wf69WhUqA2Pv4IwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Garcia Corona <fgarcor@gmail.com>,
	songxiebing <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/198] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IAH10
Date: Mon, 20 Apr 2026 17:40:18 +0200
Message-ID: <20260420153937.025894068@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

From: songxiebing <songxiebing@kylinos.cn>

[ Upstream commit f0541edb2e7333f320642c7b491a67912c1f65db ]

The bass speakers are not working, and add the following entry
in /etc/modprobe.d/snd.conf:
options snd-sof-intel-hda-generic hda_model=alc287-yoga9-bass-spk-pin
Fixes the bass speakers.

So add the quick ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN here.

Reported-by: Fernando Garcia Corona <fgarcor@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221317
Signed-off-by: songxiebing <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260405012651.133838-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 2e89528e5cec1..6b53a7d90932d 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7467,6 +7467,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38fd, "ThinkBook plus Gen5 Hybrid", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x3911, "Lenovo Yoga Pro 7 14IAH10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x391a, "Lenovo Yoga Slim 7 14AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x391f, "Yoga S990-16 pro Quad YC Quad", ALC287_FIXUP_TXNW2781_I2C),
-- 
2.53.0



