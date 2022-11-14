Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171224C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7EFC433C1;
	Mon, 14 Nov 2022 12:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430389;
	bh=87jc1f9aBeUUoqpANk80a/kPipWvHgjrk22lJX2TRdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXymy9qi30nZchf0uTAcu0L5gGZ8A9znjf25sdhQ0cC9SY/aT6XzWV5kf4ZR5z1VX
	 wRlWKOT60Xttk8Xu5Pz8GcwqHfCn/TINnZ1CBVEYq94KXGRyTNw9KTDQ9C57hwzAXJ
	 uzwWc5j4VQKb0bIGioVUPMKuOy4j6+pLPwWh+0Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/131] wifi: mac80211: Set TWT Information Frame Disabled bit as 1
Date: Mon, 14 Nov 2022 13:44:44 +0100
Message-Id: <20221114124449.373944029@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 30ac96f7cc973bb850c718c9bbe1fdcedfbe826b ]

The TWT Information Frame Disabled bit of control field of TWT Setup
frame shall be set to 1 since handling TWT Information frame is not
supported by current mac80211 implementation.

Fixes: f5a4c24e689f ("mac80211: introduce individual TWT support in AP mode")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Link: https://lore.kernel.org/r/20221027015653.1448-1-howard-yh.hsu@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/s1g.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/s1g.c b/net/mac80211/s1g.c
index 4141bc80cdfd..10b34bc4b67d 100644
--- a/net/mac80211/s1g.c
+++ b/net/mac80211/s1g.c
@@ -112,6 +112,9 @@ ieee80211_s1g_rx_twt_setup(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
+	/* TWT Information not supported yet */
+	twt->control |= IEEE80211_TWT_CONTROL_RX_DISABLED;
+
 	drv_add_twt_setup(sdata->local, sdata, &sta->sta, twt);
 out:
 	ieee80211_s1g_send_twt_setup(sdata, mgmt->sa, sdata->vif.addr, twt);
-- 
2.35.1



