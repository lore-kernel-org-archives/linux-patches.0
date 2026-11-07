Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060623;
	b=JpRzhDmNfbwH15fRNvccMAL3RWyfdELoCHe1+48/A7KnPOE9nhzhT5xgNRxBTWwtKL0f
	 I5x6bxBT4udSe46K0PkxPrO5S+eoPl1967iUAA3TLSYeboEMFEEp4HHlpZwlYxoV6Rlt/
	 glA7t/M5yIbLqBzA0W2o/bBHpCbKAVMZUhalpF3ld3euBTQk93mX/iqPuceEDuCJXEb98
	 dDwkgltYZZQsiWWjrZEfTcd0FpX5WajNXBOmX1bZonlyOZUTXoYXroMM55RKwdNbRLgS+
	 47OeqCfPg15ORcpSfyI/rfx4Vm9GX90gn7jx6XiBCWHYL/X6tXXiTmAo/jFiQdtSgvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ABDUt/yikOqR8nEZESJCtOIvFedUWoNpfppAcKA9YRY=;
	b=t4ImT19gQ+XA66TMzOolScFxRcGKa0khEYgUmoV4m6+mSdEXa+DAxP4ebxeSyCoK5JEC
	 KcSNBXMdgSN8EksFLFRwwBGqyE0LuYtv6AaOJZC86bpmbkv5AgvKb7x7htfSnVLnH1LnK
	 CPL02GTMqhaAHNxwPwlUajnpVQdJXTvnU1TvX2D5bovrIXNzwNbUnohdlqGNWqqglP1Sv
	 soBmd6JnumXq8vauzz2RVSB/dblmTTrEo4oB+GGJ+imXQu7ELBfKPpUbtTs2slldnTgeJ
	 IuhBZMunKLlJKensH/rAsWNie6HOcepG2aHzkR7G/9EBh5AIGf0H+nlu9lIec7gUMtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Op4pVX8H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F10F606A326;
	Sat,  7 Nov 2026 14:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Op4pVX8H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C111E1F0089F;
	Sat,  7 Nov 2026 14:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060623;
	bh=ABDUt/yikOqR8nEZESJCtOIvFedUWoNpfppAcKA9YRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Op4pVX8HETRW/gJrBVk47l9Ei33E7+LZyYef+gMrBQeDFK7uexBtvNK38pklJaLAX
	 F9TquMaM8yZjwunfbpL3avtYCW1LCyNuf7vyor252+o+soGO4+QRliXo3VCB8m21VX
	 NNfLxR/dbhzF2daTa6uno/1bytX7GsknI73TRn94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0070/1536] netfilter: ebtables: bound num_counters like nentries in do_replace()
Date: Sat,  7 Nov 2026 08:34:46 -0500
Message-ID: <20261107134959.636227823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 96176aa881117..5266f4d021c6d 100644
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
@@ -1126,10 +1128,9 @@ static int do_replace(struct net *net, sockptr_t arg, unsigned int len)
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
@@ -2269,10 +2270,9 @@ static int compat_copy_ebt_replace_from_user(struct ebt_replace *repl,
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



