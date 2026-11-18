Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057587;
	b=AmH+PXrpzx4345sNJYssjbbVF5SzEzG0O6CZBDcrZig1y7YOepXX9JDDBfHmYcBOtEbf
	 EaG6UT1lGemsQOGe8Fv/Fntb73OZlx5J1qMFt5A5XRqqjjI6NGlaJJcKIi+h0ddTrd6Pj
	 UAI4IbmvdIXUCGiKPv4NKCTDC3HHO+UahnUGVQOJGgqza4GtMOYzizbNSLJ15Oo6ah2GC
	 z94+H1Q0EXIFDxGqWNCuPK34VZcQPmlG1P/Cyn2w2GA+EpLvIEB8hmobYVO6rJfzwwYO5
	 NfGIHVx+HKT8/W1B/5mKekVpf89A0ZmdqYIPGy1eRe6difUpdbLIGZvtXvdqxas8EoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=B6UBzrL2MXFoCmRlwEXRuZ+Tvz/nGBFD1N0BPmo+MR0=;
	b=YfT0EI81f9J0zhdI1rmnRhzIR0sjMWP2XaXBogt+HZ1iH3kAFSxYrkMiS9EFe7+psOwF
	 0ObR4VmCwgI33jG/3220pM9Cg4q7CM6dz1VbFHbgxjnY5D4cBzXvIUNE3t5IgWI2/esg2
	 7vWEpCXzZ7l4ZPj3AzetzGt8Z+uoaBeYRK2rWUNzOnKeiq9O3q6OoJOYxD/f3OGKFGzD4
	 L1I1hT01JeJI0eOUZiJmS+0vT1HlDp6/v3wyXIq/5//nn1JnSA+s8nOvs0lAhDp7wkS8m
	 ASyM7O9RBhrcfQtZDi8zqLyXDjjwxIKg1MNieb3q2WZrfZ6yh4yfeRAtqcui9aq95MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nLMbQVT7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF45C606A337;
	Thu, 19 Nov 2026 03:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nLMbQVT7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2B41F000C4;
	Thu, 19 Nov 2026 03:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057587;
	bh=B6UBzrL2MXFoCmRlwEXRuZ+Tvz/nGBFD1N0BPmo+MR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nLMbQVT70F97uXR0Zj8crcJ1qUR6yTbGfyNymasPUeaYZuXneSLY7zh3CqODhLfCm
	 0yUAh3BECEQtxa9/NvgVkQCUDyceI3tMlxN9wwJ1S7ROZ4Tj4yW8YKCCasGjz6f8tG
	 QQZjf5HrWH1giaHMKn7vBSRfGvxQXVQNLiaPPYYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Israel=20T=C3=A9llez=20Garc=C3=ADa?= <i.tellez@btesa.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0176/1848] libbpf: Fix ring buffer consumer loop on 32-bit position wrap
Date: Wed, 18 Nov 2026 15:36:54 +0100
Message-ID: <20261118145918.904457988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5e242be45206a..d850f6d731cd7 100644
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



