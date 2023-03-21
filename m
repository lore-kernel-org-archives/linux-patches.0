Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA7AD505
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 19:07:22 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id k2so17079124pll.8
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 12:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679425641;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SmRuV3slV4UahTdDybzVo2CRivDqucnTA7QxiIR/P6s=;
        b=fO804EUnLJMrAP5WUYDun37Oe5HpVxM+LHBSf403Goc0WDQfpeMkU9aqb4u2navE1W
         6F0idMX+2pzL08bZSJuEkIYO3oMhgCcG5SS8ikbQJcGvF5YIvo7vpMSnzKRFhKzlH29g
         T+XBZL5c0htG9UDsfErIuo3xi36tNCmjzH1Zt9fzXlY0ZhPdQRblQez1MJ4VBNXdqq3S
         L9cSOj85OdLyIoeKNz3ZKPeZ3nmEf5gAwTH5J+YWVnaGy38/uGoCrA18i+2ImoRT66ma
         BR3wKjs+mMNDexqA/Hmm3nOugi4HDpoFs/pWrn4jCROhV/bhYl1aAmZyOQuIjKcHG8jk
         aF6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679425641;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SmRuV3slV4UahTdDybzVo2CRivDqucnTA7QxiIR/P6s=;
        b=md70sJsLI/Gjhjaf2zB3LSgQv+zGKxB9WwzOFDe3jJJXWJJLSAH+Z2X+cDFhh9o/FK
         zOiy6jJSiNd+4+tx9dvzCH2aJVXi/bhP+ESEIevkwLpw5qkyJ9CJ4730HEkDyoxdQel5
         5xN3CJEPWXqQEGwY2gbvu1paCW7otDB/G8RKE49G4RF28A3uNpVcsR/fV6fzxXujn9xF
         uiBFdNWM9g43pC9oVBNaXYWP8Tdw2jQRpT3/IBntjUQEOEyy1fXE+81TyAwG1jVeV7tj
         frH/TpBkmxUQUwczaI/5LiDVA2I11vgGFIDYvji9CcIjZEVUaeH7n6EK0bgVv+7xGb86
         6xnA==
X-Gm-Message-State: AO0yUKW4l8IMJ42x7O23NV5xE/XZ/WI7dbFJGOsCa1ginRbTTAgUPd3g
	CVf50+Nzvo54VLYGTb1Fh1I=
X-Google-Smtp-Source: AK7set/UnVxVAXhUXY+Pa3r38OIB+QCEhdvRX2zqw277J9hbz+C2OfCQ3te/qUkM/renZyhySHpH0A==
X-Received: by 2002:a05:6a20:b056:b0:d8:161e:46 with SMTP id dx22-20020a056a20b05600b000d8161e0046mr2550056pzb.58.1679425641360;
        Tue, 21 Mar 2023 12:07:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k17-20020a63d111000000b004fbb4a55b64sm8344418pgg.86.2023.03.21.12.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 12:07:20 -0700 (PDT)
Message-ID: <395dce02-b59b-ced2-ef58-52fdf17b77a9@gmail.com>
Date: Tue, 21 Mar 2023 12:07:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/199] 6.1.21-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230321180747.474321236@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230321180747.474321236@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/21/23 11:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 18:07:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.21-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

