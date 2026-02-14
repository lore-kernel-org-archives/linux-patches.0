Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59ED1E1C11
	for <patches@lists.linux.dev>; Sat, 14 Feb 2026 00:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030664; cv=pass; b=UKgjQ+n31kBQmb7+KMvpNlVYXGSZ8l2Ko9yGXaYHmNnQszJk5K5go4waVS1t+j5hfm8fyGCPuonMfXwsKpfd3RuQxR2M+R/VBOZu+KUoQKDPXn4zyk4nYwb2u/Tm40p5FOYnMYQWeyqXRgEvdOC3bQ7yAHvgLbN7rdQ2ZAAejMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030664; c=relaxed/simple;
	bh=sHr1Cl/Gl9fpAr8sKGi8KjHqbPHHwCS/wUW/pNi/eTM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aAr3z8YX4fv0jytG7TMmbrAh5n/JrBkrMsRcvgwEqr3Y6Z9uT0ieYycR4qmcUxfFKzddUmYh/56HhiOpcgsYzyacLinSj9DVBN/XnDvUaM0HHNe8bR80se1zfhonKDgIH4hQjENJwTnyatFbTPMqt+tn930nl05F3XpE7SV3hw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=XUhFceII; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="XUhFceII"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-89577f866d6so20907566d6.0
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 16:57:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771030662; cv=none;
        d=google.com; s=arc-20240605;
        b=iB06Apvvdr7M/jxamvuJMBixDeicGwY8iAkqvS3F+jTLuCxH8/gUQ6zRHxVafUTl63
         VgWTt/9SqyaymA5dn5pf/AUN+j7VCMRA2S2/Yr0BvUAo+dFwANoBjtpSMu4oQCTfh6XJ
         wPvR/sueB2L9RZOTieyV/tQKBanQHwNdUFQ0L0A+15wx0ArI5EeE2l+rN9Vs4Qr9IIyR
         5J75Ze+zAtAIFvPXqJ0cApAX0XQcjjw5biEaygnhNudGMx03XHKE/1VhNIhQxbGNcOcx
         upIEVZb3t1oaok5nFF/3d+lYR59V1YttbzmtAlT+jU5/+zraajrr8ccmtUFX0Pr3BXjC
         zGjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SU6MnRDhwPzTEBvQJvMDhOJ2GyLQFBxvyqaP+MaDgQg=;
        fh=BzSRCoFi0+7nWj5bi1p/yB8J2DiufWGUi5geaoFAZ80=;
        b=QAhHjFQLUFoVaHjpnUmr+qBh3GOHSEjFzDTijqMrEBvJiRByNs7eBWN3hLBrPr7W63
         8YaBOwWC/gNqJ4t+4XWK8TdpOwYHKbyC8IRkAMtwJyuRrYIW35TgAZVqWb+BBA1v6LaB
         h7WOhjATRI1P3DDZgExw0YjnVn+nEKt7w+bwn2pU9hc1YMZl2aaZd0gKmve9FNE6D5AY
         EO8aanG1Aj1M+/32YYkPCPA73QyBcKp7u1mP7HiKmouReUA2PY+kpQ1++x699b8iCHSB
         8GbvlxzCq60MKkDrOVOU2xeLEHxf4hMQfmb2BzvCB2VkJvpnNwdzEivbcOc1oOqVT2Af
         YRww==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1771030662; x=1771635462; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SU6MnRDhwPzTEBvQJvMDhOJ2GyLQFBxvyqaP+MaDgQg=;
        b=XUhFceIIMdzxg7I7kZFxYutqbXbu9XYybWVxKP/+6KqhowQ0RTreOSPgPXKjzsun0A
         /BMUFqOktw2OGB8RFBWa53NUEWC61FKpK4U1X/SUiBRNB9RDouBt76kdjSDPspHjL3WJ
         QnIM1RsF/bpOdZSHKnCrlGdwDoIRUL6POuwWwtH2WHd5gfaNb2rlLOz3F5Gi57JzGK96
         f/fg/jCnAzHZa8zMqGfnBkJoB5hZmN1DMYnueSXRtUQy9a0uMUgbgluWNqmAUSF8PZp6
         1dSJ7OYeXgwBkJ36JNRrndDytZ7kg+hrKqftKiU7qDaEFsFnE+zGbUaRunFEoURRUkoN
         ZIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771030662; x=1771635462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SU6MnRDhwPzTEBvQJvMDhOJ2GyLQFBxvyqaP+MaDgQg=;
        b=lkTZkX0batcP4XI3g/E2YI5z3+M9kawl0lJxpUjhAWhafbKWDBLCMWFJjQBOP+Is5z
         h9bV1BnlSkA/fvmL85oEeIvJBUx31ONZ8bj0VpR5CjhRMcDPsenD3AfaYITxAZ+OxaXj
         2Cbka/mpauNXMdmDVBP2iVR9S97Vfm20Vbkb10YAHRCHJD/jPuxvyxUBUcLHWibsH3Xb
         2l4qIG38/Mdhgs+EcmrhQ9QG8H73HcoZzhmX2bCFz4/D/T/zXeJUxb5CF5ZPoNx5Gf+P
         MSz7pfuqX9S5EKE8gan5CBCSUEymvI4im4uoiwzM2ctXQb1NAuyc/6+wApy2vwCcpSUB
         yrhA==
X-Forwarded-Encrypted: i=1; AJvYcCWXXwm4xWa4b2DsQxWeNPaLMfr8rxAkQ8nGuDzxwqRjjtE3LYwO/tDf+oblr+GG7/yl1YRfOVRA@lists.linux.dev
X-Gm-Message-State: AOJu0YxhAyuh56TSQ45hER76WK3MBEJlSJoIWqhTZx5nVJ0bzM8qm92z
	NegFpCSYYG/6xRuqRNLUDmQMc1I7NEJkDwlf31ebuQqva+MrOTOAq8ElARbMqv5ENtl6iY6kmoC
	KRGkRc9yE4AhDzUEAOy08PYiPq9SiSZmbMre0a7pw4w==
X-Gm-Gg: AZuq6aKrVvK7rHDsvdmaMw20oBHBuilm6EXjxB8mEiOsM+Xm6asIvisulv3XXNNrylY
	doO0Y+Gt2ak7iPyBDg8f2GxQe1SUDJRa01REyTrGj6Spq+ccJ3S1NsM56y2m02xn1ZOZw0rlDwK
	2NR6uIZ19QO6HHZddoZvxNdTn+JTEtDQgNS2jZ/Ysh1I+Kl1C0pe4BLmnoOcR9ksY7w81HBCbtq
	D8QyJbQlWa/sDXzXiVXMeBg1wkQE235tK1Ie8GyOGRmzb6BDHxrlEBAfuGqBoH9bADmJjGXb34l
	hVOXi3RQ
X-Received: by 2002:a05:6214:f2f:b0:895:496f:1a71 with SMTP id
 6a1803df08f44-8973f3270admr30874566d6.28.1771030661914; Fri, 13 Feb 2026
 16:57:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260213134708.885500854@linuxfoundation.org>
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Fri, 13 Feb 2026 19:57:30 -0500
X-Gm-Features: AZwV_QhayJbInj89dprU9BzQFB3-jRrbL_KUJPSMlYjl_XfLKIdFgNNjVeSQGuo
Message-ID: <CAOBMUvgi+=sneGYgUKCoJMhZwd2x55ih9tZa2_LX=Y67pMSEJw@mail.gmail.com>
Subject: Re: [PATCH 6.18 00/49] 6.18.11-rc1 review
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

On Fri, Feb 13, 2026 at 8:52=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.11 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Intel Core i7-10810U

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
