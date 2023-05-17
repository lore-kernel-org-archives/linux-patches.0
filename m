Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0DF101F9
	for <patches@lists.linux.dev>; Wed, 17 May 2023 09:42:00 +0000 (UTC)
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-434839b4544so136643137.1
        for <patches@lists.linux.dev>; Wed, 17 May 2023 02:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684316520; x=1686908520;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a3Mivkl0m++lbcWbpQkVlNl5ORvNsZ6jk54N2wY1md0=;
        b=jjm18+pOvvSnrefEU4G2PU3sT8st9HXjb5z4v+ND+XQG8NVoq0cWopy0yosK0miokt
         56lKeKlWxi3tsMAxAJpXP4SHq21uG4yVbSnLZYWUkZ1FYco9sjxKzb66y1yATmi0wipn
         /czSyNtfPE1+tmolFVZOr0z+IblYPQxlXOk2PElMsRF77eB+5LkNEcze62T9W3zx5ee9
         lLdXfpoepE/oZqQj+obKbAbhxiIls6JC4FLvmlCCV49+1exHlFkeAcszGo7la4k06yOm
         qSjfyW/fqwcUkE9S7naAVh1v8A/a5fiAaeEx6AOMLIgPCMZgTTDoINH+TrlauMpfCSHb
         oOrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684316520; x=1686908520;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a3Mivkl0m++lbcWbpQkVlNl5ORvNsZ6jk54N2wY1md0=;
        b=Wsnp9vDw1FOBMd6Vsf/BtdipNsQaIMt1E+h181k3bdGFLNi1Rvbbg1UffyAL/VvJGb
         JvxhaCpRplKbhP/yP4MZKh3qzaPbLZRsZO2Nc3kaGJZK/hub0wPZiGr54r2uKph2JfTC
         UzcEibQzXJybijntq7apGHVD/5AXTtLw8gHdN0Sb4F3t4ntYcgYt2dIU8jnSeIkABCBW
         b8OmoiJwDVsqJSlBFNw/+8jiMnEpIcdCpI3hK3gNqaVdp6g7g0QjXaWTQXYByAkhIoB5
         5kb9rOtPoe2rNvO1JRVo/Q/68HPYZbW0dRorZF/jZ0gTzvg8DxxpS38OPfQ1zY09mbPl
         c+mg==
X-Gm-Message-State: AC+VfDycnDd9eaNkjLoHOLPyNV4HQMr+9IIkf7Muoa0EwonPRZAydrpt
	sZtLct+WtKWTV6n2GdwYb9qr6oTrybefNIApYg9zMQ==
X-Google-Smtp-Source: ACHHUZ7mWY6Azo/e+kuhTCa16/oxLHkgGl4+Aund0CSHP63AYlLAE3pemYCGfvh4PH/Ldx+271hy2Kfxj5g/xc34bH4=
X-Received: by 2002:a05:6102:e52:b0:425:e0ab:6fc with SMTP id
 p18-20020a0561020e5200b00425e0ab06fcmr15212264vst.35.1684316519605; Wed, 17
 May 2023 02:41:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230515161736.775969473@linuxfoundation.org> <ZGNJfAPd8eeVoCJ3@debian>
 <2023051711-thespian-sponsor-8878@gregkh>
In-Reply-To: <2023051711-thespian-sponsor-8878@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 17 May 2023 15:11:48 +0530
Message-ID: <CA+G9fYvw6HJopruUn4QKPCcqbdgw++AFf1wnwMP9hP1rJsmq3g@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/381] 5.10.180-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Wed, 17 May 2023 at 14:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, May 16, 2023 at 10:14:36AM +0100, Sudip Mukherjee (Codethink) wrote:
> > Hi Greg,
> >
> > On Mon, May 15, 2023 at 06:24:11PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.180 release.
> > > There are 381 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> >
> > Build test (gcc version 11.3.1 20230511):
> > mips: 63 configs -> no failure
> > arm: 104 configs -> no failure
> > arm64: 3 configs -> 1 failure
> > x86_64: 4 configs -> no failure
> > alpha allmodconfig -> no failure
> > powerpc allmodconfig -> no failure
> > riscv allmodconfig -> no failure
> > s390 allmodconfig -> no failure
> > xtensa allmodconfig -> no failure
> >
> > arm64 allmodconfig build fails with the error:
> >
> > /gcc/bin/aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___kvm_tlb_flush_vmid_ipa':
> > (.hyp.text+0x1a4c): undefined reference to `__kvm_nvhe_memset'
> > /gcc/bin/aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___kvm_tlb_flush_vmid':
> > (.hyp.text+0x1b20): undefined reference to `__kvm_nvhe_memset'
> > /gcc/bin/aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___kvm_flush_cpu_context':
> > (.hyp.text+0x1b80): undefined reference to `__kvm_nvhe_memset'
>
> That's odd, I don't see that symbol anywhere in the tree at all.
>
> And the only arm-related kvm changes don't have those symbols either
> (the other kvm changes are x86-only)
>
> Also, no one else has seen this issue.  Can you bisect?

This is an old issue,
Many other reported long back [1]

[1] https://lore.kernel.org/stable/CADYN=9KSKQx816id-zWepV-E3ozph3k2_i9Rhs6QseFv0hkPfg@mail.gmail.com/

- Naresh
