Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5018C4685
	for <patches@lists.linux.dev>; Tue,  4 Oct 2022 23:26:18 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id l12so13987524pjh.2
        for <patches@lists.linux.dev>; Tue, 04 Oct 2022 16:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=7/Ozj3mcJHGAbiaTjJPeg1Cq0BOU1VOEYEwFpmEWKCM=;
        b=llPMwaCiE9svemlfZqli62QUjvnug0AjUfYmUGejcxHbeFLQzrs63Wval4R32RWsHg
         +Az6jF6ioPj+7Fo1t2L69xg0tVVHdFxCe0D/voKanm4stAdZgmX5t5qodEVHpZDgd0+9
         56jlkNiFTjn62io5dQDAzOfNUjkhCdtYYRpGoxxDGgQQznSmN7+9ms/r3VLqSw27je47
         J8PhqljQ1VWp5tNzLNZXgCU7ZqRYvwMf3ZKhF0Y8kcOXuUcx77j8vwD+/0La/xJ5oZFv
         15F+xfb1NOIy87TBxyHwpuO9j8I9PYX0kQ4b/HgxO2hq2bePBhWZV31DjFCmOn90fDQh
         b4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=7/Ozj3mcJHGAbiaTjJPeg1Cq0BOU1VOEYEwFpmEWKCM=;
        b=7KHF9hjidvqlk+8QIP6YWtlU0rG1MG92QkjZhEDvpeA4YW3hTik2NjX8TzoLbKQHtH
         mlgqB3ifWbkntY4S+ta7bzdlXYMNqXTGwZ2UoOLM4RyrcQpsAlRQ52YpYeAi5a54eUrJ
         EpaC1xeAuKeWyc3cUuGhQGykI3j2t8Mgi42X4zo2+N7Y93PErBoVxSPF7LlrEDhtlmsT
         LMBzJPaP/6Dej/T7EBF/Q0A/6Pv7HsAfNiwQfuFMH8VkxL35kBJ2Yd46krtVOJQnDNBT
         q47yCyMiNZfciBW0y2b0akGGxpvX5vziX3Ey1gFoT5XA5tP5YkP0kmNOxgK7qr3AIzE0
         yB8w==
X-Gm-Message-State: ACrzQf3Uy7F84J3lhOxT+QjvXkqLnNQ2rCLKolBW5PH5kXahyQrwjHV5
	koRYVERwrEN8MQM+nTv5hMmyiFIZJ9TMkgkcT2e7Rw==
X-Google-Smtp-Source: AMsMyM5rQkHFdryWEFHJkT4DR3oJz6pJFO4t4FvddE/j05hxDwSkHKNVetdFAEuansIfTVvwPxLVRBpyv/iUCPONt+8=
X-Received: by 2002:a17:90b:33c3:b0:20a:ebc3:6514 with SMTP id
 lk3-20020a17090b33c300b0020aebc36514mr641575pjb.147.1664925977583; Tue, 04
 Oct 2022 16:26:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221004232359.285685-1-nathan@kernel.org> <20221004232359.285685-2-nathan@kernel.org>
In-Reply-To: <20221004232359.285685-2-nathan@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 4 Oct 2022 16:26:05 -0700
Message-ID: <CAKwvOdkrmMQVaQ6vD9f2BN_tYyxcjhwH28pGxkstmr-Pop-z6A@mail.gmail.com>
Subject: Re: [PATCH -next v2 2/2] fs/ntfs3: Eliminate unnecessary ternary
 operator in ntfs_d_compare()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tom Rix <trix@redhat.com>, 
	ntfs3@lists.linux.dev, llvm@lists.linux.dev, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 4, 2022 at 4:24 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> 'a == b ? 0 : 1' is logically equivalent to 'a != b'.
>
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>
> v2: New patch.
>
>  fs/ntfs3/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
> index 5d3a6ce3f05f..6b0d2c01d6ff 100644
> --- a/fs/ntfs3/namei.c
> +++ b/fs/ntfs3/namei.c
> @@ -432,7 +432,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
>         /* First try fast implementation. */
>         for (;;) {
>                 if (!lm--)
> -                       return len1 == len2 ? 0 : 1;
> +                       return len1 != len2;
>
>                 if ((c1 = *n1++) == (c2 = *n2++))
>                         continue;
> --
> 2.37.3
>


-- 
Thanks,
~Nick Desaulniers
