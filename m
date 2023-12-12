Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD9877F22
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEZaxR4t"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7b05e65e784so47428639f.1
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 08:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1702397488; x=1703002288; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9A8ywdoqkvbMjsf35PJP+6DC/rgWj8HumDYD5a8MF5c=;
        b=dEZaxR4tBUGk/iOZrcfWz9llbPts9amjLwfCJCKSPdBYldUGan2ydrynDtCDwZ8a52
         gBH7Q5OiP5H/OSsIy03Bd6bnzgNkB4f4H2bSDFKx1BndtxU0tc6NkPaZaSFUSb/NmFEQ
         vC1d5alXApkRUHYdjDpESaYTmxZD+BuqsIo3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702397488; x=1703002288;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9A8ywdoqkvbMjsf35PJP+6DC/rgWj8HumDYD5a8MF5c=;
        b=byuHT3N9h2r6KocGgJF6j4tDEzQZ0jCVa8VI6HPVLZd0GCQv218bJeU3MRjBnG/MAh
         hYhieuHpL13U0NufFpSaDP3WWAg0gfeAbQs4ldtMn6shM9fjyoRWgNOa+vcgmZM89fTK
         +Y+2r9EhFrFwwJ8aGQXnJxIYOvsM9GCiRyS2nR6tZRKbaTdmrizcj+5pzQgwq5tm/dWV
         c++y2BreFPLYO1IYLZEVLXxP+ZkCYa9HZATBWGlj/Mayipj16VbR988QS9y8UCUA3wv4
         9bl6eHxuu1gEsUP7NRzA6LtmGITluHzDOM+abEsTf4e2hCt+25gmC+oMQNaS6nJgdMyX
         yyyA==
X-Gm-Message-State: AOJu0YyWcfwPebvnunRPk/mJLjJ7aP6gMbXgmDPnJ4UQNUX4/BvkJfCJ
	xX7353CIvPxL0Zu4aQdsIO3ZJA==
X-Google-Smtp-Source: AGHT+IGIAN8f7DjQU3m3l7oGBzuemvs/+v1uNJrzjbiEiUXi2FlQ3CVHAZy8Zv3mOToQOcsKkLLw3g==
X-Received: by 2002:a05:6602:254e:b0:7b7:3ba4:8949 with SMTP id cg14-20020a056602254e00b007b73ba48949mr7112425iob.2.1702397487767;
        Tue, 12 Dec 2023 08:11:27 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id t1-20020a6b5f01000000b007a6816de789sm3012606iob.48.2023.12.12.08.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 08:11:27 -0800 (PST)
Message-ID: <86fb793f-f319-48c3-889b-ee9251371e23@linuxfoundation.org>
Date: Tue, 12 Dec 2023 09:11:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/244] 6.6.7-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 11:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.7 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
