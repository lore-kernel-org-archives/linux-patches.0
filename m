Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025158;
	b=06giJkAjqktAu3DJJ3iuiPwTq9AGGI2LuOLvsvQlKVTTcKDTaAMlbs4z+UIZ7nMfToEy
	 xhM0kUShFE3FTAOZGsvUXDt1cBvCxjpT8mFjIHHCu/FR4CbfPkuUS9mR40Sfv4iM6MLCN
	 gZVDnXugw1T6dnB/6hBNHmrg42WvcyH1oDCfWsLJf79y9uFmgE0fcqLxvJEa/uOqYpzdq
	 isMDMQK2Db1UcZ4t1XkrB8cdhnCWDBL4MSSP6SHKhzoXN+NZtlcJAyPdJR9Kr+jaPArYr
	 BmOvwiAMsnGZi3dx1gQUxY83fKXOonLmcQei6kNI/7cmkXKuW8l4yX7Eeoi/xBrqRAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=76SpgyXAkRxzZiP1QVDOqwU0/8D283bh7laaOGJUMSE=;
	b=WII/rOmtiGJAG0TpQbQx8ypyHZ6wic46O/YoyPG9VX2JXmlVqD3PPdNSOnfDPEo/3b8m
	 /i+wR1tNNHcT1HxuMTfMiEh/4DNPQRo5B3Zn0kzpxnmP7xwjU9K+oblSNZpHVfYVHJKgB
	 RNvICSBJFSztKNUz4Tp92HtQn8kjO1MC0+qeTdsCEJ1xorbK75fNMSjmDxXmuLYWQpVc+
	 MNQRPv9wVkSD/mdq1gEZq3BwmVPssccARZPRSr9AXRtLfNmTTscDvrcDJgtTNipkoPLer
	 ACr4oVa/iOzsqf6zUoxETxG6Djh5WvLoV2aQabeulFqNPMxGBNOte60/g2XO7wStusQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dXHMgQ09;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062A1606A31C;
	Wed, 18 Nov 2026 18:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dXHMgQ09
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607C71F000C4;
	Wed, 18 Nov 2026 18:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025157;
	bh=76SpgyXAkRxzZiP1QVDOqwU0/8D283bh7laaOGJUMSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dXHMgQ09CB/4vGfrDM/rxwRx+sMJ+DOAxo0VDGIkErL9xN4WiRSSLzJw7OklmfnOT
	 icA9fTGnHREkCzGfWuk7zhpt7ZYnWGBbkYkU6eyzx/wQ+rCbb96ZwVtd+rwfijkhTl
	 BpgLAXpMzdiU690aHz7H3j0FitGpxymhlscq1GIw=
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
Subject: [PATCH 6.18 0973/2151] iommu/arm-smmu-v3-test: Fix arm_smmu_v3_test_debug_print_used_bits()
Date: Wed, 18 Nov 2026 15:45:08 +0100
Message-ID: <20261118150157.944777252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b254a94b2003d..d77064605e04a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -121,8 +121,8 @@ arm_smmu_v3_test_debug_print_used_bits(struct arm_smmu_entry_writer *writer,
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



