Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657911F3FF8;
	Mon, 23 Jun 2025 21:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713390; cv=none; b=IMDkz0iJnIuzq05e1zznDSBVds9Ne5v3WpNnPcQ24AajoepmqPKGkDCnywtZGhJhO02rmznXij5y9/vitx8t5jZ7pQZeyZwxPATrY8hA+Iv/TOAUBM/cDExdQbPR1x8XSDQLXqymuD0ik2yocOl9ri2Jp8VF0CD/jsvgiaasL4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713390; c=relaxed/simple;
	bh=HL2Kie3c4orsmGjaCUDzkozNDCrS5KGaUfDFx/NxBF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mL0xUyTprytYQQ8YShCJ3AI84+S4GnE5rlyKn/wOnYL6iUPg/eJFJ5tImImQfGasqqiJla5DW0C9fLDfFYl5eKerVOCMnf2q2t+XiCpGTixm90weBIFTwBZx+id8gmbMeeY0g+wLNo/vsR9uTKo1QOlRCAif37QwLCHTlBHcfVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLXYw8QO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLXYw8QO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A95C4CEEA;
	Mon, 23 Jun 2025 21:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713390;
	bh=HL2Kie3c4orsmGjaCUDzkozNDCrS5KGaUfDFx/NxBF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLXYw8QOjgK9FdmCfDYCT8t14ahMcW0jm1Ur8PFSWsm7kfFSb2FweWdq8SFMKew84
	 sKH+KB0dpyxR3WSz7uRhAxwtAZ2uycCAwAQGjyjwD+zq5OdBox9DvRtk/tz0TjxlJw
	 k48TaqUgvvDJkxe3636TNwK2w4j/If8w1b6inYgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	sunliming <sunliming@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 324/592] wifi: mt76: mt7996: fix uninitialized symbol warning
Date: Mon, 23 Jun 2025 15:04:42 +0200
Message-ID: <20250623130708.155383521@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: sunliming <sunliming@kylinos.cn>

[ Upstream commit 187de25110c8ac8d52e24f8c596ebdcbcd55bbbf ]

Fix below smatch warnings:
drivers/net/wireless/mediatek/mt76/mt7996/main.c:952 mt7996_mac_sta_add_links()
error: uninitialized symbol 'err'.
drivers/net/wireless/mediatek/mt76/mt7996/main.c:1133 mt7996_set_rts_threshold()
error: uninitialized symbol 'ret'.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202504101051.1ya4Z4va-lkp@intel.com/
Signed-off-by: sunliming <sunliming@kylinos.cn>
Link: https://patch.msgid.link/20250419031528.2073892-1-sunliming@linux.dev
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index a3295b22523a6..b11dd3dd5c46f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -991,7 +991,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 {
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
 	unsigned int link_id;
-	int err;
+	int err = 0;
 
 	for_each_set_bit(link_id, &new_links, IEEE80211_MLD_MAX_NUM_LINKS) {
 		struct ieee80211_bss_conf *link_conf;
@@ -1254,7 +1254,7 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 static int mt7996_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
 {
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
-	int i, ret;
+	int i, ret = 0;
 
 	mutex_lock(&dev->mt76.mutex);
 
-- 
2.39.5



