Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3481215AF2
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 17:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dbj1UhM2"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5bda105206fso441744a12.3
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 09:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699290511; x=1699895311; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7zfoDrt1e9fCUXEtYpas/Vn47svbwQXQsu/mnzQxCLU=;
        b=dbj1UhM2pnFfFfGFsW8KOM4VjHUtO3DxaEGnqhtB9QPaPwd5XgctuudbsAcmfXdz2O
         8BIbCHDJkHF4AJtD6tw0RTwqd1bC/kGEjjHv4YSLQQa32yZX/6vqhAGXMesGkjYXOIuE
         6cC5y5GWxZdLVADizS1sm+jFzkU3sTZhIoTIP4J7FgWnNl9w1F3/eA+A/gYVPIO9kzN3
         gusphWXDCxBliUTJO1XDraGfTwWYqZdcf05S0SuHm0mgEb1KSMrh+e3asqwMMz7p93YB
         26X6vBcp6WfR7jz2sK5WYwzyBLMhywowqS/ZMGPmOyjiE0VFLKQoeDvm3ng8oakaKFVh
         wO/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699290511; x=1699895311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7zfoDrt1e9fCUXEtYpas/Vn47svbwQXQsu/mnzQxCLU=;
        b=qCAt/G7y8+HKhftyr04xcxD9y4qBAKbKdw+F4p80FPqzVmymtlBhY8TQhEpDTnQoqO
         BX8ASiTOfoDrRg7irysfzbDIDP5Zzs9ra46iXWD83IiXknNSk9CmW5kQ6KFGsh8fjmeZ
         34A0ok5FJTuVyc22cwaNIh8bl1aaruQ/OVcoSq76Labtvhnt9WnYKr+IFkP+MQQ+YKaW
         843XwEzsUUlqo4hjT4ttPnZ96CLM4sXEC1Eq8/UvfqZZnkwv/F1Iv6hNKGaSiRDOaiPL
         EMDSSLMgiQFVmI6ydcmwYX+XOhbpZ4qNfMYMTkFVwqi19RELRCKg5AVSWJchfv4aLL2P
         hKgw==
X-Gm-Message-State: AOJu0YyujGOtc4PmboLGiZsZsVbZCJTYpNLld44z123o/bRSvZ8E1U9S
	OBH2SDlUvJO757sKjjIQpWh045wiMDh0Jlc0oN8=
X-Google-Smtp-Source: AGHT+IGUg1ociNXol7xR6OAA0jZBUsIUoo8cClk/i/igaI4/ds2fB5KIC8oYFd7ZACVTHps5QDGjlL1HowmQgQhWo10=
X-Received: by 2002:a17:90a:1a17:b0:280:2c55:77c5 with SMTP id
 23-20020a17090a1a1700b002802c5577c5mr19651657pjk.46.1699290511444; Mon, 06
 Nov 2023 09:08:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231106130309.112650042@linuxfoundation.org> <2665d8bc-111c-45ca-a473-b1c892867e9c@oracle.com>
In-Reply-To: <2665d8bc-111c-45ca-a473-b1c892867e9c@oracle.com>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Mon, 6 Nov 2023 09:08:20 -0800
Message-ID: <CAJq+SaCqtQwk+eCgXT9jQU33Ufqr+aOaQq+VsXHCqdc1Qp8Vkg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/128] 5.15.138-rc1 review
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	Sasha Levin <sashal@kernel.org>, mizhang@google.com, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	Vegard Nossum <vegard.nossum@oracle.com>, Darren Kenny <darren.kenny@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

>
> On 06/11/23 6:32 pm, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.138 release.
> > There are 128 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> > Anything received after that time might be too late.
> >
>
> I am seeing a build failure with perf:
>
> tools/perf/util/evlist.c: In function evlist__add_aux_dummy:
> tools/perf/util/evlist.c:266:31: error: implicit declaration of function
> evlist__dummy_event; did you mean evlist__add_sb_event=C3=A2=E2=82=AC=E2=
=84=A2?
> [-Werror=3Dimplicit-function-declaration]
>    266 |         struct evsel *evsel =3D evlist__dummy_event(evlist);
>        |                               ^~~~~~~~~~~~~~~~~~~
>        |                               evlist__add_sb_event
>
>
> I think we should drop these three commits:
>
> 20a5799cae7dc perf evlist: Avoid frequency mode for the dummy event
> 7de783c81c7e7 perf tools: Get rid of evlist__add_on_all_cpus()
> 141ce9207068e perf evlist: Add evlist__add_dummy_on_all_cpus()
>
> Backport was requested here:
> https://lore.kernel.org/stable/CAL715WLTjMGQrhm6wWqFSeL_Oq-HzoQd5CqewvLRL=
v0Xbnibgw@mail.gmail.com/
>


 Just tested perf build, I see the same errors:

tools/perf/util/evlist.c: In function 'evlist__add_aux_dummy':
/linux/tools/perf/util/evlist.c:266:24: error: implicit declaration of
function 'evlist__dummy_event'; did you mean 'evlist__add_sb_event'?
[-Werror=3Dimplicit-function-declaration]
  struct evsel *evsel =3D evlist__dummy_event(evlist);
                        ^~~~~~~~~~~~~~~~~~~
                        evlist__add_sb_event
linux/tools/perf/util/evlist.c:266:24: error: initialization makes
pointer from integer without a cast [-Werror=3Dint-conversion]

Thanks,
Allen
