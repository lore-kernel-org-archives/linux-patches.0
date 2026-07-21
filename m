Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEC3400DFC;
	Tue, 21 Jul 2026 20:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664070; cv=none; b=pv4C4l4TFWX6c+O2bUTcVoerv2AYSRv+HiuARln+6OF5nnMctXWFNgeY3FKRHRnSu8VkNA48Ba0IA598F5pWS2ckYjsZ1TIuxKTJoUC/WTbeHWKr0rzM9ZlzdzCNSm6JhXPu7cnlRqz2ew8EdGN75J2tBzj6UofwZuANIfjsQEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664070; c=relaxed/simple;
	bh=zFJqgOKh+n21JVy4HxE9mSUhhOWS3jg2cePkDudEjag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V1F6VFMxK8owNscBTcr8YWw4xcORN1n5ZCld1KHlfBEH9Ifu89nyQYUIsP0qrgHl6kbBq/IDjPaDAnOR/RsXuq3CKCunzPBW3p5BdTcJFa5de/OF1AeuCOmgCVsV2Z5xfYzCX289Zhkjl33/swkNXFUzu2CyUHsTHSiCv5bISzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFniRNTN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFniRNTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD7A1F000E9;
	Tue, 21 Jul 2026 20:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664069;
	bh=wVsIAH6HCBtpY4gqHyyj60E+Z9QG8kEmJvCjCbAus2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WFniRNTNx5Fb8g2pCFYhxlnpDM+N5CUXj3rr/iux+8nHNmUFFb2bXNgey+8mewlyG
	 /tn4FRm0Y8wbDKJr9VgVodHMoIF9X2BY0MozDEQ4IiV9WgiXWv6H2bdhavKhzWunyq
	 86dGNmCkp6u7Iw99RuQ83+XVbmczs0OmnfCxzeoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Daniel Gibson <daniel@gibson.sh>
Subject: [PATCH 6.12 1059/1276] platform/x86/amd/pmc: Avoid logging "(null)" for DMI values
Date: Tue, 21 Jul 2026 17:25:02 +0200
Message-ID: <20260721152509.686298781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -921,11 +921,11 @@ static bool amd_pmc_want_suspend_delay(s
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


