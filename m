Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043527;
	b=glbAYDKvGKqvaYSEqpttCZV/iodq4/7Z3O8UwGfot4fLlqtN0efSsFYjL+rycHHFKAFD
	 AqGN1N/NhUhZ3AgGWv6drr5tqJ3zynGiOL0DUt/RIcg97A0qB5j/42LQnX8B/x30JXFFO
	 4YjhH1JpOnZSa2vlc2gEZ5Y8PcmHkD16YzKFf/LKuuF/+1ZO501NzsN9nGVjPGbaUQz9v
	 kS52fkOlJkDYvHtWZ8/t3SAClRJ4lcJMwjZJuMpWqnqsaQffDuKrqczov3GjGPBwE6PwR
	 AoZy92V4UVfZSw+FnbrdgADfrb5b8YPuWw0DfwJn9cH+AezgRKgPZ4BKRyUl5PKmbRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nvBxmgIQ1tgdjH+QIW2P5lNo6y2+0sh53I4pDD5UdJo=;
	b=yNItH7BTWxi7SlG1xMTfbVx2d7tPccVDbbkfyxTTjOOV7WEjsCwonHcczEwY5/wQ1g49
	 /4yZkqhD4WZ0KQMsTJvaUlSHI5iJFHO94nO6XeggxrPRshA6bESN1J1kZZ/t2QH3mAMw2
	 THPPDNCXhJXxhATMYi1lwNJP4X3y537AS7amAp3hePR9qhKltZ8vp/tPrHJP6pprWdDP1
	 Oie0YNT39KOjFqaXyygqUMS792rGklp5FSoljJ3IWJn1SmLBOvy1uUMtkqt922Sa3rl6Z
	 g7w/znf/mwvttIKI+9Zdt0iZHbKfUEivsS+heWUw0eHwLpL6L9/mhdO8XcnhdI+wIOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qjC+kMmi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DE8606A31C;
	Wed, 18 Nov 2026 23:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qjC+kMmi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5B31F000C4;
	Wed, 18 Nov 2026 23:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043527;
	bh=nvBxmgIQ1tgdjH+QIW2P5lNo6y2+0sh53I4pDD5UdJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qjC+kMmiN8kKMcjtmDhADUraRcpf4FEVA/VwUwWB+rU3TYBAZg/auU18XxYHuFqjk
	 MAC8LEr/ttBCiYm+ije3DbsWHoozuBUglhA3GsGw0fa9SNYQnRzE4xe5vgU7UWC5Ql
	 teWFEgPWjfZd/07dm1wIpbq+zFsKsV4aBJ+WW8Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Israel=20T=C3=A9llez=20Garc=C3=ADa?= <i.tellez@btesa.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0243/2857] libbpf: Fix ring buffer consumer loop on 32-bit position wrap
Date: Wed, 18 Nov 2026 15:21:17 +0100
Message-ID: <20261118150210.198217656@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6af142953a940..484f350d31e80 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -237,7 +237,7 @@ static int64_t ringbuf_process_ring(struct ring* r)
 	do {
 		got_new_data = false;
 		prod_pos = smp_load_acquire(r->producer_pos);
-		while (cons_pos < prod_pos) {
+		while (prod_pos - cons_pos > 0) {
 			len_ptr = r->data + (cons_pos & r->mask);
 			len = smp_load_acquire(len_ptr);
 
-- 
2.53.0



