Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D78547772
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 16:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIJFGGP9"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7b442912b8bso10665739f.1
        for <patches@lists.linux.dev>; Wed, 06 Dec 2023 08:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1701880310; x=1702485110; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iDgo2Cq9agN60fB44yQGuaAdYgge0fbUUX+iicw+JS4=;
        b=OIJFGGP9a6zeOzz7ibfMOap94o3StNXytWaL7l5ZrLwxPqmydvTLWhSv1mTKD3EGTS
         zZANv7Uure6DGMh27f8nhPjYr98QDjw49YEh3slGwjmUdDMCbXNoZGt5h7ANGjKmCZzc
         /XkAFsDxB/1z9TZtKDKqGJ+dQuHn4/lst2x9k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701880310; x=1702485110;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iDgo2Cq9agN60fB44yQGuaAdYgge0fbUUX+iicw+JS4=;
        b=JmtPMeGcaHK2xF03WV7x9sWvMaFrjZV/6d4xSYdHbHScvOWBOQmYWBdBQi8P3lzw81
         NmtjSO6/7AEm4GfdrbgDMv8a2s1pbSVZQw2IM9uOv660Ur2GezDlwbgdpZ9PrX/+wdaW
         Ks2rk2KBMnwmYSp1/aKEXh6M3gcsvT5muOvbhoIK6inCSr9MtY1lJlt/sERpOXsQpdDg
         fVc9sgPNMJhBDwEWhncRDlsfAVG3KFRGvYbAG3XeNhRSRCQdghCLB6IVBC9IxZlo1xvH
         xQWDx9191Nz2weRhipyYQIR1fLmflRdgz9UVhNA+pK6NHb3cl9tCXkEU2jIjYxeyX2oI
         2Mag==
X-Gm-Message-State: AOJu0Yw0OkunmmynKK7W+Lc8C9qGGFQtmEgrvGf7D2s0+cC7iG+tW8R8
	lSRInrORsV5CqUIhQaVtYXCfew==
X-Google-Smtp-Source: AGHT+IFBeELv64/d8AuOa3xLLsK3PGlt938fjaP7VdvXIOnh5ODloxlxDxRzn4vnwtsAKO4aT+uOtA==
X-Received: by 2002:a5e:c30a:0:b0:7b3:58c4:b894 with SMTP id a10-20020a5ec30a000000b007b358c4b894mr2839717iok.1.1701880309819;
        Wed, 06 Dec 2023 08:31:49 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id a7-20020a5d9807000000b007b3e07371bbsm3970203iol.19.2023.12.06.08.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Dec 2023 08:31:49 -0800 (PST)
Message-ID: <fa221062-03b4-46d7-8708-9d3ce49961dd@linuxfoundation.org>
Date: Wed, 6 Dec 2023 09:31:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/131] 5.10.203-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231205183249.651714114@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231205183249.651714114@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/23 12:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.203 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.203-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled. Fails to boot up. Boot hangs during systemd init sequence.
I am debugging this and will update you.


thanks,
-- Shuah

