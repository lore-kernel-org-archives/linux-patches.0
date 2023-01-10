Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58968A92B
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 19:23:44 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id bj3so10219594pjb.0
        for <patches@lists.linux.dev>; Tue, 10 Jan 2023 11:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dwVwbOnb8uo95mWSD5Z9lzoTbmN7Z+5g24MYiZXeXGg=;
        b=JSeT4IlFgJCu849N5IfUkOkRcSWi8tuOFkj8IGEO6iV65xBSIhpT4U+gbJ+NV+iyKF
         hB35IGf7APfD2lXGjZGhUx4yJrZaAygpnJYbcWREbs6YFCb6qDfXf1SFWjOH0DmxoQiL
         HeDyJPyQQMzxD0iQi4UBfxGR0dDsWiPB58FztpNhwQZSB+UafcLCwZP5pI2r9Ojhh4fQ
         eMHwDJSOH7dqsljAASfyRfFmJ0vndtt67MLIASEKf0jWj2N/+6zU7o3Lf3satX3bYXKf
         Pp/Yct+3zRldjWfJpzm8czfS7NItL7jzJWn8Z1J7a9rTYSAy1xvSy73lQhwIC2xYKu1C
         aHvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dwVwbOnb8uo95mWSD5Z9lzoTbmN7Z+5g24MYiZXeXGg=;
        b=yZjODpryBVAOrE6B62yBSBqPE1u4BR04JX+OxoDxwcJY0RO2YPtePyUCzWyUp7HSqO
         ipf083cUTyUpJfM+yaSukW0LS5JPob/T39T9LYYao+LpI8bF+tXpABSuFujjsIlqlFs/
         CEz/2thEllODAfuyQ+niWl3wjhCAH18WKyF04tX1h/D4qwopmFojVJeDrhethpW6hoUS
         up1RosCykzqZiP6JxHLXJaxIaJlW39GiGAb/tcrdr+WNp9J29o9RHHcF2GEIjA/4W3pM
         PfbwV9BkMfg68WTB4jKID1QBFAfhpxzKRJT9yWzh6f17N/WgaY3Jv/FWk74gopkCl82w
         4CEg==
X-Gm-Message-State: AFqh2krVUS9vIiBiPr765msWnrTutstx0I9fTjYRFDuxybtfRhJTMwF3
	CAmulHpzuemDI/45g+q45BY=
X-Google-Smtp-Source: AMrXdXsUqCE69LJ+dhixRXXqLVV4xI1LHTSGfTw0Kwo3VoZg+1qWsyatnQBoH0r+nFEb6EZHi2iqmA==
X-Received: by 2002:a17:90a:af85:b0:223:f385:bb72 with SMTP id w5-20020a17090aaf8500b00223f385bb72mr70995792pjq.49.1673378623680;
        Tue, 10 Jan 2023 11:23:43 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id oa11-20020a17090b1bcb00b00212cf2fe8c3sm2782346pjb.1.2023.01.10.11.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 11:23:43 -0800 (PST)
Message-ID: <8a6c6e17-de35-0136-9ab9-5eb4cc39c6d6@gmail.com>
Date: Tue, 10 Jan 2023 11:23:32 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230110180017.145591678@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/23 10:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.19 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> NOTE, this will probably be the LAST 6.0.y release.  If there is
> anything preventing you from moving to 6.1.y right now, please let me
> know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

