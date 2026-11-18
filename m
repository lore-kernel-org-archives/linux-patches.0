Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046464;
	b=lmsKWMJbjxlkRfUP4VgRJCrheaNxWAjaK51PWxNnS7KipGcE2gp79vp8nivC1alEX2oD
	 z+HXlfKbygaMJpM4J+dB/zGZCP+kxnZfIXt9ukjRYWuB5OqGuF6SnS0f1mVuDdg/lpWdc
	 040ZtPkvm2DGn/lDQRZ6fwS19+dO1kIFa56KRKxYVYlInMBOwRf9Ut0HSxSnsh55VWZID
	 TBMyIJ6FgKJOmx8M98jq1XOKqPnJe7eZnP29DsrT6fDcazHIANTpYLgTcO6TvqkJeB15B
	 7jv0WbR0m8sai90Smk4sUlulH/d8SVgEu1M0D3WYgzreAf4369wADrEi6XssoKXTuFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gU/pdeYqN5xDrdFCh450B3Qs/B238lfsM2izGwzTkP4=;
	b=B7buVHFzE5CwySr0WpNr5vg8RCRsOBY2YgMntXQnXk/UAgYjPZVKoITTgy7mrweo06pX
	 n28MuIL8CFFvlHlZ1TNIfzlot/S4NenWGl9q+OlGkfL1N3ZtC+9HFtDVyhpi/u2a+JmhJ
	 ooW8jHFOWWVpvAopap6sxMax/MmptR6JUNVG5oVWK0/xlSKW0t7951+WjkT1/NvnHR8TQ
	 bViqvbnuqcoWHooWrAQIoIkD4dUuceCPgtYXQ95FGM8jj7GU+NJNKgaR8UmRbyHt52Fig
	 TZ3Ey/DND3fJ8WrJyi7LYRE5ODfv88aIE6onclVJPTnx+EkMR6PVz9Uux/kRDJTk2uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ib63navo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D77606A32A;
	Thu, 19 Nov 2026 00:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ib63navo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FCB1F000C5;
	Thu, 19 Nov 2026 00:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046464;
	bh=gU/pdeYqN5xDrdFCh450B3Qs/B238lfsM2izGwzTkP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ib63navoL3I9DX9aLaZxeMH2Z/noplli+lxA+NAwQLcHnHB7q5Mn5J/AkPA7A4Jwi
	 +W3fkKv/XetQLrlXQkMB6vKICBsAkhYUKlvjLKGCrBoLlLI+1b63NCjiwtKnNaSjT7
	 0BdF7mXDmVfYOjeMqB2cDTiy1vTSsUOOqaMnf4fc=
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
Subject: [PATCH 6.1 1288/2857] mm/ksm: reset the unstable trees of all nodes
Date: Wed, 18 Nov 2026 15:38:42 +0100
Message-ID: <20261118150247.870544198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 616a8f7c5c608..99eb19860fd59 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -278,6 +278,7 @@ static bool ksm_use_zero_pages __read_mostly;
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
+/* Number of allocated stable and unstable tree roots. */
 static int ksm_nr_node_ids = 1;
 #else
 #define ksm_merge_across_nodes	1U
@@ -3093,14 +3094,13 @@ static ssize_t merge_across_nodes_store(struct kobject *kobj,
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



