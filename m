Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD71A954
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 22:54:16 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3230125dde5so1232095ab.1
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 15:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1680562456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jIhDiEHT8vBLSgJz/+XNr8eL1bJEUN3iw88C4GMTz0s=;
        b=PQ0p8wS6Nwk3xHbBmtH666NkDSW30LA/F74tXJP718sClo8O+dpTw5sA7pe39zRXeT
         HNnsA94K1luPRe9TU4iwJU1aBpa34TcXeFCHNt0fJvqKZd5upArksnlA8WLML6Ahqmgc
         5t9LAxdafiqRkje4EJVduu7x9oB7JRscEAQuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680562456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jIhDiEHT8vBLSgJz/+XNr8eL1bJEUN3iw88C4GMTz0s=;
        b=A9ab6++M7mNv6CQRo38I1wcXk8ZDf1quMNj2QKCaC75sbdBCMBy94TuougImmYdslC
         qrOLHcjJrsaRfE/1m4n0VY716nH5RUeQjlMOkC5VWZF7AI8RCWkUuOaDGI4Pr652cn66
         TbItPDmMVNbx6BVH4XBWpCBo+ZB3JCSAqj8QUU6uSUqbV/Jk/uxbPhnN1PaibldgXwdp
         X7d5qQEq7rTpLwaS+VfFwMpuZIVW/ZyciyHcA2PgoKtCGqqCPOgLaXNEgvczQvnkkTGz
         4Mjgb4flXDAzyPxc2pM/9vh+rvd6L2CsJIO2SCMj3OoUfw3ZWncNN4rvgaaOhBF9SE2L
         z9zQ==
X-Gm-Message-State: AAQBX9eVD9PZxQB6oaFS6LEU6uSRUm6+dcN+nG2wVEhjwZGum/wE+GZW
	IL/2iJV6s0sbTiTa2urCTogwVw==
X-Google-Smtp-Source: AKy350bN5LBonI+2ny5eXAvaT9NhmbNkQHrd4vj6avV+5ATh7QMcNLJTf74jOSVFOB4+8D+u+QbRtQ==
X-Received: by 2002:a92:a80b:0:b0:326:3b2e:95b1 with SMTP id o11-20020a92a80b000000b003263b2e95b1mr411645ilh.2.1680562455741;
        Mon, 03 Apr 2023 15:54:15 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id a7-20020a056e02120700b00315785bfabfsm2946187ilq.47.2023.04.03.15.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 15:54:15 -0700 (PDT)
Message-ID: <ad4520ec-6791-630a-7884-67f723266714@linuxfoundation.org>
Date: Mon, 3 Apr 2023 16:54:14 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/23 08:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.23-rc1.gz
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
