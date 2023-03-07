Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E641CBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49433C4339C;
	Tue,  7 Mar 2023 18:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215236;
	bh=i9HiGPAw0P4mdSAJYS+B3ZFFFpAQNYgf1G4OjeLDTyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqnR/F2RjgTQAVePIuB6HRHT8VzgiYReBnZrBsYOP5j21pQf4T7RKmbS1Lbm8bYAc
	 c7k+NCwxD8MtjBtYdm5nMqTKkcDA1HwWPvCx+2b2ZLSl+Cmq3X/VDiaf8VNn7lg5Q2
	 772thQNl0GuSBkLKuaQFnzMw7CwA73jn8QxeuC/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/567] wifi: mac80211: make rate u32 in sta_set_rate_info_rx()
Date: Tue,  7 Mar 2023 17:58:09 +0100
Message-Id: <20230307165912.576395851@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 59336e07b287d91dc4ec265e07724e8f7e3d0209 ]

The value of last_rate in ieee80211_sta_rx_stats is degraded from u32 to
u16 after being assigned to rate variable, which causes information loss
in STA_STATS_FIELD_TYPE and later bitfields.

Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://lore.kernel.org/r/20230209110659.25447-1-shayne.chen@mediatek.com
Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f1e263b2c2957..14db465289c53 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2190,7 +2190,7 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 
 static int sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 {
-	u16 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
+	u32 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
 
 	if (rate == STA_STATS_RATE_INVALID)
 		return -EINVAL;
-- 
2.39.2



