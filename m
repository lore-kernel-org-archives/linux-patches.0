Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041200;
	b=YZF5bwHVzs135uBMR+8zUZTDxw7s2uliSKNha1Gpzme2LjQoR0MdCJgXBbJ+P1/TD/JE
	 5E9e2NRrRS7tCVd2PZllQDJF7OAAepO/MZyrQ5UgHVIcaHEzxMCI01SFX0eWnvQn+f2WL
	 b6trCdKOKV0qfE+s/wk2vFNUo0Shz3pWNEz38c2EgNUvF1LVqjZEZ3Pil3z4NABbf0i7y
	 pB1AAYTpj15jCDVoosW9nxaDlClroE1WOGeFdJgi1g1fxQXTQdt9oXOhrPM5twCCMQDV5
	 H4nrt8hNhyb+MH/srMcxPq6ShnisnClnnh6Y+nH6me4pHYfLrpYNZaPl78MKaRn1sXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xP26qoJjHIdKWVO0/Y77X5HraTeqdHMDrq8XEGWMHVw=;
	b=yVYug0y03TLATnG39OcPpb3o/5jBNDyyNvBeloX/no07RcCL2d5jcAHchHbiqUCw8N8I
	 VNw9L56t10I+byj7ZoM2+FElXtH7V1YV4G9OJU0RvNqKpbN1ihrGXwMhNjyMB3GVG90x5
	 gSeqvh+w/56oB+YFf3wc3HU9Xh0EHeht6NkmG+1VU8iQ+N57xe1k37EC7BGjLR0f/Q1gJ
	 HpizHeQVz4Jx0U2nU4Fe93pR8JpiC+tP1yyN4ULdsytIBkCZagJNzbobPNDwppeqKvfNQ
	 YHxUxoseJeqyQf7wYRI5ThOk6sSmN+Xx4rVVWnFRxt3MnUTIu+FQLgtvUjI5Ckakecg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n+1CvWlv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13900606A320;
	Wed, 18 Nov 2026 22:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n+1CvWlv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643DF1F000C4;
	Wed, 18 Nov 2026 22:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041199;
	bh=xP26qoJjHIdKWVO0/Y77X5HraTeqdHMDrq8XEGWMHVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+1CvWlvA5r9IDn8XgQFR3ToMOEY82Fnc6/OLrzpVYHp8a+F4fIKLfH9cNotN5hiN
	 ys2Kw1+s24cbsvXGePgKk62Vy10e9XvmtZ0ZhlWYxukWJbNOfv3UmMbfYQkY0jw/dn
	 tLGJVnhT2z4AVNJ7YWC+iaNM5vYFRFWadTkEUYZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Skokov <skokovmaksimevg@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2729/3318] bpf: test_run: Fix false -EBADMSG after skb leaves CHECKSUM_COMPLETE
Date: Wed, 18 Nov 2026 15:55:51 +0100
Message-ID: <20261118150442.692289515@linuxfoundation.org>
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

From: Maxim Skokov <skokovmaksimevg@gmail.com>

[ Upstream commit 36edb1c7738dade8ed83ec4e0aef000e538b2095 ]

With BPF_F_TEST_SKB_CHECKSUM_COMPLETE, bpf_prog_test_run_skb() computes
skb->csum over the packet from the network header to the end and marks
the skb CHECKSUM_COMPLETE. After the program has run, it recomputes the
checksum and returns -EBADMSG if it does not match skb->csum.

bpf_skb_change_tail() resizes the skb with __skb_trim_rcsum() and
__skb_grow_rcsum(), which move a CHECKSUM_COMPLETE skb to CHECKSUM_NONE
and leave skb->csum as it is. The post-run check still compares against
that stale value, so a correct program fails with -EBADMSG. After a
trim, skb->csum still covers the removed bytes. After a grow, later
writes cannot update skb->csum, even with BPF_F_RECOMPUTE_CSUM, because
skb->csum is only adjusted for CHECKSUM_COMPLETE skbs.

skb->csum only holds the packet checksum while ip_summed is
CHECKSUM_COMPLETE. With CHECKSUM_NONE the stack does not rely on it and
validates the packet in software, so there is nothing to compare. Only
do the check if the skb is still CHECKSUM_COMPLETE after the run. A
program that keeps the skb CHECKSUM_COMPLETE but leaves skb->csum stale
still gets -EBADMSG.

Dropping the checksum offload is documented behaviour of
bpf_skb_change_tail() ("implicitly linearizes, unclones and drops
offloads"), and the stack does the same in other places, for example
skb_forward_csum(). The test harness has to accept CHECKSUM_NONE either
way, whether or not the helper is later taught to keep
CHECKSUM_COMPLETE.

Fixes: a3cfe84cca28 ("bpf: Add CHECKSUM_COMPLETE to bpf test progs")
Signed-off-by: Maxim Skokov <skokovmaksimevg@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261009174755.22026-2-skokovmaksimevg@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 8e665cee22503..b7e84ad5c73a3 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1101,7 +1101,13 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 		memset(__skb_push(skb, hh_len), 0, hh_len);
 	}
 
-	if (kattr->test.flags & BPF_F_TEST_SKB_CHECKSUM_COMPLETE) {
+	/*
+	 * A helper such as bpf_skb_change_tail() may have downgraded the skb
+	 * from CHECKSUM_COMPLETE. skb->csum is then unused by the stack and
+	 * there is nothing to validate.
+	 */
+	if ((kattr->test.flags & BPF_F_TEST_SKB_CHECKSUM_COMPLETE) &&
+	    skb->ip_summed == CHECKSUM_COMPLETE) {
 		const int off = skb_network_offset(skb);
 		int len = skb->len - off;
 		__wsum csum;
-- 
2.53.0



