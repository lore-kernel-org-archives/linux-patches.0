Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0A882495;
	Wed, 19 Jun 2024 13:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803261; cv=none; b=Sv2JT/hD0QPHV87YlKmxhKYpB+Hx+BDZ1WV9KBCtG40AaipZ+Ab8D9RfKQlk72DOAtFNFSoUtp5yRhOKDdDDlFdJ9lKInOkmv/cnESAqHXXQ2m/KkWlVzhZZiS7O1EXEy+n1rPCr4+SxqbEF0xJXSFrHBSqA50xr0A4BANty8DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803261; c=relaxed/simple;
	bh=HjTNaRDMUBAL6zDivuC72X59GsdmNwccztpgGSEKq48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXafYAVdzAnOVBKGQafhLsdRz9VZ/DP3qjH2hVGCdj6KsKCSnzO5gIX9O1lFrZd8/vLyWTJ5/h7SVcIi7Bfc3uF+xYjeB88he8I4OoyrPjmbNdJlTWe3xnlMKARi78hvz9t1OcmrftQlVmPK5aziaZxafCqdFdt8eD44fizpigA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGxKfCbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGxKfCbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B828C2BBFC;
	Wed, 19 Jun 2024 13:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803260;
	bh=HjTNaRDMUBAL6zDivuC72X59GsdmNwccztpgGSEKq48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGxKfCbmKc7v9fJMi/7fQEupYSLDAPcjwC4eDDrnS/dbjqXZgoF7/ZK2evaztekSL
	 uSEmlAPSCMLenJJ39jCjc56Oke9U2N4JXvG4Tqu524HO5trxvj94vOrfWeQhJZY87Y
	 NGEWtV/toHhFmQJUc069R2Kj3epsRhXwWh6dVd+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Narasimhan V <Narasimhan.V@amd.com>,
	Jan Beulich <jbeulich@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 6.9 206/281] x86/mm/numa: Use NUMA_NO_NODE when calling memblock_set_node()
Date: Wed, 19 Jun 2024 14:56:05 +0200
Message-ID: <20240619125617.877824238@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <jbeulich@suse.com>

commit 3ac36aa7307363b7247ccb6f6a804e11496b2b36 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/numa.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -493,7 +493,7 @@ static void __init numa_clear_kernel_nod
 	for_each_reserved_mem_region(mb_region) {
 		int nid = memblock_get_region_node(mb_region);
 
-		if (nid != MAX_NUMNODES)
+		if (nid != NUMA_NO_NODE)
 			node_set(nid, reserved_nodemask);
 	}
 
@@ -614,9 +614,9 @@ static int __init numa_init(int (*init_f
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


