Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062066;
	b=TdJB2HfaaFKvn0xTIk+1Q9lAPOtGIJnO28J7PX5B4T3AWOaallSR3rGuGq6Gy+m5X/ZO
	 JvTRq4xgAL7JLf7cUijtRHYaWuuUbZipyFIRZodIK1RdMjyeNlsJsLpZf4kyIDiUCcojg
	 jny1Atg2g9RZlZk4eMjRzhUMI190PsE32tO6iT9y95yYHZWRYjMzcTxflLhWIRhRxJGsK
	 GppZ2ZRExHzBdGaYV3GPtJgtr8uqBqKVeRwEn/G5Pyho6t2GT9Vjos5yBDtNq1rcdLV6p
	 u3uzQGUKRdCR5xLhxBlQorUTpxT5eJzQ+1zOaXb7rALeGiKqiVW1G2byE3Z6LuLg2kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L9RfZh/Mz1SMkSQPeRoWjHjsLdm9Ggl9ksg2YzwNPls=;
	b=wujrpKVEFfLwD1+qezh+202wmj71IdzEpt3P55g40CWj/xqnXlMQhldhv/PdDl9Io7J6
	 y6E3lBOdm0v7GHqm+nCDuhZopNbGqXAqo1stn2pX61uRKcsI8NLWh/st16TZRt6pu5BmS
	 J+f+Xc3gNwMU8obygGBRrP+kGGki8KXAy+gpag2X+r0FcncVR0Chw1LxTkI+6ux7jYmHT
	 YOnzmQGidIdtI5OcUjekJJhZ2KmmcBL9BGbGNkKFq2LJ4OxSQW5izW+BFV2wYY8F5y/xn
	 lnNJ2T8T0WWdP5x/nOX4d6cyWI7IkixOhwIspLhJ2rlczP0zW+itWzdrEbhb5pVgZLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BfEaDGyS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FD1606A325;
	Thu, 19 Nov 2026 04:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BfEaDGyS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9EE1F000C4;
	Thu, 19 Nov 2026 04:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062066;
	bh=L9RfZh/Mz1SMkSQPeRoWjHjsLdm9Ggl9ksg2YzwNPls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfEaDGyS0VbcDG/8YuCO/s0exPX1ISytM85oqreZU/t8NbrP9kzEpH/jAuWu+8/us
	 pITi9pI+JqCHfcYby3MP9OLdGIP/9h639p9woyr9kS4UCxqDLp7HPjpRSs+idBR7qk
	 0jcifaIlkqSHAtP7UrU8Q9vhca5c+V9vFOmMJgio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1735/1848] net: openvswitch: drop IP fragments on SCTP set action
Date: Wed, 18 Nov 2026 16:02:53 +0100
Message-ID: <20261118150032.198458464@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f5c91d11c503a..337d0f9ffeca4 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -695,6 +695,9 @@ static int set_sctp(struct sk_buff *skb, struct sw_flow_key *flow_key,
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



