Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DAB3368B8;
	Tue, 21 Jul 2026 17:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655764; cv=none; b=oKoKoDWEvCkHdqeL3kbyffPyCF5GPJnpmDfE+cSshd7JG8ueiiokp4FK/1Qu6CbNJsXo/2cVXNgkVX+KN2fRUVfny5nl15/vXEGewc9OD3xUPR1ts12ATSqZ+KVOSMjCGpEO546wnfmf9ssWxab6BWTPFay8VjIPG0m4RkhhYRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655764; c=relaxed/simple;
	bh=GxRpOu/U3+cpoxAHXj9x55NVh1KDhLij4KMX25rfqMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mb/5FOSoeUfG95wJ2gHCzJ5a+fb+uPfnnq9Fhthca5KAHx73h45qXrfWwa3eMSXZcBdtF5nognfwXtVWQZvVrOFwIkXijJSGa6F1SitBl7NsBL0xq8CZBmPdY62fUFGc52RiMknBPDfOJqIrspy5M2kkknNvc986htIEQvfUE2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0H2OklT6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0H2OklT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637281F000E9;
	Tue, 21 Jul 2026 17:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655762;
	bh=j+cqJg7EKig6KoL+x0XInUx7TDetEcgATvOalJ+W2mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0H2OklT6VRm5ycx14+qAqvRNKVb5/uu4t+YwXuZPohUBeE8HxysMkJDnNrDfM/1hc
	 pgFTRwUhDld31QFFIaoOXvTQBb4RRC2XFrQeRDJ7ZTKBMdNw9docR4v2Yyc3zQ2dVQ
	 i+iNAxdWSu9eKEJzHYXzbCQIAq3oexgHk3SC65+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Wei Wang <wei.w.wang@hotmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0131/1611] iommu/amd: Fix a stale comment about which legacy mode is user visible
Date: Tue, 21 Jul 2026 17:04:07 +0200
Message-ID: <20260721152517.819537311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2494b1958117b2..dee077bd149b79 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -987,12 +987,13 @@ static inline int get_hpet_devid(int id)
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



