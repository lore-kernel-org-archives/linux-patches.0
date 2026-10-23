Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774062;
	b=xXEAKgqT7d3R9319I1t/loDRhxnwfamOilYuNR3YP89DdD0muaOMOcYRr52w9UubY+5U
	 z0M3Q38D53HQeiMmDGO0TxAGOR/vX6UDOyG+2ZoRkzlQsQno3jqgI2vMN5wwDEnXmJifG
	 8ouAtac7y62opMbDradB1MzO35FyMA+DqJxHrP+UBQBBJ6lqniYAlUnr7TvY7Jf7iUA35
	 pBQMQpr1l2mk0lREbN30cXfM/xoNCCMC+qnRog9ZtEW8hRgH9Aj7c5zbLKq6T8QPPx0HR
	 mUEBLoGD0hjPrBHCD0f7VlKQ+w+vws0W9AnXKxUOASVQfF6tWvrWWLPLL6rF36GzCmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n7mGBk1KYeVebvG5KX0L1RQEqRw6vA1BZz3d95iMFTs=;
	b=Bb1WE4EAXz4ly0Y2Au1ybYQvpQsmt8FDslgQgqQ8OHO1tBPGqEJHXBozFxSFqyD0L6Ee
	 zlqW89R/sVoiD5kBqTNp0ClUYWzstwRDktYQXcPstQtqb5pcSVMyj7oGw6sgpQObd2Gyi
	 21EbPSZQzkeqobh59A2k2NH5A+ArDzPwL/PYKc3uLp4Ea3jCzo/TMkya/WvxUUTUQOuUC
	 0RbVL0meSEZVi7nD4DgOOClby+oa+Gk64Sndi9SgiGqDrvP5FRrWM76pahivRszT00JQp
	 yL61xMLx5UXCuqW+Pazhp5nyEqSF7r6WC71ke2+u0GD8K1+F3BbtrKwON1NRdSj50aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qN2idRFl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23748606A31A;
	Fri, 23 Oct 2026 16:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qN2idRFl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C2D1F01825;
	Fri, 23 Oct 2026 16:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774062;
	bh=n7mGBk1KYeVebvG5KX0L1RQEqRw6vA1BZz3d95iMFTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qN2idRFl+eqbfBgsGrVEVM/STynkTmANqx/Gtj/NAeKowfD/Pp5NGqWF8FUskGjHX
	 cSUM2Z2zhmNsr5VjTYzTxiXzpjjmHRIRFbLOyF/tilNOKC2wYIQQcQ7kbO/gQ2sS9X
	 +0xJKq1JZVD9eLI7fZ3LCFUE0slC91aVXCx8PhoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.18 109/193] drm/i915/dmc: Add sanity check for DMC load address
Date: Fri, 23 Oct 2026 18:36:26 +0200
Message-ID: <20261023163716.787790999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>

commit 7dedc5bb11f95e96fe80757c924d8d9aa7327759 upstream.

For DMC firmware header version 3, the firmware load address is stored
in dmc_info->start_mmioaddr and later used by dmc_load_program().

Unlike the MMIO address table, the firmware load address is not
validated. Add a sanity check to ensure it is within the valid range.

BSpec: 69671, 68378
Fixes: 3d5928a168a9 ("drm/i915/xelpd: Pipe A DMC plugging")
Cc: stable@vger.kernel.org
Assisted-by: Claude-Code:Sonnet-5
Signed-off-by: Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
Reviewed-by: Mitul Golani<mitulkumar.ajitkumar.golani@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260922133535.3180973-6-dibin.moolakadan.subrahmanian@intel.com
(cherry picked from commit 5e47ee5c76ca9becde8df4ad5202845b7ffcbc4c)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dmc.c      |   55 ++++++++++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_dmc_regs.h |   12 +++++
 2 files changed, 67 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dmc.c
+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
@@ -986,6 +986,55 @@ static void dmc_set_fw_offset(struct int
 	}
 }
 
+/*
+ * Check if the load address is within the valid range for the given DMC ID.
+ */
+static bool dmc_load_addr_sanity_check(struct intel_dmc *dmc,
+				       u32 start_addr, u32 payload_size,
+				       int header_ver, enum intel_dmc_id dmc_id)
+{
+	u32 start_range, end_range, end_addr;
+
+	if (header_ver != 3)
+		return true;
+
+	switch (dmc_id) {
+	case DMC_FW_MAIN:
+		start_range = DMC_MAIN_PROGRAM_BASE_START;
+		end_range = DMC_MAIN_PROGRAM_BASE_END;
+		break;
+	case DMC_FW_PIPEA:
+		start_range = DMC_PIPEA_PROGRAM_BASE_START;
+		end_range = DMC_PIPEA_PROGRAM_BASE_END;
+		break;
+	case DMC_FW_PIPEB:
+		start_range = DMC_PIPEB_PROGRAM_BASE_START;
+		end_range = DMC_PIPEB_PROGRAM_BASE_END;
+		break;
+	case DMC_FW_PIPEC:
+		start_range = DMC_PIPEC_PROGRAM_BASE_START;
+		end_range = DMC_PIPEC_PROGRAM_BASE_END;
+		break;
+	case DMC_FW_PIPED:
+		start_range = DMC_PIPED_PROGRAM_BASE_START;
+		end_range = DMC_PIPED_PROGRAM_BASE_END;
+		break;
+	default:
+		MISSING_CASE(dmc_id);
+		return false;
+	}
+
+	if (payload_size == 0)
+		end_addr = start_addr;
+	else if (check_add_overflow(start_addr, payload_size - 1, &end_addr))
+		return false;
+
+	if (start_addr < start_range || end_addr > end_range)
+		return false;
+
+	return true;
+}
+
 static bool dmc_mmio_addr_sanity_check(struct intel_dmc *dmc,
 				       const u32 *mmioaddr, u32 mmio_count,
 				       int header_ver, enum intel_dmc_id dmc_id)
@@ -1145,6 +1194,12 @@ static u32 parse_dmc_fw_header(struct in
 	}
 	dmc_info->dmc_fw_size = dmc_header->fw_size;
 
+	if (!dmc_load_addr_sanity_check(dmc, start_mmioaddr, payload_size,
+					dmc_header->header_ver, dmc_id)) {
+		drm_err(display->drm, "DMC %d: firmware has wrong load address\n", dmc_id);
+		return 0;
+	}
+
 	dmc_info->payload = kmalloc(payload_size, GFP_KERNEL);
 	if (!dmc_info->payload)
 		return 0;
--- a/drivers/gpu/drm/i915/display/intel_dmc_regs.h
+++ b/drivers/gpu/drm/i915/display/intel_dmc_regs.h
@@ -521,6 +521,18 @@ enum pipedmc_event_id {
 #define TGL_PIPE_MMIO_END(dmc_id)	_PICK_EVEN(((dmc_id) - 1), _TGL_PIPEA_MMIO_END,\
 					      _TGL_PIPEB_MMIO_END)
 
+/* For DMC header version v3*/
+#define DMC_MAIN_PROGRAM_BASE_START	0x80000
+#define DMC_MAIN_PROGRAM_BASE_END	0x86fff
+#define DMC_PIPEA_PROGRAM_BASE_START	0x90000
+#define DMC_PIPEA_PROGRAM_BASE_END	0x96fff
+#define DMC_PIPEB_PROGRAM_BASE_START	0x98000
+#define DMC_PIPEB_PROGRAM_BASE_END	0x9efff
+#define DMC_PIPEC_PROGRAM_BASE_START	0x52000
+#define DMC_PIPEC_PROGRAM_BASE_END	0x53fff
+#define DMC_PIPED_PROGRAM_BASE_START	0x59000
+#define DMC_PIPED_PROGRAM_BASE_END	0x5afff
+
 #define SKL_DMC_DC3_DC5_COUNT	_MMIO(0x80030)
 #define SKL_DMC_DC5_DC6_COUNT	_MMIO(0x8002C)
 #define BXT_DMC_DC3_DC5_COUNT	_MMIO(0x80038)


