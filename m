Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0B535AC1E;
	Tue, 16 Jun 2026 16:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626546; cv=none; b=rSBXkQmp2qFoQq1NSEikwYAaNHlyJAP0JkTRvPFgVicCLFpmWjl4zIYJjorbq0wWmVEjaq9zeR486ZJu3e9WxTGrmu0LnEdP3ar0umq5vAQZQ+rTAQHJs+4alll4RRX8WfmekuRiStazYJc+iXX8bQXo8PN/FxALeYf2Cf+6yow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626546; c=relaxed/simple;
	bh=NvzCbQtnjRkdmutYt7DnND8NUDB96hJrGTHIJ7olBdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mb/ooSDAX/f7iOa70aeD138DCBZc9ygHouYrgGoRhe053aHGyHhVQnpR6a1QUlFOgfh3y8vGhLEJQpTBRfSk9NOjsBdhXRVjL4ichG9FgeGmIZuW88WEqgFwqayoOWRUav1z5r6vQk/WCdwgh4PcEPWC6AeLfDUco9BQZA5xKeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJI7dDEU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJI7dDEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7311F000E9;
	Tue, 16 Jun 2026 16:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626545;
	bh=N5nOcN/UzK9gbMI06mC4Ql6XcEWU3oxyCwprsW+5DJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZJI7dDEUDi89WLm/TxaiQ+RT+lqpbXQiGwi62Y46gFlSYxTxl5HHb4kVZjL65VCat
	 dNyGLoi11LPbOCbbvMGh7BPf9iNP5kpP8cuwDlwzwlXnn4lGbtaWwOmQe/IH2V7tBH
	 8fUkGhJX+hQPN52JGIwhL9LAMzac/ORwMEKd7AvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fd222bb38e916df26fa4@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Carlos Llamas <cmllamas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/261] wifi: remove zero-length arrays
Date: Tue, 16 Jun 2026 20:27:26 +0530
Message-ID: <20260616145045.417959255@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit a85b8544d46390469b6ca72d6bfd3ecb7be985ff upstream.

All of these are really meant to be variable-length, and
in the case of s1g_beacon it's actually accessed. Make that
one in particular, and a couple of others (that aren't used
as arrays now), actually variable.

Reported-by: syzbot+fd222bb38e916df26fa4@syzkaller.appspotmail.com
Fixes: 1e1f706fc2ce ("wifi: cfg80211/mac80211: correctly parse S1G beacon optional elements")
Link: https://patch.msgid.link/20250614003037.a3e82e882251.I2e8b58e56ff2a9f8b06c66f036578b7c1d4e4685@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index abb069aa5fa54f..85bf3ac6db570b 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1266,7 +1266,7 @@ struct ieee80211_ext {
 			u8 sa[ETH_ALEN];
 			__le32 timestamp;
 			u8 change_seq;
-			u8 variable[0];
+			u8 variable[];
 		} __packed s1g_beacon;
 	} u;
 } __packed __aligned(2);
@@ -1522,7 +1522,7 @@ struct ieee80211_mgmt {
 					u8 action_code;
 					u8 dialog_token;
 					__le16 capability;
-					u8 variable[0];
+					u8 variable[];
 				} __packed tdls_discover_resp;
 				struct {
 					u8 action_code;
@@ -1690,35 +1690,35 @@ struct ieee80211_tdls_data {
 		struct {
 			u8 dialog_token;
 			__le16 capability;
-			u8 variable[0];
+			u8 variable[];
 		} __packed setup_req;
 		struct {
 			__le16 status_code;
 			u8 dialog_token;
 			__le16 capability;
-			u8 variable[0];
+			u8 variable[];
 		} __packed setup_resp;
 		struct {
 			__le16 status_code;
 			u8 dialog_token;
-			u8 variable[0];
+			u8 variable[];
 		} __packed setup_cfm;
 		struct {
 			__le16 reason_code;
-			u8 variable[0];
+			u8 variable[];
 		} __packed teardown;
 		struct {
 			u8 dialog_token;
-			u8 variable[0];
+			u8 variable[];
 		} __packed discover_req;
 		struct {
 			u8 target_channel;
 			u8 oper_class;
-			u8 variable[0];
+			u8 variable[];
 		} __packed chan_switch_req;
 		struct {
 			__le16 status_code;
-			u8 variable[0];
+			u8 variable[];
 		} __packed chan_switch_resp;
 	} u;
 } __packed;
-- 
2.53.0



