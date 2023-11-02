Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED42933C5
	for <patches@lists.linux.dev>; Thu,  2 Nov 2023 07:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="MdTE/Jxc"
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6FEB140620
	for <patches@lists.linux.dev>; Thu,  2 Nov 2023 07:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1698910158;
	bh=+pVsiDdDaRHtbuhaPEXTC0rT+NfCOHEE3IYrOuWEgvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=MdTE/JxcMqXM93Knik+nAkptpXuC2+n2YBdUMfmfD9P9S31X/mca3nKWqnNzoX+TK
	 WDXSiv8rKbJvupy5pwAmR4HkcZB2pYEW7suGFUWrJ7ZaTwQ9zTO1UE6oHLQX2k+ZNe
	 NGiHjsF6G+0DOnc0bPJslSaK+OCBoF1GQIL7BUqB0IKSExUkfEg+Wm6/5iP29nbpst
	 /ryX5HtnLRx6n8Qr3+eYrfqknuujx+wCZ/Re/bdDB0HBerF3WUx0EtbmRtdwIaa7m8
	 9F9AdQdOZHG/BCBcgMj8oCjF4l6++op3DHxZ0rJrZEWk7AfTJd8MxPXS8kvpY7eaB5
	 efJPOXUV+qp6A==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9ae0bf9c0b4so44114366b.0
        for <patches@lists.linux.dev>; Thu, 02 Nov 2023 00:29:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698910158; x=1699514958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+pVsiDdDaRHtbuhaPEXTC0rT+NfCOHEE3IYrOuWEgvA=;
        b=gGK+U1PIpjtwvXtVod8IckDa42O+r2t+xDBf19lBzkzq81OaKgKpAOor11haC0/hY4
         YNymDp8O+fbcKzptEkrscQ5JxIEXPSkmYpRu10g3DX136bIOpH+APIlDDqKawcxjuglB
         YzcVm135kNUbrnusDAeKkjNCkofoaeT2sg7imBERbPs0bTSXVX4RJI2QPHSo1HzkDGll
         LZ4JGqEZ52NaLDsQK2EjggZ5IDiA/fEINMbOw8m8JzQNmQWF16AHQad2ebsoPJ4nBfhf
         yF6MRcPvun5dhQVY/Zc+B80b/4F7HkwR6dfiGVQpzxmFtoBcSwwbbYCTSknzrCZ1elZV
         I+vA==
X-Gm-Message-State: AOJu0YzVrIz/DGWRWMoqybQONrkKc/nuTl4ToNUzoq8AZqZLnR239H3o
	ul0hsfX3J20TQJx7s0wlPgu8Z2yJ7G0m0wml5U7/pUazszSwt/dsR4bPKqENVbGJ3vBcNFyCBAn
	uAMwhixJZQJ0h8WyBT0maCKyxFoguQhXnS3w=
X-Received: by 2002:a17:906:fd89:b0:9b9:a1dd:5105 with SMTP id xa9-20020a170906fd8900b009b9a1dd5105mr4190814ejb.50.1698910158107;
        Thu, 02 Nov 2023 00:29:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgKVRuZ2yuLsoWD60Wk4tJZOUuXgLooNeDFsOrnZtXJBI73p6VP+QlViFd//3PfPYMTjc+fA==
X-Received: by 2002:a17:906:fd89:b0:9b9:a1dd:5105 with SMTP id xa9-20020a170906fd8900b009b9a1dd5105mr4190785ejb.50.1698910157337;
        Thu, 02 Nov 2023 00:29:17 -0700 (PDT)
Received: from localhost (host-79-33-130-95.retail.telecomitalia.it. [79.33.130.95])
        by smtp.gmail.com with ESMTPSA id lj18-20020a170906f9d200b0099290e2c163sm771585ejb.204.2023.11.02.00.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 00:29:17 -0700 (PDT)
Date: Thu, 2 Nov 2023 08:29:15 +0100
From: Andrea Righi <andrea.righi@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-modules@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	keescook@chromium.org, zhumao001@208suo.com, yangtiezhu@loongson.cn,
	ojeda@kernel.org
Subject: Re: [GIT PULL] Modules changes for v6.7-rc1
Message-ID: <ZUNPy/sMRxdo+o2w@gpd>
References: <ZUKxT1CL9/0Dn6NE@bombadil.infradead.org>
 <CAHk-=whFXNYXG2ES8HdoaMC=O4bakMXGZezmoqA3SXwn4xJUPQ@mail.gmail.com>
 <CAHk-=wi=goCaTm6ZOKzm_ztky9ZT-vuGDWv39vVdtQT+oW=zEg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi=goCaTm6ZOKzm_ztky9ZT-vuGDWv39vVdtQT+oW=zEg@mail.gmail.com>

On Wed, Nov 01, 2023 at 09:21:09PM -1000, Linus Torvalds wrote:
> On Wed, 1 Nov 2023 at 21:02, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > kmalloc() isn't just about "use physically contiguous allocations".
> > It's also more memory-efficient, and a *lot* faster than vmalloc(),
> > which has to play VM tricks.
> 
> I've pulled this, but I think you should do something like the
> attached (UNTESTED!) patch.
> 
>                 Linus

Looks good to me, I'll give it a try ASAP.

-Andrea


>  kernel/module/decompress.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/module/decompress.c b/kernel/module/decompress.c
> index 4156d59be440..474e68f0f063 100644
> --- a/kernel/module/decompress.c
> +++ b/kernel/module/decompress.c
> @@ -100,7 +100,7 @@ static ssize_t module_gzip_decompress(struct load_info *info,
>  	s.next_in = buf + gzip_hdr_len;
>  	s.avail_in = size - gzip_hdr_len;
>  
> -	s.workspace = vmalloc(zlib_inflate_workspacesize());
> +	s.workspace = kvmalloc(zlib_inflate_workspacesize(), GFP_KERNEL);
>  	if (!s.workspace)
>  		return -ENOMEM;
>  
> @@ -138,7 +138,7 @@ static ssize_t module_gzip_decompress(struct load_info *info,
>  out_inflate_end:
>  	zlib_inflateEnd(&s);
>  out:
> -	vfree(s.workspace);
> +	kvfree(s.workspace);
>  	return retval;
>  }
>  #elif defined(CONFIG_MODULE_COMPRESS_XZ)
> @@ -241,7 +241,7 @@ static ssize_t module_zstd_decompress(struct load_info *info,
>  	}
>  
>  	wksp_size = zstd_dstream_workspace_bound(header.windowSize);
> -	wksp = vmalloc(wksp_size);
> +	wksp = kvmalloc(wksp_size, GFP_KERNEL);
>  	if (!wksp) {
>  		retval = -ENOMEM;
>  		goto out;
> @@ -284,7 +284,7 @@ static ssize_t module_zstd_decompress(struct load_info *info,
>  	retval = new_size;
>  
>   out:
> -	vfree(wksp);
> +	kvfree(wksp);
>  	return retval;
>  }
>  #else

