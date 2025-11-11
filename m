Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C453A944;
	Tue, 11 Nov 2025 01:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825082; cv=none; b=tIZBnLFWmjEyiQSSpPMPz80gDdwseCVG42YAK1kiimfHOjayc9YakYdr2kHF7hHT/r1JVkgNDktS1VUSQvONXWoYsdEHejMw4qlSi0Ekvxzu03qtXJSOJgZ1zWhCot7lhP50t85QZUKuSASeKkcvmBLpnsSq//8fnqIQDSnE8aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825082; c=relaxed/simple;
	bh=zxyHmcDBRZgH0Fw5AjXxp9qO/a2WfUjjyI1LDmAwDQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bn7j9V1tsSJEpbAOQVXTFHEbMHZ+hHm8jQphJrP58s1YiwQYwLQ5CYBgH56Aef1DSPP9As3Dw9NZKsDRklFMaUNYjlXJ0ZOg4XiRqsBQjtkjE1H8zmowsDCOckgzz8izA1nnLQtLJHOo5MZNbfrBqfJribnD0/VDBb57AJUvxis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLdPYc7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLdPYc7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387A3C16AAE;
	Tue, 11 Nov 2025 01:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825082;
	bh=zxyHmcDBRZgH0Fw5AjXxp9qO/a2WfUjjyI1LDmAwDQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLdPYc7+m1oO3VHsu68G0GY0vzrLR1BADwlf0Eeexdr21EUB9JF6JwjPU2pQpBgqJ
	 fLnA001DLNTlbDmZecTzUgzJVe5KsMJcupaeBUGEVMhzjkisz8+auQsf5bS2V59mix
	 TIsiYyrcSPJZ+fYUcbonD1rzgDz+s+Bl5SwYngGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sunil V L <sunilvl@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 652/849] ACPI: scan: Update honor list for RPMI System MSI
Date: Tue, 11 Nov 2025 09:43:42 +0900
Message-ID: <20251111004552.191296596@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil V L <sunilvl@ventanamicro.com>

[ Upstream commit 4215d1cf59e4b272755f4277a05cd5967935a704 ]

The RPMI System MSI interrupt controller (just like PLIC and APLIC)
needs to probed prior to devices like GED which use interrupts provided
by it. Also, it has dependency on the SBI MPXY mailbox device.

Add HIDs of RPMI System MSI and SBI MPXY mailbox devices to the honor
list so that those dependencies are handled.

Reviewed-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
Link: https://lore.kernel.org/r/20250818040920.272664-17-apatel@ventanamicro.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 9865faa996b0d..f2e032f381625 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -860,6 +860,8 @@ static const char * const acpi_honor_dep_ids[] = {
 	"INTC10CF", /* IVSC (MTL) driver must be loaded to allow i2c access to camera sensors */
 	"RSCV0001", /* RISC-V PLIC */
 	"RSCV0002", /* RISC-V APLIC */
+	"RSCV0005", /* RISC-V SBI MPXY MBOX */
+	"RSCV0006", /* RISC-V RPMI SYSMSI */
 	"PNP0C0F",  /* PCI Link Device */
 	NULL
 };
-- 
2.51.0



