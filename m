Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7790012CD89;
	Tue, 14 May 2024 10:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682129; cv=none; b=UKWIgdgqN59ycg40zqcxJORyCoo/LIDNIqMeeBwQm676HGBOiV9ThOkI9zUBKx1BiSO7jEqgfyIDLOPu8Uun+VH9tP1VwFKOukDijKM5O+Dp+MV7wv88hiOITnrMc4GtMFMLWFFWx3F96Nbu8uJuQT3rX+jz2DITzUsr2wP3Cxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682129; c=relaxed/simple;
	bh=4BDLu7fOpLYlV+JksZVtT2KNy09N4fVhRAlAh671pKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SeT/8upR5gAg4M5OzEq70mVmbkM/ct1MrL6hQ5EIqflX2vevWHcGu70HF806SYyHehPRyTrRtmI2WV8lWp1ujdX3WeUkUYHJGnmuTu4VnzOj9qkWIM6W9WGZBA79Gr5DXyoTnGK/orzDD1IBWb33sTANka6EvuKsBOI2LJIdXlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RA1zGp0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RA1zGp0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EA5C2BD10;
	Tue, 14 May 2024 10:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682129;
	bh=4BDLu7fOpLYlV+JksZVtT2KNy09N4fVhRAlAh671pKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RA1zGp0uGa8T1bywx9s9WBIX3WtbpVeIZzGTcj1d122fbxWfgOLfVWd3OgL7or8ZX
	 wbdOwWJ/y0liAF4IS9Dg8vsw8+bqhogfQgS2FPAUWTtdh8IqactWQKE+M3EzEb6AWW
	 VS6caPffOXD0VgmEd/c+lHNpuwWwKTwSi6APbACA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 017/336] nfsd: rename NFSD_NET_* to NFSD_STATS_*
Date: Tue, 14 May 2024 12:13:41 +0200
Message-ID: <20240514101039.257066747@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit d98416cc2154053950610bb6880911e3dcbdf8c5 ]

We're going to merge the stats all into per network namespace in
subsequent patches, rename these nn counters to be consistent with the
rest of the stats.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 18180a4550d0 ("NFSD: Fix nfsd4_encode_fattr4() crasher")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/netns.h    | 4 ++--
 fs/nfsd/nfscache.c | 4 ++--
 fs/nfsd/stats.h    | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index 74b4360779a11..e3605cb5f044d 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -26,9 +26,9 @@ struct nfsd4_client_tracking_ops;
 
 enum {
 	/* cache misses due only to checksum comparison failures */
-	NFSD_NET_PAYLOAD_MISSES,
+	NFSD_STATS_PAYLOAD_MISSES,
 	/* amount of memory (in bytes) currently consumed by the DRC */
-	NFSD_NET_DRC_MEM_USAGE,
+	NFSD_STATS_DRC_MEM_USAGE,
 	NFSD_NET_COUNTERS_NUM
 };
 
diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 5c1a4a0aa6056..3d4a9d181c43e 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -687,7 +687,7 @@ int nfsd_reply_cache_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&nn->num_drc_entries));
 	seq_printf(m, "hash buckets:          %u\n", 1 << nn->maskbits);
 	seq_printf(m, "mem usage:             %lld\n",
-		   percpu_counter_sum_positive(&nn->counter[NFSD_NET_DRC_MEM_USAGE]));
+		   percpu_counter_sum_positive(&nn->counter[NFSD_STATS_DRC_MEM_USAGE]));
 	seq_printf(m, "cache hits:            %lld\n",
 		   percpu_counter_sum_positive(&nfsdstats.counter[NFSD_STATS_RC_HITS]));
 	seq_printf(m, "cache misses:          %lld\n",
@@ -695,7 +695,7 @@ int nfsd_reply_cache_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, "not cached:            %lld\n",
 		   percpu_counter_sum_positive(&nfsdstats.counter[NFSD_STATS_RC_NOCACHE]));
 	seq_printf(m, "payload misses:        %lld\n",
-		   percpu_counter_sum_positive(&nn->counter[NFSD_NET_PAYLOAD_MISSES]));
+		   percpu_counter_sum_positive(&nn->counter[NFSD_STATS_PAYLOAD_MISSES]));
 	seq_printf(m, "longest chain len:     %u\n", nn->longest_chain);
 	seq_printf(m, "cachesize at longest:  %u\n", nn->longest_chain_cachesize);
 	return 0;
diff --git a/fs/nfsd/stats.h b/fs/nfsd/stats.h
index 14f50c660b619..7ed4325ac6912 100644
--- a/fs/nfsd/stats.h
+++ b/fs/nfsd/stats.h
@@ -81,17 +81,17 @@ static inline void nfsd_stats_io_write_add(struct svc_export *exp, s64 amount)
 
 static inline void nfsd_stats_payload_misses_inc(struct nfsd_net *nn)
 {
-	percpu_counter_inc(&nn->counter[NFSD_NET_PAYLOAD_MISSES]);
+	percpu_counter_inc(&nn->counter[NFSD_STATS_PAYLOAD_MISSES]);
 }
 
 static inline void nfsd_stats_drc_mem_usage_add(struct nfsd_net *nn, s64 amount)
 {
-	percpu_counter_add(&nn->counter[NFSD_NET_DRC_MEM_USAGE], amount);
+	percpu_counter_add(&nn->counter[NFSD_STATS_DRC_MEM_USAGE], amount);
 }
 
 static inline void nfsd_stats_drc_mem_usage_sub(struct nfsd_net *nn, s64 amount)
 {
-	percpu_counter_sub(&nn->counter[NFSD_NET_DRC_MEM_USAGE], amount);
+	percpu_counter_sub(&nn->counter[NFSD_STATS_DRC_MEM_USAGE], amount);
 }
 
 #ifdef CONFIG_NFSD_V4
-- 
2.43.0



