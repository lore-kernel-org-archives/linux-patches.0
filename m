Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015673;
	b=1b2e8T+OPYX8GUhNk/s7jWV0XMpEBzSbMqXK8P/8eG68ejKxjSnW5EmEnMRM/jFqbbiE
	 i7AU1yshxT3DCy64XDQByMrYC2jvYm2UH6XrLqU94vWGM05UfJ/mGw2MK8oYoHkcQofla
	 7CvMnWm+jnX0Myj9+ytPhEZe1UBQW5CKx2iPFcyC3x49huDuE6RejGqUvD0TmY5XAf+CH
	 0fuTl41DTIEeNEAfnslNKiR4slSMKqCjsVeiKX/PbxvYpbc+xu6syagme5H17KjmUg9NC
	 38sWoUNORgtUsDbMNJvYwiQt+3zQSy08pyYyP2MVxjmd+aOPvN6Gmsi2T2kVb1xANLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zSMcOgsF8b7/22ByKUH99zi8gjz1zf06k8gyYE8gVOA=;
	b=FmYb0TDmmq3duej7dnBzmOWB6dg9MUNZtj2YjmtIwA692AlNHdF9j1tYov37woIlxMvW
	 VVrDXhXpSho6zUtnpyYqrroIxaExI2geHsju9KvgZw9x/XHuUS40DKFZQN8b1S4SXPvpS
	 4fR3AYGFKTIuc1woRi3rE0ahsuLTWk41RBurUyv1lOHIgESUx/5KoXoZOK4Flx0mGYRUx
	 RIfiOvqUBQCOZRVvE40EF4v5jTvRUroZGjoA71lu5i5IYTPUTelcR24YYZDETGaXtZicr
	 L/A5W22xq8gERYo2rK/0+vLtGk0dF0pHIiNF0md3uYtGY+S+ZNQXwN/GGTofDjDgS3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RKrtx1cz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C38A606A32C;
	Wed, 18 Nov 2026 15:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RKrtx1cz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667AF1F000C5;
	Wed, 18 Nov 2026 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015672;
	bh=zSMcOgsF8b7/22ByKUH99zi8gjz1zf06k8gyYE8gVOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKrtx1czB1CEQ7olMddtszNxM57G9+paSZEVOkcNTdtjkL28nTwExDnDXwpttqTHA
	 DgP54LQmFvbIqtg1d8qcweiENq5NAn1K/8ezkhEkAmrb/q6z0dbdZZ5QoeGre1StdB
	 IVZHpJ69Xh9Ca/Q3UcrLSgSn/fYZ2DJVEpeoMGX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+229d761b8a110e6de517@syzkaller.appspotmail.com,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0258/2651] irqchip/gic-v3-its: Dont WARN on LPI free allocation failure
Date: Wed, 18 Nov 2026 15:24:58 +0100
Message-ID: <20261118150257.152333633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 135d9e67f7ab4f261c2157ee2de1f93a4de39a41 ]

free_lpi_range() cannot give LPIs back to the allocator without
allocating a struct lpi_range to describe the freed range, so it
returns -ENOMEM (its only failure mode) when that allocation fails,
and its_lpi_free() turns this into a WARN_ON().

syzbot triggers the WARN_ON() by injecting a slab allocation failure
on device teardown, which with panic_on_warn becomes a panic:

  WARNING: drivers/irqchip/irq-gic-v3-its.c:2251 at its_msi_teardown+0x3a4/0x424
   its_msi_teardown+0x3a4/0x424
   msi_remove_device_irq_domain+0x16c/0x27c
   msi_device_data_release+0x38/0x9c

The failure is transient and the consequence benign: the freed range
is simply never returned to the allocator. This does not warrant a
WARN_ON() backtrace, so log a rate-limited error instead.

Fixes: 880cb3cddd16 ("irqchip/gic-v3-its: Refactor LPI allocator")
Reported-by: syzbot+229d761b8a110e6de517@syzkaller.appspotmail.com
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: Claude:claude-fable-5
Link: https://patch.msgid.link/20260811095532.48454-1-kmehltretter@gmail.com
Closes: https://syzkaller.appspot.com/bug?extid=229d761b8a110e6de517
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 81a96149f9154..1bef7ecd3090c 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2248,7 +2248,8 @@ static unsigned long *its_lpi_alloc(int nr_irqs, u32 *base, int *nr_ids)
 
 static void its_lpi_free(unsigned long *bitmap, u32 base, u32 nr_ids)
 {
-	WARN_ON(free_lpi_range(base, nr_ids));
+	if (free_lpi_range(base, nr_ids))
+		pr_err_ratelimited("ITS: failed to free LPI range %u:%u\n", base, nr_ids);
 	bitmap_free(bitmap);
 }
 
-- 
2.53.0



