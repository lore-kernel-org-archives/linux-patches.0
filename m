Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A993919F462;
	Thu, 15 Aug 2024 14:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730847; cv=none; b=JGFRAAUsm7HBBp2hzhegzU4yyLv85NXsWejsSvb8JuIjit5MNd/RV/8PzgOfvU52krnCmbUJrQGAYDzPVWL0Oo02sEvWOELJshRl//UcNJZaIzz4xiEsP1QjJI+rzukJw94RJytIeMz40dmzAL3A/X3Iw5ZyAfKBzeek88gdp0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730847; c=relaxed/simple;
	bh=1FgAAeaIUS3/nAoOTwpudwmNvk8kx0/uaUhx3iC26Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfpxROk5AOWOmL41BYEAaugxcFi5va1GULk1YjmoUPETyQTEuEYfmBrMRRjOWhW1NQE439bEswg1YV+1nezbpbbEFwEB6FbS9TZXERvR62vYJIPQbW+CrRpL3xyhbFmWYu+Y87LklmP6I8a52tJ+6Ie6qEc6oHq80qHEewZUMtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXCHqkt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXCHqkt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7D5C32786;
	Thu, 15 Aug 2024 14:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730847;
	bh=1FgAAeaIUS3/nAoOTwpudwmNvk8kx0/uaUhx3iC26Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXCHqkt7ROeNmk5KWIxQxnnH8anDQXKH87uRNKlJUqrWUfBhXvLWKWIpnA0brPGwN
	 l1iNZWKy+vho1izE/JR07nldWvQ+Qg0fup7wS6gEXP3gx2IjCaIK38fnseku6Icc1O
	 luxTRXwPEd4wT3/8nj6Ee50Upmu591QxCNa8Qm00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 12/67] nfsd: rename NFSD_NET_* to NFSD_STATS_*
Date: Thu, 15 Aug 2024 15:25:26 +0200
Message-ID: <20240815131838.797295238@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit d98416cc2154053950610bb6880911e3dcbdf8c5 ]

We're going to merge the stats all into per network namespace in
subsequent patches, rename these nn counters to be consistent with the
rest of the stats.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/netns.h    |    4 ++--
 fs/nfsd/nfscache.c |    4 ++--
 fs/nfsd/stats.h    |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

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
 
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -690,7 +690,7 @@ int nfsd_reply_cache_stats_show(struct s
 		   atomic_read(&nn->num_drc_entries));
 	seq_printf(m, "hash buckets:          %u\n", 1 << nn->maskbits);
 	seq_printf(m, "mem usage:             %lld\n",
-		   percpu_counter_sum_positive(&nn->counter[NFSD_NET_DRC_MEM_USAGE]));
+		   percpu_counter_sum_positive(&nn->counter[NFSD_STATS_DRC_MEM_USAGE]));
 	seq_printf(m, "cache hits:            %lld\n",
 		   percpu_counter_sum_positive(&nfsdstats.counter[NFSD_STATS_RC_HITS]));
 	seq_printf(m, "cache misses:          %lld\n",
@@ -698,7 +698,7 @@ int nfsd_reply_cache_stats_show(struct s
 	seq_printf(m, "not cached:            %lld\n",
 		   percpu_counter_sum_positive(&nfsdstats.counter[NFSD_STATS_RC_NOCACHE]));
 	seq_printf(m, "payload misses:        %lld\n",
-		   percpu_counter_sum_positive(&nn->counter[NFSD_NET_PAYLOAD_MISSES]));
+		   percpu_counter_sum_positive(&nn->counter[NFSD_STATS_PAYLOAD_MISSES]));
 	seq_printf(m, "longest chain len:     %u\n", nn->longest_chain);
 	seq_printf(m, "cachesize at longest:  %u\n", nn->longest_chain_cachesize);
 	return 0;
--- a/fs/nfsd/stats.h
+++ b/fs/nfsd/stats.h
@@ -81,17 +81,17 @@ static inline void nfsd_stats_io_write_a
 
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


