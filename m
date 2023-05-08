Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA69E566F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 18:01:31 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-52cb78647ecso2187713a12.1
        for <patches@lists.linux.dev>; Mon, 08 May 2023 11:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683568891; x=1686160891;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CxYhKZWcTM6D0zvItXjXfl3kEr6BBDEZH2De/KsXnU0=;
        b=RjE9Zy5bFl7s5q/SOisMx8EM08G+BB800LBMmnQcnf1FZjwKN50ndFOsk9R1TgrV8g
         Dmqzc+GfiroxjQ5hUQWqtifI0c4ccQfLTfTok398wwKSZGcHwYQx9WfudqNGJeBedwPf
         6vI8A0qFgL0V/K8ICs7Wo9MlspJ/SRQh1yEcsByHY+R37+oS+44jhc8cfOcQ/zNCJmOl
         bYoBXrch2J8kTWBecgEY/6NePkXV5Zc9mo8/IWlKqS1wW85Z51EbOJC2M3/HmJfQ/Moc
         Cf9sRBJWXz1B5/GSWaGmNfRCF+U6nv9hVEJP7UxNMinhuZJfxz2gNubNBY93vT/WW2SE
         /m5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683568891; x=1686160891;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CxYhKZWcTM6D0zvItXjXfl3kEr6BBDEZH2De/KsXnU0=;
        b=TQMDXmmHr6sMQHzx0/RFmGKiIg4TlgwAYTNJE5g3I4uJ0b1V9ZLZmjQbC+WS6xSvHm
         qX2xamIJkOgJEvk+uJo/8dxPy4AcA0AnGotUUyBgy5eIKmbTkUoZSwcU1x5BH8j8asqD
         0LEvGD7WwukNCIhHIp9hnBNT1P7cKmjZxWiMZwt1nysrWfFt2Sp3YPv0xZbOJg5tkHim
         G1uIHGr8DyTpmPKnr8oQMSp6E2vgkD3t2gu99MTIrktRozr2zKBU1Z3zKRzPF+1C6oRH
         Vv3wWDgJAcsXE0nDMfRfWRtimqCfFdLMF6B/mW7PXJFX5WDydZelRbP/JMD1eQr0s91g
         8+jA==
X-Gm-Message-State: AC+VfDxrFHctSybcBRZU7n5w3StPuqnxfwquY7Tc7l+A2KhnjZ4QTMNG
	kyVT8AKbKW9xA8s/lMOXmX8=
X-Google-Smtp-Source: ACHHUZ4SQsmgQ9UWv9tiEpgxGofTIxrtbBNrMqUq9CdvGszWhGb6ZM87uyYI4/mets9p8H9kHSOdvA==
X-Received: by 2002:a05:6a20:3d27:b0:100:99a:7f71 with SMTP id y39-20020a056a203d2700b00100099a7f71mr8042018pzi.2.1683568890882;
        Mon, 08 May 2023 11:01:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k11-20020a63ff0b000000b00528af015a8dsm6566447pgi.14.2023.05.08.11.01.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 11:01:29 -0700 (PDT)
Message-ID: <b082ef46-a26d-db65-81cf-42f6f694de58@gmail.com>
Date: Mon, 8 May 2023 11:01:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.15 000/371] 5.15.111-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230508094811.912279944@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/23 02:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.111 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 May 2023 09:47:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.111-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

