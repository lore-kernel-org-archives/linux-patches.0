Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F842C15A9;
	Sat, 12 Sep 2026 13:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221077; cv=none; b=H666u3cIlEdLmO7RQ5NRbwL7c6utOLraUCicav+bW58cAXhCkQ6+wMKYoTOmgxs6xU+M+IBmfuwp0VK9sMD3RfFjbmW0sS3lHPcztwNNEqXNDGg8EDvUrCMBF/5B3hq6LhMV5AGP7f/CxgEHrjIWcOTbuOtJoS5H9aXV1zALZ4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221077; c=relaxed/simple;
	bh=qVmqRur+9zsqj9UaLOgVrwmrAqmdvNkbnp7uNEcNaYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D68JEIsQlI0UIg0h4vODsU3pf/k5REilroLl+l1Kz4qYu36J7+viYsuhW4NIXGh9AbNFwRBgY7YIZZ8BPkx849XgPE20PO1rDJTwO6R2EAoedWrY1683zA/NZqqmjJgNaUx9HWaErhmKCCJeT39bjMR6ZFfF3FBkPCXi/zvCGtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Sr2TfYg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Sr2TfYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE511F000FF;
	Sat, 12 Sep 2026 13:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221075;
	bh=JjFZgKmtwtPv9FQM952x8MduuaxDL/+tecBQ/cdQgaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Sr2TfYgUYJK8rC2brR/GtU6hpSsHqLbwETsTaLc9IXm2y9sStDxsLURU/PnwSHoY
	 DVAphjHAX+l9CWoF7STVOXF2TG9yN51HgD/shRH7yNzpABBoIZTZDWLC3vgiqNAwED
	 LRMIFDFg/snNW8H2i59wgHdwunFIiBGZyUAxotbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Eelco Chaudron <echaudro@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0310/1424] net: openvswitch: fix kernel-doc warnings in internal headers
Date: Sat, 12 Sep 2026 08:45:42 +0200
Message-ID: <20260912065614.226713761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 6bb0dcb3d321c14be7ca33b71a149034d6a2cde8 ]

Some field descriptions were missing, some were not very accurate.
Not touching the uAPI header or .c files for now.

Formatting of those comments isn't great in general, but at least
they are not missing anything now.

Before:
  $ ./scripts/kernel-doc -none -Wall net/openvswitch/*.h 2>&1 | wc -l
  16

After:
  $ ./scripts/kernel-doc -none -Wall net/openvswitch/*.h 2>&1 | wc -l
  0

Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20250320224431.252489-1-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.h | 20 ++++++++++++++------
 net/openvswitch/vport.h    |  9 +++++++++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 88156a677f22c..92dea32da88bd 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -29,8 +29,8 @@
  * datapath.
  * @n_hit: Number of received packets for which a matching flow was found in
  * the flow table.
- * @n_miss: Number of received packets that had no matching flow in the flow
- * table.  The sum of @n_hit and @n_miss is the number of packets that have
+ * @n_missed: Number of received packets that had no matching flow in the flow
+ * table.  The sum of @n_hit and @n_missed is the number of packets that have
  * been received by the datapath.
  * @n_lost: Number of received packets that had no matching flow in the flow
  * table that could not be sent to userspace (normally due to an overflow in
@@ -40,6 +40,7 @@
  *   up per packet.
  * @n_cache_hit: The number of received packets that had their mask found using
  * the mask cache.
+ * @syncp: Synchronization point for 64bit counters.
  */
 struct dp_stats_percpu {
 	u64 n_hit;
@@ -74,8 +75,10 @@ struct dp_nlsk_pids {
  * ovs_mutex and RCU.
  * @stats_percpu: Per-CPU datapath statistics.
  * @net: Reference to net namespace.
- * @max_headroom: the maximum headroom of all vports in this datapath; it will
+ * @user_features: Bitmap of enabled %OVS_DP_F_* features.
+ * @max_headroom: The maximum headroom of all vports in this datapath; it will
  * be used by all the internal vports in this dp.
+ * @meter_tbl: Meter table.
  * @upcall_portids: RCU protected 'struct dp_nlsk_pids'.
  *
  * Context: See the comment on locking at the top of datapath.c for additional
@@ -125,10 +128,13 @@ struct ovs_skb_cb {
 #define OVS_CB(skb) ((struct ovs_skb_cb *)(skb)->cb)
 
 /**
- * struct dp_upcall - metadata to include with a packet to send to userspace
+ * struct dp_upcall_info - metadata to include with a packet sent to userspace
  * @cmd: One of %OVS_PACKET_CMD_*.
  * @userdata: If nonnull, its variable-length value is passed to userspace as
  * %OVS_PACKET_ATTR_USERDATA.
+ * @actions: If nonnull, its variable-length value is passed to userspace as
+ * %OVS_PACKET_ATTR_ACTIONS.
+ * @actions_len: The length of the @actions.
  * @portid: Netlink portid to which packet should be sent.  If @portid is 0
  * then no packet is sent and the packet is accounted in the datapath's @n_lost
  * counter.
@@ -149,6 +155,10 @@ struct dp_upcall_info {
  * struct ovs_net - Per net-namespace data for ovs.
  * @dps: List of datapaths to enable dumping them all out.
  * Protected by genl_mutex.
+ * @dp_notify_work: A work notifier to handle port unregistering.
+ * @masks_rebalance: A work to periodically optimize flow table caches.
+ * @ct_limit_info: A hash table of conntrack zone connection limits.
+ * @xt_label: Whether connlables are configured for the network or not.
  */
 struct ovs_net {
 	struct list_head dps;
@@ -157,8 +167,6 @@ struct ovs_net {
 #if	IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT)
 	struct ovs_ct_limit_info *ct_limit_info;
 #endif
-
-	/* Module reference for configuring conntrack. */
 	bool xt_label;
 };
 
diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
index 3e71ca8ad8a78..9f67b9dd49f98 100644
--- a/net/openvswitch/vport.h
+++ b/net/openvswitch/vport.h
@@ -97,6 +97,8 @@ struct vport {
  * @desired_ifindex: New vport's ifindex.
  * @dp: New vport's datapath.
  * @port_no: New vport's port number.
+ * @upcall_portids: %OVS_VPORT_ATTR_UPCALL_PID attribute from Netlink message,
+ * %NULL if none was supplied.
  */
 struct vport_parms {
 	const char *name;
@@ -125,6 +127,8 @@ struct vport_parms {
  * have any configuration.
  * @send: Send a packet on the device.
  * zero for dropped packets or negative for error.
+ * @owner: Module that implements this vport type.
+ * @list: List entry in the global list of vport types.
  */
 struct vport_ops {
 	enum ovs_vport_type type;
@@ -144,6 +148,7 @@ struct vport_ops {
 /**
  * struct vport_upcall_stats_percpu - per-cpu packet upcall statistics for
  * a given vport.
+ * @syncp:     Synchronization point for 64bit counters.
  * @n_success: Number of packets that upcall to userspace succeed.
  * @n_fail:    Number of packets that upcall to userspace failed.
  */
@@ -164,6 +169,8 @@ void ovs_vport_free(struct vport *);
  *
  * @vport: vport to access
  *
+ * Returns: A void pointer to a private data allocated in the @vport.
+ *
  * If a nonzero size was passed in priv_size of vport_alloc() a private data
  * area was allocated on creation.  This allows that area to be accessed and
  * used for any purpose needed by the vport implementer.
@@ -178,6 +185,8 @@ static inline void *vport_priv(const struct vport *vport)
  *
  * @priv: Start of private data area.
  *
+ * Returns: A reference to a vport structure that contains @priv.
+ *
  * It is sometimes useful to translate from a pointer to the private data
  * area to the vport, such as in the case where the private data pointer is
  * the result of a hash table lookup.  @priv must point to the start of the
-- 
2.53.0



