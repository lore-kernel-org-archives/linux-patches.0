Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7943100A1
	for <patches@lists.linux.dev>; Tue,  8 Aug 2023 11:17:40 +0000 (UTC)
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6bca3311b4fso4433355a34.0
        for <patches@lists.linux.dev>; Tue, 08 Aug 2023 04:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691493459; x=1692098259;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzvjGxgEq+LtZZdyPTPHKgoOYqzBn/ItwHuccLXsw3U=;
        b=O2g0oBYtTpm72ygoLDgb3M2aso0xNg3zwsRoBSbDtJVXFUYMuIiJoGLoxuOjba9ul5
         4mMSUvqmQCXjijQCqqFqW/4b1oqafP8mTNqtysRnez2iiRnsp1JpqyY5QmSa86LKuOqf
         0Ij2QnlGgwpYgkjNaJCqekTmazBYgDCSmP1s65wDpkQs8hDZuYIu2GIvWgilN0K7l4gi
         ui+sZ+qIH+qUcXeLunP1r+woQyMpiHZnp1ONqdJJ6hjNyxTvuZjtT1LYAqu/nc8tJecg
         O5xfwL3Drlsvg+pmXIIIWRoBy9dRwvjZreY59sODFNWAzNFXMpfOtWRem+wJWZ8i1AKU
         +WCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691493459; x=1692098259;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rzvjGxgEq+LtZZdyPTPHKgoOYqzBn/ItwHuccLXsw3U=;
        b=M+1yhTRz20xO99jc8kPuytUg6xxpN/H89iBnEy7CsFIU3ldRgqSlf5ZbRq8/tBrnX9
         HheiETGWhwHLn7JnwdiOQO6Q+NedbguJc4kqVJoEt3Ru/eHMwPfZGw+eINEC2wPm8Rki
         p4jVe79SHokYJ3CwZER+GFwX0sZFllZ+tZ7bjTjNPDTCGzltuBT2Lw21wTx+E3tAH4Lo
         4jI1lLMuqNSAk0XUSHW/jlGfYWAIaCP0Sp/8F67H2GHubevbK/N3jtZv37vGesXBGf+C
         ve/mUD3Jc7SNBimAeSwZYIM3roGKprWa0Q7N4fErIcJkmIurXd9FeIBDpyxClAVyOwER
         T/MQ==
X-Gm-Message-State: AOJu0YxFkLFpFe8B/JcJZ4icYZC/q1h1HpdywpQ20Wy67CZk1OnGZmx3
	6ayUOKHF5GSMbKBIPOmL/pg/Kw==
X-Google-Smtp-Source: AGHT+IF/38k+mHYDsiCV9q5ja1BmiVsvVPQRkz7QNU8NMvABvumJfQv6Cb+Dkh3TgtDABWaEDoiMaQ==
X-Received: by 2002:a05:6808:f8d:b0:3a7:3ea1:b5a0 with SMTP id o13-20020a0568080f8d00b003a73ea1b5a0mr14696027oiw.47.1691493459612;
        Tue, 08 Aug 2023 04:17:39 -0700 (PDT)
Received: from [10.90.34.137] ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a005e00b0025023726fc4sm11179299pjb.26.2023.08.08.04.17.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 04:17:39 -0700 (PDT)
Message-ID: <853af8fa-0cef-b00b-3fd6-9780a2008050@bytedance.com>
Date: Tue, 8 Aug 2023 19:17:31 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [RFC v1 4/5] maple_tree: avoid bulk alloc/free to use percpu
 array more
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>, Joonsoo Kim
 <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Matthew Wilcox <willy@infradead.org>
References: <20230808095342.12637-7-vbabka@suse.cz>
 <20230808095342.12637-11-vbabka@suse.cz>
From: Peng Zhang <zhangpeng.00@bytedance.com>
In-Reply-To: <20230808095342.12637-11-vbabka@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2023/8/8 17:53, Vlastimil Babka 写道:
> Using bulk alloc/free on a cache with percpu array should not be
> necessary and the bulk alloc actually bypasses the array (the prefill
> functionality currently relies on this).
> 
> The simplest change is just to convert the respective maple tree
> wrappers to do a loop of normal alloc/free.
> ---
>   lib/maple_tree.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 1196d0a17f03..7a8e7c467d7c 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -161,12 +161,19 @@ static inline struct maple_node *mt_alloc_one(gfp_t gfp)
>   
>   static inline int mt_alloc_bulk(gfp_t gfp, size_t size, void **nodes)
>   {
> -	return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
> +	int allocated = 0;
> +	for (size_t i = 0; i < size; i++) {
> +		nodes[i] = kmem_cache_alloc(maple_node_cache, gfp);
> +		if (nodes[i])
If the i-th allocation fails, node[i] will be NULL. This is wrong. We'd
better guarantee that mt_alloc_bulk() allocates completely successfully,
or returns 0. The following cases are not allowed:
nodes: [addr1][addr2][NULL][addr3].
> +			allocated++;
> +	}
> +	return allocated;
>   }
>   
>   static inline void mt_free_bulk(size_t size, void __rcu **nodes)
>   {
> -	kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
> +	for (size_t i = 0; i < size; i++)
> +		kmem_cache_free(maple_node_cache, nodes[i]);
>   }
>   
>   static void mt_free_rcu(struct rcu_head *head)
