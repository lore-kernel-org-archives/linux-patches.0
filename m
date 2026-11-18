Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051612;
	b=DeEnJgrQVwBoxYElAfCeRz888OlSLdXQ3Uh7onAZL+Y0Ms0QduTa/NjysqHoHSRF2y8e
	 MvSkshJvTeebt55uAHeEdcVPwDY3eRkZWkpURsdSxyOIdDTdQywY0VDRaXGQeYnOlW0eZ
	 rzoEUPFSZj/NdyuIKQd+oomHL23+DVfe6dcwL/fOG8NaOTZbYuy3qPHq0LFVqzX+8hmQ6
	 K2aLpS3i8Ychlkxs+m2tTggvqfMtcKF3fIPtmF5dalZqt15zwORFep0AYk7u3YVSwWfHq
	 Qr0i+JfAIsWEzm983tcG1ROImuWzuFfox7yQwmI9MjH/3dLweDy+Zm2pMGmM+yorTaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rq/xFwHd/ABPDG5JJXw0ggVTz4Tafop/BQX40xbTpug=;
	b=hREs5b+hxMOnElb8DA5JbHudLyINEcgnG+MhL+X3bnAvljuh7H7K2deQwCFcoZhIbT2v
	 jRSl+8zFQIurjeTQ/DueDz2ADGW9jXot8u0O4UwiKhnlYA3xxv0jajnJMkqqs4L7cD1or
	 IpW7U4MFWzMJjsWrOB8N960tpwql8wFBf0sGMfLnxYTV/F+tBQ7RUytkfQWnrFSwHtxE5
	 uFp6pDwjbB4gF9KGoMBfEsaqxsTSg1tQ+Xq1cgv8Kkxos/IUa6/O1WmYxCIj4l4hLjRaq
	 5AzBuwgIU9h8JXmIsFz3GMxMOq02UIhFUklrL8ZeoYRlV/wTTX3vyvGKJpo5k1qGiPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13uTiZoz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D6C606A31C;
	Thu, 19 Nov 2026 01:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13uTiZoz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205DF1F000C4;
	Thu, 19 Nov 2026 01:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051612;
	bh=Rq/xFwHd/ABPDG5JJXw0ggVTz4Tafop/BQX40xbTpug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13uTiZozVmjkqqUhOFmSciwloLoIHCIYcq8zNDpsr8iyczSq2rvlsi3PYlhPJgIjf
	 6WEwLrKoKb/NVHXAn5wEjIA4pllkyPaU9AufPBn1H4xwJp0WzN/NuqTibGRX8GLR7O
	 iYWHH3BBvz9rhujl4flg7COGiUHGboxKTg6N4fzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inseo An <y0un9sa@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Anand Khoje <anand.a.khoje@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0271/2214] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
Date: Wed, 18 Nov 2026 15:32:27 +0100
Message-ID: <20261118150020.919611362@linuxfoundation.org>
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
index f2332b097745f..c12b2ded65193 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2451,6 +2451,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 err_use:
 	nf_tables_unregister_hook(net, table, chain);
 err_destroy_chain:
+	synchronize_rcu();
 	nf_tables_chain_destroy(chain);
 
 	return err;
-- 
2.53.0



