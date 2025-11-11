Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972A725F797;
	Tue, 11 Nov 2025 01:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824816; cv=none; b=kGFdhwkwk86keSojuRaypW0+T7tL4eRwJTUECOdcD/prps4uYmh3IS1jcrz8miherD5LpQagUw4CNiA5nVIzOhcd6nnPGT/2tFExLFzJ1+WlSWLTlvBGKFkVjisW4egeMqHWYn8p4vEJO8KREEQ0nnTxE+AR4V1VkYETNJx3D9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824816; c=relaxed/simple;
	bh=Oo0aXP6R45i9LaB3I9rtLDp9jio4r+uCVYsImVSCenc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qS25IGorTKLsOYg1Ge4zwmbzjWRRzwh/Izo0egZm/vz1CXOUR/muilyWl7tQX3Q+PhX1LJMLUtNfpHSRv5/d4kFlxkKuBti68heRmQumtSIjg3kLQeaWU9uzUJJ+7MFn1cKiPpX2O5BPO3CwghKWyl3X3Q+8mf3PlnZuf/j4OJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTWQ7oKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTWQ7oKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3652CC113D0;
	Tue, 11 Nov 2025 01:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824816;
	bh=Oo0aXP6R45i9LaB3I9rtLDp9jio4r+uCVYsImVSCenc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTWQ7oKjX55DBx1ZhhAgGBnBtR6yIFZc9v8mn3I3gIn6tErs1Lp5gl+F3y9u0DC/S
	 ipu3pjCZha/RV0woUAa2XU+htbGFav5L/Q1g2c4uSU8+VACiZN6/gdPYEGTTEA3kf/
	 9R0jO5f8TXHial9j4jhYt2Ur5MyhgkYIlJTIA+SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 539/849] wifi: mt76: mt7996: Set def_wcid pointer in mt7996_mac_sta_init_link()
Date: Tue, 11 Nov 2025 09:41:49 +0900
Message-ID: <20251111004549.446262138@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit a70b5903c57308fff525cbd62654f6104aa7ecbf ]

In order to get the ieee80211_sta pointer from wcid struct for a MLO
client, set def_wcid pointer in mt7996_mac_sta_init_link routine.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Tested-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Link: https://patch.msgid.link/20250731-mt7996-mlo-devel-v1-1-7ff4094285d0@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index d01b5778da20e..4693d376e64ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -969,6 +969,7 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	msta_link->wcid.sta = 1;
 	msta_link->wcid.idx = idx;
 	msta_link->wcid.link_id = link_id;
+	msta_link->wcid.def_wcid = &msta->deflink.wcid;
 
 	ewma_avg_signal_init(&msta_link->avg_ack_signal);
 	ewma_signal_init(&msta_link->wcid.rssi);
-- 
2.51.0



