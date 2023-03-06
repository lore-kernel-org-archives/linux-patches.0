Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF20C53A6
	for <patches@lists.linux.dev>; Mon,  6 Mar 2023 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678111316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nO3R9JigNCHMlqWS1p9K0Fb3M5vUza+J8/tkd1LfBR8=;
	b=VTyFt9HdzZj6cVLH1JdvdmLHvyWriE5Vi3B33kwl8zKMtEDZhS6sLq6nU6f2WbMP6QBnBG
	L5VWNWLMgxrWf2yHYwihYb41rJNdYa5nCxXN7HSOIwVwWAJvLpjpFChlvLVUOecldG6pzv
	8oENyBi381L5vcQv3ZcP1ZFrzbJLlyA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-2bBSxsB6PqaNlzCdX1PMZQ-1; Mon, 06 Mar 2023 09:01:55 -0500
X-MC-Unique: 2bBSxsB6PqaNlzCdX1PMZQ-1
Received: by mail-wr1-f70.google.com with SMTP id d14-20020adfa34e000000b002bfc062eaa8so1517237wrb.20
        for <patches@lists.linux.dev>; Mon, 06 Mar 2023 06:01:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678111314;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nO3R9JigNCHMlqWS1p9K0Fb3M5vUza+J8/tkd1LfBR8=;
        b=Yk57egQnlp2E+m/ywBInVTQ1o3i2IXSp1RBaaitVE7h6hnAx8Z8u2EE3g0QbWUSvml
         iYGtXjctTxLnywBglXUEWWlfOoYAvUNoFnK3Uq/Cqv0WpRdKg81QqLznP4WMMwfkeYeM
         AehLORVOcxDQOe5qKl5FNwghAhlYuwjwWOBI5MiT8WI5YMq2eNBmNJpTppU6BhLsAL/i
         HoM+oW7wbMDROB1kzWd1cUybLwflPn5jEQngwk4eCF8xs0a8TzjHWQIlnpexbq+RyU18
         dEKxH+fUpa6Pkkky1+dK2FqlDFjtXHlsFQPvrqufaDhtX4mce/3ABDIwQ7iJn3tG6fOY
         Nqtg==
X-Gm-Message-State: AO0yUKXe1UHKOnp4PYmg02CYr+TBSqqrUVteoHY/N1aCr3X/40/xP40L
	YpjFHt+6VnmmyEXcBiXj1UdjbKwcpzmTjY4lec4F/WRIeaf7uXS1kbWe4Zd4oVZ4eMK1d0i9vyd
	Age3tQkJQXmO/cx9Rvg==
X-Received: by 2002:a05:600c:4f50:b0:3eb:2b88:a69a with SMTP id m16-20020a05600c4f5000b003eb2b88a69amr9473190wmq.14.1678111314266;
        Mon, 06 Mar 2023 06:01:54 -0800 (PST)
X-Google-Smtp-Source: AK7set8XuEHIVOaesg76pe7hbbkGNdsq5dTAXQ/i2sABGlubrU8h/rag1QBDgZ3/C2I2SKHPly0img==
X-Received: by 2002:a05:600c:4f50:b0:3eb:2b88:a69a with SMTP id m16-20020a05600c4f5000b003eb2b88a69amr9473141wmq.14.1678111313841;
        Mon, 06 Mar 2023 06:01:53 -0800 (PST)
Received: from ?IPV6:2003:cb:c704:3500:b8a3:191c:eae:cc05? (p200300cbc7043500b8a3191c0eaecc05.dip0.t-ipconnect.de. [2003:cb:c704:3500:b8a3:191c:eae:cc05])
        by smtp.gmail.com with ESMTPSA id v7-20020a05600c444700b003eb0d6f48f3sm15048551wmn.27.2023.03.06.06.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 06:01:53 -0800 (PST)
Message-ID: <2a3386e7-9b09-f22e-ee39-a37a046d54ec@redhat.com>
Date: Mon, 6 Mar 2023 15:01:52 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 3/6] shmem: move reclaim check early on writepages()
To: Luis Chamberlain <mcgrof@kernel.org>, hughd@google.com,
 akpm@linux-foundation.org, willy@infradead.org, brauner@kernel.org
Cc: linux-mm@kvack.org, p.raghav@samsung.com, da.gomez@samsung.com,
 a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
 keescook@chromium.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20230302232758.888157-1-mcgrof@kernel.org>
 <20230302232758.888157-4-mcgrof@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230302232758.888157-4-mcgrof@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03.03.23 00:27, Luis Chamberlain wrote:
> i915_gem requires huge folios to be split when swapping.
> However we have  check for usage of writepages() to ensure
> it used only for swap purposes later. Avoid the splits if
> we're not being called for reclaim, even if they should in
> theory not happen.
> 
> This makes the conditions easier to follow on shem_writepage().
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   mm/shmem.c | 24 ++++++++++++------------
>   1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 2b9ff585a553..a5a6da51087e 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1340,6 +1340,18 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
>   	swp_entry_t swap;
>   	pgoff_t index;
>   
> +	/*
> +	 * Our capabilities prevent regular writeback or sync from ever calling
> +	 * shmem_writepage; but a stacking filesystem might use ->writepage of
> +	 * its underlying filesystem, in which case tmpfs should write out to
> +	 * swap only in response to memory pressure, and not for the writeback
> +	 * threads or sync.
> +	 */
> +	if (!wbc->for_reclaim) {

if (WARN_ON_ONCE(!wbc->for_reclaim))

> +		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */

And drop the comment :) That's what WARN_ON_ONCE is all about.

> +		goto redirty;
> +	}
> +
>   	/*
>   	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "always" or
>   	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
> @@ -1360,18 +1372,6 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
>   	if (!total_swap_pages)
>   		goto redirty;
>   
> -	/*
> -	 * Our capabilities prevent regular writeback or sync from ever calling
> -	 * shmem_writepage; but a stacking filesystem might use ->writepage of
> -	 * its underlying filesystem, in which case tmpfs should write out to
> -	 * swap only in response to memory pressure, and not for the writeback
> -	 * threads or sync.
> -	 */
> -	if (!wbc->for_reclaim) {
> -		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
> -		goto redirty;
> -	}
> -
>   	/*
>   	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC
>   	 * value into swapfile.c, the only way we can correctly account for a

LGTM

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

