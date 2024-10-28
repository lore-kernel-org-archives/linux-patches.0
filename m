Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8754318E04F;
	Mon, 28 Oct 2024 06:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097624; cv=none; b=PNETKiFGost5zXtfNHcynY0UppNkXhzp2uUDixU3mc6JRyv6dBVSpJRN2TeG7d3F2LD5Ls2G6QL7mh44JCnlQy9AYs+KuBBtAuZH5EOEo8fFYfYeO9/VHV7QKyFI3uxIwFJObncYcLcBMAT2NCZl3n+L3zfxmS7/T96/11IgW14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097624; c=relaxed/simple;
	bh=kN0GKVAcQ73FxpqvwrHE/6QO32rMm6Mb+MKiC2qt0dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVC3CjxSFLzBcPxjszuJVywJDgW8cubM1rdo7jFoNI3TySIvfbuMhOObxHqMljXYfioi+I9Zt8uw5vw2dzjTcAnB7HKzQFEsaCtAcxGHotdT98Sj6IAWwWZL47r9kEyh+kow7YMy9MLdNcfGhdv1T4pPm1l7vT3u6EhpreGOlQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8/Dz3m1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8/Dz3m1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A251C4CEC3;
	Mon, 28 Oct 2024 06:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097624;
	bh=kN0GKVAcQ73FxpqvwrHE/6QO32rMm6Mb+MKiC2qt0dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8/Dz3m1DLfJm0NMTtSeGgPrXQuHEyopqyQcy5sEw6z1uK2eDaIDNKR8YiWdBmnaU
	 UoY2glMLpyUvVKffp/+7Q13etDPszCsDHX1P1EthOxz5ZEOoX8OUW4G4pYRBsjeZRR
	 XdxucaRV6TWGIMIJWULrxShvtcjGyTEt1wGrL1aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrone Wu <wudevelops@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Florian Westphal <fw@strlen.de>,
	Daniel Xu <dxu@dxuuu.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/208] bpf: Fix link info netfilter flags to populate defrag flag
Date: Mon, 28 Oct 2024 07:24:16 +0100
Message-ID: <20241028062308.517603959@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Tyrone Wu <wudevelops@gmail.com>

[ Upstream commit 92f3715e1eba1d41e55be06159dc3d856b18326d ]

This fix correctly populates the `bpf_link_info.netfilter.flags` field
when user passes the `BPF_F_NETFILTER_IP_DEFRAG` flag.

Fixes: 91721c2d02d3 ("netfilter: bpf: Support BPF_F_NETFILTER_IP_DEFRAG in netfilter link")
Signed-off-by: Tyrone Wu <wudevelops@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Florian Westphal <fw@strlen.de>
Cc: Daniel Xu <dxu@dxuuu.xyz>
Link: https://lore.kernel.org/bpf/20241011193252.178997-1-wudevelops@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_bpf_link.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
index 0e4beae421f83..96015a59db09e 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -150,11 +150,12 @@ static int bpf_nf_link_fill_link_info(const struct bpf_link *link,
 				      struct bpf_link_info *info)
 {
 	struct bpf_nf_link *nf_link = container_of(link, struct bpf_nf_link, link);
+	const struct nf_defrag_hook *hook = nf_link->defrag_hook;
 
 	info->netfilter.pf = nf_link->hook_ops.pf;
 	info->netfilter.hooknum = nf_link->hook_ops.hooknum;
 	info->netfilter.priority = nf_link->hook_ops.priority;
-	info->netfilter.flags = 0;
+	info->netfilter.flags = hook ? BPF_F_NETFILTER_IP_DEFRAG : 0;
 
 	return 0;
 }
-- 
2.43.0



