Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795498012;
	b=pPthI92b3qzluXXGIdoSfYxJRm5UqJs7zTr+lY6b6xZUuFgT8XxyBBxeY45Kfk1/po2W
	 9IvOJfNiOcCS+76/scjgFmd7LZhr/er3M5isQySgeyXdzv/240m16PosF7jLvaIRMx0sI
	 +/AdPsL8VqQygYdKXexXYaUJvImWaY7lwi3xegZ8p3vI97/HZty9M75BHeFZUoUlvJaxa
	 9pwH7JYA0Xca7ncZ8Uz+TNZayoobBMbFzOmmN3X6uHq8aFuxiZYMTKcs3JoQvECUyyAqZ
	 cna91O3wEvdoP6bG/Q4m88EtJTWWow1OGiyGSrWWdHOYhne3EOQYVepemPO/F3uhi5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795498012;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=6hEHnZ4sfgUflRbEhxUh0CD0ylQZFIJ15GBUvc4I5mw=;
	b=RWu6+8mDD4Imsj342o6Rf1I0UeOPluHc2YYbvZknoYoQBiZT3Sli9WP2Y0yb9oCB4nBy
	 /oy0K1Btz4ajSa7q2aEc1izhQW14bKhxiohi9Gqh2t9pD3vAL75UQvlkVXsrXsSA94Yqx
	 6y22he+J0DbJ974scaC/gGS25UOKW2VwAgPWM4uatmxIsP2jFRVO7kMyRk8ZJx6ZGcrT5
	 dWqtJx2IC7iepb+Tdj0ebE8lVxMqvwU/9emajjLPQh3wI/rYzNy3w5E/ImJqlV+THrbtK
	 MOhDkD1vqEtZaLDTh1fG0dN4LJXaN144oKhaXm7oc71pteB6GJOZ+QADHGakQ1kNa+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bMuZ/82I";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC80606A31E;
	Tue, 24 Nov 2026 05:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bMuZ/82I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0C21F000C4;
	Tue, 24 Nov 2026 05:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795498011;
	bh=6hEHnZ4sfgUflRbEhxUh0CD0ylQZFIJ15GBUvc4I5mw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=bMuZ/82I+vs+8NKsF31D7nQhBoDtC/vh+MdJDEQFc6RfLu9u4tc1iXSnh9tQUIt1R
	 7B4aBvaDLvXRLuiTN1J7kRllSEWDL5FAyMso3WrOUo3yd+gxajeQWfNT+SPnw1JR85
	 nBowKBVgT76oli9zpQaDZRhbQAs8+j2FbwhIxOTktb7YTs9tvpPqUQff1wyBXBTqZX
	 UWpTbmZiOBunZB6QKAj5MxB+n26rmgEzueQlO0KVhXTYiGVNLPvsfiB8Qz9ab3ckww
	 3NiPz4iKGto4wg14EG/cvFr3KsGIznEulrKB1dyBb+9p9Y/pw05d9hw5P8rcLwFQCN
	 Ocw7AG9iUNzXQ==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>, linux-coco@lists.linux.dev
Cc: Alex Williamson <alex@shazbot.org>,
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
	iommu@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v9 00/13] iommufd: TSM-backed virtual IOMMUs for
 confidential guests
In-Reply-To: <3573001a-24b8-49f3-97c8-7a414c88deb4@amd.com>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <3573001a-24b8-49f3-97c8-7a414c88deb4@amd.com>
Date: Tue, 24 Nov 2026 10:56:40 +0530
Message-ID: <yq5ah5h6by0f.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Alexey Kardashevskiy <aik@amd.com> writes:

> On 16/11/26 19:19, Aneesh Kumar K.V (Arm) wrote:
>> This series adds IOMMUFD and PCI/TSM infrastructure for assigning PCI
>> devices to confidential guests. A TEE Security Manager (TSM) can provide a
>> virtual IOMMU (vIOMMU), and an IOMMUFD vDEVICE object represents a physical
>> device within that virtual IOMMU.
>> 
>> The series adds a common framework for operations on vDEVICE objects and
>> updates lifetime management to keep the VM and device-security resources
>> available while those objects are in use.
>> 
>> The Arm CCA backend is provided in a separate series, together with
>> operations for TEE Device Interface Security Protocol (TDISP) state changes
>> and access to cached device-attestation objects.
>> 
>> The full series, including the Arm CCA backend, is available at:
>
> nah, it is not :(
>
>> 
>>    https://git.gitlab.arm.com/linux-arm/linux-cca.git cca/topics/7.4/tdisp-host-rc3


Can you use https://git.gitlab.arm.com/linux-arm/linux-cca.git cca/topics/7.4/cca-da-integration-v1


>> 
>> Notes:
>> * Codex was used to assist with commit message formatting and code
>>    rearrangement.
>> 

 [ ... 148 lines skipped ... ] 

>>   include/linux/tsm.h                           |  41 +-
>>   include/uapi/linux/iommufd.h                  |  36 +-
>>   25 files changed, 880 insertions(+), 462 deletions(-)
>> 
>> 
>> base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
>
> This is v7.4-rc3.
>
>> prerequisite-patch-id: 121492d71cc22b2adbfdedd668868c5a449ad764
>> prerequisite-patch-id: ed31fd728f0adba3d60dcd6f3bae8da1a2193bcc
>
> What are these two? Cannot find them any tree... I really want try this all but also trying to eliminate guessing...
>

Those prerequisite patches are from this series:

https://lore.kernel.org/all/20261116075420.76205-1-aneesh.kumar@kernel.org

-aneesh
