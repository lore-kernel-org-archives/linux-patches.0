Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE35323E
	for <patches@lists.linux.dev>; Mon,  5 Jun 2023 20:38:47 +0000 (UTC)
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-3f829e958bdso49920381cf.3
        for <patches@lists.linux.dev>; Mon, 05 Jun 2023 13:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685997526; x=1688589526;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tBzUGtWYUz/h/GEtZLWVJ9w7DC65D2cvEG+PU1++rdk=;
        b=GiYGyKA/2hN1rkG7MtNWRc4nL1bnZ7G8u+iQG2a1SvNE64Q9yKIMAmVeLgV0Qx2ByW
         OrZ0XpvL45XOMZzfDajXu+uW9HdrRURuiRaEdz/rlp0t/TkUbAhrp7uk2JlLtoZb8USQ
         sntoMWGDApTL8H799RGcSw9+tYHQlEWUc67Cb/svn/UNiAjuCk/Bxz6qjnFV8yg5o24r
         uFhUTJDN04dJUnEschdXrtLF9LV2xpDskausF+trh7tPHOO6h9LenJ8mOJU8Dmm5kdAS
         MNGV5FiXMxtLGJeRIvRfMSj0ZaUVjJzUT6cTKtHKlGVpUqRd4SNt/FDqFhH5WEI5ApF6
         QogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685997526; x=1688589526;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tBzUGtWYUz/h/GEtZLWVJ9w7DC65D2cvEG+PU1++rdk=;
        b=cwrJVMV/xTsaiLSNnr4hAMSJqfIAfRrU48Ct3mHOabFdz0T8Z9+OVcy3d2XcYV47Sl
         GKBEb5tmIp4sUIjcOu6sv12wzl1dKNe1b1B0/Uelpar9p7ldTFUw2gKlF2h0Pc/OlLWE
         tSoIjzdck27rCPWhZZtEP4Kg+z1nKEqhA4QbFOGSEcJEDIeh94SBMTcxi0/h+cXRHHe6
         3FH4C53BGmaNbkaPVm9BAeVsQOBvgoak4L7P/ZoG5j9DIBgDgdSg5oddPLnc1VyfIloV
         KGYOztH2VCJu4KYq40me0f9vYdDdkxSq54K7N3Yu0rjK1hOeJ3z/WJpepJqxybUYWAFn
         kNzA==
X-Gm-Message-State: AC+VfDx4JCjhbrnPG+vteTvyApWbmrvqMKZ/t2bFNnGUMBVbJrT4hvKO
	So7dY7yYYznj0GrOk80bdqU=
X-Google-Smtp-Source: ACHHUZ72TxA5rtCZJe9S6Nu0SPOvnqmAh41OVTEXtwof33pAaD38MPlQwbZ5A/HVVMrDpdVBbJnpww==
X-Received: by 2002:a05:622a:1055:b0:3f6:aff0:6dfd with SMTP id f21-20020a05622a105500b003f6aff06dfdmr9548580qte.32.1685997526080;
        Mon, 05 Jun 2023 13:38:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f10-20020ac8068a000000b003eabcc29132sm4986051qth.29.2023.06.05.13.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 13:38:45 -0700 (PDT)
Message-ID: <6f75392b-7cef-3595-5422-1aa00384dab3@gmail.com>
Date: Mon, 5 Jun 2023 13:38:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 00/35] 5.15.115-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230603143543.855276091@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230603143543.855276091@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/3/23 07:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.115 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 05 Jun 2023 14:35:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.115-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

