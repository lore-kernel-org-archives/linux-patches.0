Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037767;
	b=M6T+NdJzHdmi4TBI8yClT8AoiRQ3E3KrfyBAvYPg0gtRbxaDDIgsz39jI/8/osrewiFA
	 ubvrFONdT3fY3/bJxXpdBM/lk8BzbAR3/NqOrKGhwOgZoNHJP59Aah7ubHss3xFpMDPiu
	 plh6IcP9f3N8nhA3jDuWSMne1d2xihOyLMrHpz94rlKBt7HU0nVWVdVfQ2eCwSzMmIdEe
	 JNvqazuuyD7yahx7uk61+M0orgKPWSmAHZrcDdC/uqVaRCag7aLH0mgNa1B3bygCC9xnF
	 iHm/qZXEUNDNiMismFuY7OiGLPlsfGhX4gHY+kwb3xS8pEPaIR+45Tq8fIxe16BNGrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0tfRTvCD/riKmqL3GihQnm+EUL5lduaCuVTb0U2D5TA=;
	b=no8D8HGu7l+9dJ+jOoqBZ9IIFJRytMsjuxTeALlgNAu+Dz7WVsjA7ZksZ/BOj3ikgz7T
	 Bsu73JbvNxERqkopFOF9+yUDB/azUwHjUTb/j0aM/8JllBV57TknwOnS4EKN1fzEaJ43p
	 I4QvFiuSRBD0mTO6hdKqJZL/HCmHZfOlMdZhmBsYPUne85WR47AoD5PDlhKyz8kzGupms
	 BXwTV+cICscvFv4nxrV9/mGEuWQqSQ2eqPrBj+cjWCGTjy4SVH+qwGRBd6VZIRCb4YOZ7
	 2fP0+V0sgjj65hsbVIGKy0osNy+a6lYpnMNXekqNTuizFZGSi8pnHhUoGjnudX0Z+7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HVzTqrbJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77347606A31C;
	Wed, 18 Nov 2026 21:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HVzTqrbJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C844D1F000C4;
	Wed, 18 Nov 2026 21:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037767;
	bh=0tfRTvCD/riKmqL3GihQnm+EUL5lduaCuVTb0U2D5TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVzTqrbJaGivCNRN2fYhnUqVHVxoW6LqAA0Lt6QCyThrHsTmJUo/aSSAHOuuIa7/B
	 qzjQ3dnf/LIrCC4uJCMQYarFjYdJuxRsNGLMdkIkym7Bb71hpEG8QAjR6S3DUDvKyp
	 +Xl9aEAYkWYr6TqjPK2+mOFCOvjTI3xWvFz1ffSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Cunhao Lu <1579567540@qq.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1510/3318] can: dev: can_put_echo_skb(): free skb on invalid echo index
Date: Wed, 18 Nov 2026 15:35:32 +0100
Message-ID: <20261118150406.238878094@linuxfoundation.org>
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
index 3ebd4f779b9bd..6fb1f9b2a9e20 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -52,6 +52,7 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 	if (idx >= priv->echo_skb_max) {
 		netdev_err(dev, "%s: BUG! Trying to access can_priv::echo_skb out of bounds (%u/max %u)\n",
 			   __func__, idx, priv->echo_skb_max);
+		dev_kfree_skb_any(skb);
 		return -EINVAL;
 	}
 
-- 
2.53.0



