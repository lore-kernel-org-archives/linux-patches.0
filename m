Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56768344037;
	Tue, 11 Nov 2025 01:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824109; cv=none; b=N0NUPhX9uUzHDJ/RTH/PZP/ilb8XziXPaYcPHegoyPpiTH2EDjPMxyndf5UiR1yQ86jwsbRv0hVT5CDZtAdlPeivm7L2EQ2ksa8li94l5yGSR9cVWS5hbB9b19eHtTeohO9tLupv4FQIPejhTq5BxNvxe2Gv8AJ1dABMj1+Aytg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824109; c=relaxed/simple;
	bh=uawzaMcaIQRNxTWpTd5y5fKNL4S/Y/wn2i7xVW1ukuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sOa/gdVcibHoDh1beVyh9bGUN6FCWwhUQCOzjvLi6kHC8bmgnzqdxA9GWuMRGl1/gHvaiIbXTEpWanZs6HAU0pHHpsN+Grnk9UNowww7dyXXF5u2dIGIggkbStmBF9WJLgV/fmfCB217hYEbmSnyOG/39JJX+cTgSJkvFqZYyjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITbwRE5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITbwRE5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2B0C19425;
	Tue, 11 Nov 2025 01:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824109;
	bh=uawzaMcaIQRNxTWpTd5y5fKNL4S/Y/wn2i7xVW1ukuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITbwRE5F75rHaGpOSd78S2vzkX6aJYS8ZWQDsF4ahj4S5HxHHITHbO2ayh2bDcSor
	 5kV33l7ikLLzdJi06NAbjRm1H6DgUSctNWC/CAigGYiTfMabmEM3t4ZGu93Y4a0Lyo
	 Z+jdiyYdKu9A/k4BxKIFAEab7YGhUGFMbQZaaSjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kean Ren <kean0048@gmail.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 438/849] platform/x86: think-lmi: Add extra TC BIOS error messages
Date: Tue, 11 Nov 2025 09:40:08 +0900
Message-ID: <20251111004547.021865941@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit a0d6959c345d89d811288a718e3f6b145dcadc8c ]

Add extra error messages that are used by ThinkCenter platforms.

Signed-off-by: Kean Ren <kean0048@gmail.com>
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20250903173824.1472244-4-mpearson-lenovo@squebb.ca
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lenovo/think-lmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/platform/x86/lenovo/think-lmi.c b/drivers/platform/x86/lenovo/think-lmi.c
index 0992b41b6221d..e6a2c8e94cfdc 100644
--- a/drivers/platform/x86/lenovo/think-lmi.c
+++ b/drivers/platform/x86/lenovo/think-lmi.c
@@ -179,10 +179,21 @@ MODULE_PARM_DESC(debug_support, "Enable debug command support");
 
 static const struct tlmi_err_codes tlmi_errs[] = {
 	{"Success", 0},
+	{"Set Certificate operation was successful.", 0},
 	{"Not Supported", -EOPNOTSUPP},
 	{"Invalid Parameter", -EINVAL},
 	{"Access Denied", -EACCES},
 	{"System Busy", -EBUSY},
+	{"Set Certificate operation failed with status:Invalid Parameter.", -EINVAL},
+	{"Set Certificate operation failed with status:Invalid certificate type.", -EINVAL},
+	{"Set Certificate operation failed with status:Invalid password format.", -EINVAL},
+	{"Set Certificate operation failed with status:Password retry count exceeded.", -EACCES},
+	{"Set Certificate operation failed with status:Password Invalid.", -EACCES},
+	{"Set Certificate operation failed with status:Operation aborted.", -EBUSY},
+	{"Set Certificate operation failed with status:No free slots to write.", -ENOSPC},
+	{"Set Certificate operation failed with status:Certificate not found.", -EEXIST},
+	{"Set Certificate operation failed with status:Internal error.", -EFAULT},
+	{"Set Certificate operation failed with status:Certificate too large.", -EFBIG},
 };
 
 static const char * const encoding_options[] = {
-- 
2.51.0



