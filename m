Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEC63C3C0E;
	Sat, 17 Oct 2026 16:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255318; cv=none; b=ItGkJQafJEmSQdZUfP/v4yQTnsjSAGmU0USVICtkizW/rmUgSavEwc2nS0HRLkkM1LrPdRa1TUdewDMisrd/LWj/4zHh1UxJg+R/ZS94/5W6sX6cjJul99HCJo7QwWxTGF1EOBx00olDCVei/lGT/gVYxAyYN/RnWzHxM/aoWWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255318; c=relaxed/simple;
	bh=1et4Y3b4/PIpdW3EbNgi1lTQ1O/stLxahYhpeQVMMCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+3GBtww/ykOaovkDtwY8kvwUinw0k6tovta+OmJEDRqKkQluXXO98lSpdmo8+L+qvUB9HN5OSZOecpQ4lofvjuQq9rNTHRZssdjmPlIuTGomIHfKCjSHbmPRUSV3eFh92+FzxRdIVtmzrVFiRDu1XSuclDhZT03eMKQs4ce2JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jzy+bqbE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jzy+bqbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F183A1F000C4;
	Sat, 17 Oct 2026 16:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255317;
	bh=6DcV64i9LUt6KSipuxbVO+UM8fqZiqYSFY02F/QO42U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jzy+bqbEm2nl2uOi8aOFPVMe3cJ+MFzmRQ2FhS2Dqh/NWQXjD7EgDo9CO7ezyo0/6
	 pfkNx7IS4CninQXsUE3xm1TeGtQIZEDIjeGYK/AnynYgY8bgkbjjN4ZKydSWaDI+6Y
	 k0nA1wldstffWlQWFcS/hJYcymwd6trQ2bjbgsXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 735/869] PM: Rearrange documentation related to __pm_runtime_disable()
Date: Sat, 17 Oct 2026 17:59:36 +0200
Message-ID: <20261017160055.792845048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 258e231dc29fbd72bc82c16859a8304f71780ba2 ]

There are only two callers of __pm_runtime_disable(), one of which is
device_suspend_late() and the other is pm_runtime_disable() that has
its own kerneldoc comment and there are no plans to add any more of
them.  Since they use different values of the __pm_runtime_disable()
second parameter, the actual code behavior is different in each case,
but it is all documented in the __pm_runtime_disable() kerneldoc comment
which is not particularly straightforward.

For this reason, move the information from the __pm_runtime_disable()
kerneldoc comment to the pm_runtime_disable() one and into a separate
comment in device_suspend_late() and remove the __pm_runtime_disable()
kerneldoc comment altogether.

No functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://patch.msgid.link/12617588.O9o76ZdvQC@rjwysocki.net
Stable-dep-of: 36d74f17e03f ("driver core: Avoid warning when removing a device while its supplier is unbinding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c    |  4 ++++
 drivers/base/power/runtime.c | 14 --------------
 include/linux/pm_runtime.h   | 17 ++++++++++++-----
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 34645758b2f1b..577202aaaffbf 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1401,6 +1401,10 @@ static int device_suspend_late(struct device *dev, pm_message_t state, bool asyn
 	TRACE_DEVICE(dev);
 	TRACE_SUSPEND(0);
 
+	/*
+	 * Disable runtime PM for the device without checking if there is a
+	 * pending resume request for it.
+	 */
 	__pm_runtime_disable(dev, false);
 
 	dpm_wait_for_subordinate(dev, async);
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 167ff6f7a3fec..b81d12a45aeb1 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1469,20 +1469,6 @@ int pm_runtime_barrier(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(pm_runtime_barrier);
 
-/**
- * __pm_runtime_disable - Disable runtime PM of a device.
- * @dev: Device to handle.
- * @check_resume: If set, check if there's a resume request for the device.
- *
- * Increment power.disable_depth for the device and if it was zero previously,
- * cancel all pending runtime PM requests for the device and wait for all
- * operations in progress to complete.  The device can be either active or
- * suspended after its runtime PM has been disabled.
- *
- * If @check_resume is set and there's a resume request pending when
- * __pm_runtime_disable() is called and power.disable_depth is zero, the
- * function will wake up the device before disabling its runtime PM.
- */
 void __pm_runtime_disable(struct device *dev, bool check_resume)
 {
 	spin_lock_irq(&dev->power.lock);
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 142ab39a3b386..dfc367df1c305 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -562,11 +562,18 @@ static inline int pm_runtime_set_suspended(struct device *dev)
  * pm_runtime_disable - Disable runtime PM for a device.
  * @dev: Target device.
  *
- * Prevent the runtime PM framework from working with @dev (by incrementing its
- * "blocking" counter).
- *
- * For each invocation of this function for @dev there must be a matching
- * pm_runtime_enable() call in order for runtime PM to be enabled for it.
+ * Prevent the runtime PM framework from working with @dev by incrementing its
+ * "disable" counter.
+ *
+ * If the counter is zero when this function runs and there is a pending runtime
+ * resume request for @dev, it will be resumed.  If the counter is still zero at
+ * that point, all of the pending runtime PM requests for @dev will be canceled
+ * and all runtime PM operations in progress involving it will be waited for to
+ * complete.
+ *
+ * For each invocation of this function for @dev, there must be a matching
+ * pm_runtime_enable() call, so that runtime PM is eventually enabled for it
+ * again.
  */
 static inline void pm_runtime_disable(struct device *dev)
 {
-- 
2.53.0



