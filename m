Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD02C242D7B;
	Tue, 26 Aug 2025 13:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213759; cv=none; b=MgXoq8kI4t6C+7AovMtX07axgnZrXOx3mAg5LVRKRxki7gsscCKTUptxEI02CZiK4TZSQqoNPA7wgtKNAyqfqf7IgNWUFSD9YaI2XUpOzTX90wrVzptgyhmhEltC5K4k2Xdcdp8Mjwf31KgiZeGqlpey7cF848vn0sNXnLkvKFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213759; c=relaxed/simple;
	bh=lDkQzTOb4JQ5FXW9xWD9eYpX+tQDSKAF9VqSpkVM+bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwXIQwiiWiFtiozrSxkvH9UA8d2U5pFY77pVJfEWTr4FZ2t+TPuI48OemZXhzO8oI4x3vIO/TOaRsN2xwdktR6xf7jzhys89bgqwZn/vCEtuupJNR5qZTOdyMjMnGAUfI2zuC9F8JdvYqY/ZLClA8I4vGVZ68pklbY16xZksvMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVzuj8jH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVzuj8jH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AA9C4CEF1;
	Tue, 26 Aug 2025 13:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213758;
	bh=lDkQzTOb4JQ5FXW9xWD9eYpX+tQDSKAF9VqSpkVM+bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVzuj8jHkxwY7KUlGok+Ehy2a1zzhLak5x54eJlzWuYUAuWFDY6wXvmx1Lcp8Rjnj
	 RHPMUZmqxQLEqOJSSizTVYjHjCYSd/uyic+5dg4Pur36m2B82Wz7loYD/RZtTH3gMT
	 y37AHIyjMk3IyOQfWhl2yRVN93AP4Dy310ywgFzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 468/587] PM: runtime: Take active children into account in pm_runtime_get_if_in_use()
Date: Tue, 26 Aug 2025 13:10:17 +0200
Message-ID: <20250826111004.882506640@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 51888393cc64dd0462d0b96c13ab94873abbc030 ]

For all practical purposes, there is no difference between the situation
in which a given device is not ignoring children and its active child
count is nonzero and the situation in which its runtime PM usage counter
is nonzero.  However, pm_runtime_get_if_in_use() will only increment the
device's usage counter and return 1 in the latter case.

For consistency, make it do so in the former case either by adjusting
pm_runtime_get_conditional() and update the related kerneldoc comments
accordingly.

Fixes: c111566bea7c ("PM: runtime: Add pm_runtime_get_if_active()")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+: c0ef3df8dbae: PM: runtime: Simplify pm_runtime_get_if_active() usage
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Link: https://patch.msgid.link/12700973.O9o76ZdvQC@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1181,10 +1181,12 @@ EXPORT_SYMBOL_GPL(__pm_runtime_resume);
  *
  * Return -EINVAL if runtime PM is disabled for @dev.
  *
- * Otherwise, if the runtime PM status of @dev is %RPM_ACTIVE and either
- * @ign_usage_count is %true or the runtime PM usage counter of @dev is not
- * zero, increment the usage counter of @dev and return 1. Otherwise, return 0
- * without changing the usage counter.
+ * Otherwise, if its runtime PM status is %RPM_ACTIVE and (1) @ign_usage_count
+ * is set, or (2) @dev is not ignoring children and its active child count is
+ * nonero, or (3) the runtime PM usage counter of @dev is not zero, increment
+ * the usage counter of @dev and return 1.
+ *
+ * Otherwise, return 0 without changing the usage counter.
  *
  * If @ign_usage_count is %true, this function can be used to prevent suspending
  * the device when its runtime PM status is %RPM_ACTIVE.
@@ -1206,7 +1208,8 @@ static int pm_runtime_get_conditional(st
 		retval = -EINVAL;
 	} else if (dev->power.runtime_status != RPM_ACTIVE) {
 		retval = 0;
-	} else if (ign_usage_count) {
+	} else if (ign_usage_count || (!dev->power.ignore_children &&
+		   atomic_read(&dev->power.child_count) > 0)) {
 		retval = 1;
 		atomic_inc(&dev->power.usage_count);
 	} else {
@@ -1239,10 +1242,16 @@ EXPORT_SYMBOL_GPL(pm_runtime_get_if_acti
  * @dev: Target device.
  *
  * Increment the runtime PM usage counter of @dev if its runtime PM status is
- * %RPM_ACTIVE and its runtime PM usage counter is greater than 0, in which case
- * it returns 1. If the device is in a different state or its usage_count is 0,
- * 0 is returned. -EINVAL is returned if runtime PM is disabled for the device,
- * in which case also the usage_count will remain unmodified.
+ * %RPM_ACTIVE and its runtime PM usage counter is greater than 0 or it is not
+ * ignoring children and its active child count is nonzero.  1 is returned in
+ * this case.
+ *
+ * If @dev is in a different state or it is not in use (that is, its usage
+ * counter is 0, or it is ignoring children, or its active child count is 0),
+ * 0 is returned.
+ *
+ * -EINVAL is returned if runtime PM is disabled for the device, in which case
+ * also the usage counter of @dev is not updated.
  */
 int pm_runtime_get_if_in_use(struct device *dev)
 {


