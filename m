Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA48246BC5
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 13:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214876; cv=none; b=RToe4TMMg1CTgDsLoTsGKdXK5FsYZh8PhgLEao3R6lsN2rAixbFhCOePxFynPmCoGuVlJ94d/X+bQFRwGp4lNWsRLe/SSwFfqhLhJwVFQiuLLeC1fG4MsRha478nvhku6WnhWNiVmwy6YNJLYMrYoqxweAyQdKMDJLAIG66pdZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214876; c=relaxed/simple;
	bh=xPc5VouSLZAk6rtzQm+iCZVTSD4C5Pa1mhNOLz1cBgQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XsgfWVhH8+dOpYeOzlU3yFJgiZS8/Xj4wWl6f+xFuqoq2gVngJuJTtCSCy5WOyfHY/tJyoRBudS6Exg+ByJdYtGic1scsWiLp7rJrqIofsM01QJS55ZsWOEqZgEXp7XtLIiwSBuJDG+8voqnjMjKidPw/sn+biT868vdcZYybao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=VNNHrc0G; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="VNNHrc0G"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-246ef40cf93so15694975ad.0
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 06:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1756214874; x=1756819674; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVZs1Yt4B+M7h5+3RE2O89FKpxSDOyOXZc0rIy9h7QY=;
        b=VNNHrc0G3B20BEmLwHNAMvWnY6wYqwFh6JkRmg3PTw75KNat4YUPfnvlFYDWjW1i5+
         8lGNoXNIWC6Dac6+qUcdxbhmc8c/xxAN9NuRo2Fc0UVVqXAXRoy7210yOAyiDcBE3WjU
         AKja8bwkOHWs8826OItFSftiV3oddAkL2S1Yut4Og7vITejaV8kBZxFGQ+/SE9lXYVDg
         3MOEir3Ylsnwi8RU7qreCRMiiaL1334bHbzXrFE+6CIQtasNbSFM/toeoriOergRDCA2
         Wf0Yqlj7qQBn0HrunybbUrjO9RXxlQ0bQz9vNjZAE1Nn0VyUTAh4ONqF3u6mHbpPOPUu
         ULOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756214874; x=1756819674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KVZs1Yt4B+M7h5+3RE2O89FKpxSDOyOXZc0rIy9h7QY=;
        b=ZdqhgfGkCxBLjKZ2Bi/yqYL/0i4VqLf38U02SxpfHnO7TMFtgMWRJI+WzWBzMq2skp
         ZEDyzkrkZrOz4GUXxlREDKSkaWNsfPOsq9yHZTuamrZ58czoAuyGRQVQbut+Ip+fMJiK
         ROwH88l7uPJjY6j9pPmeSD+rUEGW4TEGjK23m2itgK/Bm9t4YQj+L9/GFm7YeH9mQKpa
         ef2IxMbOGjjQFyB4d11RnnihSvCHq5PrHaTzs4JEJcVA6mIshI39N+XNTMH0FCWRteA6
         g3EHhXjxUrgo3epB/U51iiJg2cPb3e+WwySkhTzG2bdvgAdCMWKcFV6GJyvXjcJwQyd0
         Bf1A==
X-Forwarded-Encrypted: i=1; AJvYcCXrE7LQ+pUqAzMRMCkM0qmAqIxAnWI61QY5UckhAgMpgdEo/XRsFOZmk7xqKMhX1Fe5zX9bJqcu@lists.linux.dev
X-Gm-Message-State: AOJu0YyD+iGWfZv989ougeAeLlfnB2SMtI2B8PDWPCcjvP/N+Ezvupo8
	xxoBxjezlr4ELcAyWDdyr3lnOLyAu3NEz+Bhg30V8zYWxOtuS/bW8+upayv8M0I+0ZdGFhQMk+L
	ctItE6MkBIxZRdsRoqh8Pxtqg9oPjSlykuHdd+owKNQ==
X-Gm-Gg: ASbGncuOCadBs63zQy5bw4rvjtLfbCIM67Tnao8Q+6tnH4bEir80WvIxrXseu8xmMrk
	3F/ZY7qfrFUW2zJTn18N/LDokPdMMh99m8MpGqQj/R83N7+J1gWb3uvKJX9rT2ZuiOlmf3iqLoD
	FjDit23++Nl2SRYv8d/nCRbMw7hTq6046XWA2gibFUOEiA8Erru07bCW4zhu5lakcZ1277JMuNh
	EJOEuo=
X-Google-Smtp-Source: AGHT+IE2SVk4t97EhOugJmDZ3uaQs0E4tn3j9laRwvd64gm7WJAI+S2PXD6GkLMAVmz/RilHosSphia3Mhafwg0GRug=
X-Received: by 2002:a17:902:db0a:b0:246:f123:ccdd with SMTP id
 d9443c01a7336-246f123d18dmr59187785ad.8.1756214873982; Tue, 26 Aug 2025
 06:27:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250826110937.289866482@linuxfoundation.org>
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 26 Aug 2025 22:27:38 +0900
X-Gm-Features: Ac12FXzRfFlBpNNsy7AVluxhNzcPDiGjNZum3e6mUgmwnrD5CHykobV1b5JZI_0
Message-ID: <CAKL4bV6_QsjosQHz-vVzwKBN2Zu=vc7QwEM0djuipP=g77d3_A@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/457] 6.16.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Aug 26, 2025 at 8:14=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.4 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Aug 2025 11:08:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.16.4-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.16.4-rc1rv-g2894c4c9dabd
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Tue Aug 26 21:54:15 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
