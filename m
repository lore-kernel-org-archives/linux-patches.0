Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F36E154AF
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F7BC433C9;
	Wed, 20 Sep 2023 11:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210369;
	bh=ACCrwhR7fJUrTq04osvUuDPa79B5z0eqkC3GCe+MOEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hE0bOuhKv/eJDeLIgnEC755QefjjtQdPtzbpAX5QGXrMN8aX/+bWCGQ83c8e7NIgE
	 m3ZYMLvfs+2E1qaoUDwUdEaq+BO2ZkjzQT9/2ExuhxhIBJk/JN2ry0OidJN1fhGjBs
	 OZK6R9Z1CwJ8TPZM/Ljjze8oS/7FNnh8dtMbbhic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+be9c824e6f269d608288@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 051/211] wifi: mac80211: check S1G action frame size
Date: Wed, 20 Sep 2023 13:28:15 +0200
Message-ID: <20230920112847.364551552@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 0af2599c17e8d..e751cda5eef69 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3734,6 +3734,10 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
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



