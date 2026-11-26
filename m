Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704561;
	b=qIyhEIGwalK0ZgG2WsRvHUdpNOwzF0A+BcwTIE+BJ2TFUfS2uDBNxhggiJRYOx7JqGtM
	 j/OBiYO7YAgED+glGFLJ7OzmMJfc3KZsO8Yvm8ROVTchTjsOM1QcabtTaKHHoxpuOEXwn
	 V/RbsmY245oJzOZLIWgL7w1HDG5FIRXWTmfwi+edZyIX3+yl7p5VomvhneyL21QryD5ro
	 Qe9HK4LV6c4NY9iyUNgVD+Kqa8imA+iLwNQGPODr88M4xoJ55Pxy8RBS+KKGMMbdXy6cT
	 ijqZSJ8DANv5TLu6oX6mB7Yuoo6pJNC3hwiRx210wB/Py5/uqcrrkAXKjFbJ8fQmp7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s2RkssOCRA1rcFolLNz8RU9SMfQ4rjvgPRT+OwcGdz8=;
	b=Tf5794hDMBYeUPD96McXKcDXbyLLUzllib98pZOxIADITKe05fWltvVcnXJlE0mK/jzv
	 6MGMok2XFbju/AGOCB5TNrWUs1VjdI6R/QWNgFRQCY8fEls9TYVI/PKJBIKmGHVA4vYXG
	 toAZC5C5T66g4MYbO8aEka/nLYYs0LtQ+OjOJdhm4A1nPq7MCVpaGlBbneOYdLIweL49T
	 j4fUQz6oFP8rgkHQ7marjPieeZBrLs1V0ljWOEMZC68XWPbA2gq2Ge9UXms/JDuwyCHXc
	 Wai2R1W5FMik7yIlm7Zcl1ZGlQm+CUH+S/HPBHgjACP/LRIlGkN9ilCk/IjDTyHfu1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HQ3/YLkc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035D0606A334;
	Thu, 26 Nov 2026 14:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HQ3/YLkc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C77D1F000CA;
	Thu, 26 Nov 2026 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704560;
	bh=s2RkssOCRA1rcFolLNz8RU9SMfQ4rjvgPRT+OwcGdz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQ3/YLkcR7UaBSBbe6xV59e9xvpKUp2kU4AS0Bl9nC4ovt63km7pTLuDAYsZt6UQi
	 BM1eHDFqlZU5s0JioR/gXAQqeF2ts6kbqwpKtI28fqRLW5BKmFMUIlnQzUUJztLIVY
	 EOsvQ924MLRik7w2MmIcYnzhkP7SqM1uNZkyG1Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaos <shawnq1@163.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 167/265] net/sched: act_ife: encode configured zero metadata values
Date: Thu, 26 Nov 2026 15:38:17 +0100
Message-ID: <20261126143616.835069249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
@@ -49,8 +49,7 @@ int ife_encode_meta_u16(u16 metaval, voi
 		edata = *(u16 *)mi->metaval;
 	else if (metaval)
 		edata = metaval;
-
-	if (!edata) /* will not encode */
+	else
 		return 0;
 
 	edata = htons(edata);
@@ -93,8 +92,7 @@ int ife_encode_meta_u32(u32 metaval, voi
 		edata = *(u32 *)mi->metaval;
 	else if (metaval)
 		edata = metaval;
-
-	if (!edata) /* will not encode */
+	else
 		return 0;
 
 	edata = htonl(edata);


