Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E41F48165C
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 16:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281163; cv=none; b=KhhWDD3kyrPLqHhzF6MkJKWde9pt1PZcyL/YVw0HNdNhu29YsVLYXAiPXJXoW/3yTZhy4/dN4a0nOjonOP3Qly5G5Duwo76+xaRpVOwyPmjcMMg7VbD8Tq6XxqPh1RVzjSX+MH7RTEUmo4AAa9jg5osRq2iN4w9rNOXtaBsEN0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281163; c=relaxed/simple;
	bh=UYUPD7JgwryIKNVtCnoJgUs9pzPFe048Yg5ClrK2qRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aH2fwclfTeH0NDrfVuYQ5r2fTvToyY1iFGPY2AP8e2qKjsjrWj0HR99UC2sVgLpnjAvZPDB9noTQEgK83hz8hhjvO4JcMdRg2ZuGKxPFM8IgR203nFavUMq/U2j9BPPPmnSCCYK1qb5Bnz+11T8tS/NlVQDz9ygdTg01tcTOaGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNc32RjR; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNc32RjR"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-446f87b6de1so62575fac.3
        for <patches@lists.linux.dev>; Tue, 01 Sep 2026 09:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1788281160; x=1788885960; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/hHZXaeBv2IvcIvud5R7QHHLCYnONKsJzwC8o/GJ/kk=;
        b=eNc32RjRwHjlQCEbgo5kEMLXKtqWXPodhl1rqQrtDpaJvTCmzxBpuVJ+3NCts0raaG
         LW+/6QWhyaEvFrR7yuokEO0+d0v5cn0PKBN/wP4MRPGYFwIUYndNkLxaGVRkuI6QXyoH
         Jex5/8UZ+03VIh/p44hcGheKqxYYLwXcnsZ5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281160; x=1788885960;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/hHZXaeBv2IvcIvud5R7QHHLCYnONKsJzwC8o/GJ/kk=;
        b=nVPTBlstZYlDNBYKyMp82uNMRuHvlA7pm9CU4Kw2I6RZJMempaFY/nGjsh9L253dUd
         3jrQUn/iPlDORY2d3/cYskKvWi0+G5YcA7MuqIyjwDRn5B5mWFbuYh5zWN+9sn7JibnH
         lpaHL5W7qWrgkTy+MHG1cwtaoGwkIjvRpCss8u8plsRIUmKhCGxQAWyTSeoL70uvsWwt
         IMuh65SZGw6TW+QuF6pqO4QHs+qyOdq8lFzw2x9SWlbZSQ+hnP8PGZgMpc3TdKvb2spm
         8o0c1F0hgwSrlkm6VE4OcY+uPpHm1leBT904g2tW/5tZ1tP+jNRjYbVdkEPh/vKSt/Aj
         8L1g==
X-Gm-Message-State: AFuF++k/K6myJp/ChCbPJ/zA0zoNzQFFtbvpjna8PDYjhVp6lJJLubDQ
	/ltvz3knWpwxksU6RXK97BST3g1oHkS6N7KIc9zpR7nxiN2KHL7uZO1wuMN9KW688i0=
X-Gm-Gg: AR+sD10mK+xM0MOpXbMhWdsTbl1VtN2hWmH0mjcFLJA+O4FZmrxJKuZjNIaEJIw4+3S
	SxYpUl09dlceLssNxOdkkbNDj3fT3/fpIhewt/zA1cMpDu9UyvJSoZUylJxQoEyzH4KJz+hiPl/
	7+rKbXKbCnh/UonzTH/w5SGnmkXt0We6+rb2Ajq2rueKJpKAhV7BfjwiMAU46i8LrnVNWeAu4Iz
	PaVQBOyr/iXwagPCDJYUWktRtXW3W2c4zPnxVQCBhG41OwU8GI1Ir7ExYPceiOBsjgFpWntpvNA
	rNWAmGV8tWumbanXDao2jr6/H9x1h86uzOA+BXjq0ZrDj2DCLGJ+inZyeR+fIRn7GrQ9e8iHTjt
	F8OyKcCKE5IwAVoOFvmRwYyHOdUvFVdaNWWayHOx4cLwTVGzSZSA/a4GlD9NUAbX2uxzwpaOQrr
	oDn5JsZ0aMoalxHSAl6bYf+XDcFTodzkW+bhpPgbkt6goDrvfcicNTbAcVo1tNokQohkXV
X-Received: by 2002:a05:6871:cc1b:10b0:466:ad49:d0f6 with SMTP id 586e51a60fabf-46af542e37emr6739032fac.7.1788281159759;
        Tue, 01 Sep 2026 09:45:59 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-46f336c72f2sm124082fac.18.2026.09.01.09.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 09:45:59 -0700 (PDT)
Message-ID: <08331aff-3195-47e0-bb56-dd4a5fde074b@linuxfoundation.org>
Date: Tue, 1 Sep 2026 10:45:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/99] 6.12.108-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.108 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.108-rc1.gz
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
