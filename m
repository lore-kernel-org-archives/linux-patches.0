Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019012;
	b=FsZ9nedtHjBEVLkP/mkEMdGWpHYSSXOOYLkYlTNi+qgKDwTghNVTaItVCsR8YbCeHmsh
	 QtSmMxBhK3frdIL3o2TUZ+shYLD8MACFlYW0VIh7sWBXb6Xjhr2/24zo74BwiZxQJIVr4
	 SFeatk4G6Gh3N56aSy7gulCL8DaGIz05G0QkNhsLpLSUvzzcAc/xWGMJ0wwtbvOrG53Xy
	 ScZpkI7T7oBL4wQry+ZqiHaFSDxJpDxtrRFp8B8I4anRDm1OK9+6t2x/FOv/ocJk/dVgE
	 UMhCFp5VS2kmTVCXsE/vgOUErS0xclPV2/+K6ap4vM9mukpIusN1ToB9CqU2Q0BBYXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9+BUZcMlik07hz19KglBu2aZy19CRap5fxJ9SMGpOQQ=;
	b=TbRTXbae9cokH0glH7G/7cwdNGTnzeHZW9vAse2bdchXYCtu5/GoEOT/X4RccdIEw2yX
	 uUGZrhSnc+pc15tIav4FiIkdw6+iaHgFV3PHrCzPZ6SogCHuz8nWWPz1sUMqUiJGKd6tb
	 0RbC6CO9hipnu+ZZB9jgdyBe9PRJralzBynzBcwVSvrlLS/6VYYirvEPmUwuAt4VyGrBf
	 NkuVx7QkSsTGUKPcHGOWWwxXF03Cn7JGq1AIkQNIf8WJ3DggBMBUB718QpiC3JRjJiWKm
	 zoHSuoQ9jKpTKQF5cseZEPeZJbEL+JW55p61c2s2fCgxXmXEV9o4a2wY5KvV6he87uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rN+b5z08;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1E9606A325;
	Wed, 18 Nov 2026 16:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rN+b5z08
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBE81F000D0;
	Wed, 18 Nov 2026 16:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019012;
	bh=9+BUZcMlik07hz19KglBu2aZy19CRap5fxJ9SMGpOQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rN+b5z08n+cXl2ZGMxy1x3Al/+QdNboAfcRHWvFfg73p+aO4QPr+4o6zkUUsrOzpt
	 HtFxbkMR0XAJunh5z86i5oKq4Ht8S9T3uAHb4l/8uV7joMC03SqVRjiXoLRWFfl6OY
	 xCHhQ91dcMBRswuOa8fOAdmNcGKPZ10ZxrdtjrCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1437/2651] wifi: mt76: mt7925: restore the reset state when fw_pmctrl fails
Date: Wed, 18 Nov 2026 15:44:37 +0100
Message-ID: <20261118150339.787089486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 8d2f5990cd429a2fe5fff05f7acf84d6799d4324 ]

mt7925e_mac_reset() returns directly when mt792xe_mcu_fw_pmctrl()
fails, leaving MT76_RESET set and the TX worker parked. Every other
error path jumps to out, which clears both. mt7925_mac_reset_work()
clears neither, so once every reset attempt fails there, TX stays
blocked until another reset succeeds.

Jump to out instead.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Link: https://patch.msgid.link/20260827162115.1449757-1-nbd@nbd.name
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index 280797fa0d85f..67eb86746779d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -127,7 +127,7 @@ int mt7925e_mac_reset(struct mt792x_dev *dev)
 
 	err = mt792xe_mcu_fw_pmctrl(dev);
 	if (err)
-		return err;
+		goto out;
 
 	err = __mt792xe_mcu_drv_pmctrl(dev);
 	if (err)
-- 
2.53.0



