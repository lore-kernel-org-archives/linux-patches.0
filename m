Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FCC27FB38;
	Tue, 27 May 2025 17:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365973; cv=none; b=Hxpo7U3UCeSlHewYjCGpmDy+aeMoHDb+c374Cyv9mpd1SYxYLTxbALNqervJaLcJtCIzq5nAzeVX4/KMfcOoKu1Dg+Gtiz6G8GuJsnG1pmk2CBlBw1SVxsealA4zTkJqWEa6vmaYl9N1ZJP4OHP2DquZ4ONRk+72NlpK/UqLcEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365973; c=relaxed/simple;
	bh=YpmtJD7FzeJqyOWyxXH+bgLoV5mDP6StoedPUuTVUPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f8mXV5MxSZdqStwtV2eBJQPIk0FaJZKMIcKHXwoa3jyWpsukQohwt4Ks2XV0WarJTOlJ4UFI7Ns4/Q0xjnrFWxEvTRUDpl88ILVSuEiN4JXbutDkn8c4DgVX8yTa/vYAnw/8l4QOW7KZoxBQN3phHvR0TkzxBK4o3sZTLU97Z8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x880T+tU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x880T+tU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB80C4CEE9;
	Tue, 27 May 2025 17:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365972;
	bh=YpmtJD7FzeJqyOWyxXH+bgLoV5mDP6StoedPUuTVUPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x880T+tU3zusDSeXFh9H0ZgkCMkctwywRsJ3uNMLG9xXarnoEP1/t99XmAPQntAYO
	 65iyD1jT9CT4iCiFd+Ras7JMO/We0t3BdFoOqY9IneN8Z4x5INx0VXlBaLQ2UsX0lf
	 1w+6W2cTMTij9c46fVlR956prX7WjxOumaOFHTpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Saranya Gopal <saranya.gopal@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 509/626] platform/x86/intel: hid: Add Pantherlake support
Date: Tue, 27 May 2025 18:26:42 +0200
Message-ID: <20250527162505.645779844@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



