Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034196;
	b=S8ixdt+XUvu2uMmgUQcbwYQv51nF4eJpz1+29pFiWz09diXVrsPWsFE0dBfvEfuWsdKH
	 SfcpGhljO/ttBjpyU7udCCQa8j9Qw7BsmAa+0vnxuOztVfY+eo1bO82hXQw6QSoimf2Fq
	 hrNEWiFEdZtGnJR2YCWc2L49ASk0SEfsuxZpj/QZJ7yphI9i8kJwqFt1A4W8mKlPoT9L6
	 AxUANc/TuywqeBemGdWfzrmSB7eHH5jfRb2cQw2emMAPbWdBaLjJRSDYgYQO4IRka/OA6
	 zfnAkvo9Y/7/A3XBsv/ETNBezYKbjgfDh5kAhT7qZc6iu/AXfTDUaOFucMoPmpbtr2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hO7sw47GdqrqlqG6ZtJpJDzYUTdltXOf3Yy1E2f3S8M=;
	b=G5E9DksW53Jl7lRHk1BsAe6TVNdRA9TzFwhxfx7Qt/ppBvNeTumRCH0M+NxRFMI8u+aB
	 OvMUT99LtkazqQtdjs47XPnvXx54oF0Q+CmDnj3cL6wCcnvV2VxLb+pRRwhiPerDMKPNU
	 W7rKYOndodZYXlv8XHT2x00aNj9svg2Rplg4jXZLHl9A1W6IMDEsWOY3V3JJ2PlPlprSq
	 G4ki0tpqEeMnNP6FpNQ4U7sENwwcIBC4RRGTL/PId/8Myb2qTqGRxWrgVnqGP5ECyYcRj
	 mbT2I9dCIUCKbk94rklOwhXwA/rNaOG+ELMMu1HXmRMg7N/13KsX9etsGNqK5r0Yh0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FqbRhUqr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D8E60A2610;
	Wed, 18 Nov 2026 20:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FqbRhUqr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5891F000CB;
	Wed, 18 Nov 2026 20:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034196;
	bh=hO7sw47GdqrqlqG6ZtJpJDzYUTdltXOf3Yy1E2f3S8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FqbRhUqrqtV9vfASLkhzTG/7oWvvT52Vv+1yVA2hw2CAkM6JmhukZWnk4yWLaXFCe
	 KUbGgOUTTHBhqcCwHw6evhsXZpLhevNrp0tZ44QzK9F8r/mfd0Guu/KuxZFfH1c89d
	 uP3rk13z1QzsTJt77xwMJRYjP9io6nioUscHLo0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Israel=20T=C3=A9llez=20Garc=C3=ADa?= <i.tellez@btesa.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0283/3318] libbpf: Fix ring buffer consumer loop on 32-bit position wrap
Date: Wed, 18 Nov 2026 15:15:05 +0100
Message-ID: <20261118150324.030331757@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 02199364db136..0683729d4e2f3 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -237,7 +237,7 @@ static int64_t ringbuf_process_ring(struct ring *r)
 	do {
 		got_new_data = false;
 		prod_pos = smp_load_acquire(r->producer_pos);
-		while (cons_pos < prod_pos) {
+		while (prod_pos - cons_pos > 0) {
 			len_ptr = r->data + (cons_pos & r->mask);
 			len = smp_load_acquire(len_ptr);
 
-- 
2.53.0



