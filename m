Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020695;
	b=epFTcFZohWt0YyTU6DUEw5Jtz7M5T7d8dxou0OSkYWLiCs/ttWAgLJf4/E8bBr0yA7m7
	 ICQ+hB3qvY3fPkUMoyIVChju1/KQz1qlip4Ud4HDkbBMzffLHMRq16ZyrLR9k91YZFxcQ
	 LN+dZPjxt+7jo9g3P1Nx80OyCa5yH2bvrYyrR+XaVUEsZDMIvaFeXBtcl40X5Qu0PScOz
	 /2Ui+wkxVfM8gtcBh07XmfsN4IGFzC034n2L/1Z/Ye+XR8e8NCW1+vGF95yuLmFzP+Yke
	 dFT9G82ZhJl1bRTosDOqKxj6DbLoR3lvkvEIzt1tmNlXlhUnn8IX6oHSPqcTiNtMUgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hYN1zKBW0krv16u/hrIPEj7NmLSwU9rTlVfM2nsr7X0=;
	b=o2Ec5+zbJGms6huVWkSeCEEzTxfLGJdnhUgVLyX674mRuetlP04KVHFMfZWT9OMPfqLc
	 /h57TLX/2UqtPOBtBRQhNL6AEbQiYzfhaJD/r5R0CV20j52QmczgXOvC+eOL2+jRtM4Pl
	 /83FIsPVNuI71aEmnHTB3g5br9Jm0djX4kKtZv40bP4Fy3LAMHqKb5c//BDUXKBVCnNUb
	 jQGc9i3lfSjXUPu7utp3K9LmI4ADvIsDRv9l4OskBaS/YatsRHTvsQAFClWBjtToGG2vf
	 +7NZM4oziLjMkquKgqO5IAxWZv5wkmU9fs92qspLxeVIs+4e76mAatKQqpOhzI9phsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KA9CG8MA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1089E60A2604;
	Wed, 18 Nov 2026 16:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KA9CG8MA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662FD1F000C8;
	Wed, 18 Nov 2026 16:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020694;
	bh=hYN1zKBW0krv16u/hrIPEj7NmLSwU9rTlVfM2nsr7X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KA9CG8MAxO/CDQ+OFSCpM/ncTxY3cDd8yu/EIMuqS7TaaQdjMlN7gF7j0xvqpVnkQ
	 7RHQyc996cCT29AvvI7lMi1tMJvtoexzD+CGV0te+pt89HQ5ACyTckiqAoJlA25TUn
	 vFYFMMk0zWvV30FHHItkAIf/dxl8dFfRoPDNTtVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ju Nan <junan76@163.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2042/2651] pinctrl: stm32: Fix the unit of the hwspinlock timeout
Date: Wed, 18 Nov 2026 15:54:42 +0100
Message-ID: <20261118150359.610464945@linuxfoundation.org>
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

From: Ju Nan <junan76@163.com>

[ Upstream commit 544b3f8042dd7c18baa48dcb1a393ff8b6742322 ]

HWSPNLCK_TIMEOUT is passed to hwspin_lock_timeout_in_atomic(), whose
timeout argument is in milliseconds, not microseconds:

  atomic_delay += HWSPINLOCK_RETRY_DELAY_US;
  if (atomic_delay > to * 1000)
          return -ETIMEDOUT;

The hwspinlock core documents this explicitly:

  If the mode is HWLOCK_IN_ATOMIC (called from an atomic context) the
  timeout is handled with busy-waiting delays, hence shall not exceed
  few msecs.

Fixes: 290a9f937e5a ("pinctrl: stm32: use the hwspin_lock_timeout_in_atomic() API")
Signed-off-by: Ju Nan <junan76@163.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 6ebb8ea260d1b..241684cd383b5 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -87,7 +87,7 @@
 #define gpio_range_to_bank(chip) \
 		container_of(chip, struct stm32_gpio_bank, range)
 
-#define HWSPNLCK_TIMEOUT	1000 /* usec */
+#define HWSPNLCK_TIMEOUT_MS	1
 
 static const char * const stm32_gpio_functions[] = {
 	"gpio", "af0", "af1",
@@ -609,7 +609,7 @@ static int stm32_gpio_domain_activate(struct irq_domain *d,
 
 	if (pctl->hwlock) {
 		ret = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (ret) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			return ret;
@@ -946,7 +946,7 @@ static int stm32_pmx_set_mode(struct stm32_gpio_bank *bank,
 
 	if (pctl->hwlock) {
 		err = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
@@ -1089,7 +1089,7 @@ static int stm32_pconf_set_driving(struct stm32_gpio_bank *bank,
 
 	if (pctl->hwlock) {
 		err = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
@@ -1135,7 +1135,7 @@ static int stm32_pconf_set_speed(struct stm32_gpio_bank *bank,
 
 	if (pctl->hwlock) {
 		err = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
@@ -1181,7 +1181,7 @@ static int stm32_pconf_set_bias(struct stm32_gpio_bank *bank,
 
 	if (pctl->hwlock) {
 		err = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
@@ -1242,7 +1242,7 @@ static int stm32_pconf_set_advcfgr(struct stm32_gpio_bank *bank, int offset, u32
 	spin_lock_irqsave(&bank->lock, flags);
 
 	if (pctl->hwlock) {
-		err = hwspin_lock_timeout_in_atomic(pctl->hwlock, HWSPNLCK_TIMEOUT);
+		err = hwspin_lock_timeout_in_atomic(pctl->hwlock, HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
@@ -1320,7 +1320,7 @@ stm32_pconf_set_skew_delay(struct stm32_gpio_bank *bank, int offset, u32 delay,
 	spin_lock_irqsave(&bank->lock, flags);
 
 	if (pctl->hwlock) {
-		err = hwspin_lock_timeout_in_atomic(pctl->hwlock, HWSPNLCK_TIMEOUT);
+		err = hwspin_lock_timeout_in_atomic(pctl->hwlock, HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
-- 
2.53.0



