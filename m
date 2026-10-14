Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A8E483BCD
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 20:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792009989; cv=none; b=oJaxAizF/W/rbk6PyVUNHAO1F+i8FZcZBDg9QTInzZ2f80B4Ik9BjkcPVfTgSIkLFMzsxOH5xQ1a4dRFk67mCVd5wXA6718eJE8ndN+j9i2RNK9uZ7TIfPwzi3a6rjqUaKlvdrhzFiIi88za21H8xKTFg/x0GlZ4f7kMF/qWYzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792009989; c=relaxed/simple;
	bh=7gVQWNdu44u7syl2CpxBqBL3hioj2qZM5WHUTPtetmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Isy/LB/1nTHIubnOjSYQ/Mfdw98ltOcAyhUIuyLtxk0reCzAglO9FLnUHwUaLQV25DRSJvIBhIE8ehxJSKr20BlPoF9d53bu4IVrvn+yOhfstmHE2pYY55idJ6akoEMj7gYXLTKLRawHMMtad4aEApde8PO5RCMzhrZRXZcQP6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q/fDYVzx; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q/fDYVzx"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91b834592afso35067166d6.0
        for <patches@lists.linux.dev>; Wed, 14 Oct 2026 13:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792009987; x=1792614787; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pnlTwXurTKZ2zk8thHhM/pDYxwWJL3S5XvgmwZlUXBA=;
        b=q/fDYVzxREb9qWAaUP3x12I1iQjNK6e1QANYRhAm1zIwOtwrjtj5fSQIbF7XD8E4br
         SkQ/6LFOtBvt9ghud7i0eD8FLrEOAk5VZuDM0wQEO7Vqw8GeOwv+PXE319uRD6O3ylEn
         9fzE5o/hYCeeO9ELXqk3I7odM/vQgzwbDknfNvvQ7YmraowghSbtG9blgmgcjKKZABtN
         72EpeNAz6XbXC8bAsINnXxHLeNDubMeBb1iq9BIQEdyCXiK6hL6lAQV6zMSz1lPEf0Jq
         /36yrXR7Pf3WYfXOkOZqsTOt2DBO9aHs/w03/Vfiw2hS/wZClU85OBBbKDgQUQow5lsL
         Q6DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792009987; x=1792614787;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pnlTwXurTKZ2zk8thHhM/pDYxwWJL3S5XvgmwZlUXBA=;
        b=rjI57GJ08oZBrpLqD5KHdXKGfG9kNaBokZe/tWxoUzz/rYk+HMAtwp3OeCinc8J3JD
         3HoaYDA78b3QGnhc3A0ftDsWDGe0hzSIBzVnYXHdQ8qHOZkeXNGM/axkG+OKSvz/APtJ
         b99Wthii7+LDQd38tjeih2hHUgCFk+/CqJitxepF5TQO29WZiGPwdbjFO8ymC7HtYz8R
         /0IeBSwVqEXsBwJGkaX/Acq1MKLoiCmSly2YtZWQ3L1fYpJXFsp6unMZyhQrxoprXAeg
         RVFrW2TsT+L/3lyoy2FW6KKUQKzx9hqjWa1ydcrAf4anx5KIRGRyQbMaSnen+GpgScwO
         KSLQ==
X-Gm-Message-State: AFq9FYKYnYLj05y5qaDqiooQYWsrxGJefGgJAvxauzp8bCjYktAkXXV0
	oVdARZmVE6I/JxEV18MKLsWhcGGz66MipY/akBLWEQv+tN7s5BQx/4/R
X-Gm-Gg: AYBFou3UxMS5OMHSmToNi+56IHQvTJwp8Hg120ThNNMsK9+XTy4bWybdC1tijF4+/w5
	y5Yxz8VVmlvwG+7zWgtDnTAMJnM73U2pS9PU9DZkqPFr5qv1A5XJ1vr/KZr9MaFaO5G95Ukwnfk
	taSeTbf7sci96RcDCtEIxNZIbRtVygDZqoyTng6uhNOFYPH8LK3oje4ajt5yo7gZQHW0WeTVCKA
	bE6j8un5FY2kVgmZ88txqBD9KlBmsGqaMxmzFMzd4tOH3b8zvFQtANprSj2eHQ+GJyGsEVE16Sp
	y3RpfxpNyUc8ONk/v/PS1r04MraVFZ7BTzsDDp8hDv5eybZclC0VzugB44V7yNNBF5vWZCPMPNx
	z2z4eDBopU5IrMuTC3rUMn9i1oXOf45LtsxsusNapfRWe1t47K8S3K5UIjrbyScliPj1c5Nm5TP
	rAUQWB+//bIyGuGJclBtIAT2wzCT29H9MbqfjQJK2b+tPdUHJhatW4E7nxZcIZ/N/WloPYR0nzL
	DfGbuH85VypmMHm+gWq6USc
X-Received: by 2002:a05:620a:44c8:b0:939:fde0:a71b with SMTP id af79cd13be357-93ebcd2c13amr2744492885a.0.1792009986696;
        Wed, 14 Oct 2026 13:33:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50095bbsm583476785a.9.2026.10.14.13.33.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 13:33:05 -0700 (PDT)
Message-ID: <5931df06-6048-41fe-a262-575e2079067b@gmail.com>
Date: Wed, 14 Oct 2026 13:33:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/505] 6.12.113-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261014123803.944920639@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261014123803.944920639@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/26 05:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.113 release.
> There are 505 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 Oct 2026 12:37:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.113-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
