Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8990BAD26
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 22:07:21 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id k21-20020a17090aaa1500b002376652e160so810404pjq.0
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 14:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BZyheY4w/jC+3OShGK3OJX0UE6qFWtZ/dPR7eSYAETk=;
        b=Iv01k5+nCxWPbMEk4LTKpsRMcbuSombDKdAotP1jhNS4DXcG0SbQ6LPyBugGv43I1O
         1/hpKpDY6XI1y8g3BdIyyW7QrLGcfy2pDYdcLULsm6oYQC6BkxfSAdYuXPV2mWmAQp00
         1xqIGiFJHQ1wM5qrOaYBEETn3cM0muq02ojxZyLUHr7i1kOEvLgGbMJPq3Uuc5bU6cZ8
         7TgQUmLzmDE8lRNKo6HmiOZHzVzJqek6EtVAaql/P47oC7lwDK9uxiQsV7QTh+yCX/p0
         iaEY8osqqo5QvnGxPUkEt9z7NYwBbCtMrXp1w0abQOzhtVcDyHqtm9IZYhOcwZAjke8y
         M7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZyheY4w/jC+3OShGK3OJX0UE6qFWtZ/dPR7eSYAETk=;
        b=GbXD1oeag2689hz9Q0qPLBzGOSqhW+hHF4d1dtlyWWW9fCk1IPKzkpBxE6DAcbfcob
         QhskIqSaNlGpeBfoY8zMl4ERxecA61Ndxew4n6o7Se5sLrHWWXYcJ4i9pnOkjfQYIUeP
         7+SODV7B/fMn7RckuUM1M0WGnhMx31N7B6c6p3kUz6eZXTDdgkz0WVRYhuo2zw6W6haB
         lHtD5mnqJzLruAobPz5SVvhlhdWe8Okvl/o4E1gcC6FAedBuYaWtxDeG9MlVNmrsMCdd
         Qc0CYTBt86VZOg4bibyTeQvPRbOdu0ffyMZnZgK4Ew3MgFvmrnLpyk+Ez9l414yD0cFu
         aqUg==
X-Gm-Message-State: AO0yUKXP72If+ee7zuI2+hWq7JnedPIryCbg3xgTRGCOWlA7zpOGmfJZ
	QZBsLjLDEdo3bRzYdBaeBBQ=
X-Google-Smtp-Source: AK7set9lWhL8yaXx0ayujGP7JFfb6CycmZAeaWDJGbkds31VdxUqPqbuWsqkjHfhy3m+YfacGaF3HQ==
X-Received: by 2002:a05:6a20:1587:b0:cb:f76c:ce55 with SMTP id h7-20020a056a20158700b000cbf76cce55mr6891105pzj.52.1677190040921;
        Thu, 23 Feb 2023 14:07:20 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c2-20020aa78c02000000b00593adee79efsm6149602pfd.55.2023.02.23.14.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 14:07:20 -0800 (PST)
Message-ID: <7aaea7d3-f55f-5fb3-c0e7-96f930c6be27@gmail.com>
Date: Thu, 23 Feb 2023 14:07:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141545.280864003@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

