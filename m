Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021261;
	b=0IgRVQEKY7v1atOTSltm0dEvOimipbypN7sLWsmlSy+3rHQxPH8HNns3KmYXFhQEGTfV
	 joub9FN+1c3xv/eg9Ac2FciHq34GOItcBwHAckVGpaEJo4Qk7W1lvNLBkpkO9qcvM9zom
	 a9l+9y/7HxM2hMc4ZrIRPNgb0+4ySSqwcBqG2Sjz3mf8Ujg3U+sy6qXer6wWFCqDdyP6X
	 hzhglex3RQST4dCT6/AgXbBvr4JIV1c4rEc+6v/t0wz29KPLP/h/eYHOBNuIu1BpU0ROZ
	 KNWns9Ila1Q5LnX7kZhoKCKRstnWXR51SIZcwVjV6CzBfmcL+4NxhCRZL0l2TtLNJjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MOxGGO//AVGNaGlJ3MkPKVKVcjQucYiyN5TSquvFtHY=;
	b=3snOESCkCbAKT3Gfhi4lN69lsg0EZyJjz23AydkLOh5Bv8C0FhsRYhcWIOVo+Ri7xhu/
	 cL4fZi+mz2oQlq0FVtkmMQSxBqx3DE0cZ+j2e+pMYnpDI9ZOb2IANJyDUmRfi9LpZdaqz
	 iGYzGAMrgWoPUeZ2ghyn+kOdkwkPBUrFIqAMfaLsukJdSgisoVhQTZz9ymGu2/lMFaxZn
	 M7UTtP5rfC3br0XBNLhmIacZpQgd2rd7PKGSuvxObayKR6j+hoLAiBXC3dumBcrEFwHZt
	 TLbGZFyoyK+hsNSPMAZuv7dzM0zMu1olwVAfIagU875pgF0/0y1dwUhESz+gMA+LzLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jtE4p6EL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE1B606A320;
	Wed, 18 Nov 2026 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jtE4p6EL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173721F000C5;
	Wed, 18 Nov 2026 17:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021261;
	bh=MOxGGO//AVGNaGlJ3MkPKVKVcjQucYiyN5TSquvFtHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtE4p6ELqSfyS8xrVW1UWi3GcFiz5Bg6vvUZr2nTAlIk/eTeiFSXOMDyqvjRehLDR
	 L18Cvtdu5qtwbntYYcTcnxjT8Pv9bEbPVgmpcV2DrFSfhjUHphUlC51ysp6Qy54wRQ
	 VTvA537MXfhXBeQxfhe4F9Kuxl1pAtPtPrL6Tong=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2245/2651] net: openvswitch: drop IP fragments on SCTP set action
Date: Wed, 18 Nov 2026 15:58:05 +0100
Message-ID: <20261118150406.289476008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4aade471afc45..12e339cbf7912 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -674,6 +674,9 @@ static int set_sctp(struct sk_buff *skb, struct sw_flow_key *flow_key,
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



