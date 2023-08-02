Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3271063B1
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 12:46:25 +0000 (UTC)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-51cff235226so2018028a12.0
        for <patches@lists.linux.dev>; Wed, 02 Aug 2023 05:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1690980384; x=1691585184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jPNTUnEQLa/vby68PUQOq0gidCidKmFF2Y70Baz8cg=;
        b=Y/sN+v9e/KjFR3mHRAQJs7ZXEWv/HN8IJxocaNZrmUrou/Vfoah2wKf7LegCZwT2e6
         5wcmbTbByU81XUuM+bGm3DLUe6HsWj4YiY1rhTJPHW+7dkHjJyE7LeaubYV2fm3eWcut
         FN6rwaB7QV3Bafw7RPfZyB1qH1FIIH+vekFB7KijWb9WPRuJHkAbfHvPBY07JLp1mbiK
         sXoQW1hR579ea5ZtccrHX91aR2LjH5sRuYwF6HowWtSSV3JIwIVNu+XkJ5iCd9s3vFDO
         KKlsLN/+0CFE9lfBeTPeAUjWvYP2MWXTKU/tj9H32/MtbRCNvh8SLVRZ8rrxhZWz1Je5
         b4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690980384; x=1691585184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1jPNTUnEQLa/vby68PUQOq0gidCidKmFF2Y70Baz8cg=;
        b=RmioX5RNVWATRRJC8z+5vgbjMOPrUUpmethsyqql0GMrlDdqC8wnCi9DZDFNunUptj
         jWh39oIePXzwPuXbWcab895winzXDRs1F0Gzp1WtcAM4IbyRPXzp8L9PxEzl3FNnn38b
         z0wkqMCUraxKmljDmC6YfJ87WTzPBElLyQ5gr0dTlVL+0XKH+Drt7tM2JPrtWZRIPu6B
         taYvXMBvWN50ezOUJERpXzdW0pQk4TW6kiAY75eb1qZ0J9kpM6nGqVYMS+dbwlNZTrd9
         3VpJGC03BtkS1KERj7qzMPmhoDssCIjhmQEBHeTh0oYrxkPrL0dM/p/h1+dze0lKw/Db
         uomg==
X-Gm-Message-State: ABy/qLZ8Y2SbE4kVrSFx8OK5XSVvF5c7EvLHmnFMw3liTnQ8myExYMYr
	ligrXFoQ0KKHem0KSaCqwTik8p0CwQhE+xNdl2/cBQ==
X-Google-Smtp-Source: APBJJlG6MH+8DtLRZ0WDEr8YewPHyaBOyzfa56SZBQSo3KmJOimYMnNRDNJs1dvfRqY+rJfMJ4O6XPXbj5Ej1gME1UA=
X-Received: by 2002:a05:6402:518b:b0:522:ddeb:cdcb with SMTP id
 q11-20020a056402518b00b00522ddebcdcbmr5854329edd.18.1690980383950; Wed, 02
 Aug 2023 05:46:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230802065510.869511253@linuxfoundation.org>
In-Reply-To: <20230802065510.869511253@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 2 Aug 2023 21:46:13 +0900
Message-ID: <CAKL4bV6VSG8rsu2tM8A9Mrp=khz33YxTMkx53HZytk4Z9izJGQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/225] 6.1.43-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Aug 2, 2023 at 4:44=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.43 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Aug 2023 06:54:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.43-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.43-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
