Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5737D6AA6
	for <patches@lists.linux.dev>; Fri, 21 Oct 2022 20:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666384557; x=1697920557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sr0b38xXZ200FAk2bInFJdfJNKcjZ4q1uNqY7iCbQH8=;
  b=P+lYeTW3MlqPBG6GCsXk4t6PcPDMHrpPcw3zrAUvR3wNKB4h/9hE/VAY
   WcNKkZ9d3ZiIPUryommfwxCs0WUwd/xUNDtgVfszZPxNLO1W+AF90pfkg
   CTSFSxSZkzcvQ3ZYQ+yPU27y4s0sOzAK1HAFrb8qEr98eCkKrPc8/Ph3n
   IyAW4lf83pb9qgnT6p/nNx1V04AzWGBfZCtqxNLuBCzrx116Yx7IG3BJg
   doj4BbeWQ3Q/109fOmHU8M1tab3i7tw0PuywomnOnNHuCGz4L0JPVR4ps
   su44IKy0a2S0MtNOu/B8WB+8B7IWHibvsW+ocOFUjY8EJXtpt+BuqXXVZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="333675926"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="333675926"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:36 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="735701033"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="735701033"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:36 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	gregkh@linuxfoundation.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com
Subject: [PATCH 11/14] platform/x86/intel/ifs: Remove reload sysfs entry
Date: Fri, 21 Oct 2022 13:34:10 -0700
Message-Id: <20221021203413.1220137-12-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021203413.1220137-1-jithu.joseph@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reload sysfs entry is replaced by current_batch, drop it.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/sysfs.c | 28 --------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/sysfs.c b/drivers/platform/x86/intel/ifs/sysfs.c
index 766cee651bd6..e077910c5d28 100644
--- a/drivers/platform/x86/intel/ifs/sysfs.c
+++ b/drivers/platform/x86/intel/ifs/sysfs.c
@@ -87,33 +87,6 @@ static ssize_t run_test_store(struct device *dev,
 
 static DEVICE_ATTR_WO(run_test);
 
-/*
- * Reload the IFS image. When user wants to install new IFS image
- */
-static ssize_t reload_store(struct device *dev,
-			    struct device_attribute *attr,
-			    const char *buf, size_t count)
-{
-	bool res;
-	int rc;
-
-	if (kstrtobool(buf, &res))
-		return -EINVAL;
-	if (!res)
-		return count;
-
-	if (down_interruptible(&ifs_sem))
-		return -EINTR;
-
-	rc = ifs_load_firmware(dev);
-
-	up(&ifs_sem);
-
-	return (rc == 0) ? count : rc;
-}
-
-static DEVICE_ATTR_WO(reload);
-
 /*
  * Display currently loaded IFS image version.
  */
@@ -135,7 +108,6 @@ static struct attribute *plat_ifs_attrs[] = {
 	&dev_attr_details.attr,
 	&dev_attr_status.attr,
 	&dev_attr_run_test.attr,
-	&dev_attr_reload.attr,
 	&dev_attr_image_version.attr,
 	NULL
 };
-- 
2.25.1

