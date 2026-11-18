Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015617;
	b=BjgemZ+EqiHU+dzIrl/2iSCVMaTMaLMtrqULZyg3axh7dMkSxW505RjLTMRB4rcgqGu7
	 xwPn/tFLpYDpmEvPwqkXHas7ACkL+CjWzmjcSB8AhAkWK10SeEFF+NCMJSTjioUGz6zpV
	 5+WCL5TNvjYegxgAKQXq7NwFZmfI0f3eNopE/gt4y12aVcWl/mTRKLkvEnxX+IdCx5VVl
	 4tHoNRxVg2sbLsTX5fnXL7cjllpB35NKAM3Ir+zbZc8Sr2YNlCRZAWt87Pwt/NjMZhK/r
	 LNbvStc+xrfkwA6TgvGGgQAkTtfxkIlJXxAU+7OEuwyWl9DxyhIhV26ijVodYGiZqsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+vcx5gjMUo8IcPVzWsvrH9+YYpewnGYvmLrxznJXddc=;
	b=qidpbVxf6SksShSO8QPY5IqDhq3e3vpEjSu3OzbNZtj5rQRNH3h/F1+ncASHybVfgKId
	 dgjxg/bcbU60eJMCVFvhil+OEsYtfcHeN7tgZBor5zTS3om3xK0kFuqCht98L2T+wmdxD
	 WOKfuyZRfbvCYhzUNUeGrlPC9vG/QhTUadB+Sfa/v2OFeo8LkAEC+YnnLE/mxEiPOH3V5
	 jD+l2MXz9SUGoAdH6hxOOxVEQ1tvuCckgX0zzl6yyozyKCOJkhl7mphhjaLyPGqi6RYoq
	 uPHFYErkHmfF1wkTfBe140fuL3ixxwE6PD92X6k7KUru5EpGM1mFIV5hIO8mmM+slTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEQi4vv7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6566E606A320;
	Wed, 18 Nov 2026 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEQi4vv7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA02B1F000C4;
	Wed, 18 Nov 2026 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015617;
	bh=+vcx5gjMUo8IcPVzWsvrH9+YYpewnGYvmLrxznJXddc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEQi4vv7UN7LiwrKBjLM2ZgPZag7djzTU6N9k6UF+7rUdkj6wW+9Wjg8X6vLi5gxN
	 3VkVjVO+OiLx+sPtE0Ek9x7nbP5UxKUOPG5L84MaTv39HwRTfhheQ7GRVj0652Pi1h
	 t/UzvwhEBASWMzv+aLGVWC6ehi+1mxPigWYsCIBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Ben Cheatham <benjamin.cheatham@amd.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0236/2651] ACPI: extlog: Fix CONFIG_ACPI_APEI_PCIEAER guard typo
Date: Wed, 18 Nov 2026 15:24:36 +0100
Message-ID: <20261118150256.358450312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 44a8d464d79b60883f7bd386049a1ffff32ca690 ]

The guard reads "#ifdef ACPI_APEI_PCIEAER" rather than
"#ifdef CONFIG_ACPI_APEI_PCIEAER". That symbol is never defined, so the
extlog PCIe AER handling is always compiled out.

Use the CONFIG_ prefixed symbol.

Fixes: e778ffefa34d ("ACPI: extlog: Trace CPER PCI Express Error Section")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-8-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 5f5f54f0a26a9..4f78a3201c1b6 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -136,7 +136,7 @@ static int print_extlog_rcd(const char *pfx,
 static void extlog_print_pcie(struct cper_sec_pcie *pcie_err,
 			      int severity, u32 len)
 {
-#ifdef ACPI_APEI_PCIEAER
+#ifdef CONFIG_ACPI_APEI_PCIEAER
 	struct aer_capability_regs aer_regs = {};
 	struct pci_dev *pdev;
 	unsigned int devfn;
-- 
2.53.0



