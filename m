Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042981;
	b=fi4ddG/27AYwpRI++b0/kzpUQpfh+8b7siJQ1wOB0T0wVVKWyIN9KXeYdjP7NCWX9xiW
	 R2Tlo1H9zi/631I2AQfnMJuG3OL5SEWGkc99k8VXfU2qpb8Hd6a/iIqC9cqgjXvU3artq
	 0im4AAHaLi3UtLn1U4fT1U5EwpOz1Uj94b7cm/6kYS5y1wqjkK7LNCyWn0vL5iYPBiaeL
	 ci9uuO/gM/8LF0LbxrE2TjeLpJaIb/PpeHe0qSrrNV5WHeTPh3a3yi3ftjup1rj4HTXmH
	 BjnkDAaBEBh9MJuuTYCIB6RuMRQ9VebAl6yO0q+miHArbpLnt3bOnOMflzsRJout+UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WMShDaW6S5i7718CIV+b8FvHDIXmjuRtcqg3UF3SqoQ=;
	b=F7hDxG8/sHKgJU1zgBn47wZAfJGSymrzXgP1dCsEAFay2ohX9JfMeWxgLFw8B1feqYEa
	 K/Q1kxJkodYNccAjQ0tlZGtDW9OSDOtAuldUKqbAO9JgG+T1g1U8qy1lgRHmS+2bGBlIA
	 em+mGxYA/hNQgvoZclKE4Kk+YledwgjWmPSB+uFqpSOWs9wWbCERfTT/chflQSqz9RBFU
	 ps2NOUhrJ04ui0Tn0RYh6VIKun+jbKHawe3t7aH9x9hMzlM8Qvo3tvqaW9jkaA/n/9Df0
	 fhmlJkH34aTSQZJsg5V00WWNPGV/HD86ARd3GSo/wIgdZOdD2x8m5NaYIa89/Dl15+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rTR33GEu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551EA606A31C;
	Wed, 18 Nov 2026 23:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rTR33GEu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB8F1F000C6;
	Wed, 18 Nov 2026 23:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042981;
	bh=WMShDaW6S5i7718CIV+b8FvHDIXmjuRtcqg3UF3SqoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rTR33GEuhosG4Y9+W7IoeBmwkD+U6HYhkpqerhijvqxC1MF88uIJRZDWSTl8uEzn8
	 SoGJZTHslz7GyQxgLk5lvNCLYFRT7zhFGbxkqgFxkbGJhzvDnTZnwMqGHcidljntqv
	 7RnrmwSLCBVzPBUABuDJUiU9FAAdYMPktGuvbLyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0047/2857] netfilter: ebtables: bound num_counters like nentries in do_replace()
Date: Wed, 18 Nov 2026 15:18:01 +0100
Message-ID: <20261118150203.017710679@linuxfoundation.org>
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
index b1846d5c879a5..93dc1f11b2bed 100644
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



