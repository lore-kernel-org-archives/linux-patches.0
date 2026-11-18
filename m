Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028451;
	b=L3XDAIP5bSjJmDD2EW1POMzBNZbGLrgpszOE9y0jJewJ2ZBxEdI6r4Ywi6Y3hUVWj3UP
	 OY3PN9rA4MSeyVvu1uRSi4Ngn1LX3Qt5vKzMm6qC7Fe+ijcNW2PKV2irZoDtRaSBs3Peu
	 lKrDkb+hWu9SHkXRnBJLjI0TmOibEo4BsA1nXibB35yo6+VeJ62rk4CWwOEbLkArCF7bu
	 7r0WMcy02fYBmwspiM93bNWvKJcou55WaOYNjaQqy1t0fjBBjpzJDqIe3viOlczwOGiBV
	 V7ctbNs4p4kvnlRJ8pXZgpg2WPJd9NTDsW5xKJlE4uAdP/fmSIXtZogn7dUMH6Pyokg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xoGUiBsF98p95500sidrZO3tm4iinoE8950rgYdhIAU=;
	b=rGO0mZ3PQNUXK8+BhaGmA9Gnrh+FEJ+GOmI16Wxesr3a0w37ZC2xZu4S6iA5u0QP1BvZ
	 /d8vr0+zgqKtXgPj3/tYbkJJLsyOoQ3Huggm/GCG/Q1gjBGYsLNVmz60OlUVneu3N+Ryp
	 1LAvatlXq91o+9WwrsDY6kfsZQAqUdjXY9kAapk7Cme/OXSgz1ODjv856rRu8Qma+LF41
	 lL+cwM/76KJc5f6Ow6WJOu+JkgcnHiUrtMH4VBFd1Ntq1MNadyOuV5zBMgHU6PhUYd+A/
	 HspyL9i55s7IhwP0lc86nKVN9Nk4CLbI7uzmbUVBwaf8r5lYPJY8ut1ZpuLJPtVWyWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hbCBfRz5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CBF606A333;
	Wed, 18 Nov 2026 19:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hbCBfRz5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE17B1F000C4;
	Wed, 18 Nov 2026 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028451;
	bh=xoGUiBsF98p95500sidrZO3tm4iinoE8950rgYdhIAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbCBfRz5///Ub6LRFoN7tdrCF1V8Ns1d2G2ksSrBzr6BxH7pyyYfdNNXvJ6j+NzOU
	 PJjfFZ+bEFdpntmnRfZ13U8EHHxNSjHeEk5m4/zaayGUUlGD2bcSiCEf263D6j6XYI
	 AG7GipGmPChW3nL21K4sEqrudKtDbe5z3rSWGVmY=
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
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 2150/2151] ACPI: extlog: Fix CONFIG_ACPI_APEI_PCIEAER guard typo
Date: Wed, 18 Nov 2026 16:04:45 +0100
Message-ID: <20261118150239.992629487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

commit 44a8d464d79b60883f7bd386049a1ffff32ca690 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_extlog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -136,7 +136,7 @@ static int print_extlog_rcd(const char *
 static void extlog_print_pcie(struct cper_sec_pcie *pcie_err,
 			      int severity, u32 len)
 {
-#ifdef ACPI_APEI_PCIEAER
+#ifdef CONFIG_ACPI_APEI_PCIEAER
 	struct aer_capability_regs aer_regs = {};
 	struct pci_dev *pdev;
 	unsigned int devfn;


