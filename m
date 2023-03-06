Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45776525C
	for <patches@lists.linux.dev>; Mon,  6 Mar 2023 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678111153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FZbNQdV4FYPtOj26Ts0Bv5UjRK7OPjSiZogSK8fE+7o=;
	b=AWiGjZq1+TmhLriS63ybf2nWXrhJ6lfAUcDkMm1v0Yrc66NFt0SIUPNyQt+bvozKjGMqqV
	1GU2NzaDaPsm0EB1y1hwWNRuTUyOvP4cvy3RT4KJDY/KkThfDPkJA1AuRj/TVqOy7LAFS+
	ICBECsHhyu5/v0g+m8bjRX6/fB59zE8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-NR7VC3CbM1C2LKFpnwMKDg-1; Mon, 06 Mar 2023 08:59:11 -0500
X-MC-Unique: NR7VC3CbM1C2LKFpnwMKDg-1
Received: by mail-wm1-f71.google.com with SMTP id e17-20020a05600c219100b003e21fa60ec1so3780657wme.2
        for <patches@lists.linux.dev>; Mon, 06 Mar 2023 05:59:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678111150;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FZbNQdV4FYPtOj26Ts0Bv5UjRK7OPjSiZogSK8fE+7o=;
        b=H43VAzZVVOg2ZKwy8Xl5dcXGgv1bom1tJjqQv43/pjGRsIxbQl7dfOQh0OcmkcrTmK
         PV7RQ5io6cr98Jjyv+1SfgSNtiF711jfzE1hhmPVp1Anugifs/Pc42OfGw0M0sBGJPqg
         EzPYoqrTKHrYO08eIZFkcvIPIPijzxIk1+TwA1neEqXZjqRQODyUs5PPs7Updb8raYPX
         I72F5fV0PdSrQUfzkO4kQq9o5QkO7cG4mDXFL5se7ZfahnVom3vrjC/y0PdJ00sKp9Z0
         kuzCNAf1tNcRZb7mnhKvbm55ZSO3nvk6qHJD/RGW2FtU3h3NoEeTfZNZB5RKAKQFDYKP
         cWAw==
X-Gm-Message-State: AO0yUKV+PeZJTqTlm070jMx5qwVOZ83CSJr7iWld1lWiMERHBcGGiGtd
	aleDJfBNCajXAS+MudQHq6BrgPcX3zMPIHLlxjs4OllJxlcmsNeX/ZaszfWy8NVUKBZFqI38H8k
	4+2/rGm/K2sCargaXxA==
X-Received: by 2002:adf:e492:0:b0:2c9:2292:3f8c with SMTP id i18-20020adfe492000000b002c922923f8cmr6261729wrm.40.1678111150727;
        Mon, 06 Mar 2023 05:59:10 -0800 (PST)
X-Google-Smtp-Source: AK7set8URRo+VuPTwIZlwc9T6VPu4ZprYZJyIpKlbhlSQMnlagDn+3h3JtXbhdydJHdnUOAOO+l24g==
X-Received: by 2002:adf:e492:0:b0:2c9:2292:3f8c with SMTP id i18-20020adfe492000000b002c922923f8cmr6261721wrm.40.1678111150407;
        Mon, 06 Mar 2023 05:59:10 -0800 (PST)
Received: from ?IPV6:2003:cb:c704:3500:b8a3:191c:eae:cc05? (p200300cbc7043500b8a3191c0eaecc05.dip0.t-ipconnect.de. [2003:cb:c704:3500:b8a3:191c:eae:cc05])
        by smtp.gmail.com with ESMTPSA id o16-20020a056000011000b002c703d59fa7sm9956231wrx.12.2023.03.06.05.59.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 05:59:10 -0800 (PST)
Message-ID: <f4b32f05-6396-329b-4bc8-18d4af244279@redhat.com>
Date: Mon, 6 Mar 2023 14:59:08 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/6] shmem: remove check for folio lock on writepage()
To: Luis Chamberlain <mcgrof@kernel.org>, hughd@google.com,
 akpm@linux-foundation.org, willy@infradead.org, brauner@kernel.org
Cc: linux-mm@kvack.org, p.raghav@samsung.com, da.gomez@samsung.com,
 a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
 keescook@chromium.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20230302232758.888157-1-mcgrof@kernel.org>
 <20230302232758.888157-2-mcgrof@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230302232758.888157-2-mcgrof@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03.03.23 00:27, Luis Chamberlain wrote:
> Matthew notes we should not need to check the folio lock
> on the writepage() callback so remove it. This sanity check
> has been lingering since linux-history days. We remove this
> as we tidy up the writepage() callback to make things a bit
> clearer.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   mm/shmem.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 1af85259b6fc..7fff1a3af092 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1354,7 +1354,6 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
>   		folio_clear_dirty(folio);
>   	}
>   
> -	BUG_ON(!folio_test_locked(folio));
>   	mapping = folio->mapping;
>   	index = folio->index;
>   	inode = mapping->host;


It's still required IIUC. At least for split_huge_page() and 
setting/clearing some page flags in there.

At least split_huge_page() also contains a
	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);

So it's probably reasonable to remove this unconditional sanity check 
here; removing BUG_ON's is always nice.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

