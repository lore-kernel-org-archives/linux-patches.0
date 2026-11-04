Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830918;
	b=g8fiqWF97LymOo0TFxjZNInMeNEqZLbJey4N23q2F4ditpQasB3WbYrwxMyh+Ln2nr3B
	 s23yOzqTYPyK/fRKWuL1PK3sIWf1+nJVspzdCaJmFlis0IBOcwTOlF9hxvG3428pgS4DY
	 m2tx4/s3Uxb/qg3arcH5W307SDOXPou40pFK1+MD4kAK0dCAeRzahDxGzA4kD5pb4hW58
	 p+E9G4VZV+KWGknZ9ZvgZb1uziXAK0RiXwYuhLSmMZdS1e7/wFjOX/WzcDz60PYS+KQ4n
	 0+RJ0gWZwgdeDDKaON506i3Qu36yOtvQ7lDawOhrq9gP9EnEsr7TiOyFaKSKbjZy6OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rnGZ4UwO4a//hOrC/TGC0FCDXGuRBNGb0QdhIbPHxRs=;
	b=BgP35FIfmTcWscHcN843hsQ8qwMyX+Sxwvnik0hGe5JcYmv0OyAWhTsVQx4nZzBOKJkW
	 CUZiJJ9rrqUD25t6UfIYlQflN8YXt7khitdS1zRkSo7/izdc8czBvciBl8EqAd621GRX6
	 aq2LtD++mVP2XYebx3G708QF7X5XgpaTrNtyAZyjpjprh2QGRht2pzuKrCi5+59Pjvs/o
	 D3ZEPCqKT49WN/fep3nLNfjtiankdouMbIN9LdOjgCqRnCl+MBbP9lbfv/Q2AsyxpXLvh
	 6JV7Zx9XR7DoGUh+HfZthVdBho4o9wPlZgZXoYHtH22G+qkQbr9vviXSe49K/+UMSIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1b67Lei1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7AB606EEBC;
	Wed,  4 Nov 2026 22:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1b67Lei1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8761F00A02;
	Wed,  4 Nov 2026 22:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830918;
	bh=rnGZ4UwO4a//hOrC/TGC0FCDXGuRBNGb0QdhIbPHxRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1b67Lei1ApPxqGDtxWHHPkg/38i16o+K2tri5bJbfuWnH8aSVnhu6jrIWHNW1eiXm
	 jQTOobbhmnxJbLXkvVfwtzIkKEs8+o8L9PbQV2cLHcHEBOspXbdZRE+uCPxka3O/1T
	 p3auQovw5rYHTRdubqxap7YKWRbY8Qi32hyodShc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Israel=20T=C3=A9llez=20Garc=C3=ADa?= <i.tellez@btesa.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0401/1005] libbpf: Fix ring buffer consumer loop on 32-bit position wrap
Date: Wed,  4 Nov 2026 16:02:14 -0500
Message-ID: <20261104211055.307543742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 00ec4837a06de..c8fe57401a8b5 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -244,7 +244,7 @@ static int64_t ringbuf_process_ring(struct ring *r, size_t n)
 	do {
 		got_new_data = false;
 		prod_pos = smp_load_acquire(r->producer_pos);
-		while (cons_pos < prod_pos) {
+		while (prod_pos - cons_pos > 0) {
 			len_ptr = r->data + (cons_pos & r->mask);
 			len = smp_load_acquire(len_ptr);
 
-- 
2.53.0



