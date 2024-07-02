Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2E51514DC;
	Tue,  2 Jul 2024 17:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941314; cv=none; b=BLBD/HU+C7PREQb1fXUao5//TG8ooRD4633huqVPX615DDCZ+lUeQQdwEsheHa460y6u+1Ujfne+dIFatImGlgOuoMSfFRNMuuXLyu2D7A2o7QzIb17KIMDwmCGfye4bpgOuDw1HfT7Vrw6kkCj81unnM0HAtNRsmU629uTN9P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941314; c=relaxed/simple;
	bh=b8WKXVz+A5evtNU0RmLy2PcjkNI/fHyWJ14VR/pDUVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tu5UMUrvdKznE/CtZSQv9Y71C8ZyhrvKb0rRZpGAWyX+1fFp7gpS9ww2qJFg6Pf2hC0hhIID8SK7sOrOe7RCC/nXkw7t6dGFOL1MYDmzvgfM4inENU/uK4P+Kj1AnUVdytNOxwepIziMkdooU1ELcjSk49Gs4MjSgffLweiOslg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGzu6nJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGzu6nJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6F3C116B1;
	Tue,  2 Jul 2024 17:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941314;
	bh=b8WKXVz+A5evtNU0RmLy2PcjkNI/fHyWJ14VR/pDUVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGzu6nJ+Of8W0xJX2x0UqLeCs5tCn7FjxPyPlm8Efbk9meo/1rko8YLSYtzQM3+fV
	 EbEkQ8KgvAR4AWJ0ZYaTJZ2NuuleS8AOw9zlOm0aefheAkj4y/CIDUCFItIetRHwkO
	 wZJkhnxVIpuYXF8Rsl64TxFuOU2LwlCivYFSDfiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Narasimhan V <Narasimhan.V@amd.com>,
	Jan Beulich <jbeulich@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/128] x86/mm/numa: Use NUMA_NO_NODE when calling memblock_set_node()
Date: Tue,  2 Jul 2024 19:03:24 +0200
Message-ID: <20240702170226.364430407@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 3ac36aa7307363b7247ccb6f6a804e11496b2b36 ]

memblock_set_node() warns about using MAX_NUMNODES, see

  e0eec24e2e19 ("memblock: make memblock_set_node() also warn about use of MAX_NUMNODES")

for details.

Reported-by: Narasimhan V <Narasimhan.V@amd.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
[bp: commit message]
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/r/20240603141005.23261-1-bp@kernel.org
Link: https://lore.kernel.org/r/abadb736-a239-49e4-ab42-ace7acdd4278@suse.com
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/numa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index c7fa5396c0f05..c281326baa144 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -523,7 +523,7 @@ static void __init numa_clear_kernel_node_hotplug(void)
 	for_each_reserved_mem_region(mb_region) {
 		int nid = memblock_get_region_node(mb_region);
 
-		if (nid != MAX_NUMNODES)
+		if (nid != NUMA_NO_NODE)
 			node_set(nid, reserved_nodemask);
 	}
 
@@ -643,9 +643,9 @@ static int __init numa_init(int (*init_func)(void))
 	nodes_clear(node_online_map);
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 	WARN_ON(memblock_set_node(0, ULLONG_MAX, &memblock.memory,
-				  MAX_NUMNODES));
+				  NUMA_NO_NODE));
 	WARN_ON(memblock_set_node(0, ULLONG_MAX, &memblock.reserved,
-				  MAX_NUMNODES));
+				  NUMA_NO_NODE));
 	/* In case that parsing SRAT failed. */
 	WARN_ON(memblock_clear_hotplug(0, ULLONG_MAX));
 	numa_reset_distance();
-- 
2.43.0



