Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056661;
	b=JePIlYDn1P3Kqr+ayiARuC6mB8YHsIapCU+AZD1ht1MOKvl05bkjZenBLwqgnN+JKsFT
	 ayNaNQDDdFELd84geEvWMvVHjiwvXG15kSKjiIrZnEd1LDd1fp/zuk9+xponOhWrZg+LE
	 ECFnjHZ0dlukl+6MWABivTCmuVLScbA+Nb9iyXmq19kAMSS2FxGOfpS27+p7H69skAGfk
	 G9NRnrI12BVaWVRKg/0q1+KFi4p6aBZz8uP9jGwm6iit+v47lFUplD07AVBbSERn62Uho
	 dX0sR6FVYB0bdNPPxsLkHZiqkFmi0KlKgozt/mf+gd68TFeu86BzFqMqpB1UD24LATA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RfbfBoghAPNgmu/0aZQVWGb/O9X6gF9vzYh0lFlkueE=;
	b=NIOOluU1DFP98mKOdJMnzCzsax7QuaYQU30s/77rr0HRj+0frVQQzj8QOXkxVklC6AC5
	 j103VSwqEKDFYmcj4OLk65fmWawNAwqGv4rkRNe1EoBckcjDXVytiO/81rWvogFUA/voM
	 lwUWDLRg8+8FZfh1VM2cVett505wmuWz2yijXk+VYnd2w/BLRtdrG8OOSCoeYTVyuVOjm
	 AmWkB9GRbUczMlYDEbR/hIlAtkt6UKE0AGzl7VaJxl+oa7l01pYXVeD5tlHHQTyVTSEIX
	 rnXY+Sa9WTH3ZDni4cImVe6PClKpxBmKDf6V6/WoZ+Kl/LQJQ8BYLGHUjoquF3vaV7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C2oUeTQa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342A4606A32A;
	Thu, 19 Nov 2026 02:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C2oUeTQa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCB21F000C4;
	Thu, 19 Nov 2026 02:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056661;
	bh=RfbfBoghAPNgmu/0aZQVWGb/O9X6gF9vzYh0lFlkueE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C2oUeTQaVrG60A4pKIB+nYZq7KVXnVlyCyuCeSiOackCmBG7Vgm1GYwkDTK0I096+
	 toBYXdsqYMkxJSb1UZijZRnvB0ufKzxZB0b4Gjp8bu+vE4nGS/uPWKc2mXW+X0TVm9
	 3ZL18H4+FbMKu0YaV75iZTxWneo1cr8ELwM0gKIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2066/2214] net: openvswitch: drop IP fragments on SCTP set action
Date: Wed, 18 Nov 2026 16:02:22 +0100
Message-ID: <20261118150133.292919815@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 4d0d8f491307f22aea34b22f73351e1cd2ede735 ]

The SCTP checksum is a CRC32c over the whole SCTP packet. set_sctp()
updates it as old_csum ^ old_correct_csum ^ new_csum, with the two CRCs
computed over the bytes of the current skb only. That is correct only
when the skb holds the whole SCTP packet. For a first fragment, and for
a later fragment, it holds just a part of it, and the CRC delta of a
change at the start of the packet depends on how many bytes follow, so
the checksum written is wrong. The receiver drops the reassembled
packet.

validate_set() accepts SCTP set action for any flow with ip.proto set to
SCTP, regardless of the fragmentation bits, as it only receives the
masked key. As the checksum cannot be fixed up without the whole
datagram, fail the action for packets that are IP fragments of either
family, so the packet is dropped with OVS_DROP_ACTION_ERROR instead of
being forwarded with modified ports and an invalid checksum.

Link: https://lore.kernel.org/netdev/d4fc14f3-4308-4560-9012-43c09c1b3845@ovn.org/
Fixes: a175a723301a ("openvswitch: Add SCTP support")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20261015124749.4694-2-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index b7f2120cc45b6..05704e2393bbc 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -696,6 +696,9 @@ static int set_sctp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__le32 old_correct_csum, new_csum, old_csum;
 	int err;
 
+	if (flow_key->ip.frag != OVS_FRAG_TYPE_NONE)
+		return -EINVAL;
+
 	err = skb_ensure_writable(skb, sctphoff + sizeof(struct sctphdr));
 	if (unlikely(err))
 		return err;
-- 
2.53.0



