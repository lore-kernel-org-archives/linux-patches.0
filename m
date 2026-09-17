Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9284A3B27E1;
	Thu, 17 Sep 2026 19:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671703; cv=none; b=nXEwpyROoub4Hq6ELr9zbGaxxqXjLgoyejdbEa67x2MYifqhEQYUqQEekk6UdoBqoArmhkUszATvDF1X4cExfqU2XG89kW/XUgZja20fagK/couH7+gfDfaf7sHikvQS2EglaVt0PF19lyxdIArFmEu+/8UkGhZwl/Hm06dFgaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671703; c=relaxed/simple;
	bh=GbhuqO73FDEv1oJTPgyYGVGHe5PSbwI66XUu1TEu6hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+P1JK3tWf7/bEazjOjXZDQsLJYzRL6JkrhWXBYglpvL66VHPVeHLSx71tBsbsSipTfe0ii0sjW7/K2ACsRBY2W2cxq0X3j08VKjXWpG6JaBTaHo+IeoyVZfG3/5Sg7jDB7Bd/vIaT/9x6P/IccP4UAuoQX1TwT46iqNnCFdNAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThqiXb+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThqiXb+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F421F000FF;
	Thu, 17 Sep 2026 19:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671701;
	bh=W8E3mn03j4qxGLSzKpCzHnHQMUefMC4+QBIYq9KG5h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThqiXb+5Gh594o53Dk6A0yFfwdpYudPsryf9TubGB3wn9qWhjF70h1H0PdRXfyT6+
	 gkR2kRETKPpDknHwgG0UkQ0e8yBBgc2QwSD+TwMtEW8oeK2Y8CzAXWl35iOwi2gW8H
	 JbK4uP0Rx1uWWu7wkr0kRvHudv23XhVrwI/tVwX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Gregory Price <gourry@gourry.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1063/1102] efi/cper, cxl: Prefix protocol error struct and function names with cxl_
Date: Thu, 17 Sep 2026 16:16:46 +0100
Message-ID: <20260917151607.502762683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

[ Upstream commit 84973331442a57bac31b40eaef6f264496c6f3fd ]

Rename the protocol error struct from struct cper_sec_prot_err to
struct cxl_cper_sec_prot_err and cper_print_prot_err() to
cxl_cper_print_prot_err() to maintain naming consistency. No
functional changes.

Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20250123084421.127697-2-Smita.KoralahalliChannabasappa@amd.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 6625ca499c31 ("acpi/apei/ghes: Use raw_spinlock_t for CXL CPER work locks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/cper.c     |    4 ++--
 drivers/firmware/efi/cper_cxl.c |    3 ++-
 drivers/firmware/efi/cper_cxl.h |    5 +++--
 3 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -690,11 +690,11 @@ cper_estatus_print_section(const char *p
 		else
 			goto err_section_too_small;
 	} else if (guid_equal(sec_type, &CPER_SEC_CXL_PROT_ERR)) {
-		struct cper_sec_prot_err *prot_err = acpi_hest_get_payload(gdata);
+		struct cxl_cper_sec_prot_err *prot_err = acpi_hest_get_payload(gdata);
 
 		printk("%ssection_type: CXL Protocol Error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*prot_err))
-			cper_print_prot_err(newpfx, prot_err);
+			cxl_cper_print_prot_err(newpfx, prot_err);
 		else
 			goto err_section_too_small;
 	} else {
--- a/drivers/firmware/efi/cper_cxl.c
+++ b/drivers/firmware/efi/cper_cxl.c
@@ -55,7 +55,8 @@ enum {
 	USP,	/* CXL Upstream Switch Port */
 };
 
-void cper_print_prot_err(const char *pfx, const struct cper_sec_prot_err *prot_err)
+void cxl_cper_print_prot_err(const char *pfx,
+			     const struct cxl_cper_sec_prot_err *prot_err)
 {
 	if (prot_err->valid_bits & PROT_ERR_VALID_AGENT_TYPE)
 		pr_info("%s agent_type: %d, %s\n", pfx, prot_err->agent_type,
--- a/drivers/firmware/efi/cper_cxl.h
+++ b/drivers/firmware/efi/cper_cxl.h
@@ -18,7 +18,7 @@
 #pragma pack(1)
 
 /* Compute Express Link Protocol Error Section, UEFI v2.10 sec N.2.13 */
-struct cper_sec_prot_err {
+struct cxl_cper_sec_prot_err {
 	u64 valid_bits;
 	u8 agent_type;
 	u8 reserved[7];
@@ -61,6 +61,7 @@ struct cper_sec_prot_err {
 
 #pragma pack()
 
-void cper_print_prot_err(const char *pfx, const struct cper_sec_prot_err *prot_err);
+void cxl_cper_print_prot_err(const char *pfx,
+			     const struct cxl_cper_sec_prot_err *prot_err);
 
 #endif //__CPER_CXL_


