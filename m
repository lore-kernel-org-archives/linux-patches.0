Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028191;
	b=UEWZACbbAknQl39RFwsHdSRZUaV+bLZfm4JyxgZJiWdW9USiCPzKSsduba8jYKB4HpNI
	 Emfjx8fQLEwafqIusVi4DzmeOlu+EAUOcTEk3fOUIxRY1id3v6XRY0wviGCu3bEsnmGLB
	 lfd1GjvETUXrMtf35cj7P2C3MbE2H4vnR+eVqmqlGF79mYTSxWf45e/0UqjY1nhXQmzCC
	 yQf4+a8aKcKjKP+G/GAN7t7t2Yr7GAuU7wKnZHxhhvSyZCU1DfsLZW01cT0eF0PJBerRE
	 Qp9y02qvs9hFAgV9vwAOQYVpBpFBYcxuUSKAGs9JZXTnw8T1K0R+sRgw4LN439XOOlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=opigWmFWr5ZahQyxcg2IaSwJUGQukqsbKiSN18UpBuA=;
	b=OT7hU1zE+TttzrJtWBjc5R4swMHrvp4W2zk+iWyGMWeEePL3iHlIccwdq1w1p0dfpaRL
	 eKijWvO4ryByXvV5js3oH1zg0MHjAIyEaTiVEmdTW61RQ5lTWuRdALdv0dY+sa4zhwpTj
	 HL5ZsrWjUt06ytq+3nlxLY8hD173ODpzRJ+Amyt5xBfgY1R2M8cyapgJobwfeGnvGWVpO
	 w3oI6DQCaciv/9ihl3lpzNEf+OA1CN03+LR7nBZBuGiuzrRDxkjDngAqDNtrHms4nKN3S
	 ZEpjoXTLVjZ/uaD+uXQxMGvuG4hj0USabSKSRyhBB6MHeOm/iue41yETDpLzLOR2bxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bvq7m+Mo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230F0606A31C;
	Wed, 18 Nov 2026 18:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bvq7m+Mo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114D51F000C4;
	Wed, 18 Nov 2026 18:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028190;
	bh=opigWmFWr5ZahQyxcg2IaSwJUGQukqsbKiSN18UpBuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvq7m+MoBLbWrQXm8vFSLbXcJn/GUbQ0hv304Cg6H7hzH83Bklr/y93AsKwZVkFZo
	 xSck2NluD/tV6bkdFlGh/SHQpE4feOey/WMlUK7PflGQZr1wcNo63KcI4pr0i2tMls
	 mmqE+orhB5iKUTprxer6Dr4VgwRFfbgxLyzCfn0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Guikun Yang <yangguikun19@qq.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2058/2151] net: mctp: free reassembly head skb when key_add fails on SOM
Date: Wed, 18 Nov 2026 16:03:13 +0100
Message-ID: <20261118150236.689436227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit d2bfe74a8fe219a86b86c1f126e1d722a5001790 ]

When a start-of-message fragment creates a new reassembly key on the
broadcast/bind path, mctp_frag_queue() stores the skb as
key->reasm_head before the key is made observable with mctp_key_add().

If mctp_key_add() fails (a race with another SOM packet for the same
source/dest/tag, or the receiving socket going away), the error path
only drops the key reference via mctp_key_unref().  The final key
destructor frees the key itself but not key->reasm_head, and since the
key was never added to any list, neither the expiry worker nor socket
teardown can reach it to release the queued fragment.  The skb is
leaked.

Free key->reasm_head on the key_add failure path before releasing the
key.  Other teardown paths (__mctp_key_done_in(), EOM delivery) already
clear reasm_head before the final unref, so this only affects the
failure path.

Fixes: 4a992bbd3650 ("mctp: Implement message fragmentation & reassembly")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Reported-by: Guikun Yang <yangguikun19@qq.com>
Closes: https://lore.kernel.org/all/tencent_43A65D51143E18518EA968DF9323694EFD08@qq.com/
Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/179287946888.17431.11219154409333681184@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index ebccff97ec980..383ec4ca0d790 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -552,8 +552,16 @@ static int mctp_dst_input(struct mctp_dst *dst, struct sk_buff *skb)
 			 * can do is drop.
 			 */
 			rc = mctp_key_add(key, msk);
-			if (!rc)
+			if (!rc) {
 				trace_mctp_key_acquire(key);
+			} else {
+				/* key_add failed: the key is not observable by
+				 * any cleanup path, so free the fragment we
+				 * just queued on it to avoid leaking the skb.
+				 */
+				kfree_skb(key->reasm_head);
+				key->reasm_head = NULL;
+			}
 
 			/* we don't need to release key->lock on exit, so
 			 * clean up here and suppress the unlock via
-- 
2.53.0



