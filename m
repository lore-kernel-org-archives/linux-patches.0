Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015620;
	b=zom/exppe/3mEOBJrXWFwLkAHgsn280fq/JxdpYiilB/KRiE3qXZCmlJu4dwlNL1bZHb
	 VUMuofuBiVr1we0WMNT6X7rQX8DOKKOqmqwG8+A8+uB7unu7pZ/cIUWrzpsvl/ae4GwFU
	 Np89rITnyu0Tp3HKeu+yv3KI8Z9Wh24evbSXghKxf6Dse090l0NWiixsfoh0T6fJ8XDc7
	 KezPDlmfpZOtddNSB3N7qzSH+Xbr8l/OVt7hz3zjLdnLxU9hb7oRXYDYtwDnMn8bG6zxQ
	 Hjs6xbNa824FeRQG6wdfKPTO7QU1Lejld0MK/8En78Nx6dWtYmtSTZDRhp0Ajvg9BMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GwCqVU7L6Mb+p1D7aIjRArB1jM45bhJeL6XDQYZXhAE=;
	b=sNm7nSVUi9PXoGtH5DqlrZyHRLYCWYXp0rol7Z+Jz8ydWfjxbHmEmneHLvY5eQuKcBgF
	 O7IlBdBGgsMb34uey8wHeF+QsCCQg0nvVipPmQDUpE+Ig/YJlpjAUSxxktx8QMKIz1y9J
	 /CPfAqcUYJEh/33DfDsBzHWdD+1+9E0JtyFcWFj6Sl9lwHaG2QJe2M6JYsjEJFG5i0glW
	 jJ/H0aPEgXye7PfF+OQrZZRHsmYTVjWH3npUyXjh49qx1VlDcqOZd4lqGKjEQL9UzGKjO
	 t/Jl2kYAF+Ou/5J4WWIo/b1XPU1Uy3InNE30QQisdav1AEW0Pjh+joVZN/4VxZ7DN+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4VLSbPz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30044606A333;
	Wed, 18 Nov 2026 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4VLSbPz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898361F000C4;
	Wed, 18 Nov 2026 15:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015620;
	bh=GwCqVU7L6Mb+p1D7aIjRArB1jM45bhJeL6XDQYZXhAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4VLSbPzUNK9gIbL5THuoFruOcY7nQAzsb3udiOqLmYZiZStXeIQVJRvGYfBjtfYE
	 ld9E0EGJxEPVWyGXssHs9uvMVglJ7Nk3KH2Yk3r0uLJnFS+LAGyEXMuOwNC0Qn89j0
	 59R2L6Gke2SNkBUfI02766cv+kHkppzBsk4R6bf8=
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
Subject: [PATCH 7.3 0237/2651] ACPI: APEI: GHES: Bound CXL event record copy to the firmware section length
Date: Wed, 18 Nov 2026 15:24:37 +0100
Message-ID: <20261118150256.392459020@linuxfoundation.org>
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

[ Upstream commit b7a4915a2b43d47f0bbb0b2a4c30e722fa0d3191 ]

cxl_cper_post_event() copies a fixed sizeof(struct cxl_cper_event_rec)
out of the firmware CPER section without checking how long the section
actually is, so a short one reads past the record.

Pass gdata->error_data_length in and reject a section too small to hold
the record before the copy.

Reported-by: sashiko-bot@kernel.org
Link: https://sashiko.dev/#/patchset/20260617-topics-ahmtib01-ras_ffh_arm_internal_review-v6-0-91f725174aa0@arm.com?part=6
Fixes: 5e4a264bf8b5 ("acpi/ghes: Process CXL Component Events")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-9-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index ec2d5ca51db02..cf38adc60d688 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -823,10 +823,15 @@ static DEFINE_RAW_SPINLOCK(cxl_cper_work_lock);
 struct work_struct *cxl_cper_work;
 
 static void cxl_cper_post_event(enum cxl_event_type event_type,
-				struct cxl_cper_event_rec *rec)
+				struct cxl_cper_event_rec *rec, u32 len)
 {
 	struct cxl_cper_work_data wd;
 
+	if (len < sizeof(*rec)) {
+		pr_err(FW_WARN "CXL CPER section too small (%u)\n", len);
+		return;
+	}
+
 	if (rec->hdr.length <= sizeof(rec->hdr) ||
 	    rec->hdr.length > sizeof(*rec)) {
 		pr_err(FW_WARN "CXL CPER Invalid section length (%u)\n",
@@ -963,15 +968,18 @@ static void ghes_do_proc(struct ghes *ghes,
 		} else if (guid_equal(sec_type, &CPER_SEC_CXL_GEN_MEDIA_GUID)) {
 			struct cxl_cper_event_rec *rec = acpi_hest_get_payload(gdata);
 
-			cxl_cper_post_event(CXL_CPER_EVENT_GEN_MEDIA, rec);
+			cxl_cper_post_event(CXL_CPER_EVENT_GEN_MEDIA, rec,
+					    gdata->error_data_length);
 		} else if (guid_equal(sec_type, &CPER_SEC_CXL_DRAM_GUID)) {
 			struct cxl_cper_event_rec *rec = acpi_hest_get_payload(gdata);
 
-			cxl_cper_post_event(CXL_CPER_EVENT_DRAM, rec);
+			cxl_cper_post_event(CXL_CPER_EVENT_DRAM, rec,
+					    gdata->error_data_length);
 		} else if (guid_equal(sec_type, &CPER_SEC_CXL_MEM_MODULE_GUID)) {
 			struct cxl_cper_event_rec *rec = acpi_hest_get_payload(gdata);
 
-			cxl_cper_post_event(CXL_CPER_EVENT_MEM_MODULE, rec);
+			cxl_cper_post_event(CXL_CPER_EVENT_MEM_MODULE, rec,
+					    gdata->error_data_length);
 		} else {
 			void *err = acpi_hest_get_payload(gdata);
 
-- 
2.53.0



