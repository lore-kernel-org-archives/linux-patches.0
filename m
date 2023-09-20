Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADCA28E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BB8C433C7;
	Wed, 20 Sep 2023 11:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210898;
	bh=0PpqqulzHW5Yys8yc5QpNGv8G8bYQriP4J56RH7vdDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qopWt1iOQ44Dhy28Oa6nEeMM7CpsXY2yh7GspxMOQvMjM9TEEY0/+JaKsH3a82gDo
	 U9GENMUlsgfC4o4MEeI+u+Q8tTWEisp0MiPoqpwRiXr5fUubpFZpreobBbJrSXB1yp
	 1STVcJLAQ55vV04SR/MULJCjkffZCDMt3yLLhzhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+be9c824e6f269d608288@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/139] wifi: mac80211: check S1G action frame size
Date: Wed, 20 Sep 2023 13:29:26 +0200
Message-ID: <20230920112836.806329890@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 19e4a47ee74718a22e963e8a647c8c3bfe8bb05c ]

Before checking the action code, check that it even
exists in the frame.

Reported-by: syzbot+be9c824e6f269d608288@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 55dc0610e8633..c4c80037df91d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3625,6 +3625,10 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 			break;
 		goto queue;
 	case WLAN_CATEGORY_S1G:
+		if (len < offsetofend(typeof(*mgmt),
+				      u.action.u.s1g.action_code))
+			break;
+
 		switch (mgmt->u.action.u.s1g.action_code) {
 		case WLAN_S1G_TWT_SETUP:
 		case WLAN_S1G_TWT_TEARDOWN:
-- 
2.40.1



