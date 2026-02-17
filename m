Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7070632A3CC
	for <patches@lists.linux.dev>; Tue, 17 Feb 2026 23:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771371677; cv=pass; b=Tew4zh9MWyoDD+iebIWe4JmNHQv6FOU6PRF2w+dog7hD3BcWbBKTYxWXKncrB+oonfocRUV0fIBoDZlqnuwvGy5xGt8eFspxzESVwza80MmTQAwEVC1SX1Cj3AONoRR/K/hSTiSkX0tz+A/fAH8PK+jDznTNJlH0qTi5vtVjcpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771371677; c=relaxed/simple;
	bh=ZC2MeXtrSzUu8L4Ep48hQ8nuNJnmtlq6AhNproNpzvY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RIrTGWPTEIULjV3W3ontTr1EHyuJ9EpAL4C6ienUPP6FeGGh8mpGWo3vm6HtJr+bKSqDOn12rKLzyDLO2uKq1Cy0Wt7QuV6Hpvw88QiVv5b7E3HjmWCO6bfeG56ctvwuzsOZcEk0QSCC9EeGs27G4qBy/e3GlZjYusdXnWNHQ4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=L4w5bo3s; arc=pass smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="L4w5bo3s"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-12758ce1e8dso758194c88.0
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 15:41:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771371672; cv=none;
        d=google.com; s=arc-20240605;
        b=bQ35OojDZg4QCl9cIP3dAJIurJ41yriZKGDLJG5c1361MuCpPS2KpK443fjpXf4df7
         6x2IcnIJgRb+vymN7l5+fBooaEfG130WogDfAnHjL3bf+/osZcmso0sE5JdRQWAsvic4
         hH7w1xiLI5rUSSI+I7WbJo9w62GRTvr+t/X/QeEXEL4umnQ2QzjSCF5XF50pnkPSKXEv
         sU+Z/Q2R12Rzk+xex7w39J7CXPDDpmnZEDBzvonrz3VqFPh7AV1CyON40zdtq/sWVod1
         Oy/eBRqQ8ueS+jyBT+RR8UfwmkfhJyors9Q2jw1tLpUabRNexkffkdFcalbwxr5mf6jJ
         bwOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wCl+O8bYQ5IhuKuSsxlP3FcvowY6kRwa3uqsFQa7UZ8=;
        fh=Kn0p6zaCb4TDiH8BiwPNeWV8eG7n1/wh7O9+BOHGQBM=;
        b=eG9EQHbMZfHfy6xLkyyKYCwGB7lMqBmHtfjoa9FPkPVmb2wYYvKnJyIXnNr+bASss9
         NzL8P9QivLWesO2KEn7UToHTBhJQrrb1Ee6XZpzSPlWWByqdwmpR0Ch+9753Nd4Ko1YD
         7jO8QgKvP6siUuu3D/jWKwStOdwuSgEVQJFAXvPdIZDufDxaym1buMkt/PjSba9VS92m
         o30yprRb+X0CxEP0PCBijWwXJ7Dz80Ak8U0BLBaF9qQcOm+MkEX9ys35iM2bUEkDAJZu
         9Hjic6sRtSxdzrepZyoQj7noY2et3GLMhO1/h9DABp6wWb2/k08xfXn2mdGrCL//fTxJ
         m5vw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1771371672; x=1771976472; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wCl+O8bYQ5IhuKuSsxlP3FcvowY6kRwa3uqsFQa7UZ8=;
        b=L4w5bo3sFPtuZlOBQ+viz3jH8Iml2X0Q5UIuKIQEISIt9K0hx5U0/bLyQlLVW0AkZG
         R7G4EaAMPLKyLwnn9LeQHG4JMAoWHl/NFnz4ms3ZD43+SmJRnTppeOMUJfj6d8SaP+3c
         Y4FnuNEXTCL68OV6gPyAiHYINTVjUWbcJz3Jvf7UzIadOU5SI//0Ruhe8KtCzw3q1YFV
         Hk/3L2iCKV2WyPVAp09I/8Il2tZZ9nqWjffHci+JyOXgslbcH5m5tGrng8nQErc1v86s
         VxAzyqgLBVkDJHuzPj751aqjESekLssGQnnNMMOY2wITxVY+Qj8UpAnvobE90ItA5iZp
         E2RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771371672; x=1771976472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wCl+O8bYQ5IhuKuSsxlP3FcvowY6kRwa3uqsFQa7UZ8=;
        b=jr9jsSstYrgE1zSqq7hmpcsI3uOeIxSlNISiELMnHTFd7C7uxbKK0cUW32nU7XVTMZ
         3TworsbZq153qoWIhjwnGP/39yiXTk4v1oBYDIv6+OzJHVi6zgz+p2qBSd7TCx0SfB8l
         MPcVcySxeTl/hA5VUxGIASyf5GX0GEe8bkVIw94BTXMOqbuMsUKt575cfjD0/6LB0AQ+
         oyKsPE2Gv4HkCFV+burBKwz92rguy0Kn5Y+1RSidZdKe8rXrmOKuq9f0Tk+k7WHl2EWa
         +qb70Sk9LIJm4vd/5WsCyTxKUB0x8d40nns1vhPVyFlJCuZxfguOEsL7V95PfIeFGzIw
         cHFw==
X-Forwarded-Encrypted: i=1; AJvYcCVgeO6HE1AvQJW0UTxxabMDmaH7ClFLL2ofXIaLCFETXAdQN3FSrWertQlGTGvOnQqZUMQMNvRa@lists.linux.dev
X-Gm-Message-State: AOJu0YzBgSAMzkC9jwsBsfqgwEfq+1A4XrLIM8git7sKmaJ0kghDlwmT
	30KNOUTZAAB6g5zA9i5RREX14K8aarUDBVBD5xGvXnK10fP41pjaoADft6E1H/Iao6+6oYZ8p2s
	OLutfCvKm+PZK7o5Tez2rtogwdxunPt0cvG7wRVRPhQ==
X-Gm-Gg: AZuq6aIkBZwNDzxKRj4OkSU1wneDJtwOdSh6ygsoDAGqC1Bwq6Ou9Iu6GGyu+zD2GaI
	nOSa6bFRfV/Hs5z4bDnJwZbaXMrfRi10DrgqA4GLY6n/n+rRUFiqZjDbdAkGQi2Qo8u/epgeBWT
	hX7erTcjzVbyFfjZYheHw7DdIz8a6NMqxsP1x/0/9lT11pwn4xBNl8LSF1qcgrjVCnwzShFYTRE
	FBln8vxSNRqfW5ah69kL/pdkQfasHg+q7p5+TsmQ1RQGnIUQPvtc++N7cQtmPbCwdel6FR9HFtJ
	EcbQq46Y
X-Received: by 2002:a05:7022:11d:b0:124:9acd:3b15 with SMTP id
 a92af1059eb24-12759a6b6ffmr13932c88.39.1771371672085; Tue, 17 Feb 2026
 15:41:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260217200002.683975158@linuxfoundation.org>
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 18 Feb 2026 08:40:56 +0900
X-Gm-Features: AaiRm50IAir4FGafBUzb-FMs_r7-weMTOUOwb2koN7-A26RIcgUsPGiDNCjlZBI
Message-ID: <CAKL4bV5uUNTJXzFLwwiHO5ZWk2R7p45u7v_Bxo3L-mg1x8LxEA@mail.gmail.com>
Subject: Re: [PATCH 6.19 00/18] 6.19.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Feb 18, 2026 at 5:50=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.3 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.19.3-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.3-rc1rv-g40e4767c6df5
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Wed Feb 18 08:05:33 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
