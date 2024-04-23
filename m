Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78301144D0D;
	Tue, 23 Apr 2024 21:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908496; cv=none; b=r12AeryHmwHQELLfyrxZ9OBrNkkKb03/PHjw06zBky9ref4Ud64ShblL906bk/EfQ79u44P8iu1uff7eN05XUfJEKJJfI2isbJ/xOqn0YVQDqF+bE+FofjHqeunh6POKPdLty+pqCwf/uyO+Im1P9QePlIiX0dHiU01TeAP44N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908496; c=relaxed/simple;
	bh=2Qv738hF7mYg/PS+doPkQwHk0h7Vpwg0dj1T/AgBeO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVvOoCDe3PFRxVOFQr2QwkCPWM+2ku+kLUQgwNLjN2IC7hfoc1W66ajPqaJmz4ZnVH+bUIdh0LMxrSimK064+Ms9Nu8gJ9SeXzhXiESOzj04FvDgWQpkTXF8OPNaIM9YuSoGQThuYVY8ZyQSB4GIz9aDedTs6e2XkiqrOgO3Nbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZeDo4PWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeDo4PWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E531C4AF0B;
	Tue, 23 Apr 2024 21:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908496;
	bh=2Qv738hF7mYg/PS+doPkQwHk0h7Vpwg0dj1T/AgBeO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeDo4PWSO50+/loMxG8cbGaZ9kWsmbyLHYTh4NwqHL5q98yD1tf1FxRGDA3Z4Vs5w
	 rhvhisTm7zeq+4GQYvs6bwSywtc9XpjJH6/f9u8u+nUp+HRnEaOhYQpa3kNvEcPv6+
	 bATlNyKjiMy0WHss0d6BYyVwba4oyvxc6vaK97F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huayu Zhang <zhanghuayu1233@qq.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 073/158] ALSA: hda/realtek: Fix volumn control of ThinkBook 16P Gen4
Date: Tue, 23 Apr 2024 14:38:15 -0700
Message-ID: <20240423213858.333205328@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huayu Zhang <zhanghuayu1233@qq.com>

[ Upstream commit dca5f4dfa925b51becee65031869e917e6229620 ]

change HDA & AMP configuration from ALC287_FIXUP_CS35L41_I2C_2 to
ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD for ThinkBook 16P Gen4
models to fix volumn control issue (cannot fully mute).

Signed-off-by: Huayu Zhang <zhanghuayu1233@qq.com>
Fixes: 6214e24cae9b ("ALSA: hda/realtek: Add quirks for Lenovo Thinkbook 16P laptops")
Message-ID: <tencent_37EB880C5E5BD99D21C16B288115C4545F06@qq.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8c2467ed127ee..a57f5a02b498d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10381,8 +10381,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3886, "Y780 VECO DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38a7, "Y780P AMD YG dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38a8, "Y780P AMD VECO dual", ALC287_FIXUP_TAS2781_I2C),
-	SND_PCI_QUIRK(0x17aa, 0x38a9, "Thinkbook 16P", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x17aa, 0x38ab, "Thinkbook 16P", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x17aa, 0x38a9, "Thinkbook 16P", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
+	SND_PCI_QUIRK(0x17aa, 0x38ab, "Thinkbook 16P", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38b4, "Legion Slim 7 16IRH8", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38b5, "Legion Slim 7 16IRH8", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38b6, "Legion Slim 7 16APH8", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.43.0



