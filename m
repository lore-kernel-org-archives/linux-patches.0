Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033564;
	b=TyphGBeMypVzNQ3nl1n/v0uesb44dfNlpNrvq4ojENyAL0dr5/0+tOZHMyEjFIyPRkVb
	 tzGBxMyNXqHfhG2YTPNQq11bTpdLVy5qT3lXwLf1KqCfBCcNPQ36Hpfv2tvETkPhdR1BQ
	 Pg4/XssdqbXdrvgnmMUdrjeSVnRzJoKgvC0D4fNVgPBc+nOzNpqm6xHIuN2cjf2YMvIVh
	 PeqBtiWFSFxJCRpEEOM7QLZ0hQBNvsX/NIW90Vk+q8ryARcZ3JsmaaFcVO5FN5Fm9LcIf
	 umwif/DV6rfsPqlCTWivZs7KJaMugVGU1va1z4eerJkkL6cn/MXTfz6uWR+t8Oho7IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OVbfjGPyTEbVJUs3xe+7CszssycRRDvIemDUcqtE1a4=;
	b=rJFMBsewX+Ci6s7e39Wh0kCfTFXgm2useUoFFkSmOnl4lcjdsGQFheJBEfZtPhYqXeXo
	 LhKzsJfVHK4wEzEyxfEZLyhMCYbUKQKE91gNegN/chOJ4mKtI+xhoQ3e1+ITrYlvHJH2d
	 ldJD1j3D0xESYfDBEGNF3m9uAFJi3scgxBZy2rge9G/90xHDXUamFw9lI5Ao4ff4iaPr2
	 9kWRR4IqpydVtuTSOTb7wotQnFBUt1WaOQKl2yHUTXKQF+F2dCqT7ec7FoCKZUNsCZpuw
	 iG51aPu4QemyFqsFmTIxMwsfuAOHahw1osAtY+iu1WalyJbpRFKwcJsp5pb+yVObZIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Stq4cCEV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E465606A31C;
	Wed, 18 Nov 2026 20:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Stq4cCEV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CD51F000C5;
	Wed, 18 Nov 2026 20:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033564;
	bh=OVbfjGPyTEbVJUs3xe+7CszssycRRDvIemDUcqtE1a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Stq4cCEV0laAsfNDM//HxFiBOnno1KrYo82Od2xc3tQZbb60+KOlsTzHXukvSVKKr
	 3D/T6G9eiG1ydb85w2GXwxUXtMZVPdWYOETTzrRoR9EzvYGzraXT2yJJM2LuVnxSkG
	 UIj/Z7JWmaSyAGgLmu5qgWv7l4Xm2M3mjYxc3hQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0058/3318] netfilter: ebtables: bound num_counters like nentries in do_replace()
Date: Wed, 18 Nov 2026 15:11:20 +0100
Message-ID: <20261118150315.699306335@linuxfoundation.org>
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
index b5db2d08e0068..c68325568a4a1 100644
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



