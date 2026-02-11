Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947D6469D
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 04:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770784019; cv=none; b=aZyh1g9JamGeXUF1bdwND+0fraRjq8E2H367hN3OGnFdPdkw1gqrl+INRtw4aIRb87zzK6Ge69YySJUhduko4cyDjjQmvKN5Wx7O7uz5M7vG78S/aUv6mgC5mOWY6VJjQirjAXTzfbpyyL9Nmo9i1D3Y1Vsx8PQg7BLWsmD6KiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770784019; c=relaxed/simple;
	bh=el2MolEaYsa13hzRlQDP2D2L86JXqf6CUr04VZbluyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBDbcyXb9pE/oR14GC6/mpMfyHBPkNEgxEgQe7mCnVAiyYPrHsR2CM1d/YCwZReqxSwM3dp0jg+ny7c0pcRhCb7QDrCj9NJ2Sb29Ol8JwcIeTKbrxNLQRfVWjtIyG6OuimM2c6TCKeSw7qeZPwB3kV94YUu0EXEqkoCR723xTxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JiTGS9pd; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JiTGS9pd"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-436234ef0f0so3682211f8f.1
        for <patches@lists.linux.dev>; Tue, 10 Feb 2026 20:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770784017; x=1771388817; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3/DZy8o0V1z5fy+JBWeGhUBVePIm2Ww+y98BjdrjoyE=;
        b=JiTGS9pdzcJNj3q1N7tdBB8LkvOIJAMEun/bramBWTDqK4N+7WxsAj1fiep4BfHXWE
         P8c7R5k9Ci/2cj0hyYCTiRU7PlIbE4gtfQajUFvY0+Jo7bQJpM02CkUDYVBT/zBy2qry
         6ie8cSZEcm9M7c7s9+A1JHUKuNWdYgpGkx5DHX7wGcp0J47nEOxwcZtmUAxUigRA6Uo0
         q2i5LoqdBWv0qvbB3gk2nh7TcgM/9bSrY7rObWoIT1GFTCMx5ZAJsG1ya83sIET0VoUU
         AFJSe3ML8wZoElCIX3K0F8i+DGlGC1C8CO2dAd0Jcn8Z6DFfS7W9gCN+oMns90/7y9Ic
         3maA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770784017; x=1771388817;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3/DZy8o0V1z5fy+JBWeGhUBVePIm2Ww+y98BjdrjoyE=;
        b=rrFTarjhGtbDjb7o4ypIno76Q/ePyxxaATu+cmJIuQcYkyQEkWBFEowoseFtdPrONg
         DHKYfjW98x4WPvVEX/h+cM7D9Rc7/KyfZPMhDAfZz5hZFa3V6op+wRagEwg6tiU0sB/8
         de6WzjDjMXeFsNZ4clN2gxAty3wi/lKZVJdAwCsr7OOFh7VZxovS4og6F5Ho2iy+i1GY
         6GxiCzmBwOSHTMFG/FeGmKUpqrHcCIQgQIEVwIZhj14wwR7KJozsSGpxxO4RIAyik2eR
         /Viz2WXz+NGqreM2w2oy5JtpL+ugCcyJYVXgDtp0yDSTiXY3Eb50tNpKVyaOanqysbN8
         kejw==
X-Forwarded-Encrypted: i=1; AJvYcCX1Y2Tjcb5V1JN5XsWQXx62Hknl2uo0YBKDEblymCGZReQj8fobDd9ovolIc+dfZS8tRP1XVig3@lists.linux.dev
X-Gm-Message-State: AOJu0YwekBUYeQz0id9XhVaqYoYQ9fXYoEhYHgaTUSyxZZqdBiMbb+Sf
	uPDKFf6OKksx//rpQvw+svgrXPV6od3K+ArNE6THyHP8LOJ0nFnvuO47ZO5EMvnN4r0=
X-Gm-Gg: AZuq6aJ5prjG6rQoo4d6DfGEweiX3OGl3/AUE0pFK+Zj9Audk1K+HbKzf4pa6gI+14F
	ZhpHMiRIXpLiblemZXAyAWWnqCbwxq6VNcvAmNx7sz1S6qmR0zsnBMngSdeCkubody+FrLKb43d
	k8SFw7JqupDbrMIYzbtNrKqduQui4YY2z/g2b/baUMxC06fjCUdoJdmsbPVi4lw3mMAk94Z/oDt
	AaRRhr2wpM5dPScjEHbIEJf6AvrhVjctS/dEt+6d2Jg8TigbX9LG6T+usSxA/wUEuFo6I98HMye
	qrqanOWJViZ3JWOQbbaBf+PTKCiI6U9M8Ur+fRYTnBcATf4xafMNMw4V+kH54exUMhAswlyPlKL
	peE52xertZuNLn36jL05nKtcX6DXUQtwPCui65KvE8lsPLyKDrrW9uM0vHudBRFjk8MjgdidvBK
	OpuLMkLcXlMKM0VLVXH5Myqi1YRho/C1u6yjm3rRgzAIY=
X-Received: by 2002:a05:6000:2dc7:b0:436:1872:63d0 with SMTP id ffacd0b85a97d-437845219ddmr669410f8f.2.1770784016940;
        Tue, 10 Feb 2026 20:26:56 -0800 (PST)
Received: from u94a (110-28-16-35.adsl.fetnet.net. [110.28.16.35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783d46f9csm1642034f8f.10.2026.02.10.20.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 20:26:56 -0800 (PST)
Date: Wed, 11 Feb 2026 12:26:42 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 00/86] 6.6.124-rc1 review
Message-ID: <pnekjfboals6uzxw4yb3oi5prykptikz6vhgcnyky5urfl27hw@4yagi7xv6q6l>
References: <20260209142304.770150175@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>

On Mon, Feb 09, 2026 at 03:23:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.124 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/21880634049/job/63161819172
