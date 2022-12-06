Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4B717E3
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 18:41:02 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id 4so14835690pli.0
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 10:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5gSr4H7WrM5p30udt7aFBkhEJpe85dvdV3IE4tFnVRo=;
        b=TGQT0+CX1iAFQkGnVQomi2v8D9g1ksynUotNR29hyIGO3kPFxOwpRrLIYnS9IuaWQP
         R/lQ60Ap2c9LcdxYX0GG7xVxS6FAnWBgG84pj9kavgjFdK14xF30kOzZjAY9ua1zySz+
         RnljnEKRisAfcjsyoyyo7jvGNVLpbN1W65dAuatU1Yc3uVrTRpwW3e9C97yzZwttlAd3
         4rAcFp6o1C6L2q1jyN1r1Es+Z4c745e4CXbD5nrQfRBqr++X+Z4X7T2tLQ4ueEwoGWhm
         WkHOrL2WtWPC1rSv+slE56VSB7Dt2sYG15dy4JUY7XcAk6sVcgVAVhR68JeNZxetpOeX
         JBgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5gSr4H7WrM5p30udt7aFBkhEJpe85dvdV3IE4tFnVRo=;
        b=ajYPvmUI/kNjRdIb54maWxl9JZ1zRlNDJT8dyq0Hyk/aOfYQMzc4zHymLqcdBwc7/o
         jyc72ybpXtgrRQj6pg0qzB8Fl5EY8OER04eXm9FvvuR0Bi+eZM9swu8txedCmIHl209h
         jNXoa13iXtYbZFOGQxYNvKPXTevbQk0AbAG3ZtKfQEg45g1yhFgG9UZbbpCBtkGRJV6i
         SOdFPHhS9x8IoESDz7bOD88WchJ75uf3jklZDle3tdAnB4SCdEK4z4Oil0X4SBAdtlJg
         oIi+oSSQrB2/DnXY8224Y/Zt2lDxjQNFqlpRY/akLbG3+23W3zJ5ZQlnjrsFPKigcJM+
         Natw==
X-Gm-Message-State: ANoB5plOmkp6ibnytJeCOJUKzdw4N2C/g2cIxH7NX6dTIZjJQ71aNqqe
	FmBOemKqaqu0aULlMsUTfyg=
X-Google-Smtp-Source: AA0mqf4aQXK2YFP9zN8AYyVVp8yy6XB26E6pP22ecJQ2jAGlbETA14oO58LUU1q4zivayR7lvz497w==
X-Received: by 2002:a17:902:7c06:b0:189:b0a3:cf50 with SMTP id x6-20020a1709027c0600b00189b0a3cf50mr27149772pll.39.1670352062320;
        Tue, 06 Dec 2022 10:41:02 -0800 (PST)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id ju10-20020a170903428a00b001782a6fbcacsm12937521plb.101.2022.12.06.10.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 10:41:01 -0800 (PST)
Message-ID: <31fae915-3803-49e2-cded-0ab77ffcb611@gmail.com>
Date: Tue, 6 Dec 2022 10:40:59 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 4.9 00/63] 4.9.335-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221206124043.386388226@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221206124043.386388226@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/6/2022 4:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.335 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.335-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

