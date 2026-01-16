Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D26C34DB5C
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 19:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768591712; cv=none; b=EsyNEu8Ew4bYi1Z6xIrbP3fhg9RpQs+/VGI7EBuceZ/3DXynALk9vWmA45LpKY8P2F05q4jYXvxWsc7tu0SPW65kChG3vdGpRZvv9DeNu2nf8eWO6+zYXfvlxgFqI5wAjfkVNp2ZuHPYL9F8K8b+F4pG1ccyn4Bbv0hiwzbJqiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768591712; c=relaxed/simple;
	bh=02EfObqEwDi8fljYxxb5V0jKbMzSmLMJrn6FfRXL984=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W9wlAAz6xZBDYyxnoNM0tl+vP7rRfKneZSO6t2HJez48+nIeKCRgOTo1ir5kkHPwj6z6Hm1BNuhLoo7vbobl6f9coDJbqQEnucaFOWM8RA4VTjqgEY6vKP3K/CRH45ehCYojsRt5pOxPYzuuRWlor3fiayh/WxNCYpLOLxe226I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPUUJLSw; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPUUJLSw"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-45c86087949so902735b6e.2
        for <patches@lists.linux.dev>; Fri, 16 Jan 2026 11:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1768591708; x=1769196508; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gdkD30yEkr+VNwdq98p4fkHFAO63J+ygD3HFB/agENA=;
        b=EPUUJLSwtHZ8jUJYNWBkTyrOlmAgeukLnC1cgYJ5BqIZAXDGkeaG4/aRouS8jeD6l0
         XTaBxzUa6WLhapfnGwH0VUKWB3hEHgOwC+Zgs2VFH54q27iY/8jNTsclifGk9vUyA1U1
         NcaZ8YsQ+rDs2EpzUjGL16kFyzKINijT4F+Nc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768591708; x=1769196508;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gdkD30yEkr+VNwdq98p4fkHFAO63J+ygD3HFB/agENA=;
        b=rildYW7Z46AKuZJdbD29BAtIUgYgIF5o9xJ0RFciADcregdaDaBbUDWGgBYhUfWCTC
         cjAOGhO/nEuh+E0KUx8z0K11zsQkdAMkH4ztT68yLXxgwTa3BQuaWIyuG45O654PoL0P
         VXrIqxH5NiF+4VErhPB+uv0TlZqBVoM8NRhcdHy7/Tlm5sAW2PwCHaCJYYehoX8sguWi
         gOzNR4KUKNsfeDq+Jx5xiRtSzqoxipCaxlxHE5GqhyB6QLebI1vT49AEs9KnXjSFBHir
         9dHIQI/IrWS8JcDe618RQ64niJw3oLPzdegTBaYnRylMl7YuTseJVNcVbg5I8IwjoBoD
         3Yuw==
X-Gm-Message-State: AOJu0YyZBRgTXbiSN14/0o5bxYImqj09Gs6V/PQTR7S5Kz70tg7qlVbB
	qyAm0UNCG22nDfBwVGK3e4wa7v71uKxyl3RSUIuAXass1mHVc0o4R+jgEGbfLmbx0Dc=
X-Gm-Gg: AY/fxX6yiz2EUe5RK07U2oIeA47hcN4yguzSAgT/o7XUtB8DD7sr3Y4V9JPHY56KnAO
	m6cviyNJLPj9b6CxMDL4zX96LhN+vywUVZeNIE06cVrVCC2F6PRg/TNfqlVVwYbkKEbSpDfjGnc
	Yot8rFtehIsgkewR6D+ZQSWpKThT4ZcNlOKYj9tNxpq2X1kvbL+KI6spABd5TQruneZAs2TqfWw
	B8QAJUmVUqM6gFPukCR53xAvsZkn8wgNIfXspWtB/Eco2iO9FcQb5QpluJIbfzoQ7MpXQtWv1tN
	FpO0qEpiKfGZoB9lWD9u971za6vXVa2ofBjxd2ZLU+BcTvxoLaQj9RbMTjONhnoNmtgpn4VjTyE
	EpK+756mh0NsuqtRHNg4kzRlANR+Qj41ltvAYKIcgWS3Ll1nwmV0ApiOs+IDIYB2aU1Bpq+y9Is
	+i7RuBxr6rwJ5Qrm1zzuon7i8=
X-Received: by 2002:a05:6808:1506:b0:45c:71ff:1f5e with SMTP id 5614622812f47-45c9d734c5amr1786382b6e.21.1768591708367;
        Fri, 16 Jan 2026 11:28:28 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9dec3567sm1664286b6e.1.2026.01.16.11.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 11:28:27 -0800 (PST)
Message-ID: <114e9805-c353-4592-96a6-e3b523796960@linuxfoundation.org>
Date: Fri, 16 Jan 2026 12:28:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/72] 6.1.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 09:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.161 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.161-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
