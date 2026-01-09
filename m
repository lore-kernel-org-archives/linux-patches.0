Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B12B27FD48
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 23:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768003198; cv=none; b=HLxSWlYnAdVy/+ys63VNIjdGWQk4uQWxsFRXtj9E/lOejXA/LyY3Aqe0NH1CLjUSoQpbYlK1j2AdrpmsMrWU9rP2BRBB6OkpZmhS4NAH+SFctuKNXOJgwVFi0B4IL0MOn1iVbrlADr3s0GXI87MhqFJKmlS5ONA3h4Ru8lMED9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768003198; c=relaxed/simple;
	bh=uWSitvL2b4yQ1p4cBPEe/a2jacnqOWLqFz5hk4wicZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zp9iKuWBgD/hj46t/aklbdCVDenFqCP/6rmM1nMaIIBkjPb3wH33v57E9u7clAesKSFz2YncgsyTwuVe14vBVSpbDunpAVf/NDTayEGsATBlzSNQlyD4n2CN+8bgCuItmWPSlhuVLBRiFhWEDWBnTtIBt3lKCqw+Mj3imgUduAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9gv8QlC; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9gv8QlC"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7cdd651c884so2622232a34.1
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 15:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1768003195; x=1768607995; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F4P0AoPZlzsAr9oF8m3u3/s9r9MBsSXnvxpJP0li1qg=;
        b=D9gv8QlCFvK6EyJaW6zRbgz6poPZ7vgN1gtPt6bIWGum2I8SkilOYdJTTyXUxilZMy
         Uv3nXcj/yVWSytF9QGO/ItEfdCSS8sjVUFN/3aM7NT2JeHIkkBTjEBzJUsv/7TsA96m/
         GGV83wKYSRzhqzwsxIRTl+UW80TLNOnTR0Nig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768003195; x=1768607995;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F4P0AoPZlzsAr9oF8m3u3/s9r9MBsSXnvxpJP0li1qg=;
        b=b5a4mm3o0F8cmfrX06O6kMlcGITllIZZJrz12ReDMjYepoBqootYrGfP63E8ToIiPF
         CWO7KFFjBcxwDkAGTEHSgA2pOaA4sGBCSaTRZx9VgpZ6Skz9ZEU2sBi0SN0jJwUezdkR
         3JcombH3TEwsTHlUmDEkcnjZdJirJY+Yo5XWU78GKpc7pRO+BA8LA0S9cdjKFNbK7QDB
         nOZbMP0/7P050u0Ok1wRI/paqfwmo8sXS7XBuUIEN0F6REhuOZoGGDn8TKKXX5jCIj1o
         i3kHr0vla/C+Mb1dcYSVVBJ0LV+xNPB8KV2h1KfVTtp4P+e026JTiZSTcMk4/vTY67e1
         VCbg==
X-Gm-Message-State: AOJu0Yztolc9Tn4v21Cx45uFL2vUOyVVExxOM8G0iLRwhDPyeLo3AURs
	xe7J4fp6wultPVHo2r4hPd5iz8tO8BDNjO/y2sqjM/OUJc9XHswtbjWLtjn2CfK/X1Q=
X-Gm-Gg: AY/fxX7yRuTf2/MvU12i/SoFk1PMcrb1A/w2Xi4cFTRl/dnUnpIg+Uo9LBBdFzzsKPt
	kC6bEbkOLzgdnBBaWLa6xFmg8uEqSxC9YS46aVcs/3FbsQ31nJfxkzviHG1KD9VVVBqC9EEsoIu
	TbP+fzKSqiQ/sZgXU9KQyvvx0jEOIeuupkXZZKylBBacjYigopAHXOxGh0A3d6/ans6XOqvodGZ
	AqgATdUnixxvTMVT5o371UbptEQ1KLl1idSYiUozXYs3IgteHyJFq+YiISaF3KoZRpi54mr44U3
	HSfyexXVz44fUpnZ3zL/zXHLCXVVj9mfWWKqAWnUcUOYOQbaMa+39XxsQGxVWT5g8nJ70peGTUl
	eW6iKbbBppvdruxzwjg6nsdk2Xq24oo1sQcbiaD2TVCd/td7q1t0cFMKxKC3bvGckVqP5rSBLLR
	a6K8fUzxTBeXlBIQXIWQcLHYg=
X-Google-Smtp-Source: AGHT+IEZE1mIp47OiCnx57Ey17H3QmxJjSntd9n3xE4Ci5YznpqJ7xdvsZjlH6bqf0UIhw9xAHqbZQ==
X-Received: by 2002:a05:6830:6383:b0:7c7:7f85:d19 with SMTP id 46e09a7af769-7ce50a8df3emr7733025a34.8.1768003195093;
        Fri, 09 Jan 2026 15:59:55 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce47820f06sm8132481a34.11.2026.01.09.15.59.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 15:59:54 -0800 (PST)
Message-ID: <6af37bb5-1948-4a79-93c0-402213762ef4@linuxfoundation.org>
Date: Fri, 9 Jan 2026 16:59:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/737] 6.6.120-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/26 04:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.120 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.120-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
