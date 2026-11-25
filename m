Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622777;
	b=DZr2XmviJgSh5LvziXy8rV6Ai9wMoHEaOK3yfgvUx3TxpUnFKMSRrguMyY7OnDaKRJF+
	 Un4zdeRqVj5Au4N9z9o0JmjSTdXwEOGx659OtSju19MIyAYHvI6foxWww62MmQ4/WFRHS
	 9z9iiBwZ75ZBMsNH0YFbzvIe8v1MH/ucf2Tjkb0w+eHNkicj0Jch7ynwVaSASwfPY06kX
	 WxWSoiwO2svoWZrRtj/1jcsw3oYSIk895oN5GBBA+iQbySsLboLbBksm4a8fHZaeSieWh
	 LVtaVp7mVmyi3F2P0+676NYpwh4R7Djd9aVlW3tIZJT6H5p+nuoYiE91necOb/6PEfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FD/nsNkd+BYwhssePftdJIKlJQFOPbwT3eChFBhgoWA=;
	b=PSDLD/nto/5fCRGdo3C3bp7Hx0W+Jw7tzg2j1sb74SZTqUBjaE3pdD3kAIMyNwcaeZxD
	 R0fMmeD5WbKsnf1i4oNjaIV5oN46NPFn7pgTHIE5U6sWLqajdcTCiGlRHPtiLw7KFLQXS
	 2Meij2nGergEU2tb5BUJLGR1EDAi6WwYLu2tjemgRN/O65D8nJRmL8JnZoMvqZXpw1Xc+
	 AKtWZ2yc0CdJCgLGkIYgrTaQr/F6L5kn+TKLsorLHuRNGs/c4Klrgypy5EcNQDGqKTa3q
	 J4IIypjPjc+54J+33OjX8vDCW5OadxBYSK9NfDmqQLE+qy3jQ7SYsfRo2yiYrjOC7aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fGcRBcJM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EA0606A321;
	Wed, 25 Nov 2026 16:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fGcRBcJM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324E31F000C4;
	Wed, 25 Nov 2026 16:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622777;
	bh=FD/nsNkd+BYwhssePftdJIKlJQFOPbwT3eChFBhgoWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGcRBcJMnbvwcl/iayBqOjrht1rSYwC7msxBRgKco/tIjp6fwJ4EgVG8Gaqo4+Y44
	 Z62oZDiz/+A5AWe7qZvHZ5ph2yFuH+L/2beI8jA4q8v0GXArfSfGByeddyy4JQcb8j
	 sZFT3rekpb3Dx9w10fGZXadjQVRMD6tT/flDW6xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ju Nan <junan76@163.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 599/990] pinctrl: stm32: Fix the unit of the hwspinlock timeout
Date: Wed, 25 Nov 2026 15:32:46 +0100
Message-ID: <20261125143836.122997035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the two hunks touching the skipped I/O-sync and skew-delay functions (absent here), so only the HWSPNLCK_TIMEOUT_MS rename and the five existing callers apply. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 384fdc13a504b..8f9935d07e432 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -82,7 +82,7 @@
 #define gpio_range_to_bank(chip) \
 		container_of(chip, struct stm32_gpio_bank, range)
 
-#define HWSPNLCK_TIMEOUT	1000 /* usec */
+#define HWSPNLCK_TIMEOUT_MS	1
 
 static const char * const stm32_gpio_functions[] = {
 	"gpio", "af0", "af1",
@@ -559,7 +559,7 @@ static int stm32_gpio_domain_activate(struct irq_domain *d,
 
 	if (pctl->hwlock) {
 		ret = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (ret) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			return ret;
@@ -896,7 +896,7 @@ static int stm32_pmx_set_mode(struct stm32_gpio_bank *bank,
 
 	if (pctl->hwlock) {
 		err = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
@@ -1033,7 +1033,7 @@ static int stm32_pconf_set_driving(struct stm32_gpio_bank *bank,
 
 	if (pctl->hwlock) {
 		err = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
@@ -1084,7 +1084,7 @@ static int stm32_pconf_set_speed(struct stm32_gpio_bank *bank,
 
 	if (pctl->hwlock) {
 		err = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
@@ -1135,7 +1135,7 @@ static int stm32_pconf_set_bias(struct stm32_gpio_bank *bank,
 
 	if (pctl->hwlock) {
 		err = hwspin_lock_timeout_in_atomic(pctl->hwlock,
-						    HWSPNLCK_TIMEOUT);
+						    HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			dev_err(pctl->dev, "Can't get hwspinlock\n");
 			goto unlock;
-- 
2.53.0



