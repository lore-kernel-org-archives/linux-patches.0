Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C64C1EA76
	for <patches@lists.linux.dev>; Tue, 30 May 2023 17:45:00 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-51f6461af24so3026791a12.2
        for <patches@lists.linux.dev>; Tue, 30 May 2023 10:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685468700; x=1688060700;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j94aGplfWMWnGkDbJHhE7nVaNFJFqF4WYHNvsj+rgEo=;
        b=YJArRZNFf+RSZO4eguHpQ17S708oTlO2GHgqc2Er11eeFBXH1nanH2JOU/HL6gfj+M
         aKro0+ZdCJWt21QXdpCmtX3znlG5UiyOCRoc0stGDaQRMtDl1bHDXW3ey6go9xtOuw5d
         ebtbFFZwqA07eDGkw58RqVDjbnLXMBz6I/Xnsrl94mLMBimArWA1QO4nYcRlQOaYmkuH
         CCxdiBZnwdNX6uoy5Z1dz2WBDe9tXaLBwIEQSYPw8eqpMb1znQ+ojg//hjWUmkx/SsZS
         13UiMDhr2AFprvKSRPo8kQV/dX6tkU7fDGRNZCkpPVUU43YgqTt5lpKixu+wotoPohyZ
         cEwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685468700; x=1688060700;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j94aGplfWMWnGkDbJHhE7nVaNFJFqF4WYHNvsj+rgEo=;
        b=CPeKhOK/Pd3kUOqBTlIZjoV/JfltnTTi82jgJPFvhArhNz2NnOyMqQvdbCeQAj64Xw
         ZTzECyN6KEWbNyQR+lQ+AlzEv9yzgNYmK+mE7VzDRSfMnlYQu0znqYFS8t+rPfjKx7XL
         MsvzsjVNZL+QC7vm2OKc2E2O4RXdK7B746kT3AcFPrAvyW5uObcePCZ3542k9XumKmdX
         luZK4sKptuEX5XnVtfPP9SGc7ybm6fz0MUNbw29/PQpfH/U7BGKRMTQbUk610ry3aFfr
         xGM7GUpA1XTLIqZJxLSGRRAbtMu/zDGBX04z7LozExE78wxp/rexPAmm49t7QeSVdzHE
         F6IQ==
X-Gm-Message-State: AC+VfDxNkyW/QqcC+5FxWUMpig9u9mAwPNJf0HpcBhSdwgPFZzCxsMpU
	AhOcGfzu3bLkdlkQSc286jY=
X-Google-Smtp-Source: ACHHUZ5ybmzpjjvmXl3VzRqDUllxyO//rJaSr3NFWUJGddhGQMcPonWwzMNL0AlMHyvXEbj9ggYvEA==
X-Received: by 2002:a17:90a:c217:b0:256:4b34:8bdf with SMTP id e23-20020a17090ac21700b002564b348bdfmr3157550pjt.39.1685468699682;
        Tue, 30 May 2023 10:44:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g4-20020a17090a128400b0024e026444b6sm6535430pja.2.2023.05.30.10.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 10:44:59 -0700 (PDT)
Message-ID: <7bfcd9d3-38bf-26f7-ef1f-51c9a0104e17@gmail.com>
Date: Tue, 30 May 2023 10:44:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.4 000/161] 5.4.244-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230528190837.051205996@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/23 12:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.244 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.244-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

