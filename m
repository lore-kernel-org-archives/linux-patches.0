Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B903A6EF7
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 10:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775038028; cv=pass; b=pPMSaRAoBBCvN5qCn7RsWVFaq+qtCUvb5fsXOVmeGOn/i+226qUiLFPrpUAe5SG4JyFE8e3gnsPGs7d8+fATZ1AhdvcTpJ3uEp2+gg92IEt2oEGOQK8DKtOS50lsMMxkjn8AI8tiQQymQWyAgWFNHrF/wA8T+ZJFZKHcLGYgUgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775038028; c=relaxed/simple;
	bh=GuAGy0BwVa+KlDpElYaX1b2UqkrYg6svMWho463ATIc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gKxF8nRdiYY/1QfDMirU12r623vjToavY3yVvnCsjtiUrwsN6Dz6DNZ6MzS+L02zFAMljp6IBQ515vTCqretWRJFB9T1cfYbVmjxeD7DgQK074tJoAacu3rAHKVOY74aEBlFUbRzsXihJ+NghOWNA4Lu257xab/xLz3AGTOv6L8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j6MhpD8J; arc=pass smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6MhpD8J"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2b6b0500e06so9031048eec.1
        for <patches@lists.linux.dev>; Wed, 01 Apr 2026 03:07:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775038023; cv=none;
        d=google.com; s=arc-20240605;
        b=UFmA+rJgUQ0KVotDDToHgYc5VYLi1/bU7hN3oG/RxnAAn5yakPU1THxggSv5sB4n8P
         Q6algTTGYRlAavjJIWyFpdLMSsEiGOujJI6OpYpbVng++evuDQX3DAS+sNJeN1ATeaQB
         NhFOaEzfPnSDC1nFa9dKt/z+VlIQ18g3GlcywyVDm5Sn4D2ls+M17Fl2iNUObe4j4YYG
         3Bl1/CXZJw126EZ2bkWLXunNYEBbs6urf8crtwaUu0BmXJY1alLB4FgByk7OnAgMYQlx
         9X4hhvgyfcGwB/N5DkxyzM//sVSz307urp0fo1OhWbQS76sLOd1322lKLwua2ToXAlkF
         KCTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=sgo3rYYgI3Q6g7deAMcHP7eT6JeZriCPTcT7GLi0w/Y=;
        fh=x4VOtpt/XtCsC/plHbAetvmzaRDyKi7AxbQZ2US/N4c=;
        b=JqWb9h0bD0a4DMujnAHS8LyJOEojdy49uUV2m1ENoRWt6/JP6xEzQEsJilIQShlq4J
         2B7UJfwr/h9Y4yFgOBwiBFoKzMERzptupNY+fzy/BEwYLNOvQPOAm62ueXIbTgyNP1qW
         NwtJUWiLW5qVQWUIHJR971vDj/u+V9CM0wKBlXGfd9j2FIIJMU4rlJw1B8cGI3NRsnrt
         BDzAJo/G8Fs8Z/0fCCjfYCIGaFLwS9IF1w5IxMjNiz2ei6vh5LwPASduh3HTxxjN5X3P
         CRNx//rR/kYFzsxQ3mJ3/2q5MkEqeTGiza9P1eGiUqt2HQNQaMazSCMBRcn8MSubs6wo
         X3aw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775038023; x=1775642823; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sgo3rYYgI3Q6g7deAMcHP7eT6JeZriCPTcT7GLi0w/Y=;
        b=j6MhpD8JEHD/tn+FLEIUP1OxNjR8IubZD4f41OpUqpkjRM0RyZY3s3LZDI6ZiOuWzj
         ofjoX4uqzZqcXOhUtL/l9OSN++qoAWWIPAJHcR72mDKMzag4s4gdtV/+m+QSiCeznngX
         KUS3NqB+4/IEm0ZktAsRxJl0USHpT06+fvuPNiY1zVPv/0Yh3yt5YkzWl9WHzW1gknDZ
         mRrrdgkCrjkE8Xxirls6Uyo5582chGbKgw3vHzMcRHvo7b5RQk9KXsKrJjlM4iIVA7ui
         aj+je/X0fxSfj5mNV+sbuDZvv26uh2ikoeLrlraaNrB+2gmJ4MV+oHP5tM3MUMoJs+Mo
         pexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775038023; x=1775642823;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sgo3rYYgI3Q6g7deAMcHP7eT6JeZriCPTcT7GLi0w/Y=;
        b=NQMKoaxMh96ucLYXsQOtDsfRIKNjSLv5yhsz2m+dwNDsUWkC9i+E2fawQPB1pIrEYT
         gB6+yAhHy4LwhlUX24vYrZ7KcbadzMd/4C2wRLwAAPSP29taV++fxXF+On8s/9Y4Bw9S
         LEZaPt2XaL0d/08QmxutL1K1w8OD9YZeTPw8gdH+iVLJZ6p/R6B/JgpXWoRZMtFgJwRI
         OZG/bDGVuRQ4T9+t4l7zai77URSTjEJ5V28giFyWFr/t7Tn81zXxiBWr+OFzZxvuNWci
         vm5dCUjLU2c5VaoVRkhFMAnhu2YGzHHiz/hXr9Y8Y5O/4cauTpjfVumUIcbae30RmrEH
         AqTQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1w056oIVDtgVnbpEcSxaQKI3Q9iiMKCjoXPjcIMPf6XEPL0Sno6aAkCaemvknCPujf2wZVYqF@lists.linux.dev
X-Gm-Message-State: AOJu0YxLfSvGJIPKR0uZ7wD1YzRVY43JNF1WrAowv4HK59w3hBFi6mpf
	h1r4Eo2VllRchXyoqddgxAxClIGUyPw8ItKcr66BIxSZzs5h3+zsmkFS7CQ/m62xN5CkdXm3Lgv
	sQ8BXQuKSMu7ZFf9eC4ruQDw4ZlVDnPM=
X-Gm-Gg: ATEYQzx3knwMYFVH5EvuuvInq8RRBiNMHfhqwRkD9phNZghH164EDInQ/VbshVPh0Qw
	yQC/pi3II3DVvQ3NAxmU/qY6GlOkwVu1ekhOd2p7uQmHqXAPk9Du6+/ZHBChxAEVS92d3hX8SBi
	+U88KaTzl14x8zV5xb9P7KAixqIV4b8dwkO7KVbls2jBd0yekwOLcz8VWgrpKN84BMJriqm23gN
	auURW96e/a+VY/yRTsb347y4F1627IauWMzPhGcZhbh6/he8P0SaJdDikouiturEdLXBjlK5Khr
	0FiO+q6MnRTtqJKIpHIyY3LvUuC9B684R3liBWz2xQTwfHfOEB/vIhsU5PZBn9Bn2SDgN+eEnF8
	RGQqTSSwiwe7x+x8WOo+/+i6L01EMDdFmUGQCTahWquYGZRkZlZwG7ZnmKur1JwIv04TTYAr/J8
	DTZaB/IH67Ke9V6Pi5Tqc=
X-Received: by 2002:a05:7301:4591:b0:2c8:8e74:4eca with SMTP id
 5a478bee46e88-2c9320c06d4mr1454568eec.19.1775038022452; Wed, 01 Apr 2026
 03:07:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260331161758.909578033@linuxfoundation.org> <aa4dcd03-8c65-47c0-9c0d-9fc3d3b69a1b@drhqmail202.nvidia.com>
In-Reply-To: <aa4dcd03-8c65-47c0-9c0d-9fc3d3b69a1b@drhqmail202.nvidia.com>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 1 Apr 2026 12:06:49 +0200
X-Gm-Features: AQROBzBovxZAlwV3ssxnPNvdOJXfETlbAjvvU5Zlw19y2SgZgm7CgvUGd1JeuNU
Message-ID: <CADo9pHhKnfU2s8oPvM+odjxk5FK4YifBgLxPAjAekOQU9j4Avg@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/342] 6.19.11-rc1 review
To: Jon Hunter <jonathanh@nvidia.com>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com, linux-tegra@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den ons 1 apr. 2026 kl 11:25 skrev Jon Hunter <jonathanh@nvidia.com>:
>
> On Tue, 31 Mar 2026 18:17:13 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.19.11 release.
> > There are 342 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.11-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> All tests passing for Tegra ...
>
> Test results for stable-v6.19:
>     11 builds:  11 pass, 0 fail
>     28 boots:   28 pass, 0 fail
>     133 tests:  133 pass, 0 fail
>
> Linux version:  6.19.11-rc1-g411f8a553ae8
> Boards tested:  tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                 tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra234-p3737-0000+p3701-0000,
>                 tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04
>
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
>
> Jon
>
