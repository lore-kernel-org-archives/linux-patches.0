Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7705B2D028
	for <patches@lists.linux.dev>; Tue, 17 Oct 2023 17:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="beInYiYY"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5892832f8daso5381322a12.0
        for <patches@lists.linux.dev>; Tue, 17 Oct 2023 10:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697562098; x=1698166898; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVk6JqAcC96nmoEP5CbFtt2U7U2MiyM1ZZJce8WrKz4=;
        b=beInYiYYuso7a56H+TyOSsGBfZSR7CMOvKCBpjSNHdvuTAfPUUdr8AfEfKfz4v+GS2
         fUVwO1vkSv2Q8hg37iLBIDLOzpTj2RYmQLQoOhSRiRA6oJ7T0JC1q0H9e0biz6Hxnaq6
         yZUIC1hF82NeXkj99IbHZA3CZAQXP0UbussIQ/B9yrxMssXPHR17Bofy5E1i5iOImFi1
         5+hIiglXuwWDY9PkD/1uV5YRfHlSu2+YnCpZqckf7UZnyJEp4xjygyyJn30n2oTwe/+8
         vaE6BsY/WCc0TRBGJXLrKRxh48OFCmX73191Q2YRXd1562HxQY3LJGaxgwSSQ5+bS8iD
         rIdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697562098; x=1698166898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZVk6JqAcC96nmoEP5CbFtt2U7U2MiyM1ZZJce8WrKz4=;
        b=LPzMSHiuvKevyzgCmm0Za52IVkwICg1Pet0nK4ZSnAVOVTGsImLKGivabJlHQrBC9/
         cceAl8aFe9OQhaMexpK0naAJCh21MCni71cp7jfZS2ycEbT2Naq+QI+CWiCkW4ZvofL4
         Fi1vjJB7xMvrxoZW5BbT0RbQOFwK8jTsgQleo/8SFMJpQDG5L5PL1oRvFFTUdkBnZwg4
         TzwqsJv41d0OHseGBn1Yxe2qMvpH+ZH0e1gD49OLOsoOrfUae2mxqmnjr0a2a6RtlR3g
         Owt8/T6UimWk5vJggs9qcvBajoubP59ymr+8AQlS3pMowf0tvXUVGOH/03Jyi491zKBq
         8uuw==
X-Gm-Message-State: AOJu0YxzJC1gL+9NaQLjC8cuHmmTSFe74DcjxGC8fVaReghJzn3+OhkV
	WKKlo7urJ46DRKuGVVevuXfRN1WYluEsehtBzgjf5Q==
X-Google-Smtp-Source: AGHT+IFDk7hkhX1JWt5UM3OF7m5iDhCPicJKdhd0WXX/tzKf/H3qlErdWc1Aw853TP5fbSf6Lfycu4M/E9Est0yqpk8=
X-Received: by 2002:a17:90a:6d43:b0:27d:d9a:be8b with SMTP id
 z61-20020a17090a6d4300b0027d0d9abe8bmr3758897pjj.6.1697562097547; Tue, 17 Oct
 2023 10:01:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231016083953.689300946@linuxfoundation.org> <a01256b5-6082-4d17-bf4d-310e7b4f7a47@oracle.com>
 <2023101641-resource-scalding-3e1d@gregkh> <43ad9708-47d4-4113-ab05-6012cb7c4d6c@oracle.com>
 <2023101655-throng-rickety-ff79@gregkh> <fb1ce733-d612-4fa3-a1e4-716545625822@oracle.com>
 <2023101716-sporting-geology-2de2@gregkh> <2023101719-anteater-deviant-bdf9@gregkh>
 <8cd1f099-b16e-4db8-91d8-ae1ad974bf08@oracle.com> <2023101700-symphonic-stretch-b62b@gregkh>
In-Reply-To: <2023101700-symphonic-stretch-b62b@gregkh>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Tue, 17 Oct 2023 11:01:25 -0600
Message-ID: <CAEUSe78K_CJpr_=UhPC1h-A+q7Qizj9zY=zsf6_PBWzaKYLwxw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/102] 5.15.136-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vegard Nossum <vegard.nossum@oracle.com>, 
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, stable@vger.kernel.org, 
	Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Tue, 17 Oct 2023 at 10:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
[...]
> And yes, I do run newer compilers and libraries, but the rest of the
> kernel builds fine with them (I make sure of that), but given that no
> one seems to care about perf breaking for so long, I just apply patches
> when they come up and don't have conflicts and see if anyone notices any
> difference.
>
> Normally, no one does :)

Just for the record, we stopped building Perf on these older branches
as we agreed with Guenter, for the same reason that you said before:
it fails all the time with a variety of toolchains/architectures. For
now, we're only building/testing Perf on latest stable (6.5) and
latest stable LTS (6.1). We brought that up at the OATS call a couple
of months back.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
