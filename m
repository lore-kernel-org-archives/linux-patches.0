Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8582A29A1;
	Tue, 17 Feb 2026 20:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361632; cv=none; b=YcgPEjt17cKZmBvOOnaD1hq5jQa0O1g8aot22oqGsXTGjateTuniXDEGTqKZUjaAaJc44cBzPIpB8qJlqJje+tMWTRVmTPosetPlBwBfEAF0RgAphcqXiY2DDCsAozIhBKu++0t7PY8CszOLIjko4motLBf8uHFdfvU8yoAdKwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361632; c=relaxed/simple;
	bh=2jJt2EEizJfEdKD5tViTGW9Gq7z9YdWU4fHLbsrQSEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSr4VJkNTXMlt9BLuPYQ4fqOi3j41gxhQASPcucjoCLDImW6HFeqjkxmOz6J96MtVbYkSPjXqmqeOGBZqi0ea3UUJKJ54XzUoss0M/u9oscg0cLe4mqRDOvOJRi+dfrBypGQ4UcJ8XZjlQY/BVMDw63O8bYdzKGRksned4esKu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clzzH7aA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clzzH7aA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED672C4CEF7;
	Tue, 17 Feb 2026 20:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361632;
	bh=2jJt2EEizJfEdKD5tViTGW9Gq7z9YdWU4fHLbsrQSEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clzzH7aArlfJr5UKtgyBjLm3HigdmN+7mRYIpSJXF54vTH4rDZ2Iz5ccpmiljRwiH
	 i9pRRWWb8uEs734Y3wGlgPjDgQu50+u0NZLrssJ9P4vq0OFQ6zXH5PirxpF09ccJlT
	 jL73Ftwg4DXETZYi3CB0f1JO67vzThJhYOxbmodM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 09/42] ALSA: hda/realtek: Add quirk for Inspur S14-G1
Date: Tue, 17 Feb 2026 21:32:00 +0100
Message-ID: <20260217200006.364408465@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 9e18920e783d0bcd4c127a7adc66565243ab9655 ]

Inspur S14-G1 is equipped with ALC256.
Enable "power saving mode" and Enable "headset jack mode".

Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260126073508.3897461-2-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2bdad4e518032..d9c3d1443a956 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11379,6 +11379,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1ee7, 0x2078, "HONOR BRB-X M1010", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x2039, 0x0001, "Inspur S14-G1", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
-- 
2.51.0



