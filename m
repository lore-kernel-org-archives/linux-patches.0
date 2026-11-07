Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061145;
	b=DEBaevpBBbnyQ5sd+/FB9zOBU9b0Px9VPcYxUGmeEAnRP0eC+YFFrysCiazYJp7LJriF
	 q1waTSk8kOLKhq6VB1ZYcJyx/YcWH+3flFuwrtL+KmgMTCk9owGybAdIpFh+Cf2n4euq4
	 orrTyKMFUNCug0nZnOl+3r87FT03LNoWcBu8by38OMUTte7qHGw2o+aHbZ99lFAaBEu2V
	 MiPvHC9mb5yPq0Ahz03O9JUfQoji16iJQBHSNPhYedoMmgrBqolOGG7PaUwL5R14A5VC4
	 qBwacnl8/gzRxGSZgbOfQ0xFZtgdiPE3LKLlPphLJDXRFDY9CZQU3dSMGUEruVxoIfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Gj6LFOxdI8LJe3JeoGVRfGYCo4dNNytB5bwky/u3pLI=;
	b=zgybTq5FLB6l1zukWF7UlxxFWgmEqr3nuzzwSRhqQMXFtIeyGV0LJZGSgppLNEuILPWC
	 kPWrnBAUgSevELRQ5rwcZRSiykICth/ghfMhcCpyNec0Li0up2A1GY1++I/KRHM1mlEuk
	 f413uqX+dirONhYlGl5bmqRLho4O0jO7PGn9Ce/PcOt1e0LVm4X9FZjTMhpHnxAbJwGcu
	 q4jHUfzKJHs5Xd56vCVqDC6KL83fbbcijQM7wIfEEyG8/OC5wQyvRKZ7ur4hobd5tBitK
	 5MXWPiTwIaQYH57cCFfIX//ED58OufZnmssDjaKA1z2Y9AzIOdlgaqmDLSq8+my8QEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2QTSZBl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2949B606A33E;
	Sat,  7 Nov 2026 14:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2QTSZBl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9361F0089F;
	Sat,  7 Nov 2026 14:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061145;
	bh=Gj6LFOxdI8LJe3JeoGVRfGYCo4dNNytB5bwky/u3pLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2QTSZBlsk/3Vva9sbIt3ZzXT7BKbE7Xj+Q9x6aqYneG2hFgV6+Q+mSPZpZI1NKYr
	 2AXc1SWqmgB1UdMQ+R2Iflrxh3h6Nhc/3wdm0nzhRo3cPGUAVDCaE2ydc6IU+r1TV1
	 OefyYfEBUXRo2wPG/ex7hJ27Z4yLLHuOBqvFaYRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Haarmann <julian.haarmann@student.kit.edu>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0451/1536] platform/x86: lenovo/ymc: Only match lower byte in WMI lid switch query response
Date: Sat,  7 Nov 2026 08:41:07 -0500
Message-ID: <20261107135010.199718082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Haarmann <julian.haarmann@student.kit.edu>

[ Upstream commit bbc497b5231829d32c3a53b6e66be1add76c0064 ]

On newer Lenovo Yoga devices like the "Yoga 9 2-in-1 14IPH11 - Type 83SE",
the hinge switch WMI query returns extra data in the upper bits
(e.g. 0x50001 laptop mode, 0x50002 tablet mode, ect.).

The driver previously checked for exact matches (0x01 laptop, 0x02 tablet,
ect.) causing newer switches to not work.

Mask the WMI query result to only match the lower byte and ignore upper
bits.

Signed-off-by: Julian Haarmann <julian.haarmann@student.kit.edu>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260614203235.235724-1-julian.haarmann@student.kit.edu
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lenovo-ymc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/lenovo-ymc.c b/drivers/platform/x86/lenovo-ymc.c
index bd9f95404c7cb..4e3f7d4424610 100644
--- a/drivers/platform/x86/lenovo-ymc.c
+++ b/drivers/platform/x86/lenovo-ymc.c
@@ -8,6 +8,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/acpi.h>
+#include <linux/bitfield.h>
+#include <linux/bits.h>
 #include <linux/dmi.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
@@ -20,6 +22,8 @@
 #define LENOVO_YMC_QUERY_INSTANCE 0
 #define LENOVO_YMC_QUERY_METHOD 0x01
 
+#define LENOVO_YMC_STATE_MASK GENMASK(7, 0)
+
 static bool force;
 module_param(force, bool, 0444);
 MODULE_PARM_DESC(force, "Force loading on boards without a convertible DMI chassis-type");
@@ -85,7 +89,9 @@ static void lenovo_ymc_notify(struct wmi_device *wdev, union acpi_object *data)
 			"WMI event data is not an integer\n");
 		goto free_obj;
 	}
-	code = obj->integer.value;
+
+	/* strip upper bits (e.g. 0x50000) on newer devices */
+	code = FIELD_GET(LENOVO_YMC_STATE_MASK, obj->integer.value);
 
 	if (!sparse_keymap_report_event(priv->input_dev, code, 1, true))
 		dev_warn(&wdev->dev, "Unknown key %d pressed\n", code);
-- 
2.53.0



