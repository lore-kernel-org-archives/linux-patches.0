Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061040;
	b=m5JvP4YmlBd5y5F1Ejo8g3NKi3AEmTRU7rxWYo5+BsUwDKgztt0tNuLOF8oO8hsIoV1i
	 Gbg2NIHZi2tUjh58WPDhSYyinluGBuW3SywWrK/GjypVHwLvUBV5rVHUt8jj0WvEx5LF8
	 Sz4Ggpmz/WBzBjUroV70+2iPAgMrUzRv2xPkc4dr4D/6dMWr5wVoZOTHdHcUXCH1/ut9Y
	 6jDurbuVIn7gv6wSLi5j/2OEzK6avzxeoQuRRKst7fXs6+yX4vfuth0LMC2eV53bpmcuP
	 2YHtW7U+Kumiy926uB6b4XNX5by7ItsVot8hnxxH7Pp0R/FaHSiqdRfPVkBiimPsseA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Vcd2tFHVVycaYR7+Jeay/bdgMTDsqJky3zz9Cb29gG4=;
	b=eehWRXysQjhcMdaDy0uaPm67G/nBworOiFWzKjGR1W2Kx1QansN8caoZZtpLjgTYWljc
	 ZuCR5jHg0rhCyRbP6GXi56UNp8Lj3uLXXj7SLRpbG1HFe3NtRFqH9TUplSDNMDUAJGFHc
	 5wEBSLtLB2DP0XMR98Mym/E8NPeeMNdVESPyjSKcT4zGQEc0PSi1hUEtbeh1VAetAqNlo
	 TcG9dyAredp7hREKH7snITaTh2YWmsSE8dSMA4e8vG2WNLhIr58rk/LOMS/sPOEMMeB4X
	 1BG2u8YOZh6OST8WNHj/ZOPixF7wpTJCX7O4vei27RkDsk0rkM2vIIe4bYbji4uNiwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uehhlien;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874F6606D816;
	Sat,  7 Nov 2026 14:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uehhlien
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5711F0089F;
	Sat,  7 Nov 2026 14:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061040;
	bh=Vcd2tFHVVycaYR7+Jeay/bdgMTDsqJky3zz9Cb29gG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uehhlientWbKxKg8XnXwWj3/YEyZOLCmBfV1375g5L2ojKLytEEZgfza3LQBvd9oG
	 zpmRG8nrJW2gqek7r8A2O98JHldmzhV4RfEzLdsc51nvwzKLGaZaeZPMoDKeF3VTWT
	 EeViifflgRBGbGq3c+DbIIfNhX6H0eWvll4Rwk7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Israel=20T=C3=A9llez=20Garc=C3=ADa?= <i.tellez@btesa.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0335/1536] libbpf: Fix ring buffer consumer loop on 32-bit position wrap
Date: Sat,  7 Nov 2026 08:39:11 -0500
Message-ID: <20261107135007.101548810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bfd8dac4c0cc0..a813320361888 100644
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



