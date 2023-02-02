Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AAD8F63
	for <patches@lists.linux.dev>; Thu,  2 Feb 2023 19:00:49 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id 78so2019943pgb.8
        for <patches@lists.linux.dev>; Thu, 02 Feb 2023 11:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p3ZYbtaIavkAf5aV8P1noUyCGHCi0NGSeVESNHvFnYY=;
        b=tERd3yuEcFjOGwSs1S4VXGdkVqpN6d4UcJwqaiEYucEdFffjmVwx6IDBVLa7XV4kOY
         nkeXbAEzLNpaYr3MNTHiUQ8AU6tUR3k35WlLLOUxlKQYXW1vs7nUDrTUnF75dZCDdl3o
         Vgb3Jmf8Oj2ZVHxRhbmUPbn+Wq6fNVwAlOjMd2lxhqQwYZsk471YYelimQvNaCIsbFtR
         97gVJnMI13LURT+JSYWHTIWHKmrVE0AkyLru+Y6TE74DiYtQBmSakWGDyIk6aOfMhCTv
         ZcAes6tsNcN4zMcgAOcWyvVFf1+5DdwWbLSuazZCgEA3RdGPwAcIUl50DbZA5YxsBPnw
         Jx8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p3ZYbtaIavkAf5aV8P1noUyCGHCi0NGSeVESNHvFnYY=;
        b=N8grnjEt550fN3Icn/WuLqm+OQRCjZ+xYtr8sV58fF3YXpC00FYD1JbrW4CWeKFEqz
         UemrhA3eLklqeZ/M07NLAuP4NpGghdftdNE0TEBKRjUj5oqwBeqxHo2IP9NVSI9cIPuO
         TjkOTlnbXBqWTqKxyeeoO6nm0anTGchVw2O6BcAcLZ+FBodv6QiS2mJDBODqe706iIPr
         J9EiUnZ+14MHstmJ18mwgQMXoUlN4rgZExGxfs7H9RTTzre3h35qhRyc7k9dPK497LWC
         1DfEbKOTocgOyUdpjnUFNAYZ6TgeWgPVomTAPxLa77AX8AKB/vOMzlDZZWGkZPlZHocl
         SLww==
X-Gm-Message-State: AO0yUKVk7JZdBxjiWVuNKWe+cQmxqJbFF/J9veMtgYQCvRgBx92Q1mbe
	a3TMGxrwcu9O3aLiwa7RveCaxa5EQx0+siPZM4IRBQ==
X-Google-Smtp-Source: AK7set8NvDoA9gf4AicHigBtu9UpVuZVLhwEfuP2Vzy2j1FjpsC9TsZ1y3DDjZctSawx3/ctiEaprHJ0rsQLVFXvU3g=
X-Received: by 2002:a63:dd43:0:b0:4da:af6:ed with SMTP id g3-20020a63dd43000000b004da0af600edmr1187478pgj.30.1675364449073;
 Thu, 02 Feb 2023 11:00:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230202-dm-parenthesis-warning-v1-1-ebdee213eeb9@kernel.org>
In-Reply-To: <20230202-dm-parenthesis-warning-v1-1-ebdee213eeb9@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 2 Feb 2023 11:00:37 -0800
Message-ID: <CAKwvOdnffHbU4ObT2jDr_iASEC==CUsX2FfqdA-+iLU4y5Ma=g@mail.gmail.com>
Subject: Re: [PATCH] dm flakey: Fix clang -Wparentheses-equality in flakey_map()
To: Nathan Chancellor <nathan@kernel.org>
Cc: agk@redhat.com, snitzer@kernel.org, trix@redhat.com, 
	sweettea-kernel@dorminy.me, mpatocka@redhat.com, dm-devel@redhat.com, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 2, 2023 at 9:00 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Clang warns:
>
>   ../drivers/md/dm-flakey.c:369:28: error: equality comparison with extraneous parentheses [-Werror,-Wparentheses-equality]
>                           if ((fc->corrupt_bio_rw == WRITE)) {
>                                ~~~~~~~~~~~~~~~~~~~^~~~~~~~
>   ../drivers/md/dm-flakey.c:369:28: note: remove extraneous parentheses around the comparison to silence this warning
>                           if ((fc->corrupt_bio_rw == WRITE)) {
>                               ~                   ^       ~
>   ../drivers/md/dm-flakey.c:369:28: note: use '=' to turn this equality comparison into an assignment
>                           if ((fc->corrupt_bio_rw == WRITE)) {
>                                                   ^~
>                                                   =
>   1 error generated.
>
> GCC only warns when one set of parentheses are used for assignment
> expressions, whereas clang additionally warns when two sets of
> parentheses are used for equality comparisons. Remove the extra set of
> parentheses to silence the warning as it suggests, as this is obviously
> supposed to be an equality comparison.
>
> Fixes: 0e766389cedc ("dm flakey: fix logic when corrupting a bio")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1798
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
> I do not mind this change being squashed with the offending commit, as I
> noticed it was Cc'd for stable, which would minimize the chance for
> breakage.
> ---
>  drivers/md/dm-flakey.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
> index 08f9aa476d97..335684a1aeaa 100644
> --- a/drivers/md/dm-flakey.c
> +++ b/drivers/md/dm-flakey.c
> @@ -366,7 +366,7 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
>                  * Corrupt matching writes.
>                  */
>                 if (fc->corrupt_bio_byte) {
> -                       if ((fc->corrupt_bio_rw == WRITE)) {
> +                       if (fc->corrupt_bio_rw == WRITE) {
>                                 if (all_corrupt_bio_flags_match(bio, fc))
>                                         corrupt_bio_data(bio, fc);
>                         }
>
> ---
> base-commit: 6f30cc248507ee96c22ff4c3cbc86099ff12b7a9
> change-id: 20230202-dm-parenthesis-warning-6139f4b5020b
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>


-- 
Thanks,
~Nick Desaulniers
