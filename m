Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAEA1BE227;
	Tue,  2 Jul 2024 17:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940776; cv=none; b=gSUyExhs7OBEkbB/a+buror4XEXLQpUa8DSxn0dAYxC96OoTrGkNAc59839RxbIJfHYxryhJTWiNdVP/QX7SX6NOydplp74Y2WPsbYnhgcwa2e32gSntTA8MQj5/H3wuVv1BGHhjrNgpPSZmJUPmmeLni1gKnHBQog2Y/FuZhxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940776; c=relaxed/simple;
	bh=VXfR5f4Qt9siGKoyG4ofipv7KJaJSDSFpsdZNqoVKac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOIauBBogqKVWyOtWJiHvvHwXqCjHGVNZpn7SDc7QE6XPeN3F4EqDA1r9bwPgjvR3uqvziEX7mgKtBOn/ap7qxMwqNawOOaMtfuzH0MJPtLkRW4TU4QMgvCMBV0e/movlo8IrrC3jKnr+2iKPUGeZhK1Irn2SkYyu8B83/OkMqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6PWd/hz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6PWd/hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC3BC116B1;
	Tue,  2 Jul 2024 17:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940775;
	bh=VXfR5f4Qt9siGKoyG4ofipv7KJaJSDSFpsdZNqoVKac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6PWd/hzRB3R1Z2m2Ssu4uAdsY8+0ztjyP5gEuzGQYXDU0b6zyudnMYCfZBYbTk6L
	 +pU1PRWc63Y3wYM/Ygcshawgn2qrfY92MWQSYXhde+ia8PAuCe6e/nmYbyEmQO4MIE
	 Bq4ZlopQuJtGCn6iXo8ZLbx0Q/SwpuVPfRfmmWtY=
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
Subject: [PATCH 6.6 005/163] x86/mm/numa: Use NUMA_NO_NODE when calling memblock_set_node()
Date: Tue,  2 Jul 2024 19:01:59 +0200
Message-ID: <20240702170233.256675286@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



