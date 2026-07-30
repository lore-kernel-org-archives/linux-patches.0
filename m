Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650A12D0602;
	Thu, 30 Jul 2026 15:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427048; cv=none; b=aHZMAKhTD7xQTXLf0s0r7m9S4nvXY8pvrHjYJDTodB74JA+qdNYotI6J4Gs1It1R21mHkiQahAZPTcp2EUZNOGNxTEHtGzmFbfy026skR4xcDhk18XxUuAo/ydCnSd52k0Bp7pH9mCbRD7oOA3nsNj2OjkDJ8CvFvm9ive9HUiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427048; c=relaxed/simple;
	bh=H3Njs75GU2J7slNFiVxWaaYRobOVSBbtvb31O7dIFzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZnL0kXcEEvepbxZ3/4TtpFcoJ+SOvd8Iip8vqgElxyQzeBgzfBotf1uXDSYF4xdxsFCSG1rqDtEJ13rdvflJ/w4Xcen37aJNMDs+BSPmTgORhrmFIQ35i8KEnDyZ65OLlmvEdW/s0cTRfiSd8foXb5yRO+T4vc3Eml8jINFiO+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrXBoeAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrXBoeAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C931F000E9;
	Thu, 30 Jul 2026 15:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427047;
	bh=PYV2MYdGHG0AmcJoxZwKbJU40f7tSTTQL3O36Wt0nCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CrXBoeAy1Z7uysfxVB/Da3oj5YKOqEEIp6oBZwFA6Bhe0HGMP2J58Pcz4HIs/DAmD
	 CFt132IeEpuZUQhb/lAOQS8cIBtCueC3VR8sHjQCjUuZxYSmw4zIGLRAQsE3WcFb2m
	 D+uyaNQvIwVx7Gs72QGDAMX8GHdbhHrmTGv8geHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Daniel Gibson <daniel@gibson.sh>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/484] platform/x86/amd/pmc: Avoid logging "(null)" for DMI values
Date: Thu, 30 Jul 2026 16:08:23 +0200
Message-ID: <20260730141423.539160969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index b0951236887797..bf6c7ca247e243 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -852,11 +852,11 @@ static bool amd_pmc_want_suspend_delay(struct amd_pmc_dev *pdev)
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
-- 
2.53.0



