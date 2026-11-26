Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704922;
	b=V1W3UHILvA8kFwyK1Z5f82u/FhNX8XgjAo3RPghPXP7Lr++Xaau5mNeRGKnS7KzwWRk6
	 JXHFdmL5eRUnKz5f3faAvNV6eq6hBB54fYnIUqe8e7/B7UqpJsqvW0+QN2TSqsXFP+q9K
	 rrw3841dylTCacpQ9ym9wrZqYCYrosj0ox6ari5NyjDJwVUjgl0Shjn6B3MGDY0p9ZHaG
	 keM73L8bBtwwpmMxs3vhAx51iQzc2y3Tda/2jkwxSxbLI5ApW5VGY7NdQoPQJ2208NJnp
	 Mhdpdb/4uDtLCH9d5nN+Kq/eUp6JzP7MZZGzZq1O0giaeU7S2O7Fuq+cqWxQcpmXgFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6J0XmvcBmvtmxrVIHdYj4siHzYLGFKVzH+3ukjFYalA=;
	b=c+5Poh6bHSqiOEm2tXYmfi6PdNz5ECWT6vVqz60Y36Cw/zfto93NM3HNxc227cvFoV/G
	 lDu+ys/9vCa4czRP/y5xOkdm6wdQGUHr8yOdLSJr+/pz6Mjj/2gx7OsnZkbvMFbnY1YvZ
	 QMYwcpRBQw9P0AMlOdILncQQzr/MhHaYNdLMibYy16iToPc4VBcPuujBFEl8tjVIHOxk7
	 1c4kNrUkb3vwGGjg7YdyimgN0fkDg3XDkoRmh6L8QHo8yWXD7mfx7dvrVcK8r1KqEQ+Wg
	 ZI3eSjAcMogrEfoPF/a9Wpj7300uJ7Xgy6PtKWTFNHBeK1kQMGdPynrVpT+D0sMlCXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlaWFIf6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D4B606A32D;
	Thu, 26 Nov 2026 14:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlaWFIf6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287611F000C6;
	Thu, 26 Nov 2026 14:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704921;
	bh=6J0XmvcBmvtmxrVIHdYj4siHzYLGFKVzH+3ukjFYalA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PlaWFIf6ggtXnDet2i4l+FDLpKzhq68VEzJ/O6MWHSh1Vu5/at+GBCYBPZXawQTPU
	 ot236fiwwHUSatWNcQTutkK1a/YYyxmV/MYIwmJ5X1sy1cgyO7jJ6XBevbeGsrswDy
	 ur8R7dAiNczhgRa7mLQ0MIU/tYuObHSVTb7SkvM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a079f084653164a652d1@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/319] batman-adv: avoid WARN_ON for orig_ifinfo allocation failure
Date: Thu, 26 Nov 2026 15:36:29 +0100
Message-ID: <20261126144007.219865083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index 375fe4882543f..7378a2d73a3ee 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1297,7 +1297,7 @@ batadv_iv_ogm_update_seqnos(const struct ethhdr *ethhdr,
 		return BATADV_NO_DUP;
 
 	orig_ifinfo = batadv_orig_ifinfo_new(orig_node, if_outgoing);
-	if (WARN_ON(!orig_ifinfo)) {
+	if (!orig_ifinfo) {
 		batadv_orig_node_put(orig_node);
 		return 0;
 	}
-- 
2.53.0



