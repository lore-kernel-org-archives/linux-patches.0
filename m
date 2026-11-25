Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625404;
	b=bT+aFmf6hswubcMecXpXfXzVlz3zFaN2DBYsKPxwwXdzYawoIGfzfdijfepQ2FqYeGL8
	 vEFlsZkgIYVcJ1UiTAzHQZbh9P0xtSs9If5IdXXRS8p+5ufao70t4vlaaG/ecmouKO9ip
	 Qn4A3jk9GlhlaSi46qL/yqvzfm5QSOQ0JngB6qLHf9G51xlKQ7CKbeleg+jc+c64ZFD2r
	 pUbNQQNBU83LqJj7rgwFAgMy4spJUm5BTkwK/nUYwvuUOD0fltVZvyCUY3ertowcD9Elu
	 JB7qM5mEE1/cyJRmwe4dfY2GC1pvgvX2atEOPILpDPoY3uo1wKzJu4qz5j0dVHx0pWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N/T5jeZf6/0Cay+poTO/HXkDoZXr7p6w90HPD4f/u30=;
	b=tzwLK2OFBHSPQBnwgwNoKNa9jN573Zb6lK/9KbQ8rZYMXSJEfeOThp65lx2qGHfT7rNA
	 +TK2tPMG3VLkHLT3LBClO+LOK0vucUaEHB0zUxIi5VJ67HiyvQ947YMkK0BlT31/caDXB
	 xvytJeHJT8/GesHm04hNsc9AIYP74twOvoqoBG6/ToZK9u8d7PbnfuLUtwbqyvftjLDqP
	 unOg1xLOJZwPW0066a6C3r7Q1I2vK7ashD04iDtzv9+fvctdl04i0RQ4od13rJGhbH6GO
	 ZGs5o/j7j+oMN7kAS5L4WvySh9aYbf5b3GHiw/0SHRfr52Nhv/nLgHz73KoeHJSTstA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ia/dPIbU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBF0606A321;
	Wed, 25 Nov 2026 16:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ia/dPIbU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3271F000EB;
	Wed, 25 Nov 2026 16:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625404;
	bh=N/T5jeZf6/0Cay+poTO/HXkDoZXr7p6w90HPD4f/u30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ia/dPIbUAwB467GJRomGeX3YjtgXh0ElspTkBxN5d5a7v3y1+nfcwE7QYYO2Zgh8r
	 F418E9LSkEfX5CpEO7aMOJk+RvHTfiq52KTmLAHLp7ziLRc8b7aRyVMCw2HX7D41hN
	 XtXahoYLagciinpupCIuZrBbD6hrJH5I0tszBJ5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ju Nan <junan76@163.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 503/816] pinctrl: stm32: Fix the unit of the hwspinlock timeout
Date: Wed, 25 Nov 2026 15:34:11 +0100
Message-ID: <20261125143900.831345097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
[ sashal: Dropped the two hunks for stm32_pconf_set_advcfgr() and stm32_pconf_set_skew_delay(), which don't exist here, and adjusted context to rename the macro at the five remaining call sites. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 9e8b8b82c232b..06431e55fa615 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -68,7 +68,7 @@
 #define gpio_range_to_bank(chip) \
 		container_of(chip, struct stm32_gpio_bank, range)
 
-#define HWSPNLCK_TIMEOUT	1000 /* usec */
+#define HWSPNLCK_TIMEOUT_MS	1
 
 static const char * const stm32_gpio_functions[] = {
 	"gpio", "af0", "af1",
@@ -436,7 +436,7 @@ static int stm32_gpio_domain_activate(struct irq_domain *d,
 
 	if (pctl->hwlock) {
 		ret = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (ret) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			return ret;
@@ -770,7 +770,7 @@ static int stm32_pmx_set_mode(struct stm32_gpio_bank *bank,
 
 	if (pctl->hwlock) {
 		err = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
@@ -902,7 +902,7 @@ static int stm32_pconf_set_driving(struct stm32_gpio_bank *bank,
 
 	if (pctl->hwlock) {
 		err = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
@@ -953,7 +953,7 @@ static int stm32_pconf_set_speed(struct stm32_gpio_bank *bank,
 
 	if (pctl->hwlock) {
 		err = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
@@ -1004,7 +1004,7 @@ static int stm32_pconf_set_bias(struct stm32_gpio_bank *bank,
 
 	if (pctl->hwlock) {
 		err = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
-- 
2.53.0



