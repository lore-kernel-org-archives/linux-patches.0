Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC57F7765B
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 16:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAZNE0Tx"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7b70c2422a8so38748939f.0
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 08:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1702397619; x=1703002419; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i7alySON03WYfD6qf3ZfyB9eSAEEy5WG2do07xkvBxk=;
        b=SAZNE0TxFy57upI24uEvJkXMpm47EYQuiMr/BMknUjQjurbsIaydz6wLQdMGkRL6Qc
         XwWcJDi6q4IHD87EXxVUfq5SMHto/OReOeCIfnHD8jqhl+CsuHK/Oq0L1JDD3+4y5P57
         c2S5xG2JOCxbXpmAtLO8LicK/hHASGzGhQb0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702397619; x=1703002419;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i7alySON03WYfD6qf3ZfyB9eSAEEy5WG2do07xkvBxk=;
        b=kzxbe9W/h6a+ivpfD52cmHZ+jWSTbnVDziVd0UcktheeA4h97ohbsKzhVv4EGA/T2m
         jQvMscluudtnjrSXo8ZDL/QnXYZtwcifa5h8X/ZrNaU+Afrpi/HmfLYEQc+q4QzK1o8g
         IPDBYsYs5M4DRcQ/27RH3HQaLRH0eUNdkR0s66Iqg1OtiF59yRDv7vnRolutTugsHynb
         b2/0PMQI4AgI6xj9TChCdd3jp3SeDo8L9eETx4DKlxt7JcNhw/8uM7d8ZA6WRsBmd+I5
         adaAVQ/VB6ARusS0nEnbXy98QUFw05oi7lgdk2v1KHlWHm8Yk4Xai8pE2Ga7iRSL9KPN
         AoZw==
X-Gm-Message-State: AOJu0YwfgJuZ6kJ5nhNQbSWbu+QFfnvhEzCW4Y/8V32fwWtbut4hiDOy
	0XsC4EE9Yhn1uee4kIn5zcYwdw==
X-Google-Smtp-Source: AGHT+IG3GZGYn4y4YYm2tHG2D87ap6X+kqIa27ZDbVHHkcGLK1mHElj7VKWjYheX7bdAtLLEJpdQnw==
X-Received: by 2002:a6b:e70c:0:b0:7b7:fe4:3dfa with SMTP id b12-20020a6be70c000000b007b70fe43dfamr10643360ioh.2.1702397618980;
        Tue, 12 Dec 2023 08:13:38 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id t1-20020a6b5f01000000b007a6816de789sm3012606iob.48.2023.12.12.08.13.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 08:13:38 -0800 (PST)
Message-ID: <195fd72d-2170-4224-9e8a-3b4b27fbe3df@linuxfoundation.org>
Date: Tue, 12 Dec 2023 09:13:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/67] 5.4.264-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231211182015.049134368@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231211182015.049134368@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 11:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.264 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.264-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

