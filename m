Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042661;
	b=3pSHuSE4l4KuHlByKSnGnLhXJ5Ehs/Z0veDIfdqb/asOZFHvO1PhWdLMx0vtmfmIHK78
	 oHn+cUuAjCjPq9bUq+mWISZ42leoc3vlYrwvEru8lPc88sTymZIHRULEE0+tgHJgy0Ad0
	 tX/3lbeWhBpRkotF0IdqD0ixM+7Xd5cloBR2xnoEp9mWt67ASNcXh/aXT4+QFNxYw4YYo
	 exW76Zq8OCip0kqkbvD+h6I6lf6yXuI0llMz67jtbPKeMQG6O9QrRMxiSKm5g/MK2kOVN
	 yLIcv4SwpB8jQ1gxIhviqhOrRFu8SuVKf2B1QRI+KJjEoeiDcrwz5hh8uN8/I7g0+rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gOztOSxpBFII7qc39R2Puyy8Dk6kZZgVgwyWmmtzSZo=;
	b=uoh/wBMEmJ47XiTChIqVhWx6xT7Kgp5CSv3yiPjRnUXsbWcg4/bjb6oF8TxvaYpFMWMm
	 1Wlzv7rz8bOB6nNQY0E6EzbaFGjCrzH8C2j6byr8CB88N4yYOrfZOBDRffOqoimpg81SD
	 kKsrkLvHs5qLeFC2MRO8nDwYxG6u0KnlLpQjcw2a3N/DwgYaCmSTuptTwAB+szWpldl/G
	 DLl5xWV/sC2D9jS9e+yLW9nUi2ZVcy9A6cbRo6ZZEg0bWEKTK6Lp/8CcpQEBVCeBKeR99
	 M3ztMWGvKb2UNEf0++o+uj+Qw/UnwcTAo8MDYsZk/yk8Oc/Rk2snNuipVDDiJUdJKjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oRb/SV7+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CC1606A32A;
	Wed, 18 Nov 2026 22:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oRb/SV7+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF34C1F000C4;
	Wed, 18 Nov 2026 22:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042660;
	bh=gOztOSxpBFII7qc39R2Puyy8Dk6kZZgVgwyWmmtzSZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oRb/SV7+wBtIfjtrYy4T5AJZT/WRbdIiD5g9RW8spiOzn89auJac31beZJWU+G/gp
	 Rcwhy1z8QQUNVY1/akNShzMMt3zDO6yZAN1vAx8iK+PzB1/k0Lre4wlqCmOJWvPn6F
	 OFiuWzMa5QupGZY1IMCjmrypLQFuU397kWdS+Pn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Guikun Yang <yangguikun19@qq.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3243/3318] net: mctp: free reassembly head skb when key_add fails on SOM
Date: Wed, 18 Nov 2026 16:04:25 +0100
Message-ID: <20261118150456.961599080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d3b20981e4ab8..aa3b523c15d49 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -496,8 +496,16 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
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



