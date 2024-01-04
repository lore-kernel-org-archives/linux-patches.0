Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4045224
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 02:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="lRMyQnBr"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-28b82dc11e6so23983a91.1
        for <patches@lists.linux.dev>; Wed, 03 Jan 2024 18:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1704335083; x=1704939883; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VB51INjXiZAvQxQW5xjKyr7zrTy19sHnvauwLTdnqrA=;
        b=lRMyQnBrf9feEIDBndIfpKukOMoLNnX1ATs3wUFhuBkJ7XRyzBaieeYVi+5u7US+eB
         oUnZ4TsMq/jEgg2Z8cs0Pikf3rYro4R3PsD1iIYbkCKVugBOKDhbf/CAfGpGpIuL8XGK
         RrLLe4DF0y3bmGq66mXTyP5gLeEN/KVwG1LTgYcsx9LyB8YZE7LffRPaiIOoYcknDKzB
         WQ9qlv5KHpSvOfpi0VJ9Dawvqc6fDZiv3TxSXurJ3rIa29JYOtPMpPtz9oodD9qmGr8S
         wFJUNk/tUTdtRPYabODouFxGadYF7PjOLL8XNKr6+b1/MjZ9zZ35hWty6Jx6yMxP9WS3
         hF0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704335083; x=1704939883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VB51INjXiZAvQxQW5xjKyr7zrTy19sHnvauwLTdnqrA=;
        b=QSPaA9Q8iHmtXKTz7c6siczZpUdY8Iy02SGIOCUX2ChxG9XJtt8a4fgfU6+ehCsR3U
         Agzb08q0xMTfZd2gpXifXVh0reHzHThK/bUJWw5yFDRf1f7bdIzjpZqwDIwo6dqaeBWK
         oDbTPSlHCjkpyFl80XZLsbYa1AHh7zlpWf7DtI4rRJe1mDvSi8RFkigYT4F3xtO0PMs3
         nDofMg/FdaMaf74PAZFbSi+u+Q88e3r38kn/TU3VPbLlYHJisVcI7DUbI06abaJJ4JLG
         l2Uj9pZSEgRPhpjjw0L1754WbzvC0sVzg7qAFYMhVY2AX3H12/XRDErVWjntt/CIYhhT
         jaIA==
X-Gm-Message-State: AOJu0YwLhA+E93H6sszHadYlrjAGzwSFvJrAA0rfATaeYx+vWi4eMQqC
	geNkZb8wfjVmCBMdVyy6gcXgRzBHkMxV/zs2pDyiUasj53WVFw==
X-Google-Smtp-Source: AGHT+IHwcnvw7WqGDCzzJmUK7XaNnwQlpCfti485n1GWpO3JJeg96VGxHxoTNad+Uelm7salPKt03E1s/Ox2oTQfsl4=
X-Received: by 2002:a17:90a:ad08:b0:28c:2614:2caa with SMTP id
 r8-20020a17090aad0800b0028c26142caamr12231pjq.17.1704335083230; Wed, 03 Jan
 2024 18:24:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240103164834.970234661@linuxfoundation.org>
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 4 Jan 2024 11:24:32 +0900
Message-ID: <CAKL4bV7uOrnCVjKQp7rZ-KBtpV7sxpxHMc_6B0b3QiiHcrM+YA@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/49] 6.6.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Jan 4, 2024 at 2:13=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.10 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.10-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.10-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.41.0) #1 SMP PREEMPT_DYNAMIC Thu Jan  4 11:03:04 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
