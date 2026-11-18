Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059132;
	b=sf8wZ16FqwzVKK7M90ZanWLuo4nTcYPM/q2mHZTZhq1hHHEdTpyvMQAnSuy5fgEEpdiU
	 v+zMshj2rBxH3b9DYR/Lk3hs58OhL24Al0ykzqoQXkgxRsc+eC9yDStxdJ2ZLWm9/1RZC
	 Smh7gkdrcSvquocezefmHhdDQgXfMUKqs/lqQ0qIu1ogb72ftk1rESwLprqbKbFRn2TFx
	 Tfe44OfgoWKyQAqTDVlGKzRupIAIXFsXkA8oD58Tja+s1YG07jYHw508+kCAX3s64/NFq
	 vzhCeD9XjbBbMDHK5oYcboG4xuKNaG/FuL5qB8AQN/xk1RACH0/aL0WfqNlruLTMv/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eZ65R/Zy2D/V5tFE6cEyP3yQl3bYypH6kEj8/9aZeAI=;
	b=L3fn8tgwbaxq0vhXWsE6JpLm7zHW+8sY2Uu6lwYYmhnj/F1dMe2I5nhobyjdDZFE6li0
	 G9ZHj4WpmKrGsh0e8KLufarBQK5F7sGNSyZCgrerQHZguoI52h/VKARxCa+84/2QVlQDo
	 J7n1wX7zlefXgqPhdJg8iymEnWyARxYnWUC0gUP/ns3sExtOtQDsM2mzkmsPdyxsIqNGY
	 MMUdEdQyhv+eUjWgPOWsLTRYFHOT4abU3Ekw7L7fvCMUr5grtnddHEb/Vk2/mQ2sgUq/h
	 BVsNVg+ZOIGlUaXxlHzPDpX5IMv8HQRFO1EjMdqQEjFNTE+ep62ernnNaTzTxOIPmaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ttk45Fmb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3EA606A325;
	Thu, 19 Nov 2026 03:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ttk45Fmb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641D21F000C6;
	Thu, 19 Nov 2026 03:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059131;
	bh=eZ65R/Zy2D/V5tFE6cEyP3yQl3bYypH6kEj8/9aZeAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ttk45FmbDNFyOu7Gq+DyVsT5b73TuYoOYU15xjaE3Aenf+8G1aq5tHYMhSnv9dfBm
	 7bZUcPH3DaN5/P1FY26BC493cq9iHIHwisGr8Xsq/z5efxr1JU6go6PVkY3DUsZ/n4
	 n8Gnaq55Ed+IJtvB2eMA2O5czVMUi+YM1pL2kO2E=
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
Subject: [PATCH 5.10 0733/1848] mm/ksm: reset the unstable trees of all nodes
Date: Wed, 18 Nov 2026 15:46:11 +0100
Message-ID: <20261118145946.880948157@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 94d17fb3f184f..466ca19997551 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -282,6 +282,7 @@ static bool ksm_use_zero_pages __read_mostly;
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
+/* Number of allocated stable and unstable tree roots. */
 static int ksm_nr_node_ids = 1;
 #else
 #define ksm_merge_across_nodes	1U
@@ -3063,14 +3064,13 @@ static ssize_t merge_across_nodes_store(struct kobject *kobj,
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



