Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B2D33D6D2
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 07:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773818216; cv=none; b=cPPrvF2n5bLMYV0jwLNPKmHz6KNfk2CN+xorEeCETaXy9irArrx5hWfGrKP/gDUxdWlT2/rmGZCcCQMm+BcNM1eFvEzQgqVlYlP3EcFFIvxXFRhZcaAYhAICnJgp05ObZFUAQyN/2AQTWTVVE/XW3bfORonaIuTqq/kTKVwq7eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773818216; c=relaxed/simple;
	bh=Nf80Au6wCKnLR47bZXhrqtqC3C1ce/Dk91infyE9yeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BkU4MKciZirB8FlTalP/bpB4ubilDeCdhC1YFs3qOplkMhLlJXoY1BxDuqTN2YnIc12az4QdGjdaYcdX4v+WlFYoid9C+TAmcvebihqfR/i2AANOx6Il6OuNziNC+aQeaG1namKZuEU2CYbCQY0dCN8mzolCvHdV5LH664E00TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X5hYn2h8; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X5hYn2h8"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-486507134e4so17759395e9.0
        for <patches@lists.linux.dev>; Wed, 18 Mar 2026 00:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773818213; x=1774423013; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GsdordiQBG8KvI/TOVG/4SQIVN4E6bDexKX1lez9BHc=;
        b=X5hYn2h8VCAi+sUq8pOD0/2kHbRo8x7Zq9qJwkPcMLzUZyUFFZfTprYuAklQ7DGwjr
         PuJnZ2Ffh1Wdq+jMqdfMeo5YHGHUBtmGh6gub8IOS3NqhmjEzJbbUkfm025Fzsn1ckzi
         w+imvmpLkhcRV8hgjvz0o7Hwc2MFwiK5bokpWb1jBWGYN1YBanZq6goVasYPM8JuJ8AY
         Bp+/hwLadP1hA4LtQgiW8u/gHq7Fd4OLNHBpFlJBJFjU4BKX7KXjn94rHD8OasF8vT1u
         Da46LUjA1SNMSW+jzKGIQUTGztIehbcJp3LNAbDsoNWdbh9cExBgXJc5T9GAdif2vgU9
         /XMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773818213; x=1774423013;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GsdordiQBG8KvI/TOVG/4SQIVN4E6bDexKX1lez9BHc=;
        b=cEHj/1/RWAZGiBtTTAJwvNd2ReX1jmbxzfggkXCqZcWWbf/F+CUqs5O3EaWkh8mTN0
         h8Ab+uwNK4dTh05s//Hv0bXbMEegYKmBpfRKkuXmLJvquvg9nBjnqj0iA/ZKm4UOoOMl
         d/Pln7JaT9vD/0KdwivzP+YzPuoMGoxXa4iyMO5Za2R+oGs2hZIoN/bP9hIyIPIbHgy5
         bfD4D80D7p0yWB1kSdFPf0nZYWFr9qIe/Rke93QU0BvC0CjHMZfCNJjFZtnFp1BT6VWM
         5yi+inX7fUAS5PlmV/IH87kBpfgn4fIYrtjpAFQnkKY9ry70aKPWghnjBv0FoT8c+E4p
         i4Zg==
X-Forwarded-Encrypted: i=1; AJvYcCXNMxuq/XQ4qKA+eg7+qB9f5u5X/BSbetbrqEh+UbUKpI2LDTGlCiN40X4+88fqA+Oje0G0ZteH@lists.linux.dev
X-Gm-Message-State: AOJu0YzO8fOxT7BCWD7aXOiZNlt16l8Le4ljHf/EXViNtQWnBioP1VgC
	Lh9zAEgIQaOF4O9Lh5dWkUczQ2vT/WRBRwMlLJ/HRJgA88eQ4vb8LS8X0Do1YjfiqrI=
X-Gm-Gg: ATEYQzxn8UP+3nIui7IssPyjCmT3Q0qd2OHBpNZi5DXB/NBoggjBjo3fj4Oak/y5Tkw
	4zL8NDL3aqjDZQK/5hJIFjekW+qu8sjnSj/k9kB0DLLirt2oqbrr9wIuYIm7LjyOl1GGhbfq2gP
	mmKHBLrnOnfe0rcBrwNXAIFzfgRALm7HNjDB60aMVIdrUMBfGmPxg5xmnJTEr1yd7CB3qBbCgWQ
	tJPpxAX2LZioCAvuMQH2fKrW6HgWt9J10Rs0aYmYyf++BAjGr81EqFI/aLzMOck+Cl8bpEnHwhx
	NPUh5v5oGd3Wpb+bn0DZRkUM7VjWt/HSWwdAktFoXhsMkkW4A/F+DGJ5t7TGPQxNnk1/dJk4YBJ
	K3cXl9iFsWng6R+CquDaMr6rTqSZkvdGd/MrcriYV4SlXOO48MpD/oS8G3XLicSsO5wt0YJGhsG
	pjhx3UUCN7Jq8LwysDVxk=
X-Received: by 2002:a05:600c:1d09:b0:485:4388:348b with SMTP id 5b1f17b1804b1-486f41fd356mr38112435e9.0.1773818213388;
        Wed, 18 Mar 2026 00:16:53 -0700 (PDT)
Received: from u94a ([2401:e180:8d6d:4286:a96b:a815:7332:44e7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a6b541cdfsm1612786b3a.1.2026.03.18.00.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 00:16:52 -0700 (PDT)
Date: Wed, 18 Mar 2026 15:16:44 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/333] 6.18.19-rc1 review
Message-ID: <qh44yqp56wymolegs4gbwnbsyb7ogzwwboyrv2feqftdfbo6n7@63i74d5f45ah>
References: <20260317162959.345812316@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>

On Tue, Mar 17, 2026 at 05:30:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.19 release.
> There are 333 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Mar 2026 16:28:59 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/23211625016/job/67531397844

[...]
