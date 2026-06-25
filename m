Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D830232936C
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 13:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782395655; cv=none; b=qeMPYvBKU47Vy8tJTK+0kozF7DG5Z57M2OdPTkzVTLLNfDycmpp73fVaoH1cm1LY/v4r3i83XRFEOFX/DBYmXnEcNSHZgHjKLKyIonPyas9Utvr5uEU7BoScfjPeXE6xJ8QRNXqejsd2DSDHhu/kk759rM9efGncFBb1xRX86Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782395655; c=relaxed/simple;
	bh=LG7nLw7OUYoPbNUTIUvO+GzE1e3hYi3mRXdDreFv97w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UVaQi33+oKqp0tFKeCrnYn7lLHCctoEpo9E+Y3NXxVIqU3Da5Eyiq51dBojY1VHDQnaJAipVTT0hm/wsyATKj3Ry0oc4uD4/lE5GejLzJkMqd2l5YKO0q8oE/Dk5xpuWH1Nvv3/PkPiXQRCClByrC7bVRoRPACbzUFtSWMOydGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NGHMGKNk; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NGHMGKNk"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-9158643e538so178222585a.1
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 06:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782395653; x=1783000453; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kvt21rKieVMVkzHlfovU2dRzd6brOlyRtBK6C4duChU=;
        b=NGHMGKNkTAhTgcc1uWtQPNKkfiqZ8ovNKF4KBTD4N3ac/VxATa1Ij/40BLdNET6FV3
         2iNRhzNvMKBwiHqQAOGAaimGNpdvLKKxK3SW8XoNxnYWmp6+pTAfP5xj6Ylx+41ZqIbh
         MAs3LLXIZf4IQol/o6vJtBSZkex7L4s8HJsVBNhL2oBjDxWjTC/4rKIMvecDG6/fosaI
         v1//iGlpo43G8q9HzN5nUMj7bb1UlYH6gxGAU4buT1INx8razfNwfjRT/ky0hBx++08I
         ZitDW/+5tWxe2txeZveAfCGSCmIosLwMaZbkAGTGQOqHbMqMLxjMOdnoXlErE9nqf4if
         p9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782395653; x=1783000453;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kvt21rKieVMVkzHlfovU2dRzd6brOlyRtBK6C4duChU=;
        b=mRUVxyQTwzIyOeZsWf6fmqMsGuFzJow4QGHtXcHSNf+evyeOcbG045DWkx5lAkRnv6
         ZQoq+X8U8kXCwNJIGeW/ySGVJAQ8x8SwcjSp9Bpt/tQZvlhcmReYqquT7DOVZYL6TyUb
         q5l2B66i2nwmLTqHC6ABgVgJ5U0LSBvVYHe+AjATybNfYJ6kNmRclbqk94zXUiJekqSi
         VK8Nwye4xjC5aaymtVgGLUGAgA38AmVXwG98kpwmFmoLswj2V02bSJtFHd9OKJG6doQN
         Jd5k1C3UOyJ86J9PDpq0FH+zFYn+vVwA/BK5CYavBLtJseUIkbrc83IhbENyj43gjXhk
         4Pug==
X-Gm-Message-State: AOJu0YxyuuOjrV2hfuXP+4ngMSzv8CWL5xZPzaZ+ERLIoNi+Jh2GKzFD
	J40aPwoVOEd8DyJtAmZg5cL/56w8s0SN58osY2ywMp3Pf8s1m+RzI6qU
X-Gm-Gg: AfdE7cnXxiB1L+Fh/EfZOHldDNu8ihHUvEc3/nUVxzMqe61EcMCzzbc9APQ45y5eIu7
	ESmbn4wLGw4OGKtQCIWb1z17RAOJS1QpoPPD5zm8cnSKgXee0p0U+CGrgoQrNIGEQcYRCODIGv2
	eR780rFCoiay4/Tjrz+XulZS/BoQkFC7afogsU4NdQL3jTi7cVt76zwiTA7T8FwO01alJ7lf/z7
	6G8FwZGFMXZBJKZ2x7eaHpqrJ5+Z16fjZB8GhReaCK0Th+eh4pJmlu/+4CBUWrHZOZphjN6jixc
	wQIwXpMOeybyDozUuueEB5U0InX9gXVqgIDHMEbDjkpAKdGrFjbme8bjqYpLkDyiiviFWyiANrQ
	gAPyAtBjJRJ0ClvsfmqW+eCAjZTp71HJ7N3sg54ehZNqbpXD4Gx5UifhYVgWHwjVG0K+EAPt2c6
	8paczonk2h2AivUmITxqUEqiQWvMFT6Q==
X-Received: by 2002:a05:620a:198f:b0:915:8f76:8029 with SMTP id af79cd13be357-9293cecd3f0mr396331885a.44.1782395652719;
        Thu, 25 Jun 2026 06:54:12 -0700 (PDT)
Received: from [10.178.4.71] ([192.19.176.219])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-926000c31b4sm844933285a.23.2026.06.25.06.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 06:54:12 -0700 (PDT)
Message-ID: <3c85a618-4a8e-4961-8e47-882557f23e12@gmail.com>
Date: Thu, 25 Jun 2026 14:54:06 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260625125613.243729608@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/25/2026 2:03 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.2 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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

