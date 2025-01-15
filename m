Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D49248BD1;
	Wed, 15 Jan 2025 10:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938606; cv=none; b=cyAJTbTn686sIt/jsJFTXFM64nr8EXomrmzWQLVnX2oMYSpb19y2giG+P3eKOgHEd3fVvH+a/ntiY0Q3j/YKtnOXwit+qpXZug9Q2+jyTB86BykfAs32E/1whZpTlV6h1AdVjcKR7o4EXqGzJpmV/TOPD3DQbH0Hn+ithqhjY8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938606; c=relaxed/simple;
	bh=0Wf1g26PZG19LFOjMD6Hnyebvhs7cjrnF0JIW6Zaz+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPNzcr6IgZJnNoCvhRxNcKVKP+eqD+Yb5GD2tPRMfEQ7dTYVvC5N3udMzGYMXxIkS42GO1t+TgTMfbM5kvB9iTEllHdL3ib0yz35PivWyhtufsznEMGmS2Wlse9vUun5SFXjnTS1yGMrhePneNQFOwW+JYNFrmi6eMPPBPwrKi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00r/s9YA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00r/s9YA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFEAC4CEDF;
	Wed, 15 Jan 2025 10:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938605;
	bh=0Wf1g26PZG19LFOjMD6Hnyebvhs7cjrnF0JIW6Zaz+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00r/s9YAGBxtTXbHxqi1VIo+vWhr6ra2zglJqHLT6QtFMnPudovtBVgXbW8ARJE8g
	 VFt4yT5+G70r0cT9wFJWCh5h1s4RezWmtlv/p22AhdZf1qJXPG2MHbY79RzH3StCpp
	 qEDm+Tk4ue1+KxHcfxPuPnHTo6czgGdP8tk9THkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Narasimhan V <Narasimhan.V@amd.com>,
	Jan Beulich <jbeulich@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 6.6 040/129] x86/mm/numa: Use NUMA_NO_NODE when calling memblock_set_node()
Date: Wed, 15 Jan 2025 11:36:55 +0100
Message-ID: <20250115103555.967496613@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
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
@@ -492,7 +492,7 @@ static void __init numa_clear_kernel_nod
 	for_each_reserved_mem_region(mb_region) {
 		int nid = memblock_get_region_node(mb_region);
 
-		if (nid != MAX_NUMNODES)
+		if (nid != NUMA_NO_NODE)
 			node_set(nid, reserved_nodemask);
 	}
 
@@ -613,9 +613,9 @@ static int __init numa_init(int (*init_f
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


