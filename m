Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962BA199237;
	Thu,  6 Jun 2024 14:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683187; cv=none; b=UgUbKUW3JAYjlmV2/n47THSntq/I04wWe9KNyUksL6c+WxxJRGBBNiRGT2yWrB03U79ARHoSvCEkIBa9aN074qrEV8/JP0SpkDaZOrx4r+XNMkmhsdZlZnCbDuM0rzn2zSlzaKkwlVcXTwEwqhLSSqWvw9M+kMkk94DuXNFwP1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683187; c=relaxed/simple;
	bh=VNbSQQ1/2CtS+AOOfhhKXYZHu1envVop4N334ZdAEMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1ZdPTx/GXxPTioxSMZhLVYdW98qU5lzxlcHMWDGqi28pPaEaaKxSDgHqxS6OmtjKb/poEV9uqDj0/fJhavoYdF2yAmO8lydo4l+zQCdsdQWEVyY5/j8uwdj8KyB0sy/uJ1LWMa6IVEJpVV2NV0LAuGWL6EViGc8GzkbGxUqkGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=magY3mFW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="magY3mFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8C7C2BD10;
	Thu,  6 Jun 2024 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683187;
	bh=VNbSQQ1/2CtS+AOOfhhKXYZHu1envVop4N334ZdAEMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=magY3mFWIvzssgZpFfV/eK6HihDPlDVCQf4zHv65ls1X7QzoavmQaxYFOLb+/VAcI
	 GOLX262RmNfX2QsDL4aHLxrHRRN5uWni0w98BNmf/qUyk+TBXgDe6W/7LDZQNM2blA
	 iUL2aTSP3PJgNPhkF4+r/q+fMEXd2aL+8vrEgJAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/744] wifi: mt76: mt7915: workaround too long expansion sparse warnings
Date: Thu,  6 Jun 2024 15:56:43 +0200
Message-ID: <20240606131736.631029287@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 2d5cde1143eca31c72547dfd589702c6b4a7e684 ]

Fix the following sparse warnings:

drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c:1133:29: error: too long token expansion
drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c:1133:29: error: too long token expansion
drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c:1133:29: error: too long token expansion
drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c:1133:29: error: too long token expansion

No functional changes, compile tested only.

Fixes: e3296759f347 ("wifi: mt76: mt7915: enable per bandwidth power limit support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/5457b92e41909dd75ab3db7a0e9ec372b917a386.1710858172.git.lorenzo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 6c3696c8c7002..450f4d221184b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -1049,6 +1049,7 @@ static ssize_t
 mt7915_rate_txpower_set(struct file *file, const char __user *user_buf,
 			size_t count, loff_t *ppos)
 {
+	int i, ret, pwr, pwr160 = 0, pwr80 = 0, pwr40 = 0, pwr20 = 0;
 	struct mt7915_phy *phy = file->private_data;
 	struct mt7915_dev *dev = phy->dev;
 	struct mt76_phy *mphy = phy->mt76;
@@ -1057,7 +1058,6 @@ mt7915_rate_txpower_set(struct file *file, const char __user *user_buf,
 		.band_idx = phy->mt76->band_idx,
 	};
 	char buf[100];
-	int i, ret, pwr160 = 0, pwr80 = 0, pwr40 = 0, pwr20 = 0;
 	enum mac80211_rx_encoding mode;
 	u32 offs = 0, len = 0;
 
@@ -1130,8 +1130,8 @@ mt7915_rate_txpower_set(struct file *file, const char __user *user_buf,
 	if (ret)
 		goto out;
 
-	mphy->txpower_cur = max(mphy->txpower_cur,
-				max(pwr160, max(pwr80, max(pwr40, pwr20))));
+	pwr = max3(pwr80, pwr40, pwr20);
+	mphy->txpower_cur = max3(mphy->txpower_cur, pwr160, pwr);
 out:
 	mutex_unlock(&dev->mt76.mutex);
 
-- 
2.43.0



