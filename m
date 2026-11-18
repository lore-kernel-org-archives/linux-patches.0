Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032931;
	b=IYNo//ANqabD/l3RCdiiv7WMTkCgV0MQ4bU3IFhfzHH/1l6WnpFqID2EUHKAehbwODe5
	 enZQ1cK/y1ikhbZlhgzsIXggzKKU7oeaAp9tTmGF8ppgaa48OsUqsIKVGhJIjBDZHGKUW
	 v0BVG94KHOpv9JvTSUYKHBXAqxuOzm8KVnrE71wv6uAVBd9CBSImc4KNNyCLPeWK71lSL
	 DbqIp1yHs58tVzJozxtTfiAUm4pPfstBZqjzQsXRvqBMId2fjepoqQ5RR7jQuf1zhk/Gb
	 jGjo/G7I3cmI6RoY6MiyxI0mq83UFhArFZ9leZ9dsQbO5LWixK5OB7m5/JpZYX3MVAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uVNhzRttm4dBMtujqJCqpZ1Cb17kC28dZaAl9WzapDM=;
	b=vst8Fttv+tOzudSGYyX+a/GT8XStFAsIAgb2JFWf8XOfhOXX8c6jwlgPOCViOrbAkDvV
	 ZqEbtF/kwdDiYkp4ZhSxqV87hr1ysQ5ybuws6zMolts9Xf7OWKg7gTWpwsA9TTiYv7fu0
	 p/1JDJlFZ6fz5pppYJ13CTz5DbO5OyAfqcSr096SWQCWIgmV0MjoRYVW6p4rHdKEIcqgV
	 4E26b4EHpwkCuEGGbBWeZ+K/MH7CMJr37AWZ5rILzXDMJ0dEYqLW2rVrIH/Z4cOAoriFN
	 sE8DtNhQD6m28toygTilc3RxBJg5fMper9cEnYqSQV6J5YKnAoLGDwA6SyqEpAVNHvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CH2Nf9hd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17EA606A33E;
	Wed, 18 Nov 2026 20:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CH2Nf9hd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045C81F000C4;
	Wed, 18 Nov 2026 20:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032931;
	bh=uVNhzRttm4dBMtujqJCqpZ1Cb17kC28dZaAl9WzapDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CH2Nf9hdzESyfuw7nZUFFTtfjChTm9QOGEBgpwx5K+Pi1QeTpyzYIB8uQg0xc9/3V
	 SwTlzC15Rsa2vTEwSDMEwV9euHnK211+mXkyqd+uayt+/epdquuT7Pn7C/4aT4hDfD
	 ZAAk8kIW/uOI4r/gMlrz+ZuIYtj1+WgWsXLpD9QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1586/1756] net/sched: taprio: unwind the netdevice notifier if register_qdisc() fails
Date: Wed, 18 Nov 2026 16:01:53 +0100
Message-ID: <20261118150113.030748025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit c5234f89d7cb311880ef218cb7a969794a106678 ]

taprio_module_init() registers taprio_device_notifier and then returns
register_qdisc()'s error directly.  When register_qdisc() fails the
notifier stays registered, but the loader's failure path frees the module
image without ever calling the __exit function, so netdev_chain is left
pointing at taprio_device_notifier.notifier_call -- a function pointer
that lives in text that has just been freed.

register_qdisc() has two failure returns: -EEXIST (duplicate .id) and
-EINVAL (malformed cl_ops).  taprio_class_ops satisfies every checked
implication, so -EINVAL is unreachable and -EEXIST is the only reachable
failure; it needs a pre-existing "taprio" entry in qdisc_base.  In-tree
that is reachable only through bpf_qdisc_reg() (CONFIG_NET_SCH_BPF); a
module calling the exported register_qdisc() reaches it as well.

Once the notifier is left dangling, the next netdevice event that walks
netdev_chain calls through the stale pointer:

  BUG: KASAN: vmalloc-out-of-bounds in notifier_call_chain+0x650/0xb5c
  Read of size 8 at addr ffff80001fc5ab08 by task ip/110
   notifier_call_chain+0x650/0xb5c
   raw_notifier_call_chain+0x34/0x64
   call_netdevice_notifiers_info+0xa8/0x198
   __dev_close_many+0xe0/0x800
   ...
  >ffff80001fc5ab00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8

The shadow row is all f8 (KASAN_VMALLOC_INVALID): the read lands in
vmalloc memory that was poisoned when the module image was freed, and the
indirect call is unguarded because the only check, func_ptr_is_kernel_text(),
is compiled out unless CONFIG_DEBUG_NOTIFIERS.

Mirror the sibling sch_cbs.c and act_mirred.c, which unwind the notifier
on this failure path.

Fixes: 7b9eba7ba0c1 ("net/sched: taprio: fix picos_per_byte miscalculation")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261021155417.66254-1-phx0fer@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 54d0136dfe6c5..152bca7f55612 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -2573,7 +2573,11 @@ static int __init taprio_module_init(void)
 	if (err)
 		return err;
 
-	return register_qdisc(&taprio_qdisc_ops);
+	err = register_qdisc(&taprio_qdisc_ops);
+	if (err)
+		unregister_netdevice_notifier(&taprio_device_notifier);
+
+	return err;
 }
 
 static void __exit taprio_module_exit(void)
-- 
2.53.0



