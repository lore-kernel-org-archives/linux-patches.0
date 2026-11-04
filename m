Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829371;
	b=KRnwxLGM/sAdhIO/SG/B9AWolaZOzMzsxE/4/4NXO5Zl2+uLd+MH0mYeXJjuNYKw5sgG
	 Vb3Y7RtB19ijfapdY32SepC/lFclyejL0BJnzoC79/toN1lpxJy38cyYulp3frq+qjw/D
	 WjUwuZoZjnHUQKh0td8rqxmW/YXc+fsEPE0LE0k3BM2hrxvMaebRj1VF5doOIag9cUMCX
	 SaCb6slvqeWpveFw0LuiWT7dooXKMmy9e2jv22+fzgjSeob2gyOJT4k2Axg5T/h63qIAl
	 B8KD8qliPx0Ma30cWEgRDWMHG/+nQICc7BH82/7bqSn7AARWFLmWdi2WhtJqPAqmzxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gt7Z7HC1OGc0kx68NW4L0oI6P6pfSRjOiu45TWl6yT0=;
	b=RwxKXXFkZE3P2wo7leJ3w7wmmpy95mPeiJIns0bh+VQgpWgrveZzLVyg9Sze/lnbHWoI
	 D80d5DLgnbwoyQtKIoatcZVhDEPcNVzb70du4lenuTCIweuIvXpnOA1joc7mLjWgCU6hU
	 jI3dfjogKfhXrggR6RmiZVEroSOx6qK8XWneedp1+lVNzkE28a8uZa8M4uIsHNRg0jW4G
	 YY6Q6XKZrVv4weTpkyAjBO53tkRomjySWHTnj5xkb8nekwLReuk6a6vnMKqYX8igVbW8g
	 ZuGLuWyzS3+/z8mCTzKR4zvfLn6OD3FtMGeIAIKNGAtgXCGNWiYKGTS8YlYjkh5xH3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTBKARny;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A35F606AB08;
	Wed,  4 Nov 2026 21:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTBKARny
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A46B1F000C1;
	Wed,  4 Nov 2026 21:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829371;
	bh=Gt7Z7HC1OGc0kx68NW4L0oI6P6pfSRjOiu45TWl6yT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTBKARnyxPYNB1sy2sHWd5+JN1nGX+1rFCRM5mR2jlr85sN+Xf7AEQ5rz73YF5iha
	 eibv1qLS37ul+R5hlfdv2BsW55zJxU1ukpxzWaMXir4U51D/seG1sLq/syONkV73ho
	 PFz9f+31NNm9tSjkNLZOsol+e3hBTv+GujzqwA1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0083/1005] netfilter: ebtables: bound num_counters like nentries in do_replace()
Date: Wed,  4 Nov 2026 15:56:56 -0500
Message-ID: <20261104211045.952831033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



