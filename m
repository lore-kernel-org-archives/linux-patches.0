Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9838837;
	Mon, 28 Oct 2024 06:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098142; cv=none; b=BWBzFVmPttWdR1oDGtJAYt8oDGOiDpUR5YfpDM4MZkSmGRaLidAdY2x81hn2K+jT8WeQbOYMvCo8ExYKAKFN7Wu6HMGgZEfDfX4OS+Iy/J+Ywsj8cwBW8v4cK9TsaBu2NGzJoDvnn2F/XU+2R9M35s8C4BMn3+1hgIqgPNwLnBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098142; c=relaxed/simple;
	bh=PVoVp7jtqi4jLGvnoyF6Nq8Hyj+0yIUw1EYHZjBvTjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZTZBckXUPO9oeGUVXiJ2XoaKYzZzd0p7tura46TzTzPDHav6XGj0kIxJvWgYXKu4NN3iwszcZrxfculQE6C4Bb6wcDdwvzpZTpvNn2t0fL7NRq/VQtM0y2xF6nMO+OShF1MrRE7bpkOKgU+GFVPXplbT6fYvSOrba2twF3mewQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tk4v/UxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tk4v/UxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC52C4CEC3;
	Mon, 28 Oct 2024 06:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098141;
	bh=PVoVp7jtqi4jLGvnoyF6Nq8Hyj+0yIUw1EYHZjBvTjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tk4v/UxBdDup+OgLIl1HUQOhDl68bOwug/g7AqwSQfw7cLlCCqbcaCmsKKj6mR+r6
	 JamVLivDa6WtN5rB9muXZBKcNi+82kn2YyNr5BwHbahIFRQfwg+Rgzms38//yz1E6Q
	 BFHgu0V6SpWjqm2lzFIfslsFRmf6ldfOB6wsSjT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrone Wu <wudevelops@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Florian Westphal <fw@strlen.de>,
	Daniel Xu <dxu@dxuuu.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 094/261] bpf: Fix link info netfilter flags to populate defrag flag
Date: Mon, 28 Oct 2024 07:23:56 +0100
Message-ID: <20241028062314.385300788@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 5257d5e7eb09d..797fe8a9971e7 100644
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



