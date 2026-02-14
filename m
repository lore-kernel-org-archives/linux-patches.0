Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD9F299931;
	Sat, 14 Feb 2026 21:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104377; cv=none; b=hoyylfIVaPqgWz03BwtBbazfxD393x9aQtv9AMI7nZUfR1Lu8fj3XIBxtASiKNoAifNzyeVo++tgU4MefArPjR6Dse5X1bV/t2o5G1BxTfKdoBo1CTOXluwcjQCJjrrCGq3Ni+xWsxtsU3IlqJR3tczjX/HShxQdCiRhNSoJR5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104377; c=relaxed/simple;
	bh=LJvwCkXL776zJX/WvyQWr9cwHQHia4o0eSMgh+ZA3jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hm7cL/j8eV8yBpIUI0Z3/buq3x8/itYl+LANQSns+p+Gnjc6VkVh7oHmJzFd8LmO0AQmtA88urwOMcXEGU5fMxkZUaXpiVx7KmsjQmftLo84ELdZ6lEgpF5G3f6EnB0POynAHb6k8CrzLlNF5isYGzjEBZPsd9mlaI9kWWgEEBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7ExQu3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7ExQu3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959F8C19422;
	Sat, 14 Feb 2026 21:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104377;
	bh=LJvwCkXL776zJX/WvyQWr9cwHQHia4o0eSMgh+ZA3jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7ExQu3wKY9pi26Ub3/a0Dk49v3hKKO81AlYnz8VPorvigWiG0R3s9FpelIwJRv3U
	 hz9ZYvwjehTNDld4/cq578Coa5YkSc2vJO3SjdVl3mKHWcXxonKZDd+rizrc+EyOKw
	 OltA4ylQtnGZnQU9iARBQbTcI5hzGNTmuWgVCgZhuOum6bidtcTYrtG6nox1qb1dAr
	 V1hBQZbwOU8WpV528ur3MAtqR0J21IeXzkgVlHiBgjbHEZmp6+hmvo5XbtPaoNGZ4Q
	 F+7tC6Q20VkzraQhqjOau1lES/8lvQ0LxbnE5R+NCmJ22VJJNFohIjCAmhYJKJQZ/a
	 w2pHjkgAI8law==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Carl Lee <carl.lee@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-5.10] nfc: nxp-nci: remove interrupt trigger type
Date: Sat, 14 Feb 2026 16:23:16 -0500
Message-ID: <20260214212452.782265-51-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Carl Lee <carl.lee@amd.com>

[ Upstream commit 57be33f85e369ce9f69f61eaa34734e0d3bd47a7 ]

For NXP NCI devices (e.g. PN7150), the interrupt is level-triggered and
active high, not edge-triggered.

Using IRQF_TRIGGER_RISING in the driver can cause interrupts to fail
to trigger correctly.

Remove IRQF_TRIGGER_RISING and rely on the IRQ trigger type configured
via Device Tree.

Signed-off-by: Carl Lee <carl.lee@amd.com>
Link: https://patch.msgid.link/20260205-fc-nxp-nci-remove-interrupt-trigger-type-v2-1-79d2ed4a7e42@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of nfc: nxp-nci: remove interrupt trigger type

### 1. COMMIT MESSAGE ANALYSIS

The commit states that for NXP NCI devices (e.g., PN7150), the interrupt
is **level-triggered and active high**, not edge-triggered. The driver
was incorrectly using `IRQF_TRIGGER_RISING`, which can cause
**interrupts to fail to trigger correctly**. The fix removes the
hardcoded trigger type and relies on the Device Tree configuration
instead.

Key phrases:
- "interrupts to fail to trigger correctly" — this is a real hardware
  bug affecting functionality
- "level-triggered and active high, not edge-triggered" — clear
  technical justification

### 2. CODE CHANGE ANALYSIS

The change is a **single-line modification**:

```c
- IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+ IRQF_ONESHOT,
```

This removes `IRQF_TRIGGER_RISING` from the `request_threaded_irq()`
call, leaving only `IRQF_ONESHOT`. When no trigger type is specified,
the kernel uses the trigger type configured by the platform (Device Tree
or ACPI), which is the correct behavior for this device.

**Bug mechanism**: The PN7150 NFC chip uses a level-triggered, active-
high interrupt. When the driver hardcodes `IRQF_TRIGGER_RISING` (edge-
triggered), it can:
- Miss interrupts if the line stays high (level vs edge semantic
  mismatch)
- Cause the NFC controller to become unresponsive because the driver
  never sees the interrupt
- On some interrupt controllers, specifying a conflicting trigger type
  can cause the IRQ to not work at all

### 3. CLASSIFICATION

This is a **hardware bug fix**. The driver had an incorrect interrupt
configuration that causes the device to malfunction. It falls into the
category of fixing a real bug that prevents hardware from working
correctly.

This is NOT a feature addition, API change, or refactoring. It's
correcting an incorrect driver parameter.

### 4. SCOPE AND RISK ASSESSMENT

- **Size**: 1 line changed in 1 file — minimal scope
- **Risk**: Very low. Removing the hardcoded trigger type and deferring
  to DT/platform configuration is the standard, correct approach in
  modern Linux kernel drivers. Many other drivers have undergone similar
  changes.
- **Subsystem**: NFC driver (nxp-nci) — niche but has real users (NFC on
  embedded/mobile platforms)
- **Regression potential**: Low. If a system was working with
  `IRQF_TRIGGER_RISING` before, it means either (a) the DT already
  specified the correct trigger type (in which case removing the driver
  override changes nothing) or (b) the interrupt controller happened to
  work with the wrong trigger type. In case (b), the DT should already
  have the correct type defined, and this change makes the driver
  correctly defer to it.

### 5. USER IMPACT

NXP PN7150 is a commonly used NFC controller, found in embedded systems
and IoT devices — exactly the kind of platforms running stable kernels.
Users affected by this bug would see their NFC controller fail to work
properly (missed interrupts = no NFC communication). This is a
**complete functionality failure** for affected users.

The "v2" in the link suggests this went through review iteration,
indicating careful consideration.

### 6. STABILITY INDICATORS

- Signed by AMD engineer (Carl Lee)
- Accepted by networking maintainer (Jakub Kicinski)
- Clear, well-documented commit message explaining the technical issue
- The fix follows established kernel patterns (relying on DT for IRQ
  type)

### 7. DEPENDENCY CHECK

This is a standalone, self-contained fix. It has no dependencies on
other commits. The `nxp-nci` driver exists in all recent stable trees,
and the `request_threaded_irq()` call with `IRQF_TRIGGER_RISING |
IRQF_ONESHOT` has been there since the driver was introduced. The fix
will apply cleanly to stable trees.

### Summary

This is a small, surgical, one-line fix that corrects an incorrect
interrupt trigger type in the NXP NCI NFC driver. The bug causes
interrupts to fail to trigger correctly, making the NFC hardware non-
functional in some configurations. The fix is obviously correct
(removing a wrong hardcoded value in favor of the platform-specified
one), has minimal regression risk, and affects real hardware users. It
meets all stable kernel criteria.

**YES**

 drivers/nfc/nxp-nci/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 049662ffdf972..6a5ce8ff91f0b 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -305,7 +305,7 @@ static int nxp_nci_i2c_probe(struct i2c_client *client)
 
 	r = request_threaded_irq(client->irq, NULL,
 				 nxp_nci_i2c_irq_thread_fn,
-				 IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				 IRQF_ONESHOT,
 				 NXP_NCI_I2C_DRIVER_NAME, phy);
 	if (r < 0)
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
-- 
2.51.0

