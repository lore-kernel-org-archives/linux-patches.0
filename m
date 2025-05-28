Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351AF3595D
	for <patches@lists.linux.dev>; Wed, 28 May 2025 13:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748437300; cv=none; b=hUu01SEzYZ4wGFSdsJR+C9pSbNSo9mRy3UgiAPP+0Dbt4UX4MgqTORze+SmQ3VTkVwkuXbgrnI2UwvAJ0K4kzaMcEsoZl72z42KzDAcckcz+mnhGStDLzgSl8jtZdew+4GD0lc3RAPxuThvH5mwyLriVm+aQt0eFZhDedZGyvnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748437300; c=relaxed/simple;
	bh=IDUpsfHZ2AH+U1rKwA/IQTqNl27rntnPiEG0JxCqPMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ttN8kPNh1odOCtnTH4yTnSHR6E1vWuMZCvgzZ/peyMu0dZ6+KlxDhGm6P+qLS8YZDTGc/jUPQOqgK7eCW1auAnYeh2BBePhNg9tBlYSGcxAsZWqByyMB6/YDJHycs+ZjN3ONYeMqH3J9hrRg30blHBBpu+H8i82AWiWEhwMLBjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=TmDgWTWJ; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="TmDgWTWJ"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7cadd46eb07so427181385a.3
        for <patches@lists.linux.dev>; Wed, 28 May 2025 06:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1748437298; x=1749042098; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WdTBfL4v5yjVyTe4ji2bqNzULXH9IrkaNLBy8k+ftBw=;
        b=TmDgWTWJN8Nmyna9Wp1z4KYzcCa1y8KqwOFLLjRhNtKv2rwpo8sOwoBR4DY6C/4cQw
         152CITPDFCMBJK83XhYMn9FQcyR3MYaf/ab48TzgauRopPxppMOza8C9xATyuIcQNuPJ
         8MnnkWDGzqfyDffvQKcfZC6NlqV+YkEKXfOUUMa7O60iB27azcfVw1wiYv15Y9j4wRaN
         hjHyIudTQuSLtBmv/bOq2dp9/3xaRhbcKCWFavYDI281P+qhUqQFD/zaXkKyMb1gH2/R
         W6JIPsjY65QKDNy2fXvoSnydx4t48qu/S9fuLHI8JdcGjPfYIEXuVEm9a0g134KQr12H
         y3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748437298; x=1749042098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WdTBfL4v5yjVyTe4ji2bqNzULXH9IrkaNLBy8k+ftBw=;
        b=TVO2WZ0Dut919Wz2CJaSXuQ/N8bvYNnBXmeoM8TsXA4w2ya1ol+yZXwNl2i1hPOfu/
         1K3fcU78LA8L3auDp1T7HDGSL/2gmR58v8KOYiNRENUTJg1kc7lXhLK0yKqm2qMZmi7f
         DhuD7UdfYAx3kXbbFhZxj5e8kcijDgx3Phunb0RGsKgDzC1cRVUwTHybMxH4Bcf/Z8/X
         A+WkJ9uwgJimpf5Xzs0ghPxAOJ7r+NMWBo9yWtDfv77xvKmY/LQLkSRe38uEExf6i6Yg
         OKaMqZtt6AfrOvbHUp93GmfVRDVVC5qXEecvMEspZbl+nJ8QY28bNdEPQlKWEqSGM2vM
         k1+w==
X-Forwarded-Encrypted: i=1; AJvYcCX6+b4/TiuXgXTXHM8MzsKGDkCRwXuNXe+QEHxVjhpH33YmAYs2eqzGfpj7J6GZ+PBee0mulGYr@lists.linux.dev
X-Gm-Message-State: AOJu0YxfJwGi5sJFyxcyDUOEctF8kBzTU9poPnKGhhkqZW+DM50uV9tn
	bNWka/S7t+iYG6apyR9b3pHaSdSbmdArQcFqYFebFAM8fGFGn04Shs2KWq73JlA8Fqx7LE+BHH3
	6wV/JLf2L6oazhUlh5yebN7OhxfOndXKNZcHNWs3lDw==
X-Gm-Gg: ASbGncsjzdzCv0y0yzwymufz6kFri0AljRCF2PWoXdWvtuZntsqtFJpUmPb9cBoRXn8
	Rw8x8moh3pxNh6gTwqc6B6zBI9sIs40S2n20shT+njYWBLJ9dL/NymB9f6p3LVw2HLouAGB/+AZ
	fYrL382sHAGccZnWTN82srg82m1E5yZ/QZ
X-Google-Smtp-Source: AGHT+IFU9HRd8Z2NHXDUti6Rzo2QxfPYr9ibpOVOYfcSdksMHy6ckLo7YTZaTUCa9+aafWQRbLsvRBJms4rHDxY/5NA=
X-Received: by 2002:a05:622a:1146:b0:494:a099:daee with SMTP id
 d75a77b69052e-4a3800e6784mr35251551cf.19.1748437297821; Wed, 28 May 2025
 06:01:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250527162445.028718347@linuxfoundation.org>
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 28 May 2025 09:01:26 -0400
X-Gm-Features: AX0GCFsWHcrqN1_NeXTzUkCpGXT3fVMnMV6OhgqOX67GdQ4WyBq7Uin5PrObcX4
Message-ID: <CAOBMUvgRZmc=Q-dCS7X=9QzFgUHzgkXkqAtNcncLZUi+Fu0Zxg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/626] 6.12.31-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2025 at 12:45=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.31 release.
> There are 626 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.31-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
