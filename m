Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034665;
	b=s1pm9pNRSdfeXnxaK8/yShT583tE9foLoyOVvy/zG8fXzpMgOEBnXTqe0WAG0rtZ6hK/
	 +5/CTPJaE0D+RsjKAk6QFzYLRIweD7wNdfCM8Q1puQni6Dka5e5UobXkxtt5Rw7pWC8qL
	 3pae0e/QUs77jsNDjblVjggj84N1tTVmKcAdi1pslhTRceiPh7yAMER1+akFbrtKheTyP
	 F8ATR9MNV4moir27PkZvqBfy7r3A4/hmsCc78kjUC7qgpYGr+ruM907o2SxYz3SpVWAiC
	 eaEx9vHjMxdnNkS39pXS5dl+dh5NRU6jsXvwoEZPgEXPb8gDVmBp+o2boF/edA0TDng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C/Iv5MD4PDEQhQvrTW218fm+WMwkciqy2S2ZYUYWZoU=;
	b=MT3em6/ssCWdXOhxpR9UGClXeIr6GjlkmO8PMYqhuWXJsQsshhaR5Nf7+eJaooKtEQc1
	 w2meQv8MMQjD7Iarn0IWWP9w7SSpaz2E6G9ELQSuo9jhdVHsOe2+eUSrDgyfybCW29QfJ
	 946vjgFtz5C5xYgIN2xOlkB0D69Ser/eF2PpZMMYfjRtv12Ztf3GjtH+vhbj5FIvEx6rX
	 Gsz7NxKSXSbqMXDh0iaDHhNjzqxE2wVsSPqMIc8TvWdSzuZ2EwYKT+LfdFe1rpuyPW2PH
	 GNw+jPO9qXjRbipW/ZPBihkD7zSjf0s7akdWIZ8iuZ5MJdA4igCL56JVQBhIeb+7fXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qWWLBmqJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694BE606A320;
	Wed, 18 Nov 2026 20:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qWWLBmqJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B8A1F000C4;
	Wed, 18 Nov 2026 20:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034665;
	bh=C/Iv5MD4PDEQhQvrTW218fm+WMwkciqy2S2ZYUYWZoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qWWLBmqJibPa5oKEOtfegCU+/LmCUpfkw3lfdsRKYzUiqMQq5xcotiY+9hKAFPifv
	 fgZz3xZ4AJ9/jKRpKHDAJFRYUrzEz5rVqbGdWWVii5+Q3nfllT2yr8AyhsH6OoRGE/
	 P47CMfmxS56tWGw0OSpnE0/x6cetiavXIYpcHoAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ju Nan <junan76@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0450/3318] irqchip/stm32mp-exti: Fix the unit of the hwspinlock timeout
Date: Wed, 18 Nov 2026 15:17:52 +0100
Message-ID: <20261118150330.264056518@linuxfoundation.org>
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

From: Ju Nan <junan76@163.com>

[ Upstream commit d31fbbade43f880b7e59e2b3a72722fe2725d93f ]

HWSPNLCK_TIMEOUT is passed to hwspin_lock_timeout_in_atomic(), whose
timeout argument is in milliseconds, not microseconds:

  atomic_delay += HWSPINLOCK_RETRY_DELAY_US;
  if (atomic_delay > to * 1000)
          return -ETIMEDOUT;

So stm32mp_exti_set_type() asks for a 1 second timeout where the comment
next to the macro says it wants 1 millisecond. The semaphore is polled
with udelay() from a section that holds chip_data->rlock, a
raw_spinlock_t, so preemption stays disabled for the whole wait on every
configuration, PREEMPT_RT included.

The hwspinlock core documents this explicitly:

  If the mode is HWLOCK_IN_ATOMIC (called from an atomic context) the
  timeout is handled with busy-waiting delays, hence shall not exceed
  few msecs.

Fixes: 5257169ade8c ("irqchip/stm32-exti: Use the hwspin_lock_timeout_in_atomic() API")
Signed-off-by: Ju Nan <junan76@163.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Radu Rendec <radu@rendec.net>
Reviewed-by: Antonio Borneo <antonio.borneo@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260821024756.24927-2-junan76@163.com
[ sashal: Applied the fix to the older driver file, changing two call sites to the renamed millisecond macro because this file has two hwspinlock users where upstream has one. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-stm32-exti.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-stm32-exti.c b/drivers/irqchip/irq-stm32-exti.c
index 971240e2e31b4..fa9cdfd87c56d 100644
--- a/drivers/irqchip/irq-stm32-exti.c
+++ b/drivers/irqchip/irq-stm32-exti.c
@@ -25,7 +25,7 @@
 
 #define IRQS_PER_BANK 32
 
-#define HWSPNLCK_TIMEOUT	1000 /* usec */
+#define HWSPNLCK_TIMEOUT_MS	1
 
 struct stm32_exti_bank {
 	u32 imr_ofst;
@@ -365,7 +365,7 @@ static int stm32_irq_set_type(struct irq_data *d, unsigned int type)
 	irq_gc_lock(gc);
 
 	if (hwlock) {
-		err = hwspin_lock_timeout_in_atomic(hwlock, HWSPNLCK_TIMEOUT);
+		err = hwspin_lock_timeout_in_atomic(hwlock, HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			pr_err("%s can't get hwspinlock (%d)\n", __func__, err);
 			goto unlock;
@@ -569,7 +569,7 @@ static int stm32_exti_h_set_type(struct irq_data *d, unsigned int type)
 	raw_spin_lock(&chip_data->rlock);
 
 	if (hwlock) {
-		err = hwspin_lock_timeout_in_atomic(hwlock, HWSPNLCK_TIMEOUT);
+		err = hwspin_lock_timeout_in_atomic(hwlock, HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			pr_err("%s can't get hwspinlock (%d)\n", __func__, err);
 			goto unlock;
-- 
2.53.0



