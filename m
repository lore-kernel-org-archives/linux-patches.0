Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59AD420C463
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 07:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745999063; cv=none; b=i9AdX0ZPQ/VPiHqEBDSe5KaKHNNIWgb8F8LscjhVkBjy2obaDKDPc13ccXBl2D7WCwlR4nkp8vMhKoJ+PAu5ikL7BdEaUnkN0YwFoO0GY1YWZ5ukLpPwNipg49Q+Facxqw5pljS25litePCsZJYxU95DPc8YE/Honit27xAyylk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745999063; c=relaxed/simple;
	bh=hUwRzq3kF0eovXWmvigA6hoYFnbe9C2/ZD8GyoTNxrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F/GeBJb+X7GFWAaRBXWJsT1hChS5HVb+bSqEOd5dQqwwKlIjAmp6ntsWHaa5YuuLVTILWiWacPf3oOmIqHJaqOqPmpnH2dFKXRyXXNTzz5/yFNIsAR12yVsuMUqLavfCE8oQLb+RlaWlnW4hbDRqNdP5gqb7eogr9z3cn1VrDqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=brtW11Ia; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="brtW11Ia"
Received: from [100.65.32.103] (unknown [20.236.11.102])
	by linux.microsoft.com (Postfix) with ESMTPSA id 84947202094D;
	Wed, 30 Apr 2025 00:44:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 84947202094D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1745999061;
	bh=NxFpXP0IH3xpH1xAOXFlnEEkZye4KjrFHH+kwNi3v2Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=brtW11IaQfOmqxgq24YuBTzTfneQNg43c5fzNkhZYUuHIakISD2jaHW4okUIA/J0L
	 GHaA4YvoTedKcqxXFoL5RdzYhTYl9kS+rRBoBijFBm697fBTDawYEpWI6Fku3Ek2XM
	 4PKjMCTMXkNvoq0yPSEuMtZ6c2N3xZdSs0bBrA7c=
Message-ID: <5f5d8335-31c6-4eeb-99d8-8997b64372d2@linux.microsoft.com>
Date: Wed, 30 Apr 2025 00:44:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/204] 6.6.89-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250429161059.396852607@linuxfoundation.org>
Content-Language: en-US
From: Hardik Garg <hargar@linux.microsoft.com>
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The kernel, bpf tool and perf tool builds fine for v6.6.89-rc1 on x86 
and arm64 Azure VM.



Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,

Hardik
