Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015631;
	b=tO3/qd1invPDbVIyhToahqs9hLJbnYZpigalPwSQNAVXOQaLHHev4iy+dzXebIU/gQ8x
	 /XY+sV4GewCeDsSRkg/3Vq7GRuz/BbJvVBELgR1vp+nTToMAa8OlURZV2z2GeX0hOFF7R
	 2aNX+OINqCGWNWucaf4wKH8XOUXfjFN3R54x/c2xgSDBTsvi4msmfOLI3eDG6sU2iF0MJ
	 33PxjdVJFNPdsVYCcmm147ZaJ9ztTi1rdakoF4mUmAExDO42wSsWEYeME33r1eWcvAOIl
	 DWp4on48uBdafwakAdgsirpskp0f60LGq2b8gDlVkzevWiD22tfxxc3nBBvB+3iWigw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p+epphEixRRAtUpWo43ZcVwGH8Gv8yQEu1V1alAN3I8=;
	b=Cs+0nUxbb2IXLdZNg7exM1edA9vAZanYcOKkyDgv6PB+LLbUx4NGxdayqoy4zns2dmv8
	 cp7DYrbireQKLZx4hMkk2xGhJkWhM8J+HCf6zu04xQ4zNcZufXKIW/aJpKUMU1oqQrkci
	 9+sFTyLIjljaxRxHudof2GtzGPxQXw2X+BFE1LMsY1Wk8u//6fW7JIyrRwrj0ChDajwS1
	 9/Soj5d41QL0rQMsdjnKdYxtRgH8W5P0lc3jtsQs0ZrfY0X7omKLRzFtjM0Hp+m1qSxcO
	 3TNtE+bJwk3f+oqJhspsNbGzjVZDrQiBu9mwm2ruj77IOTUoq1rfuyszmOnxBumVdmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AF4au27F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACBD606A32C;
	Wed, 18 Nov 2026 15:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AF4au27F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D9A1F000C8;
	Wed, 18 Nov 2026 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015631;
	bh=p+epphEixRRAtUpWo43ZcVwGH8Gv8yQEu1V1alAN3I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AF4au27FjvsK4gkMfzmFEnBxX4aQp3PCUDya26/5jJsWRU067pfKZOvRr5kPYjuWj
	 4ts2mYN5NjQdzMPejfjkNL42JLehlz8B1zyKl2jif+WynKKjHUnXkMyIpye1cFglJk
	 qR1w+62AHh5K87E3/so0ihSQfzUtLGzEZ9B1dXro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Hanjun Guo <guohanjun@huawei.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0241/2651] ACPI: APEI: GHES: Validate memory error section length before payload access
Date: Wed, 18 Nov 2026 15:24:41 +0100
Message-ID: <20261118150256.534590845@linuxfoundation.org>
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

[ Upstream commit 10338c9085b4939a428a8dc78d2bbf62c161278b ]

ghes_do_proc() hands the CPER_SEC_PLATFORM_MEM payload to the report chain,
arch_apei_report_mem_error() and ghes_handle_memory_failure() without
checking gdata->error_data_length. All three read validation_bits and
physical_addr, at offsets 0 and 16, so a shorter section reads past the
record.

Check the length once in ghes_do_proc(), before any consumer runs. Take the
73-byte struct cper_sec_mem_err_old as the floor: older firmware
legitimately emits that UEFI 2.1/2.2 layout, and it makes validation_bits
safe to read.

The fields from "extended" on are absent from that layout, so also require
whatever length the validation bits claim. Derive it per field rather than
demanding the full 80 bytes: rank needs only 76, and the BANK_GROUP and
BANK_ADDRESS bits describe "bank" at offset 38, which every record carries.
Testing the whole mask against one size, as cper_print_mem() does, gets it
wrong both ways.

Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260714231835.303081-1-dave.jiang@intel.com?part=7
Fixes: ca104edc1784 ("ACPI, APEI, GHES: Cleanup ghes memory error handling")
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-12-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 41 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 6dd2ee025963f..094d112535551 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -929,6 +929,28 @@ static void ghes_log_hwerr(int sev, guid_t *sec_type)
 	hwerr_log_error_type(HWERR_RECOV_OTHERS);
 }
 
+/*
+ * The fields from "extended" on are absent from the 73-byte UEFI 2.1/2.2
+ * layout that older firmware still emits. Return the length needed for the
+ * fields the validation bits claim, so over-claiming is rejected without
+ * rejecting an honest short record.
+ */
+static u32 ghes_mem_err_min_len(u64 validation_bits)
+{
+	u32 len = sizeof(struct cper_sec_mem_err_old);
+
+	if (validation_bits & (CPER_MEM_VALID_ROW_EXT | CPER_MEM_VALID_CHIP_ID))
+		len = offsetof(struct cper_sec_mem_err, rank);
+	if (validation_bits & CPER_MEM_VALID_RANK_NUMBER)
+		len = offsetof(struct cper_sec_mem_err, mem_array_handle);
+	if (validation_bits & CPER_MEM_VALID_CARD_HANDLE)
+		len = offsetof(struct cper_sec_mem_err, mem_dev_handle);
+	if (validation_bits & CPER_MEM_VALID_MODULE_HANDLE)
+		len = sizeof(struct cper_sec_mem_err);
+
+	return len;
+}
+
 static void ghes_do_proc(struct ghes *ghes,
 			 const struct acpi_hest_generic_status *estatus)
 {
@@ -954,6 +976,25 @@ static void ghes_do_proc(struct ghes *ghes,
 		if (guid_equal(sec_type, &CPER_SEC_PLATFORM_MEM)) {
 			struct cper_sec_mem_err *mem_err = acpi_hest_get_payload(gdata);
 
+			/*
+			 * Check once for all three consumers below. The 73-byte
+			 * UEFI 2.1/2.2 layout is the floor, matching
+			 * cper_estatus_print_section() and making
+			 * validation_bits safe to read.
+			 */
+			if (gdata->error_data_length <
+			    sizeof(struct cper_sec_mem_err_old))
+				continue;
+
+			/* Then require what the claimed fields actually need. */
+			if (gdata->error_data_length <
+			    ghes_mem_err_min_len(mem_err->validation_bits)) {
+				pr_warn_ratelimited(FW_WARN GHES_PFX
+						    "memory error section too small (%u) for the fields it claims\n",
+						    gdata->error_data_length);
+				continue;
+			}
+
 			atomic_notifier_call_chain(&ghes_report_chain, sev, mem_err);
 
 			arch_apei_report_mem_error(sev, mem_err);
-- 
2.53.0



