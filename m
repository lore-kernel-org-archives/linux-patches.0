Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74DF8F54
	for <patches@lists.linux.dev>; Thu, 21 Dec 2023 04:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CITAvKbK"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-20418dd34e3so51575fac.0
        for <patches@lists.linux.dev>; Wed, 20 Dec 2023 20:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1703134354; x=1703739154; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bz5m5ul72l4RhCvdkAAZDejQ0Cy9sHzUwoLbrF+jVCs=;
        b=CITAvKbKEtFv/TbbtYqNtamtqMO6Li3Vndun6i+oDBSe8vBlKPGNbuBxImzoU/m2wD
         gdEDDc3wdOE6McMfWpnT2IUxSey0Q/r5GwvtCQRHHvCtlj0iOaBiAAnbteO+Z08ypQ96
         l5i2jmdhAxbZX8iSBjGZ2ymrOF6sZY8RhfgSs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703134354; x=1703739154;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bz5m5ul72l4RhCvdkAAZDejQ0Cy9sHzUwoLbrF+jVCs=;
        b=Wbsq/mkV6Y/NugMTX5xmn5I3WtQOkbkbw7owfbYXFxA2t69v9qobetLpNCsDCtBwzH
         SX9PvHxxJ0BU44gSyLE64aZ/wwP5BiZ865CV0W1XJVXCTBu1gQ+21pjQSseHfdnV3DuA
         JKpSzO3WoQme6ecXrLPOqNNtp+bx5/loS3w9d0uci/sGfz2fbaAySn0/v55oIioNjB+B
         e/AQNvM/BaoXHDb4DPFGV/Q3937Te+8ZmGy37qJDKSRdE+wnyk1chny0Kvs2M0TO74Ha
         B171B3vECWaqoZUvJK/Rnime1Qx/i3Z+F39a/SM68ZmDLYxhvoEoPP8kG88l6LPKPnYX
         ZolA==
X-Gm-Message-State: AOJu0YzSc1SKSJYAwR1Q+2bS2CjESxy7AgqlcpSe1txCp03Nz+xLAijQ
	RTPJbJz0BUsnStvzc7HMMUmUng==
X-Google-Smtp-Source: AGHT+IFU6YIKltqtyRWS5Fq80oW1ZM2e2tj8nwLk0KoDFlFz6ocQhueT3KZ7ESKWk7sxooIZC+jWPA==
X-Received: by 2002:a4a:a581:0:b0:591:cdc0:f28d with SMTP id d1-20020a4aa581000000b00591cdc0f28dmr12232023oom.0.1703134354564;
        Wed, 20 Dec 2023 20:52:34 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id j12-20020a02a68c000000b0046b70c98d41sm289714jam.26.2023.12.20.20.52.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 20:52:33 -0800 (PST)
Message-ID: <56301ac9-ca34-44fa-b18b-9c779fe9b24a@linuxfoundation.org>
Date: Wed, 20 Dec 2023 21:52:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/159] 5.15.145-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/23 09:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.145 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Dec 2023 16:08:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.145-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
