Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD124625
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 00:52:46 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7748ca56133so58478239f.0
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 17:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1692060765; x=1692665565;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OMHEMD2drjafQVG8JrAKuYd3GCDFQ+GbZ9AG30u1YxA=;
        b=K9rfLJ74XS/LBFVT1DDIbRdoZS7Kv/Wk+KEDkz5OCPixVJiE5O2gl0toQPWJgAjjTd
         y5alRq2zbFRc01I0wqqRpSKsxYxi5i6py1LNw5DpwgcdH8b43waAYvyE+HEE+frLL+PX
         Lz6r+cnqducOdHZb+G1qfqayXNTBs9fVPc4wE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692060765; x=1692665565;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OMHEMD2drjafQVG8JrAKuYd3GCDFQ+GbZ9AG30u1YxA=;
        b=d2ZiFJhUo3DeQbC1mvRPEmiuo1/JaCkfD/IVhfnqE4BgIoS+v9W+TLkE2R6nHNOpaK
         Cc7bCqfdX1p74g6nvPUCm2aUwD/S6xWbntKql981v4kdepXBc/OedZRC1hhoxVVB7FCk
         5t/gbMSHjli1L9hoILlzXQduJgMDCpe8EygOR5GRUdeiXZ4jbUwBiN7TfwWEA/R1SVVe
         OptscFeyD7GhHRmg6uefRJOf6YMqPPPVulHe1ng43QR4E7bFLy4imTQven/T1ZM1tkTL
         Xsul7wFLPDBH/D6rpRfy1/j5cpjPmJEZWBS01aU94kmBWVhwNl52NEtKTPf81g4rNNKM
         JKug==
X-Gm-Message-State: AOJu0YxQ7XSPLE82dmKtK5abt5i6EJzG4Q2bOZXgCB+iEmgpyN5idfy8
	FLhRQ7tc3pQzf0RjaKuZmSlDQQ==
X-Google-Smtp-Source: AGHT+IFX3GXgUzsbUvGnkssxTlN3jq4QhVZLC6xKs6FZ8jJPIhSjSDQU0V9CeIVBhXLzm+zO+14Fzg==
X-Received: by 2002:a92:c6ce:0:b0:349:7518:4877 with SMTP id v14-20020a92c6ce000000b0034975184877mr11968941ilm.0.1692060765684;
        Mon, 14 Aug 2023 17:52:45 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id t15-20020a92c0cf000000b00348ac48e127sm3577087ilf.33.2023.08.14.17.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 17:52:45 -0700 (PDT)
Message-ID: <b44a3dea-ad20-c046-2027-95fa855ddec8@linuxfoundation.org>
Date: Mon, 14 Aug 2023 18:52:43 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.10 00/68] 5.10.191-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230813211708.149630011@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/23 15:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.191 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.191-rc1.gz
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

