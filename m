Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B6C847C
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 20:18:57 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id 7so6311779ilg.11
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l5jWeSEFH8KPpRFe92anqqfuPK5CFe56HJ+q/GFObsI=;
        b=KnOsqmJf+Thi9PWSSU6z38w0WX305+CFnz5i6LGeKoT5Oc+yHn0P8JMwQl5NWS4LU/
         5M15Wyd6bbMP+H7VRGLGQDvj9gLwpSQCNdE3dQBI02dbGoLv13yR5mAmXYKAFgXw4GTO
         mqlkKlFZ11ZGED6OeXt9CiygK8Nrup4QD82AE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l5jWeSEFH8KPpRFe92anqqfuPK5CFe56HJ+q/GFObsI=;
        b=MkNHv7/FQDngpSaEJRC3uwUQXPwIpob4zziJHKCTQoIMrEv8oxZsyOTCqCJNQUrdp4
         Fxn0MQSVpXXiRpgK9LaWQH0AJeGowa3jfSrSCnUp3i4kkEs4HRochODikIxfjNcbagBd
         jwGwRJZ4aggiacHRAeBenz67+9sqAmXgTTtsO9u26AOe+KKRqQiJi6xFnL+8yc5QpgU0
         Sc8rB0wdYYx422owwEIRPifbH02CuVR50RZ+UwjHJxJ70wHgEPB4At2XKd8rMH/uj3Qt
         L8rJuXTbZPxS+Pm5IKj+RUU0kpxI5qn7G1VkvEyOMVpnT4jZwM1ZQFW31ZohUuTHhZ0m
         IAQw==
X-Gm-Message-State: ANoB5pkbzXGabGqsIKrsx8HhHwgQXVE4vgDKreZM0Qmf0W5HRpCzMCN4
	pnKeWZwNwVXYV4RQaPT/ojZsAw==
X-Google-Smtp-Source: AA0mqf58swpwdoWUpjNBlSxGv88VOj7yRUmLl3xe1ZWcJ8j7cidiNCb6Kgp1vfhcAigzS/ABz9dSig==
X-Received: by 2002:a92:7503:0:b0:300:c699:770e with SMTP id q3-20020a927503000000b00300c699770emr6941343ilc.115.1668457136959;
        Mon, 14 Nov 2022 12:18:56 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id j184-20020a0263c1000000b0037508cc0bc2sm3876514jac.12.2022.11.14.12.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 12:18:56 -0800 (PST)
Message-ID: <8e929fe7-70e7-d425-d285-45e3040d6f09@linuxfoundation.org>
Date: Mon, 14 Nov 2022 13:18:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/22 05:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
