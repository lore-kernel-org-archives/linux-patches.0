Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512B7259B
	for <patches@lists.linux.dev>; Sun,  4 Jun 2023 09:53:12 +0000 (UTC)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-514953b3aa6so5030034a12.1
        for <patches@lists.linux.dev>; Sun, 04 Jun 2023 02:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685872390; x=1688464390;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iB2FRr+iV4uFJJk72mDgzFzP+Ys3k17GDqpjb9bxqMs=;
        b=nUd4cQ8v6H3eScmxHQqV++PApfZ3+7ucw1+5vtk9QnrwE/h3oDbr631cGvfsX6tE8X
         e5oAanHdF0IHE70lbzXe/qWD8hz5I5M5AJBULo10fDGyrXbBCkJipu9QlKQ2+BzdWmhU
         cS7vvRuk0Amv1fxl3AD5mIt4H9VewDstKSGg4MuHb4Ni7Oovn2EtrPNudIwdMvPQ3XfK
         rCoewAV02ufHx9id+DWo6oNGlyabQ1TTdPgprqq4mjKQo43sADuyoNi3P3gXQP112S+F
         ARBmyUwsfobuUKW+sIJ2wfG6a/GazprJy615u2ek4tXaTxh3zIE9SbdBK1anq2KLqzo1
         qLiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685872390; x=1688464390;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iB2FRr+iV4uFJJk72mDgzFzP+Ys3k17GDqpjb9bxqMs=;
        b=ZBPKkdtRiGHrlE/FsbVItYzviV0CDZ/uGHhMCpfijT7fPZbyRwLGJbbRrZOCnGvPh0
         oz8YdXy9AwEOw2lEdG+s+Eyz8pHy/XU/2n5u7uWb4fg7wLoCTD5ZwUg9DJDvAfstQe2f
         tuVIgmOIm/KcaN6Q45qZLeIB7KhbQdOXOiqaIKPDD68yWuX2LFRG9LinKu3l6see0lD9
         gl9oIYjuYd+a/2WEL29MYTjO/PnNaszZpKmqgNuMoxNOcXFRdNqEIdn1LNCOg/+EAQwH
         55QsQwbEojX1iTtyUzzkbvch4OMsHv03hvoqH9egvKJK4uLR3AzEPUGkqeVxsUTGijIn
         x02g==
X-Gm-Message-State: AC+VfDw1Be1Q4u37fu9IG0jo2B3E13FLr1iTYplLq0cXrp+JqBINa0l9
	v1y5oHR65FiMbSrWsSUWO9QOTrmQsH7EGV4nbUo=
X-Google-Smtp-Source: ACHHUZ58FUBQiGi5Ds9JmJwAS2B+xK7MFRStELAVOENnrCmJLi/I/KeBEk7KpaNp9+RPVda9PzvVF4wSqOMcfksQGlQ=
X-Received: by 2002:aa7:d657:0:b0:510:487a:ca3d with SMTP id
 v23-20020aa7d657000000b00510487aca3dmr5563421edr.23.1685872390104; Sun, 04
 Jun 2023 02:53:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230603143543.855276091@linuxfoundation.org> <ZHxNSQkgrZsyV6OT@debian>
In-Reply-To: <ZHxNSQkgrZsyV6OT@debian>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Sun, 4 Jun 2023 10:52:34 +0100
Message-ID: <CADVatmOVpK4PvcEB89PU7qCXhGxqJ148AtAkyS6JoKv4QA6XDw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/35] 5.15.115-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Sun, 4 Jun 2023 at 09:37, Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Sat, Jun 03, 2023 at 04:37:18PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.115 release.
> > There are 35 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>
> Build test (gcc version 12.2.1 20230511):
> mips: 62 configs -> no failure
> arm: 99 configs -> no failure
> arm64: 3 configs -> no failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> csky allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
>
> Boot test:
> x86_64: Booted on my test laptop. No regression.
> x86_64: Booted on qemu. No regression. [1]
> arm64: Booted on rpi4b (4GB model). No regression. [2]

mips: Booted on ci20. No regression.
https://openqa.qa.codethink.co.uk/tests/3695

-- 
Regards
Sudip
