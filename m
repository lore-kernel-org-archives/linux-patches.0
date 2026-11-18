Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057819;
	b=fkhDcar/LBN1OMKJ6ahBuTChiJKZK9aWFJxHb7qWJUfMW1QFpuXeesy720Ktrvkcr5Os
	 LLi5eaoJEzshQe0K11DYp23BCKMx4bovpIXiE9nysPct5Qo6g9NeoBpNqQlR7cVglm/f2
	 Uu+f5E8zlVuMJ1GOirRM9Bg+aZQSyB99GIxxAacOaB7SVMXjy5OT6HTcTeSqHCXzzQWl9
	 cz6MOtwhA9uYmrktAYtEM1qw8d9xIcGD/pfCso9IVNA7U5jNPql/rwGpOv+FWwjCpFA69
	 BbgPnQ3CT6jz/SMpggdU9lIV8+i3XI97DXSOMTdWnPZrQxj4U2Sw/j9nZiT5Z/VnvSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/EKOn9BW5ZSmKMcpmMawq6/MdRdjm++zO8GyigR0jPY=;
	b=N0rMys4HxzzVU0iJivAPy5VfNRKxEAhOR3yThtvqzu+2+Hn044d4zfYTvUZcUl0lowtk
	 Gu63aPvs9NFS5R5dmVgfQQm1C8zhbxzqrMYywCX74NkklSAGasRRAM9Gvwt2OX7afD02o
	 uyr2aAJWlsz/7+lijaAIm8ltw6IO6c7rMUR/dG/0YmYVhBq64fNyG3uRpKQjBfSQPBifu
	 m0JKcn8Udf00X3wTB8rWRfOC7QKi+tCVpO9vMpwITCAy1whjqf0Er/BWar82Ww5MFzyZK
	 VdQf9+b8VHmhzxgHT+sXGCZv5D8/mV+rsa93y3C5HmQsILJZI4SP7exebArbSQ6hFWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5tOFGOf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496E3606A31C;
	Thu, 19 Nov 2026 03:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5tOFGOf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD711F000C4;
	Thu, 19 Nov 2026 03:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057819;
	bh=/EKOn9BW5ZSmKMcpmMawq6/MdRdjm++zO8GyigR0jPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5tOFGOftx6W+QPsVci1f5fYRS5O6RoKLFnTtXQOUhRRoXVFT0rJsDQrMXcNriGyv
	 rVzndnsd5Y3D4T3ZvrrJhsN0NS25BfoWnoGuym5HkGSyyLfNPO3fnAFKGbhBL7wa6Y
	 a11No0AjOql+rLZSIJ8Z2qVnozw38mklfNlkyD+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inseo An <y0un9sa@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Anand Khoje <anand.a.khoje@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0224/1848] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
Date: Wed, 18 Nov 2026 15:37:42 +0100
Message-ID: <20261118145921.343842483@linuxfoundation.org>
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

From: Inseo An <y0un9sa@gmail.com>

[ Upstream commit 71e99ee20fc3f662555118cf1159443250647533 ]

nf_tables_addchain() publishes the chain to table->chains via
list_add_tail_rcu() (in nft_chain_add()) before registering hooks.
If nf_tables_register_hook() then fails, the error path calls
nft_chain_del() (list_del_rcu()) followed by nf_tables_chain_destroy()
with no RCU grace period in between.

This creates two use-after-free conditions:

 1) Control-plane: nf_tables_dump_chains() traverses table->chains
    under rcu_read_lock(). A concurrent dump can still be walking
    the chain when the error path frees it.

 2) Packet path: for NFPROTO_INET, nf_register_net_hook() briefly
    installs the IPv4 hook before IPv6 registration fails.  Packets
    entering nft_do_chain() via the transient IPv4 hook can still be
    dereferencing chain->blob_gen_X when the error path frees the
    chain.

Add synchronize_rcu() between nft_chain_del() and the chain destroy
so that all RCU readers -- both dump threads and in-flight packet
evaluation -- have finished before the chain is freed.

Fixes: 91c7b38dc9f0 ("netfilter: nf_tables: use new transaction infrastructure to handle chain")
Signed-off-by: Inseo An <y0un9sa@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>

(cherry picked from commit 71e99ee20fc3f662555118cf1159443250647533)

Conflicts:
 - Only race 2 can be observed in this codebase.

Signed-off-by: Anand Khoje <anand.a.khoje@oracle.com>

Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cde499274fd37..6560da6b0b2eb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2372,6 +2372,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 err_use:
 	nf_tables_unregister_hook(net, table, chain);
 err_destroy_chain:
+	synchronize_rcu();
 	nf_tables_chain_destroy(chain);
 
 	return err;
-- 
2.53.0



