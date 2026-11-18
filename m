Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050263;
	b=N60aVG9F/ESPW14QgGpNq93obXXQITMRDeUXtCKpwfm3LODZj7/ybm9TnsRGz2m8EIin
	 YtBbwA+xJLQYQ/cvNXRG6I08h9Ak4P5rVgUBOKzuj4laZ7rvtdkgBinWm4nqBc6sWTK9s
	 fHNu4HiyTVriMXIFpTpI/Gox69V+0nJPVnQ/6/LzPojvly8iBzpKg9OaKE5PaI3nW3VRe
	 /P+tewrBSmSQduI+ge9CV5Nkuj3O7KQtE19Zsi7Au+FlW2a6BxUvRwgYB20tQwQW7XRZB
	 4fp95BPNjOZ8v6+YWsbKx2/SJLYEzhfkryHMiic7v1HvQHUmnoJasRl3TSrfNlb7DWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8IiAMvVMXIc96dg9yVc7SVnNYjRabVfHU5OoMXvZGtk=;
	b=SQsKnJzCPoNPYfhls2EU56Ag7nSm8pPEMDAJBBq9mT851chRLbgtAjGk9Qw6yoGSv7Cs
	 UGdaOTezUV9/DLBLt5AXk7/r0i8wJ5kBPKRv5BY1ZYfNh2qEJY/gfIyL6p1aNUhCjSHhL
	 l3Su/eO+g6vtZ8fTfOWaQRcXYOawt4Y5VT6uN58GQAa4y8k4a/849wT1oK1uuoswoaye9
	 jgXcs6YJ2o2eZhzp3grAqlBl6ToCbo1JssUd3SbBsUOqfxqNo8GalLXfSSGf/Foe8rLAB
	 uXreFXz0k7FbP4uv3l+cC9WBeGYllCbiNzwiNU3fS4+JT0h+HL1VpkU/spsnh6K32qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7Q+lhtS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BEA606A334;
	Thu, 19 Nov 2026 01:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7Q+lhtS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191CD1F000C4;
	Thu, 19 Nov 2026 01:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050263;
	bh=8IiAMvVMXIc96dg9yVc7SVnNYjRabVfHU5OoMXvZGtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7Q+lhtSLAJOKA4br4AX4vZVE09KCmMcmEF2dUqnGHe2ccVAGrACcWTTcIWLjWdB4
	 oVK7NjDEAWOzBGJe0i3qjG8ZgP+gyNNq12NJjlRvFaJ7XyJmTR5UAJPzArPJzXJ+0S
	 /y1Z6ZVSViE0fAwBEWemuBISVsv00SjnpUI6uEKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2646/2857] net: openvswitch: drop IP fragments on SCTP set action
Date: Wed, 18 Nov 2026 16:01:20 +0100
Message-ID: <20261118150336.860426634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1eab2a43f7cec..6e7e4b8b757ed 100644
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



