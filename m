Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF6F3328F6;
	Fri, 17 Oct 2025 15:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713534; cv=none; b=n9FQ3X13l779BAcwPSJUtfZPIUhFXI2MQK9obyxAiv6f/Qfw9+YkXknw239oZO1toF6MZFL0kHsZUAWf7/bsPm5T2jNv2zYpQCn8rlgE2vinET4SEpLCNDfqS0J/78FC+hmNX9Hy/6xlEVfo/ba2snMgOg2twSx9lGXTfizOJqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713534; c=relaxed/simple;
	bh=VVhPkF/ZQdjxuXuLGUKkwCBeeFt1Dj+n+Ab/crOIz60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTO9e7BcAOBhesXw2rUT+RrYY1ctrwYLwHU9UgElCzor0tZzH3FepU6yGWLSNk5JouQQWuRfL5/+ZrM3yl6eyslx2AIyQwKj6DRR+hhCsC7GgXnY2KU5DZdsdxs8uc9Dzqp9QPYPk501vtLOPKYofQvWCYd6L8Cub6kvdXIQSOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qx/15kIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qx/15kIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBB0C4CEE7;
	Fri, 17 Oct 2025 15:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713534;
	bh=VVhPkF/ZQdjxuXuLGUKkwCBeeFt1Dj+n+Ab/crOIz60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qx/15kIaeQFSTQMa07evwdT6Wz4YLzLqpyiQ1ipTa8ChsSPh8nn5YXj+xzcmwggq7
	 i13l1ug3ynczog4zbJyNctTIK6bvCy6gCn0JTZYd2Sl3Tq8xuXS1cPEozxxDXQ8y53
	 tSyYf7UHBG9H84b9mYIlGqu7P2AGISzscknJxvn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/201] LoongArch: Init acpi_gbl_use_global_lock to false
Date: Fri, 17 Oct 2025 16:51:31 +0200
Message-ID: <20251017145135.850881526@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 98662be7ef20d2b88b598f72e7ce9b6ac26a40f9 ]

Init acpi_gbl_use_global_lock to false, in order to void error messages
during boot phase:

 ACPI Error: Could not enable GlobalLock event (20240827/evxfevnt-182)
 ACPI Error: No response from Global Lock hardware, disabling lock (20240827/evglock-59)

Fixes: 628c3bb40e9a8cefc0a6 ("LoongArch: Add boot and setup routines")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index a494b13c9e90c..31be0d00976e2 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -365,6 +365,7 @@ void __init platform_init(void)
 
 #ifdef CONFIG_ACPI
 	acpi_table_upgrade();
+	acpi_gbl_use_global_lock = false;
 	acpi_gbl_use_default_register_widths = false;
 	acpi_boot_table_init();
 #endif
-- 
2.51.0



