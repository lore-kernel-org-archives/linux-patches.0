Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F2527E077
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 09:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759310899; cv=none; b=A4Z3Hr3XUhqA9ckilZj54vKTnKT+rHt7BntTQplenaOikmVwPFnaSS/qQxyOZ2ceYWNzBUaOMowxUO5vQETDcSe6XeytXqfBlNsChZLChlTmY01COcwXEH2MnCY2EYcfm4z/31TeTdG6oNdcq9SbIqkbxnbqRn4EhIb855uu+Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759310899; c=relaxed/simple;
	bh=u8Q/puU00m1+Ma30hn2PbTN/YeCwD3+SnWOZqn5KRRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KoLhmj4dTDZC4Gg4oDXO85QAX3wI42vvzscn4T+iGtYL+cHviLTpMA4VV7tFsBrcUQPrM2qhgQKTL77DUwCog9WhXrnlX+aCVoR3IiSAKPliS6if2LyUpq8AzInVH/wa9PLKEV3JayNExhDjcx0rVOV/5ItoIhNm3GgoAhwSjOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BHKMtLub; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BHKMtLub"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759310896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ybtVMUpvDW3U/F2Zx0MRGWKL6mjqpdZhKS9ovQqZCJg=;
	b=BHKMtLubZVnUb3kgB8l8GqsQOgsRsfJQJORgdf1eigTzkrvrcMBtWwXXK7JK45Gcw8Q6aR
	DLMdlexDdwY70oyFUA059g04mpYC6ew0fNiD55sKAkoeE0Gy1K+I4VXBrY3sVzbjTOJMQC
	i+NHFO2+xR92ZRiQRCz9b0OuIXQrQnk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-S2blvNPRNLO4nkWQJ8PwgA-1; Wed, 01 Oct 2025 05:28:15 -0400
X-MC-Unique: S2blvNPRNLO4nkWQJ8PwgA-1
X-Mimecast-MFC-AGG-ID: S2blvNPRNLO4nkWQJ8PwgA_1759310894
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3fba0d9eb87so3742020f8f.0
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 02:28:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759310894; x=1759915694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ybtVMUpvDW3U/F2Zx0MRGWKL6mjqpdZhKS9ovQqZCJg=;
        b=tl/ZSlUti3DmwSh1gQ2p7X872jQYlqoGK9NV2JzscqUR39kqMsn4CtKPwlXAZ9SVyu
         VpEdrkzv+qT+jzQe9NDYElNPvwN8q/boCaMd99DnpC/vzx8pELK2JIHTzIS6l+W5qbCh
         vp6bR0JdalWgtU7zH3eN4Lksnnsqgbc52+Z8XzPDVLrpBW3k4PalkqYi4B16K3dADCtK
         hHpwlv+Qzuy4TV5uAyLvyaipChMJhfCbX6zGy67FtbHbImmt2uigQSY2yaT4eyi1TWSA
         Ve/LFUCCWA7wMDzIBwm/oDzref5sEAI6ex5fCrOwd0QnpOvS4/a4JSx0jt0pZHQJdFqt
         Q61A==
X-Forwarded-Encrypted: i=1; AJvYcCWEctkjsb6Qmr25b0yCnuATTIyBN3vwVDU8PDpKUMZEW0qRFoPpty+/JrgVu0WeYeevfQGN3RDQ@lists.linux.dev
X-Gm-Message-State: AOJu0YyRkDAM+zarKKuCiSNaJsUi7HAWXNC+lzfXMvpzSBd1gZbF9yt1
	7WHbdIb9GPwWpR/JvQKODvZ29/vA6XtCpmSoajG90BKBfBHbxHxXRBA16gnt0xa68MiP9pE7Avk
	DSuzFUqtktNpRkNDCGI34yEDWpnbKQCq9DASWgz9+zJHNsOnHlsD/emMdbZY=
X-Gm-Gg: ASbGncvTnWJjFaSyLLtxqWN/k5nvMsIlsz/Lee9gZW+FFJ+rB24TKZ3azxq5rhWyhZQ
	qjemTKpInT7VNKYAbJSqVYU0SAdeaPAMrgF0yRfdhvnczjonpS//XzW8CMmSmhhJH5umOSRKhlt
	0+VOSdP6/QVFZGQoWr80882j20GIi1KmOePDi1bwXHr6luQb0ZZ+B6KvIwXfmLRxk/4B5Xev/fL
	6fuZZvKCOkZNCXTrjH/tqXwRf//LFvutyS9F8SOaoyfcdLomE16SlV23YdX0mGHDgnRqHcdYJvF
	jUHCN/XgQVatggtVD3D46eQ22VDqd1BdHM1mrIA4tit9kmT+yh5S6E7Fu8TEQHFm9RRB5ausV3O
	ZGhwboT5pDwUEqMc3qg==
X-Received: by 2002:a5d:588a:0:b0:3ec:248f:f86a with SMTP id ffacd0b85a97d-425578183aamr2084048f8f.48.1759310893660;
        Wed, 01 Oct 2025 02:28:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2jGX49TGzAee2RWy6ApUBj/jwFn2OVqWsFJymuz8OiVF8ehgSB3/azRECWeXusX/4XaZBCg==
X-Received: by 2002:a5d:588a:0:b0:3ec:248f:f86a with SMTP id ffacd0b85a97d-425578183aamr2084020f8f.48.1759310893212;
        Wed, 01 Oct 2025 02:28:13 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fac4a5e41sm28042341f8f.0.2025.10.01.02.28.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 02:28:12 -0700 (PDT)
Message-ID: <651ee9fe-706e-4471-a71b-e7a12b42cc3e@redhat.com>
Date: Wed, 1 Oct 2025 11:28:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V6] net/mlx5: Improve write-combining test
 reliability for ARM64 Grace CPUs
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Michael Guralnik <michaelgur@nvidia.com>,
 Moshe Shemesh <moshe@nvidia.com>, Will Deacon <will@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Justin Stitt <justinstitt@google.com>,
 linux-s390@vger.kernel.org, llvm@lists.linux.dev,
 Ingo Molnar <mingo@redhat.com>, Bill Wendling <morbo@google.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 Salil Mehta <salil.mehta@huawei.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
 Yisen Zhuang <yisen.zhuang@huawei.com>, Arnd Bergmann <arnd@arndb.de>,
 Leon Romanovsky <leonro@mellanox.com>, linux-arch@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
 Michael Guralnik <michaelgur@mellanox.com>, patches@lists.linux.dev,
 Niklas Schnelle <schnelle@linux.ibm.com>, Jijie Shao <shaojijie@huawei.com>,
 Simon Horman <horms@kernel.org>, Patrisious Haddad <phaddad@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Eric Dumazet <edumazet@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Jakub Kicinski <kuba@kernel.org>,
 "David S. Miller" <davem@davemloft.net>
References: <1759093688-841357-1-git-send-email-tariqt@nvidia.com>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <1759093688-841357-1-git-send-email-tariqt@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YBN5BlIW8QkXtX173hOqjDtjn1GJ0MS-4iBLLkmoJIk_1759310894
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 9/28/25 11:08 PM, Tariq Toukan wrote:
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wc.c b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
> index 999d6216648a..c281153bd411 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/wc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
> @@ -7,6 +7,10 @@
>  #include "mlx5_core.h"
>  #include "wq.h"
>  
> +#if IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && IS_ENABLED(CONFIG_ARM64)
> +#include <asm/neon.h>
> +#endif
> +
>  #define TEST_WC_NUM_WQES 255
>  #define TEST_WC_LOG_CQ_SZ (order_base_2(TEST_WC_NUM_WQES))
>  #define TEST_WC_SQ_LOG_WQ_SZ TEST_WC_LOG_CQ_SZ
> @@ -255,6 +259,27 @@ static void mlx5_wc_destroy_sq(struct mlx5_wc_sq *sq)
>  	mlx5_wq_destroy(&sq->wq_ctrl);
>  }
>  
> +static void mlx5_iowrite64_copy(struct mlx5_wc_sq *sq, __be32 mmio_wqe[16],
> +				size_t mmio_wqe_size, unsigned int offset)
> +{
> +#if IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && IS_ENABLED(CONFIG_ARM64)
> +	if (cpu_has_neon()) {
> +		kernel_neon_begin();
> +		asm volatile
> +		(".arch_extension simd;\n\t"

Here I'm observing build errors with aarch64-linux-gnu-gcc 12.1.1
20220507 (Red Hat Cross 12.1.1-1):

/tmp/cchqHdeI.s: Assembler messages:
/tmp/cchqHdeI.s:746: Error: unknown architectural extension `simd;'

I can't reproduce the error on any recent compiler version via
godbolt.org, so I *think* this should not block/be reverted for the MR,
but could you please have a look soonish?

Thanks,

Paolo

