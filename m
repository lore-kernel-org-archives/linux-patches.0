Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094B38814
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 20:29:16 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id d3so21344940plr.10
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 12:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zRcbw/Pw2fNIlbQKW1+g/Vut5WCBUnY0POcA20AoPuQ=;
        b=jUPKA7KVPWUNHo6S3bE6FvtfNIgSVOA8ZltkggrPdMop05kqp/IG5a2vlRzSIHKLWy
         bGB7B2sAv10jIQsoviJoxfMJJ8pyD7Mth0gWLZEcoBEPalAW3k+D7M0fTp2+Fr8Ak1Mh
         9pUX4CpbBC9AGLZfScr/KXApS+PKfWrjHET5MGilcxs1ZtF53lsOFP6r8QMUGj/htoqQ
         SAPTgNmX4DD6I3eh7TRCZCZ9GWN1HbQf15bKFk/NegmNTd+X7qPE1FJLmDb/n59AlOCy
         guR5UODExnhu3VtS2HoUGke9sM8d/qtZ4Fhooi+pdP0LuDAP9XhZL4d6vsnynrxA4ihQ
         GSig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zRcbw/Pw2fNIlbQKW1+g/Vut5WCBUnY0POcA20AoPuQ=;
        b=WNgOY1YgjN2d5PqjxqAhBGi/SGMg/ZVIzDVZwo0WKEvyNacmZuWQCsQyDVDulJzCQb
         61iXSfNtDRYuMWpWyLs5f3ytjW9CExoWocKyLcW96yM+Lf+kXA0+L3ADJA7OzwIC3lx8
         Lxp+ILf3NWbJeTaaGvCKlnSDtP7PwfZzs/hL/uiE/JTKnnt41gTyqHOm2uMe7pvK0nCl
         qG4RsVxXVvbOYlkQicr7FCk/Em8X/CSfrfLNiF/GeARI+WLn5YdUeCxmQhP79x/uV35C
         FcaqLdY7IMIsXau5c23Y4iO+W6jBZa+y2zA/RQuHdKrQmPm+2mE/3fScUY5EdM0V+SFV
         rzMw==
X-Gm-Message-State: AFqh2kr+YM8Ljhf9oBS01fKhEK+YJnnuavfjWDG2qoBmN/Z2l0EF0HSX
	l0mXbyMpaC5d57/pno7VO2k=
X-Google-Smtp-Source: AMrXdXs4WY/WYj1lSGZEJultfm60MUw8zc6EgPXU3YyJYx+8m++U8M5nmDfkcBKRNHnCWKOozf3BWw==
X-Received: by 2002:a17:90b:51c5:b0:223:2aa6:7f0f with SMTP id sf5-20020a17090b51c500b002232aa67f0fmr84182185pjb.7.1673555356369;
        Thu, 12 Jan 2023 12:29:16 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id oa11-20020a17090b1bcb00b00212cf2fe8c3sm9813448pjb.1.2023.01.12.12.29.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 12:29:15 -0800 (PST)
Message-ID: <b53ee5db-e490-1d88-cba4-d98764b58050@gmail.com>
Date: Thu, 12 Jan 2023 12:29:04 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/783] 5.10.163-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230112135524.143670746@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/12/23 05:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.163 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

