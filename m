Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE93F14AA7
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 14:22:06 +0000 (UTC)
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-34cb4b85bacso3131215ab.0
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 07:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693318926; x=1693923726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wf6GNFsSxcx1anzAYYKpXcKsJT0xS0B+yb4Pte21nG0=;
        b=KdwwvdZogbw+TuR5vNbEJAhj35004+fY33HYtgviW2le936RoS7BLxHT2nfwHmC0bu
         nkkWr8Dr5iLLrea0ScQ+BFGAF6xV1H5GaJWmh6cAzOr5NU8u3CI1AHnnlmr+cq/11SxS
         R8xwhS8vGTparOL3sa72h3H4F0/JV/uftQ434=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693318926; x=1693923726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wf6GNFsSxcx1anzAYYKpXcKsJT0xS0B+yb4Pte21nG0=;
        b=NBntSV7umsgaFIIf0G0SgaNWheAvHLIngUc72X8vH/qzGoNMaiUfA/jPdyCmmBaZFy
         zqHp/Q9YA5JZZjGMAm/0Qz3FpHb7QEWatFlqu0iPOjFegJxO1n8NI+IDi7VbB8xATWzg
         0sGsI+FteEMAM13GPpOUMiQKKFWjmZVxQlIyo7MChpwMTlJOghDoh38AtLF7psMSZKFI
         fu7QeETbDVblVgeV99mzx1dXs2OnkkV16b8Vp17MyHXfbHD1VXsZvenrDPjdCkwwM0Mo
         PsvjLkx8Ku/cX5/H+lJwSEQNDFOXCQUDfPwjcuqdyWz9PYC0BYATYe7y2ofJD+RYWYEQ
         6W4g==
X-Gm-Message-State: AOJu0YzbpB2ZCtTXBi2TOIaXiXv1ttyRhULCqFma/DrX1OwWKB1i6IZX
	zrbgbl+RakH+Ut8P83LPfVlY5g==
X-Google-Smtp-Source: AGHT+IEu1YVJL/d7gQqT5xXOlyC617XhMQ38RwAqUk/z/Kv5qvJ0qn/cmDqhUWI1CMt10A4ZirgvzA==
X-Received: by 2002:a92:d6ce:0:b0:349:385e:287e with SMTP id z14-20020a92d6ce000000b00349385e287emr29439643ilp.1.1693318925936;
        Tue, 29 Aug 2023 07:22:05 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i6-20020a92c946000000b0034cac5ced38sm3141971ilq.13.2023.08.29.07.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 07:22:05 -0700 (PDT)
Message-ID: <678a9296-c9b0-9270-7194-f233e9559fd8@linuxfoundation.org>
Date: Tue, 29 Aug 2023 08:22:04 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.10 00/84] 5.10.193-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/23 04:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.193 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.193-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
