Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50681F75B0
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 18:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737484203; cv=none; b=cq7Y2doxgMWql5abTbTrm0Uj2c83Kf8Hx0wvlkCiJJAs46T//rEVwPHj4cVfpqpg4U4ObxXx9EURo2/oqH56MfZLkVBjkZlIq+2Oco2PXUUeuJllTyWJ3lVadlnJZzJxxbBXiIkDT1ydLsLeOyfha+ECmcQ/ph1kTKauH8j3DUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737484203; c=relaxed/simple;
	bh=/vutXnYVmyhQsjwRtKszcejcdcDtsokLDp9RgjxyHgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qJzLA5AbYisSW3D6dpYZCcRqR7so5+1+F8fC+PBhPfW+KiDD3mHm2mJYrma2N4jfHAgHEP1uSeZQygP0oeArcXC4BWEaKVofa1cPLuVj7GWeDXyYXsKV/5OVo6RIBdxV/VSW3/UwYW6kOvDj6GFtHCiFwPf8XPGEDDmXak3CAh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LjlSmUSc; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LjlSmUSc"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3ebb2d8dac4so3513052b6e.0
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 10:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737484201; x=1738089001; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Wh47sbhBkhnOFM7hc3tO3sny/2UZwRiDWNjSfYgQwow=;
        b=LjlSmUSc0NKz0SCDZA2x+BbphmXilvPjKfTS2JCQvRuUF6Wuo7N1n4HY5mauw8t3n4
         7BcINjBzQSYEXlLVBkWXZa7UjEQq8ZXZwLwVtvCPX9F6zYaHDNJRE+EUB6I0nOR2T76N
         VkbMt8ZSMkjbk4CY1lrrSQnv4vESc6nvMx54vWTHsulENNsXqNnUfNH+BVvWumbks2a0
         qNn223V+NuX1VZdsY68TdC14a8ZDm2PdIdj1bLmQUICPOl7vtuDUhBs/+MdGpU84JbFz
         aJnc0M6d3swgZQjQs3nIhkxMHH0lq3SSAu0YqgysnjkCK84v8ElJ9XgcHBv7vkA8cjti
         45/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737484201; x=1738089001;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wh47sbhBkhnOFM7hc3tO3sny/2UZwRiDWNjSfYgQwow=;
        b=vf/qboiVTX0lbFP5FflTndqJpedRWI3No2n8B0RQhoXzMkiUVxTBNlhp8k8cO2FvFQ
         SxN+Rkh3j9zJGYeZ3ismhorCu46smQbleY9MCA3SthYwngfA7AorBQEBU+vYhjI+2dbL
         y8NJJ9m+f1R3csE8wGJ26Bkf7W72w04EsPqfkJVz582yA8kPtZIeccrDv/E7etvhTUt8
         uCEz4VV22Q2koLpfCHz1seYTUaLsflLAMCAwub1lB+QOaMpHyr62QOW8jXZOZ+49OnLL
         E8i8aMwjfy3KGm66yl2TrasYUl0/9jhGM0JraafkyvLpy8Dn+WOhhJz13/GpJhcwLYVB
         +4Fw==
X-Gm-Message-State: AOJu0Yy/Cyra0e3CQ+19OPjFRelQKjSrGgHbTfk3Rs+SRdE4J1+y/HZy
	6oIw6EYVFkXhxsSnLbrG4VO45LHltiqb6fdNNCym4Cj4IEePGIbd
X-Gm-Gg: ASbGncspY3vEXEdbgavfWcLJ8FE9GLkYo9HfGEDd3AY95ILde9N0LQokTwm/OOAR2w3
	z2MsmhUwSUIJcp5uOPDEAUdH2EE/qyO+1NK5JBYsBVZ4Vq5axZJ06wxnkxpyetVR0AEA5Q/nrdL
	jSew9eewSyHQjEcqtPNKR+/QlC867P2+eziE27+HkAIvniyTSDIYRtuDA2M+0WxL0LDBbNQPyIN
	o+ZhEIjsWO4osyT5eVzOU2hsloJ7ufPXYZfhD3O6omaorQVbRZISdz15sPwUxC0VAVQ+dkY0erl
	nlHq5MXXseIHkF2tSe5o1g==
X-Google-Smtp-Source: AGHT+IFpnp6zXXziD/ch0fbPFm84SczsVSxBkEfBF9GcIwu4ur0suMyBrGb5I44oQYGXqHrP+45bCg==
X-Received: by 2002:a05:6808:831c:b0:3e6:22da:843b with SMTP id 5614622812f47-3f19fd30cf0mr9520809b6e.28.1737484200775;
        Tue, 21 Jan 2025 10:30:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f19db9ebebsm3125883b6e.43.2025.01.21.10.29.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 10:29:59 -0800 (PST)
Message-ID: <910f9798-cb69-4c00-9980-57fe799b5a4f@gmail.com>
Date: Tue, 21 Jan 2025 10:29:57 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/127] 5.15.177-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250121174529.674452028@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/25 09:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.177 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.177-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTb using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
