Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CE827D766;
	Tue, 27 May 2025 17:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368262; cv=none; b=USjkIDvdxqMC3mnXBtV2Y7HcOLG1HCDj6kHoyp+34ttBsafMc1WHES/6w5HOnIO2Mlr4AvAxtRj+P1I+AE1FPswviTxJXeAdxyyeyhpBHbt+R5uHzzWHPMJZTaqQJ4iAU9+iPIQpOwwH8iKLRDxcF+tq/aHzzd1TzOyBfSM8G2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368262; c=relaxed/simple;
	bh=AYHHhEGSOd9xznuDiIO3jbcpXe1GQTYVQPdhpYuqm9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FRkvMXGCIOxDvLg93goianskKlh2hZaqI0Eal0MNR7aENgqKwlQ4oEsZonxFstJdXGQQqCpDBWitTA7WZJjpAChvJG3dvvzmKhUuUNbruFy9qpVZE0nsuTrUqCHnqDiBwZs9eZnYADYjcdlS3lZaKRRiJ4Z4q/uVOd5/CsUIBCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Srhuy1Em; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Srhuy1Em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D795C4CEE9;
	Tue, 27 May 2025 17:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368261;
	bh=AYHHhEGSOd9xznuDiIO3jbcpXe1GQTYVQPdhpYuqm9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Srhuy1EmK59HOXwXf8q8+KKsWfqIaA3jVPNm34tP++aUzxzxWzZeV8i3p8rhmKkIy
	 1mrJ8ou7SRtgjPRi8OcpOCm18Csr+Ycsluu+JuTn2jRpchRJMlTwmOpzbVOeubBVSo
	 O3zUQH2Tqleno74MI0XU/Xg1dK5f7CxxzZV0rGhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Saranya Gopal <saranya.gopal@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 651/783] platform/x86/intel: hid: Add Pantherlake support
Date: Tue, 27 May 2025 18:27:28 +0200
Message-ID: <20250527162539.643593714@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saranya Gopal <saranya.gopal@intel.com>

[ Upstream commit 12df9ec3e1955aed6a0c839f2375cd8e5d5150cf ]

Add Pantherlake ACPI device ID to the Intel HID driver.

While there, clean up the device ID table to remove the ", 0" parts.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250421041332.830136-1-saranya.gopal@intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 88a1a9ff2f344..0b5e43444ed60 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -44,16 +44,17 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alex Hung");
 
 static const struct acpi_device_id intel_hid_ids[] = {
-	{"INT33D5", 0},
-	{"INTC1051", 0},
-	{"INTC1054", 0},
-	{"INTC1070", 0},
-	{"INTC1076", 0},
-	{"INTC1077", 0},
-	{"INTC1078", 0},
-	{"INTC107B", 0},
-	{"INTC10CB", 0},
-	{"", 0},
+	{ "INT33D5" },
+	{ "INTC1051" },
+	{ "INTC1054" },
+	{ "INTC1070" },
+	{ "INTC1076" },
+	{ "INTC1077" },
+	{ "INTC1078" },
+	{ "INTC107B" },
+	{ "INTC10CB" },
+	{ "INTC10CC" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, intel_hid_ids);
 
-- 
2.39.5



