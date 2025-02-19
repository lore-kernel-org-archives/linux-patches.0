Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D671B6D0A;
	Wed, 19 Feb 2025 08:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955111; cv=none; b=TzQgeU348IAtkqDBGfo1ktAUwY2lgrqnuYaAm9V4EZJxJg0tddF9Zf+Mjd9FFBb7yqwUQJDRgJ+Z1FtL7GVMm5A9sXo8zTjnMgSP5x31/VYpPM/OaKzNBP6YsP5i3s9TAOiuxJhiMGsqbFp2cNcAZkSMjoPRW5ib9k9S6pPq6FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955111; c=relaxed/simple;
	bh=Evu643GM1eWmiiAPhX5Bl6+oPz06Sd3XLedFjRUf2hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yu6B0+YUXMc5fy8GnKL6U43JJ/plmYl/sWxkABfn+HdpV8ZWIvzpVZUYd++SwhvPjuFvUskuWLVIWDg1D8gHACzRTN1MNApDl21vvllEDoleegsEajH+Z/+ThHsYsNm99AgMea4K8yxVJ2oS4GZKB5Van/8mCai59PYMKzYASiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSXMV+G8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSXMV+G8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D80C4CEEC;
	Wed, 19 Feb 2025 08:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955111;
	bh=Evu643GM1eWmiiAPhX5Bl6+oPz06Sd3XLedFjRUf2hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSXMV+G8zPfW+6n1xPtziwTS7uWuV9gZ1yR/CIdSWM33gDQj1PbWZrRBHpk3Fgfcc
	 /NvsEzB0164sG3ljW18bj1LDTno0nxo6cKQOAvefBWRuIBn3JDsJwU8PshTqc+5NoD
	 i23wcNko7DcX+mZzAF0FK1Lnfdq+MU0uttvBmdnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 128/230] USB: serial: option: drop MeiG Smart defines
Date: Wed, 19 Feb 2025 09:27:25 +0100
Message-ID: <20250219082606.693212875@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6aa8a63c471eb6756aabd03f880feffe6a7af6c9 upstream.

Several MeiG Smart modems apparently use the same product id, making the
defines even less useful.

Drop them in favour of using comments consistently to make the id table
slightly less unwieldy.

Cc: stable@vger.kernel.org
Acked-by: Chester A. Unal <chester.a.unal@arinc9.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -619,18 +619,6 @@ static void option_instat_callback(struc
 /* Luat Air72*U series based on UNISOC UIS8910 uses UNISOC's vendor ID */
 #define LUAT_PRODUCT_AIR720U			0x4e00
 
-/* MeiG Smart Technology products */
-#define MEIGSMART_VENDOR_ID			0x2dee
-/*
- * MeiG Smart SLM828, SRM815, and SRM825L use the same product ID. SLM828 is
- * based on Qualcomm SDX12. SRM815 and SRM825L are based on Qualcomm 315.
- */
-#define MEIGSMART_PRODUCT_SRM825L		0x4d22
-/* MeiG Smart SLM320 based on UNISOC UIS8910 */
-#define MEIGSMART_PRODUCT_SLM320		0x4d41
-/* MeiG Smart SLM770A based on ASR1803 */
-#define MEIGSMART_PRODUCT_SLM770A		0x4d57
-
 /* Device flags */
 
 /* Highest interface number which can be used with NCTRL() and RSVD() */
@@ -2366,6 +2354,14 @@ static const struct usb_device_id option
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0a05, 0xff) },			/* Fibocom FM650-CN (NCM mode) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0a06, 0xff) },			/* Fibocom FM650-CN (RNDIS mode) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0a07, 0xff) },			/* Fibocom FM650-CN (MBIM mode) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d41, 0xff, 0, 0) },		/* MeiG Smart SLM320 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d57, 0xff, 0, 0) },		/* MeiG Smart SLM770A */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d22, 0xff, 0, 0) },		/* MeiG Smart SRM815 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d22, 0xff, 0x10, 0x02) },	/* MeiG Smart SLM828 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d22, 0xff, 0x10, 0x03) },	/* MeiG Smart SLM828 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d22, 0xff, 0xff, 0x30) },	/* MeiG Smart SRM815 and SRM825L */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d22, 0xff, 0xff, 0x40) },	/* MeiG Smart SRM825L */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d22, 0xff, 0xff, 0x60) },	/* MeiG Smart SRM825L */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2df3, 0x9d03, 0xff) },			/* LongSung M5710 */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1404, 0xff) },			/* GosunCn GM500 RNDIS */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1405, 0xff) },			/* GosunCn GM500 MBIM */
@@ -2422,14 +2418,6 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(UNISOC_VENDOR_ID, TOZED_PRODUCT_LT70C, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(UNISOC_VENDOR_ID, LUAT_PRODUCT_AIR720U, 0xff, 0, 0) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SLM320, 0xff, 0, 0) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SLM770A, 0xff, 0, 0) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0, 0) },	/* MeiG Smart SRM815 */
-	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0x10, 0x02) },	/* MeiG Smart SLM828 */
-	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0x10, 0x03) },	/* MeiG Smart SLM828 */
-	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x30) },	/* MeiG Smart SRM815 and SRM825L */
-	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x40) },	/* MeiG Smart SRM825L */
-	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x60) },	/* MeiG Smart SRM825L */
 	{ USB_DEVICE_INTERFACE_CLASS(0x1bbb, 0x0530, 0xff),			/* TCL IK512 MBIM */
 	  .driver_info = NCTRL(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x1bbb, 0x0640, 0xff),			/* TCL IK512 ECM */


