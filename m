Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9B843CE41
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784740113; cv=none; b=bDO/hAfYbXppsscIlaXvPQuELPV1ppdovnkDykLNYoY0YpH9iHmZOKB1kKrx6LeMzLuHo4GXDwkDENfEJp9UyHhHZP1F8/JA3Rnq3j9ict7LERR62OVfEP+j6dKnEI64sZs9hFNgq6/tjRrGL9+cnlwbkFfEhJB5g0cBzG3mmjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784740113; c=relaxed/simple;
	bh=SKWrcJccyeeVXyRR3KfRN6ZeFEydVVeyRSv1oaGQyoQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZG4akoKPZy7rnAgWUaHDy9q6rGcnQgRhEUsKL+ifQWkpzYZFdzbZcdiw4sTUkcsCIVooTfcvnbQ2PygciH2bopup3KAA7E/clMX9FC2GW3oDLHc6S5iX+2p6USxXOhvyqVYo80uZ7p+IqKZZxY/k4/M9C/0lphRmKv9YrCgIJX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMpnT17Z; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMpnT17Z"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7ebd88be784so5793927a34.2
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 10:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1784740111; x=1785344911; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xX7yio4N3t8Y+JNUzWpt1aRHfRlbQ7M/0cs3qHVOkuI=;
        b=MMpnT17ZLMyZtqU0xIBRZ3k13iHG3h+0xwd5aqbmwCDfF3cZMtgk3cL1xSF2qKX8Xd
         UHkzsujENS+zevqFH6q78yc6GHxcdNZJ4bV3H0sLjXt3IJc2wNqyMOKbXs6VSXozVz7d
         6tKGzsvY+/Fq79ZIYgbIDtLJ3J5xIZeGHs6kY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784740111; x=1785344911;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xX7yio4N3t8Y+JNUzWpt1aRHfRlbQ7M/0cs3qHVOkuI=;
        b=R9VqE2Sd14zO57htthhK3Hulma2yc0//DD45yfDJNsqmRXPvJ7QrNVrmNpHtCSCbSU
         ufINCDOkchi7EJ4ZhWmdgSyz4irBvtoW/v2Ji7vfQ50DXLyLP9s0k1QY+MYiQriuO6wa
         sJQkJbiQLiNOZX6cL6Zy/NOZ2foNJaeYOh8/S9L7xR/hxaTmVLCQpUpx8mpzpJyKZ6ij
         /qLihASW4BiemPifIIUgjPg2U9M7y54Sw7G9K6aqlgrgScpQRXEqYEX+1n9kY8uWqBM9
         lAmoArsUQVp9rVSCFbDVrEnrYYqA2enhrH6wGp+GUdzxem+4DUVpX3lLKWTk014tgEI2
         0k7g==
X-Gm-Message-State: AOJu0Yyqz2TdMrL+1Cj8n0sQsyz1h3ENBL4GVgbib0hqm3OdOKtFxCap
	MaXAZIrE3mIxNRwkVbHS0c8YhCYCQxKfjW5H1/4RMXC/aflVZwE4c8zFVW3PWa+uROI=
X-Gm-Gg: AR+sD13ib3qJGyTDn0zhIDIcjQZUrqNzB9LvQFDEOTiPRKCmoiO2fgm1qb0zcfidz09
	2bfIdrdTfYmtTB5p7lZxeMx/wrouXoSTDRJ6Q4aJ1Z4w/BOoJ4a/+GXmQcsQVKbRDamJSS4d5pk
	sNl6+cLyY6TsPKvaRWrwzinfRSS0ecLEVr2JbwQ/4z6gKXD0IaGc5XdLcfQXqDh72OL7lyh+NxT
	LRi9sN9TSBeGL3v6DKAmLeA16KO5Cl/uxsfKSJUFNp+6BEcmxNXf30XiaZ5z2H0Vvm9ETQ0jZTA
	LS3+DBFnbXYJXKs9EIP6lPIRonJ0NMjCtdP6DVvQ/TeMuz4TTXkQVIDyz4QVryFWP6KT16i5zDq
	JS7AbSdSrfstlPNTxZahhm21wjoOfuBOvMMOIPqzw0D5Lwc/FgvYs2i22x7xNqWMIhF+cO/0O0y
	TWJssxpOK+/m4=
X-Received: by 2002:a05:6830:498f:b0:7e9:c59f:9515 with SMTP id 46e09a7af769-7eda09578cemr13239991a34.23.1784740111179;
        Wed, 22 Jul 2026 10:08:31 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ee29db53fdsm1710163a34.4.2026.07.22.10.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 10:08:30 -0700 (PDT)
Message-ID: <48638deb-7d0b-407c-94fd-8eeeed3f2221@linuxfoundation.org>
Date: Wed, 22 Jul 2026 11:08:27 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/1266] 6.6.145-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 09:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.145 release.
> There are 1266 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.145-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
>Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

