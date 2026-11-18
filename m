Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054784;
	b=RVbZIIqOAxzC8dccSNoYfig773ebiBDfb6M+u9M++2XLrkl0w7PHQFmhO3MVyNYMdOrq
	 ABXtqK2G9MUGyYiCY0GbhQAvPSa6HVNA4hDErsWQWo17Yzw9Fndrh0jeLzdfdCNvVtxtu
	 Q6Fg+1b24W81gOmmgfQ7UKmhtPNn9oNOqfQmHWARNhWlpbGhGWI8zV22zIHlT3TSuan/m
	 PF9y5bruN2QTCwrcLkzJjCt1JNyCjp2g6lryoFrrLkr6Czj8GbaEqa4Ncnhn7L/LMqNH7
	 oim5RPvb+ZB0oqkqRyyJyWDFggv5aGun9k6ATPyUSK7xupDXxjwMhP6zSx4lVKP6tSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A5w60Y3n0FqEyIoaemurx2eyH7UA+UYM+GWOYEvREgw=;
	b=vinSW8m/SFHCD6HOl9ZaW+oueExuOvVE6EfnnfQA2dhC/AU0ZkozXQD+JdqNDemLVc6/
	 BSFVApWMpka+oL0D3fwymguqgq0pKAMXfZ+w3ZQXSU2Tcp6NoYDXDUJdKuKmEtyA81F9P
	 BEFpBIK0/XAcNg0xeRfNq5MF2P+/B3FXywpV9lZnibgg3hQ4HF3XnCvTTdVFj36k17Jet
	 UMw6JhDINFAHUkmI0NxDahrJtPD/cMDtxCjfGhU6XTpcwAWNJzS2A1szhuAqNvS83lgZo
	 AIeguhqEEfkFIpCt6GpNvaDbS5p3KqXSGhrlBK4EmV8J3/19kn57TuhFG1oguS7pNpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3Z9or15;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2862606A320;
	Thu, 19 Nov 2026 02:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3Z9or15
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114671F000C6;
	Thu, 19 Nov 2026 02:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054784;
	bh=A5w60Y3n0FqEyIoaemurx2eyH7UA+UYM+GWOYEvREgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3Z9or1551J5vTHHgr5TFQusGpd/7D1x8dDO0JTfSZw6SaL5eZjnOtn1NTnkRfYIJ
	 EDEHP41d+kps40Lo7umLHi+3Y7GdQ4VKH2vwKTGy4C3/ra7vg64LU2GM2mWmUP9dYP
	 lJ4Z8+d/L7FyMU9vCoobs1SzaD/twLqG9Jdbv0g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+229d761b8a110e6de517@syzkaller.appspotmail.com,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1398/2214] irqchip/gic-v3-its: Dont WARN on LPI free allocation failure
Date: Wed, 18 Nov 2026 15:51:14 +0100
Message-ID: <20261118150107.210402377@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9e857e2b5985f..5457498031431 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2186,7 +2186,8 @@ static unsigned long *its_lpi_alloc(int nr_irqs, u32 *base, int *nr_ids)
 
 static void its_lpi_free(unsigned long *bitmap, u32 base, u32 nr_ids)
 {
-	WARN_ON(free_lpi_range(base, nr_ids));
+	if (free_lpi_range(base, nr_ids))
+		pr_err_ratelimited("ITS: failed to free LPI range %u:%u\n", base, nr_ids);
 	bitmap_free(bitmap);
 }
 
-- 
2.53.0



