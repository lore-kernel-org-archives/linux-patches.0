Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705452;
	b=XbHsAlZh5hXxG0djdXYBbawQUNTeZXuaYyWvQpZUOqSRBZkRsKKhZ0SBWFM/JWI7BuLp
	 kKtImEbOkGa4KDLBTaXS0f0Adr4uamTIYRq3zSwlbblgmlE8e0CfFg4ig2qVfeKuv32xX
	 G2s02onZnswTtLJV3uKrG/AVL7yoEcEOgO1YON+sDOf2rJB1L0cto3A7VyrQBYhPi4Zc/
	 waX/PR8MbN4YiGc1OV6zRIg5RRKP1w7rptHxhkf93Qq7C1+iQnoxqeQGb+E6ncufHWMuD
	 89PR2MBNYU//vGltR753VTwotdTNjlwUp/hskzw3VDjNKXvugdJ3/LodGelbIkn9Qrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D16BMn3uUUXKPLleuqsMzjID2/GQ7k3OGBWLHQaZ1qw=;
	b=MfOAcfv7LLJtu3BsN6aHH/kbKot8Szkd2/HpVK493Jk2j6us4QNaCvpPZG1nhTe36toh
	 CxZWoMPJ48D3I4iR7O3KMzqhmEn3QRewOfIflhCCZ/7/aKkuKMBUdXgmsUqT8a9Cmu1wz
	 s91t0HhtHSZ4CvB9YithJ7/Tq2rRMoNpGWHI4HvLxxhv4d3ozTL9tvQqGC5DzvLcFkUaJ
	 pSHrDPcOSeWClGQXkXwZGfferHELTMYl9vYEQfswQ2Yg92zeIJST6RmbT4/BdWedue4rq
	 qBfJpLRKdxdbPihVhj/HuxbBY7e2vaIbFwTapYCawnO5r7kje+ciJcHpFS2mwCayIsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1EigrrsQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572EE606A333;
	Thu, 26 Nov 2026 15:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1EigrrsQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A361F000D3;
	Thu, 26 Nov 2026 15:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705451;
	bh=D16BMn3uUUXKPLleuqsMzjID2/GQ7k3OGBWLHQaZ1qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1EigrrsQY0O7vNXMhyGScULBRSStX09w/z9QEJRwHxdMLSVPLJezE4Adau0GuCH27
	 RzQGqHNpPPMjgmH7ArBON7vlXX0fCL5s0P+4qRrrr5VFfPdQznYYeE7A7ogiaspJ8Q
	 v2K4kzu9VXoCDsNLnNYcQI6MHvKmSHU3+Ja2Z+5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaos <shawnq1@163.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 202/319] net/sched: act_ife: encode configured zero metadata values
Date: Thu, 26 Nov 2026 15:39:30 +0100
Message-ID: <20261126144011.303944758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
@@ -48,8 +48,7 @@ int ife_encode_meta_u16(u16 metaval, voi
 		edata = *(u16 *)mi->metaval;
 	else if (metaval)
 		edata = metaval;
-
-	if (!edata) /* will not encode */
+	else
 		return 0;
 
 	edata = htons(edata);
@@ -92,8 +91,7 @@ int ife_encode_meta_u32(u32 metaval, voi
 		edata = *(u32 *)mi->metaval;
 	else if (metaval)
 		edata = metaval;
-
-	if (!edata) /* will not encode */
+	else
 		return 0;
 
 	edata = htonl(edata);


