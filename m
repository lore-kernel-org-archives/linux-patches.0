Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9CF26B95F;
	Tue,  8 Apr 2025 12:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116811; cv=none; b=R3OStm8B93Yf20Rso7BIW4Z/thXf+5PLBiw8LLVrhpU4Qh8mxrZZ33Vmx38m7dKz0DyoWa7HT4JOkrVyNHzkOW2BqnwkmVughPPTFM7syMXBYW1Kh8TVdul9V00cRCzr7CFv3lnyUKNd9J4afQmvw0Xt+x0ZijH0ZRoc9vaeJUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116811; c=relaxed/simple;
	bh=nTEi8E/iqDU6S4KzkKHHJpfB2utk5a8hbGYaQ9gTN08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAaTS5XzDLsyLjZPWR5sHE32rU4M5v55QlqUHO6GsxH6x6gxP5Q+QLnlglQeJSV/fUG3noK9+3S3U4cvRosQoPuGUcBN5zbDhwChtbpcZyz9F6JR8WYHiVIsNHQKpfNxiKBuG1qa2yz90gsJGCHxtYSc4+ivbU2ENhVfjrjDIzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeWlCDkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeWlCDkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF887C4CEEB;
	Tue,  8 Apr 2025 12:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116811;
	bh=nTEi8E/iqDU6S4KzkKHHJpfB2utk5a8hbGYaQ9gTN08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeWlCDkLHjde3TrMv700mfYcEjWUZjrQFRWnoMK5vFJUswrizry/w5zUimAFBzjlg
	 1b8r08Ce2WCLeF7y2ZBAU+4FRLi2e2d9ZfytYPKgPOlAHs20QKMRG81rt1qN9ywHJo
	 GxuxEYs4c5y1aOu7hOGVgl6z3XJlQX3Y5ThT7L2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 278/423] ALSA: hda/realtek: Add support for ASUS ROG Strix G614 Laptops using CS35L41 HDA
Date: Tue,  8 Apr 2025 12:50:04 +0200
Message-ID: <20250408104852.246666972@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 9120b2b4ad0dad2f6bbb6bcacd0456f806fda62d ]

Add support for ASUS G614PH/PM/PP and G614FH/FM/FP.

Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250305170714.755794-4-sbinding@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a960ef29a7036..6117aad97ba37 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10620,7 +10620,9 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8e1a, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
+	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x1043, 0x1074, "ASUS G614PH/PM/PP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10a4, "ASUS TP3407SA", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x10c0, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
-- 
2.39.5



