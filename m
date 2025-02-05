Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F72A14F9FD;
	Wed,  5 Feb 2025 13:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763984; cv=none; b=WT88YIpygIfWRqYLhcMOngyK9ddmv6crQ1vgVYW+H31ysDKBH+EaPm+qdveMr/E/E3pbdlQS9lkDHSROAkr0ztrv0zeQlBrXaPltbPJkEPD9MYBbtENSDUEbVXRatjsALZh5unTYeGSNxguzEYRS1Ju79bSwiifD6Ivh0lyZM5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763984; c=relaxed/simple;
	bh=tnvBgbAE1YAfdyzV55hmcArgPZ8o1Op72lb8hjKKNU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRRbgnEtwGNKAQVVKTLtpG4XlVw/ND2wmoisma4D4NGDMROwuo/cl2nD9BSk5NFyxuc0aQJ4BfvzV5WtJjH1zEoSoAUXjeQSaqaUN66s2GsxjyT7b4wDF53al1MaoUGJXXtGLOQ8B759NOVPq+nxlFeORd0syZEdFXOf1M4171k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2mhT691; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2mhT691"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F531C4CED1;
	Wed,  5 Feb 2025 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763983;
	bh=tnvBgbAE1YAfdyzV55hmcArgPZ8o1Op72lb8hjKKNU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2mhT691/lqjo5qajY/wbY8E/3qFTxjG2CkbXbK/5EPQXpBHeEZPGkIN4RUMwgaGn
	 +Yxbwo8sNfKMJmoB9xq4dICMgjq7fBfD72tw4/+qCTVwvZynMaZsS2wXmvL9h9l1Q8
	 xns/pdWFLVOIWEqAtSE7J8tdt6XZhjSx+IKsfKLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shengyu Qu <wiagn233@outlook.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/393] wifi: mt76: mt7996: fix register mapping
Date: Wed,  5 Feb 2025 14:40:44 +0100
Message-ID: <20250205134425.076024052@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit d07ecb4f7070e84de49e8fa4e5a83dd52716d805 ]

Bypass the entry when ofs is equal to dev->reg.map[i].size.
Without this patch, it would get incorrect register mapping when the CR
address is located at the boundary of an entry.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shengyu Qu <wiagn233@outlook.com>
Link: https://patch.msgid.link/OSZPR01MB84344FEFF53004B5CF40BCC198132@OSZPR01MB8434.jpnprd01.prod.outlook.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index e75becadc2e54..f0fa0f513be90 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -119,7 +119,7 @@ static u32 __mt7996_reg_addr(struct mt7996_dev *dev, u32 addr)
 			continue;
 
 		ofs = addr - dev->reg.map[i].phys;
-		if (ofs > dev->reg.map[i].size)
+		if (ofs >= dev->reg.map[i].size)
 			continue;
 
 		return dev->reg.map[i].mapped + ofs;
-- 
2.39.5



