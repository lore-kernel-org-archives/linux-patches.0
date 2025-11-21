Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E5C2EA177
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 07:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763711437; cv=none; b=Nr7xTJvPZyKV5xA2sa5txk+1zQRaBMvoxdvbcu/l25CTAiO5ELJ/Hza8FKPpzhpPDeqee9jMdyQ4mQJAALmWLz7RTs8q2l0Sw/Uaz8R6fCS5BT/HsPRv1Eugw/EtnPfJt33/KeYyWt4G71m/Wt7u3ppV14kB794mG2vN6rznu1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763711437; c=relaxed/simple;
	bh=kf1ywlgXwuyZYoLtkUBApZiCaBrnG4svPWkptu+49ao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eq7B6sayNoCq4W1HSs6XLkt4bch4U4zElDldcuUBJY1olUqPyIYfkGK+pbVplkkOR12y8vF0bwEbLWavrT8hh7KPtMMJldiMe01EyhxOpcoE4vEgU3Ks58UsqIaf4uI69Edzk5q4AoGKLf/e72tlzfXw+VWcssy7+8XKucojNCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4dCRjQ02bPz9sTD;
	Fri, 21 Nov 2025 08:31:22 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K0Q8cCQU7afe; Fri, 21 Nov 2025 08:31:21 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4dCRjP6KhSz9sT8;
	Fri, 21 Nov 2025 08:31:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id C1E158B76D;
	Fri, 21 Nov 2025 08:31:21 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id LTFf_Pnq6OKk; Fri, 21 Nov 2025 08:31:21 +0100 (CET)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 2E1458B763;
	Fri, 21 Nov 2025 08:31:21 +0100 (CET)
Message-ID: <93bd6b07-5088-4af2-89af-7f0ae726dcd2@csgroup.eu>
Date: Fri, 21 Nov 2025 08:31:20 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] powerpc/pseries/svm: Make mem_encrypt.h self contained
To: Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joerg.roedel@amd.com>,
 linuxppc-dev@lists.ozlabs.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Kevin Tian <kevin.tian@intel.com>, kernel test robot <lkp@intel.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Vasant Hegde <vasant.hegde@amd.com>
References: <0-v1-672b61acd916+1449-ppc_mem_encrypt_jgg@nvidia.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <0-v1-672b61acd916+1449-ppc_mem_encrypt_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 20/11/2025 à 16:06, Jason Gunthorpe a écrit :
> Add the missing forward declarations and includes so it does not have
> implicit dependencies. mem_encrypt.h is a public header imported by
> drivers. Users should not have to guess what include files are needed.
> 
> Resolves a kbuild splat:
> 
>     In file included from drivers/iommu/generic_pt/fmt/iommu_amdv1.c:15:
>     In file included from drivers/iommu/generic_pt/fmt/iommu_template.h:36:
>     In file included from drivers/iommu/generic_pt/fmt/amdv1.h:23:
>     In file included from include/linux/mem_encrypt.h:17:
>>> arch/powerpc/include/asm/mem_encrypt.h:13:49: warning: declaration of 'struct device' will not be visible outside of this function [-Wvisibility]
>        13 | static inline bool force_dma_unencrypted(struct device *dev)
> 
> Fixes: 879ced2bab1b ("iommupt: Add the AMD IOMMU v1 page table format")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202511161358.rS5pSb3U-lkp@intel.com/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>

> ---
>   arch/powerpc/include/asm/mem_encrypt.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> Joerg, can you pick this up too please?
> 
> diff --git a/arch/powerpc/include/asm/mem_encrypt.h b/arch/powerpc/include/asm/mem_encrypt.h
> index 2f26b8fc8d297c..e355ca46fad933 100644
> --- a/arch/powerpc/include/asm/mem_encrypt.h
> +++ b/arch/powerpc/include/asm/mem_encrypt.h
> @@ -9,6 +9,9 @@
>   #define _ASM_POWERPC_MEM_ENCRYPT_H
>   
>   #include <asm/svm.h>
> +#include <linux/types.h>
> +
> +struct device;
>   
>   static inline bool force_dma_unencrypted(struct device *dev)
>   {
> 
> base-commit: 7e06063a43d317c1ca9278b6662555f687f43f03

