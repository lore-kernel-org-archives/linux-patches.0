Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632AE59B5F
	for <patches@lists.linux.dev>; Fri, 12 Jan 2024 13:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="h8FP/il9"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a28af5d7531so172987566b.1
        for <patches@lists.linux.dev>; Fri, 12 Jan 2024 05:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1705064704; x=1705669504; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vAbZchzI0iGmOu/a8rn2udlF7BOKYbAuYwZzGRVm3BU=;
        b=h8FP/il95qNAqQEnShkJ6U5ILF9yNIwYdGhPTkK4s0mMzw5f60+Wf7bGIZrm08NiZX
         0kvaLgwSsUw9GW3LbxcGeggWuxY2BR9zJhGQXKytyWtNvz8zcU1eIBElQRUALZsy6FTN
         rXljK+RkBrxXWLO9UuI7dhsW5Y09FyzTZWbcI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705064704; x=1705669504;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vAbZchzI0iGmOu/a8rn2udlF7BOKYbAuYwZzGRVm3BU=;
        b=b1oIY5RxRiST4Desm4/5itlU+NUWDd93uHkesW8XJOUNEpLzfDJZ7ur6PNFmTsmSC5
         XyqLrYRI6kZqrvxpirMjKzjgEb5hC/+lipkzRFOvJPMqL5jq4mW5QkWGc/Sg3QgD2PW5
         OLjgz3EHt2xLHJttnBkNec28VM6B18aU44ugH6gsbhoeCQx5r4mUOGgVxqbMJvO6kyu9
         l21Z57YSRhpMHopcLhBVQi6KF40wErN5iK+f1B5fydxXyKMgXRnkDcMaTqelrQpWQljp
         hmD30WqNen2m4BvSivdewK9NG0cGjI9TINPWQiVfkxIts0mYGkRbPddhdnIlFarsQ0BL
         c6Ww==
X-Gm-Message-State: AOJu0YwS+iCsc4JIJyM0A7ddcfmfI+jBtQiWE/vfSn4GUQpWMF30iXcM
	/1xeQXwVOxxkkZbdGeCtQtxNlajUnb+1KA==
X-Google-Smtp-Source: AGHT+IFtm6FukgWCJmvMOWGIQAQ4rW/HJgSEIzEjtdiyxsAnvXu1fGEvnNuGMsdglBVovqejvpW9Xg==
X-Received: by 2002:a17:907:720e:b0:a2b:d12c:ee42 with SMTP id dr14-20020a170907720e00b00a2bd12cee42mr1179501ejc.0.1705064704572;
        Fri, 12 Jan 2024 05:05:04 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id z19-20020a1709060ad300b00a2687065e28sm1761878ejf.45.2024.01.12.05.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 05:05:04 -0800 (PST)
Date: Fri, 12 Jan 2024 14:05:02 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: dri-devel@lists.freedesktop.org, patches@lists.linux.dev,
	Sumit Semwal <sumit.semwal@linaro.org>, linux-media@vger.kernel.org,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf/dma-resv: fix spelling
Message-ID: <ZaE4_l8PzXx9Isjp@phenom.ffwll.local>
References: <20240111041202.32011-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240111041202.32011-1-rdunlap@infradead.org>
X-Operating-System: Linux phenom 6.5.0-4-amd64 

On Wed, Jan 10, 2024 at 08:11:55PM -0800, Randy Dunlap wrote:
> Fix spelling mistakes as reported by codespell.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: Christian König <christian.koenig@amd.com>
> Cc: linaro-mm-sig@lists.linaro.org

Both dma-buf spell fixes applied to drm-misc-next, thanks!
-Sima
> ---
>  drivers/dma-buf/dma-resv.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -- a/drivers/dma-buf/dma-resv.c b/drivers/dma-buf/dma-resv.c
> --- a/drivers/dma-buf/dma-resv.c
> +++ b/drivers/dma-buf/dma-resv.c
> @@ -405,7 +405,7 @@ static void dma_resv_iter_walk_unlocked(
>   *
>   * Beware that the iterator can be restarted.  Code which accumulates statistics
>   * or similar needs to check for this with dma_resv_iter_is_restarted(). For
> - * this reason prefer the locked dma_resv_iter_first() whenver possible.
> + * this reason prefer the locked dma_resv_iter_first() whenever possible.
>   *
>   * Returns the first fence from an unlocked dma_resv obj.
>   */
> @@ -428,7 +428,7 @@ EXPORT_SYMBOL(dma_resv_iter_first_unlock
>   *
>   * Beware that the iterator can be restarted.  Code which accumulates statistics
>   * or similar needs to check for this with dma_resv_iter_is_restarted(). For
> - * this reason prefer the locked dma_resv_iter_next() whenver possible.
> + * this reason prefer the locked dma_resv_iter_next() whenever possible.
>   *
>   * Returns the next fence from an unlocked dma_resv obj.
>   */
> _______________________________________________
> Linaro-mm-sig mailing list -- linaro-mm-sig@lists.linaro.org
> To unsubscribe send an email to linaro-mm-sig-leave@lists.linaro.org

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
