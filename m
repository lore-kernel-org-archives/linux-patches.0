Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015370;
	b=3hnlAoclh6NSdPb+W3o19VPF7v0RbbebqRheyruylLxPUlu+Ef0Y7efElZUyo78e+e/M
	 xR/xRpzpREqu+OruP87e/RtVJBgM5O+/USgpS9H7gdoiETY+ftII53h9Pe5tVH44Ysiew
	 bTza9i11S/nw5u5o2D0MrhV1r+95cqUamyKX0ket8RA2kjrY//HUe8x2KSvg3//6BmoFA
	 D40q7NEb/b1Q/6nhGQWlvWbHiTl0BhJ6K+s+KHVN9yqbAo8F3fpxnXwd5u1CAYBjXS0mv
	 Z3Z7rv/9wcOD/4uG74IRNd1VpYxwP7ItZkXXk64vATq3AH93A1alsxU4jL0hJrdd6Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6jV1cboApr5UXp5nPRkae8n1BzpU/vOBQ6aTzHBZMts=;
	b=zB/a2SAZhOInB3Rrq5FMsOociI4O3xTK4k/GferS+2ySeFe04cVBUPpUur4k0O5chrvd
	 xFBUFAN3LJ07WD/f+4g++UOn3CjLiYxX1oGuoVpG3ITnNGoXTh/Vgnaz628S1oN3bxvDQ
	 y7Y0qY+6OqgGQRMcwdn3gwIwiB9Td/I2a7jKl4SuLEsCdYr2j7ZIPMq9OP91ZgNHnOdu4
	 8Q6cHcGUBOgti1P64eTCzIwoIWud0BtvlPlEHQhlXb7nJAE4gFRBucEj54ViqI5+i56PY
	 xVtlSYHJKOpzQvvf1QhrryxmplmhgdCy8qyGFMqNAI4ryuinj/4sxdKzchMRrBqvsAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fUbqXPeU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057D1606A330;
	Wed, 18 Nov 2026 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fUbqXPeU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646851F000C4;
	Wed, 18 Nov 2026 15:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015369;
	bh=6jV1cboApr5UXp5nPRkae8n1BzpU/vOBQ6aTzHBZMts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUbqXPeUc8FNzxtQGHj4H5QR5WtOpBNQFA2KkVM4myzd9EMionIK6Bou8JeyBhkvy
	 x3+uZ9fvTPRenYTsrcEejWVDhOZZYTzfezjC1MxfwatPN7j/dO31wk/lb3zyF2jMkl
	 G+vdiE6qfgg33lVlvWMeA9VVgqXotc9UobUP67PU=
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
Subject: [PATCH 7.3 0148/2651] cxl/test: Map mock device nodes to an online node
Date: Wed, 18 Nov 2026 15:23:08 +0100
Message-ID: <20261118150253.184352296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 62bd92b3be45f..221be4addb0e7 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1945,7 +1945,7 @@ static int cxl_type2_mem_init(void)
 			goto err_mem;
 		}
 		pdev->dev.parent = &dport->dev;
-		set_dev_node(&pdev->dev, i % 2);
+		set_dev_node(&pdev->dev, numa_map_to_online_node(i % 2));
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_mem[i]);
 		if (rc)
@@ -1974,7 +1974,7 @@ static int cxl_type3_mem_init(void)
 			goto err_mem;
 		}
 		pdev->dev.parent = &dport->dev;
-		set_dev_node(&pdev->dev, i % 2);
+		set_dev_node(&pdev->dev, numa_map_to_online_node(i % 2));
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_mem[i]);
 		if (rc)
@@ -1991,7 +1991,7 @@ static int cxl_type3_mem_init(void)
 			goto err_single;
 		}
 		pdev->dev.parent = &dport->dev;
-		set_dev_node(&pdev->dev, i % 2);
+		set_dev_node(&pdev->dev, numa_map_to_online_node(i % 2));
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_mem_single[i]);
 		if (rc)
@@ -2009,7 +2009,7 @@ static int cxl_type3_mem_init(void)
 			goto err_rcd;
 		}
 		pdev->dev.parent = &rch->dev;
-		set_dev_node(&pdev->dev, i % 2);
+		set_dev_node(&pdev->dev, numa_map_to_online_node(i % 2));
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_rcd[i]);
 		if (rc)
-- 
2.53.0



