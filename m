Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5DA43D510;
	Tue, 21 Jul 2026 22:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673497; cv=none; b=nbwIjSnG3o8DyBahjOqj6BIB0v3/KGbBR28yDftTz1bELhCRH7KplXmfx9lGmusOmC3E1iSHebK/z2GCbWLOIORdZYkpZoIG+XcbTQ7KUZh5LhYX1ed1gDd1VplIuuuEeE/4O9zW082ThCnq29wSMQnXhrOPFQivET4uC3q2FAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673497; c=relaxed/simple;
	bh=XzSMcpsm7dOV2FsTqaxQ3vVkTHPpaDirV/7RtTcFYv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRH1B56tqXsjLfCYYoQ/Ng95zd1tpiTkayxlLsjxwP7oWnhNYyL2MeQqpjcKbSzBO6fjHBavJwPuzssCc3T2uvvytvczB7fHUDLk1VjjZR3Scc69NPIxCTF8FfL9P84p0nLxnfzc/qN9MzY8Xb6BMdScj1UNUTThxlgUZEqaCac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRnC8ijC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRnC8ijC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65ED91F000E9;
	Tue, 21 Jul 2026 22:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673487;
	bh=6o0uGDaJ/NS5VwaCYhntr6d3s8c5BTbvw0ZYAMlg5sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WRnC8ijCDm3dlTHBvXGYoV47N5lrle/aXKTrtqSo4AORwgs43Pw8UoTRRZPO3iVOQ
	 +ifZOMb7hBikzQtxiY7zhLK5Ml90oWlE1kdA44M2FULb2IyFdnzBgCErrp0wmG/tbv
	 tbq2xx96HqQ+EiAviuk/rLuylKBbNWTPBpPT2z/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Wei Wang <wei.w.wang@hotmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/699] iommu/amd: Fix a stale comment about which legacy mode is user visible
Date: Tue, 21 Jul 2026 17:19:01 +0200
Message-ID: <20260721152359.803138874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 4bf53c2d0c08bbdaa32f2114281f1ddab61902bf ]

Update a stale comment about which of the legacy modes is visible to the
user, i.e. can be forced via amd_iommu_intr=legacy.

Fixes: b74aa02d7a30 ("iommu/amd: Fix legacy interrupt remapping for x2APIC-enabled system")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu_types.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index c4b1a652c2c7fa..e4a6752f349587 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -820,12 +820,13 @@ static inline int get_hpet_devid(int id)
 }
 
 enum amd_iommu_intr_mode_type {
-	AMD_IOMMU_GUEST_IR_LEGACY,
-
-	/* This mode is not visible to users. It is used when
-	 * we cannot fully enable vAPIC and fallback to only support
-	 * legacy interrupt remapping via 128-bit IRTE.
+	/*
+	 * The legacy format mode is not visible to users to prevent the user
+	 * from crashing x2APIC systems, which for all intents and purposes
+	 * require 128-bit IRTEs.   The legacy format will be forced as needed
+	 * when hardware doesn't support 128-bit IRTEs.
 	 */
+	AMD_IOMMU_GUEST_IR_LEGACY,
 	AMD_IOMMU_GUEST_IR_LEGACY_GA,
 	AMD_IOMMU_GUEST_IR_VAPIC,
 };
-- 
2.53.0



