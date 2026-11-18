Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023234;
	b=16HHcrE6ztsHPTxmQLwMPV0KXp+MQSuxoujYquTP+x1LS3loRe4m2BciLj9jCJq2DAbO
	 /+2zKVlS48uN+nvkQ2AyV9fMa3IQqJ/QrntF/MJMIRSmu4mKOzvnAbN9ux0lk249wUw5z
	 VELMq3etfO4CcOU6wMCKqvsuRDmntU8AlJM2ak+suWGAN4HQKXyw6Ol/4nYN+eX45N04t
	 iqh2rHqNN8Y9uJ6vw4cIMJbrOz/Zge/7H/3E5zcQJ5qOJNLRL5G3C+n+iJiUvzjQp/u1z
	 7rGSa1kUT5dzjfdUU9nb1T5OJE643ZtIrr8CcSkzxHgJHrTBUOM7gd1Da8kLzBddOrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ULpr+IQq1l/DcjlSQBSuHpTeYgoqPzRH37aa/xVp2EU=;
	b=kOpOGbEEaV1qT7UcQRGuaYYDzB2T/Bk8EkcM76SI+4L8Wk+4wpYMJUhf/cbqTv1ZbC8T
	 PsnHfyEvsvNCURkisECeGmxV8aRCCGhSzRed3uAT34Vup9P5NIOe3SkjisEPSt0Ey9X7S
	 SfhOyVh9FWcOfY5kWl8iDd9Sy3NbkyTSVDTR9mOxEBRPP6aEVMbQmulPFIVpiGcuu7Qy4
	 JbfxJVn7cejTorlYjdCsMLkGHMxVrPL0e15nATrZt6x0krMuTry67USY7n5CLukDRzV0n
	 tQx7jJIoobILHVlRIR5Qymm0VYnuROVRzKhPXa+ypua2HhN0iNuXAlxgk8Jf98dnGtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TwCWIZ5c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CE8606A33E;
	Wed, 18 Nov 2026 17:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TwCWIZ5c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E751F000C4;
	Wed, 18 Nov 2026 17:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023234;
	bh=ULpr+IQq1l/DcjlSQBSuHpTeYgoqPzRH37aa/xVp2EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwCWIZ5cDGEfWE1WXJ8TxXAd19rrRU7sn8GdtqhSzVxU+bbVCJ4Hfu/6DEToUsr/O
	 ifU9+xSjwAy02euMcNao/iKxKDWPJ+/QkcHxMtT9qhwAE6NK/DNGpETYsFifoaP03V
	 co/tp7fGZhOZJgk32ioUd3NrB5MLbEG7UmgKJg3o=
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
Subject: [PATCH 6.18 0247/2151] ACPI: APEI: GHES: Bound CXL event record copy to the firmware section length
Date: Wed, 18 Nov 2026 15:33:02 +0100
Message-ID: <20261118150130.791062056@linuxfoundation.org>
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
index f301bee643318..3031447e1fc0e 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -830,10 +830,15 @@ static DEFINE_RAW_SPINLOCK(cxl_cper_work_lock);
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
@@ -937,15 +942,18 @@ static void ghes_do_proc(struct ghes *ghes,
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



