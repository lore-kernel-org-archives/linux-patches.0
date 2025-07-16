Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD81D2F2C7C
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752660548; cv=none; b=GK6ifB/JZ+wIIi4E07BVITnPcojjD6aJPz1jkhGpmTjg9cwQChcpsibIw5YhUs4k3uJS6Y4FjvGVZyYjJtccOIjb/msZns8ilLvxBguMazKKLg4YGgjgRGKVO6Mqtu7HGp9pg9seXf/Q2vrKQON/baLSWN877vv/1CrJjBwIEpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752660548; c=relaxed/simple;
	bh=bFBhJZawVLHR8IcJ2Vcrd4R81/LwC9KrzFTtxMVX5cg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YQYZQ1kXeKrX4nB13CRF6tdADaXlGwj0UtmWzt6029a4HwifguIS9bc/XjVzabYWFfQdYtqJKuRUNoAUFpzmX4sDVA511oKYHNF8U1DgNbJM48G674dHr1svSVVKAs5b9QpueKmAba7fcyiZ8zrFv8neIVGWsGaE47Gg7XHqN/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jnkFnJpG; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jnkFnJpG"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-711756ae8c9so50581877b3.3
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 03:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752660546; x=1753265346; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4gV45BWglfzhUxE59Qv4ombDQhK6ciqBH4GljP84GFs=;
        b=jnkFnJpG41ZyK7fLCfJp0DEuE4AyDMTNOOIWCUeNV6zkwNgCUGgU7iiEGm2SQ/2rkU
         2JObsj+5DT55+mThlhS2kleZDz8mmUFbaEqeNu0orwNieKkBHOLGHmRWo4BDtN347X4L
         39pXKEy5vp2hvF6wYCBiNX7nkCJCpwJk52aLxHL+Ky+hUv2ge/NrEqEN+4BAOtfKjSrt
         /tmVT1kLmku6/Y01J6OaUE6maDshuQ1usguaVVUutO6UKoGRW6AHzl2e/KjDf1900ke9
         e9NEWScZdhwJw5tbJr2lnEjeS3v7ZEqzIYs9s6liNRCTlRV5lVR4cOtjS4qVnFiC2TcI
         ZbhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752660546; x=1753265346;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4gV45BWglfzhUxE59Qv4ombDQhK6ciqBH4GljP84GFs=;
        b=jLm/Cwg07d05k1qD+3Jd65wvfOUXq6QqB2zRSF1sTsfIVNXVJUCMSq6+llRS0FnpJz
         PAU7frKx2CbQABMlUecziJJJDpGK1ZAjmJyv0AKxxI1RLi3UbEFz0VE+waKNxH7R/uYT
         3q1A3DgTaACdIrFFxjib++DB+fQEHEQSBjcWSEXM+eTmnYPWh2dTh9Q3bHHCTuWHB/Kl
         kxVNCxaYMXbRRmhVu72lA2Y2z8HqVLmC1ifPBM9GxUMwNTkrvJraIN5X7pAfz9KglE8W
         BBZ52mk8HZyAMAX2McrPHtVhS58n0wnsv3NW7haZOMLc/BedrYL9qs9W5kjjeFSy6r/6
         myUw==
X-Forwarded-Encrypted: i=1; AJvYcCUIZUcU9BGCrfgu7tZgX7POCvoUD6AIrKPwsww9NrXzr+XJZuM9WPVBulFwZvZqjTJGMfQjrXWf@lists.linux.dev
X-Gm-Message-State: AOJu0YwFc7aTKDDEQGM3Zt9JQ8WojfAqzWKEkcmdeM+XNClN8aTgUXQw
	M0eIVu6kubyc4YYI2JOhwkG1/eSM/y4OIoesi7u5yZhNAU+iZvgvD2NZILJrKQsLt7mEX4l/jJX
	VyqZchQqVIJEpF0HwdMFWdu1k1Ai+ZbMnx5KEdVzg4Q==
X-Gm-Gg: ASbGncsx/JGBANTa41+w18OL0kcNx2IxQ2lsRUUc8DZgfaKFymFch5zS+gWcudnDH0m
	189ifxmuIWcT7VWFgbiOoeoTn1fq7TbSPJ0mcTx0CoSn6uUBPuAuc0ACN2Nq9VVoAk7ezEjfbZ6
	OpkmpSWd+m4w4MA4htQfj1mr4IKGEt5ANGFTk4lvPaxpcK3fvtGzT9IkUsw9LyRtY1CYBqMe4ZT
	OHh90p8
X-Google-Smtp-Source: AGHT+IHbf9uC6mvlDjLNF6dIc9S4dSQ+VNOZ0NRDgEmrKLk0gdoDzLQwF9jjwQJK77A/D6L0h1BM5w/vF4E9CMZ6E90=
X-Received: by 2002:a05:690c:730a:b0:70e:7ff6:9ff3 with SMTP id
 00721157ae682-7183517dc19mr38773327b3.35.1752660545599; Wed, 16 Jul 2025
 03:09:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715-memstick-fix-uninit-const-pointer-v1-1-f6753829c27a@kernel.org>
In-Reply-To: <20250715-memstick-fix-uninit-const-pointer-v1-1-f6753829c27a@kernel.org>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Wed, 16 Jul 2025 12:08:29 +0200
X-Gm-Features: Ac12FXyidmVqEt8vJA-TGBN58fq86rVrqsDtWU_9Q1n-pkGowaYzgUWF1QhgIVw
Message-ID: <CAPDyKFpb+_N_XbZrZ02QDFfgk0MNMWb=oJC4V10+s+CrDXdUQw@mail.gmail.com>
Subject: Re: [PATCH] memstick: core: Zero initialize id_reg in h_memstick_read_dev_id()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>, 
	Arnd Bergmann <arnd@arndb.de>, linux-mmc@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 16 Jul 2025 at 00:56, Nathan Chancellor <nathan@kernel.org> wrote:
>
> A new warning in clang [1] points out that id_reg is uninitialized then
> passed to memstick_init_req() as a const pointer:
>
>   drivers/memstick/core/memstick.c:330:59: error: variable 'id_reg' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
>     330 |                 memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, &id_reg,
>         |                                                                         ^~~~~~
>
> Commit de182cc8e882 ("drivers/memstick/core/memstick.c: avoid -Wnonnull
> warning") intentionally passed this variable uninitialized to avoid an
> -Wnonnull warning from a NULL value that was previously there because
> id_reg is never read from the call to memstick_init_req() in
> h_memstick_read_dev_id(). Just zero initialize id_reg to avoid the
> warning, which is likely happening in the majority of builds using
> modern compilers that support '-ftrivial-auto-var-init=zero'.
>
> Cc: stable@vger.kernel.org
> Fixes: de182cc8e882 ("drivers/memstick/core/memstick.c: avoid -Wnonnull warning")
> Link: https://github.com/llvm/llvm-project/commit/00dacf8c22f065cb52efb14cd091d441f19b319e [1]
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2105
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Applied for fixes, thanks!

Kind regards
Uffe


> ---
>  drivers/memstick/core/memstick.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
> index 043b9ec756ff..7f3f47db4c98 100644
> --- a/drivers/memstick/core/memstick.c
> +++ b/drivers/memstick/core/memstick.c
> @@ -324,7 +324,7 @@ EXPORT_SYMBOL(memstick_init_req);
>  static int h_memstick_read_dev_id(struct memstick_dev *card,
>                                   struct memstick_request **mrq)
>  {
> -       struct ms_id_register id_reg;
> +       struct ms_id_register id_reg = {};
>
>         if (!(*mrq)) {
>                 memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, &id_reg,
>
> ---
> base-commit: ff09b71bf9daeca4f21d6e5e449641c9fad75b53
> change-id: 20250715-memstick-fix-uninit-const-pointer-ed6f138bf40d
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
