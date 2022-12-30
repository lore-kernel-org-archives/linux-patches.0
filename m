Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26ADB46AE
	for <patches@lists.linux.dev>; Fri, 30 Dec 2022 20:58:20 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id ge16so19796638pjb.5
        for <patches@lists.linux.dev>; Fri, 30 Dec 2022 12:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A5HECF9+rVuUX+brSXubDgLVHbeqG015MmzEZ9FF8VE=;
        b=cSpq2X/PC9hjQIhn7TixPaxyLrIj2Echgf4Uompnm8LQwp9Xgo0+CSaK9/Sr/KXeJk
         mOtg8BP7ddm/QCWE7JpxN3LP9Aqg5QzZVdGjnEYCW8wx32yseo85V5xV92i5ZvItDK2I
         BfJVJkugU5z5I5OwKSA4dTR4rDLQjkw5mXhHAeqR1DLPATG9p8qVNS77vVFnkO06SMeJ
         BgvnScHLQWSBIGL4Zfyph+eosR5jG+mOVn7GQuqPug6mrisNZDAOT0k2mx0Z2h1GfKbk
         mI50xA2ykj84l2ZLzvjokG/uctzKIMfU8vI8kH3aXCrZ8NajkaxLNW2UONZZpeniHUsw
         LNfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A5HECF9+rVuUX+brSXubDgLVHbeqG015MmzEZ9FF8VE=;
        b=mPBs6nuEd3s1FwczkNuYcPtNFyrJ3bjiioFgagWE/RNVQkLGNVaWrEv3ri23VkTN8X
         pKHeVcUYh6N1pJiyZwbeN+FMDblKKJyZJTyXPwlohKdbwOeyXzWwwSWqHY65j3CJm0EX
         uVEgp3zGQJA3whFpQh89EiQIcXWK4qL5K6BVYTdJBJpYCofWo/h8hU/uFd86cCyxCNFG
         hj7Es/WCbkaVxR921ehnSxMM5hbTzLxu2ucoNZ/lCpkribwLeQdbwVTF7dyvwLWXwRe4
         IrO0mEuXXuZYuY2GIrMdOhg423mB+OTxP4EPiXa6AQBYzBPi3gaqKajElQdNTTUl2Z20
         SKRg==
X-Gm-Message-State: AFqh2kp56Y9MbVuvBpxTdfnBkxAbsInca218vxIPZWtkz466ayQLskFW
	Byqg8Z6K8X/rY/z8OhW5oun11CN/eBZy5MGOsPM=
X-Google-Smtp-Source: AMrXdXs//T30asV4CVfSzhXj0gdwFo0Wu17EEcoS58I75cZvc0GcWON/DNDt1cGUFxotQ/fqO0EJG5T+Q1wMc6L5HFA=
X-Received: by 2002:a17:90a:fd03:b0:219:d32a:ef96 with SMTP id
 cv3-20020a17090afd0300b00219d32aef96mr2717571pjb.12.1672433899545; Fri, 30
 Dec 2022 12:58:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221230094059.698032393@linuxfoundation.org>
In-Reply-To: <20221230094059.698032393@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 30 Dec 2022 12:58:08 -0800
Message-ID: <CAJq+SaATrjeJrBnqT9uR=i3OzmsPnYuvSvnv1N8cbaVDRN2djw@mail.gmail.com>
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.16-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and boot tested on my x86 and arm64 test systems.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
