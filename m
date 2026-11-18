Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027496;
	b=DygNDmioRqnUyb1cO385iVZeZgrnMaJsepQjj67D9NNk2YyIp1AULmRtzSjBnon+Jp2Z
	 v7EyZe2oHt41UqVM7k471W0jFiJlNwMG3OdMPCfYnfEJWIjT7VT/f+rDbqkfvhy2icoXr
	 Y3ZBukTSfKFpHQ1ehvjcNgD4PpjdB+agmb1WNv/vh3QeMOOlkxQS18VEU2+noYsLx4ATD
	 gQjUlsDrF33nTljQm1lxWOLmbgEKjD/9056n5f4OiPd0g7tlfoUGfeKkV0aKcRNezDI8Z
	 UzPNK4CuU2d2zWAt7eLMYgdvRHOUOFUEw+jfrll/uAPPCM7ZghgJri1lG1xUwm2ZO5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9g28LB1eYhIUWkl+Vf0gy9qkL5Tcs3aplXS+s0hZc6Q=;
	b=B0kEBAhpkHXbVOKveCWODtLM1nRRobGCk8OTadyoocUaw7kbCuzCaHTUPKrxuFzgfzQX
	 WsiknQ+5Ze8vJiTbT5l5ZS6QDMuQcqTEXGHfypptK/foxDoRqq9/DlRorhSQh0xrQzMvk
	 RRSaTHSsNk5tTC85u+W4TieuRId2tDgVydkLG1GHphsK4GxDAIRKQIG2E4gJNkEkokSQO
	 3GqG+q4DWsnGBYLbkYxugsRH8Z9FqWvInUye6zBbwM8VIqNGAfSquYxUcxksISQ9c1tkP
	 nfPbVjZlN7hP06HuPGDIdYkYGgeg3bErC1IUVFi/3kEjqtOvMgJHSU+3TTo38USTbMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SA5yC7dk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E44060A2602;
	Wed, 18 Nov 2026 18:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SA5yC7dk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5691F000C4;
	Wed, 18 Nov 2026 18:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027496;
	bh=9g28LB1eYhIUWkl+Vf0gy9qkL5Tcs3aplXS+s0hZc6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SA5yC7dk+mgXHoN2qVgEAQOR+aU0mDWCpG2upIV0BX/HTMwYAnzEW+HqeHrDm6Jq8
	 dJaDJXVGPId5VFBQx+QeivbEHQMKBf5zIIGDmwBMoyhS+fQLS82khGiHpLjj/uMAqn
	 Dg1x1hhW4VvnEKYCs3DMgfj6VIdSI+4PJtxrWtG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1809/2151] net: openvswitch: drop IP fragments on SCTP set action
Date: Wed, 18 Nov 2026 15:59:04 +0100
Message-ID: <20261118150227.703377939@linuxfoundation.org>
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
index cbab49ecaf152..d5f0b1f0bcd0a 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -673,6 +673,9 @@ static int set_sctp(struct sk_buff *skb, struct sw_flow_key *flow_key,
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



