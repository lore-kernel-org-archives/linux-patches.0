Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E717428E6
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 22:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eE5COKo1"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7a24c86aae3so64876739f.0
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 15:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1696891677; x=1697496477; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9dmV0s2gvhYKd9sKafgfFhwZfZh7sBcpDjTFnUkjgaA=;
        b=eE5COKo1UNXvIPTfVR8L+ex3ea6Dy/jFdp48qFp7qtjOawQml9HJGCrOg9ZwRPUZny
         IoUJj5Y28pOX/cgBQIdGmRauEM+/0G63l7HQ9j1fRUK7ORbiZ+vl+L0z7L/WTETuzLMh
         /3mgKgyOsDX7/i1I8bLQz3VORz+flPMh8KLxw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696891677; x=1697496477;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9dmV0s2gvhYKd9sKafgfFhwZfZh7sBcpDjTFnUkjgaA=;
        b=fpphQD0w3vXZYy/0N9Yzz7dPBPtUMqvaek0K8W9/2HG2aLLaP/pjLVMUVxe+3vbbfE
         N1cSG10yteBT6n/9lJLHwphc5rLwJDiYhJRgPYEvU3jzvbhv29MbFBqfGjJQOURrG+6P
         T/bRJ2MNbDicetlnj2Ptc6qae7GlWjcByM/qO3HxQzpmcXRbFAt0b1xWulqGlUiygZ67
         SY+ALqk/M59fwhiWAeHGzD3V8xo9Dvr5QZazum8ABiuanGMMtdA6NHGFmy4STJDLZ0YW
         ZYFjS86x5L55zofypWloAV2nV5C8fstchlHeDGUUtdGqeqa2pE0WXPLhvNHVGPUPg1zt
         oUWQ==
X-Gm-Message-State: AOJu0YzR5PCKtAMyh6go2OI/Y/Z3ilREVMaj8JXc8jRAzGZOjiHv4kcO
	e3HIU6L/vi7Y77GFIYfJHucSKw==
X-Google-Smtp-Source: AGHT+IGTiYBjiNf9gT4dg3w+9cYpLpg4VurB4YXRIhvnxRU5szianBv5FtByTdxps8PoBzoUju/Qvw==
X-Received: by 2002:a05:6602:3a11:b0:79f:922b:3809 with SMTP id by17-20020a0566023a1100b0079f922b3809mr17703193iob.1.1696891677005;
        Mon, 09 Oct 2023 15:47:57 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q6-20020a02a306000000b004290985a1efsm2344564jai.43.2023.10.09.15.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 15:47:56 -0700 (PDT)
Message-ID: <4275348c-13d8-47a5-b661-12cbeadc30d4@linuxfoundation.org>
Date: Mon, 9 Oct 2023 16:47:55 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 000/163] 6.5.7-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/23 06:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.7 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
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
