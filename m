Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA0B28E2
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E394C433C7;
	Sun, 16 Jul 2023 20:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537658;
	bh=gynbCFtLdWo1QmpIJ78cgPpXllZGc+XQTe0CXk4c87k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPhSM7VKNB7H/nDqvnfoZlh6TiUPUrJJI2oqbsjrlq/TNBSyc5+I1RMAszuPHJGFY
	 9LwQOjnZyG/agVZzaDlvC7lAWkpU43UmvXZ4HuPcwYGwPm5dqmGAE8l8gA08ptC7Gt
	 a8R4eI6045oxuu8s4rV9fGpSM8A6IM5iS8X+0IiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 147/800] wifi: mac80211: recalc min chandef for new STA links
Date: Sun, 16 Jul 2023 21:40:00 +0200
Message-ID: <20230716194952.509651849@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ba7af2654e3b7b810c750b3c6106f6f20b81cc88 ]

When adding a new link to a station, this needs to cause a
recalculation of the minimum chandef since otherwise we can
have a higher bandwidth station connected on that link than
the link is operating at. Do the appropriate recalc.

Fixes: cb71f1d136a6 ("wifi: mac80211: add sta link addition/removal")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230604120651.377adf3c789a.I91bf28f399e16e6ac1f83bacd1029a698b4e6685@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 1400512e0dde5..a1cd5c234f47e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2913,6 +2913,8 @@ int ieee80211_sta_activate_link(struct sta_info *sta, unsigned int link_id)
 	if (!test_sta_flag(sta, WLAN_STA_INSERTED))
 		goto hash;
 
+	ieee80211_recalc_min_chandef(sdata, link_id);
+
 	/* Ensure the values are updated for the driver,
 	 * redone by sta_remove_link on failure.
 	 */
-- 
2.39.2



