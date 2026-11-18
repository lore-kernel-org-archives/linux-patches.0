Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039345;
	b=umXnOyytACohAJIaRMhPwR42Te3i5WzcgG0xpfkcP9KpsgiAeaER2bZXhitcidcpZhTT
	 f01mFAcyCVnzZvlAIJe5kPPEqxVTAJ15hOlmQWXqaEbgxvZG/l7AP5DJ+Z2McyjWLmKVg
	 yQceVtBHU76b3nzWlBx/992QPl4P31LlmE/qj3U+CuwI8yyTl3ARKdA/33XCVmlrLbosu
	 l+yoXAcAZ0g3+vuu3jUTkxbCASATtxzTPtYRyOc1PzMutMRgYOPEOrckePUQD7fF3O1BF
	 YI+tBeGGNG5zN+UnzCK6PcAgsK8m4br1TjQnXAwEfCdzt9i9N4JauNC+fe6vfv2Ik4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WV7rzBRIeG1vPoQBJdpFofbk4dhkYXfhOazSpJ+8dqw=;
	b=SSuhCsuxE8MCf+qtCbVwWaYjUru4vEZf6qtZY2n7qEyWEsyD+zS1YojtCODfpCGBQIsq
	 5bFyzGhWiLPDeq8k1xzxC3T5xjKtrQTSSJz8FsQpKJo303tufQ5Yj3QEXSEvQbuCd4csN
	 x5AT61PMIYhMtrPB1/4M468tz355s/7Tg4Rfj3EN2VOhl2xoxWdKEC9E361hgiy8mb0PU
	 L5zFYo78Ixk6TVd+lAwgUavELz1rHnK4CbWPhFn9lgg3otYwQI1rHAr1S/XdqDvv6fAIV
	 NQpypZTe9AZ4m13Mc1arIZn4s9A3/q+euvFIPU/VkxokkH0GuDY00wGj2eG84jfg/Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5iai8Cx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A76606A32A;
	Wed, 18 Nov 2026 22:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5iai8Cx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9841F000C4;
	Wed, 18 Nov 2026 22:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039345;
	bh=WV7rzBRIeG1vPoQBJdpFofbk4dhkYXfhOazSpJ+8dqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5iai8CxEhqJSrD+nUWBDcD+ZiYhrGbCbu84dgQBkRPx/3rDL5P2tA4uunJsMV+vR
	 gSoCPNQ9tGHSOYx/a9o4JvDgTWqYVKUm/vvB0DIb/oyK8sGOBt5UnTXC3lG0FMDcM/
	 x7oUUlhJ2gwAkpRBTUbIob0QI3P57QL3KggctnXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+229d761b8a110e6de517@syzkaller.appspotmail.com,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2068/3318] irqchip/gic-v3-its: Dont WARN on LPI free allocation failure
Date: Wed, 18 Nov 2026 15:44:50 +0100
Message-ID: <20261118150424.120590025@linuxfoundation.org>
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
index 224319b4eee6d..2a10cc5ae4d65 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2175,7 +2175,8 @@ static unsigned long *its_lpi_alloc(int nr_irqs, u32 *base, int *nr_ids)
 
 static void its_lpi_free(unsigned long *bitmap, u32 base, u32 nr_ids)
 {
-	WARN_ON(free_lpi_range(base, nr_ids));
+	if (free_lpi_range(base, nr_ids))
+		pr_err_ratelimited("ITS: failed to free LPI range %u:%u\n", base, nr_ids);
 	bitmap_free(bitmap);
 }
 
-- 
2.53.0



