Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060377;
	b=oaWqxDGaSYJSsRUhZK8u2TtbwPqA3dGQ1gsroHELM1xLSaN+hj6MOm6E0ZOwSl89Qxi5
	 FlKIPufcHinh4Jk0MvuvFWLX/K0yZAZg69SIEn203YEXxXcs1gryBCq5TaYAV2lB7+Xz4
	 skpIrbkdQ4a2hiLjCoB5fItyP0wNXJfonpVIZsResINSzsmklv8/oJtQgG+j4jdXdOMPQ
	 WhH/yxDY0p35ozTxRaABC1oG3Og74+Sro3GPlbXFA6JovnpVHU2ZbfQebfd9Pg4TowJB0
	 PpabZlBQs+9I3ouTfvW5gRsz6tqhX75RpSHirS9q5ydBkmFq4GMmrscIfKrcuZCqhqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j0oQhYNGeFqSLSDT1CECLYATXGgrwmgGwBHybffljDM=;
	b=eVcYNMrYdnkoAsShc6O3+3zuhgHELAxCAOG9A7X7zU25NmeOk2qHL48AKqDXZcnUPX8a
	 KpQDKsf0Hkqk2qZPfBYT4xbQ8VNzjLDFOlTUlqTsG2ZU7xXjc4opOFyc00WdA3PMXJMYQ
	 wIJKoeiwXmacw1setPDxkpebwPGuB+OF1zxI3Ukr56go/df1pt/s51Tn92y7/c7ZeeMHt
	 2MjAwm+tzHAXYRqSO61AzRFo6DS5ihs1QMsdqwr6SB9t7ZI0Nw7DE4NZKTY7ghUUuWEVd
	 BKBvmP4UEFktArgJvKwaUjY4vasGvSd8NFHl0cgYpAiZY99PxaNzWcWl8fYxZgjdXHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pdNGhXH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB7D606A331;
	Thu, 19 Nov 2026 03:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pdNGhXH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640841F000C9;
	Thu, 19 Nov 2026 03:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060376;
	bh=j0oQhYNGeFqSLSDT1CECLYATXGgrwmgGwBHybffljDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pdNGhXHHctYuro9gw7AXOUtMTLiG8q6zPxu+xQ8DEFMBNB0Akr8uhUHPEKUrSIfh
	 dN23vu+AIBGxW3AMtoSV70xM53N4z2yHhAD6757NroJwwqmvk56+65dv3Pe/XDHZuL
	 bZGPIwABG+Yyx2OYra2kh1chcfwEb9ZYMJpeTMnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+229d761b8a110e6de517@syzkaller.appspotmail.com,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1177/1848] irqchip/gic-v3-its: Dont WARN on LPI free allocation failure
Date: Wed, 18 Nov 2026 15:53:35 +0100
Message-ID: <20261118150008.859267045@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5094ef561bd2c..8b11d5f5f4058 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2181,7 +2181,8 @@ static unsigned long *its_lpi_alloc(int nr_irqs, u32 *base, int *nr_ids)
 
 static void its_lpi_free(unsigned long *bitmap, u32 base, u32 nr_ids)
 {
-	WARN_ON(free_lpi_range(base, nr_ids));
+	if (free_lpi_range(base, nr_ids))
+		pr_err_ratelimited("ITS: failed to free LPI range %u:%u\n", base, nr_ids);
 	bitmap_free(bitmap);
 }
 
-- 
2.53.0



