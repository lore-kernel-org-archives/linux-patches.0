Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331322770A
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 21:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciPNlw+g"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3574c225c14so7092005ab.0
        for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1697491902; x=1698096702; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2eq+Kx/9S8V0Cs7DZC5sSlCaT+pWk5Hx1QeNjsJae14=;
        b=ciPNlw+g8FP3MMh+TXMzVUj63K3ArXocK1EGgtQNzB+y6dWopdrHUVM3FoBPKSyJMR
         lwquGn+4FCQA+YUDHx7DMdDBkr5l8u+ODJubcmNvYMIYY2H7g6gErJzJoa3INn92wLmh
         RyREQC/oRVtwG1YHnkXIeNeX5AQbaWQ9ozvWM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697491902; x=1698096702;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2eq+Kx/9S8V0Cs7DZC5sSlCaT+pWk5Hx1QeNjsJae14=;
        b=N7zD0K3KTeE3ANaFuBJK2rcoY3qwwjTlrsIBMr+To9OSbSe+X6qeL+Lp5gBbrOLXDl
         DA5RSUIsd4zugisMtsndnAuIYAwDst5jUbhjWos5KvoH5KQ+NEsxtfR+WtxLetFQCFYx
         djPO0AzAoG6jCr5SLW6ABvQ77POm82b8qAn8q10uRXgeiKh7LWC9WK6m0vKTLypOMr/+
         P9xZ3qkZglDMVYfrIKpgha0hwGOZRvdmiQkbh4T4KGZjbbcutRQpOlCt7/QDbyAYZbaY
         N10UvnheUH9PtUl1Ig53hNSxrXla4ZgQ/SfFLCz9dvbRH1mpQOe5t05ByvEb7T7A1jgz
         N9kA==
X-Gm-Message-State: AOJu0Yzu7BoUqwwNbF8fKyX/Jweq9Qg/IzPslyRORdzuk4/2ddp8HLnv
	/gN4VlKXAeBwN3A1WEAecs9Q8g==
X-Google-Smtp-Source: AGHT+IGxeDhQmu1poxt/H4JzwTKErzZyffEgpadqK/wYb/Vt7pGxxTsvG0HukykYVzG+YtLpU/OsYg==
X-Received: by 2002:a5e:9404:0:b0:792:8011:22f with SMTP id q4-20020a5e9404000000b007928011022fmr472192ioj.0.1697491902309;
        Mon, 16 Oct 2023 14:31:42 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k8-20020a056638370800b0045c25ef9a56sm58767jav.21.2023.10.16.14.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 14:31:42 -0700 (PDT)
Message-ID: <374b97e6-05e0-48b4-9cb8-6b371f5c7f5b@linuxfoundation.org>
Date: Mon, 16 Oct 2023 15:31:40 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/131] 6.1.59-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/23 02:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.59 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Oct 2023 08:39:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.59-rc1.gz
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
