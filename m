Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F544DB57B;
	Tue, 21 Jul 2026 15:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648503; cv=none; b=Dvf0JIwIUNhoz1rdQZ8lxIrhqeOyeIimPwl35MkpVBXm2sUtILQ4ePRRnlu7xOEJ0jFHKjlxJM7UfCpRT+mKhCTikwdg2sVlVJZImJyUWeOHaX6SyqWkaNemGBTNNlvKaqbBqQJuoEiQpYFO/SNKdgklsbu40LHzGgZfnnk8pSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648503; c=relaxed/simple;
	bh=cZ9uVZc7r4PbYaNuy7lmMYYpUwcDhnw1XAbdkWWgDXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qu/XR6YI5enqkGjNzUEjgdxGAVPkKvi9uXdEXDPTOQJHiTBSJAR/5XUh0noWZgK0j/y0cgxZVOP9Y7JGQl7rMEpHboMXU6+1H3dCOFDupnwU9RV7pjQ3hvyvm02LUivrdNMMcXlAvn5QqiUGUXJfE1LjpIA6aPvYFqsa2nrjfGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UI6EcF5a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UI6EcF5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473A41F00A3A;
	Tue, 21 Jul 2026 15:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648502;
	bh=iTj+tdC87w4WPUO7dnBht9HW80loCmUUtEGq/hOxzXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UI6EcF5aomeA1doiZermoAjf36RtpB8ldRaZy2GncBK/t0Ef/YRLSTnn0CXDE7x3p
	 HVDSwpRBBPtY/H9vCTMTx9gBCh0z1RwoPAO9KE57b0kWkN3e9qbBbGTmvtEYwVfd4l
	 hGVMTCc+WDAFy49zF+xF23fcbBDR4O3tbHtnvPcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Wei Wang <wei.w.wang@hotmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0181/2077] iommu/amd: Fix a stale comment about which legacy mode is user visible
Date: Tue, 21 Jul 2026 16:57:34 +0200
Message-ID: <20260721152556.952197332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index f9f71808789303..c726d115939a6b 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -948,12 +948,13 @@ static inline int get_hpet_devid(int id)
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



