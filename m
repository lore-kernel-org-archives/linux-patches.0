Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3FB33CA
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 16:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741711543; cv=none; b=dQAb7ZEWajiugUEPNSRHI0sylOy1LM+B9AosxIGT2qZNBZydcUz1w399v2hE2VkFgRxvnjYCBJvClXqSZ7HVHtnmHStfILZTpuEUPtLi1JHfBwzsTCCjmj+gmQlXuS3YfSMFTs2iFZK/UDc8cQfhDA2IZBj0Up3Lhw5aZCnczMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741711543; c=relaxed/simple;
	bh=dMfpeTf/NllZv9N3DyfOl2z5YpwpaZ2Szk9XzslUpQc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=poMnqET3pgGUuHYH3iC3PSMC63NZH28YRqTfc8es28/fTj2MbZtiSsMs1HlGQfudQgnzWqj8UldU+tI7hlOrc/UN7gijI9lKfVUPprYUqdvT7iQeH0rYlOPfJKX5BerSe00soqVRZIU6K+TWyQzEbqldsQaczH7k4F/sXqWYCPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c236iSbO; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c236iSbO"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d4436ba324so34042475ab.2
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 09:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1741711541; x=1742316341; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vLx2WoIhJiBG3bqAkGfbCh91LVddIJWiQd12L4pfcIA=;
        b=c236iSbOIuMkwwAjUn/L4q217L33UDccspPW9CW5x+fTqeRcGwX/miIhPMudOwt85r
         kXxzeYk/nIAlo138sxo/wiR1A/J0omjjl/jxDuPwdexwqwzlr3Gs39lNkC1qwjbiyOgf
         lL4cKb3NCwtYz9Q3Ohly2yFPhvwKOOay2CM3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741711541; x=1742316341;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vLx2WoIhJiBG3bqAkGfbCh91LVddIJWiQd12L4pfcIA=;
        b=RPxL1TU4cn+YxQLR0rrOOk3FG99Aji93wDaJ49UMQxzih0nPZbmHP8AIs4/joyq8Ju
         Pjrn8eUCO/n+451lBHycIxoLBiJS1jKrlg76tQg+bzjYJI/wuWuPg1Uh4IfBY6SIp+Fs
         BxVZiADabnfR155DsFQJiVwkeyek66viTbOCK11B4Uxoiv7t+1BR40leKKNMpIZPVvXF
         CrrW9d71euTftRIf9SgZCCehpH6pP6eRBswvEmZhLCAb0nfI+KadAJgGo1EZMpl68RjP
         W7DH0t/tqgvajzg7wt3oenUu9yJsAaULBt2iBKkhl79g0zG/mAa2ViXIMC+EMQ55ZZZC
         FOYQ==
X-Gm-Message-State: AOJu0YxCO7BY/2G4f5Plb8LHx9kztYcBA1fnnxE1qGLECMzPYckhYpaF
	L/My66L9ikqPAokax+rzY+/M87bqv0QiTu8DrFe4DsfQMO8YXi8+wCEfG+sHIMk=
X-Gm-Gg: ASbGnctS2j2SSqmh5IO5RxBiYd19Uumu4vMh6bcRHxgNKQttPjHW2aDcs3xCenR1FH6
	ArYQ3M1rEbb2lyK+PZXs6xRkFJ0IPdDumXUuTKw1T3jpH0UkKsQjOYxRPEQqcAg3s28v/flZRdr
	baB/FF8H+Z+1XCeph+rq0Kn1LibzQANwy5L1qjopI05D+IIrUSFGDbmZDBN29mbOl/N4QHBnz4z
	+OaHVqbg2eoXsDMKipOu3LxlNELs9bW/A0WaDzo4XdDnf12NCDNZRo2ROlizz8qGKese7uOwe9W
	z9EOpCrURYfL4zW6e9OiC6z0Qsuns91UN0s4O+YZdQjaTGf1yRgEKVU=
X-Google-Smtp-Source: AGHT+IFNRcfQzm6xuksYf/8LPcPtWo+WVv5uKFa9PKonyffFvWpr2Pt03YoFcJoQfra+HQB8yRxDJQ==
X-Received: by 2002:a92:cdaf:0:b0:3d4:341a:441d with SMTP id e9e14a558f8ab-3d4418d0cdfmr201635105ab.10.1741711541121;
        Tue, 11 Mar 2025 09:45:41 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f22fa56259sm1456209173.2.2025.03.11.09.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 09:45:40 -0700 (PDT)
Message-ID: <e1be13e3-dd14-4e11-8fd5-6d1e2316aa34@linuxfoundation.org>
Date: Tue, 11 Mar 2025 10:45:39 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/269] 6.12.19-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/25 11:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.19 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.19-rc1.gz
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
