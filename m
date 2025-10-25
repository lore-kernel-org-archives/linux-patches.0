Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E71303A17;
	Sat, 25 Oct 2025 16:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408589; cv=none; b=Gy264ZwCqudYUnIzHET+h3k9UcG4dSk99M4ME+ypqvfqStfM5GJ/u/Vmwu/6BGPaQOXy97YcEbjiKslR5yNe1tpObgm5Sw98sRKKibSqi11H5bNkXBW/FKmV4rzu7jVVd/Af1sJt/i/m+/9BuwqJeRSC81gxqZkCCQuV0VeNbks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408589; c=relaxed/simple;
	bh=zqY1tD5cG9nV0tP5vTOtO3T1wE6vD00rGkksPeB8h6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c6jY2Bj9lmIFmdK7SbOIQ4hR/9PFxcjZCsoKuc77tbSXeWekb8FhYN1FcMzbIdMMrMsGY8PTAPPO+n0ZoSEfxjcfAeAMizwD/7gPSxL8PInDOB5gTgf0mglmrD48+MG2A1GyK13ia6JmDG7bQqNL78KcEDb9rCFZuu5srzSiM6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9CVcHBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9CVcHBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84EBC4CEF5;
	Sat, 25 Oct 2025 16:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408588;
	bh=zqY1tD5cG9nV0tP5vTOtO3T1wE6vD00rGkksPeB8h6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9CVcHBxWQ2A3ZJSApeo+/md5pDP5b3K8sKV0vVPiOqm5skVkKsbW9pIwSYIp88pp
	 Iu4Vkk2fBhm4zx0XbUg2rwg24SJ9L5s+Wsg3y3KVuAcZZv7U31gaeygH5EjdFDNIJA
	 lFWhkXxFZcknP6zqbhEVpsKrQccznJOI/Zj2MMh+Uk4Udl4hO7f06SXCw6CJQ2hcf4
	 UHFvf7zPSifJNZaYflO+GQF3Ec0UL41lddap3hORroMhknkNoCLnrKPUZBhuw2P79O
	 Ri4GpdVI426lZGsAKJOtpwjHhn9od/oG2xM5FIQeR5d2abwFVROFABXc8vpE2+k5ac
	 nomTEhLPwudIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	dwmw2@infradead.org,
	iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17] iommu/vt-d: Remove LPIG from page group response descriptor
Date: Sat, 25 Oct 2025 11:54:05 -0400
Message-ID: <20251025160905.3857885-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 4402e8f39d0bfff5c0a5edb5e1afe27a56545e11 ]

Bit 66 in the page group response descriptor used to be the LPIG (Last
Page in Group), but it was marked as Reserved since Specification 4.0.
Remove programming on this bit to make it consistent with the latest
specification.

Existing hardware all treats bit 66 of the page group response descriptor
as "ignored", therefore this change doesn't break any existing hardware.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20250901053943.1708490-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- VT-d responses no longer program bit 66 (`QI_PGRP_LPIG`), which the
  Intel spec has marked reserved since 4.0; both the macro removal in
  `drivers/iommu/intel/iommu.h:455-463` and the descriptor writes in
  `drivers/iommu/intel/prq.c:149-155` and
  `drivers/iommu/intel/prq.c:372-395` now guarantee the reserved bit is
  left zero. That brings the driver back into spec compliance and avoids
  undefined behaviour on newer hardware that enforces the “reserved must
  be zero” rule for page-request responses.
- Without this change the kernel still reflected `req->lpig` into the
  response descriptor (`drivers/iommu/intel/prq.c:149-155`, `372-395`
  before the patch), so a “last-page” response would carry a ‘1’ in a
  field the spec now forbids. VT-d PRQ handshakes are sensitive: if the
  IOMMU rejects the response, devices stall waiting for completion, so
  this is a real bug for any implementation following the latest spec.
  Existing hardware already ignores the bit, so clearing it cannot
  regress older systems.
- The fix is tightly scoped to the Intel VT-d page-request path, keeps
  the driver’s outward behaviour (e.g. still reporting
  `IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE` to device drivers at
  `drivers/iommu/intel/prq.c:187-194`), and has no dependencies beyond
  trivial code motion. Backporting simply drops the `QI_PGRP_LPIG()`
  usage in the equivalent response paths (older stable trees have the
  same logic in `svm.c`), so the risk of regression is minimal while the
  upside is support for spec-compliant hardware.

 drivers/iommu/intel/iommu.h | 1 -
 drivers/iommu/intel/prq.c   | 7 ++-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 2c261c069001c..21b2c3f85ddc5 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -462,7 +462,6 @@ enum {
 #define QI_PGRP_PASID(pasid)	(((u64)(pasid)) << 32)
 
 /* Page group response descriptor QW1 */
-#define QI_PGRP_LPIG(x)		(((u64)(x)) << 2)
 #define QI_PGRP_IDX(idx)	(((u64)(idx)) << 3)
 
 
diff --git a/drivers/iommu/intel/prq.c b/drivers/iommu/intel/prq.c
index 52570e42a14c0..ff63c228e6e19 100644
--- a/drivers/iommu/intel/prq.c
+++ b/drivers/iommu/intel/prq.c
@@ -151,8 +151,7 @@ static void handle_bad_prq_event(struct intel_iommu *iommu,
 			QI_PGRP_PASID_P(req->pasid_present) |
 			QI_PGRP_RESP_CODE(result) |
 			QI_PGRP_RESP_TYPE;
-	desc.qw1 = QI_PGRP_IDX(req->prg_index) |
-			QI_PGRP_LPIG(req->lpig);
+	desc.qw1 = QI_PGRP_IDX(req->prg_index);
 
 	qi_submit_sync(iommu, &desc, 1, 0);
 }
@@ -379,19 +378,17 @@ void intel_iommu_page_response(struct device *dev, struct iopf_fault *evt,
 	struct iommu_fault_page_request *prm;
 	struct qi_desc desc;
 	bool pasid_present;
-	bool last_page;
 	u16 sid;
 
 	prm = &evt->fault.prm;
 	sid = PCI_DEVID(bus, devfn);
 	pasid_present = prm->flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID;
-	last_page = prm->flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE;
 
 	desc.qw0 = QI_PGRP_PASID(prm->pasid) | QI_PGRP_DID(sid) |
 			QI_PGRP_PASID_P(pasid_present) |
 			QI_PGRP_RESP_CODE(msg->code) |
 			QI_PGRP_RESP_TYPE;
-	desc.qw1 = QI_PGRP_IDX(prm->grpid) | QI_PGRP_LPIG(last_page);
+	desc.qw1 = QI_PGRP_IDX(prm->grpid);
 	desc.qw2 = 0;
 	desc.qw3 = 0;
 
-- 
2.51.0

