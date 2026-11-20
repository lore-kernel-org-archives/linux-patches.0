Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795215275;
	b=RoMoaL6yWUt/+J0N/QX5BB5xPjb+4eqMkdI6NYPHGID3t7zMxA0sTard4hxqjK2/k9H2
	 n8hXPkPZ/bJ9YNKmVc1pcR6a8bZ/D5H2PBh5WqnthyBA1mvMctTD/qltNpPmgwJU+zT9P
	 gOq5d2EDeRUP0itXxauctf5n7Pxw4yzi1xpA8FEp/8CXq3lHcMmYi0/xl/HgvpseAOjN0
	 DmfaezHm2XN+vWfom9MqEqWgB5rTP0Xn48qtrAGknGs1UPXLDgZKb/2cHS5rN/QhqWOr1
	 jdG9WAVQshSKJmBi4KDwIMDjcal11XJOwOuTCg4EiIMvCW/H6TqOzqFSrBLYcHO1KHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795215275;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=7skHt+YrMSf45fvtAQB9ncjgz8a/0hFVmjlyc9Hg1bM=;
	b=v5vu1PVwzJCYMxOVqJprmAdcJ4g7YnFHr0NEbIDKXOTGtEcSxLQgBFY3VirQadJR4/ai
	 j2wa8H+1Vj54uDlY9s7TASBKCe1KX8jxEYnOAcASGPfDFIy5HpKyaAWu+5ApB3cJRqk1p
	 +Y9AgiMeawpMOJS7dqGGDkRCQazYtS9tDSerepAPbA1vOtg7Aeb/LwUAlQbayllECbNOD
	 gi8RdF8V8dGiQ9y/s9tD6NM0lQlDq61a0JJw+ByzYnYf2dGUFjBbGstK5k2jNdOA/PTzS
	 dsvA74P35Qw7oXX/kivBtWf0ImggWjII1Lxyv+JhwVUs6sttoyaS0NMRb4tiBE/QylA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i5oAe8Ae;
	arc=none smtp.remote-ip=209.85.222.182
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4BC606A693
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 22:54:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E4BC606A693
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i5oAe8Ae
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-94961b68685so123523185a.3
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 14:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795215271; x=1795820071; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7skHt+YrMSf45fvtAQB9ncjgz8a/0hFVmjlyc9Hg1bM=;
        b=i5oAe8AeM03EIu+nk+7e7ydP++SqKZgVllkfoZTT/jJBzbeg9JXAEoY1xUJmjaun7c
         sfDMODoiTswwEXXkZoA0CJMjLYb292XkUAijZuyFGcG8Lux003hPHodrmt2e40ep2k0P
         hX6B4aT3RsNFBMiSZK93m+kX8rjicFP/AHI4474JzN5IsVo9WnTzq+EQnvWToUSz6CLE
         XZLHZTbbWN6YeQyNbbXd5Lrkdi+lxM8aG1fMDPlSxcnZBJya298L1gXeOrO6NbZlEkRi
         OHGNY6idXnPmu3LrJ2ww5mvAiIyygFEWQ6P8eaeVM6p8qjOl3ctCyHWRTEv8Bvns7OLQ
         ++GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795215271; x=1795820071;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7skHt+YrMSf45fvtAQB9ncjgz8a/0hFVmjlyc9Hg1bM=;
        b=XgjVkRehYfIPKStuK3a4pU+QcOtWb0+8Rk/y9FPD07tWxMkQ/vyqeuWGVa+rd1RW2B
         8sBmkuySCr6ZELhSOLaiBoznBC6k4SuGwntOn4UYK8fwYa0vznz45jJPWhxU8EMASKqF
         7AORLYKZtK+ABsxlpDzaCF8dVWrLOtYLnn5wA92C0jxDMc8MMkRnSKbJsj50Hnm3p9za
         oVRtEVyUWgZILnB9xVdArhtAwb7mG0PjbMLGdGND5NESoLXCYuyVUcedTnK/U1Qt2pyE
         pSGPaUV25MIoVecfp/+O2uUGn9h6Fn2ggseUl/S1x8YPv2pj2/xCl8E6vaD+i33xl6Nh
         joow==
X-Gm-Message-State: APuU4Z8ZG8BWltfFxVX702WsvQsn4eknoGiSorSCxy7B8oV2TdyMEcfe
	VXeVunwDjFj7pGbBBcd0qnLpXUK/d83ha6EtZXvHci7gZ6PxXHwzgKRh
X-Gm-Gg: AYBFou04SK77kKy4qeWXzRk6hr+CWKVr5ykNhYdL13Bv3EeKEpfic859gy16S6oBpts
	bpm83sE7W3QavKjHOT5hQ8ZnQqCIGRrDGH4uGyshHYvGga798YmwI3ytSkFoPCm2lDgFQw2bjjr
	kI4GlSUlooGFyVXu/Ee09wKjCnLZylE+hoFglIgyahP2eC5WW/ngJ1EjpeNrtW5gK+sr6dYay/s
	KKW3LofR8DTRdd3kcYyk7jSgaBVlDsSjiJD9ANobnBpD9MQVBtiZ9h2zRBeY6dAlam1Wer7NcGF
	BBtRP6CSNNJY3BTvER7hytAaFbjaEOhYL4LeopBXH8dRTxGoC7swzW71maBok4nfwRt8bRvgZQH
	+7/O8d6cnyIFoNC+ZxnvNYtNJKd/M7+u6erdXTGqu7xJ9heGnp83kJqOA/ZGF2iw1qbJ9Qcz3X1
	auBFRbVt8slVh5M/oVXTjzeIQ21kpue4OhUVrnYJNbIhvbn3YkfJMXu//Vs/fW2kUIjONKGJhi7
	ED86djbHHq/e6AiQkB0DZLp5JsDtn4Wb/c3hW3azxeLEg4095O+wYZaUVyg4JUdKaKl//AMuOTt
	Omw2JyhN+jJj26ZxM/KECyh3huTsHapAlidmaCeovBd+coLcdsh4Vcvm
X-Received: by 2002:a05:620a:4627:b0:93e:90e0:d2e3 with SMTP id af79cd13be357-949bab0aba7mr751067285a.39.1795215270952;
        Fri, 20 Nov 2026 14:54:30 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb3f1ee7sm295566385a.28.2026.11.20.14.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 14:54:30 -0800 (PST)
Message-ID: <f47e9c53-c479-44c9-b5c1-b118873f8399@gmail.com>
Date: Fri, 20 Nov 2026 14:54:27 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/2144] 6.18.65-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261120055114.182757740@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261120055114.182757740@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/26 21:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.65-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
