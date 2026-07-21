Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD9547253F;
	Tue, 21 Jul 2026 20:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665673; cv=none; b=sn7YeESnuhaYeE22zmhL5RF/sWYIu2pZH6Fg/RovF0fMOo2lLr8XJEXjUIrDOhJdDTbPMFBQhM88hSiKnWumn0ng5mGAzKvgGXYZWjB2Vocx2Z0bDTeSVytu1E0EZd0UBJD6jZC1XC4m7sFfDXgY1n5cCs1m6mmpZ+1VrdwaHeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665673; c=relaxed/simple;
	bh=UALnmIm22UCECqS1om8YyhoaK4rYagQed4BLL8dSv0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgLJIperc2nAABj/YTVkYeXx8cShgaOY/fvK8MIIEPyeKBiH7DtWGvTLBW6Qb4ZyGVdE+5KtPlBQK6FCIws5A2Mt7J9LMwB98fAxkcvNtx04hGQTDgpcMfoHSezF0MfRLqfiPyAtDZnRFxLx0pGzjhX6Sj5f90VxffetTSjt34E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tlwj6Fyv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tlwj6Fyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796CC1F000E9;
	Tue, 21 Jul 2026 20:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665671;
	bh=15UrIJl3btCXyO6WfqNLF+FSJiPOjSwbnG2sRNS62iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tlwj6Fyv7/2sEQeQH+GpYvdjZvwjcB75aH9wAqwRUP6T63DKcwdmg7heUW7lE/KBj
	 SHV3ZsaVUQvgAYiHQ9cwqC6AIOD2LEtaBf95qOxBUxd+YhUwGe1HeAf1pjX2uUw/At
	 KNn73KYkyRe7DZsph8xR0fuMsX5vBKG/hsn7zz7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Wei Wang <wei.w.wang@hotmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0392/1266] iommu/amd: Fix a stale comment about which legacy mode is user visible
Date: Tue, 21 Jul 2026 17:13:49 +0200
Message-ID: <20260721152450.598623214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2571a782b7b61d..d81defd49949ce 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -926,12 +926,13 @@ static inline int get_hpet_devid(int id)
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



