Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619282;
	b=T2WP/wsDH8fvGnauNWUtOMVq/hz9VDCJ4NebzbbwgXa8PFDzpEXaS4OOTFz0BB6jmhnC
	 NkZLS5V1ruFwHVPPDepBHW/Sif5nLtBLFxmK8fOD7wU77C124QZLThxE4NFX9svwSea2F
	 VVuayF5ii0e9eI5Ilti3ERIh/n1g6cNveQubprSOBS6aiXZWpslQJIGs9V+Bf8O2QfrT6
	 LMJ4/XHn02hWGqEUyyvF42oO4d8isUlkwc5Ougs8K06/DYk96JnkQVCdhcQBlTfFgZ/n0
	 m9zbGzGQSwy7+7MgjOzajjmS6/Akt8zu4s+JiGABYN5nBdoEBQlF47XYkEtNVUYGD0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kiVPWrd1B6W3fVSgP+g+44xj+Sos+L1ZpqemPhf5pM0=;
	b=UQKdpuLRsLUh24WYcB65RJb1rOjipHWmVVETCSC+LaIxNlGq57wlExDcmccD4+6oa3kg
	 D3pz5wTWwytKWLZS14x2IG8bNRVHrSPhdgJvuq2oOXENfE+g8nsSH00gtkgdy4fXOwE3k
	 y4xX3NZO9/UZdzvb+yo3ovPDvvaUb2fhqPYoz6kiZFzQTrVDXi+qHSFFdyp7ATvU9JtEJ
	 9oLqDs9MAFJDKn4fKqzuTd6ChSxE/+JxEVgFzDeCAVjONwAawOQoSwhgAc2epjAOF4aev
	 yWr+ZG0tds450JrwZG+s/UIsGpU1FNiLe65J79T/giuZi22eWHw9e8YQT8yN58Ssa0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDPLGGiq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F5E606A321;
	Wed, 25 Nov 2026 15:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDPLGGiq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7312A1F000D4;
	Wed, 25 Nov 2026 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619282;
	bh=kiVPWrd1B6W3fVSgP+g+44xj+Sos+L1ZpqemPhf5pM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sDPLGGiqH+F/eOtZHIpRVHEqeboe08avUaqmbV65JggwhD5chZ+xVPSJOAXtsnqc7
	 /idYN7A9cJGYv9HF5Dngg7I/LhdoW27DrpKTCADkihSTB5stsSUFzGuldthaVX5b2r
	 mYJvOwTSdQqeGwq6smpgIICvc0j65VMPFnkzos2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1994e2ecf323ed90f255@syzkaller.appspotmail.com,
	Jiahao Xu <xujiahao@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0545/1005] net: usb: cdc_ncm: dont underflow the NDP room check
Date: Wed, 25 Nov 2026 15:31:23 +0100
Message-ID: <20261125143834.511231278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Jiahao Xu <xujiahao@cmss.chinamobile.com>

[ Upstream commit b507828c7b6135ff7a4b69eba6e33502b4839fb9 ]

cdc_ncm_ndp16() and cdc_ncm_ndp32() verify that the new NDP and the
datagram fit into the NTB with an unsigned subtraction:

	if ((ctx->tx_curr_size - skb->len - reserve) < ctx->max_ndp_size)
		return NULL;

Nothing guarantees that skb->len plus the reserve stays below
tx_curr_size, and when it does not the subtraction wraps around to a
huge value, the check passes, and the skb_put_zero() of max_ndp_size
bytes that follows overruns the NTB:

  skbuff: skb_over_panic: text:ffff80000db33558 len:428 put:172
  head:ffff0000c2c66100 tail:0x1ac end:0x140
  kernel BUG at net/core/skbuff.c:200
  skb_put_zero include/linux/skbuff.h:2595 [inline]
  cdc_ncm_ndp16 drivers/net/usb/cdc_ncm.c:1132 [inline]
  cdc_ncm_fill_tx_frame+0xdf0/0x30e0 drivers/net/usb/cdc_ncm.c:1309

Here tx_curr_size is 0x140 = 320, skb->len is already 256 and the
skb_put_zero() wants another 172 bytes.

Two device controlled settings make this reachable:

  - dwNtbOutMaxSize = 320 caps tx_max at 320.  The lower bound computed
    in cdc_ncm_check_tx_max() is max_datagram_size + max_ndp_size + the
    NTH header, but cdc_ncm_setup() clamps tx_max before
    cdc_ncm_set_dgram_size() runs, so max_datagram_size is still 0 and
    the bound is only max_ndp_size + the NTH header.  It does not
    reserve room for one datagram plus one NDP.

  - wNdpOutAlignment = 256 is accepted by cdc_ncm_fix_modulus() as long
    as it is smaller than tx_max, and cdc_ncm_align_tail() then pads the
    12 byte NTH header up to 256 bytes right before this check.

An NDP can also be added to an NTB that already holds datagrams through
cdc_mbim_tx_fixup(), which uses a different signature per MBIM session.
On plain cdc_ncm the chain lookup in cdc_ncm_ndp16() returns the
existing NDP for the single signature, so there the create path is
normally reached for the first datagram of each NTB.

Rewrite the test as an addition, which cannot underflow and gives the
same answer whenever the original subtraction did not wrap.

Fixes: c78b7c586657 ("net: cdc_ncm: refactoring for tx multiplexing")
Fixes: 0fa81b304a79 ("cdc_ncm: Implement the 32-bit version of NCM Transfer Block")
Reported-by: syzbot+1994e2ecf323ed90f255@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1994e2ecf323ed90f255
Signed-off-by: Jiahao Xu <xujiahao@cmss.chinamobile.com>
Link: https://patch.msgid.link/20261111124156.637661-1-xujiahao@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 3bd7cb66f3fc3..3c6ac561fe863 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1125,7 +1125,7 @@ static struct usb_cdc_ncm_ndp16 *cdc_ncm_ndp16(struct cdc_ncm_ctx *ctx, struct s
 		cdc_ncm_align_tail(skb, ctx->tx_ndp_modulus, 0, ctx->tx_curr_size);
 
 	/* verify that there is room for the NDP and the datagram (reserve) */
-	if ((ctx->tx_curr_size - skb->len - reserve) < ctx->max_ndp_size)
+	if (skb->len + reserve + ctx->max_ndp_size > ctx->tx_curr_size)
 		return NULL;
 
 	/* link to it */
@@ -1180,7 +1180,7 @@ static struct usb_cdc_ncm_ndp32 *cdc_ncm_ndp32(struct cdc_ncm_ctx *ctx, struct s
 		cdc_ncm_align_tail(skb, ctx->tx_ndp_modulus, 0, ctx->tx_curr_size);
 
 	/* verify that there is room for the NDP and the datagram (reserve) */
-	if ((ctx->tx_curr_size - skb->len - reserve) < ctx->max_ndp_size)
+	if (skb->len + reserve + ctx->max_ndp_size > ctx->tx_curr_size)
 		return NULL;
 
 	/* link to it */
-- 
2.53.0



