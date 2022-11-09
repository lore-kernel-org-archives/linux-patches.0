Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6872FA463
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 22:07:06 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id e129so17378236pgc.9
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 14:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iw5S3C75tN/oGViY8ItNjGlumx4biWxjIIT5f99rcI8=;
        b=kRKJwoIzfYQ/DWIm8KSUaZ4Ro0bDtgjRpwb7yY0HH+jZHaujlpp0j43JGV1jtKLbXf
         YWQe6oMBenkCa4M1iJtKSv0M5JtJvkWWYtp6RPjnRwmPCBHhoQo6dNmgO8xJPnSlA429
         J2dp+3cMGwOqunwxv+fMFpFbOPTeZboGdvylHh/oMSVEC5IlhNSdrpNwA6EVkOt4hRMd
         8kaUw7q36y0iZc4k17BeX5lASGLa4Gx7TLwra+8d6HgQnuZlL8tp9+rsf77WGLH9jXht
         M5fTLPm5tkibU8REXZZfJxFOGHBWXvZE7jKkSRjwOE1QdLJ6y23ggQbuHWQeOch5XcGc
         XlhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iw5S3C75tN/oGViY8ItNjGlumx4biWxjIIT5f99rcI8=;
        b=NI0IbW5m5BEnoXhLZrip1RB+AXTHdc1Z61aS4ftkd9HQrN5uh9Q90ZkT7nSwWrea7k
         iAuMZby5fLwi+8OxMNGWwmsjuNVMn2PKmMcVtDH20VOXuONrHzwOWL3Kizz11GEiI0Pm
         ah9r7IMnsQDdXYGAh2u0td/axHMI4Mk3ZFV/q4VQij+JQWX0iUgyZSmzok/sSqH+jiCR
         cSCNq0Tu/VUShEFyV6oNoTgTgUB+OkwCDA7RnqD8kjJwEKPvUHwVBTAvYJnIsBML/RQS
         iihdj7rWitB2/CZw00Rbfzd+aVaeZ5exYhI+SaELF1TevKnz6d/HnB4j0Rkr5ChEJGQF
         Rfxw==
X-Gm-Message-State: ACrzQf1z8vMDLnx3zlmn8U9FtSJ73obJTYAeAEDD5g6JumkFLTJuNeHl
	6BicnbOdSmo2OSdlfyTfXOyAAxxCddbir4tdtpU=
X-Google-Smtp-Source: AMsMyM7Q+Id4Z7/MMoExlaIfDv+7Yd88p8dRT/wqu4p3TYsopLqogJ8/a9QHDZpDUfikABiFJVuq4sT58bxn9452QOg=
X-Received: by 2002:a63:ea4c:0:b0:46b:2772:40a4 with SMTP id
 l12-20020a63ea4c000000b0046b277240a4mr52259052pgk.342.1668031625779; Wed, 09
 Nov 2022 14:07:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221109082223.141145957@linuxfoundation.org>
In-Reply-To: <20221109082223.141145957@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 9 Nov 2022 14:06:54 -0800
Message-ID: <CAJq+SaCw85ENMx+QNimuckk46eU9bwf66QmuK_x6GnWMGRA5-A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/117] 5.10.154-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.10.154 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Nov 2022 08:21:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.154-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
