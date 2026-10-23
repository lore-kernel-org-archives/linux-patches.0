Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774802;
	b=zFeW32W0xjDeFElb/WOomMwqWOI0MXrV7hFxyW7P9aCG76HHLof/23vfAOAIVt4faA4K
	 cY4XPYWBl7wNOBB8LPCXhC9e4IO1c5TbVPc4QVzCYe/RfI/LofAzNYNEpAk9aQWZMOL51
	 IIvsHV8s18M7MIjIWN+DR8OC2pMBaEzI3XPmAXu8htxNoO3GXCgx7J2otNsD3Qnl4HIQp
	 poQQzqCwvDRh3uZ3g/09H9u9MNl01AfQwUmRO/RFzd52ATfwOuqW/t0Na59hu4qS3y36v
	 v95jMVma3k4LH/VgE3m18flmiLmSeiHz9+Kf5FxuTJmI746EOxqodCDxZSUlEJkuXCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LnCpUw0I734PANpGwTBfIAtm4IsdcetRgH1c0LzW+f0=;
	b=wLasV1m2UIyLZl1KxoKcPPciV96stqdEN8fJJUF5qf2BHpIviAJmtKagIsm9wO3iqR5r
	 QdnA48cLKWIdbtXT+9cjl2q2jBi05K82LW0bsolP1Naa0+mjmpf25SybiHDbw8m0y4JiO
	 Gw4IY7JfpqP+V31gEAgcbdrIoANFW6uycXidIxDQTPcVHrF7xXpvRUjagK03mNM1ITdmF
	 8B2QWkIfbysNRAD2ni2t1nAysGKW+x/BHnRo2MbFpicgHj+nVqWn06TNR7hJfEdHsmLjw
	 U4NRO5ZR/IW208dHVhq/B/XHUx2A/xX/v4SvjUH3/VcT1mlh+rwg+65Z+jaiPiJEFdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xr7dkl13;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFB9606A32A;
	Fri, 23 Oct 2026 17:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xr7dkl13
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEFF1F01825;
	Fri, 23 Oct 2026 17:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774801;
	bh=LnCpUw0I734PANpGwTBfIAtm4IsdcetRgH1c0LzW+f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xr7dkl1335ewjM6u9uVbQf48kTBjZtCVJdnRC7KYU1U2CHrQ+Qhan7FFYZk5Z2Y4f
	 47329C1CXEtV1OpWtcm+YJ4xuogNgVNzveb68UFYuIYibdecxIRmIpCh8Du+Syi8n0
	 5pmiCXG1USL6hEpcTgpJt/PG5m0nEl90Y8F4O4aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 7.2 162/242] drm/i915/dmc: Add sanity check for DMC load address
Date: Fri, 23 Oct 2026 18:40:04 +0200
Message-ID: <20261023163717.616576026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1019,6 +1019,55 @@ static void dmc_set_fw_offset(struct int
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
@@ -1178,6 +1227,12 @@ static u32 parse_dmc_fw_header(struct in
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


