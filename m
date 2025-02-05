Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B312514A088;
	Wed,  5 Feb 2025 14:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765727; cv=none; b=og46fYOvN2RU/faFTiUqlx4rWz0bLnRx7KsvD2AFUKJQOe+Qz3JKOekLiajt6gzXd2FxcLBwKooQhPJ9gzp9ZV3S/zO0t7/v7bm2VSnYBKr8gDx9l/eJmuG1RgpfrVDK/7Vc0V15FFmfAxfVB4LwpF7g209n89R5k8mYORVOkrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765727; c=relaxed/simple;
	bh=Pdq5uKS02kvcZSZt7jsFFn5krRM2ISPS10L6P+FA4x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1eVsesw7z/NTlSikzJwiQufgh/udp9r1YtpeCuTzmzbQLPQLVDwMxsx4JTFPJp2BXI7ZIzPq94EKTyvWxGptrp34A0ay2qH2CY17aIVjVXGsDUJCGQYrZKjxlNWWGqipGlhMhLqNm2tarl2KTbHnjfYV1hgmAP+oPJsn3XgLuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URJogcdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URJogcdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239EBC4CED1;
	Wed,  5 Feb 2025 14:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765727;
	bh=Pdq5uKS02kvcZSZt7jsFFn5krRM2ISPS10L6P+FA4x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URJogcdO4MDfsO3f94vjVkUN8xwZExQo66LuoNfduvzDCMNlLFie1w/2vq/647F7n
	 DTwe9JT7ksG5m1AxQ0VFBfcGlPH3ndw4XU+GxO0idclu1CrElqvc7u1iNpG/gh4bcj
	 41hRxDS/NOzoOlIJKkuEmFRnzgpaMKNNqwODbuEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shengyu Qu <wiagn233@outlook.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 208/623] wifi: mt76: mt7996: fix register mapping
Date: Wed,  5 Feb 2025 14:39:10 +0100
Message-ID: <20250205134504.187397350@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 40e45fb2b6260..442f72450352b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -177,7 +177,7 @@ static u32 __mt7996_reg_addr(struct mt7996_dev *dev, u32 addr)
 			continue;
 
 		ofs = addr - dev->reg.map[i].phys;
-		if (ofs > dev->reg.map[i].size)
+		if (ofs >= dev->reg.map[i].size)
 			continue;
 
 		return dev->reg.map[i].mapped + ofs;
-- 
2.39.5



