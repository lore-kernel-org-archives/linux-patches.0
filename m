Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4D5314B6D;
	Tue, 16 Dec 2025 11:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886058; cv=none; b=uBpH6zOngq8YHYK3KacXwifB1glz4six0V9wjJQtDLDinjsYu7G1tNrENxLqbWcxlli+WwkQE3TJo/m+nxu0jFvYQmPYVj9G1nlxbZ7iLMxGEkniyXWKQo0PmttlC/7QTQzvUBHcNqTvbOfBw2IV1WDvaB7GAnRbZJqKPOSc9YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886058; c=relaxed/simple;
	bh=AOlUm4fwgjWkVQUL068sCKDHWVxaryVbgNMQkidx3ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3Na1weN7Q4yzNUL+ADOq2VWcCAvdQHZtxK787dOV5VySsBU95cK3B/WstbDZ256bv8wdbJ6AqELK6o0rNgtJe1Jph6HOBVbnTJN5dN1zEqN4vZqrtpepdsPxLQ1A/m+00HaISHT8JKpyDfod0r/D3NSxDIh9OtXZjT8WYBf37w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrIb2ArC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrIb2ArC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2C7C4CEF1;
	Tue, 16 Dec 2025 11:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886058;
	bh=AOlUm4fwgjWkVQUL068sCKDHWVxaryVbgNMQkidx3ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrIb2ArCmPoYrLxgEP/xPifOVwZz3S3JcohG/Jc6jHMzk0hdNKBDJ9rJLeuFmgHVN
	 iLOKmNYMrP9Z4usLfcSNP5ZZF61ljOEuF/RmU1sbDXxX56HJQGRMQNTQ7Wtc/o6cyc
	 5XsSUl1gfDXhIaNZnwlKXRKmZUiFmViIWn+rdaBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 326/507] Revert "wifi: mt76: mt792x: improve monitor interface handling"
Date: Tue, 16 Dec 2025 12:12:47 +0100
Message-ID: <20251216111357.276380936@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit cdb2941a516cf06929293604e2e0f4c1d6f3541e ]

This reverts commit 55e95ce469d0c61041bae48b2ebb7fcbf6d1ba7f.

mt792x drivers don't seem to support multi-radio devices yet.  At least
they don't mess with `struct wiphy_radio` at the moment.

Packet capturing on monitor interface doesn't work after the blamed patch:

  tcpdump -i wls6mon -n -vvv

Revert the NO_VIRTUAL_MONITOR feature for now to resolve the issue.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 55e95ce469d0 ("wifi: mt76: mt792x: improve monitor interface handling")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Link: https://patch.msgid.link/20251027111843.38975-1-pchelkin@ispras.ru
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt792x_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index c0e56541a9547..9cad572c34a38 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -688,7 +688,6 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
 	ieee80211_hw_set(hw, SUPPORTS_VHT_EXT_NSS_BW);
 	ieee80211_hw_set(hw, CONNECTION_MONITOR);
-	ieee80211_hw_set(hw, NO_VIRTUAL_MONITOR);
 	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
 	ieee80211_hw_set(hw, SUPPORTS_ONLY_HE_MULTI_BSSID);
 
-- 
2.51.0



