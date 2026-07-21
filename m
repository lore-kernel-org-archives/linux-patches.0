Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18175471272;
	Tue, 21 Jul 2026 18:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659164; cv=none; b=H+iSYOfWxlxkBMPLaNxQJtZeNn6qWyZqmJ37WQVWTuQKHYGtmRuA9T5/JMgEjDdfAWQxPJlEDDrwNt7cPy8Fc3nIECm/dx63G+rHCjZTp1GrYuws2CavgCuZCLNEc7lMCG76nymFLGrT8/j8x6bEaiw+aVVgaGhUPoCJYwdyVM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659164; c=relaxed/simple;
	bh=f44+e2hO8sd4TjOFKJj1o3JDU16Y4VDPDK6EJfT+stE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gT4h+RNaKRo8QBuZ7rv7aB3eSYNtjx95N7I3Z2KWdaY9URIQF9gHYl3OnD5hiCDri6s1WodmzzxoXcVlj5Lx/OurkAderSYK6oekLh7Xgs60DR57Uij5tXbWaxmJeb0hdxZCRmN+WOCU9ZlCwE1UQ/a5F62DyQAZzh9/Vt8hZ4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InYHbZPW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InYHbZPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9B21F000E9;
	Tue, 21 Jul 2026 18:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659162;
	bh=BHG3lLNINqqvfLJppTnqqmqSEKlTwBXC8UTvZH4SC2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=InYHbZPWgo41hChYnUjtvX7QpWuunyZKgbQAfV42EStmMz8Gei1uJtMaOGJLNC0q+
	 nU1ixC0bj9zsm4pDLBalsncCNtrPBR9hPVBwNFXYT5LwmSDhZtVRFi4SMcJBw9ZIMw
	 Q/9e/jCZ2Uc4tlk5+4DnZL6Obdkt1GOEbF00XNuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Daniel Gibson <daniel@gibson.sh>
Subject: [PATCH 6.18 1417/1611] platform/x86/amd/pmc: Avoid logging "(null)" for DMI values
Date: Tue, 21 Jul 2026 17:25:33 +0200
Message-ID: <20260721152547.310715235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Gibson <daniel@gibson.sh>

commit a0738abd042f7406edd2175a819cf2e66388ed97 upstream.

dmi_get_system_info(...) can return NULL. Using that as %s arguments
of dev_info() would log "(null)" (as part of a message like
'... System Vendor: "(null)", Product Name: "(null)" ...'), which may
be confusing for users.

Use Elvis operator to print "(Unknown)" instead.

Fixes: 428b9fd2dce5 ("platform/x86/amd/pmc: Add delay_suspend module parameter")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606251540.Nr2BtaNu-lkp@intel.com/
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Daniel Gibson <daniel@gibson.sh>
Link: https://patch.msgid.link/20260626220210.1761783-2-daniel@gibson.sh
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -660,11 +660,11 @@ static bool amd_pmc_want_suspend_delay(s
 	} else if (delay_suspend == 1) {
 		if (!intermediate_wakeup)
 			dev_info(pdev->dev, "Delaying suspend by 2.5s because delay_suspend=1. If this solves problems on your machine, please report this whole line to: platform-driver-x86@vger.kernel.org so it can be automatically detected as affected in the future. System Vendor: \"%s\" Product Name: \"%s\" Product Family: \"%s\" Board Vendor: \"%s\" Board Name: \"%s\"\n",
-				 dmi_get_system_info(DMI_SYS_VENDOR),
-				 dmi_get_system_info(DMI_PRODUCT_NAME),
-				 dmi_get_system_info(DMI_PRODUCT_FAMILY),
-				 dmi_get_system_info(DMI_BOARD_VENDOR),
-				 dmi_get_system_info(DMI_BOARD_NAME));
+				 dmi_get_system_info(DMI_SYS_VENDOR) ?: "(Unknown)",
+				 dmi_get_system_info(DMI_PRODUCT_NAME) ?: "(Unknown)",
+				 dmi_get_system_info(DMI_PRODUCT_FAMILY) ?: "(Unknown)",
+				 dmi_get_system_info(DMI_BOARD_VENDOR) ?: "(Unknown)",
+				 dmi_get_system_info(DMI_BOARD_NAME) ?: "(Unknown)");
 		return true;
 	}
 	return false;


