Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956E62D978B;
	Tue, 10 Mar 2026 11:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142031; cv=none; b=iJPCfzoOqQrPGFLg1ZIEpwlso7BydejQFCPzpEiwoVnFZWoq3TMAKVZuh2z4n/m8Kfw83jatlj/pK60h8nAdYX5iqaPaHnZqdERt8lZiT/fZjFFCSB7BEurOhFfecu+41HeDmXHwfOluSr+XjcAJRyDj8D4GA0o4ZHCJkQa4mHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142031; c=relaxed/simple;
	bh=upiSQMo8q3yCrtlkiYPZTa9P5ASHMF/i88cgAj2N6fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+1GSC6UA+un3O4dqQzhvupiWw1P5KHwSW9ZG77evBSnukUzX0kkWqEMLxbyK7zONnG5KNMtehg1xJlbD3CGGHfoS7PEdB2Oi9Y7AhXdl2GhH3I8L9YWwK6foSdzll5wM0HWWcSKcvJ3Jg1YcuJyvzakIkQ36m4sJDmUymeQtWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJFCtMks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJFCtMks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAF3C19423;
	Tue, 10 Mar 2026 11:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142031;
	bh=upiSQMo8q3yCrtlkiYPZTa9P5ASHMF/i88cgAj2N6fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJFCtMksDWmwaLPO7UXGk/hg3kzuw7z4zoxZ/8AsqnQLaptP8T3uLh3CNZVQ2tJoC
	 oVaJGUcOHRJa0DdQ/NsU+Dp1dBZXOUkIRdzTKHlrd/+zykuhJWbRYzhg9eU9gMSdVT
	 flrNYTERvCEy3mko6NppIZ0HoMxYOR6AzLkm+xAWUSDi6RAplCBb6TUsEaIBU1zLZJ
	 OYxAmrPcOtf5DsIloQgaGRry08HcDF6ltc6on2Xn3TxkxzmTeayNycSL7hdMU1d7Dv
	 ljmwjdIGANbnRuT33bW/8Q0SD7BlEPpV9vMfYffgLNpllgAv/znWpmWCoGxT3elVdO
	 SJl5saOZo+YRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Juhyung Park <qkrwngud825@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 158/314] ALSA: hda/realtek: fix model name typo for Samsung Galaxy Book Flex (NT950QCG-X716)
Date: Tue, 10 Mar 2026 07:16:57 -0400
Message-ID: <25af276f3fd16adb7c04b24bd8ae5e71947cf008.1773141555.git.sashal@kernel.org>
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

commit 43a44fb7f2fa163926b23149805e989ba2395db1 upstream.

There's no product named "Samsung Galaxy Flex Book".
Use the correct "Samsung Galaxy Book Flex" name.

Link: https://www.samsung.com/sec/support/model/NT950QCG-X716
Link: https://www.samsung.com/us/computing/galaxy-books/galaxy-book-flex/galaxy-book-flex-15-6-qled-512gb-storage-s-pen-included-np950qcg-k01us
Cc: <stable@vger.kernel.org>
Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
Link: https://patch.msgid.link/20260222122609.281191-1-qkrwngud825@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index e1e0b4de4a69f..11c526d94858d 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7149,7 +7149,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc109, "Samsung Ativ book 9 (NP900X3G)", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_AMP),
-	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Book Flex (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a4, "Samsung Galaxy Book Pro 360 (NT935QBD)", ALC298_FIXUP_SAMSUNG_AMP),
-- 
2.51.0

