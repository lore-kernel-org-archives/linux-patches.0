Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A1B3A16B2
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 18:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787076190; cv=none; b=OUZQ460LOsUzwk33GVyKajt58GeU6+0N4uBvkByr9P74u+aqBtV0JjyeKMV9QZpRgHdTWkyVrZ7VgMCS4mXVrhazQhSmKpdCw3CSy4+cEUgxjv35LqMMDaDfBR87fqf3KDVUFC5Qw5uA0RPAsk/Vi2h146u6Jmq6IxU6kfsBRWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787076190; c=relaxed/simple;
	bh=kux7923xqGElgDtYxjlW1kCHNma8Cxn+0IS7mbJ7Srw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=unMCYlchYn2HcnPJOFPHYetj5/Yh7ZrLtX9nNhvpsiNCDjEDhW35UG2wTSL2HvgQrK5IbftG48Q4HfYGXGmZv5qFB4CzBpPPkknXbnU6UGhwd33BUdOgzmP6sywrln8gNSz6otKG6p1uvxyiXcPDl+fYzkIO0ZkPRT5XDAdtjfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pa7Cf6hs; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pa7Cf6hs"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7f18c0e03e3so67864a34.2
        for <patches@lists.linux.dev>; Tue, 18 Aug 2026 11:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787076188; x=1787680988; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=86SBJV0XE5iT1q0TvIA359xjqIYiArOaY9A0khfcrDU=;
        b=Pa7Cf6hsT+yc0+YC4Yk+2L0sMyVykNWt0+qJyj2c2hH3AWC/fmWRtEHHkKyqnlTALA
         J/znYbZjxdERuE1JdXvCjnwfyZYXtDU3jHxebT++wiyku5qMAJ3F50aasYcPrQrCuvdF
         PjoFA4hVl9yFz+Pz3jMznrYONqM+D6H67C5p4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787076188; x=1787680988;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=86SBJV0XE5iT1q0TvIA359xjqIYiArOaY9A0khfcrDU=;
        b=AZ/E5e+uncdsh7hz//hPKkYlNFF4cQi15LVtFhq1BB6hVWS6/rwoWN6w8YDozucLuN
         /2jOcCx+09Hvluw0/onZ0Mb1X3PIJEOPhckndIOzNs7PSWcq2AGK0fptoHTGjB8O39Gv
         QFyBRs9TsnL6jkHWg0hRX6Ccd38sdlK6LCYQH9hJkno03XCodSw/InfArePxXSq4XdQ4
         M1WVxtWtlzYUv0k6Fc3Fcj1J1CW7CBCBNIO92WNjmSNLOHlGKi7Z3XrfyvJ5QIukaPAg
         1DjnFrC/MD34IHdJKarGyI46fIV2c/zF4KggJZgJhvrooJqG/Uft4HfWXh5FuXbMEM9u
         f33Q==
X-Gm-Message-State: AOJu0Ywv1RWwNmm51j4Eh7nlYmMXzkcri5MuNsv+cKePHBITRa4/S7Nd
	KHE+A6WGHRJduhkhBffi0tYvqYrjt5XqFWT7xCDaprui6JmjyvuBD+YlCxp9DSM7M/Q=
X-Gm-Gg: AR+sD128ZK4UZ5IXQ6tB1c8UQakN+Ql5BTTo/GpspRHgQ4A7tZkNa/IoPCh2lJcoVNd
	HcnHHJTi2cecnYBUmVTBul++z+E5qg5+TdPxaVKzrktXeRBuPuXyFeWplD6Q+QubpWQqlvoDGKA
	dCYZ40Ao8AD8pcjCE2xa5KI7+CVGzSBmNUlsZPAx3K3GeP4eTH6AA84k+NsHt4Wx5q+c6v07GzF
	7xHU9bbr47dKPGgcKuB1vTPvxUleBPZqFU+89sS93H2f8E4WL2c/FwGH4H8u8gn7W5rCZtYHypF
	1vTWYScvU7d3FzGdr0y3lP1marnqsd5P8sWAIDudYZKN2ShoXJbh2dWA4e+yeDeu3ZzCqjmgZkP
	ftuDlaDJFz/XcjmubtfXqfe4BSufXqaKcTRqTN9/eUKd42ENa0zoIE9SJFZ32NdV/Aw1IH1J7Wq
	V6P2SJornm6BokX3v2TU2jo2mcHQsSZKVPrTXcjdYFWnTQ3Ux9ymYJemp+BYT/sZ2B9LIDQD0=
X-Received: by 2002:a05:6830:3748:b0:7e9:e0be:583b with SMTP id 46e09a7af769-7f3de71d894mr31867311a34.9.1787076187678;
        Tue, 18 Aug 2026 11:03:07 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f41c0b93b3sm4759046a34.13.2026.08.18.11.03.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 11:03:07 -0700 (PDT)
Message-ID: <869474f3-45e4-48f9-9379-4116fcd6ebbd@linuxfoundation.org>
Date: Tue, 18 Aug 2026 12:03:02 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/456] 5.15.216-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 07:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.216 release.
> There are 456 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.216-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
