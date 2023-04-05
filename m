Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C7B2C9A
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 13:10:41 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so39470730pjt.2
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 06:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680700241; x=1683292241;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VtodILvQ2ZMMlQviiIR+jJTYn+DhiSUAYYkxKahJV3E=;
        b=ggCDlh67old4Wkj7U8Xwno8MC/kO4SkXOblBCvDt9kFG9v2sdYQESfxZLEmPnPdtNG
         OJBOohulVFZIASbj3NL7CFupbP+jc9yRP4ht4QCyFhgimVu/BqWnrgc5lfgT2yYRdNUq
         qW8lh+CsnB4Oj5uoqqlnJEI1zfWII7fa0Nre5xYhqH9FDrJ5q7RjXz/fJe7F2QhyJrsH
         1O4TGb31QZ31/4xJ5ybx/TO+hJP86nkJuIpZEAiR5DKL7r2GRSG/140XbcGfoY8SNEsf
         CpZmjcHzjMeZ/eXc9aCRpOtrdv829DWm3sp339ddYNW0S9d/FxVUCgeJgtIcQFIbLsr/
         UfNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680700241; x=1683292241;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VtodILvQ2ZMMlQviiIR+jJTYn+DhiSUAYYkxKahJV3E=;
        b=qvVBIDhl4rLD02PhIKdHd6opzJcMbhSmUwS5BhQbx/Ivfm5RTuRNBnWq4DBhecRsBk
         y75b/sbTPoP3ekLuY1A1t8WSWJecn8VARdAQu2kapRakZ64AQzVy74mcS9Mex5G2lvz3
         N8AdDeE4s+1NhTNNWPtOrY/TUz9k1S9FUfsJGRTYsJYjMm1WFdMXnKYwQvYbkEUgZFjW
         Dgbs9MeJciytb4uSvCx6NfU40mfLa3QUVrioDUFDH8kyBcvEwY/mkxjTuJQN0fEr/YNp
         qVbi1G7ZBIzgTLozIoYfJJCrUJNr/8d5IzNX3yf63iKwNI1KBqnIiVV4dFjQVoxr6xLx
         8f1w==
X-Gm-Message-State: AAQBX9ePItcrXKeOcGF22ASc3QAlYPLV0ZHB1hg+5YGkulv/I+0Q9FMz
	MBimfxqcXgugxrorSnXg0tA=
X-Google-Smtp-Source: AKy350Y78GB5qsViRCXJ2kOADdulfOaU/53okcrylJp8k7Da2LwyAVBtU9ZjdYg6bmzyh9d1Gzo7Vw==
X-Received: by 2002:a17:90b:1c8d:b0:234:b964:5703 with SMTP id oo13-20020a17090b1c8d00b00234b9645703mr6584614pjb.18.1680700240841;
        Wed, 05 Apr 2023 06:10:40 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id t23-20020a17090a5d9700b0023d0290afbdsm1383910pji.4.2023.04.05.06.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 06:10:40 -0700 (PDT)
Message-ID: <df2fd045-daef-246f-8f44-5c2a301b4804@gmail.com>
Date: Wed, 5 Apr 2023 06:10:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 6.2 000/185] 6.2.10-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230405100309.298748790@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230405100309.298748790@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/5/2023 3:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
