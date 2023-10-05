Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4071266D5
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 19:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Dc3Juu/t"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-49ab6c1869dso1637414e0c.0
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 12:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696533666; x=1697138466; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V3YAwa7B2OJPRUP59nwxn3A11jwk1jGLcSNDbqpCUEs=;
        b=Dc3Juu/tzOVz4L0it8MjhBMW22ZI6k9N6tdImTOHrMI3Cx6tZS0y1bpSalrf8WdvJ3
         cjY3bAw9lukqDHs0BRmnSsSgw92yO9G2/4mH50j2m1Am5o8qzfkp9LB2sVEAMUVRf+jm
         Aq5x85kZkGbrB3fjR3z/iBsOWbXpsgid2flFYUvjD1jV+krJNvZSEc8bqP/daej9zLBk
         NUI5RYgd0GyPzlhPOzuMDAK9GoEzR27dXIIdUrR6uSBSuzLZfr6Q6gwGIicy1bABrPTA
         u2gB4i3LQeR9rWHpxiUvkn0jacgAEeveGb0/s4YT8gglTgelPJT6K9iEZkAoCeiWdLER
         bl/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696533667; x=1697138467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V3YAwa7B2OJPRUP59nwxn3A11jwk1jGLcSNDbqpCUEs=;
        b=G+1mZFexNwCPL7QMdgGPuqGh/u282B+RCaCifZ+4kg+KG0mKNanWhchUzxoxUob2Q9
         rg56455bYOoPJhwnz0phK+SxXHpV45MrTOgNlE8k7XU5mwSkLclaoN3+FnR0gMo428e5
         DGozINlb2ohm7fC4vbVwqEoGFwDkw9gnilHwN3qzb4FBicbMQzDuV5IcNWVOgDRot80O
         jgx+lfYgZhFIP0yQLt7rbLQjN9EAWEyMa02RiW3uwX2Ig8Avxaii7mZWOTh1BDqUr4/Q
         4S/Q6cZ7+yapYs9BRbmRxqcyHzuiYVOhe8qbV2TBNzcsDho5FjTfr4c0MWrgCUwATZ6H
         JT1Q==
X-Gm-Message-State: AOJu0Yyd+MklyNJSrwYSTm3QGA9l5ZVXfmBf2+wV//yrnC1AmhbBIJhP
	xNV6bJq//N9mTP8T3pWSLZkdsl3lD9fAxhwzzvSReQ==
X-Google-Smtp-Source: AGHT+IFhEXUCf6hg0p0VkgiUHPuy9O4n5JiWEsbvC4N0pJ6GZCevj6BKaE5f4ZMr3qR2O1q/atILq+7gURY5Qemu1P4=
X-Received: by 2002:a05:6122:4201:b0:49a:b587:ab79 with SMTP id
 cm1-20020a056122420100b0049ab587ab79mr1292189vkb.8.1696533666626; Thu, 05 Oct
 2023 12:21:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231004175217.404851126@linuxfoundation.org> <CA+G9fYsqbZhSQnEi-qSc7n+4d7nPap8HWcdbZGWLfo3mTH-L7A@mail.gmail.com>
 <20231005172448.GA161140@pevik>
In-Reply-To: <20231005172448.GA161140@pevik>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 6 Oct 2023 00:50:55 +0530
Message-ID: <CA+G9fYuyXgWvsRhznP2x2VE5CvSyCCgcvxPz2J=dbvg6YW2iUA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
To: Petr Vorel <pvorel@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-nfs@vger.kernel.org, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, Olga Kornievskaia <kolga@netapp.com>, 
	Benjamin Coddington <bcodding@redhat.com>, Anna Schumaker <Anna.Schumaker@netapp.com>, 
	Trond Myklebust <trond.myklebust@hammerspace.com>, LTP List <ltp@lists.linux.it>, 
	Richard Palethorpe <rpalethorpe@suse.com>, Eryu Guan <eguan@redhat.com>, chrubis <chrubis@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Oct 2023 at 22:54, Petr Vorel <pvorel@suse.cz> wrote:
>
> Hi Naresh,
>
> > On Wed, 4 Oct 2023 at 23:41, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
>
> > > This is the start of the stable review cycle for the 6.1.56 release.
> > > There are 259 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
>
> > > Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> > > Anything received after that time might be too late.
>
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/pa=
tch-6.1.56-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-6.1.y
> > > and the diffstat can be found below.
>
> > > thanks,
>
> > > greg k-h
>
> > Results from Linaro=E2=80=99s test farm.
> > Regressions on arm64 bcm2711-rpi-4-b device running LTP dio tests on
> Could you please note in your reports also LTP version?

Sure.
We are running LTP Version: 20230516 for our testing.

We will update the latest LTP release (20230929) next week.

> FYI the best LTP release is always the latest release or git master branc=
h.

We have two threads here.
1) LTP release tag testing on all stable-rc branches
2) LTP master testing on a given specific kernel version [a]

[a] https://qa-reports.linaro.org/lkft/ltp-master/

- Naresh
