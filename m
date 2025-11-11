Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656E82BB17;
	Tue, 11 Nov 2025 01:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824633; cv=none; b=A4FZIMV3LvncNEam6MDdFh5fP9z8JGQwGshPYPqybgKJ/s5+aJOrhEAEFez3c/J60BvdaXXJHAaGyw7IFDipxT7o8AatYA2Evz+DNnShGL5kC4GJCoM4fxzlLxVhpcwoEQb0NA0W1I+4/UyDs7SDxG/dUrJN0zDVlaxvKZzDInk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824633; c=relaxed/simple;
	bh=v3py1gVPVsnZ9+Gu1nXxNBUDU+jq+9FzQisQvKBQ1Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kC7TFIvy6L7QVkUxgA0CBNJ2lc8+AoLJm/Uq7g3/YwpSmopcglESPGx8qGx8XIeUX6cCvyw+qRNwtdfqdltJFEsdgfJKHI2JCKQHSsI15bjQPmQPHqhUI3mZu7TYWkDDjaUp3nOQpS2YsuksROigWMnmDUpmROHLkAbTovL+v78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUbsW5sy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUbsW5sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0635DC19422;
	Tue, 11 Nov 2025 01:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824633;
	bh=v3py1gVPVsnZ9+Gu1nXxNBUDU+jq+9FzQisQvKBQ1Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUbsW5syr0OSp8uBYHqBCQ5N0lTEhWLfFwjbhB2uA8O0Sqab6kUCbuHVCbFWFrtrR
	 sMCZqr9md3FS/maWVyj/jeOkm5zJ4+Yqs0QLvcArbP7sXWcR5wyCUuuyvBw1ho53+N
	 kXnO6BVkfJz+3r9YlUdFowb9yN8a7jpjjcmbdc9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 540/849] wifi: mt76: mt7996: Temporarily disable EPCS
Date: Tue, 11 Nov 2025 09:41:50 +0900
Message-ID: <20251111004549.469391961@linuxfoundation.org>
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

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit e6291bb7a5935b2f1d337fd7a58eab7ada6678ad ]

EPCS is not yet ready, so do not claim to support it.

Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250904-mt7996-mlo-more-fixes-v1-4-89d8fed67f20@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 84015ab24af62..5a77771e3e6d6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1330,7 +1330,6 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 	eht_cap->has_eht = true;
 
 	eht_cap_elem->mac_cap_info[0] =
-		IEEE80211_EHT_MAC_CAP0_EPCS_PRIO_ACCESS |
 		IEEE80211_EHT_MAC_CAP0_OM_CONTROL |
 		u8_encode_bits(IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_11454,
 			       IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_MASK);
-- 
2.51.0



