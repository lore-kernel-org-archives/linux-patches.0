Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560031E500C;
	Tue, 12 Aug 2025 18:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023794; cv=none; b=TUJJQh8EQwOueCMpirZINvP2vIQGNpcdvQr2yi6sU4zBUiYuZFUtjEgaO9jwZKb+0WOr1Zs/+U0/PwooXEXv+cLS9LDYqjrE9oeRCat2Jg8qWwDcZyUmRPr8EafPcM010ZPoKElr+RFawOxd3wEfvFODNmyw+HOu/e2LHvf9aGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023794; c=relaxed/simple;
	bh=NxY9qPfk8zrfXmbEjdXSzSInXoPTAJAcRFSW/wE6y8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8HqCmWzPxQaOfoW0f4vfzAzEQEToksqtwnsXsAqsvqJTrmxwINH0xBcZhauL4HrqtoFJ39yD/8kxBGXyATUycNJlI+VSwTVCElCCo/adBW0KK9nV+non++hK59+7ug7ofrTD7u8wDWvOZlDFLIhnr4oOYLzx39LSJufa59aKjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ks+6Dai2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ks+6Dai2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73DDC4CEF0;
	Tue, 12 Aug 2025 18:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023794;
	bh=NxY9qPfk8zrfXmbEjdXSzSInXoPTAJAcRFSW/wE6y8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ks+6Dai2OAc4FL7H3JwuwFpVEIQdqyc1Dw2jvoLmPSiVve0tR/l+CnEJoNg53nPnA
	 b/ks7NA+QunB9ge21/Xwq7lyuw6hxd03yyb3+GgnTOblX0ypTGxa9BK2uKgNUxroRp
	 Zyl2GRcZh21L3WCosnfV51aBJalTBiMNp5pu9Tcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 184/627] wifi: mt76: mt7996: Fix secondary link lookup in mt7996_mcu_sta_mld_setup_tlv()
Date: Tue, 12 Aug 2025 19:27:59 +0200
Message-ID: <20250812173426.282571796@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit e8d7eef07199887161cd6f3c062406628781f8b6 ]

Use proper link_id value for secondary link lookup in
mt7996_mcu_sta_mld_setup_tlv routine.

Fixes: 00cef41d9d8f5 ("wifi: mt76: mt7996: Add mt7996_mcu_sta_mld_setup_tlv() and mt7996_mcu_sta_eht_mld_tlv()")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250704-mt7996-mlo-fixes-v1-2-356456c73f43@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 994526c65bfc..dd4b7b8c34ea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2326,8 +2326,7 @@ mt7996_mcu_sta_mld_setup_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 
 	if (nlinks > 1) {
 		link_id = __ffs(links & ~BIT(msta->deflink_id));
-		msta_link = mt76_dereference(msta->link[msta->deflink_id],
-					     &dev->mt76);
+		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
 		if (!msta_link)
 			return;
 	}
-- 
2.39.5



