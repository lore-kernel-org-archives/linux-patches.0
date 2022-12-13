Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45075748C
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 18:07:37 +0000 (UTC)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-3b56782b3f6so203444187b3.13
        for <patches@lists.linux.dev>; Tue, 13 Dec 2022 10:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C89klaJYnYqVPt72HuSAj6C0KHKkDw4EdmizFmt/dYY=;
        b=QZNinhaUVjRgKa73IrmjBKG7NReEZV4m1uchhSGuGYFpetecMcx2J9lCjlWLDAwvQ1
         INXFmcEVYPOKVf8frp0GI1qjR/ASnDRpo8UOHOH9oNXMocDdLrJTy823WkqwC20ZEmcP
         KYN85fSzWc0odgZKO+Q/GfjFozhdK4nAHZmEu1TUAfmF3Ee86372btH/So7Eozz6ZXRu
         X7XWaLv6BrJhOj0HbznsJMBTkLQaKbil8j9Lizoqtzl7yzLHFOzvpTDAP16bODKTuC3r
         jJQgmfEzzpVEx68JVA5aqKKnPOwN7DTmuAAU1of8eWa3cZCOx3aBiAFn9+TZRmDZjn9B
         Xa6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C89klaJYnYqVPt72HuSAj6C0KHKkDw4EdmizFmt/dYY=;
        b=4dHzE25XR1B7FDK0TEOMrhx9JjmU5cvBdmmmLbAG+yCit/Ms5o4V07nPF+/Fvz69Sp
         cdo+tcLdcpsvDEKjQG4HrFG8S/pgb8XgDDl7FtAD2SQC/sgeNpwYHnoCso3K605rG/9e
         ehqHl+LPBQ2BzvaCNm45Ks+zzcIlaxLaNRCueIlOL0UVFgEO0zCI1Qf49DEWsz4rn7MS
         dg+vNRJ31sZCM16Ch/AjU2j8U0xM9pLJbwypgUu+j5nW9c9Zo4HrkuWQPSWVaSYeS44A
         UIGiqlnPXNdOM/EhyWtU6RudfNnb+s06M2K28iTU66aLXS1egUMsMmEBeo11XUfyLgSb
         zK3w==
X-Gm-Message-State: ANoB5plsYk6jzeYFFcAuDUhBEfjT2qDnxza1uZK7LdfyaGVxDlEcKumm
	f7mbInhiJGZZ3L2UsY1ANcQ=
X-Google-Smtp-Source: AA0mqf6ZOKTYxzndQpxZP3egcIfH1WZvDNMa8114teS8rzLykaNhY1IS/MMVtWXYhlkxmUih4iBQEQ==
X-Received: by 2002:a05:7500:2c0d:b0:ea:3678:ead5 with SMTP id ep13-20020a0575002c0d00b000ea3678ead5mr2180795gab.0.1670954856032;
        Tue, 13 Dec 2022 10:07:36 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i8-20020a05620a404800b006feea093006sm8382944qko.124.2022.12.13.10.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 10:07:35 -0800 (PST)
Message-ID: <87f7c713-3dae-daa2-d72a-3df8f77a614d@gmail.com>
Date: Tue, 13 Dec 2022 10:07:31 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/98] 5.10.159-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221213150409.357752716@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221213150409.357752716@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/22 07:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Dec 2022 15:03:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.159-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

