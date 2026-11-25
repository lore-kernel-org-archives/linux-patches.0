Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625705;
	b=2CAAj23a75qTcnzDFUu4Q4W/j3on4+bO38xJwgbhqjBjixEtzsqXSUIPFVbpkP0kcwAw
	 S87w/rGAHOK6+a4OGkV4c7Gw8yKicB0D4dfXIucsouZaKVzBhL6Zo/Hd0PAzzgotHUdC8
	 e05kemMJcb6vSBgqHVe+k1P7dGfISP+SIfjZbcUFukqM2RbSZfp9qNgIlQzcqN85Ci7t/
	 DXFZI2KhLPRObIRPYKTHLNprEwqs6t56QkqkT9zJWxULnvDq68lmNrnG+P0pt9fZlYrn7
	 Rnfvxqo7VjlaQl+U49ZwP67bh2M20Ct/BiKtRAYkbobdMH1zyBYCsbX7QguD3ftL1SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TFtDkaxWsc2s/R7fTWH+S1PsBvx882/gu3SrHvhbfnU=;
	b=i6n1XzxHvukNNhpEXQwu6cJWrv6zAA5O/N/6S7/tVWNJ3CKCGKll8dg702TmE9w1XhjC
	 9lkraovxb7EZAp4bntdjo4D5dHgj5ucNtsbaPDUb4eCsKuQ0Ui5L/lWJeFp58kJPVyACk
	 cSQEtpVj+lo1xHNu0h7Up/YTkhLJIxG2wSfqSlAIqouwVsXxLnrsuum1ZiCmIzQBnchTd
	 Ff0HDz8qb5KftCryqSeAQ0k8JQB4ktyLCfF4jRJeYgSCmWahdRmfvpa3VvRpTbH6MocJ4
	 bd40waJM/VFB/prANp7JCrjW771sPDyelwwjmigCAe22Fo4eXg1UWvDAd9ukTx5eftw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8KKPHoR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F30606A31E;
	Wed, 25 Nov 2026 16:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8KKPHoR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59591F000C0;
	Wed, 25 Nov 2026 16:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625705;
	bh=TFtDkaxWsc2s/R7fTWH+S1PsBvx882/gu3SrHvhbfnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8KKPHoRwzIvgRLXpv8tCiI8t8jv78zfwgH4z4Yp1PTF5fsWXH3+7IoITDcfqMRH9
	 xUCaoKnzT+ZzNUwD/5gvBJP3WwwhzOAs1ukRcVWe4DGBZN4gi+KeHv6UdVjhod5i0O
	 NgQcr4a8w50vmqsIWKeiI5N45S0juDwyTfFZ1+3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaos <shawnq1@163.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 603/816] net/sched: act_ife: encode configured zero metadata values
Date: Wed, 25 Nov 2026 15:35:51 +0100
Message-ID: <20261125143903.135867822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

commit 7d02c07c738bf5c4b9a7d7ef498fbf465c446853 upstream.

Reported by shaos <shawnq1@163.com> with a reproducer for the 32-bit
case, which was reproduced and verified in our test environment.

The issue:
ife_check_meta_u32() and ife_check_meta_u16() both reserve eight bytes
of metadata for a configured value even when that value is zero, but the
matching encoder returns without calling ife_tlv_meta_encode(). The
encoder therefore writes neither the TLV header nor its value, while the
enclosing IFE length still includes the reserved bytes, exposing stale
skb headroom contents to the peer.

The 32-bit helper has been present since the IFE action was introduced
(v4.6); the 16-bit helper was added with the 16-bit metadata helpers used
by the skbtcindex callback (v4.9). Both defects predate the oldest
supported stable kernel (5.10), so they are fixed together in this patch.
Each hunk keeps its own Fixes: tag for provenance.

The fix:
Encode any configured value, including zero; skip the TLV only when
there is neither a configured nor a runtime value. The runtime fallback
is unchanged.

A raw TCA_IFE_METALST netlink request is needed to express the
configured zero: the IFE_META_SKBMARK attribute carries four zero
payload bytes for the u32 helper, and IFE_META_TCINDEX two zero payload
bytes for the 16-bit helper (not an absent or zero-length attribute).
Stock tc cannot build these requests; "use mark 0x0" emits no mark
attribute and "allow mark" emits a zero-length one.

Conditions to recreate the bug:
CONFIG_NET_ACT_IFE=y, CONFIG_NET_IFE_SKBMARK=y,
CONFIG_NET_IFE_SKBTCINDEX=y, CONFIG_NET_CLS_MATCHALL=y,
CONFIG_NET_SCH_INGRESS=y, CONFIG_USER_NS=y, CONFIG_NET_NS=y,
CONFIG_VETH=y. In a fresh user and network namespace create a veth pair
and attach clsact to the egress side. Install a matchall filter whose
ife encode action carries a zero skb mark (or a zero tcindex) in
TCA_IFE_METALST. Send a frame through the veth and inspect the IFE
metadata in the received frame. The metadata region is eight bytes but
holds neither a valid TLV header nor a value; it exposes prior headroom
contents. Setting the value to a nonzero one does not trigger the leak.
The namespace needs CAP_NET_ADMIN; no additional privilege is required.
With the fix the zero TLVs are 0001000800000000 (u32) and
0005000600000000 (u16).

Fixes: ef6980b6becb ("introduce IFE action")
Fixes: 6a5d58b67e20 ("net sched ife action: add 16 bit helpers")
Reported-by: shaos <shawnq1@163.com>
Link: https://lore.kernel.org/netdev/20261022144739.61342-1-shawnq1@163.com/
Cc: stable@vger.kernel.org
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/SER-NSBD.v3.r0.20261103064310-1@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ife.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -50,8 +50,7 @@ int ife_encode_meta_u16(u16 metaval, voi
 		edata = *(u16 *)mi->metaval;
 	else if (metaval)
 		edata = metaval;
-
-	if (!edata) /* will not encode */
+	else
 		return 0;
 
 	edata = htons(edata);
@@ -94,8 +93,7 @@ int ife_encode_meta_u32(u32 metaval, voi
 		edata = *(u32 *)mi->metaval;
 	else if (metaval)
 		edata = metaval;
-
-	if (!edata) /* will not encode */
+	else
 		return 0;
 
 	edata = htonl(edata);


