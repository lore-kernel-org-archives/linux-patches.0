Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F363DE454;
	Mon,  4 May 2026 14:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903586; cv=none; b=SGMit9XAi2Ckq2d4zdml50kAgvmIrefsIZpBTbROC7plVvZkNYoFqJfWFekQjus2Dr62JQq6GrYEIn/dAstZa1JGjno7kvKH7F0AncVX+O9warnyt1s7oyVDn0LseY2IDG68eYz4M4jUP4GW39CjXTrgX1PL4HXuFHqDWiSmKAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903586; c=relaxed/simple;
	bh=hoT9Kj+u3oJoDYfK4f/nN8J4lFGknvS/okL3gQDQ1Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amT7G9mVhzGb1OT82X/0kZL67SUG8xl67B/+l8hPjXjYpaxH59Pyh3TDdlZyHtbbaNdvt4Nu9vE0ecOtjPIxxH4wIyeP/XroOu0+L7q+oR/eGl1lvcUiORMgGd1yDusK9s2oC2DwDwo5kp7Bddz+nIi+/qttIALDihhnuZF6doQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wttpFY2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wttpFY2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C19FC2BCB8;
	Mon,  4 May 2026 14:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903585;
	bh=hoT9Kj+u3oJoDYfK4f/nN8J4lFGknvS/okL3gQDQ1Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wttpFY2wU+D4HQZ6mpOR6FOTR4F8u1pxtQB9k42nEbJjun6gEdNT+udisBFkOTJIs
	 NAftU/MwtgOvF3l7mY/mpz2sNjNBPTizhN+OkuaUFYCpFs3MFNSiTzCAZUb+tZcm6f
	 +QTlyE7w44jefSQ9h0RjWbOBSCM5aeV8MmnnjieQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 292/307] mei: me: use PCI_DEVICE_DATA macro
Date: Mon,  4 May 2026 15:52:57 +0200
Message-ID: <20260504135153.778576058@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 9e7a2409ecf4d411b7cc91615b08f6a7576f0aaa ]

Drop old local MEI_PCI_DEVICE macro and use common
PCI_DEVICE_DATA instead.
Update defines to adhere to current naming convention.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20260201094358.1440593-2-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a5a1804332af ("mei: me: add nova lake point H DID")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/bus-fixup.c  |    6 -
 drivers/misc/mei/hw-me-regs.h |  162 +++++++++++++++++-----------------
 drivers/misc/mei/hw-me.h      |    6 -
 drivers/misc/mei/pci-me.c     |  200 +++++++++++++++++++++---------------------
 4 files changed, 184 insertions(+), 190 deletions(-)

--- a/drivers/misc/mei/bus-fixup.c
+++ b/drivers/misc/mei/bus-fixup.c
@@ -303,9 +303,9 @@ static void mei_wd(struct mei_cl_device
 {
 	struct pci_dev *pdev = to_pci_dev(cldev->dev.parent);
 
-	if (pdev->device == MEI_DEV_ID_WPT_LP ||
-	    pdev->device == MEI_DEV_ID_SPT ||
-	    pdev->device == MEI_DEV_ID_SPT_H)
+	if (pdev->device == PCI_DEVICE_ID_INTEL_MEI_WPT_LP ||
+	    pdev->device == PCI_DEVICE_ID_INTEL_MEI_SPT ||
+	    pdev->device == PCI_DEVICE_ID_INTEL_MEI_SPT_H)
 		cldev->me_cl->props.protocol_version = 0x2;
 
 	cldev->do_match = 1;
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -9,120 +9,120 @@
 /*
  * MEI device IDs
  */
-#define MEI_DEV_ID_82946GZ    0x2974  /* 82946GZ/GL */
-#define MEI_DEV_ID_82G35      0x2984  /* 82G35 Express */
-#define MEI_DEV_ID_82Q965     0x2994  /* 82Q963/Q965 */
-#define MEI_DEV_ID_82G965     0x29A4  /* 82P965/G965 */
+#define PCI_DEVICE_ID_INTEL_MEI_82946GZ    0x2974  /* 82946GZ/GL */
+#define PCI_DEVICE_ID_INTEL_MEI_82G35      0x2984  /* 82G35 Express */
+#define PCI_DEVICE_ID_INTEL_MEI_82Q965     0x2994  /* 82Q963/Q965 */
+#define PCI_DEVICE_ID_INTEL_MEI_82G965     0x29A4  /* 82P965/G965 */
 
-#define MEI_DEV_ID_82GM965    0x2A04  /* Mobile PM965/GM965 */
-#define MEI_DEV_ID_82GME965   0x2A14  /* Mobile GME965/GLE960 */
+#define PCI_DEVICE_ID_INTEL_MEI_82GM965    0x2A04  /* Mobile PM965/GM965 */
+#define PCI_DEVICE_ID_INTEL_MEI_82GME965   0x2A14  /* Mobile GME965/GLE960 */
 
-#define MEI_DEV_ID_ICH9_82Q35 0x29B4  /* 82Q35 Express */
-#define MEI_DEV_ID_ICH9_82G33 0x29C4  /* 82G33/G31/P35/P31 Express */
-#define MEI_DEV_ID_ICH9_82Q33 0x29D4  /* 82Q33 Express */
-#define MEI_DEV_ID_ICH9_82X38 0x29E4  /* 82X38/X48 Express */
-#define MEI_DEV_ID_ICH9_3200  0x29F4  /* 3200/3210 Server */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9_82Q35 0x29B4  /* 82Q35 Express */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9_82G33 0x29C4  /* 82G33/G31/P35/P31 Express */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9_82Q33 0x29D4  /* 82Q33 Express */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9_82X38 0x29E4  /* 82X38/X48 Express */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9_3200  0x29F4  /* 3200/3210 Server */
 
-#define MEI_DEV_ID_ICH9_6     0x28B4  /* Bearlake */
-#define MEI_DEV_ID_ICH9_7     0x28C4  /* Bearlake */
-#define MEI_DEV_ID_ICH9_8     0x28D4  /* Bearlake */
-#define MEI_DEV_ID_ICH9_9     0x28E4  /* Bearlake */
-#define MEI_DEV_ID_ICH9_10    0x28F4  /* Bearlake */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9_6     0x28B4  /* Bearlake */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9_7     0x28C4  /* Bearlake */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9_8     0x28D4  /* Bearlake */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9_9     0x28E4  /* Bearlake */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9_10    0x28F4  /* Bearlake */
 
-#define MEI_DEV_ID_ICH9M_1    0x2A44  /* Cantiga */
-#define MEI_DEV_ID_ICH9M_2    0x2A54  /* Cantiga */
-#define MEI_DEV_ID_ICH9M_3    0x2A64  /* Cantiga */
-#define MEI_DEV_ID_ICH9M_4    0x2A74  /* Cantiga */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9M_1    0x2A44  /* Cantiga */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9M_2    0x2A54  /* Cantiga */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9M_3    0x2A64  /* Cantiga */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH9M_4    0x2A74  /* Cantiga */
 
-#define MEI_DEV_ID_ICH10_1    0x2E04  /* Eaglelake */
-#define MEI_DEV_ID_ICH10_2    0x2E14  /* Eaglelake */
-#define MEI_DEV_ID_ICH10_3    0x2E24  /* Eaglelake */
-#define MEI_DEV_ID_ICH10_4    0x2E34  /* Eaglelake */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH10_1    0x2E04  /* Eaglelake */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH10_2    0x2E14  /* Eaglelake */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH10_3    0x2E24  /* Eaglelake */
+#define PCI_DEVICE_ID_INTEL_MEI_ICH10_4    0x2E34  /* Eaglelake */
 
-#define MEI_DEV_ID_IBXPK_1    0x3B64  /* Calpella */
-#define MEI_DEV_ID_IBXPK_2    0x3B65  /* Calpella */
+#define PCI_DEVICE_ID_INTEL_MEI_IBXPK_1    0x3B64  /* Calpella */
+#define PCI_DEVICE_ID_INTEL_MEI_IBXPK_2    0x3B65  /* Calpella */
 
-#define MEI_DEV_ID_CPT_1      0x1C3A  /* Couger Point */
-#define MEI_DEV_ID_PBG_1      0x1D3A  /* C600/X79 Patsburg */
+#define PCI_DEVICE_ID_INTEL_MEI_CPT_1      0x1C3A  /* Couger Point */
+#define PCI_DEVICE_ID_INTEL_MEI_PBG_1      0x1D3A  /* C600/X79 Patsburg */
 
-#define MEI_DEV_ID_PPT_1      0x1E3A  /* Panther Point */
-#define MEI_DEV_ID_PPT_2      0x1CBA  /* Panther Point */
-#define MEI_DEV_ID_PPT_3      0x1DBA  /* Panther Point */
+#define PCI_DEVICE_ID_INTEL_MEI_PPT_1      0x1E3A  /* Panther Point */
+#define PCI_DEVICE_ID_INTEL_MEI_PPT_2      0x1CBA  /* Panther Point */
+#define PCI_DEVICE_ID_INTEL_MEI_PPT_3      0x1DBA  /* Panther Point */
 
-#define MEI_DEV_ID_LPT_H      0x8C3A  /* Lynx Point H */
-#define MEI_DEV_ID_LPT_W      0x8D3A  /* Lynx Point - Wellsburg */
-#define MEI_DEV_ID_LPT_LP     0x9C3A  /* Lynx Point LP */
-#define MEI_DEV_ID_LPT_HR     0x8CBA  /* Lynx Point H Refresh */
+#define PCI_DEVICE_ID_INTEL_MEI_LPT_H      0x8C3A  /* Lynx Point H */
+#define PCI_DEVICE_ID_INTEL_MEI_LPT_W      0x8D3A  /* Lynx Point - Wellsburg */
+#define PCI_DEVICE_ID_INTEL_MEI_LPT_LP     0x9C3A  /* Lynx Point LP */
+#define PCI_DEVICE_ID_INTEL_MEI_LPT_HR     0x8CBA  /* Lynx Point H Refresh */
 
-#define MEI_DEV_ID_WPT_LP     0x9CBA  /* Wildcat Point LP */
-#define MEI_DEV_ID_WPT_LP_2   0x9CBB  /* Wildcat Point LP 2 */
+#define PCI_DEVICE_ID_INTEL_MEI_WPT_LP     0x9CBA  /* Wildcat Point LP */
+#define PCI_DEVICE_ID_INTEL_MEI_WPT_LP_2   0x9CBB  /* Wildcat Point LP 2 */
 
-#define MEI_DEV_ID_SPT        0x9D3A  /* Sunrise Point */
-#define MEI_DEV_ID_SPT_2      0x9D3B  /* Sunrise Point 2 */
-#define MEI_DEV_ID_SPT_3      0x9D3E  /* Sunrise Point 3 (iToutch) */
-#define MEI_DEV_ID_SPT_H      0xA13A  /* Sunrise Point H */
-#define MEI_DEV_ID_SPT_H_2    0xA13B  /* Sunrise Point H 2 */
+#define PCI_DEVICE_ID_INTEL_MEI_SPT        0x9D3A  /* Sunrise Point */
+#define PCI_DEVICE_ID_INTEL_MEI_SPT_2      0x9D3B  /* Sunrise Point 2 */
+#define PCI_DEVICE_ID_INTEL_MEI_SPT_3      0x9D3E  /* Sunrise Point 3 (iToutch) */
+#define PCI_DEVICE_ID_INTEL_MEI_SPT_H      0xA13A  /* Sunrise Point H */
+#define PCI_DEVICE_ID_INTEL_MEI_SPT_H_2    0xA13B  /* Sunrise Point H 2 */
 
-#define MEI_DEV_ID_LBG        0xA1BA  /* Lewisburg (SPT) */
+#define PCI_DEVICE_ID_INTEL_MEI_LBG        0xA1BA  /* Lewisburg (SPT) */
 
-#define MEI_DEV_ID_BXT_M      0x1A9A  /* Broxton M */
-#define MEI_DEV_ID_APL_I      0x5A9A  /* Apollo Lake I */
+#define PCI_DEVICE_ID_INTEL_MEI_BXT_M      0x1A9A  /* Broxton M */
+#define PCI_DEVICE_ID_INTEL_MEI_APL_I      0x5A9A  /* Apollo Lake I */
 
-#define MEI_DEV_ID_DNV_IE     0x19E5  /* Denverton IE */
+#define PCI_DEVICE_ID_INTEL_MEI_DNV_IE     0x19E5  /* Denverton IE */
 
-#define MEI_DEV_ID_GLK        0x319A  /* Gemini Lake */
+#define PCI_DEVICE_ID_INTEL_MEI_GLK        0x319A  /* Gemini Lake */
 
-#define MEI_DEV_ID_KBP        0xA2BA  /* Kaby Point */
-#define MEI_DEV_ID_KBP_2      0xA2BB  /* Kaby Point 2 */
-#define MEI_DEV_ID_KBP_3      0xA2BE  /* Kaby Point 3 (iTouch) */
+#define PCI_DEVICE_ID_INTEL_MEI_KBP        0xA2BA  /* Kaby Point */
+#define PCI_DEVICE_ID_INTEL_MEI_KBP_2      0xA2BB  /* Kaby Point 2 */
+#define PCI_DEVICE_ID_INTEL_MEI_KBP_3      0xA2BE  /* Kaby Point 3 (iTouch) */
 
-#define MEI_DEV_ID_CNP_LP     0x9DE0  /* Cannon Point LP */
-#define MEI_DEV_ID_CNP_LP_3   0x9DE4  /* Cannon Point LP 3 (iTouch) */
-#define MEI_DEV_ID_CNP_H      0xA360  /* Cannon Point H */
-#define MEI_DEV_ID_CNP_H_3    0xA364  /* Cannon Point H 3 (iTouch) */
+#define PCI_DEVICE_ID_INTEL_MEI_CNP_LP     0x9DE0  /* Cannon Point LP */
+#define PCI_DEVICE_ID_INTEL_MEI_CNP_LP_3   0x9DE4  /* Cannon Point LP 3 (iTouch) */
+#define PCI_DEVICE_ID_INTEL_MEI_CNP_H      0xA360  /* Cannon Point H */
+#define PCI_DEVICE_ID_INTEL_MEI_CNP_H_3    0xA364  /* Cannon Point H 3 (iTouch) */
 
-#define MEI_DEV_ID_CMP_LP     0x02e0  /* Comet Point LP */
-#define MEI_DEV_ID_CMP_LP_3   0x02e4  /* Comet Point LP 3 (iTouch) */
+#define PCI_DEVICE_ID_INTEL_MEI_CMP_LP     0x02e0  /* Comet Point LP */
+#define PCI_DEVICE_ID_INTEL_MEI_CMP_LP_3   0x02e4  /* Comet Point LP 3 (iTouch) */
 
-#define MEI_DEV_ID_CMP_V      0xA3BA  /* Comet Point Lake V */
+#define PCI_DEVICE_ID_INTEL_MEI_CMP_V      0xA3BA  /* Comet Point Lake V */
 
-#define MEI_DEV_ID_CMP_H      0x06e0  /* Comet Lake H */
-#define MEI_DEV_ID_CMP_H_3    0x06e4  /* Comet Lake H 3 (iTouch) */
+#define PCI_DEVICE_ID_INTEL_MEI_CMP_H      0x06e0  /* Comet Lake H */
+#define PCI_DEVICE_ID_INTEL_MEI_CMP_H_3    0x06e4  /* Comet Lake H 3 (iTouch) */
 
-#define MEI_DEV_ID_CDF        0x18D3  /* Cedar Fork */
+#define PCI_DEVICE_ID_INTEL_MEI_CDF        0x18D3  /* Cedar Fork */
 
-#define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
-#define MEI_DEV_ID_ICP_N      0x38E0  /* Ice Lake Point N */
+#define PCI_DEVICE_ID_INTEL_MEI_ICP_LP     0x34E0  /* Ice Lake Point LP */
+#define PCI_DEVICE_ID_INTEL_MEI_ICP_N      0x38E0  /* Ice Lake Point N */
 
-#define MEI_DEV_ID_JSP_N      0x4DE0  /* Jasper Lake Point N */
+#define PCI_DEVICE_ID_INTEL_MEI_JSP_N      0x4DE0  /* Jasper Lake Point N */
 
-#define MEI_DEV_ID_TGP_LP     0xA0E0  /* Tiger Lake Point LP */
-#define MEI_DEV_ID_TGP_H      0x43E0  /* Tiger Lake Point H */
+#define PCI_DEVICE_ID_INTEL_MEI_TGP_LP     0xA0E0  /* Tiger Lake Point LP */
+#define PCI_DEVICE_ID_INTEL_MEI_TGP_H      0x43E0  /* Tiger Lake Point H */
 
-#define MEI_DEV_ID_MCC        0x4B70  /* Mule Creek Canyon (EHL) */
-#define MEI_DEV_ID_MCC_4      0x4B75  /* Mule Creek Canyon 4 (EHL) */
+#define PCI_DEVICE_ID_INTEL_MEI_MCC        0x4B70  /* Mule Creek Canyon (EHL) */
+#define PCI_DEVICE_ID_INTEL_MEI_MCC_4      0x4B75  /* Mule Creek Canyon 4 (EHL) */
 
-#define MEI_DEV_ID_EBG        0x1BE0  /* Emmitsburg WS */
+#define PCI_DEVICE_ID_INTEL_MEI_EBG        0x1BE0  /* Emmitsburg WS */
 
-#define MEI_DEV_ID_ADP_S      0x7AE8  /* Alder Lake Point S */
-#define MEI_DEV_ID_ADP_LP     0x7A60  /* Alder Lake Point LP */
-#define MEI_DEV_ID_ADP_P      0x51E0  /* Alder Lake Point P */
-#define MEI_DEV_ID_ADP_N      0x54E0  /* Alder Lake Point N */
+#define PCI_DEVICE_ID_INTEL_MEI_ADP_S      0x7AE8  /* Alder Lake Point S */
+#define PCI_DEVICE_ID_INTEL_MEI_ADP_LP     0x7A60  /* Alder Lake Point LP */
+#define PCI_DEVICE_ID_INTEL_MEI_ADP_P      0x51E0  /* Alder Lake Point P */
+#define PCI_DEVICE_ID_INTEL_MEI_ADP_N      0x54E0  /* Alder Lake Point N */
 
-#define MEI_DEV_ID_RPL_S      0x7A68  /* Raptor Lake Point S */
+#define PCI_DEVICE_ID_INTEL_MEI_RPL_S      0x7A68  /* Raptor Lake Point S */
 
-#define MEI_DEV_ID_MTL_M      0x7E70  /* Meteor Lake Point M */
-#define MEI_DEV_ID_ARL_S      0x7F68  /* Arrow Lake Point S */
-#define MEI_DEV_ID_ARL_H      0x7770  /* Arrow Lake Point H */
+#define PCI_DEVICE_ID_INTEL_MEI_MTL_M      0x7E70  /* Meteor Lake Point M */
+#define PCI_DEVICE_ID_INTEL_MEI_ARL_S      0x7F68  /* Arrow Lake Point S */
+#define PCI_DEVICE_ID_INTEL_MEI_ARL_H      0x7770  /* Arrow Lake Point H */
 
-#define MEI_DEV_ID_LNL_M      0xA870  /* Lunar Lake Point M */
+#define PCI_DEVICE_ID_INTEL_MEI_LNL_M      0xA870  /* Lunar Lake Point M */
 
-#define MEI_DEV_ID_PTL_H      0xE370  /* Panther Lake H */
-#define MEI_DEV_ID_PTL_P      0xE470  /* Panther Lake P */
+#define PCI_DEVICE_ID_INTEL_MEI_PTL_H      0xE370  /* Panther Lake H */
+#define PCI_DEVICE_ID_INTEL_MEI_PTL_P      0xE470  /* Panther Lake P */
 
-#define MEI_DEV_ID_WCL_P      0x4D70  /* Wildcat Lake P */
+#define PCI_DEVICE_ID_INTEL_MEI_WCL_P      0x4D70  /* Wildcat Lake P */
 
-#define MEI_DEV_ID_NVL_S      0x6E68  /* Nova Lake Point S */
+#define PCI_DEVICE_ID_INTEL_MEI_NVL_S      0x6E68  /* Nova Lake Point S */
 
 /*
  * MEI HW Section
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -33,12 +33,6 @@ struct mei_cfg {
 	u32 hw_trc_supported:1;
 };
 
-
-#define MEI_PCI_DEVICE(dev, cfg) \
-	.vendor = PCI_VENDOR_ID_INTEL, .device = (dev), \
-	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID, \
-	.driver_data = (kernel_ulong_t)(cfg),
-
 #define MEI_ME_RPM_TIMEOUT    500 /* ms */
 
 /**
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -26,110 +26,110 @@
 
 /* mei_pci_tbl - PCI Device ID Table */
 static const struct pci_device_id mei_me_pci_tbl[] = {
-	{MEI_PCI_DEVICE(MEI_DEV_ID_82946GZ, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_82G35, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_82Q965, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_82G965, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_82GM965, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_82GME965, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9_82Q35, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9_82G33, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9_82Q33, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9_82X38, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9_3200, MEI_ME_ICH_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9_6, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9_7, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9_8, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9_9, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9_10, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9M_1, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9M_2, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9M_3, MEI_ME_ICH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH9M_4, MEI_ME_ICH_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH10_1, MEI_ME_ICH10_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH10_2, MEI_ME_ICH10_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH10_3, MEI_ME_ICH10_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH10_4, MEI_ME_ICH10_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_IBXPK_1, MEI_ME_PCH6_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_IBXPK_2, MEI_ME_PCH6_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CPT_1, MEI_ME_PCH_CPT_PBG_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_PBG_1, MEI_ME_PCH_CPT_PBG_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_1, MEI_ME_PCH7_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_2, MEI_ME_PCH7_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_3, MEI_ME_PCH7_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_H, MEI_ME_PCH8_SPS_4_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_W, MEI_ME_PCH8_SPS_4_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_LP, MEI_ME_PCH8_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_HR, MEI_ME_PCH8_SPS_4_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_WPT_LP, MEI_ME_PCH8_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_WPT_LP_2, MEI_ME_PCH8_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT, MEI_ME_PCH8_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_2, MEI_ME_PCH8_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_3, MEI_ME_PCH8_ITOUCH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_H, MEI_ME_PCH8_SPS_4_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_H_2, MEI_ME_PCH8_SPS_4_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LBG, MEI_ME_PCH12_SPS_4_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_BXT_M, MEI_ME_PCH8_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_APL_I, MEI_ME_PCH8_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_DNV_IE, MEI_ME_PCH8_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_GLK, MEI_ME_PCH8_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_KBP, MEI_ME_PCH8_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_KBP_2, MEI_ME_PCH8_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_KBP_3, MEI_ME_PCH8_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CNP_LP, MEI_ME_PCH12_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CNP_LP_3, MEI_ME_PCH8_ITOUCH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CNP_H, MEI_ME_PCH12_SPS_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CNP_H_3, MEI_ME_PCH12_SPS_ITOUCH_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_LP, MEI_ME_PCH12_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_LP_3, MEI_ME_PCH8_ITOUCH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_V, MEI_ME_PCH12_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_H, MEI_ME_PCH12_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_H_3, MEI_ME_PCH8_ITOUCH_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_N, MEI_ME_PCH12_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_LP, MEI_ME_PCH15_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_H, MEI_ME_PCH15_SPS_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_JSP_N, MEI_ME_PCH15_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC, MEI_ME_PCH15_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC_4, MEI_ME_PCH8_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CDF, MEI_ME_PCH8_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_EBG, MEI_ME_PCH15_SPS_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_S, MEI_ME_PCH15_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_LP, MEI_ME_PCH15_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_P, MEI_ME_PCH15_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_N, MEI_ME_PCH15_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_SPS_CFG)},
-
-	{MEI_PCI_DEVICE(MEI_DEV_ID_MTL_M, MEI_ME_PCH15_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_S, MEI_ME_PCH15_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_H, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_82946GZ, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_82G35, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_82Q965, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_82G965, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_82GM965, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_82GME965, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9_82Q35, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9_82G33, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9_82Q33, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9_82X38, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9_3200, MEI_ME_ICH_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9_6, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9_7, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9_8, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9_9, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9_10, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9M_1, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9M_2, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9M_3, MEI_ME_ICH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH9M_4, MEI_ME_ICH_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH10_1, MEI_ME_ICH10_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH10_2, MEI_ME_ICH10_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH10_3, MEI_ME_ICH10_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICH10_4, MEI_ME_ICH10_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_IBXPK_1, MEI_ME_PCH6_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_IBXPK_2, MEI_ME_PCH6_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_CPT_1, MEI_ME_PCH_CPT_PBG_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_PBG_1, MEI_ME_PCH_CPT_PBG_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_PPT_1, MEI_ME_PCH7_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_PPT_2, MEI_ME_PCH7_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_PPT_3, MEI_ME_PCH7_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_LPT_H, MEI_ME_PCH8_SPS_4_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_LPT_W, MEI_ME_PCH8_SPS_4_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_LPT_LP, MEI_ME_PCH8_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_LPT_HR, MEI_ME_PCH8_SPS_4_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_WPT_LP, MEI_ME_PCH8_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_WPT_LP_2, MEI_ME_PCH8_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_SPT, MEI_ME_PCH8_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_SPT_2, MEI_ME_PCH8_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_SPT_3, MEI_ME_PCH8_ITOUCH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_SPT_H, MEI_ME_PCH8_SPS_4_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_SPT_H_2, MEI_ME_PCH8_SPS_4_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_LBG, MEI_ME_PCH12_SPS_4_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_BXT_M, MEI_ME_PCH8_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_APL_I, MEI_ME_PCH8_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_DNV_IE, MEI_ME_PCH8_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_GLK, MEI_ME_PCH8_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_KBP, MEI_ME_PCH8_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_KBP_2, MEI_ME_PCH8_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_KBP_3, MEI_ME_PCH8_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_CNP_LP, MEI_ME_PCH12_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_CNP_LP_3, MEI_ME_PCH8_ITOUCH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_CNP_H, MEI_ME_PCH12_SPS_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_CNP_H_3, MEI_ME_PCH12_SPS_ITOUCH_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_CMP_LP, MEI_ME_PCH12_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_CMP_LP_3, MEI_ME_PCH8_ITOUCH_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_CMP_V, MEI_ME_PCH12_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_CMP_H, MEI_ME_PCH12_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_CMP_H_3, MEI_ME_PCH8_ITOUCH_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_ICP_LP, MEI_ME_PCH12_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ICP_N, MEI_ME_PCH12_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_TGP_LP, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_TGP_H, MEI_ME_PCH15_SPS_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_JSP_N, MEI_ME_PCH15_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_MCC, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_MCC_4, MEI_ME_PCH8_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_CDF, MEI_ME_PCH8_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_EBG, MEI_ME_PCH15_SPS_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_ADP_S, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ADP_LP, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ADP_P, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ADP_N, MEI_ME_PCH15_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_RPL_S, MEI_ME_PCH15_SPS_CFG)},
+
+	{PCI_DEVICE_DATA(INTEL, MEI_MTL_M, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ARL_S, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_ARL_H, MEI_ME_PCH15_CFG)},
 
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LNL_M, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_LNL_M, MEI_ME_PCH15_CFG)},
 
-	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_H, MEI_ME_PCH15_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_P, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_PTL_H, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_PTL_P, MEI_ME_PCH15_CFG)},
 
-	{MEI_PCI_DEVICE(MEI_DEV_ID_WCL_P, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_WCL_P, MEI_ME_PCH15_CFG)},
 
-	{MEI_PCI_DEVICE(MEI_DEV_ID_NVL_S, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_NVL_S, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }


