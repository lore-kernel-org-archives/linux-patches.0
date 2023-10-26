Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9AB199
	for <patches@lists.linux.dev>; Thu, 26 Oct 2023 01:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I/UcB93L"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-5a8628e54d4so3356627b3.0
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 18:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698283388; x=1698888188; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=u8mIrYZi0yJBTkfE0I4Tn+5fir+dZ0INB4+AMiyws7E=;
        b=I/UcB93LmzOhNRfXtQuOf/DJilLh0W9vHfgErGQSCzs9K4CaO8l4G2sDjM2JQIV84d
         8y7lrXS03gbJ2CQent3Q1LSl5lNtHbeKrhOuP2mcUGq7I+GS52+SiB11/SqxY525QlNm
         aTsc4GlQjR/qes7ZvDZtyOYNu5b2T8n29zqx9dV3caAltMEAs51WXbV+73ZUIQemdMsY
         m/1W/jU0ZRc9L+Fh04FCOtb+vuPWF6IAF/quHpGT5bkhrG84OW2L0V+VxxYf5WhR5QPF
         bPaGaxI0h/0nkX8ht39bM5Ah54uZ2tFLJSBQlMfk7C3hFiFlgQ62bBkB7JlGdJUey4lC
         ZjSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698283388; x=1698888188;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u8mIrYZi0yJBTkfE0I4Tn+5fir+dZ0INB4+AMiyws7E=;
        b=v0olrEzbwiCe/XZFQ/47JRt++hsTZIBUzfy19vQ4V6lyHW4LsUEeSlm2S61tdAw4k4
         IEONaJ/mKMiCDSwzyiOssj3LzFCvQCsc+B9z7CTsNZd8J3cP2CbaTYMlnWWXVFwL6Rjn
         YpOYYWbfVo6gvrkItGwq+cftHN5TwHHkorcvBf/dfttj6ixqBc2SooEfI6TtyRJH4C+x
         zW46vbpRQ+txx1d9f3BMoNRnoy3xZ5UQZmf56PmRxLnzpmZjsKJ3JhAp2xk4xZHvUhjx
         +/6B2ALnF7LskwFTm04O41ab4GI/piZq3a9dGZAYfGHlKY7j/T5Wewpwo9e8XaCQxvFa
         LrGQ==
X-Gm-Message-State: AOJu0YyTQufsts84rgIZhnWyxqOPbUrB602lAzd70q/SVZqy0zS3T76x
	gYaZDq0NauTU1vYC/hbaUiAkWOL7vAo=
X-Google-Smtp-Source: AGHT+IGwukaFvT8vY/voibhmBVtjgWzcSiUUw9BiDcENmNzE9Khnzsip0n0ndTjeCqA7hU1ggCVOIQ==
X-Received: by 2002:a05:690c:d89:b0:5a7:c887:43bd with SMTP id da9-20020a05690c0d8900b005a7c88743bdmr3072178ywb.15.1698283388461;
        Wed, 25 Oct 2023 18:23:08 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b190-20020a0dd9c7000000b005a23ab90366sm5535995ywe.11.2023.10.25.18.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 18:23:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <757599b5-aa8d-3915-230e-cea920aa0084@roeck-us.net>
Date: Wed, 25 Oct 2023 18:23:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: renesas_sdhi problems in 5.10-stable was Re: [PATCH 5.10 000/226]
 5.10.198-rc1 review
Content-Language: en-US
To: Pavel Machek <pavel@denx.de>, Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
 Ulf Hansson <ulf.hansson@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 niklas.soderlund+renesas@ragnatech.se, yoshihiro.shimoda.uh@renesas.com,
 biju.das.jz@bp.renesas.com, Chris.Paterson2@renesas.com,
 stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, jonathanh@nvidia.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, linux-reneas-soc@vger.kernel.org,
 Linux MMC List <linux-mmc@vger.kernel.org>
References: <ZSRe78MAQwbBdyFP@duo.ucw.cz> <ZSUy+zA0+Chm6dFb@duo.ucw.cz>
 <ZSU+GHl1q7T/TBp5@duo.ucw.cz> <ZSWg1fv3gOyV5t+h@shikoro>
 <2023101057-runny-pellet-8952@gregkh> <ZTgZa1ic1iFbdaTM@duo.ucw.cz>
 <CAMuHMdXQApuOPfU1zNKcHKN5=fCuLBSDiLtF06U7e4Tx0+noyA@mail.gmail.com>
 <CAMuHMdVrdmBgopnPnJK_ij52wz2WVBdYRHur2KfosFnT945ULw@mail.gmail.com>
 <CAMuHMdWZvTGrFgx_o3g3usOwkDvD2rw5QH9_ibo=OKdw17sAzg@mail.gmail.com>
 <CAMuHMdXvpiGQ7jqAG69Zo=10wV-E0bioC9AYUHwwhRGmLXygWA@mail.gmail.com>
 <ZTmP+WuZGKQQiYzb@duo.ucw.cz>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <ZTmP+WuZGKQQiYzb@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/25/23 15:00, Pavel Machek wrote:
> Hi!
> 
>>>>> I don't have a HopeRun HiHope RZ/G2M, but both v5.10.198 and v5.10.199
>>>>> seem to work fine on Salvator-XS with R-Car H3 ES2.0 and Salvator-X
>>>>> with R-Car M3-W ES1.0, using a config based on latest renesas_defconfig.
>>>>
>>>> Sorry, I looked at the wrong log on R-Car M3-W.
>>>> I do see the issue with v5.10.198, but not with v5.10.199.
>>>
>>> It seems to be an intermittent issue. Investigating...
>>
>> After spending too much time on bisecting, the bad guy turns out to
>> be commit 6d3745bbc3341d3b ("mmc: renesas_sdhi: register irqs before
>> registering controller") in v5.10.198.
> 
> Thanks for bisection, let me take a look.
> 
> I reverted 6d3745bbc3341d3b on top of 5.10.199 and that solved my
> issues:
> 
> https://gitlab.com/cip-project/cip-kernel/linux-cip/-/pipelines/1049624365
> 
> (Strange thing is I seen a failure on qemu this fixed, too. I guess
> that must be some kind of glitch).
> 

qemu interrupt timing is different, which can result in exposing race
conditions which are not seen with real hardware. Plus, of course, there
is always the possibility that the qemu emulation is buggy.

What is your qemu command line ? I'd like to add it to my tests if possible.

Thanks,
Guenter

