Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C65D2C872
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 15:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4Y0kSBY"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-357bc05f94dso3898795ab.1
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 07:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1699371323; x=1699976123; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u0Q97ZjZqObFPBaDoJRqfB46zlWgq8JESlNpJLuVSWY=;
        b=E4Y0kSBYOuWSVXIvJFUJdsjjc+ZLCSduHhW2h0KmvjeQjYsqkQrAxP1egW+GS4VtAU
         9F5WxvLOb5i52ZtjNA+VDY5hShtiOLceFp9R+85Hle3V7pxJuoY6R6HReu4gZrEbPFwu
         MYIJpMOSbJ5f5G6JSji2mCFMOHuArZB7EB5E4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699371323; x=1699976123;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u0Q97ZjZqObFPBaDoJRqfB46zlWgq8JESlNpJLuVSWY=;
        b=dOvi/KWVzJ/1RKJXeOu39fjVhBpci2HDfYDM1e7kNYIfsEDXii+vE92e9zoWT4B/r1
         FsuXyFSmWmtFQxygP0JLYXncIfHa3Kt8vxsKrsrfQnTXhlZaBJbUFEdsoZ/+GTmURSjk
         rR9nfDd8f550Xvh5rUv+lxxjqz9P8PJBrvEJUEwReXBnAxomC2WDkElGEd7hd13cRG45
         us8+gn0DLGu+aG1lrk9BHPwDWRVZ1wJ0q5l4QOa+G8MWna/nk4ys9w6GkVu8y93uAre/
         Y3c3MmRXXPhN7zyFBFx8otl7nfIElW704WRIDBLOdEBWwqyKM/G3fJzzh3AF1oCSTkg2
         UVig==
X-Gm-Message-State: AOJu0YykeyjSXBLTHTmFhHiBDvEMlpEvcPHRdfFW7RqRD4n+RNWAFqb9
	enbdFHYbjN8UthVrQl54vIS5pg==
X-Google-Smtp-Source: AGHT+IGu0+OjpZ9c5GFN+YtEXHATCgKN5f1JuHTU2tvvV8AFosus9NykJaZw8geqLpsU/G11l9HIEg==
X-Received: by 2002:a05:6e02:168c:b0:359:4db7:102a with SMTP id f12-20020a056e02168c00b003594db7102amr24982430ila.0.1699371323093;
        Tue, 07 Nov 2023 07:35:23 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id y12-20020a92090c000000b00357f3790ab3sm3160589ilg.25.2023.11.07.07.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 07:35:22 -0800 (PST)
Message-ID: <df4b4f69-5fb0-4247-9eef-057efcd33f10@linuxfoundation.org>
Date: Tue, 7 Nov 2023 08:35:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/62] 6.1.62-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/23 06:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.62 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.62-rc1.gz
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
