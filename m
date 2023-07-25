Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191E721D47
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 14:46:19 +0000 (UTC)
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-4470837ff8aso1645787137.3
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 07:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690296379; x=1690901179;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2Cq8IRyozLb3SkglqS2g2LxJsUZMe4IMho3GgyuMdRU=;
        b=hWC2i6Wfc9ExzCeHJuPToUeC55mGwCFWGK1MpnBJ0McMw1PMFbbzgAk3q/LTYB7Fqz
         TLh8pSlwH6t4e0++ulLAh7BDOfDonlpVRKLR+7MIHhhxC3c3tS9COvCevLRtIrGj81r4
         wRu1GZTzAsjQ3ouFIJAiEfq24Kn63pLQn+u+ijdHZmpNu6RQkSeAOlwCsACBpE1TttuH
         xQEdqrD7idd5unTj6Lqd3yvU7L2lv7DxOyzhQKZtMqwlS6mdQALBpxLPYwwhrSb71imA
         WBqa7UlrgHaQLGcaeFiy4FxLkGWEQm2qT+Wh6AwhZs+/nDaP+YV6+Pqnn9oT4ITv+d5t
         BEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690296379; x=1690901179;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Cq8IRyozLb3SkglqS2g2LxJsUZMe4IMho3GgyuMdRU=;
        b=VPneH2CGIXTStjIrE8/4Ibmgfa7JqhAO5/svUiYd0OUoFUvWRUH1UXnyhccmUY3OSf
         kdoptlHyNILhneM1FUUdQwrZ6E0ud/g6UnvB34+Q22MK1Ce/UXp8tIaG5+M3L3NG8KVi
         by7p5oW9yo7aHg1JwnOLyL/oeTnqWgtTcrmSFPkXylX+igCTcXHP7XHPIGVyZV9aVqM1
         0ntabpeX+E+KT/u/Ua0Gev97HRwvBuF/CPqmR//yo+42oySM0luaxDr6THnj7J86NA3K
         ii1zUAUSaoK5cSFj3kUUikvAHmasZzfcWyBZ+Azm6l9fxS/4YU/GU7E5Ao1XZI+MpTOy
         NZ0g==
X-Gm-Message-State: ABy/qLa2njI6nW5W0HpyXvfn3EvAR6X+5F9qIjbYYqKPjcjYASeZSEI7
	I5NxLUMoCDzv6xWMTKaqlDwC3azn4wMoxMtBA+iWiw==
X-Google-Smtp-Source: APBJJlGD9MLvai2uEROAGRTZfkLteWGpF/+3RQ9alRXLmAndP5qKwJEuzTsMN9Zpyasazxry3jvFwHUkoqyeQarSPUU=
X-Received: by 2002:a67:f999:0:b0:443:5f9e:9864 with SMTP id
 b25-20020a67f999000000b004435f9e9864mr4879919vsq.17.1690296378788; Tue, 25
 Jul 2023 07:46:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230725104521.167250627@linuxfoundation.org>
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 25 Jul 2023 20:16:06 +0530
Message-ID: <CA+G9fYuH-jyxJwgEgX4J4+eh=nEEk9aqt4YPNUW9j==mwtw=jA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/313] 5.4.251-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>, 
	clang-built-linux <llvm@lists.linux.dev>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	"Theodore Ts'o" <tytso@mit.edu>, Chao Yu <chao@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Jul 2023 at 17:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.251 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.251-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following commit caused build failures on stable-rc 5.4 and 5.10.

ext4: fix to check return value of freeze_bdev() in ext4_shutdown()
commit c4d13222afd8a64bf11bc7ec68645496ee8b54b9 upstream.

fs/ext4/ioctl.c:595:7: error: incompatible pointer to integer
conversion assigning to 'int' from 'struct super_block *'
[-Wint-conversion]
                ret = freeze_bdev(sb->s_bdev);
                    ^ ~~~~~~~~~~~~~~~~~~~~~~~
1 error generated.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
