Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF091481669
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 16:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281078; cv=none; b=clUVla+YfhR7qy6oMF2ZTZDQwUs7TLB2vx6EtCk2RukKSWWtCKzRoTes2h5PRLG6gqklLxBKge2dhJkNjse27tqPxVlRhtSFjqn5KZdik1mOfsCkerZ7RruSDS9JLlisYwXJ3azi8jCsHWcGYFGvp/Is35BXvsVRK1A+k1HFdoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281078; c=relaxed/simple;
	bh=BE8xFo1k60gypSs4ssodFBplGIq/3pRV/lXZBQbcfQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KFZNU1hvB2rhQHUbAg7mslmQafABgV2Wo0ayKEjXcVTPImoZ4cJXHQiLgAHhNGomClk6zRHXKEiTCndo8IAEDiasM9vGITWW/g9KHht8kGJ7DUM+X2pyKCF/3AG2AJqoGHse28QwY3HCx0JuXnlKwTLz9ezUaNIh6BSEhRY439o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dc5/+J1k; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dc5/+J1k"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6b1334a3b16so22433eaf.1
        for <patches@lists.linux.dev>; Tue, 01 Sep 2026 09:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1788281074; x=1788885874; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2GA62kqcT+ePnUyibTOPCdIAFiDj+kwuH2zWieDVoT8=;
        b=dc5/+J1kcTt5MPXTTmw53//pFjKvy3Ba0f0evx6BGdKY6SORWlbme++Re/rkr70ejr
         nt9g0yNmG3CRsUQ51JyQ1+iDoCTkwjolSUGDYArxZH3oYsuacymNox5asFwYKq/lZGr9
         KH37P6IUnL8ZDMD3dr+inRRLnceJmfqIaQYPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281074; x=1788885874;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2GA62kqcT+ePnUyibTOPCdIAFiDj+kwuH2zWieDVoT8=;
        b=p/Y1a9bRQlWSUHWLQc13c0HmfLZxLi4KeSIOiQNYk5HTed4batbOE0WMLj1g+afdO4
         DtfmBahxa3kKOFqAADB84eA3nyxkaJ9OIXVtO4Gb0syoHlTg3USNw9pt/HscjTfgW6Ul
         ipmgOx1B1NAuKZBGManxHF9uhHwWX6YbqfLRPtis0s0Ph3WFvMhbkTGTND9fr/qT/HQ/
         d0mcEMjUTXcO7SN96Qzo5qyhumu+D7fMJTpdFhMXf11Mc3TaJHI9pksul5uihMVrzwy2
         3DBO++LL4U07lyxxkdt1UbvIVn0TDjbSDkD8y4zadqB27Vxk6vxRjW3Xg7sOKZwy6fVI
         cpeQ==
X-Gm-Message-State: AFuF++kt8Zn//vmhy2ZfQptZSgNNzYRjAkwhcDADY4KQgWbnT6AtOV6M
	vSzqUtL5jMDPbzbkXAXC7J+v4XR2mFpxUhOWFLIHi39UDckhfbolqIG6nukjPXeC6D4=
X-Gm-Gg: AR+sD12/Aj+BGY8Xa21eeOg1q+tGdf0gMRZFyDymbOp434Yh0eNvMt879+ZSb6pBDBc
	meV7ENcA5+TOnDEIAucxHy5HLBWjnh/WpM92JmWjisXWyFGw/xwhj6+mCxeSNRQuId2u+ka4wkB
	bz+edd24xDmdYw4LgDzTrUSw3TCaMZYXw0Kcr10uaOjO2jtEBvqgXCHXsYQDTaot9bLL/nxgqkr
	iEam2JBB6TNYL9muDyeTxqmNWoRNh8/bEN/hleanMtgsNK+suX3oyshp4SKV4ikf4Ee9jWLFA37
	VMdSZmqaFA8TvXPr+8Go9/NWeiLOojFKqeT1cTPbFIRv/LqFb2U7y6XP1YR2YmV77PaAP4XMand
	PGqIHiam3ahkk7AhukjWV6hrNQUDAnnl0HZKNV5tP5quLBSdyucka2j7bEBh4Pf+gea10mg7Ca9
	lbmSbtY8eOOTzRmpuGukh5/Tkal/8PTQifI6gOS9lZvcDoksiwsP0cAWy5pfaXSxquR4wEUA==
X-Received: by 2002:a4a:e90c:0:b0:6a1:47c8:c86 with SMTP id 006d021491bc7-6b1c667ccffmr35159073eaf.10.1788281074439;
        Tue, 01 Sep 2026 09:44:34 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-46f30cb5a17sm187699fac.8.2026.09.01.09.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 09:44:33 -0700 (PDT)
Message-ID: <917c59b8-d3a4-44f4-acb8-7d527f36dbc2@linuxfoundation.org>
Date: Tue, 1 Sep 2026 10:44:28 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 00/76] 7.1.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.13 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
