Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E79453A6
	for <patches@lists.linux.dev>; Mon,  6 Mar 2023 14:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678111370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7YJ33VBWjw2CT0ZZFr8RJg8K/VD7WeNxaY8vu7LGjb0=;
	b=QgX6A6SdtzwVpNdMoIuPuVRFRaUIaFdCudcmqWwcijlIBSgHyhH1ff9zKGROgG8iQvn5Iq
	zRI75CTB931r1RkW4Udwehx7DYk/EBhoOBRJOkeVgesDoNU29uVu4cXCuDl2cqM0tV2jMp
	V4wAcHqGwNX1e1yyk2/XirFyj9iGjfk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-NY5PdWzGPUupD0287wOHPg-1; Mon, 06 Mar 2023 09:02:49 -0500
X-MC-Unique: NY5PdWzGPUupD0287wOHPg-1
Received: by mail-wm1-f71.google.com with SMTP id k36-20020a05600c1ca400b003eac86e4387so6781577wms.8
        for <patches@lists.linux.dev>; Mon, 06 Mar 2023 06:02:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678111368;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7YJ33VBWjw2CT0ZZFr8RJg8K/VD7WeNxaY8vu7LGjb0=;
        b=LLA3D+hgGSFqi1UGw/FOuUgGkIVu9JGCbp70q8Y0b0L6MjxVICYjJXL7YkVSyUBRro
         0HqBT6xVo8s0dgmBNNF8pXrEv4paPBbaA36wWCRQ180bn5UFviR1EXKTdXAM0IjXnbRw
         P+BBMamm7I+9Gk68ltuCS7DqdmUfzcTU6gYRwN5oJhdx7y7Pe6SU0grmo7dv9Xhqruun
         9DoM6tNT7mqGf3PwQqeATJY4Izws8owCF8iNraPyT/+p9jjUkE0ZFHLRDaWdc86356u1
         U0nYef6p9XkvxH4QP/G9rbGwa/N/+O9tKvkqndLxwvvHQnbBZffGxd1u2OwzPHAP7EMs
         Pw2w==
X-Gm-Message-State: AO0yUKVQW8z/JJpm7BNMYUz5Yzvyt5VnM+WShS3siKMWiu5fq+DbFuWo
	jU2D5ndjsi3RGqLqH1k52n880CJYRR4Nv/TGsllNNcAg/+pvIfdhyGbTfgmbzSb0In3FICHNWQE
	kyK4peI96lmevw5WnRQ==
X-Received: by 2002:a05:600c:4509:b0:3eb:399d:ab28 with SMTP id t9-20020a05600c450900b003eb399dab28mr9282562wmo.37.1678111368199;
        Mon, 06 Mar 2023 06:02:48 -0800 (PST)
X-Google-Smtp-Source: AK7set8UsnDqSBjgdWhLZMOVUCI8XxZWntH6OdOcD4b0pMNiP46MgSM5QIbPtcURKpqK/78/66kQ7g==
X-Received: by 2002:a05:600c:4509:b0:3eb:399d:ab28 with SMTP id t9-20020a05600c450900b003eb399dab28mr9282511wmo.37.1678111367826;
        Mon, 06 Mar 2023 06:02:47 -0800 (PST)
Received: from ?IPV6:2003:cb:c704:3500:b8a3:191c:eae:cc05? (p200300cbc7043500b8a3191c0eaecc05.dip0.t-ipconnect.de. [2003:cb:c704:3500:b8a3:191c:eae:cc05])
        by smtp.gmail.com with ESMTPSA id p21-20020a05600c431500b003daf672a616sm10079911wme.22.2023.03.06.06.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 06:02:47 -0800 (PST)
Message-ID: <b8839e28-1189-bb2d-3afe-d21c2d0182c3@redhat.com>
Date: Mon, 6 Mar 2023 15:02:46 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4/6] shmem: skip page split if we're not reclaiming
To: Luis Chamberlain <mcgrof@kernel.org>, hughd@google.com,
 akpm@linux-foundation.org, willy@infradead.org, brauner@kernel.org
Cc: linux-mm@kvack.org, p.raghav@samsung.com, da.gomez@samsung.com,
 a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
 keescook@chromium.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20230302232758.888157-1-mcgrof@kernel.org>
 <20230302232758.888157-5-mcgrof@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230302232758.888157-5-mcgrof@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03.03.23 00:27, Luis Chamberlain wrote:
> In theory when info->flags & VM_LOCKED we should not be getting
> shem_writepage() called so we should be verifying this with a
> WARN_ON_ONCE(). Since we should not be swapping then best to ensure
> we also don't do the folio split earlier too. So just move the check
> early to avoid folio splits in case its a dubious call.
> 
> We also have a similar early bail when !total_swap_pages so just move
> that earlier to avoid the possible folio split in the same situation.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   mm/shmem.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index a5a6da51087e..6006dbb7dbcb 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1352,6 +1352,12 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
>   		goto redirty;
>   	}
>   
> +	if (WARN_ON_ONCE(info->flags & VM_LOCKED))
> +		goto redirty;
> +
> +	if (!total_swap_pages)
> +		goto redirty;
> +
>   	/*
>   	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "always" or
>   	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
> @@ -1367,10 +1373,6 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
>   	}
>   
>   	index = folio->index;
> -	if (info->flags & VM_LOCKED)
> -		goto redirty;
> -	if (!total_swap_pages)
> -		goto redirty;
>   
>   	/*
>   	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

