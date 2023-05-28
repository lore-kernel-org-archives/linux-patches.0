Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794DC611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3495C4339E;
	Sun, 28 May 2023 19:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302992;
	bh=Q2MFxnOA5XJ19UZeafyACZ3xgh6OMdVVdIJWHzVUdYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVLUb+26JH3i31UBlyO5ZoIX+9AxY6yi26LM5QDF4m+MHn/i03ZaKZSxXAz2Q6iDD
	 vPnpnZDosgLSsmNy9Aitzw0th4wf4Rg5kmhwgR3SoLG8r+UXvo8lQojY/G4MmHyRcX
	 rpqEwT8f54oDuacwFDQdevcJur7bII2XFBOWFO2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/211] net/tipc: fix tipc header files for kernel-doc
Date: Sun, 28 May 2023 20:10:30 +0100
Message-Id: <20230528190846.282410431@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit ff10527e89826aaf76480ee47e6fd05213189963 ]

Fix tipc header files for adding to the networking docbook.

Remove some uses of "/**" that were not kernel-doc notation.

Fix some source formatting to eliminate Sphinx warnings.

Add missing struct member and function argument kernel-doc descriptions.

Correct the description of a couple of struct members that were
marked as "(FIXME)".

Documentation/networking/tipc:18: ../net/tipc/name_table.h:65: WARNING: Unexpected indentation.
Documentation/networking/tipc:18: ../net/tipc/name_table.h:66: WARNING: Block quote ends without a blank line; unexpected unindent.

../net/tipc/bearer.h:128: warning: Function parameter or member 'min_win' not described in 'tipc_media'
../net/tipc/bearer.h:128: warning: Function parameter or member 'max_win' not described in 'tipc_media'

../net/tipc/bearer.h:171: warning: Function parameter or member 'min_win' not described in 'tipc_bearer'
../net/tipc/bearer.h:171: warning: Function parameter or member 'max_win' not described in 'tipc_bearer'
../net/tipc/bearer.h:171: warning: Function parameter or member 'disc' not described in 'tipc_bearer'
../net/tipc/bearer.h:171: warning: Function parameter or member 'up' not described in 'tipc_bearer'
../net/tipc/bearer.h:171: warning: Function parameter or member 'refcnt' not described in 'tipc_bearer'

../net/tipc/name_distr.h:68: warning: Function parameter or member 'port' not described in 'distr_item'

../net/tipc/name_table.h:111: warning: Function parameter or member 'services' not described in 'name_table'
../net/tipc/name_table.h:111: warning: Function parameter or member 'cluster_scope_lock' not described in 'name_table'
../net/tipc/name_table.h:111: warning: Function parameter or member 'rc_dests' not described in 'name_table'
../net/tipc/name_table.h:111: warning: Function parameter or member 'snd_nxt' not described in 'name_table'

../net/tipc/subscr.h:67: warning: Function parameter or member 'kref' not described in 'tipc_subscription'
../net/tipc/subscr.h:67: warning: Function parameter or member 'net' not described in 'tipc_subscription'
../net/tipc/subscr.h:67: warning: Function parameter or member 'service_list' not described in 'tipc_subscription'
../net/tipc/subscr.h:67: warning: Function parameter or member 'conid' not described in 'tipc_subscription'
../net/tipc/subscr.h:67: warning: Function parameter or member 'inactive' not described in 'tipc_subscription'
../net/tipc/subscr.h:67: warning: Function parameter or member 'lock' not described in 'tipc_subscription'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 56077b56cd3f ("tipc: do not update mtu if msg_max is too small in mtu negotiation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.h     | 10 +++++++---
 net/tipc/crypto.h     |  6 +++---
 net/tipc/name_distr.h |  2 +-
 net/tipc/name_table.h |  9 ++++++---
 net/tipc/subscr.h     | 11 +++++++----
 5 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index bc0023119da2f..6bf4550aa1ac1 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -93,7 +93,8 @@ struct tipc_bearer;
  * @raw2addr: convert from raw addr format to media addr format
  * @priority: default link (and bearer) priority
  * @tolerance: default time (in ms) before declaring link failure
- * @window: default window (in packets) before declaring link congestion
+ * @min_win: minimum window (in packets) before declaring link congestion
+ * @max_win: maximum window (in packets) before declaring link congestion
  * @mtu: max packet size bearer can support for media type not dependent on
  * underlying device MTU
  * @type_id: TIPC media identifier
@@ -138,12 +139,15 @@ struct tipc_media {
  * @pt: packet type for bearer
  * @rcu: rcu struct for tipc_bearer
  * @priority: default link priority for bearer
- * @window: default window size for bearer
+ * @min_win: minimum window (in packets) before declaring link congestion
+ * @max_win: maximum window (in packets) before declaring link congestion
  * @tolerance: default link tolerance for bearer
  * @domain: network domain to which links can be established
  * @identity: array index of this bearer within TIPC bearer array
- * @link_req: ptr to (optional) structure making periodic link setup requests
+ * @disc: ptr to link setup request
  * @net_plane: network plane ('A' through 'H') currently associated with bearer
+ * @up: bearer up flag (bit 0)
+ * @refcnt: tipc_bearer reference counter
  *
  * Note: media-specific code is responsible for initialization of the fields
  * indicated below when a bearer is enabled; TIPC's generic bearer code takes
diff --git a/net/tipc/crypto.h b/net/tipc/crypto.h
index e71193bd5e369..ce7d4cc8a9e0c 100644
--- a/net/tipc/crypto.h
+++ b/net/tipc/crypto.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/**
+/*
  * net/tipc/crypto.h: Include file for TIPC crypto
  *
  * Copyright (c) 2019, Ericsson AB
@@ -53,7 +53,7 @@
 #define TIPC_AES_GCM_IV_SIZE		12
 #define TIPC_AES_GCM_TAG_SIZE		16
 
-/**
+/*
  * TIPC crypto modes:
  * - CLUSTER_KEY:
  *	One single key is used for both TX & RX in all nodes in the cluster.
@@ -69,7 +69,7 @@ enum {
 extern int sysctl_tipc_max_tfms __read_mostly;
 extern int sysctl_tipc_key_exchange_enabled __read_mostly;
 
-/**
+/*
  * TIPC encryption message format:
  *
  *     3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
diff --git a/net/tipc/name_distr.h b/net/tipc/name_distr.h
index 092323158f060..e231e6964d611 100644
--- a/net/tipc/name_distr.h
+++ b/net/tipc/name_distr.h
@@ -46,7 +46,7 @@
  * @type: name sequence type
  * @lower: name sequence lower bound
  * @upper: name sequence upper bound
- * @ref: publishing port reference
+ * @port: publishing port reference
  * @key: publication key
  *
  * ===> All fields are stored in network byte order. <===
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index 8064e1986e2c8..5a82a01369d67 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -60,8 +60,8 @@ struct tipc_group;
  * @key: publication key, unique across the cluster
  * @id: publication id
  * @binding_node: all publications from the same node which bound this one
- * - Remote publications: in node->publ_list
- *   Used by node/name distr to withdraw publications when node is lost
+ * - Remote publications: in node->publ_list;
+ * Used by node/name distr to withdraw publications when node is lost
  * - Local/node scope publications: in name_table->node_scope list
  * - Local/cluster scope publications: in name_table->cluster_scope list
  * @binding_sock: all publications from the same socket which bound this one
@@ -92,13 +92,16 @@ struct publication {
 
 /**
  * struct name_table - table containing all existing port name publications
- * @seq_hlist: name sequence hash lists
+ * @services: name sequence hash lists
  * @node_scope: all local publications with node scope
  *               - used by name_distr during re-init of name table
  * @cluster_scope: all local publications with cluster scope
  *               - used by name_distr to send bulk updates to new nodes
  *               - used by name_distr during re-init of name table
+ * @cluster_scope_lock: lock for accessing @cluster_scope
  * @local_publ_count: number of publications issued by this node
+ * @rc_dests: destination node counter
+ * @snd_nxt: next sequence number to be used
  */
 struct name_table {
 	struct hlist_head services[TIPC_NAMETBL_SIZE];
diff --git a/net/tipc/subscr.h b/net/tipc/subscr.h
index 6ebbec1bedd1a..63bdce9358fe6 100644
--- a/net/tipc/subscr.h
+++ b/net/tipc/subscr.h
@@ -47,12 +47,15 @@ struct tipc_conn;
 
 /**
  * struct tipc_subscription - TIPC network topology subscription object
- * @subscriber: pointer to its subscriber
- * @seq: name sequence associated with subscription
+ * @kref: reference count for this subscription
+ * @net: network namespace associated with subscription
  * @timer: timer governing subscription duration (optional)
- * @nameseq_list: adjacent subscriptions in name sequence's subscription list
+ * @service_list: adjacent subscriptions in name sequence's subscription list
  * @sub_list: adjacent subscriptions in subscriber's subscription list
  * @evt: template for events generated by subscription
+ * @conid: connection identifier of topology server
+ * @inactive: true if this subscription is inactive
+ * @lock: serialize up/down and timer events
  */
 struct tipc_subscription {
 	struct kref kref;
@@ -63,7 +66,7 @@ struct tipc_subscription {
 	struct tipc_event evt;
 	int conid;
 	bool inactive;
-	spinlock_t lock; /* serialize up/down and timer events */
+	spinlock_t lock;
 };
 
 struct tipc_subscription *tipc_sub_subscribe(struct net *net,
-- 
2.39.2



