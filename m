Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015634;
	b=EChDPXjSY9p/+b7HiT5uK95E/Q3+Tf44YNLRv/tWnXkzjgH2YPsQ60QIsAep7tCY8yJN
	 mpVA0H+EVP3BBoOSekHAFiS4BlQVTu4MyqmVKXcaqLLLloO6vCYp8WtoE/gSkzUXtRlgL
	 DGeDemdXiKkz/3oMKy5qoMU9Gd3/KowD0HE2A6YTkurhHJuAIk83nNwgMS1vDvm08jYrD
	 Vg7cgmQBnNxha8azr3AtTiuirExv/azn/S+PI0stKXQsiQkZXFZUovEAylAc6S/4t60Me
	 RpJzImKHNlctzoyTvYyrBbCWGoYyFO8kA8f9gv2W11HDICtSNlXfbjSs/3rMOIQw+dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NiyoPTnBfRTDCGWJYiLqJ3ZzvyuM9fOB6S6n1HA+z2A=;
	b=tP9noeNmQFFtShAVchDWP5aQqIadXkgFzXdAH78Ao+AwnaDq9SdU8TelLyPtkSZlVlJf
	 94nlkML+ixPZi/FeTRviEisqG3Mnad8U8q3gZZwliZzL8cBG3T4X+kbk8zIu1wlGfqkLW
	 40GeXlSBW7fYNFnJOTzBjNl3lAElHSpeenOnsGV154jdGPdqugDrbeHjdyO7LSBk5MY9T
	 Nxa0lG2b2DnQ1efZnW8/v3++1SdtP6QYAxQlA9w5G0x/oHNJTB/eFR1Axnb0GykXdZeR0
	 Gn58VxH8EvFOqzwJYgTlRQmPH1r6icpvAYa9LJZlUEIhHxZOd/BUxXidFi8T2Ob67fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yBPZnh4Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0C7606A31C;
	Wed, 18 Nov 2026 15:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yBPZnh4Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717A31F000C4;
	Wed, 18 Nov 2026 15:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015633;
	bh=NiyoPTnBfRTDCGWJYiLqJ3ZzvyuM9fOB6S6n1HA+z2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBPZnh4ZXM6BUVwz66Y5UwjM75rEMZTk6nKItkRutHlCheg5p8SkYZRDAPqXUOi59
	 HS57nd6Rb9XX7JlQmbLvx7YwPbYAKUnD/Gv3W1zHOW+jYp1FgCvwHBeFETxZCWpXG9
	 akBrObUDZkjZrAmbF7CDTQBmxT2Rp5VO5FlToqKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0242/2651] ACPI: APEI: GHES: Bound AER info copy and sanitize software metadata
Date: Wed, 18 Nov 2026 15:24:42 +0100
Message-ID: <20261118150256.572378459@linuxfoundation.org>
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

[ Upstream commit 9c3ad3bfff20d2d7a0c9614db2a58e78123bf0ce ]

ghes_handle_aer() copies sizeof(struct aer_capability_regs) out of the
fixed 96-byte pcie_err->aer_info. The struct is larger, so the copy reads
past the section, and it fills the software-only header_len and flit fields
of the embedded struct pcie_tlp_log from firmware bytes.
pcie_print_tlp_log() uses both to bound a loop over dw[], so a large value
walks past the array. Nothing checks the section can hold a struct
cper_sec_pcie either.

Validate error_data_length, zero the destination, and map aer_info onto the
struct as extlog_print_pcie() does: copy up to the four Header Log DWORDs,
then place the TLP Prefix Log from its own offset. The rest stays zero,
covering header_len and flit.

Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260714231835.303081-1-dave.jiang@intel.com?part=3
Fixes: 7e077e6707b3 ("PCI/ERR: Handle TLP Log in Flit mode")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-13-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 094d112535551..4e7df028a0b8c 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -642,11 +642,14 @@ static void ghes_handle_aer(struct acpi_hest_generic_data *gdata)
 #ifdef CONFIG_ACPI_APEI_PCIEAER
 	struct cper_sec_pcie *pcie_err = acpi_hest_get_payload(gdata);
 
+	if (gdata->error_data_length < sizeof(*pcie_err))
+		return;
+
 	if (pcie_err->validation_bits & CPER_PCIE_VALID_DEVICE_ID &&
 	    pcie_err->validation_bits & CPER_PCIE_VALID_AER_INFO) {
+		struct aer_capability_regs *aer_info;
 		unsigned int devfn;
 		int aer_severity;
-		u8 *aer_info;
 
 		devfn = PCI_DEVFN(pcie_err->device_id.device,
 				  pcie_err->device_id.function);
@@ -664,13 +667,25 @@ static void ghes_handle_aer(struct acpi_hest_generic_data *gdata)
 						  sizeof(struct aer_capability_regs));
 		if (!aer_info)
 			return;
-		memcpy(aer_info, pcie_err->aer_info, sizeof(struct aer_capability_regs));
+
+		/*
+		 * Map aer_info onto the struct as extlog_print_pcie() does:
+		 * copy up to the four Header Log DWORDs, then place the TLP
+		 * Prefix Log from where the hardware keeps it. The rest stays
+		 * zero, so firmware cannot drive the pcie_print_tlp_log() loop
+		 * over dw[] out of bounds.
+		 */
+		memset(aer_info, 0, sizeof(struct aer_capability_regs));
+		memcpy(aer_info, pcie_err->aer_info,
+		       offsetof(struct aer_capability_regs, header_log) +
+		       PCIE_STD_NUM_TLP_HEADERLOG * sizeof(u32));
+		memcpy(aer_info->header_log.prefix,
+		       pcie_err->aer_info + PCI_ERR_PREFIX_LOG,
+		       sizeof(aer_info->header_log.prefix));
 
 		aer_recover_queue(pcie_err->device_id.segment,
 				  pcie_err->device_id.bus,
-				  devfn, aer_severity,
-				  (struct aer_capability_regs *)
-				  aer_info);
+				  devfn, aer_severity, aer_info);
 	}
 #endif
 }
-- 
2.53.0



