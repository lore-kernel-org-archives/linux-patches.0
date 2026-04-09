Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED71E31196F
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 06:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775715337; cv=none; b=BXnKrNRt/lWcBeLfbcHSxfmBta4NMDYk5ez5B5uskL9/kPWgMhrv8rMLrDqEmXUTSEqGMLrXax0bg38KvCj/bpiRkR0p2/zdh7mPfJ8N/JjCtZljdoRky3CIAj1WwceOEM1Y7/Sc4Zbzdj7BIHcJ8SFK4C5Q/2knPZ7R+Hm+BaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775715337; c=relaxed/simple;
	bh=gynYxE/cJH5GXtEhmWuEkMGUWBTMJgN5AYOWIKIc/fw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q6c0AeRBxvxyoTO7T5kdhsu6SQiNbM/67kZq+BXGI9Pv5ohymnCh1tFpr185KPtjOQlu9lvKJXPQiZ3st9Gbdm+ba423NroIFB0USmdX3YmY3tAm49GgLS+sLqJE59PATK1/3J89TVPQ+bpYs3qJlzwX7rkrnMs4kW6y46A73hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZmkYTwBH; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZmkYTwBH"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488c21c636dso2506595e9.2
        for <patches@lists.linux.dev>; Wed, 08 Apr 2026 23:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775715334; x=1776320134; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=unrWXz/BvVWB09BOLpqqeC5jaEKVeUeeeLOkPeGWieU=;
        b=ZmkYTwBHCA2Y9dY+5Gln4KP90urRqpn8/qUfsMKQ0/Ft2Vi/uU6qRUtneDwe1FgpPO
         YVRxNnXRIo7IhsGd44CqeffC4ynFMCXh5U+3JJsgZMCEr3rPoVGUi7p3SEeGomwoz0vg
         fYWi8+ipifUHVqM+wc6VevvPfTeyCdp1db3b4yx9/JRa3FLeqj1EHX2DxVDIfpOhDDio
         hnvwGWEphvBsQxYihZ+w+F+HYjmk7acBNC5zPLT+qdRgSIYU36eNY6hSyvFYO7tsCXI2
         do8BErQHaJqg9W4yHulRZ80w8p4Mm/QXe7x+HNMatAZxLVvd8lUNyTV0Nwz6Cpm4b+v5
         ubQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775715334; x=1776320134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=unrWXz/BvVWB09BOLpqqeC5jaEKVeUeeeLOkPeGWieU=;
        b=RjXdGcQx/9JUKy1XuZV4MHXPx0nARmvk2CODSK1DJtl2qvpSjwzG4L0M8uG37Q5q9H
         +m+FH21Znm+UsRSveRtLFkKN71jC33Wkcd21zq/USsIZevRTytwBHGGXH+RaTAZjAmX9
         lucmUgm+DR5vxJyK+O78BsFf33MBktZCghzzNIMRRg7/vHrmrSeK/HWBmAHX135J8if/
         os3HuY4srhnWV9LacSi0BRshiwYo/8fc193wkYsjZMM5tc0A0KVTstq0HsIjWqOu/O8F
         xeDnBH4t2xvDD4iRKzqXgVDY3tird4omKsz8f65AAYnMUVVy9xoHvexvMetmWEni4Z73
         H+zQ==
X-Forwarded-Encrypted: i=1; AJvYcCVa2+PwMEDUzwb8zjQuXVSpwPLGagGUPcFRNrUACwfRNqjcOp/Hd4xWuLUKR4A1KYa65ORoRM6I@lists.linux.dev
X-Gm-Message-State: AOJu0YwtYgstCGmy/OqSmrvfrR2klf5e1fnMgzcFR1V9pfG/QBGXC1K1
	rJecYBZ6NhkAkMCE7QsdbhTZwwablPdwcm3JiCB36kJXjzQVALeI+3JUxtAM7A6Zws0=
X-Gm-Gg: AeBDiet7uQ3EFGJytY5UZ1WKG8/aJzcRxEoWDJft/O+MukysHxXi29C/X5z8dO1jj8Z
	4fxDhVN6odMy3ZYNDudURNcaIHTupOwgwY2YEyPyU9+vw3/vQYlEUmfTfigcUXzk7ATJf1FFmLp
	7K8TCsqRvpqpgPqoVgti68Efwpwda/kagWIvj+NOrbYI6c7aqmCKoakv1VzP5dgYUw3/wPvMyOS
	72H7KcbX8DTZ76OIPbboyHZm1FxPhktyVIZPkxjPVsbf0P11zkLgaplMFiPZfbQv7E4+ZmXg/is
	UjxLBjPeaLkGNz6Fp9eollGKJRDFHG3EHdsWz7FPNbfosK9xYfED7koJR2EBzhjHE/Z0vKPd+4F
	SxscskQTnw+301AF15hson/pvPqTqKgdYcMHs+1N8N7BVP6RdKw40W18NzdibkpwalpdUtLwdn2
	WUg10BeNeRKW2FVF8uGtGOM0FfmBGP7Doc/soMUx7ZGafRRyc9
X-Received: by 2002:a05:600c:5292:b0:486:fe39:28b7 with SMTP id 5b1f17b1804b1-488996f08f5mr359918855e9.9.1775715334280;
        Wed, 08 Apr 2026 23:15:34 -0700 (PDT)
Received: from u94a (114-140-130-35.adsl.fetnet.net. [114.140.130.35])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9546344aae6sm4114265241.5.2026.04.08.23.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 23:15:32 -0700 (PDT)
Date: Thu, 9 Apr 2026 14:15:08 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/311] 6.19.12-rc1 review
Message-ID: <7we3hoy35kjuwbrzarr4266ylu4x4zcurpuhuhkuzhijbhq2fx@o3zp2r6kgvoh>
References: <20260408175939.393281918@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>

On Wed, Apr 08, 2026 at 08:00:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.12 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/24153838933/job/70487760072

[...]
