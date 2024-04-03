Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5F9156890
	for <patches@lists.linux.dev>; Wed,  3 Apr 2024 23:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712185264; cv=none; b=cc/PimbvKky8+WKs7ijkWpasm2o8xaR2HR6jqypvT3MICuPVNbQRC1/zsNu07rwDlL0lC0QnitlS3FFZGmSJVBlbDaxqpzHjfnc4P8mee2jX1CPyCC6+eF4tlHpIgOrdgwYyLYkORw/RRlXvR/a0wSLLm1f2QG5pbwa/OU0Z2AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712185264; c=relaxed/simple;
	bh=7Y74O7TjY7jpHYofExHM93h8IkZ4W5efuR621D08PM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UPSlbRXfUiaQw/d7QezCUlzhB0thCk7Z3eCDacXu4qMXbE1dXLDb9xOLzUk7F/hADybPlCpp1uNpFJdMR5/XIj8a6OoFyqiMhZ8fcCAreXPkfMfOBCVDgKpbbPx6l9765Tk/RUgVgEUb9xzOhuPjazQpIQFRAin++4yleCEy/3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OoSIW7F6; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OoSIW7F6"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-369e4a6ae04so15365ab.1
        for <patches@lists.linux.dev>; Wed, 03 Apr 2024 16:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712185262; x=1712790062; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lVfdwPhoWoL0b+VXF/L262JhPi7ESknq7Q/FQyN+ugM=;
        b=OoSIW7F6miqoks+KX+yHlc8pKKbf1S06NCbDcP82OgCE5Xaw3HaStgcs2lIodzmHug
         8Zqih3Cjp3eg6MTzrIFmL6A4DvOo7pcPp092X+eXHJPp+SWwDmkoXIjNW0ZdvXoycRJn
         49JyYlKqrp2KStOZDb7jlF+lIZpUB1K40EktM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712185262; x=1712790062;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lVfdwPhoWoL0b+VXF/L262JhPi7ESknq7Q/FQyN+ugM=;
        b=mW0RNXVAKmCjiTB7lYo9a3yJ9W43crgRJbeuNi47Nv9fH0o7tqI+gu2HW9OBM/KwKE
         dsykkcD9Req0WhyBLH4SVVVJpLyFf4I04BVk+m+fEotG6IM0uH9GM2P4Arjn60iDgFCR
         3A9LjM+2+qg9k9ehYvvLc40V3yHZanUnsRuJJPaZTqC3tGps3jpisIT0/65qgtpiKVW9
         JLHY6wf3Sp47yy4Yk42/qCTuEjVyIT37pUUp4RktsI6DNs0K/NB4MwBZXso05zgglWj0
         kFpaRoCnAsJaoYnx+k41B5VO3ehj4E4tlHGgdmOvnv0um3nJF1iwWQ9yKlc3cPehlJxj
         KVqw==
X-Gm-Message-State: AOJu0Yxq5f+d0+vad1zHN3ZZt5JD7fXtGTApxfGXIeMGS3YAropLS3MT
	jnbuUxRHX6yAPc+mGLhA0Ut0H2tnawNO17+7SUVp+DgeaAHXmgPlFpy2Z3AW+iE=
X-Google-Smtp-Source: AGHT+IH6cRHPVj5NEezsGxb7L0Ozrt8vyJr/LPTdVNmL+k/OgV6BiBlvHPc093dRKgMOhDOhj+Ru8A==
X-Received: by 2002:a05:6e02:541:b0:368:efa4:be12 with SMTP id i1-20020a056e02054100b00368efa4be12mr1139587ils.3.1712185261996;
        Wed, 03 Apr 2024 16:01:01 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id n16-20020a02cc10000000b00476e7f39a44sm4092962jap.110.2024.04.03.16.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Apr 2024 16:01:01 -0700 (PDT)
Message-ID: <8cbf96eb-b1de-436e-8312-c228d0882226@linuxfoundation.org>
Date: Wed, 3 Apr 2024 17:01:00 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/11] 6.6.25-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240403175126.839589571@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240403175126.839589571@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/24 11:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.25 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Apr 2024 17:51:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.25-rc1.gz
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
