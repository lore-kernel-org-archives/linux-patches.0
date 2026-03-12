Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED7735DA73;
	Thu, 12 Mar 2026 20:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346901; cv=none; b=l7hR031QaDUkZJKc7lejkO17DQgWYGwerOnPNM5moAtPiguMQS04RxWah2Hjs4d/PV+F0Mf0XKlcH0aoKDLKbDoV4+nH5wnPzKG1oCI/y3x0TAEjcEL8bxNWV8vPw8qlDq/7Fs6NAHXdBFlUeEssdqvPTDUfQjQ0NFKeqGBN4g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346901; c=relaxed/simple;
	bh=s/5ioRHdOVB8lfvUlxRptNQO1qRPc7ya0sOKC6AVVi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjq6YqJb65RY7jqetjLb/BzWKc3LoazLpsjuXKTH51vHaC3NiwN1Dhmzk/ZMbN3e5uWjmxEXjLtttDCOARIjeRQBJRlyzKnZVkEFfgIv9dUnEcPFXjHTWLaE5B8NAO8DtI7WaJgJKL4dxCQGBUSqkh6e0/zS1YT7XsqDK7Db7Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkV57gPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkV57gPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A108C4CEF7;
	Thu, 12 Mar 2026 20:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346901;
	bh=s/5ioRHdOVB8lfvUlxRptNQO1qRPc7ya0sOKC6AVVi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkV57gPD5cG+0FEDunWxCzaSAtCx64gX+hVZ7G2DBIV9bAHqxfAI8M+KgGCKyifrx
	 5peDc55FN3R955aqJn2BaC+eEefFIl9vw1O2XVTJ2XSZATwi5b1SkZpGfoS7hclf2W
	 mo9gdKHdL1Gq7dGqbbBZVWgNjSU/zErs9pD7znAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lewis Mason <lewis@ocuru.co.uk>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/265] ALSA: hda/realtek: Add quirk for Samsung Galaxy Book3 Pro 360 (NP965QFG)
Date: Thu, 12 Mar 2026 21:08:30 +0100
Message-ID: <20260312201022.688712299@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lewis Mason <mason8110@gmail.com>

[ Upstream commit 3a6b7dc431aab90744e973254604855e654294ae ]

The Samsung Galaxy Book3 Pro 360 NP965QFG (subsystem ID 0x144d:0xc1cb)
uses the same Realtek ALC298 codec and amplifier configuration as the
NP960QFG (0x144d:0xc1ca). Apply the same ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS
fixup to enable the internal speakers.

Cc: stable@vger.kernel.org
Signed-off-by: Lewis Mason <lewis@ocuru.co.uk>
Link: https://patch.msgid.link/20260210231337.7265-1-lewis@ocuru.co.uk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e321428225f9b..c13def0f1e1a4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11295,6 +11295,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc872, "Samsung Galaxy Book2 Pro (NP950XEE)", ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc886, "Samsung Galaxy Book3 Pro (NP964XFG)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1ca, "Samsung Galaxy Book3 Pro 360 (NP960QFG)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
+	SND_PCI_QUIRK(0x144d, 0xc1cb, "Samsung Galaxy Book3 Pro 360 (NP965QFG)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1cc, "Samsung Galaxy Book3 Ultra (NT960XFH)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x1458, 0x900e, "Gigabyte G5 KF5 (2023)", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
-- 
2.51.0



