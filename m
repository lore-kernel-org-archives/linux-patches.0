Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338931E485;
	Tue,  8 Oct 2024 12:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389765; cv=none; b=YNFAk8XjkZ1rbdH0oVkjdw1Yf6FvnewdvY4rCIbbytYn9+m/Fv+dCvGZv53oCvfCmD+VT21uBpQ+eWFg6SJOLXqigsPKrHmO5j9FqRvovVlG1r7tCuxwCVkH0cvdb6QmkejCNNce8/LpPJqDMWFTCsNPiHST1nosAHXCEHIBHjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389765; c=relaxed/simple;
	bh=fOLA3k/MTyTaxRyoV30nAk2tHTgDxM9kXt+iuBRUyMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nq65cBbsWt2hC50f8abOMdnqDQ4UlBlsVM7nbjmenRRB65z95DXWFrC9gvuPpDBJNi6VtAk6r4hS93xAB8dPzuBNhmQzmDuRGubrqHAYH4thguHCDvj/sNSlMyDLtVS0d+uwC91ClVKBrTQzciTyOVsKAPVEJLN+y4KZHipfEkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXjeQ0gd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXjeQ0gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968D8C4CEC7;
	Tue,  8 Oct 2024 12:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389765;
	bh=fOLA3k/MTyTaxRyoV30nAk2tHTgDxM9kXt+iuBRUyMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXjeQ0gddGnE6yfdkYhoB2s5Tgvk0tX5RPxm2EeeBxE0xUj/wMBTdXT4vRytiaeL4
	 UD25Z5MkyPftLmvHWbdwGivlNkmRTnGpz5ubsH/LlE//f0XHGfUpkvYXZp6RlprbnY
	 kuW3O83mFI+vnHExnVa1zXfY7fowE3BORr+XlOwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oder Chiou <oder_chiou@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 058/482] ALSA: hda/realtek: Fix the push button function for the ALC257
Date: Tue,  8 Oct 2024 14:02:01 +0200
Message-ID: <20241008115650.590482124@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit 05df9732a0894846c46d0062d4af535c5002799d ]

The headset push button cannot work properly in case of the ALC257.
This patch reverted the previous commit to correct the side effect.

Fixes: ef9718b3d54e ("ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7")
Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Link: https://patch.msgid.link/20240930105039.3473266-1-oder_chiou@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2b674691ce4b6..64efa6123d839 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -583,6 +583,7 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x10ec0257:
 	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0285:
-- 
2.43.0



