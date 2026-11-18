Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053484;
	b=lFk9CS44NEkEt3wXrt0DTBulwMsgGFL0sdAtN1MjpsWclVh11+eoL1nRFoYR9SqGHFOG
	 1SaAY77XuOV7HHcwNB8ZYGY97UGv/nEy2JUy0gT14yBhX4JpIMKqPoj+fPOxR1PKrX+dF
	 roWDmcxGFI4Tzk0R8IM8wVBYhlGfbH0p3eHju5LB4Chh6ZD5PWXUrKGCoIv1TSNxzrnjl
	 WYlP+zgJihCr8T3OZLrAAW2klmZtBwUehVg3MYMzrRiTiElooI9Jco3U6QtwNJuVWduDb
	 qdRLExqPzn3CCQ0KAD/GNUU3GiXBk9rZDx6Ii3VyAdgrjJNe4bj3t7z3oiGDTO1xbLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EgbShfF1ymJUSkUfxPApfFX6AuzMi2PmOxJ2sRNObhY=;
	b=0kWfRtGXWEW5srCTmb8eyQoAbukEuTnsGoYstirbgoXLU0G+IfyuXy0KD1Mg9BDGE2i7
	 j0r3OJAgcUnCp9KL5hJ0AffRNOoEtXtYKAFWmNWDJHIdjPpX70Mm4MeVg/joqhCZn+aYq
	 +l4xnjzHiFJ/OPH4Y9Hf81eANpY0L7kLljaisoFCjd8jQANR+nMG6JDHjTQFkTIDbdXzI
	 hvVF047J2yoz/rV9b6ve4Ztmn7+C6zzu94eXsT0sVha7EZHvQe8+jaMuTpgoT/pScE2yf
	 EpkVdDClKBJo5MGyd5HuzgNrXOMpIbto4og0NZhtuRlC3VxOlKT8zmW3ALmkf4aeckQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYEfftZy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFA3606A320;
	Thu, 19 Nov 2026 01:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYEfftZy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F321F000C4;
	Thu, 19 Nov 2026 01:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053484;
	bh=EgbShfF1ymJUSkUfxPApfFX6AuzMi2PmOxJ2sRNObhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYEfftZy9dgrv0kFG5QM1BOBX2k2d3Dh9bdDhS/iqePJerjvxv7wTt9d8VUmQNsK5
	 tYtyUIzvTGvkbloFjDaAaO1yM3F0GJG7CdaAjb0zMcoT9SdMpXkxmdq+M7DE9roBgU
	 vBkBd0JmT3nJf3t2sUCEoLE+mU04xJqPeojZwDbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Cunhao Lu <1579567540@qq.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0896/2214] can: dev: can_put_echo_skb(): free skb on invalid echo index
Date: Wed, 18 Nov 2026 15:42:52 +0100
Message-ID: <20261118150048.126690913@linuxfoundation.org>
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

From: Cunhao Lu <1579567540@qq.com>

[ Upstream commit b4ebcbbf66ba6c5816dfe229effb4641c46e4b4c ]

can_put_echo_skb() consumes the skb on all paths except when the echo
index is out of bounds. This leaves ownership with the caller on -EINVAL,
unlike the other error paths, and can leak the skb if the caller expects
consistent semantics.

Free the skb before returning -EINVAL so that all return paths consume it.

Fixes: 6411959c10fe ("can: dev: can_put_echo_skb(): don't crash kernel if can_priv::echo_skb is accessed out of bounds")
Cc: stable@vger.kernel.org
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Signed-off-by: Cunhao Lu <1579567540@qq.com>
Link: https://patch.msgid.link/tencent_683AA16E643DE00211CD2FB62991264DC605@qq.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

---

FAQ:

Q: `can_skb_init_valid()` directly modifies `skb->data` without checking if
   the SKB is cloned or shared. Is this violating SKB shared buffer rules and
   causing data corruption?

A: The finding about can_skb_init_valid() modifying skb->data on a
   potentially shared buffer is not relevant for this (correct) patch.

   The FDF-flag write in can_skb_init_valid() only matters for PF_PACKET
   use: PF_CAN allocators already set CANFD_FDF. The write exists to
   normalize frames for PF_PACKET observers (tcpdump/Wireshark) so they can
   distinguish classic CAN from CAN FD at the netdev level, and to
   compensate for PF_PACKET senders that omit the bit. That normalization
   is functionally required.

   The shared-buffer concern only becomes realistic through a specific
   chain: a PF_PACKET sender injects a CANFD-sized frame, the CAN driver's
   loopback puts an echo skb back into can_rcv(), and cgw (without
   modfuncs) clones it for forwarding to another interface. Only on that
   second can_skb_init_valid() call is the skb cloned. By then the bit was
   already set on the exclusive skb during the initial xmit path, so the
   flags |= CANFD_FDF write is strictly idempotent for any parallel
   consumer of the shared buffer - no memory-safety or
   information-disclosure consequence. It's a formal violation of the skb
   sharing rules without an observable effect, so the current code can stay
   as-is.

Link: https://lore.kernel.org/all/54a3cc01-abcf-4a33-b932-39bb1f68cdd5@hartkopp.net/
[mkl: convert Oliver's mail to FAQ section]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/skb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index e59d5cbb644a1..3a39940e6357c 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -45,6 +45,7 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 	if (idx >= priv->echo_skb_max) {
 		netdev_err(dev, "%s: BUG! Trying to access can_priv::echo_skb out of bounds (%u/max %u)\n",
 			   __func__, idx, priv->echo_skb_max);
+		dev_kfree_skb_any(skb);
 		return -EINVAL;
 	}
 
-- 
2.53.0



