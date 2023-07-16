Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03FD8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F8DC433C9;
	Sun, 16 Jul 2023 20:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537630;
	bh=T0c+jJZ9N9WhC5st1FT4TVNQ79lQGtYp1a2AJCAGZ9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+7WZmlKnCIERcr8iqNxC7btfyYffMyr6n7C8P1NCWbdyrwENh5Qu8XjZqE6+z89g
	 3eSjh/dFuR+w41tEH7t+SvvSLubKRPUqdVM86lrG/YklBM0CQmeed+YrUADhSSSi1x
	 2reJmcfPTWqBhJ3zrwRTEaQvgY6Hnmz+H6B3k5Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 164/800] wifi: mac80211: Fix permissions for valid_links debugfs entry
Date: Sun, 16 Jul 2023 21:40:17 +0200
Message-ID: <20230716194952.918961520@linuxfoundation.org>
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 4cacadc0dbd8013e6161aa8843d8e9d8ad435b47 ]

The entry should be a read only one and not a write only one. Fix it.

Fixes: 3d9011029227 ("wifi: mac80211: implement link switching")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230611121219.c75316990411.I1565a7fcba8a37f83efffb0cc6b71c572b896e94@changeid
[remove x16 change since it doesn't work yet]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index b0cef37eb3948..03374eb8b7cb9 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -717,7 +717,7 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD_MODE(uapsd_queues, 0600);
 	DEBUGFS_ADD_MODE(uapsd_max_sp_len, 0600);
 	DEBUGFS_ADD_MODE(tdls_wider_bw, 0600);
-	DEBUGFS_ADD_MODE(valid_links, 0200);
+	DEBUGFS_ADD_MODE(valid_links, 0400);
 	DEBUGFS_ADD_MODE(active_links, 0600);
 }
 
-- 
2.39.2



