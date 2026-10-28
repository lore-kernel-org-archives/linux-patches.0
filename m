Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211895;
	b=ZFrAIZZNeB7k3c2AcRAsLL4dBZ8O+N9zgyOlgfipbcZimfe494Wjl3/mryVVfn/+WmGK
	 OCumcCK5EXr700CNbONFCiHo2462lfCXSu+MSGUveNeU+Ir5ptA9sIPoWAZRPup0NDe2D
	 RzNoLl4+0zwReQo6YV0NeEX8Y8oUn1dfS1BqdRCMTxR5TV8xda1o/pWWeroNjEdxWyT8B
	 ZHy4EPBwwpWUM3rvQllpsVbc7jEFoECh+puJUB4CRyWKHCL2sGtlnMHzkOZs4zmO4Hl8r
	 NHaIz8uotc1BGVk0Vu/ayQ8AA3MkBjC9w6vBdNSdfMCnyacUyk89lot7KolrCGUz2tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HmUAUDPp1/CJKY2YhAlMeXaJRM23TQd/cMg5Jl/Rjb4=;
	b=a8RaI9RVBzQQTbe5WkoXWoVKu9gi9I7tYf6FTn3ivQNItg/flaESGUv3xbNxaC0u0Ryr
	 cqZb2FmVv58PxVugeXPpHLJMeu731HhSRoYa/BCZKZNbkKDC6i6oNHsq62gQ8mht3QwJX
	 HSGrWA3LEdEFEnVvcMrHl22augFURob2AcgFS/U3SNOPi1yFIMXAt6w3+krpOemMXc4pa
	 eIeSMvlQQFjEaf0FFeiE1yduIQt2Vdkobopdl9IqI0HVBaOONgoF0jpIWqb4mqdhZ2Zz9
	 Zl0Zw/yHEfZ8cu+Gbd8U4FO4eG+IWciejDZDM6/w7Kpa8XNLZc5XaHbQO8RwqcAY9Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOmJjpPN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CD6606A31C;
	Wed, 28 Oct 2026 18:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOmJjpPN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFB71F01825;
	Wed, 28 Oct 2026 18:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211894;
	bh=HmUAUDPp1/CJKY2YhAlMeXaJRM23TQd/cMg5Jl/Rjb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOmJjpPNKOd34xfVLO2seGRKURiQ0eZgZc5mUIs0A9q/KYrcnlq93n+3ex0xlKi3x
	 APw/mtr/JSve7HyMco3LklZfQ/Rx3GwHj5XmPzU+uAe2NUSP/xngTCV8ppH+EmBaoK
	 ehF9yiewEX0dTUrnwzRcXjbUKDGhE/Mz5SwFL96Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 538/571] netfilter: nf_tables: always walk all pending catchall elements
Date: Wed, 28 Oct 2026 18:01:25 +0100
Message-ID: <20261028170020.801099054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7cb9a23d7ae40a702577d3d8bacb7026f04ac2a9 ]

During transaction processing we might have more than one catchall element:
1 live catchall element and 1 pending element that is coming as part of the
new batch.

If the map holding the catchall elements is also going away, its
required to toggle all catchall elements and not just the first viable
candidate.

Otherwise, we get:
 WARNING: ./include/net/netfilter/nf_tables.h:1281 at nft_data_release+0xb7/0xe0 [nf_tables], CPU#2: nft/1404
 RIP: 0010:nft_data_release+0xb7/0xe0 [nf_tables]
 [..]
 __nft_set_elem_destroy+0x106/0x380 [nf_tables]
 nf_tables_abort_release+0x348/0x8d0 [nf_tables]
 nf_tables_abort+0xcf2/0x3ac0 [nf_tables]
 nfnetlink_rcv_batch+0x9c9/0x20e0 [..]

Fixes: 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
[ Backport to 5.15.y: 5.15 still passes a struct nft_set_elem to
  nft_setelem_data_{de,}activate(); only the break statements are
  removed. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b4c3615a2bf6a..6a6b42923f504 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -627,7 +627,6 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 		elem.priv = catchall->elem;
 		nft_set_elem_change_active(ctx->net, set, ext);
 		nft_setelem_data_deactivate(ctx->net, set, &elem);
-		break;
 	}
 }
 
@@ -5172,7 +5171,6 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 		nft_clear(ctx->net, ext);
 		elem.priv = catchall->elem;
 		nft_setelem_data_activate(ctx->net, set, &elem);
-		break;
 	}
 }
 
-- 
2.53.0



