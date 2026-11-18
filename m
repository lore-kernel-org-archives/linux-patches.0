Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051594;
	b=Zs+trSu8V7mXi8Mlx+ulW5aLD+iwsvYk84941AWEQUMzhuF6IADjfdMn4MUpWqHuBizP
	 s/mm3mN2V1eM/qZ/aC+XT3Z5WdsmKMpU5+hY3Dwf1aWDUPa4beG6EYrvgvXMImPgzFXO1
	 fe1/b1j0dqIAXazgcequ328mSuCE/BOfFVeJOboc6rRGQFqqqbDvHh31iIGS+D+5J67zE
	 kTYmCqptslAMZPIil/JilxHvTDBL6kp5qFV2XAyjJKUbSkSt5jMxh8UWn4KHBRm43fIbs
	 RUgXZDemvLMY6dpA8d8koHIgfrFHAl2t+OmoWeFTylcSyfiAUsmYJJEWLe1F81K6i4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GXWs9GIdMJo55QJkWfA3uyT7BtcwpV2fY/coDI0+nBY=;
	b=2tv3pfcIHL7o3t0AtsdbC0X8nF+JDi9bO1ygHpnATTvsq2Zqg54lxjQnkc3b/9OuJ+nA
	 ckGYvvXZPQ/w96YVivjAkHQp17MxzCN4CVKCc9QU3cn75CLqNaVdJd5Vc04btk7RediSB
	 VZsBbyr4c2j9nwo+pV0exPjiZlxv0wjcJUyVf1jbDrpJxdOEThztZHtVGi42HxLELw+wI
	 6ODC1jBr9phsW0RqaFsPmiCZvCDcv8A4lG7RhmS2NQljEm4My0mf3ljGeFDknThbH9VON
	 UVYnTpO73Cpg7TpbNHgLVfDL2idsxrqpkmg7zQuVjG05pK2tQbBkubHqDnTsYFNTg5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NvScpbyx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C36606A325;
	Thu, 19 Nov 2026 01:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NvScpbyx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C048D1F000C4;
	Thu, 19 Nov 2026 01:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051594;
	bh=GXWs9GIdMJo55QJkWfA3uyT7BtcwpV2fY/coDI0+nBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvScpbyxa+N/Mzv0zQeu4rqK+kfqj5JWMWEKXgqZ4W3j9DnP1ekp8tcrxretUeW1D
	 CeLoOKSiOEQe0dn0F+gCcx9S+QnNK7vfqn2mOWgzQYJKOnDFf5CSr8LK36UTMrVZG3
	 CBc0txbwCki5XHmK+aUkvU+hd2K8dyOY3eLkdTUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Israel=20T=C3=A9llez=20Garc=C3=ADa?= <i.tellez@btesa.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0207/2214] libbpf: Fix ring buffer consumer loop on 32-bit position wrap
Date: Wed, 18 Nov 2026 15:31:23 +0100
Message-ID: <20261118150018.485890815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Israel Téllez García <i.tellez@btesa.com>

[ Upstream commit fdd4fad0bbbd08501465c5f9b556963093c5d58a ]

ringbuf_process_ring() walks the records between the consumer and the
producer with an ordering comparison:

	while (cons_pos < prod_pos) {

cons_pos and prod_pos mirror the kernel's ring positions and are
unsigned long here too, so on 32-bit they wrap at 2^32 bytes of traffic.
When producer_pos has wrapped and consumer_pos has not, prod_pos is the
smaller of the two, the loop body never runs and no record is consumed.
Since consumer_pos only advances inside that loop, it never wraps either
and the consumer stops delivering samples for good, with no error
returned to the caller: ring_buffer__poll() keeps reporting zero
records while the kernel side fills up and starts dropping.

Compare the distance instead. The consumer never runs ahead of the
producer, so prod_pos - cons_pos is the amount of unconsumed data and
stays correct across the wrap.

64-bit hosts are unaffected in practice: the counters would need 16 EiB
to wrap. This is the userspace counterpart of the kernel-side walk fixed
in "bpf: Fix pending_pos walk on 32-bit ring position wrap"; a 32-bit
consumer hits whichever of the two comes first.

Signed-off-by: Israel Téllez García <i.tellez@btesa.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260814124843.22041-5-i.tellez@btesa.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/ringbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index c42ba9358d8ce..f04956f2cdffe 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -219,7 +219,7 @@ static int64_t ringbuf_process_ring(struct ring* r)
 	do {
 		got_new_data = false;
 		prod_pos = smp_load_acquire(r->producer_pos);
-		while (cons_pos < prod_pos) {
+		while (prod_pos - cons_pos > 0) {
 			len_ptr = r->data + (cons_pos & r->mask);
 			len = smp_load_acquire(len_ptr);
 
-- 
2.53.0



