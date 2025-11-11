Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627661F4617;
	Tue, 11 Nov 2025 01:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824669; cv=none; b=i5wea0LETjWhlKrugAtbj2jtESycY9q0oTcReKfABOtVaxpPwQl4NoRKJbu158aSqhgALR58OtX5xcr4ZbG8TC9bVz+YaihpUC0Leg6EIWJKC4ngZW+QhEy/G0TEKDXJsdEtRbjAXkxpy5JWX+ep32khp5iFwlEhxOsKfsJfKxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824669; c=relaxed/simple;
	bh=3sM9FB6aRxBJJQ7/sINecKX/V5GI2hBDfvUvWmsMaSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdmyPl7xv/uHjcGI8hz5e7KfJv8Z5sxEDbvsfUqNo5MxHuvWQvJvN/c+VoJdpyr2OU6P1GDuAfexTRYdHmoKpQkEUCVyz6U6NySmLdq1ZEWsMR8JCTx6p/rYIEybaMz5WgodmhzE5E/9TVYanxVJFZL30Qr1t/ZiBcW9SCwGmOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbM71Pf6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbM71Pf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB550C113D0;
	Tue, 11 Nov 2025 01:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824669;
	bh=3sM9FB6aRxBJJQ7/sINecKX/V5GI2hBDfvUvWmsMaSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbM71Pf6bGCrw6WKt7Eeb9Yo1A38HxVYityPX2rEBYKfEXZF201xGzFqQUAD3YPEn
	 XnQFBwIo59gc4iVvxrgZ81mqEh0s7zMvx58wtVjXwIXoa50I6TqbmH9/zBYBEj7KXF
	 WEmvIlClAzAZiq7lnXpWOapaMWx45ndm9YGWXegU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 547/849] wifi: mt76: improve phy reset on hw restart
Date: Tue, 11 Nov 2025 09:41:57 +0900
Message-ID: <20251111004549.631288587@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3f34cced88a429872d1eefc393686f9a48ec01d9 ]

- fix number of station accounting for scanning code.
- reset channel context

Link: https://patch.msgid.link/20250915075910.47558-14-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 59adf33126170..4fa045e87a81f 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -824,6 +824,8 @@ static void mt76_reset_phy(struct mt76_phy *phy)
 		return;
 
 	INIT_LIST_HEAD(&phy->tx_list);
+	phy->num_sta = 0;
+	phy->chanctx = NULL;
 }
 
 void mt76_reset_device(struct mt76_dev *dev)
-- 
2.51.0



