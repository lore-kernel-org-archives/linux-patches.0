Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050986;
	b=ef7hqhlhHayP07OVzjjn4KMCnYsVKDGR8ShDBoBjsiXTkLm2BAxdigmRh9gmrpzMak7y
	 MdQVpOGg5uad/rzRyRVNzEdk6kCEDnecC+WszX1YdYbOh+AXRLoKJXJ99EQgcb7/ExpDd
	 jLae2F4CDpC9b9GuWJKX45RYl9QBbql/HUYrv12HzihUh1nUIjXFTPEGeQoqBEBJYqIbc
	 9Dy+dShPnXggVACGC2hicFFKCVd2Tv/FHWZTJagIx1x4um/V7FaVb0GcbiQ08fnSb2XqK
	 y1hMJX30CBkG+E1+5v0OyciAvBwnqowKhc4Hf8KZRLdDxBMrSPsm0xi2INux62tPQ9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/qNPULcq7Fcw1FvGtyNOEIDEMSvorwnwy+1UhjXtdok=;
	b=szpgBZ46B9BtRhEydWX0r6hkeD0iE+sY6CiUEHCqZY7zvf1aORN94+FhhQBXVNOQ3Uge
	 5A9dIFFUOXha6D3IIfK5RfRgMKN+Aab9OqVbgRzSvL/NOORGjE5Z+UNy6fziID7ItOMEU
	 Wnoxiwk4LBCkEdi/HBf/idLcDCyuRIVRfiNJ5owut39wZT9YBNXYc6w5vtJ5yrqPlTk0V
	 yPnuJY6JwXY24xCjsc3UocglqLOg2P1CD/5YL5FscO8gTnPb1AuR98S79DwOJXXX1wn7F
	 7OFF4C3Qlq6+RqUEDLmwcx6yrKuFBzcVYRM5fpW2AxgAYWY+KIrnf14YIxgm23NWtdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vD8xR30Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4477E606A325;
	Thu, 19 Nov 2026 01:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vD8xR30Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176321F000C4;
	Thu, 19 Nov 2026 01:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050985;
	bh=/qNPULcq7Fcw1FvGtyNOEIDEMSvorwnwy+1UhjXtdok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vD8xR30QsOAXCAP6QoB5uqSZNrA2OhNsxqzJX4EUcF/tSpxqlSdCVTu5Y1TQu+/iG
	 BPshrlLr26/VXv6eUN7GicoEv08nxsmd17SwTR7eYqPCtTCNNnQKIMc0n1VaJzFrdA
	 Gxqz2JGVbdDafXHqdLXrqz6s3s0RE4p8BTWkRIrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0049/2214] netfilter: ebtables: bound num_counters like nentries in do_replace()
Date: Wed, 18 Nov 2026 15:28:45 +0100
Message-ID: <20261118150012.007252887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 43ae85af154b27f9a0ff602f7a01e3a7583ffdab ]

do_replace_finish() allocates the counter buffer before it is validated:

   counterstmp = vmalloc_array(repl->num_counters, sizeof(*counterstmp));

do_replace() only checks num_counters against INT_MAX / sizeof(struct
ebt_counter), so vmalloc_array() can be asked for up to 134217726 * 16 =
2147483616 bytes (~2 GiB).

num_counters must in fact equal nentries: do_replace_finish() later
rejects the request when repl->num_counters != t->private->nentries.
get_counters() folds the per-CPU counters back into one entry per rule,
so what userspace gets is bounded by nentries, never by nentries *
nr_cpus. Apply the same upper bound used for nentries (MAX_EBT_ENTRIES)
to the incoming num_counters so the over-sized allocation can no longer
be requested.

The allocation is still kept outside the ebt_mutex, since vmalloc() may
sleep and trigger reclaim; only the bound is tightened.

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 6ac4ca32fdbfe..f585b516bca79 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -39,6 +39,8 @@
 #define COUNTER_OFFSET(n) (SMP_ALIGN(n * sizeof(struct ebt_counter)))
 #define COUNTER_BASE(c, n, cpu) ((struct ebt_counter *)(((char *)c) + \
 				 COUNTER_OFFSET(n) * cpu))
+#define MAX_EBT_ENTRIES (((INT_MAX - sizeof(struct ebt_table_info)) / \
+			 NR_CPUS - SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
 
 struct ebt_pernet {
 	struct list_head tables;
@@ -1125,10 +1127,9 @@ static int do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -EINVAL;
 
 	/* overflow check */
-	if (tmp.nentries >= ((INT_MAX - sizeof(struct ebt_table_info)) /
-			NR_CPUS - SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
+	if (tmp.nentries >= MAX_EBT_ENTRIES)
 		return -ENOMEM;
-	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
+	if (tmp.num_counters >= MAX_EBT_ENTRIES)
 		return -ENOMEM;
 
 	tmp.name[sizeof(tmp.name) - 1] = 0;
@@ -2264,10 +2265,9 @@ static int compat_copy_ebt_replace_from_user(struct ebt_replace *repl,
 	if (tmp.entries_size == 0)
 		return -EINVAL;
 
-	if (tmp.nentries >= ((INT_MAX - sizeof(struct ebt_table_info)) /
-			NR_CPUS - SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
+	if (tmp.nentries >= MAX_EBT_ENTRIES)
 		return -ENOMEM;
-	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
+	if (tmp.num_counters >= MAX_EBT_ENTRIES)
 		return -ENOMEM;
 
 	memcpy(repl, &tmp, offsetof(struct ebt_replace, hook_entry));
-- 
2.53.0



