Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CD338A712;
	Tue, 10 Mar 2026 11:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142033; cv=none; b=D0qQI+ziN9KoYSYXHenYeq3DPsah3wzL+L7bu2NiOVqJarEaBWxiVy9KgBCZd1SA0HID8XSqf7HOe7KIEilaxJyfrkAAw/8IzYhF2UJk94DGgJds8grqsWm91UDW1C2smDPoFQ1MQArEIX3XRC1zl+srhImBNQe4DDQcwd23D/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142033; c=relaxed/simple;
	bh=/18lp1/ktXGi595Asi6XrzuAJmGWcNaiTcK26oYENqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+fDPNCRAPpnz8VeHRfLABs3GM0aXRnuoufycziIYshYZpqkpeYM/MmnCjkqgMp5aurDTofLo+C6PGIqROC2frjqWMQ2OTFpfDthQ+nSeGhLSVoPhOT5jqVXist8QiBqr6S2whoixEHEq87k32cJje9pb9eAyWwFbEuebO0Fc74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ohgi+L2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ohgi+L2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96AEC19423;
	Tue, 10 Mar 2026 11:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142033;
	bh=/18lp1/ktXGi595Asi6XrzuAJmGWcNaiTcK26oYENqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohgi+L2PIKV7LDxTHBS4DtcrefH1ODRKOqRcZE+f/+xhdf19m1PXHPM7Q9b7+RmiB
	 K5z0hNk8uvf/NugXPGpvX6/uKP7JrBnB6gMz8+wotSn+ZRdRK5XAy9ggTgaNr6dr/u
	 uB77Ma+Hp87V6k/16InicCICsEGbHOC9dd6W95dWzAgU3Q3tDv1min0oVFYGv5cLT1
	 FJYlP4Sy/WN3J5wmymko7WhhJgrw44YqI+q12YOYHKs9LOdKFJ1a5Kqf6Qr6++xh/W
	 ZcsWQzzO3ZU88p4Ep8KavHQyQT62jT98yPONlWX7yA4oLXecmLy5/TGRomvcY+GNSZ
	 oM9kIedUPX4gA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Juhyung Park <qkrwngud825@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 160/314] ALSA: hda/realtek: add quirk for Samsung Galaxy Book Flex (NT950QCT-A38A)
Date: Tue, 10 Mar 2026 07:16:59 -0400
Message-ID: <ec095f85983f0a548889ceee1eb4fcb21fb347c5.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index a094d60194b53..f40e00a578d99 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7150,6 +7150,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc109, "Samsung Ativ book 9 (NP900X3G)", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc188, "Samsung Galaxy Book Flex (NT950QCT-A38A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Book Flex (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
-- 
2.51.0

