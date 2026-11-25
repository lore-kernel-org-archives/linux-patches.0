Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624009;
	b=mROPqr2VJVmF6URgynPIPGV5WHqJTRyU+wx2dHqE+0M/PMbeXvWnO0DTQNXzG1thHRJ/
	 XFuIN8wk3WGP6a3WWw4M1edqGGvBLuXnkl/k0voSUNySUKf+6H3rnno62b2IyagzzHep9
	 7ghS0xCiDaSJf16O1ZT64eicn2qdnEgfO1Wn+TR6tc0A+J9yiRs/WOwb4LnK6lIXpfzdr
	 Jne0udPtFgEHYCG4GKDxJE8iACC5TXa1mubNwU63i2vCFQ90kof8fESMEUUiP83u0I8cd
	 wgNwnZw9+84jQ7+7gMpcCz0Fh1wJboUwnGqK7Alc9Oxyvz+iUHrCkZGTLqOtz8Q4qow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kKcKuNXF9N4f98pic5lch1wet7mOXvstHHlqOjl9+RQ=;
	b=k3k70EpLMvfCfhO7L0IG0xxXpKiBQCBPjxx7QVC24NlAAJhdowE6EQuIxqU/w+LF7ZAE
	 ryBJHLIC5wyb+U6rSaqO1k7n/zmnv1m89Z3DStfsuxr+5ddYfioMf+yLxmwrBZa8mzXU/
	 0n+f6FR99CLPlyNvTjgYzoO+L3xFIorxCclFVpBSfO38CKRnc2uil1KBgesELR0buVJDL
	 gkNYZ/bW2FTctFOZMplH0ccDFnaevOxhLl8r7TbJK61ia1GJ7QBjgdHDFP4dcxP2JW36O
	 cv0px3hy8010qoQ35ib4DUdD/m70WbV1Bdra7mV/V+vowF0PzG11h4+Feu7VztsrRpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqf5Mt17;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCDD606A326;
	Wed, 25 Nov 2026 16:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqf5Mt17
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA35A1F000CA;
	Wed, 25 Nov 2026 16:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624009;
	bh=kKcKuNXF9N4f98pic5lch1wet7mOXvstHHlqOjl9+RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqf5Mt174tgF93xJV9/q4MNKpPHzZoAi23+d8//Ckq5t7MPfSam8mB3y7eMIxbGf/
	 ASDk3+wclQVW+uGREAOkfJjM0vhvs0WqSV9kwjMXvtnQ3EskajYg+4YuoZeTc2B5mr
	 a/rkOEnEFTh1CkuraBG3hxX+WpZmb47GvyvNO4nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a079f084653164a652d1@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/816] batman-adv: avoid WARN_ON for orig_ifinfo allocation failure
Date: Wed, 25 Nov 2026 15:26:45 +0100
Message-ID: <20261125143850.538809045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit dfa953ba5366b0a80c303700dab2bbcbdc5c27e9 ]

batadv_orig_ifinfo_new() returns NULL only when its GFP_ATOMIC
allocation fails, which is a normal runtime condition and not a bug.
batadv_v_ogm_forward() already handles this the same way, simply
checking for NULL without a WARN_ON.

Do the same in batadv_iv_ogm_update_seqnos() to avoid a spurious
WARN_ON splat when the allocation fails (e.g. under fault injection).

Fixes: 7351a4822d42 ("batman-adv: split out router from orig_node")
Reported-by: syzbot+a079f084653164a652d1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a079f084653164a652d1
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index dd1f88af5b961..cf6ff9848a7bc 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1296,7 +1296,7 @@ batadv_iv_ogm_update_seqnos(const struct ethhdr *ethhdr,
 		return BATADV_NO_DUP;
 
 	orig_ifinfo = batadv_orig_ifinfo_new(orig_node, if_outgoing);
-	if (WARN_ON(!orig_ifinfo)) {
+	if (!orig_ifinfo) {
 		batadv_orig_node_put(orig_node);
 		return 0;
 	}
-- 
2.53.0



