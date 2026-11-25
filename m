Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617905;
	b=xv6dpxO995TZ+XsHlke1KUvDyOGoJAq3SWI5jUrmzT0H0YzsRhCJYRb1ZdQBdDJ1k9VZ
	 xTp7ZvC9HynS0kIHFTZy2ObSosv0x19jRy50Ib3lR6cxERUVpbdrcE4pziImv+3BC8+Vd
	 WCYVpG+GA5xik0sfEY19FOPPY9OQQUUUkmvrRSH0cbwkBiq2Lao+Qg2b365quVaDwBTPS
	 gnsGuPXbTM1fDVLgnBOQ0/EmhBpQ1Eeo/2q+j6YbpBBIyHfdqtuA11TYOlk8KwotgEfF0
	 Qm0LAXnoBMcWWfrOujf1+lQdZPk86IA3a+azCuG/+VMPCLmfzUQaeTn3Z65SPdTwFtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=goBEtdT1Jcy1lj8Mtwvw961P99cbRfgfNRweaj5Uqo0=;
	b=Frfq22oAEQvt09bC+oiW+tC0YzOIR0aONGT+dwWRBrEYu15TR/I1PqJrJcp6h2cb6ktQ
	 9azgFBpTwL5kGCR7lWKDMJxwj2eN/yU3OhxjsXVBIwPwhgFKY6UUUllTptUUZDpLyyDQh
	 7C4wFnCEpV3WPj8Cl3hs9r6VyvpHkvobr/wmF4oF4G2vKANQaWgBgab1Y5pKv1mO27+s1
	 FSccxDXb+DE1ckme2m6/4KlifSckZz+FSLHSNV38uiesbMMd3FjxqI98INRDOU33HGlAx
	 PkMGBcLx0on5lRN0aT2M0cUyDL6HQgSKWv2M82wRY9m+vSz8akEt9CRWzL6xrmplFHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qb6DmPD0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BE5606A335;
	Wed, 25 Nov 2026 14:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qb6DmPD0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA8A1F000CF;
	Wed, 25 Nov 2026 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617905;
	bh=goBEtdT1Jcy1lj8Mtwvw961P99cbRfgfNRweaj5Uqo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qb6DmPD0AcYEC0NNhejjKlDz8+NqjxjW9w32ljsIRU5prkF9WDoJ39Ul6rw6DbtyJ
	 GfX2Z6fODJnBF4cW4lmWmczUvynXRqsJKxzyLecWxgCTMmsKZF6U9da3wskW5gPCre
	 aIKyuN682XZVan+4/epNcAoS4Dqk/PviolAeUwfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0110/1005] bpf: Dont look for the SRH again in the End.BPF helpers
Date: Wed, 25 Nov 2026 15:24:08 +0100
Message-ID: <20261125143824.321587993@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 45bcc58d576705d2c001332766e10313f1c55bad ]

A packet can have two SRHs. Thus input_action_end_bpf() uses
IP6_FH_F_SKIP_RH to skip routing headers with segments_left 0. The helpers
bpf_lwt_seg6_store_bytes() and bpf_lwt_seg6_adjust_srh() can reallocate the
head of the skb. Thus they look for the SRH again, but without this flag.

  +------------------------+ <- the helpers: srh_state->srh
  | SRH 1, segments_left 0 |
  +------------------------+ <- input_action_end_bpf(): srh_state->srh
  | SRH 2                  |    and srh_state->hdrlen
  +------------------------+

Then the helpers check offset against the wrong limits. If a helper changes
TLVs, seg6_bpf_has_valid_srh() writes the length of SRH 2 to SRH 1.

Neither helper changes the offset of the SRH from skb->data. Calculate the
new address from this offset. To add IP6_FH_F_SKIP_RH is not sufficient,
because advance_nextseg() can set segments_left of SRH 2 to 0. The helper
bpf_lwt_seg6_action() can change the headers and still looks for the SRH.

Fixes: fbbc5bc2ab8c ("seg6: ignore routing header with segments left equal to 0")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-20-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 0cc65aff822aa..2d64d661c0bef 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7024,12 +7024,13 @@ BPF_CALL_4(bpf_lwt_seg6_store_bytes, struct sk_buff *, skb, u32, offset,
 		this_cpu_ptr(&seg6_bpf_srh_states);
 	struct ipv6_sr_hdr *srh = srh_state->srh;
 	void *srh_tlvs, *srh_end, *ptr;
-	int srhoff = 0;
+	int srhoff;
 
 	lockdep_assert_held(&srh_state->bh_lock);
 	if (srh == NULL)
 		return -EINVAL;
 
+	srhoff = (unsigned char *)srh - skb->data;
 	srh_tlvs = (void *)((char *)srh + ((srh->first_segment + 1) << 4));
 	srh_end = (void *)((char *)srh + sizeof(*srh) + srh_state->hdrlen);
 
@@ -7042,8 +7043,7 @@ BPF_CALL_4(bpf_lwt_seg6_store_bytes, struct sk_buff *, skb, u32, offset,
 
 	if (unlikely(bpf_try_make_writable(skb, offset + len)))
 		return -EFAULT;
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
-		return -EINVAL;
+	/* The head may have moved. */
 	srh_state->srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
 
 	memcpy(skb->data + offset, from, len);
@@ -7162,13 +7162,14 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
 	struct ipv6_sr_hdr *srh = srh_state->srh;
 	void *srh_end, *srh_tlvs, *ptr;
 	struct ipv6hdr *hdr;
-	int srhoff = 0;
+	int srhoff;
 	int ret;
 
 	lockdep_assert_held(&srh_state->bh_lock);
 	if (unlikely(srh == NULL))
 		return -EINVAL;
 
+	srhoff = (unsigned char *)srh - skb->data;
 	srh_tlvs = (void *)((unsigned char *)srh + sizeof(*srh) +
 			((srh->first_segment + 1) << 4));
 	srh_end = (void *)((unsigned char *)srh + sizeof(*srh) +
@@ -7200,8 +7201,7 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
 	hdr = (struct ipv6hdr *)skb->data;
 	hdr->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
-		return -EINVAL;
+	/* The bytes in front of offset have moved together with skb->data. */
 	srh_state->srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
 	srh_state->hdrlen += len;
 	srh_state->valid = false;
-- 
2.53.0



