Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622469;
	b=KCHPpKmPTNpa5oGgj/yXVdXcs//9qbA7DiKvzR0PTHuGLU3vZVH8V/e19gmvG83YopDI
	 lKNwBNmjsjnZecnpiCOral0adCvBTBnBT1uXHlKi63ia84+8uc2XwqPxcnh4z25xp25Ap
	 m6HUL3vO9/rs0DA+BDKTxX4tAXbCh6D2zsPpLnGgZnMNFbFK7BYrz9W2sfjpUnRzvfZqS
	 BpW6d4Vt4u1HtqMEZKxZ15O4tdXFlMnok4wae0rQlJFYrMjbhfsRYIA3foJ2ZKlNVthFw
	 23n1YrhpxzVIKEUys9mq34bTvVfIlgxuBdXr0eePnaOTa7KA09E9O2ac3WkpXO616Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pBw3eFZMIdFlpj6inv9HMO/BgxHcDI5Gm/o+siW6Y/Q=;
	b=iCKkOm3pENgwVj4jyG42RWLqRkBfMximJYuvAoO+00k5UdKPo5XjzDJXQI7M+pE0QYne
	 sfI/5Mky75oHAMc4rmg1g0TqL0QHOvemRlC3xGFxc6k3wEsRmTjQ0nEw7A+uNUHX39L9R
	 Hjm/RKkdr2gf0IYa1skX56o8VyE4anYnt//P9MIAdVdIgkuRjVYv35uxtG/JjdGohCPBv
	 bT/GuKeNB9FLToWq/olskYRNCvwq43HazcrElKxY1arf52Sk5KmUxgeRY39dCZcyO/ezO
	 Omm71DZs8xcvFKX39Sn7cbnammR7qikn9Vr5rmq+eloV/RjmjEvAzHnhOjqSjAm+3vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IlQkeAM4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BCC606A31E;
	Wed, 25 Nov 2026 16:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IlQkeAM4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7061F000EB;
	Wed, 25 Nov 2026 16:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622468;
	bh=pBw3eFZMIdFlpj6inv9HMO/BgxHcDI5Gm/o+siW6Y/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlQkeAM4URMTXy//szPzX/P5MKF0ECIBcOePXfcKVouXddsEwd2zHiA8doOKupPM/
	 uoXtSBypK1Y1VmkyaT3hn6o4yVwNFquU3oe7K2s6RSK1s/bcQfaGsWAYg9p82BYZ1I
	 u1TlDNF85BMBKjZd/topGnpEx5jgLHy93JGHsbFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Shaikh Kamaluddin <shaikhkamal2012@gmail.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 503/990] cxl/test: Map mock device nodes to an online node
Date: Wed, 25 Nov 2026 15:31:10 +0100
Message-ID: <20261125143833.883921159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 6f057dea152574dd044382fd0ba5ed19e3ecba25 ]

cxl_type3_mem_init() and cxl_type2_mem_init() assign alternating NUMA
nodes to the mock memdevs to model multi-node topologies. On a
single-node host node 1 has no pgdat, and the first node-aware
allocation in an odd device's probe faults on a NULL zonelist:

  Oops: general protection fault, probably for non-canonical address 0xdffffc00000006e3
  KASAN: probably user-memory-access in range [0x0000000000003718-0x000000000000371f]
  Workqueue: async async_run_entry_fn
  RIP: __alloc_frozen_pages_noprof+0x288
   new_slab
   ___slab_alloc
   __kmalloc_node_track_caller_noprof
   devm_kmalloc
   cxl_mock_mem_probe

Map the requested node to an online one, as dax_hmem already does
for its target node.

Fixes: cf1f6877b088 ("cxl/memdev: Add numa_node attribute")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Tested-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20260831175119.3247915-1-dave@stgolabs.net
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[ sashal: Dropped the upstream hunk in the type-2 init function, which doesn't exist here, and applied the numa_map_to_online_node() wrapper to the three set_dev_node calls in cxl_mem_init(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index aadb90ec516e5..9663f183aa2c0 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1369,7 +1369,7 @@ static int cxl_mem_init(void)
 		if (!pdev)
 			goto err_mem;
 		pdev->dev.parent = &dport->dev;
-		set_dev_node(&pdev->dev, i % 2);
+		set_dev_node(&pdev->dev, numa_map_to_online_node(i % 2));
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_mem[i]);
 		if (rc)
@@ -1384,7 +1384,7 @@ static int cxl_mem_init(void)
 		if (!pdev)
 			goto err_single;
 		pdev->dev.parent = &dport->dev;
-		set_dev_node(&pdev->dev, i % 2);
+		set_dev_node(&pdev->dev, numa_map_to_online_node(i % 2));
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_mem_single[i]);
 		if (rc)
@@ -1400,7 +1400,7 @@ static int cxl_mem_init(void)
 		if (!pdev)
 			goto err_rcd;
 		pdev->dev.parent = &rch->dev;
-		set_dev_node(&pdev->dev, i % 2);
+		set_dev_node(&pdev->dev, numa_map_to_online_node(i % 2));
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_rcd[i]);
 		if (rc)
-- 
2.53.0



