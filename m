Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E76228C009
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 14:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769696660; cv=pass; b=fp8jRc8jX6il80PoyzRtucPRrTdJ4LZhnEk3JsVI6erMT/ZQBUxJUItvahFmXOkzr6+1P6u3kBiKljzE6IibX1Ut/EZUm8lBjrhTD1k5twdaGDCoYDKpnWCa33+jMfLYJN6iuJyFWzA0hWf8i4WuNJoRb6l+lztwsxCwsdypTQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769696660; c=relaxed/simple;
	bh=xU1/ZfrXgM9HR/Zx0kKZpCKj99mAbA3yDtIE/KHX3A4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tmIcevfzVk7zt7pf6o7H+yuWO0aS7aNkEmKYZgr5ALfnFta8Rxr7Y3ghwut94juDZmK8SqCqclXiBD2uJ01Uh++QK8THSGS8Kw5iaHr8A4S2dIrJsAOfgHGEkANyRMb5hMDBU5qG/MmjpblL8euzzfCwuARtfYjfxjeYeAGJXDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=QyiRUjFN; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="QyiRUjFN"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-501469b598fso7029481cf.3
        for <patches@lists.linux.dev>; Thu, 29 Jan 2026 06:24:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769696657; cv=none;
        d=google.com; s=arc-20240605;
        b=TFd0ZSRuh0widcmrhIShFjrMnJILWplhrqQgVSN3ZbzCRz5oSsEL4thWSDXlARx0Ek
         GnQtOyGdxetIBg3HcEPF2eURsI1quKf7enrFgGtnItDrMLsF4F3c4kAHgtFo2tnOtEHd
         N76Qw6JbmRg71BAkCqkIbeSjsaYpUkIXQGA9ViOEsTrJKJsjal3tO7AHogDjUrKmMPhW
         ikaDxV+5t9IE1nvWXxAUn24FLchGiihPf4T6/rj135s/PNIEfYlo9QtUIDlWZJhZ0OwO
         eGpWwsybOY0gK4NonS4/x8WyckXjZYsbEh3YQm51OGzoNBPQilYSIzHv4LPEmhHldtNe
         DZkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gktut5wQC1km4p9bQI9Id4b3vU7e4+c1JajdasfISjk=;
        fh=PlhcAmzaZPj7wiVGdYFTIXl4bZPU8rDfHyZWr4y1quA=;
        b=jbSkmWb3gT3lrKSEv5gQCpkckMHXq/glZCIBQWHtEAwPCj7k+K0MFYvm6S1DCm6Y+1
         gfWExdanF7mLCcJFPcc7YuHfxGvPS4gEpRn7NH+5NuHOoYPrXU6PcHfY0HMTDn2VTbRb
         VA0aunA+50086mxWZ7zzlZn53VxjsTghD2ZQzlT0/yUAQqz5g4LmnfWVBVwjDW2COYnP
         BA8dsR/0e6pZKSrP74w52BjdAvQFlTS17C3IORoPa53zyIby3ZDKwyh6A1WTxOcFok3d
         Hhv2BHh5y9dPr+YwOx1vHzafmUihLRj+aJBPZ97m1uFKgw1lYZkHBuFmFuG4n/wl4dmC
         PRCg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1769696657; x=1770301457; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gktut5wQC1km4p9bQI9Id4b3vU7e4+c1JajdasfISjk=;
        b=QyiRUjFNuJ3UKj2jfjPR+VpLtlVR+xB92JMV1EX3At7xiFEmDzbICmAnVVSaS/WIAP
         j145lBF/+EkTLDCL3XrWHGWcC0dS311I/e66KvPx7PKz/8/yKPdpUrX/TKynDV3Fuhk/
         7IXMvo0309zLmqJVrPUEOBtcblMqXIDo5yIvJ9hbxxR7PY4DFpOnQBcCsPfWvGl8tZBg
         zC07MhkFJHrYjndAw8adOTMak+Gn7Qh5TDtaGkDC4X2VS4mFjAviPQzXB3QuLbcnNMvk
         kpCwh5eASbEvqIxDag/13dnX/RzPEzCaxoWzBFXeAg7RFMSSJUeZortUNpq6q3WZ5wbu
         xw8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769696657; x=1770301457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gktut5wQC1km4p9bQI9Id4b3vU7e4+c1JajdasfISjk=;
        b=O4wZNGYVE/M/4s8Vdue6i8e8OTsiw5d6hYVli8gjgBvtroCMbqNMqSYO6FIb+gwaZP
         mYjkraw2lnfwnl/hIyFBBRNmugHB2rJgp2q4MQFBcvGfOqKCuyQYpAzuemfyZ26IDV9C
         Loomlq2MK+NT5Gdv58BN62AXeD3IczqmJ2IVQcWghjhPjWxgzsuO6dbXQ8bh5yNOMF2j
         7XYQqMhSCPG/8sJ4inzmNVAoUrR7pxzkYZMN2I4GOGk7mSsIA2PkBnCUuCgNogfg5c1L
         RmeB2T2d0WSfLxHuZbPbu/fDpGMtp55oBajnAcy/l8URODI75N5ZOM3eUebQvxj30yAD
         CPGA==
X-Forwarded-Encrypted: i=1; AJvYcCVbzatxhizlzh9l9G0lz4j5Cl5ONZuldGtj7/+RUeDNjdLt24xx2MiQF/K3KHBtklIqyR/t4P/S@lists.linux.dev
X-Gm-Message-State: AOJu0YxYNrmatWMM3/+Pms8Kn2F7l7rnYaIuecTdvAcqUYjsbfc55Kdz
	ALJOD8ovwnByxdTIXuOAKC8mYezSa+ukNgQcvWjETThuARarT+DftzIS4NVEndWWeh33Ck65w+6
	lJkL14CWqpXszJEf28lN7knCHl5B8pzCV5SxNvTvvtA==
X-Gm-Gg: AZuq6aIKXjt78uYOgwiicB3PZDuwaktdKvOLyjKDzjR8PKkHpQ9/74LLNGdmq5RPFhq
	lD8VkHTNlbsLt/RRKtEavYrlCFES/K2IKqtskLDapZNgA0HgNNdvi0coI+BYVCsDE9mWeYvsmEx
	bG04DNoNTSwrBuG/DmnmYg/j1rbd5mtU6gM46TONlMdzCuAmXapGlAzhxUAcSl0JXkiZRNHq1nb
	KT9yVQ6Kp4CbqNFRv+b6GszTlISYysMAGxyQTxiwiNwIe/lhJjBSGGyaBOZlYNDjOPSDwa5
X-Received: by 2002:a05:622a:241:b0:501:d6ab:99c6 with SMTP id
 d75a77b69052e-5032f888b28mr117185321cf.32.1769696656920; Thu, 29 Jan 2026
 06:24:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260128145344.331957407@linuxfoundation.org>
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Thu, 29 Jan 2026 09:24:05 -0500
X-Gm-Features: AZwV_Qj5V6YFUeSBt4FZkzqCgXMyY-6bvFIqCSYP0qCnPkxUMX9ip_fsyKXL4_o
Message-ID: <CAOBMUvhEoJEZRGJWbmW+Nbt-mzfJ9Tnnv2Z8b1Ep_OR2zBee5w@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/227] 6.18.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2026 at 11:18=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.8 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.8-rc1.gz
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
