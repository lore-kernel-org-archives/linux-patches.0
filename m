Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D911ACE65
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 13:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718889266; cv=none; b=BsS9Twfq/hZrHoFrEcNuUX5XK+0oQfi0iZ8CFU4UUCGpBEykM4sSnEK8ef/F4cROvytHxOQMjFxzwiwmNfKEVMI3uYB/OJf5zJQdfcNXgCAbzupChltWipXiW+zPhCJvUSd+HBlyHyGi7zWgrmjA7kI3wTmLuQIW8MW9eMZm2BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718889266; c=relaxed/simple;
	bh=Y+MEEyx41IcOVMqXoXDJWkJ9+FrOPr++BZN75feuo1Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qWg/j+6bEAR1uAg6SW7CE43Put+obLZqpEMpMP2Kw2Ay8M84vHCbqw8Exv4JbJRUpqUleNZF3t9GZEwtHZ0j9loXAoCfUFlRqxUWecPJaPXdlE7IcwV49jN3mlwipdXXstMKBJfyhun12UDwwbE9Au0lTidGOiG7H+ZokcscndI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EBj4Pd6m; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EBj4Pd6m"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4405743ac19so7931391cf.0
        for <patches@lists.linux.dev>; Thu, 20 Jun 2024 06:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718889263; x=1719494063; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k8loiKfZnA+YA+BNdznuyc93e427hOVjzdhKBo4Mcdg=;
        b=EBj4Pd6ms0iBxknECZo5XzR9aNheu9ZJi77vNvefzUF/8HNLOzRERoPZabi1Q4bHTh
         lLUvNIr+VU5o3U4OtELoU0Td//6M/gHneVZ9zMmCbPEbNTOkHC/8nDpQ38M0c0iFgEeE
         RYFL0VPIp4rePj8QyAGwlVfqRKr89ionHpmlK8+5Dj1E1Q7BleMOslDXGdFwoqQK3IjY
         utHy5APiJvkE5D8vdzkZHwjc5Hllx1LjDoCmC21K3P+4KVFGz53n9U3q0Vy2FecERtil
         QCSX+0bxruYCfMMrCDnX1mcU+KYy+FapnLW6nJcdrlWRf+6hJPKzGMZP1gQi4Mkfmhrk
         lx/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718889263; x=1719494063;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k8loiKfZnA+YA+BNdznuyc93e427hOVjzdhKBo4Mcdg=;
        b=FRNIDAO243pRqnIo4rIiZHF/t90shFZp3r6XwDDUxcfnkK6pvLM76aFeQ+55pKfz88
         +BZShnIZChtYBfXAp6qX6Y4Ol8a/cNBFFRpfL0DoaiFhTUyYLY+yH8T5AE9QtbPnbC67
         UP/AnI43ScYqO+AfDYtpNqLX4y5YcQdwksMPNXBjcvMVc8yeF3xqYH4eIQ0CzQZ1kBPY
         7FWNTlpUkSp/7EGaRXQIfiaIeZ8HWdlnhR2Ud+axu0iMkZtBpeH4uByLbjOV676ITLd6
         hFD9hJGoO2sEUxLqLYaJSHibSwOCQDULVApsUTIy79MhPSt1LgoQKXJcwtzXEr8MEflR
         3DdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW8wgUTxq+KF6XUupF670I/PtqqCgSvCTiPyzpl8OVuEFm2O5QoKjLBC9xotx/y9z9JdM5qnRV2aH3mes43B51sXg5lNbAHg==
X-Gm-Message-State: AOJu0YzeKcAT2FZpVI9+w5GdGgiSwtHSkbgRqXfLbdxzj3gPbHcHJTzw
	iwCneuRHqKuR07f+59AyxiikZfEcj/K5Y0B466wUCnHN2DGuQ26j0kib33hpCSMvXCjiEmJKXQE
	Yv1VNv3n8bLgCwNL/4vaUPpjkKdDWiNYkAUP8OQ==
X-Google-Smtp-Source: AGHT+IGiHKV+q2qJu/mkMnrbWS6TykUfrsN8Y6wuNtachV8KZU4pBm3Bkt8z8L8YuUKSny6A751rJg0UHn+YKbmJrf0=
X-Received: by 2002:a05:622a:1813:b0:43f:f5e0:8e86 with SMTP id
 d75a77b69052e-4449b90ec32mr145142351cf.10.1718889263444; Thu, 20 Jun 2024
 06:14:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240619125609.836313103@linuxfoundation.org> <CA+G9fYtPV3kskAyc4NQws68-CpBrV+ohxkt1EEaAN54Dh6J6Uw@mail.gmail.com>
 <2024062028-caloric-cost-2ab9@gregkh>
In-Reply-To: <2024062028-caloric-cost-2ab9@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 20 Jun 2024 18:44:11 +0530
Message-ID: <CA+G9fYsr0=_Yzew1uyUtrZ7ayZFYqmaNzAwFZJPjFnDXZEwYcQ@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/281] 6.9.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Miaohe Lin <linmiaohe@huawei.com>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, David Hildenbrand <david@redhat.com>, 
	Cgroups <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, jbeulich@suse.com, 
	LTP List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"

On Thu, 20 Jun 2024 at 17:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 20, 2024 at 05:21:09PM +0530, Naresh Kamboju wrote:
> > On Wed, 19 Jun 2024 at 18:41, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.9.6 release.
> > > There are 281 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.6-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > There are two major issues on arm64 Juno-r2 on Linux stable-rc 6.9.6-rc1
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > 1)
> > The LTP controllers cgroup_fj_stress test cases causing kernel crash
> > on arm64 Juno-r2 with
> > compat mode testing with stable-rc 6.9 kernel.
> >
> > In the recent past I have reported this issues on Linux mainline.
> >
> > LTP: fork13: kernel panic on rk3399-rock-pi-4 running mainline 6.10.rc3
> >   - https://lore.kernel.org/all/CA+G9fYvKmr84WzTArmfaypKM9+=Aw0uXCtuUKHQKFCNMGJyOgQ@mail.gmail.com/
> >
> > it goes like this,
> >   Unable to handle kernel NULL pointer dereference at virtual address
> >   ...
> >   Insufficient stack space to handle exception!
> >   end Kernel panic - not syncing: kernel stack overflow
> >
> > 2)
> > The LTP controllers cgroup_fj_stress test suite causing kernel oops on
> > arm64 Juno-r2 (with the clang-night build toolchain).
> >   Unable to handle kernel NULL pointer dereference at virtual address
> > 0000000000000009
> >   Internal error: Oops: 0000000096000044 [#1] PREEMPT SMP
> >   pc : xprt_alloc_slot+0x54/0x1c8
> >   lr : xprt_alloc_slot+0x30/0x1c8
>
> And these are regressions?  Any chance to run 'git bisect'?

it's difficult to reproduce the first one so we haven't been able to bisect it.
It seemd like David and Baolin might have an idea what's causing it.

- Naresh
