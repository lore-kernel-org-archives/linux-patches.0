Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594365;
	b=YAuJHkX8C78VjDWnfFjKO1D6lyphBLWG03xVu/feB4/6foEfOk8i7o/hNc10qXrpw6JZ
	 tFB5mfsm8SabKIvIAkru2zLRhtRjCVWBcxzoSaJpkkEkzqP9/aiJkh7xDZ9xNQgh5m9QD
	 rDo1F2UaFWa9fIUSOe0eKynLPiKXp4mnRjiUSSxZTXQyBznaihlb02KyhMCJjkZAiVnys
	 DPBg5VHRfZSnFq9LRwyKipaPJa+cuO5qxWPjp7TmfucfbCwHv0/DzhVK9KMd8q9nwtA4i
	 6VDW1Hqqnt5Mg+73KEki+vaIcjyZM9ML2lWw5thpYE/f07gM8R0D6UodtbVxTfpwGmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=TmvUw2ZVyUsMcdadsKZcjzgp0p8e0wTBduKxTgJF7d0=;
	b=GBYwoWXWql9VLkpeFerElFu6pPd38uvQv3YrY/+uX86XWzK9t4nRsFDrhbLGpmwLREeh
	 3LfziQerIsMwRwwW1I6tT7UxNEFuxibvqWg4ltKgM6VVL+ww6HFaF4uoIA4JY8S9TQ1sZ
	 KtS8/sAZ8tZ5J0G4D39403D66SlB9ezOWDWUSVTLGHv8NwnuGFGk47LEgfmoE6YLXEAbF
	 Y6ZNo8V/UyVoav2I1jMT89/SIdfOFXMWv4oBTYSs8dPCqSMOXBSHnvTgQZDnd6cyQEfrV
	 WmvlEz6mCqA7x+5h6ytqfzwcr4TSF8luiAAS7vVvwLRdNkyfkM/tmBZqfXUkOH/rqUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IkxZN628;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD5B606A697;
	Wed, 25 Nov 2026 08:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IkxZN628
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03801F000E0;
	Wed, 25 Nov 2026 08:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594364;
	bh=TmvUw2ZVyUsMcdadsKZcjzgp0p8e0wTBduKxTgJF7d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IkxZN628ybcwca27neAchYKstENCxE13/+I3sQX7CHsiLoIElvpghqepsqlyibvoZ
	 TxPy5kjwQm1NKtR6p7LBfFUngIeEUgpX9GjHTw+HfAgvmV0tS0K90FANFuaIiyMkqN
	 rx9mfGWppMk8SBXGSfKU16IozmCo3UTWhLIERDH4bK3nAICDZMuZdu8J20LLGk84nW
	 XueCuTu90UYX2y5xooui1EXJaCJAnkLnT+//AAEAb+HMUuhHe6Qdi76hcEreKGsrWG
	 2GqCt4iGFcLFaeKSaq22g6DFTiISC2RQW1I3GY3FotZ7H5gwuMl5xH/i1AakkdgzS7
	 G9/iMEoSRRoUQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Lukas Wunner <lukas@wunner.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Steven Price <steven.price@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	kvm@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v10 05/18] virt: coco: tsm: Register the TSM class before device drivers
Date: Wed, 25 Nov 2026 13:41:08 +0530
Message-ID: <20261125081121.379481-6-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261125081121.379481-1-aneesh.kumar@kernel.org>
References: <20261125081121.379481-1-aneesh.kumar@kernel.org>
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

Register the built-in TSM class with subsys_initcall() so it exists
before a platform TSM driver probes, independently of object link order.
CONFIG_TSM is boolean; remove the unused module exit path.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/tsm-core.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index 2fa746d078b3..bf09bb4546de 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -115,13 +115,7 @@ static int __init tsm_init(void)
 {
 	return class_register(&tsm_class);
 }
-module_init(tsm_init)
-
-static void __exit tsm_exit(void)
-{
-	class_unregister(&tsm_class);
-}
-module_exit(tsm_exit)
+subsys_initcall(tsm_init)
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("TEE Security Manager Class Device");
-- 
2.43.0

