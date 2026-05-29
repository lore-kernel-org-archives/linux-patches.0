Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA33A39EF35
	for <patches@lists.linux.dev>; Fri, 29 May 2026 05:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780032443; cv=pass; b=r6ZtfU9wIzzE9xtCta7hsEXcvhRJUJ3uSvpTefvHCZ13OXRPFGl2V8pPbSbZEalyF95gymM8xUX5yJM4lgl0uGnVKk9cjXP3HIYwNkfVlvxz85rwRd+trEChsbqvUH2GCo3XXcYvwhtdEem/PSZ6l2O9ffwIDXxVCjkydOMnhjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780032443; c=relaxed/simple;
	bh=MUXgWKwbXep5RG7+umAlMuGw9dCMPtNGKkuMHnQffV8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Syz3KfcevBZlzJ2aMc12G3xfdlfue+LvxXH9NiyyVRw87FvvQMs4PWNdhMZ6UeTns93Xxxg0MXZPENNJngLFzCV3X5B1tjmXe7ZKS8UxKwE6nI3qy8GlvRdV0ZD94Nd/uGGgN/IJDvN5yQfvLixKMlRb3x/mlIqP3PvD/JuII80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KAD7WBU7; arc=pass smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KAD7WBU7"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-304cf518c9dso2517108eec.1
        for <patches@lists.linux.dev>; Thu, 28 May 2026 22:27:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780032440; cv=none;
        d=google.com; s=arc-20240605;
        b=Fa+eUJwncppqbc/XtcqSxT5jszOsvwCOR8QPCIRHoxC/waXXi7yCsijlPuae6wkME/
         nEWwf8BlfrUcM5a6J7d4KtvUPyS61PR1fXgtxlOh7A0viT1d9iPeqlB1TI/ggJQHlEft
         KTdnccYR8NeUkJ9mQw8i/odj2Pav/uzqv90FgAxSUV9XJBruR3aZ/FwiZTvteHLRUWrE
         w9FUmfa4pAsExz56ad+EirajePTnCyyoE56FlNeByzG25C12tinuRG2kuYOOX5TAllUT
         Flym5GcCQttEb7p2W8HNi7dZwTXj3qJrGNKOFQVr8GDh+LOeJpfzatHyDgYsi9dlBGZP
         S9aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PvM+MHSHZ+xi/ne3NmT80GH0uDwpYd2vFIpgtDMVLSU=;
        fh=JwGrM6kyhbroOISvEfndNbXqXwszNC7XHJRkVqIU1HU=;
        b=hL38MQa9nLBbgpyMNZEYoTdl4u3NgHQSrflrDMfuWXdmqV4Mgv295j7xYlBp6+3rzJ
         iLcwyc+X3tsM9CyX+yh/rlKq49VkUrKHMdx1/BqCGDicaO7zH1t3T/nEqXs8kEBuOtZT
         In0Q2xPwGs1TP/v2B7he3Z4ovmYTl26vbNAn0+awRQw1WQ7iYZBfnH5Fe91vkTb+0duv
         1cTpkDSd2SAHny9SYMjig4QYJdtNAF6Oh4njhEYp1h53+JLQzuRNmXBxDmRa2Vh0d2tQ
         quFyn941LoNqvZ036yVC7357mQWrnBdJWxygSpZSt4OOOASRzaIokbGBBRKjyEKcrB5a
         WR/Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780032440; x=1780637240; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PvM+MHSHZ+xi/ne3NmT80GH0uDwpYd2vFIpgtDMVLSU=;
        b=KAD7WBU7UItVb2OQIZa8Ts9sz8p4sW5Ve8xrox8kUlcUYs7ZMMITfpugSlvnEA5zZ6
         gamJlOxCbFhixBW0K1ZydEuslX/tdr6BaQN59ihEMCOcW1XHvRJF765svmZ9rOenHl0A
         JEsGGYBVl8k5Q5SFlbbQRFrQ2jE04AZwm1/I0O54cl3Pa1vI+TmQsZin0erdtwXFEF0u
         NYoM+o3KJBDj40w64ZADNUCvUFwsFNLLu8T8kUsgj75uNCjfYNFEm8ajpt34crGDxp9m
         MLqJtiFa3PAJchlQsxsQ7bZztf/Vq4TD8XS+EyC3y3vVy385Lpr8UelUdrcLguF+27VC
         P6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780032440; x=1780637240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PvM+MHSHZ+xi/ne3NmT80GH0uDwpYd2vFIpgtDMVLSU=;
        b=ES/9Hf7HQdcsL+lTv9a01542v9iF128067qaLrbdURcuNFcwrAb5SISWskDyrCb/RB
         P0pb9JgD7hT0WKpeCabS8qrqg7rIlX91BzOuePMDdYQT/SCZ2GKp+jnoor5xScqcZpUj
         /vTh2ddlBoGOaijd28Yh/qOs3IsSKnLGTqY9Mqh06gE2gHaai8dHmCBMSxZADSclsjcO
         UcB+Sv6ogLmJPiEbH+dMSej+OuniE7HqU9dZLkIK6QWDibcDm9mmEmlLqzG806aU39BU
         P7aJDim4D/DwY3PpZDHvK9AOShO0wqmYmRbRfJw9h94xk+iVTlp6Da9RCY+DBY2ZBCHJ
         ElEw==
X-Forwarded-Encrypted: i=1; AFNElJ+k1UDlhCPBjijUhKjyO3iyo0Ld/3nMQc+gBCPPBuAF88D8dZnpHi4x1K5lZxfhc/MfmOfS2IDb@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7kgIp/RQ/XZMZjzcupxMZBQWOtsOwS+nw79UaTSRONc6I/5Pe
	vpTqA7y2iwyCRIEbnUcUAisde60ZuYPWMe+y7uJ7EsqqSF5U94ODm4Axu7Qu1SyJ+yKRznoqUO9
	ipVwjuayvlzOUec+R0Wp60B76JeurK6E=
X-Gm-Gg: Acq92OHRQLrHAOWijYQeZbvn9eZMRR3AN6w8R5aOD0Hb2bbXN3mAmgQrmc6xufMhLih
	oMh0JeORQEtqatlmVeHg7HaO2adQuasjj5Y58Wf7u1uj1Nsi9AXyjD4vVQFkwcb7xpuzt5av74X
	O5OQO3f2rX8fK1/w7MvfOx0hYC6+1eaCX6TSKks9rqPrlhCDUqxSANEdB0NebsqBXGvnqNYayA7
	xorBaKGBpD5d0mfOWztSXdmo/QDMbsGGwAFjH3WTOr2rPHnhhOgbrydbDYdjmC7f88QQoBHZSpg
	3o7XssprLE404uXoheltZY/UaSxHYzvZiRbr7LpVW4/TQJTyU/f6gKgP2RQgVI8N311/YKiDy4D
	unCb6LKWGbfM7qf2j60q+TPiqhoGHnkbbQVzxPZBhH4NAfUXbKT2/uyvd4sie+BL4lJRrlqWZ17
	lMAbaEDETKO3SuXJrU5ZFSqEOLproC0CB/MGh/G1Vv/xsNfp7rMmF8N31dm6w=
X-Received: by 2002:a05:693c:834e:b0:304:ed85:5f43 with SMTP id
 5a478bee46e88-304ed856527mr200456eec.24.1780032439839; Thu, 28 May 2026
 22:27:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260528194646.819809818@linuxfoundation.org> <CAKL4bV73k67Qg1dfhPV18S7_yTuVzkVsBLO0sMsdESoDZnwLcQ@mail.gmail.com>
In-Reply-To: <CAKL4bV73k67Qg1dfhPV18S7_yTuVzkVsBLO0sMsdESoDZnwLcQ@mail.gmail.com>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Fri, 29 May 2026 07:27:06 +0200
X-Gm-Features: AVHnY4Lek4iSkv4QOXfuiv4M4cWEdrmILjbTgn-2XJmNAcSjZKsb95Ym6qDUTbk
Message-ID: <CADo9pHiejnrVUz2pSA4kudUwefUU5Od5EbpMUsSaRDkCRRYTzw@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/461] 7.0.11-rc1 review
To: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

and a Dell Micro 3050 with: Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den fre 29 maj 2026 kl 02:11 skrev Takeshi Ogasawara
<takeshi.ogasawara@futuring-girl.com>:
>
> Hi Greg
>
> On Fri, May 29, 2026 at 4:56=E2=80=AFAM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 7.0.11 release.
> > There are 461 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 30 May 2026 19:45:49 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patc=
h-7.0.11-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-7.0.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
>
> Linux version 7.0.11-rc1 tested.
>
> Build successfully completed.
> Boot successfully completed.
> No dmesg regressions.
> Video output normal.
> Sound output normal.
>
> Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)
>
> [    0.000000] Linux version 7.0.11-rc1rv-g547c0212c36f
> (takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260430, GNU ld (GNU
> Binutils) 2.46.0) #1 SMP PREEMPT_DYNAMIC Fri May 29 08:35:15 JST 2026
>
> Thanks
>
> Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
>
