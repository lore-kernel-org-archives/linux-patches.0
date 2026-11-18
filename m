Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015615;
	b=tAEjAcTE3z622UalihCyPbh9oP/Ztj+LRorHU9ESf4rsj3hnPIi49oRDnU5a4GfoBFfV
	 gx8NR0KWKWkwsZGAJ0CbNkzMZGMiBLUxGNEdOT7IMXGuFk3GBE7kRoQzfWIoU7XLSzxjv
	 AqQxgrXhr42S6XgNVnSMR9QgN5k7BRZ41U1beg6xLNV7nGZtyLQjedE5vvBwf+fV7fFTl
	 +mHDuZJoieu4O15Vh2AKkqdPiIm4SSSVnAnGCbMyWyuWOrZhLF+VhqTUu0AWi3nDU6twi
	 LnXcJa2l/4+6O838iSuXseFs940XDQZAt9b3MGqCN2XTvjB1M0u6YCbBLdyD0yDgJ/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7hVCmoyxLdmylhPkzz+2LvPkzYGBqyCaSt1muftFNiA=;
	b=5YuiUfac5AEwe7QX8OLdfL8MNyFL+aFf+G+JMCQ7jAzC6z9OsaAuMCe+Hd7Y9+dPR58F
	 oGpAl3JgGA5UfH0sBeaKdhT6sh0WSyAXJ/aEtt1Dqbo5zNi/bFgCrDpz56Tnd7Pjh0NMx
	 ier/dBk3WhPUE6qYeLHqCYi3/XS5Q9RBgSCr9GRtuCel9MO2SdTrf0m1tPP73sF47RkwU
	 bU+auaFZjpTUJfFB55qhtLdMor2GdVVRBJlIjDRl1pTHUnTQxPUJEyiCqocjwiZEKOcsn
	 t8kdBE0CSewfAEo3/yp+/dbMZi94On3Ql5LL8nK91jH+8pQw5XvoVszsf5IYmtsKmzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dYZD+Fc/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184BC606A33A;
	Wed, 18 Nov 2026 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dYZD+Fc/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD011F000C4;
	Wed, 18 Nov 2026 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015614;
	bh=7hVCmoyxLdmylhPkzz+2LvPkzYGBqyCaSt1muftFNiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYZD+Fc/OaTZR0Zjr/pVKUQGHAfJjbklVTV+thp4nR6yL9XRsGzmhrLLFWPBdqGP0
	 Hnnr9g2sAJCOa53I6uMKoccMqX6QEHaOS0aSTevemNzxA5NZRvHSXNIkXGZVf6PXF3
	 Xs1yCAcC8cycDhY2tBPP33Kg4ityoLSYeKBA/ISs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0235/2651] ACPI: extlog: Validate PCIe error section length before payload access
Date: Wed, 18 Nov 2026 15:24:35 +0100
Message-ID: <20261118150256.317258967@linuxfoundation.org>
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

[ Upstream commit 5eefd849e26506170552e614496d094230650e78 ]

extlog_print_pcie() reads pcie_err->validation_bits and device_id and
copies the 96-byte aer_info buffer without checking that
gdata->error_data_length is big enough for a struct cper_sec_pcie. The
cper_estatus_check() call added earlier keeps the read inside the estatus
block, but a short section still gets stale adjacent bytes treated as PCIe
error data.

Reject a section too small to hold the record before touching any field,
and warn: a truncated section means firmware is emitting malformed records.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-cxl/20260709165457.8BA181F000E9@smtp.kernel.org/
Fixes: e778ffefa34d ("ACPI: extlog: Trace CPER PCI Express Error Section")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-7-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index eed807dd160f8..5f5f54f0a26a9 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -134,7 +134,7 @@ static int print_extlog_rcd(const char *pfx,
 }
 
 static void extlog_print_pcie(struct cper_sec_pcie *pcie_err,
-			      int severity)
+			      int severity, u32 len)
 {
 #ifdef ACPI_APEI_PCIEAER
 	struct aer_capability_regs aer_regs = {};
@@ -144,6 +144,12 @@ static void extlog_print_pcie(struct cper_sec_pcie *pcie_err,
 	int aer_severity;
 	int domain;
 
+	if (len < sizeof(*pcie_err)) {
+		pr_warn_ratelimited(FW_WARN
+				    "PCIe error section too small (%u)\n", len);
+		return;
+	}
+
 	if (!(pcie_err->validation_bits & CPER_PCIE_VALID_DEVICE_ID &&
 	      pcie_err->validation_bits & CPER_PCIE_VALID_AER_INFO))
 		return;
@@ -263,7 +269,8 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err = acpi_hest_get_payload(gdata);
 
-			extlog_print_pcie(pcie_err, gdata->error_severity);
+			extlog_print_pcie(pcie_err, gdata->error_severity,
+					  gdata->error_data_length);
 		} else {
 			void *err = acpi_hest_get_payload(gdata);
 
-- 
2.53.0



