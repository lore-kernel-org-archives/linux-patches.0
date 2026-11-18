Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037792;
	b=toAbQb/NnVIASA+w9vlrk6f4GdUySzlg/yY+mV56zN6PF60RaM2hwLtO+f/qqQm1dE7R
	 2pZKSY8bhNMYI1GOcCWtooBCAZtFdRfMzOFRndaZGI8LouIZo+hopd5OT320ddJK1IF8k
	 RJbdd42mqcW2KoZKnmuMHF/+jwH2oCyHVpNWE0y/gH0yMLLWhQC9HqKAB/CT8Zeq/6bPy
	 X5y1XTiYdBez4XDXRr5jBcTYqmYV84gkl0kuqd8U3IDoEtuJBu6tBE84NaE2PkKkkYKio
	 eMKwd5WcINrbt+w8Sk6ic4xU1FpEVq73vI352tFfPB3mS8IFG6Z02RjvwedubpFcR3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+vuJ12nWTsJbPQooivbiFdQV8WOxOpCfltmYtKODR1I=;
	b=Ich1SishabtMv9unCoYk521Z8ukPKS0u/BH7gompkuMiCRFqnsr2HmLdXUZYquM+Qhhg
	 kkFyyUIX1wFMifgUEO8Z6LWnW7H+k0dh61vRw4o+Yj4QlaS5+ZEACqKuNEeO6kcVwRVnw
	 /g+LcVCsKMuEiYKPu7+MnXD5dbQ434khTrkt4huiFNmOhgod6//BmIzVygmo4M0qHZ7XW
	 XIL+ZqidRogdY8kka9DTUB2jaIk5HuqOK5xhkCqVnrPpfJUC2UVNDssou9jnPFF/NpMa/
	 VnYJw35tc4koXd11PM3UzEjrefMUEKB0qdCXc+Op5fVSHig9hDEZVLnqUFSgJ1iWwnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r0Gf3kQH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87C1606A325;
	Wed, 18 Nov 2026 21:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r0Gf3kQH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92661F000C4;
	Wed, 18 Nov 2026 21:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037792;
	bh=+vuJ12nWTsJbPQooivbiFdQV8WOxOpCfltmYtKODR1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0Gf3kQHZjSbpoWCMjLIdWk3C/IjEfYRqkd7X1iRJq1bSEgUCNhsAlaWi69qXE7Pe
	 VgEXxtcUCxsOhFLZayEHrQOu0FR+CKMLsxe7qsv0S/K0rN0AJnHie0zNBpEm27KCeq
	 m6pZXh4mPf5svkgvfdg9CpWQUEr+UHEKAbxg7RhU=
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
Subject: [PATCH 6.6 1521/3318] mm/ksm: reset the unstable trees of all nodes
Date: Wed, 18 Nov 2026 15:35:43 +0100
Message-ID: <20261118150406.587876700@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4ca7e4511297b..fa4229a224060 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -287,6 +287,7 @@ atomic_long_t ksm_zero_pages = ATOMIC_LONG_INIT(0);
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
+/* Number of allocated stable and unstable tree roots. */
 static int ksm_nr_node_ids = 1;
 #else
 #define ksm_merge_across_nodes	1U
@@ -3374,14 +3375,13 @@ static ssize_t merge_across_nodes_store(struct kobject *kobj,
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



