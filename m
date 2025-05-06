Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68B221883F;
	Tue,  6 May 2025 21:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567336; cv=none; b=KKvLCMEwTyLqnU3/e4CKbYN9SZPiXw+e2nv6U7bftbpT7H9kGgNUaBRwLuZuFxPYgunWDJl5AawcR4eope8r4TA064YQJYdIxNZqYYDDsGzZGAGKyPI25yDuH2l0Agsxd+iSLk2Frgfep1WxN9UYxB2P0srweB7+tEZZ1A+wh/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567336; c=relaxed/simple;
	bh=aJPn5X7j0WvTS/lNEbSNSc6QxYKmHx89dafz1IaGtFU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RXR1MUYTvSt2fygdo4oQSjFIPDN+trYAiV0GnR00J6JfR2yYolmssFgubVdKcYpWg53cOhaOrbnlXjgA5KLlwGBQmOuMzAC6cdDQrgTFd8Pibx4ACXqH50xp6chDkilWR6F1rWRzfRXH18pJP32FsSEKC+knWcNLmCpDr5Z++jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XStTWMT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XStTWMT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CA1C4CEE4;
	Tue,  6 May 2025 21:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567336;
	bh=aJPn5X7j0WvTS/lNEbSNSc6QxYKmHx89dafz1IaGtFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XStTWMT8P4FDnffAX2xqxetTJQ22FaXyVcWEcCE8AOfWmVro8dPmACJuONaVxNeB6
	 vh9W02IEf2Ni8/YoOGn12vXJkiafS1ITw6dAoqfp84XJaewLH+oAbE4rQBsuQQcutk
	 nkVB4SpPh4fZJAbX2MANL2k0PPbZY6u2QstKdxx/NWkywOkFbtkByi2ykURlDUkzvb
	 V0zWCdw6/ZPWukF6rfMJvFPENL7bKGodGTaVL0cgs5Kn/70zmnQp4vYSF++HTCzlmB
	 JWMZT6rP4lLKQaTzUXVeBosctkBdZytD5uo/dKzaNlXhrDY0Hm+PPqe05K2Rpsf94X
	 +KhuZ8UWPi0Ng==
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
Subject: [PATCH AUTOSEL 6.14 05/20] platform/x86/intel: hid: Add Pantherlake support
Date: Tue,  6 May 2025 17:35:08 -0400
Message-Id: <20250506213523.2982756-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213523.2982756-1-sashal@kernel.org>
References: <20250506213523.2982756-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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

