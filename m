Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30F8223DC0;
	Tue,  6 May 2025 21:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567382; cv=none; b=s+RFxAhuGfiJ2rBDrrN4+N3RXcttOWeY8ppp4XedvSW3OcMlR46hdm3ty8FLBoWZrYaru5Dmq34NvBs9e7NaMwA9u6ibnO7pjJw2E5BtQjZjZI2OtspvEbKkwdW5SNDYQxtfX/avNm0RugCKEa93wvGm5d9f6zXq2qRgBzKpCjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567382; c=relaxed/simple;
	bh=vcIDJmEDMs66KkCTPnjXRpxp9M0R+JOuxqcCSSQCht4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HbiEL+hzTaS7bmTa3PFQQabkarQRBJFpYZT53cJzGy+LegmRPvHT3GHv59Fjl0FOi4FaA4+UTA5/tlnBUGfyubzOzDW/55LJGJfs+DLqJo/b9oIym/tYErd+4UIm4wtbjn24656kcL8pA9IEqglFlwqd5OHxGv/tmj5y0uWzayc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olDqrbwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olDqrbwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF93DC4CEF0;
	Tue,  6 May 2025 21:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567382;
	bh=vcIDJmEDMs66KkCTPnjXRpxp9M0R+JOuxqcCSSQCht4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olDqrbwlk7//46Cj/IRGNdeOsYExn+63zyJX9UeFYtZbhvcuuZiHvL0pXg4UgQgaN
	 oHwgTwa/N7DFozRcIaab7IbExuvl3e5lIEGLx1HjRoFbTcfluHwjTw7e8Fl+wViDYe
	 gSlSYt4yD8eqEs2tby+2uu/WLQJoPfRN0UGbaNkEJDiYEX18byXvrCOKe09Iu50Rdj
	 Ni7dE4xiAEi0w7rICAr9USJHYvkwEUj/Kk6aHAsfVAA0So9qsWilfh3HEV6ov/TV0I
	 fRYiuV+PMkOsSLmyyhE2tZeW97/Lm0MaaKnpISPgh0zsNL61Hy+rPYPjNMc26HW6mB
	 DAvHygkbxPY8Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Saranya Gopal <saranya.gopal@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alexhung@gmail.com,
	hdegoede@redhat.com,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 05/18] platform/x86/intel: hid: Add Pantherlake support
Date: Tue,  6 May 2025 17:35:57 -0400
Message-Id: <20250506213610.2983098-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213610.2983098-1-sashal@kernel.org>
References: <20250506213610.2983098-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.27
Content-Transfer-Encoding: 8bit

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
index 9a609358956f3..59392f1a0d8ad 100644
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

