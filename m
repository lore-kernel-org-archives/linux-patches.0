Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88398C13D;
	Thu, 30 Jan 2025 14:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245639; cv=none; b=diBGpBG8+k7Mm30emcpbGsjvgrCx/RKmWirUm1tgVrQY3nlVEM1J838ByDAKEoCyX3V3VanP4Ky8omi1yIfvR11k2Iihv6U+9DTWks/EKN06zxZYHMnVQUpfajw+cVasHCjue7dKzLsVGBsc0Y7WeJXTdQ/IB9WWhEP7fYs2Pgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245639; c=relaxed/simple;
	bh=PV1ekjZx1T7hH3REmmPLemaUcRL5Ny4hoI6tmValFkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nfq05L3UNnFq13icvlMtWYdDYMAA9kGGvqv3ulC/kHLxTMhFjKQFns/g5K1m/xuIJk7jfxN6Ejr0iKDk361s/uDKyZSQf/9TM5Q3wMzrD8bjY5F91y4UGngXqYwmLgoUuRucgJ9xNaf7NOvWfLiKn6/zCCmjkB9MYSHYINcmCQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkAIxP7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkAIxP7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941B7C4CED2;
	Thu, 30 Jan 2025 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245639;
	bh=PV1ekjZx1T7hH3REmmPLemaUcRL5Ny4hoI6tmValFkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkAIxP7bCjsw6SXIhODiigDUFSgJUFWqT8T4wR+q/e3mUuatwGb7hMsFrUrv1WmYj
	 u6rqpC22gusJakL2sDoIC6U5LaY3FWiHt1g3AremjoKFtGYu70RGom9duF/Z79AuBJ
	 zRZNbEuQ8ZWqMgXJHsGcVijfTjIYqb4e9gkAdpO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yage Geng <icoderdev@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 10/40] ALSA: hda/realtek: Fix volume adjustment issue on Lenovo ThinkBook 16P Gen5
Date: Thu, 30 Jan 2025 14:59:10 +0100
Message-ID: <20250130133500.123290733@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

From: Yage Geng <icoderdev@gmail.com>

[ Upstream commit 34c8e74cd6667ef5da90d448a1af702c4b873bd3 ]

This patch fixes the volume adjustment issue on the Lenovo ThinkBook 16P Gen5
by applying the necessary quirk configuration for the Realtek ALC287 codec.

The issue was caused by incorrect configuration in the driver,
which prevented proper volume control on certain systems.

Signed-off-by: Yage Geng <icoderdev@gmail.com>
Link: https://patch.msgid.link/20250113085208.15351-1-icoderdev@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a9f6138b59b0c..8c4de5a253add 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10916,8 +10916,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38e0, "Yoga Y990 Intel VECO Dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38f8, "Yoga Book 9i", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38df, "Y990 YG DUAL", ALC287_FIXUP_TAS2781_I2C),
-	SND_PCI_QUIRK(0x17aa, 0x38f9, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x17aa, 0x38f9, "Thinkbook 16P Gen5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
+	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38fd, "ThinkBook plus Gen5 Hybrid", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
-- 
2.39.5



