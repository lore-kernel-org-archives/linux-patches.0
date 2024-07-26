Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA8E22616
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722016021; cv=none; b=sEuI8T4CtoqaWcoJOcb1E3nusp1dJ650orgNcmIhgNXchneWLSZ1IYU1s8FF2VTQMkwzympgqiGaaKLqZtFduid0UI6NlAF8xC5ne6BEOkdzxbSyhWnU80R9fAHVOl2Px+g8RcFruXUiDxXGml3SAf83qC3IoHZtpwbH7+SJR6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722016021; c=relaxed/simple;
	bh=uv20BOradmm9ejZK6VE7PW2xqWKlQ17duNVIP7Qs/T0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oeDczoX8RAHW0Iz5zGjLy2zigBL1adxJGNKvAoXK7CV2fbwiM/f+bqxG1BfnVnuS8Ti2khgBXwFAJV9C3BhQwuyWpVODd6mRRFoL/93ZyUcHQWh8VYjTNBqNoGBYJqr5bDNcVtVA2NG46NgSsFlh1W8e15TMBIqxFf7Rt2lZGcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k6eQz+G6; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k6eQz+G6"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7093abb12edso760228a34.3
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 10:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722016018; x=1722620818; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Ld8tsTjI0GFd4Be9iWKsgD4FSHAh6Eekpaf1onWlKo=;
        b=k6eQz+G6sD5EoFa/Dsa2qKdyLJwTa794PR/V8lOjPUPcmbcTABx6B0Jy0tkvZkWGJc
         TEF0NcBKJ7FZP130jgTrH1x0CMhKTs2vCLILHVOYewBCrTptHWPX8eLCdfd26bdN6drP
         LAFMex57Zy/JmfSAIqShrpfTuIya7bA3KXFJZ8RRwLyIWwbuCTPcetR8Pke0elLP7vwQ
         r47TcY9KJF1wYFz+tmZLo/s5z58OACltdGfnFjCOYF3SJq+Kr7uA+3AQf0Abx0yOaYaf
         dloD+NZxBlZlS6kiaDH/OzW+ghWbxK0W4hN5zIgo1zjNSaZYHdMAbwUw0fufAHzjzs+8
         JDAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722016018; x=1722620818;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Ld8tsTjI0GFd4Be9iWKsgD4FSHAh6Eekpaf1onWlKo=;
        b=nEkJ67irdS5SnIS0tCD9cRJExcaexvezhYFmFJQ7l8wVyXAagyqj7XgoxcWNXRfRYb
         mssnvHQzeWJQdGa+vTZ6Pj3+oPZN/Fz+zDc6mjPiXEW3C2l33/rN4O3IDPQ5vha88tpW
         KaEMNT8OdzsJg7gA44aTQNbpr7nXQ7b8uUP+GF+zS5Zi+m/QBpplaHF2paUomfcYnwYy
         GHHtCH+FQW6a40MDpz+u+HbJg7TDwkyb8LAutRohK8a585qwQQE0N7YUeK6pS8LENB34
         wBScov/JfkPs4ruNtUJYw5ygsy+o5TQ2o98q22nQcFG+Rtve2SgRnOEeKMJ4vWUGIFHb
         Ny0Q==
X-Gm-Message-State: AOJu0YwPjvim08NrpGW5YdBalqGQ55KzH+KEbE9qSjri4eSb1b+4vNVy
	GREyOeyAZfFs//bgcBZlrmty2QXlh/womo5VLVM3oQC+2husT1+O
X-Google-Smtp-Source: AGHT+IEmmiJIksgvLCkm6RA8hE1G+1EkOzTaFAw1SJD0NdKtg03MhOARzZGEjAaxqCaQ8dsnGfxy2w==
X-Received: by 2002:a05:6830:650b:b0:708:c1e7:912a with SMTP id 46e09a7af769-70940c1564dmr352398a34.8.1722016018399;
        Fri, 26 Jul 2024 10:46:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7a1d7f221f7sm188578585a.19.2024.07.26.10.46.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 10:46:57 -0700 (PDT)
Message-ID: <08963e07-f676-4694-8339-f14b340cf247@gmail.com>
Date: Fri, 26 Jul 2024 10:46:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/90] 5.15.164-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240726070557.506802053@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240726070557.506802053@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/26/24 00:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.164 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 28 Jul 2024 07:05:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.164-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

