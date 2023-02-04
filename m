Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B025910FF
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 00:49:41 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id j4so2610991iog.8
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 16:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oo7mqL9y5RSbe5Z0lh99Nai0NSR3yfVP+UESegMK5U0=;
        b=XFBszp9P01vRlXL1pdAzILHmfjGJWxCUz1sNv4cpoyHqiHY6Gt40rhXfkw2dtuNesG
         KTZALxh+SuXK2UfrIEGMDUrgcdmQif3M1oBV2E5bhQqTaJUax0kEo+hM+XBAPGjP86KV
         q6jtbc6djuO/zPZqCLLlJylZI6i70lRwwG69o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oo7mqL9y5RSbe5Z0lh99Nai0NSR3yfVP+UESegMK5U0=;
        b=Ykb2khUmUzEjGyepRp64IvhyIbC/E17Q0CRc1b6J6rJdKbFpRlo7F+qZAKqTG+tB3F
         ZM1ei1ll8S1uZb1DQyPUOxWShirJGXR2MFxVMDl8a28dpCfpxdl4M8notDxFnPw4IwNg
         TTbeXO2z8jUiDrjEAXrU+gaEaoPxtKvsIEwaBhqzLg9nP+nDd5GKfhtGVPubMDayK6a6
         Pb/RKCRNZjQBir6pOLisxcV0g8bfdDy38l8xW0b+4Dl4QsQD6RZHginP9xNL3fGG9J3C
         eSt0nN9rXekjFHFoNqdLS4qWX3dJHaTXYRiIeFNI1z0jz38+t8Z6TQgfwHVz1wqxpRKR
         5W6Q==
X-Gm-Message-State: AO0yUKUDc11QVCMfkZTB7YRlpwlrDj7+t6Ws1Q9LzEpeqlwrPRQ1Zfev
	0uB9kn+ZIaIb7YK1NIMVqRsPBg==
X-Google-Smtp-Source: AK7set8pyFTXYndI7vTRUogyFr8J12Rz6W9PAOmi/TDMHIHlMSf3w31CyN0/et9dLawFd8OEYqMRTQ==
X-Received: by 2002:a6b:7808:0:b0:71d:63e5:7b5f with SMTP id j8-20020a6b7808000000b0071d63e57b5fmr7554082iom.2.1675471780598;
        Fri, 03 Feb 2023 16:49:40 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p32-20020a056638192000b003748d3552e1sm1283835jal.154.2023.02.03.16.49.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 16:49:39 -0800 (PST)
Message-ID: <6ce2b22c-c19c-6e88-3ceb-a05f4bd5ea99@linuxfoundation.org>
Date: Fri, 3 Feb 2023 17:49:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/23 03:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.10-rc1.gz
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
