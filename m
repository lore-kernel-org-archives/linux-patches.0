Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45854C70
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125AAC433D6;
	Mon, 14 Nov 2022 13:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430893;
	bh=tRJLpFL7OmCKa+hEiLb6yVVX2ZsGGr6ikyXFbMP6K0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfiHzT40NIznv4qRXw9iGQgpSV4iO09sgLqDR32/p62okD7t21zDsVRxDiMwbukT2
	 74Mh5s1rSc59K2G/UqXO+x5C7TK1KAdvWyBm0YF+hGzMfA53FydSlLC+yKBWs7JCaa
	 WH9hb3UK7WjNTGZO6ohQr91tunWemZ+NN6LHrw38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 026/190] wifi: mac80211: Set TWT Information Frame Disabled bit as 1
Date: Mon, 14 Nov 2022 13:44:10 +0100
Message-Id: <20221114124459.899527711@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
index 8ca7d45d6daa..c1f964e9991c 100644
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



