Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594315;
	b=Pgx2BKgU/uLD55Xm6UiQOJZpR3v/c/Wsm1QN61PKB1ShQev8Jha1+igbuIiVTuZSGUy6
	 6eRbMKPCRyXqjP30HVcsKEyI1tKt0tYhSAASn3umGjVhZ6O1Fzc8Ttke1Bwfhfal0kWDQ
	 EPgT6+gG3O8vHu53H2qG7nz20mX0UyDFPjENibsfPglng1WHb48ZhYO+pIsxFdquX63t0
	 cyoZ6REtYnE+NWuVpndAaPdoMuvC1gjoLHH7FanHDW9WdKP50kfuNDnHE0EeFsvrzTRHG
	 SDHT38EaWzszxfjAk3pk/3sbtivuXSb1j2tmx6qb1QBklXkPR7s7IprURJODhBEN9Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ajNwRVkrHKmg+nmQoX/j5cIgs+avtvW7l5600Ntz7FI=;
	b=qCpKH3mkIR89LL4NuM321hg3uAp/XqEUlVENC+/vLETF796X0p9catqHffRzI868vmVv
	 r3yxRgd40gMXAh5tm4ZMM8Ojj6IM4gqjnrsFShbxNLCbDeMoTZccI0psvz2IwSggy1irq
	 krMIGBJM+2scuR4Qb/2rfhVdFIqVdNiJUZqFsVbAm6cX6Si8BVWfmeMRGShzpJ2e//s9D
	 cWV16CNeGlU8L5KfzwQpECNcKZWi667LHGMzg4j13pLOrHy8uqTpME+x4TH26sbbZl7v4
	 pVkxG1g1Y1RkQ3BGkSdDjOgr7bf2NTMvIISwvvgKuHwW7CcaAu6K95fUW8QKeGzNbwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaZKGWdK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFA0606A321;
	Wed, 25 Nov 2026 08:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaZKGWdK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5D01F000C4;
	Wed, 25 Nov 2026 08:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594315;
	bh=ajNwRVkrHKmg+nmQoX/j5cIgs+avtvW7l5600Ntz7FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SaZKGWdKdaRUC5LSiZDy5U1KnjAaYGzK9EvmKbFRQ3Gm05kgEMDjnGXg2P29FoQlP
	 FRQYc1zJxrlxxNDdGXm9pW3D3F24jvrlWheiG0/YP8Pp8sUFO2fFu2jHAwTn3/b2Oh
	 buTsadqaK7qTxq1qNTNZXx2tn96IkDG0j4rAPT/uHzDh79wkpLtNXsLZyQBpU3E+Pc
	 Lj3l3/AAqwgda5I2n2RcIOJoZ8GqZvlILoE6kr9yFfSDEdigXRRau20W4uQwSqEbOI
	 EvzawWsbhijpN92PxfHjrD2HIC5d+l9E2R6qyeQrzkK3QpCgYnfzZzmQQWUIjMh+Zt
	 JxralxzPjRy/Q==
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
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v10 01/18] MAINTAINERS: Update TSM file coverage and repository
Date: Wed, 25 Nov 2026 13:41:04 +0530
Message-ID: <20261125081121.379481-2-aneesh.kumar@kernel.org>
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

Add drivers/virt/coco/tsm-core.c and git repository to the TSM entry.

Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: linux-coco@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3ed1991cac46..a3ee234d79ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28549,11 +28549,13 @@ M:	Jason Gunthorpe <jgg@nvidia.com>
 R:	Lukas Wunner <lukas@wunner.de>
 L:	linux-coco@lists.linux.dev
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tsm/linux.git
 F:	Documentation/ABI/testing/configfs-tsm-report
 F:	Documentation/driver-api/coco/
 F:	Documentation/driver-api/pci/tsm.rst
 F:	drivers/pci/tsm.c
 F:	drivers/virt/coco/guest/
+F:	drivers/virt/coco/tsm-core.c
 F:	include/linux/*tsm*.h
 F:	samples/tsm-mr/
 
-- 
2.43.0

