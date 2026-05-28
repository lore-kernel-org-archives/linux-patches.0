Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508D62E7F25;
	Thu, 28 May 2026 20:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000738; cv=none; b=A/kwOHL4AVvpfjorz/xh223D0r6V2NnaMwcYztoKqxE87y5wQM4m+FjRqESYyS1PkwbNMzY/V4Dvfw+HCjszeRIOpDwNz8NHEHC3Qqd4PzZr5RSTgNvFpzJxxK7QuaFxLpq6V8f7/x2N+XmFYLjoQQPFHL7HxzdvE2U2nYnSpWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000738; c=relaxed/simple;
	bh=MnOsxv7EANYqJOZpxhERim+qYrJKLD33MEBUfm5TXZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4ia88WoWYhMXdbaPMspFaPsF9S6QlvNGpkD+7o82nK2d2WkHYJ6volWBBb/VXz6lkDYP0f7j+hwOdyJtpOEEDQ2XOPI6pvY9YKZvIYGjkh4Krq61B+HuVfprywZ6SSNnROyobmoCFP2UQT242Kcin35v67/8BQf6BO1LYRY6uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcJsRZDK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcJsRZDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F61E1F000E9;
	Thu, 28 May 2026 20:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000737;
	bh=MEHCrOjI4cNJ3ouA6AAuvGbSaZXVah9aEfjHelBXEmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcJsRZDKmBbSyh+XgbjWGEpZt6p/UDTRHZGdvzxyjNG4qyLAjZPUKJ4uHC2f+Zd/4
	 tlfjREMnXzJb1BM5IybGRL/Knj3v0Lwfg1FtiXE/WWEChM1SFHdhAH7zfncvpIE+a7
	 xge3USBFlYhHgo8FtPBy6nT9a69lEn5t5lm5vxKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/272] firmware: arm_ffa: Remove unnecessary declaration of ffa_partitions_cleanup()
Date: Thu, 28 May 2026 21:48:45 +0200
Message-ID: <20260528194633.594372513@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 9982cabf403fbd06a120a2d5b21830effd32b370 ]

In order to keep the uniformity, just move the ffa_partitions_cleanup()
before it's first usage and drop the unnecessary forward declaration.

No functional change.

Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <20250217-ffa_updates-v3-13-bd1d9de615e7@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 6d3daa9b8d31 ("firmware: arm_ffa: Unregister bus notifier on teardown for FF-A v1.0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 33 +++++++++++++++----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 63030a3849a87..eaaebb841b782 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -114,7 +114,6 @@ struct ffa_drv_info {
 };
 
 static struct ffa_drv_info *drv_info;
-static void ffa_partitions_cleanup(void);
 
 /*
  * The driver must be able to support all the versions from the earliest
@@ -1441,6 +1440,22 @@ static int ffa_xa_add_partition_info(int vm_id)
 	return ret;
 }
 
+static void ffa_partitions_cleanup(void)
+{
+	struct ffa_dev_part_info *info;
+	unsigned long idx;
+
+	/* Clean up/free all registered devices */
+	ffa_devices_unregister();
+
+	xa_for_each(&drv_info->partition_info, idx, info) {
+		xa_erase(&drv_info->partition_info, idx);
+		kfree(info);
+	}
+
+	xa_destroy(&drv_info->partition_info);
+}
+
 static int ffa_setup_partitions(void)
 {
 	int count, idx, ret;
@@ -1498,22 +1513,6 @@ static int ffa_setup_partitions(void)
 	return ret;
 }
 
-static void ffa_partitions_cleanup(void)
-{
-	struct ffa_dev_part_info *info;
-	unsigned long idx;
-
-	/* Clean up/free all registered devices */
-	ffa_devices_unregister();
-
-	xa_for_each(&drv_info->partition_info, idx, info) {
-		xa_erase(&drv_info->partition_info, idx);
-		kfree(info);
-	}
-
-	xa_destroy(&drv_info->partition_info);
-}
-
 /* FFA FEATURE IDs */
 #define FFA_FEAT_NOTIFICATION_PENDING_INT	(1)
 #define FFA_FEAT_SCHEDULE_RECEIVER_INT		(2)
-- 
2.53.0



