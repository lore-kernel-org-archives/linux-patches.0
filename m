Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7183636DA16
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 22:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774303794; cv=none; b=TFwsMMVuIUslF5QNxsuWc+blDzW73aR3jxZg6k12o03JlXvS0sWaamoxiL03IFmYNLL7CDm7HHO+iH3V/u5iGrldA0xmRN7qvKIoeXcN/LMMz3JepvK9aPqfcTXYBv7g0t7y5OHDlUOso4HGpCJKjLt8zbmqIUf0sN5KiIgkrFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774303794; c=relaxed/simple;
	bh=xtdd+vLrZJR3aJKGHFCK11d8tfWyTb9aPILZwHJZiuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bt9CgvlvIEkVjPAJ37kCTms31iubwG0yWbe0vXPFIBmBDxEj5iOictQ9ez/zX5G6UjRe54vUbqkPOM5qSHJpS+mSUDHJWpY0BuzQjQ1gcSZMSetoXN34qa3+oMHtZ6FTHCV/hTkl2K9koRkMbBLJ6TaidPZeTgc83mzj3mRz+Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxR5xJSk; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxR5xJSk"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d7d50516e9so2578264a34.1
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 15:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1774303790; x=1774908590; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FPeRLxGrOuIO8TRxpkoeoYAWzJCSPoOx0rDLujnGo4U=;
        b=QxR5xJSkkaMH7GP144GKA8ctwaYFRUKRCA+bP2eio515m8j9JCNFmVOcDp5lDo+sfY
         uOYaxxLsKCwC/DI2WP8kPepWpFry+G61sQResW70Py0qL2MPV+EAj/rrE/298ZbJrO/+
         ixvieOP7uFiVHD1YTCk8Z0uWirCY+zCe9hnAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774303790; x=1774908590;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FPeRLxGrOuIO8TRxpkoeoYAWzJCSPoOx0rDLujnGo4U=;
        b=Fqr6xAzxk+dGJIAdZTbiu8BI7Hq6eXwciGqqAo21J9mBxbMkoAAdFBoh1hkCnNhi4h
         bNRaTm3s7VKTMc0QbJ2HshMpp5/PJchHQDb/HWRg5eLqS0vQ+GjAvUKzLD07CgjosSfq
         RAwpDanRDqLusut+bvNsv3sh+GOMS4mR01xi4N+ludvGdjKLLxRGbLi06pIUqqv/1isg
         r6Hc+Xl4jXHxGQCpWH/I/OUza4JyT+009XohX6kP4MSZp7I6Z57qRdKNPPm+s8sMs5/S
         SJGbMaT02HlnE7bRKIXyajba+To9ZGJd5slAniao8yTE9Zlaj+GV3RpxqiAYj/CsuE6f
         PLPw==
X-Gm-Message-State: AOJu0Yyt8cjoosxt6EUo9EWkdnupWJwzJUVLW9QgADl0YNg7DVCST7mH
	KYLXRXvuVbqvKMHvVHwws4yXC30pyRZEVy16z9GiIM8kUAEBBtg0qFy1bXXgWyTCwyg=
X-Gm-Gg: ATEYQzwI0sQNG5UmULET5+18K1+EPg8Hs+IzNNPtlVuRXXKIJU/wGDoHQJCRHfjaQRw
	yvrNtLTDZ39meM+oZr5l1hN2hYldramdpvAD38Fh4qcztmD+p39hstwZgu1AOVIxa3dl0gkYosx
	+cHFQtftH2sQVyFiEQkqDZI9P7sv8knGQuZNU2fFZJIiRFE55bguS93VLiCAMRajDsoN/jmVAX/
	Ub4No8a5yEUTQ//L8q5zaINleIYTy1mkSk/9vxmpJc7Tetx/I/fh/x8EQvB9bJh3O1AwbFZxXJQ
	GWtHfMvXQIf+ObNCxCwjLbeubCAuxKsj3QQiISmF+YdyM9gU6A/MzRV3aF3hvqR48OwbFOqO8KW
	V4X0a0K/uyO8IADWjjArL0Zn6LGpaTZVDkHillhgf+/mTtr6+29GfdwUn7Axs6DN/ULifzbtPrz
	hZSO5NJz/BmusMm8tUP5fRNWX1fK6pzIFhhr0=
X-Received: by 2002:a05:6830:368c:b0:7d7:e57a:bcd with SMTP id 46e09a7af769-7d7eaf765bfmr9193488a34.20.1774303790439;
        Mon, 23 Mar 2026 15:09:50 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7fbee2c6dsm7953910a34.1.2026.03.23.15.09.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 15:09:49 -0700 (PDT)
Message-ID: <8e78c25f-6125-4574-84db-ce054b36c01a@linuxfoundation.org>
Date: Mon, 23 Mar 2026 16:09:47 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 07:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.78 release.
> There are 460 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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

