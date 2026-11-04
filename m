Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831205;
	b=RSqyKjcgua+kFmoGTe/bcbxsl9XViqRkZ7W/ocMfnUUY7gCoIrZXw78SN5KHEzxRsLkt
	 oal7JSEgtxq74ha/TMTNP/NkTFamgfM1I+bVluVJ48yxQo1ZOR/sQA+QZMuMYu5gay1vm
	 7D5Ya+zDXAEJzhd8yh4KHfXcLCSVRHGrnKrYDBOpdVFY31nVeHlfYrv6sV/eFD7sw1McK
	 xWiS29L9AObMr2DABYRQYjXnGXZeaL3jXWK746zGVtUm7Nmw9KIsf/x5QbXAN8+PjYtZe
	 OzrsryJvlDiG0vLfg4icdDnlCbLiLj7HUMnBrc+qIxVOnlbm/mX96EUHLfDEyD65ETw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aw7zUKe6LVdH+qEB1htDrma3zW5O5aw/SSLFQZB5RFI=;
	b=sWVPbz3y5L3yvxoGl+8nggSZkcw2tMQue2CSKtftmJPMD9ShJKycKUHmAAuC/LJR2Adc
	 jIBolBdTwI9Udv4hnMvaX7h8STBL0HiqC2qMuNNoP1x+TXJr+9rO4z/cmUnYX50vCcvJ6
	 nJM1zTjEkXuP8erl2EkWRMlv2SAFw68ksovAe68R2P4m4tT6kgq5qOT1hZuCshAV0TeI5
	 cyEgflnEMGr4MAMaNcYMMM1OR33+g9LQ7jFkYpHHnr5cj6dKW0tHv7VLO8BpSVLwsuV77
	 uRAqV+VD/2/do4GMpzO9krU9BJ1f+zSlX3WOBmcnSRFa07Y+UDY+OYnkSSYNqoBM4Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZdoXv+mh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9D4606A858;
	Wed,  4 Nov 2026 22:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZdoXv+mh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99EB1F000C1;
	Wed,  4 Nov 2026 22:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831204;
	bh=Aw7zUKe6LVdH+qEB1htDrma3zW5O5aw/SSLFQZB5RFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZdoXv+mhLvkQi5vzy1HSBkOLQl70VIxMFs4xTlUzs9fwJaWE7HS98irkb+G2q8Lag
	 mJFoZHKrqZdZTTM4WbkYl/wGCHaVAUm6DpT7YVnsnw7MJx80TEOYH9+XiXbY69DbdV
	 d3IY9X6Psgifhyrq8wJ7dAzK0f2/qNAwLi6j7T1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0563/1005] thunderbolt: Make the DP tunnel activation callback mandatory
Date: Wed,  4 Nov 2026 16:04:56 -0500
Message-ID: <20261104211059.656191745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

[ Upstream commit 12f5d8b85a66a0ac08d082517d92ce136f8c0d42 ]

tb_tunnel_alloc_dp() takes an optional callback which is run from
dprx_work once the DPRX capabilities read has completed. Without that
callback tb_dp_dprx_start() reads the capabilities synchronously and
never queues the work. It however always takes a tunnel reference which
is only dropped by dprx_work itself or by tb_dp_dprx_stop() when
cancel_delayed_work() actually canceled that work. That reference is
thus leaked for every tunnel without a callback.

The only tunnels without one are those from tb_tunnel_discover_dp(),
which are activated again when restoring from hibernation.
Pass the callback to tb_tunnel_discover_dp() as well and drop the
synchronous path such that the DPRX capabilities are always read from
dprx_work. Hibernation restore then also no longer blocks for up to 12
seconds while waiting for that read to complete.

Also fix up the KUnit tests.

Fixes: d6d458d42e1e ("thunderbolt: Handle DisplayPort tunnel activation asynchronously")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
[ sashal: Kept the existing dprx_canceled assignment in tb_dp_dprx_start() and added the new timeout and queue lines after it, and omitted the @paths kerneldoc line this tree lacks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tb.c     |  4 ++-
 drivers/thunderbolt/test.c   | 37 +++++++++++++++++++---------
 drivers/thunderbolt/tunnel.c | 47 ++++++++++++++++++++----------------
 drivers/thunderbolt/tunnel.h |  8 +++---
 4 files changed, 60 insertions(+), 36 deletions(-)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 51b56a304ae8e..be29c56c587a6 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -89,6 +89,7 @@ static void tb_dp_resource_unavailable(struct tb *tb, struct tb_port *port,
 				       const char *reason);
 static void tb_queue_dp_bandwidth_request(struct tb *tb, u64 route, u8 port,
 					  int retry, unsigned long delay);
+static void tb_dp_tunnel_active(struct tb_tunnel *tunnel, void *data);
 
 static void tb_queue_hotplug(struct tb *tb, u64 route, u8 port, bool unplug)
 {
@@ -385,7 +386,8 @@ static void tb_switch_discover_tunnels(struct tb_switch *sw,
 
 		switch (port->config.type) {
 		case TB_TYPE_DP_HDMI_IN:
-			tunnel = tb_tunnel_discover_dp(tb, port, alloc_hopids);
+			tunnel = tb_tunnel_discover_dp(tb, port, alloc_hopids,
+						       tb_dp_tunnel_active, tb);
 			tb_increase_tmu_accuracy(tunnel);
 			break;
 
diff --git a/drivers/thunderbolt/test.c b/drivers/thunderbolt/test.c
index fb769005f7cd9..082dd33d61cb4 100644
--- a/drivers/thunderbolt/test.c
+++ b/drivers/thunderbolt/test.c
@@ -1407,6 +1407,10 @@ static void tb_test_tunnel_pcie(struct kunit *test)
 	tb_tunnel_put(tunnel1);
 }
 
+static void tb_test_dp_tunnel_active(struct tb_tunnel *tunnel, void *data)
+{
+}
+
 static void tb_test_tunnel_dp(struct kunit *test)
 {
 	struct tb_switch *host, *dev;
@@ -1427,7 +1431,8 @@ static void tb_test_tunnel_dp(struct kunit *test)
 	in = &host->ports[5];
 	out = &dev->ports[13];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0, NULL, NULL);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0,
+				    tb_test_dp_tunnel_active, NULL);
 	KUNIT_ASSERT_NOT_NULL(test, tunnel);
 	KUNIT_EXPECT_EQ(test, tunnel->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, in);
@@ -1473,7 +1478,8 @@ static void tb_test_tunnel_dp_chain(struct kunit *test)
 	in = &host->ports[5];
 	out = &dev4->ports[14];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0, NULL, NULL);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0,
+				    tb_test_dp_tunnel_active, NULL);
 	KUNIT_ASSERT_NOT_NULL(test, tunnel);
 	KUNIT_EXPECT_EQ(test, tunnel->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, in);
@@ -1523,7 +1529,8 @@ static void tb_test_tunnel_dp_tree(struct kunit *test)
 	in = &dev2->ports[13];
 	out = &dev5->ports[13];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0, NULL, NULL);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0,
+				    tb_test_dp_tunnel_active, NULL);
 	KUNIT_ASSERT_NOT_NULL(test, tunnel);
 	KUNIT_EXPECT_EQ(test, tunnel->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, in);
@@ -1588,7 +1595,8 @@ static void tb_test_tunnel_dp_max_length(struct kunit *test)
 	in = &dev6->ports[13];
 	out = &dev12->ports[13];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0, NULL, NULL);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0,
+				    tb_test_dp_tunnel_active, NULL);
 	KUNIT_ASSERT_NOT_NULL(test, tunnel);
 	KUNIT_EXPECT_EQ(test, tunnel->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, in);
@@ -1658,7 +1666,8 @@ static void tb_test_tunnel_3dp(struct kunit *test)
 	out2 = &dev5->ports[13];
 	out3 = &dev4->ports[14];
 
-	tunnel1 = tb_tunnel_alloc_dp(NULL, in1, out1, 1, 0, 0, NULL, NULL);
+	tunnel1 = tb_tunnel_alloc_dp(NULL, in1, out1, 1, 0, 0,
+				     tb_test_dp_tunnel_active, NULL);
 	KUNIT_ASSERT_TRUE(test, tunnel1 != NULL);
 	KUNIT_EXPECT_EQ(test, tunnel1->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel1->src_port, in1);
@@ -1666,7 +1675,8 @@ static void tb_test_tunnel_3dp(struct kunit *test)
 	KUNIT_ASSERT_EQ(test, tunnel1->npaths, 3);
 	KUNIT_ASSERT_EQ(test, tunnel1->paths[0]->path_length, 3);
 
-	tunnel2 = tb_tunnel_alloc_dp(NULL, in2, out2, 1, 0, 0, NULL, NULL);
+	tunnel2 = tb_tunnel_alloc_dp(NULL, in2, out2, 1, 0, 0,
+				     tb_test_dp_tunnel_active, NULL);
 	KUNIT_ASSERT_TRUE(test, tunnel2 != NULL);
 	KUNIT_EXPECT_EQ(test, tunnel2->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel2->src_port, in2);
@@ -1674,7 +1684,8 @@ static void tb_test_tunnel_3dp(struct kunit *test)
 	KUNIT_ASSERT_EQ(test, tunnel2->npaths, 3);
 	KUNIT_ASSERT_EQ(test, tunnel2->paths[0]->path_length, 4);
 
-	tunnel3 = tb_tunnel_alloc_dp(NULL, in3, out3, 1, 0, 0, NULL, NULL);
+	tunnel3 = tb_tunnel_alloc_dp(NULL, in3, out3, 1, 0, 0,
+				     tb_test_dp_tunnel_active, NULL);
 	KUNIT_ASSERT_TRUE(test, tunnel3 != NULL);
 	KUNIT_EXPECT_EQ(test, tunnel3->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel3->src_port, in3);
@@ -1771,7 +1782,8 @@ static void tb_test_tunnel_port_on_path(struct kunit *test)
 	in = &dev2->ports[13];
 	out = &dev5->ports[13];
 
-	dp_tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0, NULL, NULL);
+	dp_tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0,
+				       tb_test_dp_tunnel_active, NULL);
 	KUNIT_ASSERT_NOT_NULL(test, dp_tunnel);
 
 	KUNIT_EXPECT_TRUE(test, tb_tunnel_port_on_path(dp_tunnel, in));
@@ -2203,7 +2215,8 @@ static void tb_test_credit_alloc_dp(struct kunit *test)
 	in = &host->ports[5];
 	out = &dev->ports[14];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0, NULL, NULL);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0,
+				    tb_test_dp_tunnel_active, NULL);
 	KUNIT_ASSERT_NOT_NULL(test, tunnel);
 	KUNIT_ASSERT_EQ(test, tunnel->npaths, (size_t)3);
 
@@ -2439,7 +2452,8 @@ static struct tb_tunnel *TB_TEST_DP_TUNNEL1(struct kunit *test,
 
 	in = &host->ports[5];
 	out = &dev->ports[13];
-	dp_tunnel1 = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0, NULL, NULL);
+	dp_tunnel1 = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0,
+					tb_test_dp_tunnel_active, NULL);
 	KUNIT_ASSERT_NOT_NULL(test, dp_tunnel1);
 	KUNIT_ASSERT_EQ(test, dp_tunnel1->npaths, (size_t)3);
 
@@ -2476,7 +2490,8 @@ static struct tb_tunnel *TB_TEST_DP_TUNNEL2(struct kunit *test,
 
 	in = &host->ports[6];
 	out = &dev->ports[14];
-	dp_tunnel2 = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0, NULL, NULL);
+	dp_tunnel2 = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0,
+					tb_test_dp_tunnel_active, NULL);
 	KUNIT_ASSERT_NOT_NULL(test, dp_tunnel2);
 	KUNIT_ASSERT_EQ(test, dp_tunnel2->npaths, (size_t)3);
 
diff --git a/drivers/thunderbolt/tunnel.c b/drivers/thunderbolt/tunnel.c
index 466e9da029356..84e5cb7e92db5 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -1119,8 +1119,7 @@ static void tb_dp_dprx_work(struct work_struct *work)
 	}
 	mutex_unlock(&tb->lock);
 
-	if (tunnel->callback)
-		tunnel->callback(tunnel, tunnel->callback_data);
+	tunnel->callback(tunnel, tunnel->callback_data);
 	tb_tunnel_put(tunnel);
 	tb_domain_put(tb);
 }
@@ -1136,15 +1135,10 @@ static int tb_dp_dprx_start(struct tb_tunnel *tunnel)
 
 	tunnel->dprx_started = true;
 	tunnel->dprx_canceled = false;
+	tunnel->dprx_timeout = dprx_timeout_to_ktime(dprx_timeout);
+	queue_delayed_work(tunnel->tb->wq, &tunnel->dprx_work, 0);
 
-	if (tunnel->callback) {
-		tunnel->dprx_timeout = dprx_timeout_to_ktime(dprx_timeout);
-		queue_delayed_work(tunnel->tb->wq, &tunnel->dprx_work, 0);
-		return -EINPROGRESS;
-	}
-
-	return tb_dp_is_usb4(tunnel->src_port->sw) ?
-		tb_dp_wait_dprx(tunnel, dprx_timeout) : 0;
+	return -EINPROGRESS;
 }
 
 static void tb_dp_dprx_stop(struct tb_tunnel *tunnel)
@@ -1599,20 +1593,28 @@ static void tb_dp_dump(struct tb_tunnel *tunnel)
  * @tb: Pointer to the domain structure
  * @in: DP in adapter
  * @alloc_hopid: Allocate HopIDs from visited ports
+ * @callback: Callback that is called when the DP tunnel is fully
+ *	      activated (or there is an error)
+ * @callback_data: Data for @callback
  *
  * If @in adapter is active, follows the tunnel to the DP out adapter
  * and back. Returns the discovered tunnel or %NULL if there was no
- * tunnel.
+ * tunnel. See tb_tunnel_alloc_dp() for @callback.
  *
  * Return: Pointer to &struct tb_tunnel or %NULL if no tunnel found.
  */
 struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
-					bool alloc_hopid)
+					bool alloc_hopid,
+					void (*callback)(struct tb_tunnel *, void *),
+					void *callback_data)
 {
 	struct tb_tunnel *tunnel;
 	struct tb_port *port;
 	struct tb_path *path;
 
+	if (WARN_ON(!callback))
+		return NULL;
+
 	if (!tb_dp_port_is_enabled(in))
 		return NULL;
 
@@ -1628,6 +1630,9 @@ struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
 	tunnel->alloc_bandwidth = tb_dp_alloc_bandwidth;
 	tunnel->consumed_bandwidth = tb_dp_consumed_bandwidth;
 	tunnel->src_port = in;
+	tunnel->callback = callback;
+	tunnel->callback_data = callback_data;
+	INIT_DELAYED_WORK(&tunnel->dprx_work, tb_dp_dprx_work);
 
 	path = tb_path_discover(in, TB_DP_VIDEO_HOPID, NULL, -1,
 				&tunnel->dst_port, "Video", alloc_hopid);
@@ -1695,16 +1700,16 @@ struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
  *	    %0 if no available bandwidth.
  * @max_down: Maximum available downstream bandwidth for the DP tunnel.
  *	      %0 if no available bandwidth.
- * @callback: Optional callback that is called when the DP tunnel is
- *	      fully activated (or there is an error)
- * @callback_data: Optional data for @callback
+ * @callback: Callback that is called when the DP tunnel is fully
+ *	      activated (or there is an error)
+ * @callback_data: Data for @callback
  *
  * Allocates a tunnel between @in and @out that is capable of tunneling
- * Display Port traffic. If @callback is not %NULL it will be called
- * after tb_tunnel_activate() once the tunnel has been fully activated.
- * It can call tb_tunnel_is_active() to check if activation was
- * successful (or if it returns %false there was some sort of issue).
- * The @callback is called without @tb->lock held.
+ * Display Port traffic. The @callback is called after tb_tunnel_activate()
+ * once the tunnel has been fully activated. It can call
+ * tb_tunnel_is_active() to check if activation was successful (or if it
+ * returns %false there was some sort of issue). The @callback is called
+ * without @tb->lock held.
  *
  * Return: Pointer to @struct tb_tunnel or %NULL in case of failure.
  */
@@ -1719,7 +1724,7 @@ struct tb_tunnel *tb_tunnel_alloc_dp(struct tb *tb, struct tb_port *in,
 	struct tb_path *path;
 	bool pm_support;
 
-	if (WARN_ON(!in->cap_adap || !out->cap_adap))
+	if (WARN_ON(!in->cap_adap || !out->cap_adap || !callback))
 		return NULL;
 
 	tunnel = tb_tunnel_alloc(tb, 3, TB_TUNNEL_DP);
diff --git a/drivers/thunderbolt/tunnel.h b/drivers/thunderbolt/tunnel.h
index 2c44fc8a10bc4..84281aaf28ca7 100644
--- a/drivers/thunderbolt/tunnel.h
+++ b/drivers/thunderbolt/tunnel.h
@@ -67,8 +67,8 @@ enum tb_tunnel_state {
  * @dprx_canceled: Was DPRX capabilities read poll canceled
  * @dprx_timeout: If set DPRX capabilities read poll work will timeout after this passes
  * @dprx_work: Worker that is scheduled to poll completion of DPRX capabilities read
- * @callback: Optional callback called when DP tunnel is fully activated
- * @callback_data: Optional data for @callback
+ * @callback: Callback called when DP tunnel is fully activated
+ * @callback_data: Data for @callback
  */
 struct tb_tunnel {
 	struct kref kref;
@@ -116,7 +116,9 @@ struct tb_tunnel *tb_tunnel_alloc_pci(struct tb *tb, struct tb_port *up,
 bool tb_tunnel_reserved_pci(struct tb_port *port, int *reserved_up,
 			    int *reserved_down);
 struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
-					bool alloc_hopid);
+					bool alloc_hopid,
+					void (*callback)(struct tb_tunnel *, void *),
+					void *callback_data);
 struct tb_tunnel *tb_tunnel_alloc_dp(struct tb *tb, struct tb_port *in,
 				     struct tb_port *out, int link_nr,
 				     int max_up, int max_down,
-- 
2.53.0



