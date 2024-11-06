Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16C51DED62;
	Wed,  6 Nov 2024 12:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895515; cv=none; b=ohuSnoVZIiA/5o4aKcsX2CG4Uzpks1BaHa5lwsstHf35NI4eKe0TRxAQuWNzeskd4JW8+tYAIsp+OEVjy0LmT1VvNsHPGmgVTzcO97j68D/CGWWSfFMsALLdl7j7tLxcfKULudJrt65QKjD4vTsWTLOGrqf9xNLyyeDqkQEJIXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895515; c=relaxed/simple;
	bh=MD6t0kWmlZDjTy2flTtltdxANNoH8FpacoAwqoldjUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rQSDEt1KQVuFeQDIvRweWO5K+pYs8TbAMxXblftltCsxztNpoTM9rFrZhvKXI6x8lftmA8cP8pwn1AjhkT6968FA7EnFVI78S8INQvIQu1e9/Wh16jfUh45H+bl8ZAx6BP9quMaW8FBW2Rv1Ioai4y2RGBUGlM0BS6axA8krJIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSu3hYP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSu3hYP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02554C4CECD;
	Wed,  6 Nov 2024 12:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895514;
	bh=MD6t0kWmlZDjTy2flTtltdxANNoH8FpacoAwqoldjUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSu3hYP87un4FVyRqIJWSBA2piyGuXHIAWUeU5TCipmfxEbRYH/JggbsM2cRVbxQR
	 3T8Y4dyF6txPapycYCEVHDy1d5ckRTfTQApYapR6m0u64DceA8Ay999hpCqX6OlgB/
	 rdFU00WXS/5ua7feQbDO6eTyWe2ZV4H9pjsxCmaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdravko delineshev <delineshev@outlook.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 242/350] PCI: Mark Creative Labs EMU20k2 INTx masking as broken
Date: Wed,  6 Nov 2024 13:02:50 +0100
Message-ID: <20241106120326.917938452@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 2910306655a7072640021563ec9501bfa67f0cb1 ]

Per user reports, the Creative Labs EMU20k2 (Sound Blaster X-Fi
Titanium Series) generates spurious interrupts when used with
vfio-pci unless DisINTx masking support is disabled.

Thus, quirk the device to mark INTx masking as broken.

Closes: https://lore.kernel.org/all/VI1PR10MB8207C507DB5420AB4C7281E0DB9A2@VI1PR10MB8207.EURPRD10.PROD.OUTLOOK.COM
Link: https://lore.kernel.org/linux-pci/20240912215331.839220-1-alex.williamson@redhat.com
Reported-by: zdravko delineshev <delineshev@outlook.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index bb51820890965..e496670d7994e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3347,6 +3347,8 @@ DECLARE_PCI_FIXUP_FINAL(0x1814, 0x0601, /* Ralink RT2800 802.11n PCI */
 			quirk_broken_intx_masking);
 DECLARE_PCI_FIXUP_FINAL(0x1b7c, 0x0004, /* Ceton InfiniTV4 */
 			quirk_broken_intx_masking);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CREATIVE, PCI_DEVICE_ID_CREATIVE_20K2,
+			quirk_broken_intx_masking);
 
 /*
  * Realtek RTL8169 PCI Gigabit Ethernet Controller (rev 10)
-- 
2.43.0



