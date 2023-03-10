Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64128489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD8FC433D2;
	Fri, 10 Mar 2023 14:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457889;
	bh=Y9hw6l4mRSujFRa4h37a2DCRotgaoRWL7tZnbQN9q1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOURlg/Wlq/cCP25Y0YkWg4J5MDyDnLAD/Iuc8jeio6rYQWSqtkhs+JqH1CcQDuk+
	 zUFGgThiaR81mT6Vtz1HuW2eueKF7PMGtDMGhkNureDZZqXrbCkkK8XoNQIiRAtyfD
	 9WqOeRG80juLIW4//UkYu2scliX/s584Tss4wfLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/252] wifi: mac80211: make rate u32 in sta_set_rate_info_rx()
Date: Fri, 10 Mar 2023 14:37:11 +0100
Message-Id: <20230310133720.679435124@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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
index 3a907ba7f7634..5e28be07cad88 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2047,7 +2047,7 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 
 static int sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 {
-	u16 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
+	u32 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
 
 	if (rate == STA_STATS_RATE_INVALID)
 		return -EINVAL;
-- 
2.39.2



