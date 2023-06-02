Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085FA17AC5
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 12:08:26 +0000 (UTC)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5148f299105so4276481a12.1
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 05:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685707705; x=1688299705;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NX4MckBz+kMOWWfYXwQZwvt4Wo7nQreetEG9P/8etNY=;
        b=MDzogKGgpQt2NfKjKR2ABAnQ6PSNWZBvu0fv2J7+xfF5C41DC4RF+q3E1HGzB0ZMhV
         vHzp6MfzR3ujs2eivp/hgH73nCaEqHdwBbmjp+BzD+PFpzlXJJd62OaE0jrWUq2cCcbm
         gAaPwxRgLE1xCK+PlxIQXar26PrNut/5fYWOfALJs+aBTHb5TQ8uzlPaG15A4rqEJprO
         +KxRj8cRVm2tzTFShQp47ZqeyOr6Sb5mgGoLwlLlaBUEZP6ZVD1uEY0EX7Rmw0n4S8di
         sH37RgFaWRfkAfUwA15nmc9k2lLP2JDou/XXZTtg9KKBQZYPR9d2GMFLyR4vj8bpO4EJ
         Mzcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685707705; x=1688299705;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NX4MckBz+kMOWWfYXwQZwvt4Wo7nQreetEG9P/8etNY=;
        b=JsHeb9Mij94du2GpqkE3fQkuhHTpxebphKmYmMXr5M0eXrI+55wW6xxyJWNALnwRab
         KJwDex/O88T33E1w2DDrieQJwmlZfqdKNYUGAjYA27eDd2upAHS9xh3pg6GJjBMZ2n44
         uKBJ2QJ4D1JqpKc/Tpm7LvoueOPOXGluyxj7Z7nxkytdLhTMYKwLcRGW08Vpp022qE0m
         kGsYfDZbgdFPXcqgMeBlPv2maQmBIIPWPl4YVyNWNf+l3EFmpAKvXBdPzN1Yl4S6mbOW
         T+G6CTejGuBnsWEE/1chQA9ZzgbXdtoZwZtNpoKe8IeEw3RSy0IzxzJPlqfvqswf0+9m
         fviA==
X-Gm-Message-State: AC+VfDxlrPlY4SOAhk1qJtj5tqLiMRu7ZvWEhGlL1GbZFASmHvvDakVf
	aq/1j5qTGTPXQ1c4YRq0NTv2PWE3Gl8xJ1L6MkU=
X-Google-Smtp-Source: ACHHUZ7gwc/jkjRlVjHpwzT1u4y5IMyFOHYEnDBUueOVz04IhMv9WNJUyTIVgu1hKV5sLIk5Pcee5Br2y+E0OQbis5Y=
X-Received: by 2002:a05:6402:5252:b0:514:9e81:6185 with SMTP id
 t18-20020a056402525200b005149e816185mr2701109edd.16.1685707704786; Fri, 02
 Jun 2023 05:08:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230601143331.405588582@linuxfoundation.org>
In-Reply-To: <20230601143331.405588582@linuxfoundation.org>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Fri, 2 Jun 2023 13:07:48 +0100
Message-ID: <CADVatmPDwobeqntQ5+LQibMSHK86FmwUpN+E3JUd+GMs3bWpDQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.115-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

Hi Greg,

On Thu, 1 Jun 2023 at 15:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.115 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

s390 allmodconfig build fails with the error:

arch/s390/kernel/uv.c: In function 'should_export_before_import':
arch/s390/kernel/uv.c:204:40: error: 'mm_context_t' has no member
named 'protected_count'
  204 |         return atomic_read(&mm->context.protected_count) > 1;
      |                                        ^
arch/s390/kernel/uv.c:205:1: error: control reaches end of non-void
function [-Werror=return-type]
  205 | }
      | ^



-- 
Regards
Sudip
