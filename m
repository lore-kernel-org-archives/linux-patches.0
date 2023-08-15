Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DFE625
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 00:58:52 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-790af3bfa5cso58197339f.1
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 17:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1692061132; x=1692665932;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JdivT+33ubXZzmbj3HnlgDDmTGKoaEP2PiuRQnajAEI=;
        b=cGvE9GsutE2vGYYLpoxtruRo2qx9ju2hC/VOKsBKx+hjTZ0gFAM7YkJa3PRC4/r7KV
         vvYYtxrkOXxnJVkL3mynprvFKoB8yaQbn6vU3TTZPN+tWtr0sGGbuBKOssHECfc5aw/3
         APoe0ydN+Ak1EuMJXeKCBUk5EvHv51FyxryUE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692061132; x=1692665932;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JdivT+33ubXZzmbj3HnlgDDmTGKoaEP2PiuRQnajAEI=;
        b=RlAChRkkwQGu3AldPkkuGA8bL6Tnm+ptOxkSdq1sHxRBMxwpqnjgqw7mbOcHy560mO
         xdhBeAubLjpVO47xGeL8ZH5zCDlbEiQEu1h8R0mIGCQ6eEDf9gCboCoyxTaqH+OqJSbU
         LMho8RpRdLKfYargV2WmpfsVTrHJlRmTLjkyD9wtDbyz59llcu03++nBvIaAWAgxpqMB
         CeMd2AHy3nhQuZ9HDJeF0h+6kPApn8tswu1tD9KexlA4bJTHUOmAhN0UZFj8XR/Orz3J
         5DExdHP77MjXKd1CVnDrYJbV+sDqulv59e+qKEs+MnIMMPfgqcN0V8X+XF6vLonUhd/F
         5w7g==
X-Gm-Message-State: AOJu0Ywt9k6DiNo62k3P4t1jr1zCHWToQGi6H2AavTKaY50RAGbIDMwR
	+zOcIA9AYEiajFBic1myK/MbsyfR2R2lZ+sZb3k=
X-Google-Smtp-Source: AGHT+IHt36N2MvBksFyBSjcoO4rMuJi6SleshEqYhq1CbDLN0rp02f75O2SYsrbxea9QmpkqI10Pyg==
X-Received: by 2002:a92:c74f:0:b0:349:582c:a68d with SMTP id y15-20020a92c74f000000b00349582ca68dmr11073016ilp.3.1692061132197;
        Mon, 14 Aug 2023 17:58:52 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id b21-20020a029a15000000b0042b0de0b976sm3228805jal.154.2023.08.14.17.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 17:58:51 -0700 (PDT)
Message-ID: <0ada8b3a-0e77-41dc-a7a9-f12c112c0790@linuxfoundation.org>
Date: Mon, 14 Aug 2023 18:58:50 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.4 00/39] 5.4.254-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230813211704.796906808@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230813211704.796906808@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/23 15:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.254 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.254-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
