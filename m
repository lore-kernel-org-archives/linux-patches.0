Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA28E335BA0;
	Mon, 18 Aug 2025 13:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524279; cv=none; b=U8657OWBxfLkUQEATVuKlIvg3A5QmHeTu8GOuhYiZM5Wrk4KxqVjdB8uQZAJlF/yl/NFvH+qNOjp805IyN4i7pv9rbQ5xsMPIyfSCqL3PCBQBVySWwOv72mBynkU3wy6YJdA245NpfuN2VB1tOUm+BVi0VTwuZk8SNSQ+VP8hbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524279; c=relaxed/simple;
	bh=rC1THRWytBpp0zgwclt4MmZFnUXwdLTXUa0TF9Tj2kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfkGSgqgfEAFnbXbSSyxj20f/j5HcFLfpV5Mokz9Cb/1Erkk6+4wKKl7L7Y3oW8t6hqGMzxgBOlztOPTkubQbs1GAth3KOFK5F0n9TS71yUu8/yK8Gt/RNvnhT7MqDft+EzXTdLma00/rvZO17g0nnV2Pvi+nBZy40fc5sS7sas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YF5QxNqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YF5QxNqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39628C113D0;
	Mon, 18 Aug 2025 13:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524279;
	bh=rC1THRWytBpp0zgwclt4MmZFnUXwdLTXUa0TF9Tj2kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YF5QxNqAc3DIM+D8nL59rVnW2A1MNmSIKwJIeNKRvgP958IuafEZq0fxX7e3S+8FJ
	 bvPZ3uy7uzXGlbfsxcBoJPk988jfUO7WgEqEUlpvgRBaSqObN0ZjhV8oxvl7SZ88I5
	 cRortlhhTIzdCyZYvwkXuH4HOeC/IkROi5tAM6PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Croft <thomasmcft@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 423/515] ALSA: hda/realtek: add LG gram 16Z90R-A to alc269 fixup table
Date: Mon, 18 Aug 2025 14:46:49 +0200
Message-ID: <20250818124514.708189534@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Croft <thomasmcft@gmail.com>

[ Upstream commit dbe05428c4e54068a86e7e02405f3b30b1d2b3dd ]

Several months ago, Joshua Grisham submitted a patch [1]
for several ALC298 based sound cards.

The entry for the LG gram 16 in the alc269_fixup_tbl only matches the
Subsystem ID for the 16Z90R-Q and 16Z90R-K models [2]. My 16Z90R-A has a
different Subsystem ID [3]. I'm not sure why these IDs differ, but I
speculate it's due to the NVIDIA GPU included in the 16Z90R-A model that
isn't present in the other models.

I applied the patch to the latest Arch Linux kernel and the card was
initialized as expected.

[1]: https://lore.kernel.org/linux-sound/20240909193000.838815-1-josh@joshuagrisham.com/
[2]: https://linux-hardware.org/?id=pci:8086-51ca-1854-0488
[3]: https://linux-hardware.org/?id=pci:8086-51ca-1854-0489

Signed-off-by: Thomas Croft <thomasmcft@gmail.com>
Link: https://patch.msgid.link/20250804151457.134761-2-thomasmcft@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 71632790ca1d..1c421518570e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11376,6 +11376,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1854, 0x0440, "LG CQ6", ALC256_FIXUP_HEADPHONE_AMP_VOL),
 	SND_PCI_QUIRK(0x1854, 0x0441, "LG CQ6 AIO", ALC256_FIXUP_HEADPHONE_AMP_VOL),
 	SND_PCI_QUIRK(0x1854, 0x0488, "LG gram 16 (16Z90R)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
+	SND_PCI_QUIRK(0x1854, 0x0489, "LG gram 16 (16Z90R-A)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x1854, 0x048a, "LG gram 17 (17ZD90R)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.39.5



