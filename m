Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018333;
	b=PPjOJhU5p6mE8EFsHjzJq9L7DMlGJqoG1PxWhXxCU+JXecW8FXXj3X+OrSECxZvtgIEU
	 hjcB3aJk//+cRdJ797nj7vL1w4ml28tu79JILKnv+gX+LZ0eMAICevWDP98VQ8FXcbesd
	 0fM4tQobMquxRdm/tmIcnUsUAQ+Ul1N10qRJ31aa8JqPshPL6OqKAKw5UpoPcQMzEuQbN
	 7EezCpfwG5FaRQZhn2ANWYswlBTItdIRCCSYUwBS2X2nuC6u/hktwBJXJTKOqjX9A8rfo
	 hFU4/vY90JT3AJRSJA6Jf8pco5htfBzcCc4V6C4KcomfavZdcSwBjAPszhOmaT9hrOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2BPoy0T4PRKO8vrKpfmq6bofFe70RWEnyHHl09jqNd8=;
	b=2NWJcKSCkEYfjx1goytQe6kQNxQsSb8zT8y6H48KnTRiKUvKsVu3leMqwNbpwuWxgHur
	 jtLMiLVHd69R21egLHDGM45+brUzp3aP9g0tBI6iiB6iFXFbu2exKgTUkOFG819R/qNsY
	 VcQWKq4ERl/7TZpqbYpIcOtL0u6t/BEd42TMOLcaMo4ZpgaZkRJte2ii/8YuR1oH6jHiv
	 VDi+doqY93qvAuFah0UluwC4jrte80pLHue85IUs4jmpQUuDj6I8bdxlf6LtqRQvKxL29
	 Q7Ju/lJ+d14JcPxjnqYuK5u1Qq2oqgp7qS9H89X6j9p6zpD++IURS6vMk/n/YwYln0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJAAMirO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3888A606A320;
	Wed, 18 Nov 2026 16:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJAAMirO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF1A1F000C4;
	Wed, 18 Nov 2026 16:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018332;
	bh=2BPoy0T4PRKO8vrKpfmq6bofFe70RWEnyHHl09jqNd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJAAMirOGyOquXzMQ4gMobzoM2zMXMop2+UQswf0gZYSm0WHsZkYgey5MA5SMus7b
	 V6OpZj7eaAKEY/Di5Uq9oOJZGCoisWqjPa5SVuqHTzlqXwbwwT9CpAPPKSf25STF53
	 DQaDbhVAWHwtLdmsdQcmHZsQgU2Bo/3ZmcHb7p/A=
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
Subject: [PATCH 7.3 1176/2651] iommu/arm-smmu-v3-test: Fix OOB in arm_smmu_v3_invs_test_verify()
Date: Wed, 18 Nov 2026 15:40:16 +0100
Message-ID: <20261118150330.348275371@linuxfoundation.org>
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

[ Upstream commit 8105675f33746cce48f5381d02d0356ef79dca89 ]

arm_smmu_v3_invs_test_verify() validates the array bounds using
KUNIT_EXPECT_EQ(), which triggers a failure and continues execution.
If invs->num_invs was smaller than expected, the next loop over
num_invs would blindly read past the end of the invs->inv[] array.
Switch to KUNIT_ASSERT_EQ() to fail and stop the test on bound errors.

Fixes: 15a2a5645ad7 ("iommu/arm-smmu-v3: Introduce a per-domain arm_smmu_invs array")
Reported-by: Sashiko <>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 366dcb2b55548..244cf34e5a0b8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -643,7 +643,7 @@ static void arm_smmu_v3_invs_test_verify(struct kunit *test,
 					 const int *ids, const int *users,
 					 const int *ssids)
 {
-	KUNIT_EXPECT_EQ(test, invs->num_invs, num_invs);
+	KUNIT_ASSERT_EQ(test, invs->num_invs, num_invs);
 	KUNIT_EXPECT_EQ(test, invs->num_trashes, num_trashes);
 	while (num_invs--) {
 		KUNIT_EXPECT_EQ(test, invs->inv[num_invs].id, ids[num_invs]);
-- 
2.53.0



