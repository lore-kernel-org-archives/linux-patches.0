Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029168;
	b=MbJu75KlIJT04AH0SgZMR8AfTRzM+p6F8FAOorpFXx56SblrLnjUaIOhTYT6U5b7FgQ4
	 T2SMmbFPTHV3y/z3irsqPgrUKU4Ui5j3ShdLr4AFC4u5JRcnoayQW+z4RRJXKFnobnYLD
	 fP1Qhk2q6Uwf9HBIlDCOEXuNpmNUvsLtbptzTM2w5dXMwKx9GKeYUda1seAExXz3HktIy
	 3IYKwj7QuZRIIR/ISkISTLzG4MYUgh0LKsTlZtbmkd97O45grM8Lkdkb2rMfLX8MqnvUm
	 C1+IkRWnRjioctEGWs5zCx2nW3d/vC+gXT9Aq2sA1bA2fZkIbHr7APir3DlweqIogEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AoV76BMaopM+IeJUFrK0sg0qbtdgARdLUFB+QxpM1R0=;
	b=Vu/HDVltfo3Vr8UMAPImMaWDsXPtIVnglfMnEnQ0Tb6SHrAvvlEEu+6ab6VOmS4i38xX
	 XDiUnBYRszJxUDUCWBAkvBUAUW34YN7f/XiUqdPNn36mCAGZNYvKUNRD+Upm4p0WriiHA
	 3L+51TtWBOXCXDz+I/R0mziy0C4ptH8FsneFqFUBDr/tK8FdRKbph/dOqvI6LVaRks8pl
	 zy5esId6WvNM6jWAOfpXwWT1inmEeDAOSv5nexzB/MlzMUmS84lQfhPnYhbCkblbLyuWn
	 J9DFmis/jowZ135190rqygl/pv9squk6n9EmgzEa0wiAtwXoDdRyVopx/7R6D+x8XVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lgCLdeYd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204D5606A33B;
	Wed, 18 Nov 2026 19:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lgCLdeYd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BB51F000C4;
	Wed, 18 Nov 2026 19:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029168;
	bh=AoV76BMaopM+IeJUFrK0sg0qbtdgARdLUFB+QxpM1R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lgCLdeYdIsZb9rkLo5VFNejrG6l2tLcL5YN7TqH5wL4jlrmsZG1W43MUxtRkn2wNA
	 Zw5OZJ9HxZD+gj4PswCTtnoGTJH5iNHThoMpCGEsk2NEDhrGlTxtvRsz3ZAS6tsxYC
	 5tnvtGz0P1JR4provOESRlveqgRNwLWXadaYB9iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+229d761b8a110e6de517@syzkaller.appspotmail.com,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0252/1756] irqchip/gic-v3-its: Dont WARN on LPI free allocation failure
Date: Wed, 18 Nov 2026 15:39:39 +0100
Message-ID: <20261118150018.413298724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7ab93108c1096..a98acf21becce 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2166,7 +2166,8 @@ static unsigned long *its_lpi_alloc(int nr_irqs, u32 *base, int *nr_ids)
 
 static void its_lpi_free(unsigned long *bitmap, u32 base, u32 nr_ids)
 {
-	WARN_ON(free_lpi_range(base, nr_ids));
+	if (free_lpi_range(base, nr_ids))
+		pr_err_ratelimited("ITS: failed to free LPI range %u:%u\n", base, nr_ids);
 	bitmap_free(bitmap);
 }
 
-- 
2.53.0



