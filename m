Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DC4612F
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 17:46:27 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id h19so2668698qtn.1
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 10:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678988786;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sPZg95eOf/E2ZkQuZc78nWY6/OH+N1ZiVxrFPyxfRKg=;
        b=IjrjqgOcNzR4oEMpZvWT9tg6p7CuK5YgxKV63oYBlMJT6PgKlICg6dZr1/8plko8BJ
         AkB212Sh2FUOL3x1EUSQJx9b8dVuJ9hWepUzQkMoL0t+xKCtDPIiRf2ZjM9tsdHxE+aj
         Q2RAo17qVF0Z4QkaI2p+JaoRv8bH8SeifK+zo9qTmcPpTCM80O35JS1QReVFra2JaUeo
         lklRcmb4UG+7Yytj1php4B6JxCeYfAy1Kp5YMR+hdjFZNCRekjYSRVwzC56yxhUJAnV1
         xQIKr+N1kUc5ykkwK/Z7gpEc73Qq7nSEq4xGanyqbzEls8KieRP3I40QBXr5/BiRhd8l
         o4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678988786;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sPZg95eOf/E2ZkQuZc78nWY6/OH+N1ZiVxrFPyxfRKg=;
        b=P44owgMh8pSOLogag7CfkV29WEGpk5dB3nCMvIt9xxVCPZ1u2DYRFENDvaVOm3dflV
         DbQVmqOgbfGCrzKsk4rVBqjMdtT4HX6OxHX6eWq9HbyjBYvk4T3G3h5iW+rqOh3/1tWF
         mbthu9km1I3CefUOwxEJQaELoci/S911KJoNjOJsBVjrbLK8WjMlr1NuSRUHO+QB9O1l
         PqBqK9X3QY7jwAKye6UaWX/0qbNsmqoS7qj6ZUM1A9zM9rwr33RczpAQXoZCeE0w7/PK
         7+BRjSTSx1LlYZZTP+d+WgrSh96isFfcqk6snj48ZZRV6MG9HPqZ4Fwwpwn7WpzznHQ8
         ZCrw==
X-Gm-Message-State: AO0yUKVB6CKcXGcqbrHLecK/AH8ck6tJhCE2HS4pXsR9/jTJ9M3d5Ft2
	AHy24yarXakhASr31BeN6HU=
X-Google-Smtp-Source: AK7set8PattTu8uWLuGWv1oNMtRTPKVUeUGtjmzlapFfYlNtp99OQflEaqMMcqTxTx4DgvgZNxjEYQ==
X-Received: by 2002:a05:622a:1393:b0:3bf:dbb4:3bcc with SMTP id o19-20020a05622a139300b003bfdbb43bccmr8320234qtk.4.1678988786527;
        Thu, 16 Mar 2023 10:46:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k16-20020ac84790000000b003ba19e53e43sm46072qtq.25.2023.03.16.10.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 10:46:25 -0700 (PDT)
Message-ID: <eec5798a-79fa-0262-340d-8c48c8064c02@gmail.com>
Date: Thu, 16 Mar 2023 10:46:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 00/55] 5.4.237-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230316083403.224993044@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230316083403.224993044@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/23 01:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.237-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

