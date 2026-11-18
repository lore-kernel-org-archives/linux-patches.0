Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018271;
	b=fJTIBOJ9PX2872YIiAlae/TnUnURiWpRoWzyM/9VoWbdsd3roIJulwXpijZJc/lqRLC9
	 Eg+SJrJX4yQ05FUzDUdY64NPAAHlW6roY0L5MrHSP2u+jB5FDvn5GzxT7b9SX8AnH3jtM
	 XMn3u6yCGz8/7NtrwGc6mnVrK9498raHIQhmSy6Gr6KtlwBA0bFz2A+8yHtPE8+YSfdT2
	 bK3I7LJPYx3sqiiOxZLq/Ioj9qEuteihGq2AmU2uXMEFrj2tJUcorvjomhm+8ZWzGwtM2
	 CdgK87EMsldjMrJnbh+005G3GXAaiZWN2EFgBsZs0hOExpiUvtH+XPzeXEKaGLPG/ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B4TIAX1K00b+1pzjxa499pT7YbfPW0I3P94UwMCCgXY=;
	b=s64/05d2qbdJB+Un1BgZO21HkIOZ4pS/FsQgI2kOqjt+zlVIvvgCafWc+Yji95LA5b6m
	 2141EXV/qYXuEgAaK/Xs8hNN0wX8cSc1zw6b0s6FYzX1AKsgN+1AhieUuhCld6namozla
	 dNcmPIEIijoozvALvvOtulKW8OQPkjm8gjCbJB5oB0ukZs2J2lCWSMfSs/18OTnDIPuyl
	 CFDxHRu28pgHkdNITnxaMmYt6uvNs09oKi1uLLJ31xFi/RlvHXT2JNLncHGTjMBJIjuFL
	 QM86j5RvuxJkGeVInCJMXD7NkiLY2xLNX2MSdQz8HiSoMm9FZqO0z6O6IfuoNB2MvXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lR8vvTMM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998FF606A325;
	Wed, 18 Nov 2026 16:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lR8vvTMM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BEC1F000C4;
	Wed, 18 Nov 2026 16:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018271;
	bh=B4TIAX1K00b+1pzjxa499pT7YbfPW0I3P94UwMCCgXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lR8vvTMMpm0CfuIcsDqq4TtwwaoSoHdSYYEMFp4EUDcoiV7gArQ2gfbZtDliBWaWl
	 +guOxmncZY9ZFwjYlKNIVMUOIwwOqKyZOEqJOf895qTAw4rARFw1vyRVE/0GpBGbk+
	 OroVC/R9okYaiD+3ABqrh2/+VyL8bMA0d8C864j0=
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
Subject: [PATCH 7.3 1174/2651] iommu/arm-smmu-v3-test: Fix arm_smmu_v3_test_debug_print_used_bits()
Date: Wed, 18 Nov 2026 15:40:14 +0100
Message-ID: <20261118150330.274505789@linuxfoundation.org>
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
index add671363c828..eae08d4d77ec2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -125,8 +125,8 @@ arm_smmu_v3_test_debug_print_used_bits(struct arm_smmu_entry_writer *writer,
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



