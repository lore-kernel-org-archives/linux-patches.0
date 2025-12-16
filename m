Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FE636D512;
	Tue, 16 Dec 2025 12:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888059; cv=none; b=NSaW+EQjNNKc2/4aN9IgAe/IWSK65Gcc1bDeN2QrBmurBZYQwY92IYqhI1QWazr8uyxbA3xJkcYx1I7uHElCmsU7znqQ0CSmhawnRe6l/i39mi60V7pko0yJk9pYo9OPqh1ZEQVBzQ43e3H6r8l0vAWNSmTRXdYfHLYdD/4Aez8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888059; c=relaxed/simple;
	bh=7f228i3z3npAQl2rlL81PYGnLl7PGCzeUtU+rfjEwwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cM/rZEjR8b5hHQ4MVIZbuddBhq5sb5/uBVLxpr25EP58xhOnsfCrI0OJkCAOYkl6ZBhfRpKsJV2r7OdaVXXKs0nKsZIl/tQGYBZQuW9RxwEU5o3LaXutexOMJLKQtbfWrCBiMHwHH4DfxdNPc/du1pzx3sBcfgfCmk42G+zqQa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WA+eQv+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WA+eQv+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DD6C4CEF1;
	Tue, 16 Dec 2025 12:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888058;
	bh=7f228i3z3npAQl2rlL81PYGnLl7PGCzeUtU+rfjEwwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WA+eQv+F0flF4ZhZ4u59mZvcMs/DEVJGhHUnediHBrbNXOJ1SRfSw2a89/mufbXnC
	 UghUnTZZD7glPLU/wx+9V42T99OOggQBUEvRbz9SHLg5+9K2wugm6B5eUzOZ3svt4I
	 VLBvWaI/ctJb8Sodt6bY0j6iJpiarXig5hn3Prog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 387/614] Revert "wifi: mt76: mt792x: improve monitor interface handling"
Date: Tue, 16 Dec 2025 12:12:34 +0100
Message-ID: <20251216111415.390444593@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



