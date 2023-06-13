Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0982915
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 09:45:47 +0000 (UTC)
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2b1a46ad09fso64499481fa.2
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 02:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1686649545; x=1689241545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8SpYglX3xZWy5x6JjxtuTN/FRZavJqUKXS8aVqhebYk=;
        b=XZdZk9shQ71u/141zS/u087WEwIiXiVqoN5KykFsUDzUgnGRIL2wqNn2WoNL4E4t9q
         lEr0qAN1yOObjT0sr4ONuHCjhDcE03RnnLuVTjtiHeXQ4yrRSOp5eUV5WV+DULDJ4DOd
         zFiS7+1DQV6FeRResvIBtMnU7swr8DniimFgP01bMtuezbDe6C+QWZeJM6AsRMXd5dr3
         JexylTYCI9Khd25mb3PJxRLkGzJS6J6LsXtGUTy81YZ4WBL1ekCFtC8JzjFFED8+Z+f2
         UVFlX+SXon3VAqzVtIRaoWVYpfMWQP9FVKhDYR+dQusQqDuLqDJgH6bIIHAKHujjTlp3
         j2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686649545; x=1689241545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8SpYglX3xZWy5x6JjxtuTN/FRZavJqUKXS8aVqhebYk=;
        b=Sz253GtmJB039KYp8w8ikaMPVf0l+Qs0pCsSoAwSh2smBcS4tklSJ61Av2/WJYWas6
         7OgCt++mMMjfkhcXhN7oYPRKXfxvdGFPKrp4ETf4Fz4j4Dda9zfyrxCnhCvSgzQHI6GI
         IF6+VWqImwqWJ9OT6geHqC5TFqz/0VQ1F9tV2YGegkUzXyFbBq4TdXEW5FoMgIvjMN+J
         kPpkosHtIRYXBIGCck+Te3wcn+ZRU12uuqK0kmGSqE+AVDMam9Js+89P42rn5mdJ5adW
         ythRgfFHFNKn2cdFRLMweSVo2Tuiew7RKruTj/UUym0LZHBZyQXXG5JaKa9sAFq8wuSZ
         fU5A==
X-Gm-Message-State: AC+VfDzVN2ytiTGRDWrrD14Fo3OZBix/Xn3j7rak9TgRu5Vt/lWfXuYy
	s6Ny6ra47BQpclhGoZQ+9enzPB7NyFH2nlLK2rWaZg==
X-Google-Smtp-Source: ACHHUZ5cFzMVREFQr4SC+vRlo8q4itfT6Lyp/yPulI7nR8OW7RQeLvlldVxv4pJyEPB8r/jXc7ZKZr9+unN9EIxlpfY=
X-Received: by 2002:a19:4f0d:0:b0:4f4:dd5d:f3e4 with SMTP id
 d13-20020a194f0d000000b004f4dd5df3e4mr5367991lfb.26.1686649544710; Tue, 13
 Jun 2023 02:45:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230612101710.279705932@linuxfoundation.org>
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 13 Jun 2023 18:45:33 +0900
Message-ID: <CAKL4bV5Kvn7bAwChdpmiA7ONJ8bnDYCNFJTxqfs_dYfbTzt38Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/132] 6.1.34-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Jun 12, 2023 at 7:56=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.34 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.34-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.34-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
