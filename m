Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6929B1E4BF
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 16:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709138394; cv=none; b=m5XUMdnv223IpBm8EVTvBWvcbS08Kph8jsv/X4m9PzHy6bnkEiqhWwA9FOrhzUktzmLh+Sa/40Dsp5GOmig4EVBAaSuTKbOwAKe1L5p4d7mi6WNmeTYQB4di/jQ17Qri+kFnrYbQlJZ+JZEmLElHcFcJLu/z3+muilNZ9xa27oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709138394; c=relaxed/simple;
	bh=PZDf6Z6qf0DHOIC6Adf/nEul4voHVYJq7s+h7EnxYbc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LMwdSZPeZxARKCPF3Q27K7hQZkr/ZeWkLyUMF35p00VkyxSy1KxpvkO9S2O6WABEjlFWU0CBuhAPbEgRsgkSq8L06L51g3758bqJJXIb5ySKMmpon0jhdtm4e2Ty45/alb+Uv7ffsQeCevg9RWXDMS6ILRcWOSdsZUUO+E5KDfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUBUCEiO; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUBUCEiO"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7c49c979b5dso113926339f.1
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 08:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1709138391; x=1709743191; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3YwFcibZYyn4TURE65NeFWD6oR0EJNbwhkMgk/B8ptM=;
        b=CUBUCEiOuU9zoIlCZKNef/nfM1l/c856R7QC90BIDk4We+lLXYk81aqmz8DsdNZoAh
         FoijfscCggHmAPwWp6QANtNJwIv5bJmrqXEcWUJ3+6v2JvhJAflGzT5m4+XHLLYT6u5G
         mgSG+1HjkhndH8kMxUV9NJTPg616jBREIj68Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709138391; x=1709743191;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3YwFcibZYyn4TURE65NeFWD6oR0EJNbwhkMgk/B8ptM=;
        b=H8OxBcoUnuBQwqRyv2cVi6id0JbMqIwuwFtbYxjOzYDglb0c521XcMQpAbqHSsn75p
         l9jIuvUDDeO/KSX2ziuQQ4WwxdtDt8dML5JkoycdIay4JRei/cdfDWXI04/BjB7seDbS
         nGlQv85nGCENQUe+LSDst4vhCydL+BBiGHviO0eV9u6EUmpSmn0QGETXc67igrzwSfPz
         ym0dS7R+MypEP/8qh8QYu6nSJ8sy8Rgft6X2ALKqgWzaxvjo0wc2GSzC6b7wxwApDxNm
         5fl8GTh2hwCE+9I8gb3JyAVvB7Nzz+2BbNrFHcs4vvKZ4cpsXGEyNbZ3YeF3nVbiGKzc
         9xBw==
X-Gm-Message-State: AOJu0YxUsMXnrJN0JPQrkGYjfALr1M2HrZAwqcZuqAifRxlZLHlRMGn9
	lo+Ta4YG+L6puBJHBvMajAtxK75gJtuyigN6mkXdnlWwEsT5j7q8JrNPm10OxBU=
X-Google-Smtp-Source: AGHT+IHiLzT9E2N49Fi6K/4Pl1Twu2MlJpcKH7yo5vXyNT87r4Mo0hghCzsyOdKBkevlIl9igVRSDw==
X-Received: by 2002:a05:6e02:1c43:b0:365:25a2:1896 with SMTP id d3-20020a056e021c4300b0036525a21896mr13469149ilg.0.1709138391488;
        Wed, 28 Feb 2024 08:39:51 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id bs17-20020a056e02241100b003642400c96bsm2891272ilb.63.2024.02.28.08.39.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 08:39:51 -0800 (PST)
Message-ID: <ef1161a2-8c85-40d7-b8de-8d668f9d8625@linuxfoundation.org>
Date: Wed, 28 Feb 2024 09:39:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/299] 6.6.19-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.19 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

