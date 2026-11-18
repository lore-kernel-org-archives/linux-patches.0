Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025083;
	b=3sIHp5p4TFct9J8S4aqi6wIeSjgC75qDq5oeI2fY2TswnTYCDpLJmk93D+4XudqPb6+o
	 Sl1IZgAYqgsgAPbi58+njwngcrZeuic7pUUKFwj9+uKeUicr4RDito6p6e7nzhxomfokE
	 b6ajoTYoMQ+zYe8LMKKA1lzVxV16xuWIzvkPDc9x090ehTRr/c2CZJjmQ07lXZz4Genh4
	 qARwhEoI71UPaUI1LTQ1WquRxzkonliM4t96yV9YzZEsElLhQPzj1KMzLoUGTa0+VEU3L
	 zkYQr3wI+3Kgf9I0KIdZGFI9W0UEEBkZvoilpbR/dLt5lFHN6eeLogge5i1+aj3/FvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WyB4jVnHkOMarW//08NuPu1qCq39JpBsP9IEJ1UDbhg=;
	b=Jduw6NsdD7Ci3PiwSfrahB6Ke/h0I9L6dT5BlIdjqMQH7gtY+q45oCg6rS16A4cL+y2t
	 lKOx2hOIzWHB4sIv+7mVREPpC5mbkGtAhcBJQF2lcX8lgKpqH4hWPo5VlejmjXM1BWRIU
	 VBDXQJqgGoAY84IdDtke+s3eTzYwmv+A8KI5Iv1rXynKI7aXyaNfhreC65MnOtUUO7K4R
	 FhNGJci//BPY+BnS6UDfUJebTr49gFomJ79pA8RkxciLljGDORncmev9VF+0fXBL/1Rh2
	 nJ0lxeHh9vsWLJSSWw+XbSboGC5ir+kbAMGC4+JUJI5HcH7LuiUyoVQqsE5/ryo7+Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ndY2NE2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EF6606A32C;
	Wed, 18 Nov 2026 18:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ndY2NE2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9445A1F000C6;
	Wed, 18 Nov 2026 18:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025083;
	bh=WyB4jVnHkOMarW//08NuPu1qCq39JpBsP9IEJ1UDbhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ndY2NE2mPRVhZM7NAgN1so0L2AizolJSjkgQ0TRybrnaNy0mClkRpJgpR3mkXl6j
	 sJ9/sLlnwJ1RGRRX8vIWKdWgi8QmIVCtMubAzpBKl1d4+s/nq2N1rTDun/d5V6Iu1c
	 y7HIOyNLQIGj/1LxEU+Tm5YQ/1tJaeswhKz5bwls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Adrian Tomasov <atomasov@redhat.com>,
	Kris Pan <kris.pan@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0954/2151] net: iterate online nodes in skb_defer_free_flush()
Date: Wed, 18 Nov 2026 15:44:49 +0100
Message-ID: <20261118150157.208604399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Kris Pan <kris.pan@intel.com>

[ Upstream commit 56fbbb662795b29f4d12a55cb1b456553a6ec3b0 ]

skb_attempt_defer_free() only queues skbs on the current CPU's node
(numa_node_id() of a running CPU), which is always online, so the
flush loop never needs to visit nodes that are merely possible.

for_each_node() walks node_possible_map.  On machines where the
possible map is much larger than the online map -- e.g. a POWER10
LPAR with 32 possible but 1 online node -- the flush loop touches 31
cold, always-empty per-node lists on every softirq pass.

Use for_each_online_node() to iterate only node_online_map.  Nodes
that go offline are drained by dev_cpu_dead() ("net: flush
skb_defer_nodes in dev_cpu_dead()"), so the flush no longer needs to
visit offline nodes.

Loopback UDP throughput in a QEMU guest with 32 possible / 1 online
nodes (bench_udp, 8 senders, interleaved runs) improves by ~5%.

Fixes: 5628f3fe3b16 ("net: add NUMA awareness to skb_attempt_defer_free()")
Reported-by: kernel test robot <oliver.sang@intel.com>
Suggested-by: Adrian Tomasov <atomasov@redhat.com>
Closes: https://lore.kernel.org/oe-lkp/202512112119.5b9829a-lkp@intel.com
Signed-off-by: Kris Pan <kris.pan@intel.com>
Link: https://patch.msgid.link/20260928014708.3903028-1-kris.pan@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 95126e2360792..244ec60b2dd1a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6825,7 +6825,7 @@ static void skb_defer_free_flush(void)
 	struct skb_defer_node *sdn;
 	int node;
 
-	for_each_node(node) {
+	for_each_online_node(node) {
 		sdn = this_cpu_ptr(net_hotdata.skb_defer_nodes) + node;
 
 		if (llist_empty(&sdn->defer_list))
-- 
2.53.0



