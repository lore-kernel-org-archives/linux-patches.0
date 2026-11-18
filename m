Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042202;
	b=K3Hf6SyAw3gBtzPINTFk6AGKCVUPFVvzucerq+OPBYNspLj1u6h7FShrFz31rmJCyme7
	 pB0OytVALx44aC32cllClt+x3zXlssN1Ircle5MlqcIIOF0MGboo/NGYFkusCtuYEXwnf
	 oihyei8LLgzBix03uq08K7Y0rQARgvScM66Z0lE5Mwyl95RL4cfYdcm8t0sTWhIYAXbkf
	 Ogdhp+lGxx1vLr6vTW5aV6p5kZhonPanwbjElwxCbQEQ1nHkV8w9oAFYVagGtLt4FsLJM
	 A5+3FYmkY/PNqRJKiPaTxcyDRRqIdLqwaGjbif7NJzFVzFqvq9Ak1S3CQunTSg2hIiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BIBdtgTDhTkwClHToxiim5VSJvO76mq5dxohOcIaj0c=;
	b=TETcCyeHnvxcqVT6SeHWx04WXu9mlGsFUMVv8wZupDwy2Xk9jy30SvZh4It7VQl252VW
	 9H2HmTkT9FnIYcyjyox5I6VFgLFGA8dkJNMnpDpp9Xgqzv6JC/i3aRjY/obb1uUOxMgkL
	 A5VBo4FFKnQUBAzahGwjgUicrWJjgTwpt90Mp72gPOfPTA4j9Adumn/BdX5XzV80shQXv
	 EhkWGiv9nIYvjdaBItcOFhJMHaFSngG5+ZrDzy92h+We00s7kE4k7zqIDBp0qB93G80pw
	 n9Ym/thOHFMt+t8fMa6Kz9Wx+FSIvsxZ3BTVeHBX1yDJo3DpGD1GBVbNck/xX0O8Ukg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ptf1QTDn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C74606A336;
	Wed, 18 Nov 2026 22:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ptf1QTDn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB941F000C4;
	Wed, 18 Nov 2026 22:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042202;
	bh=BIBdtgTDhTkwClHToxiim5VSJvO76mq5dxohOcIaj0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ptf1QTDnJAL7Jq6FWTv0A+OzKmuBemos8Q/kQX9ZJzwratTaNbLmJpN7Tro8ECmZ0
	 w+ew6B3ilGC0C2oFfjHyh0k+nk/H8i/ymD/OXLNT3hRU/uQ9+7DvGC1F1JpXQie0lT
	 SepXt/cfgUFv8jNwjujMdLk+YalgYktrArZuIqX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3069/3318] net: openvswitch: drop IP fragments on SCTP set action
Date: Wed, 18 Nov 2026 16:01:31 +0100
Message-ID: <20261118150452.181536483@linuxfoundation.org>
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
index 8511e70890b45..e49964cdc5f5c 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -698,6 +698,9 @@ static int set_sctp(struct sk_buff *skb, struct sw_flow_key *flow_key,
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



