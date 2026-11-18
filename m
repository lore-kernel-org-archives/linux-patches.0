Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043975;
	b=Yy8puaj6JTBKbMjHKjrMfLiOaZCbevVAYQNzMu2iBKSWXhtqQd77D32OLnub7NTOIMQ4
	 VJN9qPo1kKlhbgsQPSOkWhpb4YDiIn1SANJ182eqfzYbrjJYPBumgk0Y4ZgNoSP5K0zL7
	 GmgPnMLdbMKhVz1RYDVqR0KZakG3W2u4A7G/KgTNHRh6qox9XwQh9XVPJV4RqLOujb8o+
	 hMD76Dpn9AtA4BbnRyKwZOrG27VmaVF57vMjZxGtgik3OH/acqMaLd5pi+wIFlUdSUMNE
	 CMG4ybnxmoDFQ1uGN4ie3YyBvFSDCJuGnMNI/xRVpn5IsO8F7LxRzoz7S8TZtDUXyaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uYZGUPCFwKoDS+eUb/yRgJ0GAVWrDziHvUqC0bmy7eo=;
	b=5o3ugaDbeL0y+bSfx44LlhcS+AicMgpNktUM+kJfYyw59r829jvKlis3t4CemYKfbcd4
	 NRcR54F4/n0AjRrz8Wz/DO2ZtQaFyv7qC0AJyUwk3M9UCGLXVGLlzY41B4aOzwMCkKb75
	 sSKMgG+wMO2I03PZEqVFLvIgandpT0Mq2C5/iP9EQ7vShwHOKBgkNncLz9ue3Nn9aeMfK
	 zLwy8nCwTCoZbx3pUu40vKSSkpcHOVXg9gZLLElgGydoUSdDHT9onmF0VjIWkdPhV8arD
	 Y+LXjoMrTjTl41pO0wGoaOgAIcFzMDLDS//yqgP+xahZvJLyTXlH/4ee2okLi+30R8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnsJcnHx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAE1606A31C;
	Wed, 18 Nov 2026 23:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnsJcnHx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6C51F000C4;
	Wed, 18 Nov 2026 23:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043975;
	bh=uYZGUPCFwKoDS+eUb/yRgJ0GAVWrDziHvUqC0bmy7eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnsJcnHxxDewucQwtaegZOzwoM8bfOWVc6Pj+5sLHM8mo7Qm7AEqSmurazzg711iX
	 B8Jxa1OGyyZWX30FMaEk0ckmof4yARH50iiA10GMVe0UAw+fFgYWhDSkfMwNxJq2YU
	 crctGcHlS9XJfAl4xATs+5K9P/SFRvFmvkoKW3dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ju Nan <junan76@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0401/2857] irqchip/stm32mp-exti: Fix the unit of the hwspinlock timeout
Date: Wed, 18 Nov 2026 15:23:55 +0100
Message-ID: <20261118150215.828920873@linuxfoundation.org>
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
[ sashal: Applied the change to irq-stm32-exti.c, the older combined driver, and renamed the macro for both of its call sites instead of upstream's single one. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-stm32-exti.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-stm32-exti.c b/drivers/irqchip/irq-stm32-exti.c
index dc6f67decb022..2b3135b9bc147 100644
--- a/drivers/irqchip/irq-stm32-exti.c
+++ b/drivers/irqchip/irq-stm32-exti.c
@@ -24,7 +24,7 @@
 
 #define IRQS_PER_BANK 32
 
-#define HWSPNLCK_TIMEOUT	1000 /* usec */
+#define HWSPNLCK_TIMEOUT_MS	1
 
 struct stm32_exti_bank {
 	u32 imr_ofst;
@@ -363,7 +363,7 @@ static int stm32_irq_set_type(struct irq_data *d, unsigned int type)
 	irq_gc_lock(gc);
 
 	if (hwlock) {
-		err = hwspin_lock_timeout_in_atomic(hwlock, HWSPNLCK_TIMEOUT);
+		err = hwspin_lock_timeout_in_atomic(hwlock, HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			pr_err("%s can't get hwspinlock (%d)\n", __func__, err);
 			goto unlock;
@@ -567,7 +567,7 @@ static int stm32_exti_h_set_type(struct irq_data *d, unsigned int type)
 	raw_spin_lock(&chip_data->rlock);
 
 	if (hwlock) {
-		err = hwspin_lock_timeout_in_atomic(hwlock, HWSPNLCK_TIMEOUT);
+		err = hwspin_lock_timeout_in_atomic(hwlock, HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			pr_err("%s can't get hwspinlock (%d)\n", __func__, err);
 			goto unlock;
-- 
2.53.0



