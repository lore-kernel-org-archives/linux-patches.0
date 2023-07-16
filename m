Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C26C8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8521CC433C7;
	Sun, 16 Jul 2023 20:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539789;
	bh=NT2Zqbvt9Yb5l2itftHMYeHnRFJamq/cixbhSXSZcMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhy7lD5b6etWrXMHYAVC+mAARNtbrirpPcNZI3JCESxOSZ54sxie23/yTDKRnRPme
	 eNp4VurEp0XBfMp77Fk9nyTVTLvaFz+zDnyJV0PjAbVHZ6YeVPhnzCViOQyhmi9hYz
	 5cF5QuMCh03Hke8S1DHCihojHmdXj7zUSZlIoIVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/591] wifi: mac80211: Fix permissions for valid_links debugfs entry
Date: Sun, 16 Jul 2023 21:44:05 +0200
Message-ID: <20230716194926.616266872@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index 5b014786fd2d0..08a1d7564b7f2 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -694,7 +694,7 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD_MODE(uapsd_queues, 0600);
 	DEBUGFS_ADD_MODE(uapsd_max_sp_len, 0600);
 	DEBUGFS_ADD_MODE(tdls_wider_bw, 0600);
-	DEBUGFS_ADD_MODE(valid_links, 0200);
+	DEBUGFS_ADD_MODE(valid_links, 0400);
 	DEBUGFS_ADD_MODE(active_links, 0600);
 }
 
-- 
2.39.2



