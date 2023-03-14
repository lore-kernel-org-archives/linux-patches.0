Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123AA2CA6
	for <patches@lists.linux.dev>; Tue, 14 Mar 2023 22:11:54 +0000 (UTC)
Received: by mail-wm1-f46.google.com with SMTP id bh21-20020a05600c3d1500b003ed1ff06fb0so5756083wmb.3
        for <patches@lists.linux.dev>; Tue, 14 Mar 2023 15:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678831913;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SekFEmAeK9leXCVtEJ/5RiO3jcSsl6NVfTaRrfrZ9J0=;
        b=oPNWwBITue+0q+Gxhr58U1kNBLFxTO1MPp56f9Y+lN6aB40OfQA+HcognUG0yf4pmn
         e2gFvCzgqkNE6DheOGDTX0/va4sOjqSyisTfHD+971zqRBaQclJWHRyep4Ubzuh3yQXD
         PoP/JZglgDGJzPNLExl32duTvYBCrew7Gy6GazTQgjn56B9PfHWeIh2JJ6dNHCx6nStX
         SyYgktXbqCSlyFfVei4/hSS3w2rWnzrT0enOosoLz03a8OsbGSrYqpYavBHJzPR94Xoi
         zC+uHX4ceP0QL57R6SRib0pqx13y0moaj+EMNnhezYvMliREdD7Kc1djkgAfXkvd3NRf
         EGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678831913;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SekFEmAeK9leXCVtEJ/5RiO3jcSsl6NVfTaRrfrZ9J0=;
        b=s+o6w0iv+HwbnmaiPRZ/IMf99X1+m7J7K5hGuk7nyePj6yss0Hu1AhOFlxkYrRVWjX
         u6TVrUnhq/l/ZyIV+oIt1MhQySxVS8nfIUn1pmDNZ0EBf1qAszgxJFtoAObD/DfZliJf
         Vf35nuM+Yulw1xyiTQ26IhStvmqRWtpi5fs0iMzoQGcc2f74ePQjwl8wBUAL6xek/crN
         gu+uiBs4/zjy3tjrkgbYItfWoxD1g2RcCJiOTFWvwEANPzeeRah/eI9s3B06rHCKgp9t
         vYtcQj0u3zeqME8cOT0d1bSvqu2HBpsFOqgAKkebDE1N7DkyVhNdMpjo5jvJiIIk8lIh
         +8rQ==
X-Gm-Message-State: AO0yUKVcFE0LOhSHYBlG884q6gM2DyTDU8nyrJ/29Hbi90cEmfmZpS5x
	y+preCOVRuHdpJ1RqBMgwcU=
X-Google-Smtp-Source: AK7set867EXlhkXXBMVZCE2npmcXP0xJU5GRhkg31e64K452iGc8VYDPMj8kt4wPWuhgptenPGsmDA==
X-Received: by 2002:a05:600c:1c95:b0:3e2:1ef0:f585 with SMTP id k21-20020a05600c1c9500b003e21ef0f585mr16262253wms.2.1678831913150;
        Tue, 14 Mar 2023 15:11:53 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id l8-20020a05600c4f0800b003db01178b62sm4438120wmq.40.2023.03.14.15.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 15:11:52 -0700 (PDT)
Date: Tue, 14 Mar 2023 22:11:51 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/7] mm/slob: remove CONFIG_SLOB
Message-ID: <4e936740-1f1c-4dd2-968b-b781ee2bfc6a@lucifer.local>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-2-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-2-vbabka@suse.cz>

On Fri, Mar 10, 2023 at 11:32:03AM +0100, Vlastimil Babka wrote:
> Remove SLOB from Kconfig and Makefile. Everything under #ifdef
> CONFIG_SLOB, and mm/slob.c is now dead code.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  init/Kconfig               |  2 +-
>  kernel/configs/tiny.config |  1 -
>  mm/Kconfig                 | 22 ----------------------
>  mm/Makefile                |  1 -
>  4 files changed, 1 insertion(+), 25 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index 1fb5f313d18f..72ac3f66bc27 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -973,7 +973,7 @@ config MEMCG
>
>  config MEMCG_KMEM
>  	bool
> -	depends on MEMCG && !SLOB
> +	depends on MEMCG
>  	default y
>
>  config BLK_CGROUP
> diff --git a/kernel/configs/tiny.config b/kernel/configs/tiny.config
> index c2f9c912df1c..144b2bd86b14 100644
> --- a/kernel/configs/tiny.config
> +++ b/kernel/configs/tiny.config
> @@ -7,6 +7,5 @@ CONFIG_KERNEL_XZ=y
>  # CONFIG_KERNEL_LZO is not set
>  # CONFIG_KERNEL_LZ4 is not set
>  # CONFIG_SLAB is not set
> -# CONFIG_SLOB_DEPRECATED is not set
>  CONFIG_SLUB=y
>  CONFIG_SLUB_TINY=y
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 4751031f3f05..669399ab693c 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -238,30 +238,8 @@ config SLUB
>  	   and has enhanced diagnostics. SLUB is the default choice for
>  	   a slab allocator.
>
> -config SLOB_DEPRECATED
> -	depends on EXPERT
> -	bool "SLOB (Simple Allocator - DEPRECATED)"
> -	depends on !PREEMPT_RT
> -	help
> -	   Deprecated and scheduled for removal in a few cycles. SLUB
> -	   recommended as replacement. CONFIG_SLUB_TINY can be considered
> -	   on systems with 16MB or less RAM.
> -
> -	   If you need SLOB to stay, please contact linux-mm@kvack.org and
> -	   people listed in the SLAB ALLOCATOR section of MAINTAINERS file,
> -	   with your use case.
> -
> -	   SLOB replaces the stock allocator with a drastically simpler
> -	   allocator. SLOB is generally more space efficient but
> -	   does not perform as well on large systems.
> -
>  endchoice
>
> -config SLOB
> -	bool
> -	default y
> -	depends on SLOB_DEPRECATED
> -
>  config SLUB_TINY
>  	bool "Configure SLUB for minimal memory footprint"
>  	depends on SLUB && EXPERT
> diff --git a/mm/Makefile b/mm/Makefile
> index 8e105e5b3e29..2d9c1e7f6085 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -81,7 +81,6 @@ obj-$(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP)	+= hugetlb_vmemmap.o
>  obj-$(CONFIG_NUMA) 	+= mempolicy.o
>  obj-$(CONFIG_SPARSEMEM)	+= sparse.o
>  obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
> -obj-$(CONFIG_SLOB) += slob.o
>  obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
>  obj-$(CONFIG_KSM) += ksm.o
>  obj-$(CONFIG_PAGE_POISONING) += page_poison.o
> --
> 2.39.2
>

Looks good to me too,

Acked-by: Lorenzo Stoakes <lstoakes@gmail.com>
