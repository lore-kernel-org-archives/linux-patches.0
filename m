Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030605;
	b=oguS0+lMAxQXXUEFejeZ9vCismMmgS/bVbys6Vs8kab/JRCczVJ+7b4rBPPekeMNpXtK
	 VT5leFPYr34TSWMaMk9R8CPZrDzV1OoWiqjDZy6/8l9bCZL6He4DuytzBY/dzpOE0xiTF
	 F0nUsM2azMHCXlvL8eAxyWk+sr/TGBnWEcQzJrg/kDrRFQe3vLS7HRQe4lCL/ti+0EzmU
	 ZiufEDQF4kHoKi4OCDxSk2D80ceA9bZSnRUA3wv7T7jTk1yIajCxdjJdduPD/cAbTXSw1
	 onGnylAnpkT5OskgFS9Q9ayCQ5yw8UMXJZ0NaTtdTvIJ0PbF0pjoT1/77UB95A2dnYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qDCOj0dnE5X4Q1M16i0yJjlWMeO2b0sAhPWNIy1odvs=;
	b=j/tNRXcNk2axoQyjCau4S/nIpRlchIsucdK/oFt7CbzWi3v+EqEKCP0cGpbj0aPARCyy
	 IF+VNx4I4xMJqsZl1U0vm5I8G+Z4GlywLLeOERXqzSaA4Z/KCPsw+j3xtJJyJ+NV1zw8p
	 /+/ohfM/tzKf+/uT0ug4g440HiBrAz2PVqrkSSX8CQk9Y47Ln13zUJZ4wMz83+6nLX+27
	 2Fj5xowlah7aiGgYgvyr2OO6aUgQt4BVlk2XH/v0+hRgyW8s5C4MifJ5kTgbqQHT6QvYD
	 vFjzJSevE+2m0OX/eYmHXdUNaZNsbrHotyr/m59E/Y7sPsQ5WnN6w5H9N5zi9q7sA3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVVhnCMs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E91F6073D6C;
	Wed, 18 Nov 2026 19:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVVhnCMs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D831F000C5;
	Wed, 18 Nov 2026 19:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030604;
	bh=qDCOj0dnE5X4Q1M16i0yJjlWMeO2b0sAhPWNIy1odvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVVhnCMs4fkSZF9AJ4lU/phjKGoXAgr2Z6Ad4HKDeARlwUmfwdQXj9lIaCT4IXmO2
	 wtFf5Zv6eVWP5D4t1Hb97/o8OtMv0UhWXDvmx6hQdHQFz5TQK/zqB6CW7SWMGI2UQH
	 vxSvz0DDQYIIdaAKAaRmRRMX+O/5tRLNFoY1befA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0764/1756] iommu/arm-smmu-v3-test: Fix arm_smmu_v3_test_debug_print_used_bits()
Date: Wed, 18 Nov 2026 15:48:11 +0100
Message-ID: <20261118150040.045545643@linuxfoundation.org>
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

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit ce58940ccc3d1a377d238d93666c140405f8ce05 ]

arm_smmu_v3_test_debug_print_used_bits() hardcodes arm_smmu_get_ste_used()
instead of using the provided writer->ops->get_used() callback.
This caused Context Descriptors to be incorrectly parsed as STEs.

Fixes: 56e1a4cc2588 ("iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry")
Reported-by: Sashiko <>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 84baa021370a8..2c0e3b5806b9c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -97,8 +97,8 @@ arm_smmu_v3_test_debug_print_used_bits(struct arm_smmu_entry_writer *writer,
 {
 	__le64 used_bits[NUM_ENTRY_QWORDS] = {};
 
-	arm_smmu_get_ste_used(ste, used_bits);
-	pr_debug("STE used bits: ");
+	writer->ops->get_used(ste, used_bits);
+	pr_debug("Entry used bits: ");
 	print_hex_dump_debug("    ", DUMP_PREFIX_NONE, 16, 8, used_bits,
 			     sizeof(used_bits), false);
 }
-- 
2.53.0



