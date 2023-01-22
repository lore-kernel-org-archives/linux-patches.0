Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F7E138B
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 22:54:33 +0000 (UTC)
Received: by mail-ej1-f49.google.com with SMTP id az20so26394046ejc.1
        for <patches@lists.linux.dev>; Sun, 22 Jan 2023 14:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bMkGNYI/fHgvu0vw4xYIcVeU8+WBV4ArAcWUlG7Zc2o=;
        b=PhbxiQNidA1tVM9zIsUxDzkyQt3k2tOeIFAwnqAZCHMBaURy8ctAh7ILXXj/0yVKri
         Wnkgyj0CH3noCfHnCIbGqpwuR1rGov1STqItytgKUxnmeyoc/CJsm7BSugtzTo87ps6A
         pRPvtIg/W3GWpJaqcdqCFDjxJ/+AyDHBcgalCQbkiAMuGykgKZk61PtZKiktPANY4nYI
         pVF04va2QHggKOzLDmsSloSXOA4Z5y06Cs63FaNZIwGf3OxH57V0PosDCHquEuais7OO
         pQ4kK5HVyY/4cq6mx9qyzuYpb+sB4cKgx/acsyK60rnxy8jZ1ZTYULwj026kUauUijNT
         aUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bMkGNYI/fHgvu0vw4xYIcVeU8+WBV4ArAcWUlG7Zc2o=;
        b=AHL1FGWPwXIXuqPW0MwYHY1roeP9QZJqyKkYQLQBLpgu72OYUj0N1uUcXt00bJ31xk
         7mfUmH4VP41iKCCjvFgwe9WM8KJvYJd+UXilGL/64lbsIlDUxTXX1+00KSSaEFBzX9/z
         Bps09JX6DI7xYh+Q30NrnylUDi2UCeZQtWLtHfB5j+0SJAWZ08dZvhYSYqxo6eKKjyOQ
         RSAn8VS64t1OP0TYaXO7vjeV9P/J92SNeAobLMx+jRBIXDv19wsfVr4euRIdIizmj1F5
         16j381T7QQri4EJE4uRXL47Tjs8YHkXU8ACsV4GNrhCDGGYybbEt/5npvdE9LtpUI8Hy
         gMKA==
X-Gm-Message-State: AFqh2kpD+YS5QNo4ditBsR+gNl9xc/3qRtuSEy2DEPjCaqqYIGa40w4/
	PqPQ3RUjKqBkR2IOLXjL7Je9ul/Gj8/XvQWgNNYsCw==
X-Google-Smtp-Source: AMrXdXtuKaI+bneEJSDWwLYwvpPi/J8MILQ3ySzWME8Ff5KKH//OwvdRHAbh7G4hAX7a5pt/RGPao3aXP7XV8QBdi+g=
X-Received: by 2002:a17:906:df49:b0:7c1:908e:709e with SMTP id
 if9-20020a170906df4900b007c1908e709emr1860050ejc.414.1674428071778; Sun, 22
 Jan 2023 14:54:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230122150246.321043584@linuxfoundation.org>
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Mon, 23 Jan 2023 07:54:20 +0900
Message-ID: <CAKL4bV4D+woPBzYXRhTws0S3zqgzuracc52bNT3EyHLV5zLkwQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

Hi Greg

On Mon, Jan 23, 2023 at 12:22 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.8-rc1 tested.

x86_64

build successfully completed.
boot successfully completed.
No dmesg regressions.

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
