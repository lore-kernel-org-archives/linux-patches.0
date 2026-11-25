Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625046;
	b=kI8tq9aBGLGmOlO1PhVKshVSIxKDvXd7i1UC72nTSKizFN5hSEQNF/2+XIi8kIx51Hss
	 AW0/DPKZPjPzM/RewfT9R3PGbevk/Z0vr0K3LvY/9PFd0SEIfqxF0dG6siQXypEPTeYAU
	 6i7XMqO27MY7RDMPilfxX2LpakUwBvl+QrDgCnjzYsOxfXoP9j1u6L1f1pbWlOa1ULifi
	 nYm2uWr3Q7VbCVXWQK4G5gmgVtXw5PAl8G5ttfVQiwa+B+hYbS2vEvlbIAtBOZQGNaXv+
	 P5T1uJGoF3HFoNmzIREnEJWLoGSz4hzq7oUHCQcGnxxQj6SWA6pgNkU1I1LL6T1nZOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=omRWr8c4vuS5WJ6vKs8TVlLy3NH+b4IfkR+mmWmW8C0=;
	b=o+bhh669mGJ6kn29ceri/+oc59bO2x8T24K/yMoC4BU7XFricBHxfS1vR+1bV1Uc6mC5
	 pVTeoBiflS6GNw600tYdD63TDr7rPR6uVi+9YpN8XtpMh/oeHk1Z/6L2wCQ7xm3GDYSdk
	 SoyhTfNcq19TvaKZcPUyacpDp1aWIg+ewnuC5Jdnj+FhEKI2jEP4w5mlfVQX6FViZQlMP
	 CspTLRegFqluWa1j4/NpVk7DjxRFs0NTFf2HMse3cud8sBuIfgly5e0zy3TcfL7UK5ljb
	 vlQcMbJKs0L8ijz1jHqFpO/aQyM/NopeBic0+uhOOSyiRXvYXFHaJRKppqbflS9HOmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IqNmC28M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B672C606A32A;
	Wed, 25 Nov 2026 16:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IqNmC28M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194D71F000C6;
	Wed, 25 Nov 2026 16:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625046;
	bh=omRWr8c4vuS5WJ6vKs8TVlLy3NH+b4IfkR+mmWmW8C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IqNmC28MMSyLzC/rYBG9NvVNokACbbH1sGEfPuUmzMmOniPxGqSdPVh/do46154aY
	 TTwtxzu06jiFZtN5u/4ZkegYJsvUP7ruLgcoD1WBxMX6NCTMJ7Ctctfzr5kaliAcNV
	 i8XgndQxh2B0R9docbzyA1szlX0+dD1ElX5tWLXE=
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
Subject: [PATCH 6.12 389/816] cxl/test: Map mock device nodes to an online node
Date: Wed, 25 Nov 2026 15:32:17 +0100
Message-ID: <20261125143858.206396691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the three set_dev_node() call sites in the single cxl_mem_init() since the type2/type3 init helpers don't exist here, and dropped the fourth upstream site ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 49e8b82004cb5..2432892dfcad2 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1274,7 +1274,7 @@ static int cxl_mem_init(void)
 		if (!pdev)
 			goto err_mem;
 		pdev->dev.parent = &dport->dev;
-		set_dev_node(&pdev->dev, i % 2);
+		set_dev_node(&pdev->dev, numa_map_to_online_node(i % 2));
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_mem[i]);
 		if (rc)
@@ -1289,7 +1289,7 @@ static int cxl_mem_init(void)
 		if (!pdev)
 			goto err_single;
 		pdev->dev.parent = &dport->dev;
-		set_dev_node(&pdev->dev, i % 2);
+		set_dev_node(&pdev->dev, numa_map_to_online_node(i % 2));
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_mem_single[i]);
 		if (rc)
@@ -1305,7 +1305,7 @@ static int cxl_mem_init(void)
 		if (!pdev)
 			goto err_rcd;
 		pdev->dev.parent = &rch->dev;
-		set_dev_node(&pdev->dev, i % 2);
+		set_dev_node(&pdev->dev, numa_map_to_online_node(i % 2));
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_rcd[i]);
 		if (rc)
-- 
2.53.0



