Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9253829B8D3;
	Wed, 20 May 2026 16:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294659; cv=none; b=E3vUUwjvRDnumOLsQsHHO26Ht4Qi7KE8nL5Swt7JazkBGld2lzTSYF0SnqGEKaTlOPe6ceRMQHMBUrx5wEcPDvYfvb7ly6TMTx/dHGD3lw1kQN7EblkqEgtxLds9RPpubPRvFVQ+xYdL5nW7CgMjIeouOmANuXJzmRHTkV2eZOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294659; c=relaxed/simple;
	bh=g8YRqMM5EXLl8yylDsE0SFf8xO9O1Rn+SuDF1VfI5k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1XD9JD80tIf7gFm8dJ5bXnvdlciSdKUxWQAi/PdcpKO/NTEI9Pb3WT/KyjA/0N9+eR3AtGG9APTvm3ZxDQTmC5skhRj/e3KnXId6DTQIKgZpjdt/T64gG+sYblZrjRKLPN75+kHaSBEaIHOGU0MlmDQDOKnwXvAhhaXAJYUqns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rP/UgVEM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rP/UgVEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046E91F000E9;
	Wed, 20 May 2026 16:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294658;
	bh=bKZKNGKz18h5VqJWdr1R2LpVdt5nraWM9qYF64WZVnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rP/UgVEMzri/eRCKZshaMZ2J2ABMrx+ym9adK+sSiiPFf8xakNB7ZYhK1lx2jQiCs
	 pT/SBIKc6rCx5e8hZn3DsrP/0ek9Zeg7FiAoLgNZqNq54QcAPXkLbmiDIrF+L0Z26P
	 UrSBkxkd9AEtblDIVAS5sOUIUisZMHEH9VVJQLv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0121/1146] wifi: mt76: mt7996: fix struct mt7996_mcu_uni_event
Date: Wed, 20 May 2026 18:06:11 +0200
Message-ID: <20260520162151.071317731@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit efbd5bf395f4e6b45a87f3835d4c2e28170c77c5 ]

The cid field is defined as a two-byte value in the firmware.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20260203155532.1098290-2-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 81893ef944aef..20ade7ae7da95 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -233,7 +233,7 @@ mt7996_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		event = (struct mt7996_mcu_uni_event *)skb->data;
 		ret = le32_to_cpu(event->status);
 		/* skip invalid event */
-		if (mcu_cmd != event->cid)
+		if (mcu_cmd != le16_to_cpu(event->cid))
 			ret = -EAGAIN;
 	} else {
 		skb_pull(skb, sizeof(struct mt7996_mcu_rxd));
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index 647f39b7dab52..f87a8d316f17d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -25,8 +25,8 @@ struct mt7996_mcu_rxd {
 };
 
 struct mt7996_mcu_uni_event {
-	u8 cid;
-	u8 __rsv[3];
+	__le16 cid;
+	u8 __rsv[2];
 	__le32 status; /* 0: success, others: fail */
 } __packed;
 
-- 
2.53.0



