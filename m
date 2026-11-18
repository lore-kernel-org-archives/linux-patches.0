Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033133;
	b=Z0m6rhdx7AVuxRya2hSpTyGOFglP1X0OLu4o+2+svlcsqhEz4Mlt0vTWK50+cFSb2yTR
	 U4pKWLdYY/oCon/xDgoUzzGoLBtN2qVKnlo7+SvNlxJJlbXBhyGjgie7yk3mUBLMlXuC+
	 eR12k1ukOG+8ZNREJEG8Jvv+B29N5m8Kq6tQ1F9eZZ6oakdqJpHgPc6DkSgcGsmqFPBBR
	 SuV1a41Cfz1P60hjbGXk9UIEaRKjSiLG3Y5UPn0+EhrN0/IkHc+Y8ibUYhhmuQskdhOoP
	 HWkvwo3kI/hlTMdi8mGOkCZBd0246MtReR5vpk91Od9plbapv1JD6xqHimXqMT48AXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h/exU+6/b3pJ0TT6FbdxNipwt4EMgDkHHj7UKah/BNc=;
	b=RMm+xc6OBhQHq3bDp66HHkkPLmNNfSfMxloBl87qZDLul19HK0BelW79IND1wMxhVAbg
	 bWVFpWkj6Vsz4qf38UXyVr2jpycdytZkHQK69zueX8lb1IqsNqjHvCFRjC4bKnURDuIUp
	 5veddgM6xusZUeybwd7yCRsx3GG9ZaE4+iVx3qk9zEhi+w3w7ADv4iE7axNtl46mT7yH3
	 4EmMqfpRtlpivhVgH67lVgaN7rinizB/sEoVw/t4m/EN9AL3BTAd66cnE+xVsQZzXziul
	 LabJxcjqwRosl9YuHP1qfbutGCiXzgK0FJJ54/CC8MLmkBgFo+NRe+kayUwUsEf8vXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n7vREla+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8369606A337;
	Wed, 18 Nov 2026 20:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n7vREla+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DDA1F000C9;
	Wed, 18 Nov 2026 20:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033132;
	bh=h/exU+6/b3pJ0TT6FbdxNipwt4EMgDkHHj7UKah/BNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7vREla+1G3y70Bcrph4P9T1ZWw9eqo5E5BI2ybBxruPZqKsXMpwA2f6DwAVnOrWa
	 p7s1s1G9cwtET7LiiR5CbP2lLz+Tc++uImJz/+546FhHcTR4ofsPAZJtU7a4wk0Mq6
	 Pxn6ZiXkeV+e63aBOjqTIcq8CjxoF9bxT27MT180=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Guikun Yang <yangguikun19@qq.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1660/1756] net: mctp: free reassembly head skb when key_add fails on SOM
Date: Wed, 18 Nov 2026 16:03:07 +0100
Message-ID: <20261118150115.801066288@linuxfoundation.org>
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
index eb7c1166d11b6..10a5e53057548 100644
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



