Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E99321CC5C
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 00:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786149303; cv=none; b=AxJM91JiJUtBi0rGKxsRPVOqd8q37n22LHkxtYqRdingfHFH9nNc9O4CbTPgWX7XGxeyvj5Y+oH+uA7D89DC0jtS5VV3766ladcw4Kq3cftfpZECZifx1o3YqPhx31BRr+aK+Y19zRqP3LbLet4STYG5t1S4ZSfSELZzTNwP/1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786149303; c=relaxed/simple;
	bh=qPWYVDfGidSWObMm2aZe8inJYQg4VBphlJz6TEyKM3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PuvxTfDFl+ksa0F1YZI4EFJjFL7BdS7hOigZ5fUWiRtAY8Zclj6m20YV+OyOcla6M7hvu2AQObwVKFJE9zsRE8JdIKs+FqTu3z8HwtPPfXyKKkZ8qbPFc60BkHMIDVV8F8hH8e41VVcXGTYCA0ZWx9zDh9lN8VCylEYOWizRkAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJIjbVEb; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJIjbVEb"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e6128bd9b3so87143a34.1
        for <patches@lists.linux.dev>; Fri, 07 Aug 2026 17:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1786149300; x=1786754100; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NrtwQ4j+g8aN1LkT20rOlsm19+tjXqZu2a5a73OuJPw=;
        b=TJIjbVEbyiJGifTE4N9afkBQ1d1ENgptHy8w8l6q6XITB0KHo15MFzcfcZe3sx3CXL
         igfHXngdeBWYld/VT1f//PkmYm2CfPEUHh0zvPt2Oa5G8Prd4jF59E7VtY04gu/+J/PF
         mEeyXuNY+buGrXefGMSrc6E2qOhH/oDN/BIW4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786149300; x=1786754100;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NrtwQ4j+g8aN1LkT20rOlsm19+tjXqZu2a5a73OuJPw=;
        b=piC4v3dWOtMeIDSb4ZLaqOGf/lH9nQbcg64MgCICJPLLs4ji7vZ5vOCelEmlZQdTDr
         zPZYKk6UTn0zHAdg2vavqWgda9ooPOYp7pcLIHKZIcfQW/c+Dh91gXaEL50TGR2t54Z+
         zAh5dLnI6GAaEPtj1045mdHlgpJRbe+VEhI1Sx4nAyH8I1LHZ7H9bT1r0tplLl4ol6vB
         A5ZC7W3fHo91+xqd0eFi/8LG0yav9ysbALrDdUGcq6y495EckJfCZGGGlN/JA8b1/kii
         vS47sCwnQeYQCsY1BjHlAUT92AJFbs2Ap3MHrvwL4jhFK4ALL5y6+nDA8eht6a17EFy/
         xtnQ==
X-Gm-Message-State: AOJu0YwX9HIR6BiP9uNGqQqxGDOivOuT8MVSvQIkyvabZhDU2p4c9uda
	rY8Wcks2o9gpLognHqYsxvOnv+oa36otXnPZpwjoFkDTrHEt4wZ9pFyYkzVP8d4NA0g=
X-Gm-Gg: AR+sD11KH9DroUcJe+eGWSKATkm2NzYXrwlxKGPP9bdpfpaoymIvHdB3Icu2w5/oepz
	kxMMChXAf+Q0NwCklSSuCBn51EYtToBYLgxwU5auR+r9wQkxiLQE7Y8eU2SEd6s4HIyOXljEgnv
	28Uay+Rr4PMHLMtcqghmT86fo6OUNIEPPdY0DVfxJMPqhaxmC2xYXtRZ1qDmjSslAEnIzERhNc6
	vqsmUD6mc5NsJJSxICc5dpEEwvlYp0wBGrinbZ2nplYUytKjodjPNy4N4raOBFByZPJU2upRCgh
	CzYnTXf7jJLwvYVhQ7yLMZEJRpg0lO9ZH1CasLaKZfLM8DGQFge6jWv9TpAclqoxHEo7cpSoNm5
	TQPUKeLu/ODZCc4+R2mbuIZnF1HDj0nVknZmQBUaoebJwXaSBht28Kl+6ppMCNMFG2+Kbi5q4mr
	TlrX9URtlyvWB8JDYHH067ojWV9Qu9dzX03FuImhcPJ/uBqjQnLRm2kMSGgBH7oypkzxwOfA==
X-Received: by 2002:a05:6830:381a:b0:7e6:f582:955e with SMTP id 46e09a7af769-7f1e5e4c9edmr16473666a34.10.1786149300198;
        Fri, 07 Aug 2026 17:35:00 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f35b7b95dcsm2293101a34.19.2026.08.07.17.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 17:34:59 -0700 (PDT)
Message-ID: <f96179d4-a4f2-4340-9348-50e635d9b5d2@linuxfoundation.org>
Date: Fri, 7 Aug 2026 18:34:56 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/337] 6.12.103-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com, Ilya Maximets <i.maximets@ovn.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Sasha Levin <sashal@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/26 08:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.103 release.
> There are 337 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.103-rc1.gz
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
