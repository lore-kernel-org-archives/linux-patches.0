Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879E73B584F
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 17:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775757224; cv=none; b=mNrP5ZyrSKcy5gdAj1BOHWo6po0hg6xxJ/vjZDs9IIMPwBC9bN9JRxfcIKhh2ndYlHMqr3tk2ATGNiH/QepflctShzRS3W0G7sYmIeBe6c0DUi6HGG8cifWN5dB4gtpjicQXxYIGwPRlvdo7nG7q9ujFz5Iyi8AHl8ZEf2hjIeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775757224; c=relaxed/simple;
	bh=iRQ3w6+yntSV2TqQM7i0obZA2GM/zmIG8tpGbKGRP7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O0JlvoRTC7AdSohPAS8pxt2yudsMsdnd9PIdAsnzyWENEZdhh6Yfyns5YhMQ1c09yJaTY0r0raSlr3Adn/tBoFWEaYsGaGTtUvG1JaeENTbY9+ZoiiVPZfn5emuQ6GB03azyVxwJtAdSD9U0VVG2aLD+iuHtZXr+oyDtLhRGaXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQ8CFmgH; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQ8CFmgH"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7dbec19732eso1115308a34.3
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 10:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1775757221; x=1776362021; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CZ68RQRBggP0gvUnPIBwIISF/7PCd73n4JJR2iSytA0=;
        b=FQ8CFmgHFxKjSikQ/tfApsD1d0SKLZ0gl8UOwHKbqN9A+eT0v28pvuxqnx/4CvwTWo
         xJMo0dTCe9NF4gQ5ObIb+wVRD9a3UYUEp8MuRCioNvZeHl8LPb5c483NfHPy8EoQSoVU
         c55W3H1Za4e1WGUBfoNfCci/ggFn0HDvYP0Eg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775757221; x=1776362021;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CZ68RQRBggP0gvUnPIBwIISF/7PCd73n4JJR2iSytA0=;
        b=poykuRlFP+Ipj36k/FQmLY+xvtvufdmCAX5yiHOCTMilSw+pNLiSgmsKTSJ0Fi5Ah+
         /krdlLZz+y39vEInTCJ48X4Rvo3Y1h2tdMHUg8n94zBPLqmxZO4CeadV6FCVUFgzdgyL
         6VJBTcsSs/j24LWzOA7YTP1Ijp6ffi7Os28oTaIY9k/OgGZTTEV9qHDEVP1KxtoNck3k
         s2p2xG3HOdI5q+S52+aSRLuJqBpVRDmNgsZNOMdOKHWFRL3jjBofwcfyGCNU8NusCxCX
         D8hp1hKk054uZHUToqsQnwqseeiBn1iWx6Znu+GU+IEV0MM4Cc3r5XqUZzb0EooHITZK
         2xCw==
X-Gm-Message-State: AOJu0Yx5jirC4zXGdlgaByL3nmD7/6vIjlqFySG0fJro3SvKI07kL5TY
	OXdw3uq8TI2yyiAAK7Du+j4/bvEH2Gt/NLYkkDSeKUkFD46C+MfA+6M+ov8rN8NmIfk=
X-Gm-Gg: AeBDiet0JoU6aZMMCpVYekYqlWUr9zcrhYKO/9qNpzaJc0tenXTk184+FerQ95k1ib+
	U0u00V0uNhk+85tFfeO52XroZ5khkg3qj0m3qh/jYZWMZ3Al7e2ks7gWKCamI1XTmfQru6filoy
	/fIAvck/R7IN+qBauZfAvruHhPPCDIHzjQUO7+6ho7jTEnALWmG7bWVsJ8dR9KkFbcTNiGxaioF
	0Y/Kv+/BYo/Pg+ejQl3C4otjp8mHiK/AZLlgPBJU/Jq8Rj3F8hLcFcgv98wYdo2G1Y8fsHfssso
	gE9LaOyImSwJoGvmPEpVb2CzToZugskZwWUIQ3UU/npLWx8WeB1wM12oSKTeVgJJ3QlyVWl/7wP
	5UWurXQNM6SVPr4Xyv+IxttrbtndnfHktKJe6anmDAQimyzwZz28rZg53ObACz/b5Vam9z+i4Dl
	Bdh+lxPSJUTn+lGb9fkZdlUmbd/PXu3L9CS8w=
X-Received: by 2002:a05:6820:62a:b0:67c:2857:e0e9 with SMTP id 006d021491bc7-68be84d4703mr11181eaf.44.1775757221523;
        Thu, 09 Apr 2026 10:53:41 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-423ddb20c0fsm231439fac.11.2026.04.09.10.53.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 10:53:41 -0700 (PDT)
Message-ID: <83368604-7b18-4687-95d6-0359d72d2848@linuxfoundation.org>
Date: Thu, 9 Apr 2026 11:53:39 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/242] 6.12.81-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/26 12:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.81 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.81-rc1.gz
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
