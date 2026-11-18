Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023115;
	b=2HXgYALmjcyf20IYUBwwuBxY/lrFnEOGzaqTX2Ejk7p4RA62jVMYn6X2lOKxK3Xe/n6R
	 WFWPHLBy4mimbLE0es5LENvy8dOvBH0ZF6NqYencaKHNfAxsn1wUBZH76XGy4VW7bkWTW
	 feSO0XtbjYBWub52EVuDaCxy6WZeXu9pPHIjEptaacbESJnjGWQ+ntSu+K6hAAH56WahG
	 ja0WlcpRoJyojyLYvcrtsY8FV2eKSeYMmCNnEtsff9oCFHzb8ke1EfPZsmznjzbl7jT0t
	 8rc8LJpL1F0bjsREgStijFeQdpItDo3tdkBwIYWiQFJO9/p/4AKCd0iH7loM/hlcriw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CarKo6DMZgbhCb9DkeXbiE/uxNuRUF3O1L9IzcDdNrM=;
	b=0TVGk35uKBcFBd9LM7vgYgzcDfjNfI06ogvj1BVveoujCuwPUiczS5V1vYV3zlHoAGoY
	 Evx4DO19yd+x0QibG0bomYygYu+Er82PZgK8fS4XXLr+3WKyiA3KFT3OuzfiliIu6ETzI
	 TSuCK2QcGL8oyl/Ott/7o1p4t1Xx8ycg3mpUlUR3CsQRM2BLrbGetygKQv/zxRBC8NUBU
	 Nw6Nhh2hje5CBHybZ3u7ho0Ln67JxwnT4F1m2xkmbJB8fGcnSBolPCUJ9wHJt4CtkjfpR
	 SyyQoXAz9KuyYjldvN2kCFA4D/xL8W98D9rzR0cB9hJhpd8L6XAgWsARzu9T9mG1Jfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PZPSr93d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F63C606A31C;
	Wed, 18 Nov 2026 17:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PZPSr93d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7C91F000C5;
	Wed, 18 Nov 2026 17:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023115;
	bh=CarKo6DMZgbhCb9DkeXbiE/uxNuRUF3O1L9IzcDdNrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZPSr93dJpxK7hSSxD4y63Ye/yNa2CzomVb56BjYvBpHxaYFJEkfVkm4uUhx+ET+l
	 AwqOzw3RCULBfD30P3vDBT1zbUCXRwZsAZYD8+GRdqemYxNk+BthSYhC8vWmIFnDBU
	 3I67jWssjQFjMDhq5emusUQREpxk9HLCymgseYSQ=
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
Subject: [PATCH 6.18 0255/2151] ACPI: APEI: GHES: Bound AER info copy and sanitize software metadata
Date: Wed, 18 Nov 2026 15:33:10 +0100
Message-ID: <20261118150131.074417546@linuxfoundation.org>
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
index 58c7caa6d3d3a..b81d5ed50d439 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -647,11 +647,14 @@ static void ghes_handle_aer(struct acpi_hest_generic_data *gdata)
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
@@ -669,13 +672,25 @@ static void ghes_handle_aer(struct acpi_hest_generic_data *gdata)
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



