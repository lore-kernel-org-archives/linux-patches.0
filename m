Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047925;
	b=Q3RmdQ5SW609A/AXpm+QVkflyzOCsNSmktCFea/Hf7MeB3ZK5MYsP0tEYtRo3DvoE4Kr
	 8xiUtc134mK5FeKhG8Ui7LWVk/a3cuIqDfDyi4OdJzxDDsVqzhacQPPWL6nDT9y56w6y/
	 iU1XQ/HKSGMqbiZVzxSKd96KSiU8Sju6ThtlE8adw0OJiom5+rDp1C5TNC2fqbnGq/mbq
	 +kn3d/gVK5Pwyb+K1utxWX+P/e3h11HawUdLM+1VWJZ1puPn4ISrUYrNs0kIAlqANl10W
	 egLesDHZkH9x+XyALvkqvsYhP7T1pir/YvRmNnR2UIrIPty69ki627BcIbL1aEUkBrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2MXCxmjLkrsCSUF81bK1xhf4hfxgKqTL/5NU3rwY1uQ=;
	b=W/leCnAb+UafKKO6lILvv0ctlnRMKcV/mf2Nv/PoZc1l7zpFx+MGQMe0NKgPzAhMX/G7
	 7jos0XRsFCgLsoBo7a/FGyDETozXINHChbTnZnK1fI68F1nz6Ns/WFsDxS6qcqMmSnOfn
	 iS4hwtvUGUFJwK2dvATTLEXMvycFares2DfNtveS5zP3B3sYTLiMCY3ZaKaOroHDmiX7g
	 b+ozPqxh1AYKJQtHHiELCm8MaxG9Jsq46Rd6/tM9G3NzQ6eVC2RCn0pFidk9nZyZYLJjk
	 HoYSTbCnGYZj7X5b+Trqn6/x4i80ArYZD8QWNTSTbGQ9KtLu1fAyIblDstijQa6BVzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uxty0cQ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E74606A330;
	Thu, 19 Nov 2026 00:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uxty0cQ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5C61F000C5;
	Thu, 19 Nov 2026 00:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047925;
	bh=2MXCxmjLkrsCSUF81bK1xhf4hfxgKqTL/5NU3rwY1uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uxty0cQ62raHO0KEjXAjRBVeXgcJhg/sNsO3eznazVEThjVwfEc0fMaBQFZGDCjwo
	 mdYnN+lKRyfPwyqEpsuT4qBDc1eR/Ez0llFPlE39EdpKp9B9Cy4ukUof36qVm6MUWd
	 fWC2Rv3SxT2PTqeG1iVG/Q9aenBffudbQ33rL370=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+229d761b8a110e6de517@syzkaller.appspotmail.com,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1810/2857] irqchip/gic-v3-its: Dont WARN on LPI free allocation failure
Date: Wed, 18 Nov 2026 15:47:24 +0100
Message-ID: <20261118150306.418661688@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b9138eda000b4..d1e0c4af03c6c 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2172,7 +2172,8 @@ static unsigned long *its_lpi_alloc(int nr_irqs, u32 *base, int *nr_ids)
 
 static void its_lpi_free(unsigned long *bitmap, u32 base, u32 nr_ids)
 {
-	WARN_ON(free_lpi_range(base, nr_ids));
+	if (free_lpi_range(base, nr_ids))
+		pr_err_ratelimited("ITS: failed to free LPI range %u:%u\n", base, nr_ids);
 	bitmap_free(bitmap);
 }
 
-- 
2.53.0



