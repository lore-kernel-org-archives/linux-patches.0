Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591200;
	b=Ca41oRVO92sOkMMETEyPDUdE2Tfl7O+h86aO0GRMpuxPC8TVRW0atqZUrC6WCbFFS9aT
	 XFdue0Kqks7GRH/ZrmTjSx+wWW5g/55BHX/xzoPzhYUUgVnJIL++jmJz+6EDyqM6CtRSL
	 90IDapX2FSFssI+w8zXy41p1b7lMNaaP/zHE9MV418vVUpXbo5Wk/tnH8lJhvtunTOeTc
	 iIjOXm0JhFF9kfHgblHpFZm3+oWKWIUwU2Q070qR1m+DB6fYzBuhEXeN3Mfyjwg9auJwj
	 ZDdyfXJL5bV/CktNkXFZdA9IRxn6MXEmQeBnjiCTM0S9VpouT47k8qO2aoBSD6dD32A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/9LRzHag030ieuZoaed1biRZkHVrxxbYNu+JGkyHN0Y=;
	b=uw9IY4CrX71fug9d5FPbKyeDmxMeVz9AUTxVO2oUkhG1DjWrPoRTeyo8dMoHdhMAdiNX
	 1Lw2j6Hdck5zCgFfEichWTuSZo4x0Q6Fdy2OKvdjlQkFDckfvyhf2PlKwfzo65YT6xg93
	 Y1GQmkOmA7Ozah7fS4GDSqrjsbub2tuw3o9LpQYUMP2/9isdV9fKRGiuCKKamNw5WAjs6
	 fr1F9mZBRZJN5Y73ZfSmsIOcWS9KOdXro08/IoJaktVdM0A14HRblT+TlWsLUfvVKQlxU
	 zrRneo88tMpubdH9xdgY2M34QhgCTzWyfdvXoR4puMXHn629Vs5nAfBc8sff0jwSmHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AcPegJ/1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078CA6075851;
	Fri, 13 Nov 2026 17:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AcPegJ/1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE151F000C4;
	Fri, 13 Nov 2026 17:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591199;
	bh=/9LRzHag030ieuZoaed1biRZkHVrxxbYNu+JGkyHN0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AcPegJ/1ZHJyIoq8OuzUa3dmRIWNTWzD2cKJApMKdJCkvbBbyV8IkP305gu/dZSqR
	 bxUArFJjlTxGg1FZi2WxwFesslZ3sEAl+qc0n1CYOWr8lwv+9vpKal9G5ANZhtPXdh
	 C4jufMzBgQQv3dbNs6XsgnFaB9OP6gN+4vuUWRfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Xu Xin <xu.xin@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 333/670] mm/ksm: reset the unstable trees of all nodes
Date: Fri, 13 Nov 2026 10:48:17 -0500
Message-ID: <20261113153823.154448296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 890e118e95bfc2aae4432ec2a95192d6f9193211 ]

Each full scan resets ksm_nr_node_ids unstable tree roots. Enabling
merge_across_nodes resets this count to 1, even if per-node roots were
previously allocated.

So when toggling "merge_across_nodes" 0 -> 1 -> 0, a scan that starts
while the setting is 1 and continues after switching back to 0 can
encounter stale unstable tree roots, resulting in UAF.

Only root is allowed to change "merge_across_nodes", and the documented
sequence is: "merge_across_nodes setting can be changed only when there
are no ksm shared pages in the system: set run 2 to unmerge pages first,
then to 1 after changing merge_across_nodes, to remerge according to the
new setting."

Let's fix it by tracking in ksm_nr_node_ids the actual number of
allocated tree roots.

remove_all_stable_nodes() and ksm_check_stable_tree() will now scan
more tree roots (skipping the empty ones), which is harmless.

Fixes: ef53d16cded7 ("ksm: allocate roots when needed")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-39-d6437171ecc3@kernel.org
Reviewed-by: Xu Xin <xu.xin@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index aba53b4a3b978..8ce4cd5a382ce 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -470,6 +470,7 @@ static void advisor_stop_scan(void)
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
+/* Number of allocated stable and unstable tree roots. */
 static int ksm_nr_node_ids = 1;
 #else
 #define ksm_merge_across_nodes	1U
@@ -3532,14 +3533,13 @@ static ssize_t merge_across_nodes_store(struct kobject *kobj,
 			else {
 				root_stable_tree = buf;
 				root_unstable_tree = buf + nr_node_ids;
+				ksm_nr_node_ids = nr_node_ids;
 				/* Stable tree is empty but not the unstable */
 				root_unstable_tree[0] = one_unstable_tree[0];
 			}
 		}
-		if (!err) {
+		if (!err)
 			ksm_merge_across_nodes = knob;
-			ksm_nr_node_ids = knob ? 1 : nr_node_ids;
-		}
 	}
 	mutex_unlock(&ksm_thread_mutex);
 
-- 
2.53.0



