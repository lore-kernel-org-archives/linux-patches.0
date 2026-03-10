Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC8B352C4F;
	Tue, 10 Mar 2026 11:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141127; cv=none; b=nSXgVzZP/nBWLBU2YFaRe4PPgUGrAjz7liXvHYQiRs6mqJ4ddGFjPfBoLQQvkYOT0Tl6KnvYEkYyJs6f3J9q/Pb1WU7jyHl4fETmwrMrGNn2WM7BaDxQFdlVEK9r9fokkBE4BRp8BlpxuQ7ezNxpdkgTJ2qzzr9LTTllAAoYAvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141127; c=relaxed/simple;
	bh=15zQJJE0qAkyZwV0VCD0krDPigYom1wibm8r4pKUGqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLuHA0DQJmUhgnlD2YN3dFSA9EML77KXsbOX0uILiPhjqxdJLSwzOqxWggJlpu4kmrwf8PLbOiCa4jDthAvpolkRMhc/U1Fh0erMivlQfDVkNeYipIIB2Gu3VbLX+sRKwVvYKBNZ7QI9QJXua9cLbyKpsWjorqvHkH9XtvCPPtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FIP0qSye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FIP0qSye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2F4C2BC86;
	Tue, 10 Mar 2026 11:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141127;
	bh=15zQJJE0qAkyZwV0VCD0krDPigYom1wibm8r4pKUGqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIP0qSyedOiqI1rHmEyTaYUXFpPgLL68N8WsFLEg2K5FvT361F9wShbi6CrmESJGD
	 Bqiy459WApRqr608mAGUdWbEPdhm6f0d1Xi5kvM2qpl4rir+ep/vC/b2RLUBGqHsYA
	 JvL2r5p5eaJiR7U0bRofeCvYOYRS+zAH+14VE1CQZw7t+z0k1WmRVgd722ryX4Ewvn
	 nHmR6Ky8tJBryErAywei6wPzmS7lT5RFLvXlhJlfqfpCKRXhPZPZa8rGIGhnIQHGfe
	 SBBB+amn6lTwgeNhNN5aSvotDu2JWQGNnQEZKlvChH+VQgsl7c6iEVtlN8syTHTzqP
	 T/5LKbO1JN21A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Juhyung Park <qkrwngud825@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 130/311] ALSA: hda/realtek: add quirk for Samsung Galaxy Book Flex (NT950QCT-A38A)
Date: Tue, 10 Mar 2026 07:02:57 -0400
Message-ID: <1071d8a6d98bd55f14e92cefeda96611c6c3c92b.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Juhyung Park <qkrwngud825@gmail.com>

commit 9fb16a5c5ff93058851099a2b80a899b0c53fe3f upstream.

Similar to other Samsung laptops, NT950QCT also requires the
ALC298_FIXUP_SAMSUNG_AMP quirk applied.

Cc: <stable@vger.kernel.org>
Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
Link: https://patch.msgid.link/20260222122609.281191-2-qkrwngud825@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index f77f160504adc..1b674b77da69b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7313,6 +7313,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc109, "Samsung Ativ book 9 (NP900X3G)", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc188, "Samsung Galaxy Book Flex (NT950QCT-A38A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Book Flex (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
-- 
2.51.0

