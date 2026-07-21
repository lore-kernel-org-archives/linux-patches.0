Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C2843C7C8;
	Tue, 21 Jul 2026 22:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671396; cv=none; b=GlJdQFgQW+uFueAnxu2NOW4zeqAsVWfIqcSs5Cx+8hyFXSxqjnaehOsZNvkDsVqwClC86HbLqU/4DoTrKzzetfVC0HVl2KZumSCgByMn+lZIaJM9u6Ib8H3R5pjlkWYMWCnjTdGHm4xXSO83xipQwYSO3uQY6qcC5SlO7Lxo8ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671396; c=relaxed/simple;
	bh=Z4SCCcIWiFdp5y0QWhzGb1lNaL3xdz4p3zIdSYTda4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c44OFjN/i3FrfWczmnuxoGxi6/4jk/xQC2Zl2QDM0T/jZzOCtKlKZJwQhRf7/fZT+fy6JVTCBnBRaeBiSFCCfDCuCVMSYkKxbamz4IHRHu3wvrz4nc4sviSVyjN0uXwt76zwwnk5jzxQErnOUBU8Py3SAhfazeqc6Rl1zRyi6/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfASTAhP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfASTAhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30091F000E9;
	Tue, 21 Jul 2026 22:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671395;
	bh=j26TeGpBVakD5JHTiSyMoeWLUF8fzlNBRpvNQ+jE6K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vfASTAhP8yEaQZmiW9DmphXgFjIIHVMtrHLmlf5j6IOsxk0vMxnPW7Fa+biSqZ4Ph
	 HZ9AYSBpg0hJJjDiop91i+Eg4WiKHeXYG6UzbDe4TGLqspgzQai89uETs4z8AcY/Qu
	 QtNfTGI/BJHV5NHbV4YLwr3Oy0Q167GHK2Z5hEIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Wei Wang <wei.w.wang@hotmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/843] iommu/amd: Fix a stale comment about which legacy mode is user visible
Date: Tue, 21 Jul 2026 17:17:46 +0200
Message-ID: <20260721152411.214202488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2dc025acad4ceb..9453d15286acd4 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -841,12 +841,13 @@ static inline int get_hpet_devid(int id)
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



