Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D8A1CAB9
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 18:34:20 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-68fc1bbc94eso4272308b3a.3
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 11:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695062060; x=1695666860; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FklHMNqNjRSEiP2yIY2hQ7L26kuoNsBASX7uOWLkP/A=;
        b=VtMChPT8i5zNhQWfj9SBS7fT3zabJkPMSuz/PQr8MdHFht+3UT3yKTJykiz+1KIjIb
         ofe4BYdQWDv5EuaJR5OWLb+WLdF7L8916WViTUNivACoMIOrOSrRR51S5vaaMs13ez4v
         lmOqWRPldLWi8j2XT8Z/DmtXr5qAwltupwuwWY+d5KAXKI5tJXqUffxMAKWPDTmI/xM0
         BPPGEKYi6DiKZTkbe9tSYD7yR77rI7Ai1f7oitq9YrtmPU1YbwZmcyGXTsPE/697WaXT
         JknfkR41vUsneckUP9wZgpEzn7D4n5jWYX0GMzp08yERYg+VYq173OkfxDQ/eidGsZCZ
         OySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695062060; x=1695666860;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FklHMNqNjRSEiP2yIY2hQ7L26kuoNsBASX7uOWLkP/A=;
        b=f5+IA6pSZBRgwwmXdz1mhAWOllbYqAyz/7V58M1gHM+WtXG9wrEG/YLiB0ihEvXFlx
         z7VuXKaJyKfYofgRF5qvZF+fyD8fol4ysmh1+O2FZuCEaGLxZiH2cTeEAsHoupG36Zpx
         9hZ13/mEEUBwG0K+lUuCFzw+R6HtI3fiepRyM+D39dQ+WVAMkoOnPDLCO3nUWZV6HBT5
         IpkgCPK72wAgoabp9UYrGcKSFdKcmubMXiv75SM3o2HcnQuOaL4OS2tLnHx7Sky5wsPo
         3+W9zn6TNvKMQsn5vW8xRbBzZfwxh2fd01wvmb9hMU5XOJncnHjdd380ZaeA1jaKXsUz
         SKFQ==
X-Gm-Message-State: AOJu0YwDQFLbnM23tn8xMYpZZ5XRbdIr/iZaERZJQYjGaILroro2mCK/
	O+U6qHpxYAorh22FS0abZmA=
X-Google-Smtp-Source: AGHT+IFwXJYVQv7z5guUlBHJTzNuMu1g2FRKkARGo7K/d5Yx3WlGOhxJ8DgFkGmY2CmJxSK9DFz1DQ==
X-Received: by 2002:a05:6a00:21d5:b0:690:2ecd:a597 with SMTP id t21-20020a056a0021d500b006902ecda597mr12245813pfj.21.1695062060007;
        Mon, 18 Sep 2023 11:34:20 -0700 (PDT)
Received: from [10.67.49.139] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r11-20020a62e40b000000b006879493aca0sm7395460pfh.26.2023.09.18.11.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 11:34:19 -0700 (PDT)
Message-ID: <51d7f8b8-13c8-7350-53eb-1f1e09f1b683@gmail.com>
Date: Mon, 18 Sep 2023 11:34:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/219] 6.1.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230917191040.964416434@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/17/2023 12:12 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.54 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.54-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

