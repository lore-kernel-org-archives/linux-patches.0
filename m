Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B7828F9
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 06:49:09 +0000 (UTC)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-992af8b3b1bso163236166b.1
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 23:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1688107748; x=1690699748;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DSXNPQ9cSE+8ldFCpxe5231qRGX3JF8PWsLfdfAuz3g=;
        b=gN9yewynNzWqCiLGduiYED62Y+JkiZXdvSBsfk+UJyJRAQfN10Z3+qWgVCuQU7emEO
         cKDfXXNm6Ic30Tqhpd1JTbj6Ul+eZbZzkVpq9OoLfchmazOSLEK8cvnRozQg8QvS2jHp
         dTZNMq0VFfNGYXiUNbE5KIX28Nc/Ajhu3uGPY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688107748; x=1690699748;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DSXNPQ9cSE+8ldFCpxe5231qRGX3JF8PWsLfdfAuz3g=;
        b=c2qoXHR6eNvqQ3ZdAlKeij9O0W8BQMkaGDoRaXa5U/arjwwq/bHP1H+cDnyo0uM04I
         /3UHR3u/CgAXru7Pymd/DB0y5F7kPb6JvD0qwKsnx1/hnDu0jvHa9y3gC/E8aQpjie6G
         7Tv8St747bKucXG/NrEUUFW6LnlHQMPUivPQt67p9P0StjhSdM4lO0UVmc5ygjbb+/Pw
         jfIScJu5Bu5tOk0DTcfSlUe42InEebduJplNr3Add7ustgW5bKSojOfmL4XDW2GHCWSb
         JxP1g5XAHkdHlYuegByd/NRGt3mEg+lAJ90ySGzliljqGZBXP1e1n+0p+jqePI87nO5m
         3kNg==
X-Gm-Message-State: ABy/qLZUv5B582Uxmfb0ropK3kHZk+zt3fa4NYIJvwFvk6PICX89je6B
	WP6OiKB11uaBk7Vy8XoEMSv5qMf6ZVEYjyo7V3xBTrM4
X-Google-Smtp-Source: APBJJlFuPsSYs3wmQJm6lsWOe3FKvCLrD4UXYa/6IdGbV8SXuiORgyMH3rOzjsAT3jA2c1qSa/m1ag==
X-Received: by 2002:a17:906:1910:b0:953:8249:1834 with SMTP id a16-20020a170906191000b0095382491834mr1203210eje.16.1688107747912;
        Thu, 29 Jun 2023 23:49:07 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id ec10-20020a170906b6ca00b009893650453fsm7810328ejb.173.2023.06.29.23.49.06
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jun 2023 23:49:06 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-51d946d2634so1635106a12.3
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 23:49:06 -0700 (PDT)
X-Received: by 2002:a05:6402:12ca:b0:514:96f9:4f20 with SMTP id
 k10-20020a05640212ca00b0051496f94f20mr795315edx.41.1688107745787; Thu, 29 Jun
 2023 23:49:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230630055626.202608973@linuxfoundation.org> <CAHk-=when9OgPprG57O+DtVFM7X9_wb6x2h4Veq4Gu6TUvxyiQ@mail.gmail.com>
 <2023063030-overgrown-unfunded-7523@gregkh>
In-Reply-To: <2023063030-overgrown-unfunded-7523@gregkh>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Jun 2023 23:48:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjm79krU=PJ372s5PzrbZ=kUDA16WMm==J4Moery3Uu0A@mail.gmail.com>
Message-ID: <CAHk-=wjm79krU=PJ372s5PzrbZ=kUDA16WMm==J4Moery3Uu0A@mail.gmail.com>
Subject: Re: [PATCH 6.4 00/29] 6.4.1-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 29 Jun 2023 at 23:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> I think the "crazy users" reports might be triggered sooner with stable
> updates than from your tree as well, so this might be a early-warning
> type system.

Yeah, I agree, it might help find any potential odd cases more quickly.

So just as long as you are aware of the false positives by syzbot and friends..

               Linus
