Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029137;
	b=yYpBXPwTqmGxXKMklCJqdQZS1aDEVQQ+i/PGlN/p8b6vxUMA6EMhdbvlkJDiazZv7i7t
	 xTHLm1w7lK6yl/0A4XF0QNdH1G216SjwNd1gVL/KSHc3/PagdBdy3nJ6/6BBB9x0ivsMN
	 XcG9qEX5piBFw/KPOcb/nloqe2uoJK5l8evGpAkgMVFG294UEZIP+M1TKKxN3IGydbiYx
	 lESKvL+7gY6WMeISlZsDtVtBCRXUMJn1xH/ZkVbjQZxCoK0hBw4OLD//EZWzlMmfO1iJX
	 /KcmS2L0+cBuQa3x4b7zxI2BJuXAI00qgAM+zmiYQCbs1HHSKHjGGMT4W1zacALqoag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GIJeIHElKDx6sIaICqEHvng0bfRReXc6f+8kQqrKcF8=;
	b=qVQHsRoZMctUPFomBH/YqS20qkfBy2mDHMvfw1VVJ/dxjJeDObpKJwQb1ZhL8iT68OkK
	 mUrMEGWGGUsWDViMQv8qdfpN4TrCAB4Mj+84PT+eaXgW2G8VMUgQJ2qshC3WQecfJ92zG
	 SFHWt1uFW7OA3KBKeDTaoqYSRzSLcSxjiQiVU4UwnvIJoJq2kJIsPMO63nYlZ0Z6xRMtj
	 hznpPA8ell8L+wAA+4cIlUi1B9GDVivB35sYK4SzJHAr1B8xpKQnD1ML6TR/IBtfFOrMH
	 3enqCLZAYjVacZ70ek7IAcCY03R4lQRsVjgbqZQHw2sFf8gK4C9OW61glnj7DVV4ndw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJR4DWri;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335E1606A31C;
	Wed, 18 Nov 2026 19:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJR4DWri
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA6B1F000C6;
	Wed, 18 Nov 2026 19:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029137;
	bh=GIJeIHElKDx6sIaICqEHvng0bfRReXc6f+8kQqrKcF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJR4DWriJYOuSRDFoc8On3SVnO5Zdkk3gygd/H5ujjN2DgsEODZ2ETcT4J4Eve0q4
	 pAki1qgFZBSchfSbd2f8Z/QTjeNdaSGq5Wub1ZnGCxbYrw/vOVAXEAeR2SqTRG63wh
	 wJUKXPxdwEaTG09zIOHN+DR8L1atp4RK6NjnCpG0=
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
Subject: [PATCH 6.12 0242/1756] ACPI: APEI: GHES: Bound CXL event record copy to the firmware section length
Date: Wed, 18 Nov 2026 15:39:29 +0100
Message-ID: <20261118150017.970008903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 045acf13c1313..dd9ea631f6f60 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -714,10 +714,15 @@ static DEFINE_RAW_SPINLOCK(cxl_cper_work_lock);
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
@@ -817,15 +822,18 @@ static bool ghes_do_proc(struct ghes *ghes,
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



