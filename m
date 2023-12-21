Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5028153A03
	for <patches@lists.linux.dev>; Thu, 21 Dec 2023 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIazkKsG"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7b7117ca63eso11173839f.1
        for <patches@lists.linux.dev>; Thu, 21 Dec 2023 07:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1703173811; x=1703778611; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NkVEjRBzIQTEE4egLQy5RyshAsIpIupPiuBcwMoryU8=;
        b=WIazkKsGSdZKNnloXIO2X2FmEKmlcIQnEljek4Wr5q/dT9IcZDHnx9iP6GApvvBOGM
         vuJETLyRg1sJzBBRRv4YkluyZNOiJxBOJLi4qk+QFjLZhVdhaRDjguIEkwVK8GU6vObf
         NdggvpafwkllngehZ2yOc1Ep/Cws9cyjxGWU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703173811; x=1703778611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NkVEjRBzIQTEE4egLQy5RyshAsIpIupPiuBcwMoryU8=;
        b=Oj4x6uuII2jp8D5gz1pJ51TR1su8zFmkIic0Wvd1AZEx5k0WRB4UFtfNwI/9MFPWlK
         Dlu/Grk8JtR0na9KN1ccOkZ/o4BvFvc3l9YxNV7b6pOsfNPPhpwZHrg0NON9EN2FSoLS
         yJUqQnG+hI0Te5IztDzTpSvddt6DExv+uuZ2n2l4Ra9WdmMJiidkmHyiHCvKiT/rsIIL
         zYzGHWODLU7bdyIAXflRuBpoppnghOzKiuFMphTqzm1WqjaHL82OYu1mutMOtZBITnTp
         1Ewm1tzgbqnpdbitoFI9LOyI4ppgREDX8ChmgiNoq0kjbGdV+P6WUY1wE4OjU1hZdudt
         +dbQ==
X-Gm-Message-State: AOJu0YxG1mjaE6ZomIGa8XrUc5yZiomAz/mdYFOnCTrnwmBbW3gS3dJj
	UwbSNf2c4r5+lYB4R/xBzDdLzQ==
X-Google-Smtp-Source: AGHT+IFVNi9BbVx1KB3mgTWEm8/3cTNGstNT+75OJZKC4iACYQXE+kxs92l37WjcMq/56d6xaePE2w==
X-Received: by 2002:a5e:c80a:0:b0:7ba:72d9:394e with SMTP id y10-20020a5ec80a000000b007ba72d9394emr5696085iol.0.1703173811464;
        Thu, 21 Dec 2023 07:50:11 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id z26-20020a6be21a000000b007b3e44dc200sm553890ioc.42.2023.12.21.07.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Dec 2023 07:50:11 -0800 (PST)
Message-ID: <79edf3da-d8f6-4e26-8fc7-cde71fc7c82c@linuxfoundation.org>
Date: Thu, 21 Dec 2023 08:50:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/62] 5.10.205-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231218135046.178317233@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/18/23 06:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.205 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.205-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Still doesn't boot on my test system. I am getting closer to finding
the problem. The combination of ZSTD config options and compressed
amdgpu firmware seems to be the trigger. I did find null pointer
deferenece in amdgpu_gfx_rlc_setup_cp_table() related to compressed
mce2_fw when renoir_mec2.bin load fails.

This fix will be in mainline - I still have to find why I don't see
the null reference problem on mainline and all other stables. It could
be that it is taking a different path to get to this point on 5.10
when renoir_mec2.bin is compressed.

I will keep you updated.

thanks,
-- Shuah
