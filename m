Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B23C3D16EB
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 18:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773426792; cv=none; b=Yns6U6oDjE5DP16H96z+sO7BJ1+kJwd406zMxC+eADYwEf6hjhWpG8JAccP/o10R1nUSmwsWpsNy6xwGKKEYFNZg1GNOXw7bm+4lS+jCN7GA+X1uO6hEKWLLzUbVdJaEUYUb5zi66Nnqj9fH/M51nw+viHSAxgUAqxUWmiV0egI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773426792; c=relaxed/simple;
	bh=5PJ3XjzXks0djshMWOA0orzo+ZK+NY1YSBqNSdvZbhQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QH7OThKTnSqLnSoNBmnwX2ijX2/SqHWLQ11srC2Pp8744aXTKxwqHgm1NAjnN6VhGJ1bzVnZ7j0W7tp7jrTlajziyv2oxWWQP708CmWOt88561+rOEhMvAr8xFQpKe/9Sc/T26ORzi76dEywwNWqRVgBm/tz9DPC0QIHVog7eT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aAgc/Tso; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aAgc/Tso"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-89a018cbbf8so44951816d6.0
        for <patches@lists.linux.dev>; Fri, 13 Mar 2026 11:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773426790; x=1774031590; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gFmig18Rs8HEf+yS8y2A1zLNsyNkgAYrZGwUpliaGQM=;
        b=aAgc/TsonDsHcQ1Rb4ygTXXlW5DDX05+43CSfo5306EotgEj5VSAbKGD1SYg5VsinC
         ktTOQX1vUyeViSHsSq1wpupYtN1zMhP2JCLzGW5Qj8opTEQfZ6CjzN8OYLiJcOkBLMlx
         mud2XL+iGDvShWbWxprlNBRrarldyWoJ1YmUYlK5ckmjpBNRGzMJ1Ov1pcwjhS9ZnVld
         N56TmGacpWL+toTJDS+zhz6jRoA/nyFNjrQigBA2BkOgwq0eC5pLCPN4ByUCWdXRzoHJ
         jC5kDel1zFtAlELT90P0H2Kdpe4cyzh6bf4fSQL4wP1WZB+3X1GtvrnwQi+zKFpyYOrB
         SMEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773426790; x=1774031590;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gFmig18Rs8HEf+yS8y2A1zLNsyNkgAYrZGwUpliaGQM=;
        b=cy5G+b8hFtbGJi7dHOWmMjv1EgKYBhAK2GHw6TFhuDM/PzVU85BoxPf0D/poIcKxNF
         l+sIjSQuDTkbDa/DrQZf1HlmWhAcFbTht/k1KcdqmLGh/WHK5KgQxvlCyz01d05tERPX
         DgzBK/OkQB/wZrdDGLFzjYFx36Hdqo6IoBVzRXQkbknA+9R2kk0Aj5V93igRR+j/Bbxg
         WPiAfHqIgc2LwlBNi9o87zVqVnHHXbERx8OPSlz/1GDykErposCS0ySwx2MOY+ZbIHy0
         gnqjZiSiGtn4Tao2ecViQGasTwqx7polUqZ993iIbOb4Q6olBGTk4VBc1c6wwiB7INBX
         PDfw==
X-Gm-Message-State: AOJu0Yw4oeBrxdZRvlAKOlziWmP7Yh4IyXc4s40YOQssSntw+1FwapZH
	5IS9fgLnn8YRQPyc0D1bmOZFyNTqGsDTFcyfBtie2qKwQZsQEFWh4gg0
X-Gm-Gg: ATEYQzwAuBlI0Cq5EXgMxami+Hs9YMXxzdFqyFt8vd5Q5tBjp2vyMqfSSZjb8zzA5gC
	DAB10k5Z4yKDbsgYCPe9ZcjQdFU6VL9oYURljJY2iXgVw+sOf7LtxxgBwp1wT+IjBCWGeQlsO7O
	AIuKfCS6upXGfpmqDhhV2Yu69LIcCzV+8P7fA1UV9y6gy64KKPJXfDK2FAdPQXRERU/wKoSBrWw
	kUm2S4bmv68UR6svMCwLQrs6FNp6CTcRPw0rQQeBG/WHe+mspQ4Ho/GTK+eESisN6ULN35nmT6K
	h+gQe9Y0Z4lMt0i8JAkymJOpwThEU7fbcmUKzL7zeIT2PeG8p7xOasxghrmnPFvSV5GWdedXolv
	vunBFzRcOx4Jxklw0LALg06xgvNrOnDF1HgIHiuDCG/7uOJV1g8RGx8M2wABiTV5R5crOUXGsN/
	ZmvU3SsooTOLuEVT1g788xcMndMw4TseOTGEvBKLTztqQQvsB5Zw==
X-Received: by 2002:ad4:5de8:0:b0:89a:929:3d2d with SMTP id 6a1803df08f44-89a81f1dc99mr61275286d6.16.1773426790417;
        Fri, 13 Mar 2026 11:33:10 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65cfd520sm62894266d6.36.2026.03.13.11.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 11:33:09 -0700 (PDT)
Message-ID: <b4c383ce-5362-451b-bb9c-e62a66cdb863@gmail.com>
Date: Fri, 13 Mar 2026 11:33:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 00/13] 6.19.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260312200321.671986598@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260312200321.671986598@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/26 13:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.8 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Mar 2026 20:03:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
