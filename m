Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812BC241FF
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G4lFRKCi"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6c32a20d5dbso3715512b3a.1
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 10:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699294186; x=1699898986; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=neBbBkCbikRraB0nQmFPavVUC9R8TAdKlPMHdSdzNw0=;
        b=G4lFRKCiITf7I6KX9iDYwscIuND9aKuXYjU4TSw8SY8JHOVOfLfOHXcwsZ5sodyQ7G
         EjdifBqyd+Qp/DUSxUt1lofSvJT4wA6xWP9XKaQrIGz1Ml2NNtO6cLLSALUZGYy9XJGN
         7G4SLOc/zxYJbl4YwOwJusX1Ddo8uFPdCliJSam9YX392ZfZ38BD3dC6LXLZggepbrXR
         xxIu/bJxiBi6ANLPVOJPMQu0XWctIYlaoJQFMeawi4gGMNmyC9r0dC8oUP6ZhOkGryu5
         tmED48UnN5ZEOGerTXIp2z2ZOogS5j3PAueataDX+CDxTJqKuMJZpzcAAM8iFRqxF3Ku
         oJbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699294186; x=1699898986;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=neBbBkCbikRraB0nQmFPavVUC9R8TAdKlPMHdSdzNw0=;
        b=Iedt4erEAc8lT0NBOOFaxRJpHCRpmd6zi6EctMtNKKfcFy+yXYmwyel1u73GGova/A
         +urYJdvXKbdd4UOHbKFxZCTTkPenaFeFED9sq0yaXKe9Wfc5CbwCBDwgR8PQWbPWqrSh
         DTGi0JWGtINNPqbiH/m2FP0tpVVZu8oSJ49f4cdACyLSuh9XuKGDoapHsKYAtT2Lccw9
         qeOZr0BtFwyCY4WE6cR02p4T6eRix6xm7ikvlyY1o0yiGNHcvsI6hFckEvUCOgfoNFia
         xHJkNtBmTgqoZgnNHYoyaAXsZwOUec+HrKBXIHGlQJwoODjTsyAzQFui3BwoAGWc54TG
         +OYg==
X-Gm-Message-State: AOJu0Yz9AtI+ZTDk0rBYOnaQrzx3YEQ4U3IddwpGfUpxC+wcL/dHt0I/
	Sn6RvhBi7tGSRh4BVXZpvFI=
X-Google-Smtp-Source: AGHT+IH3ttiaL+UUmdWm09Np2ElUm26SZPhFEDb3REd7EVTtMMkwUQYDp2QiWdEBTKh1EUnnDWq4rA==
X-Received: by 2002:a05:6a21:a58d:b0:16e:ab42:9837 with SMTP id gd13-20020a056a21a58d00b0016eab429837mr32603706pzc.29.1699294185720;
        Mon, 06 Nov 2023 10:09:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f5-20020a056a00238500b006926e3dc2besm5868722pfc.108.2023.11.06.10.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 10:09:44 -0800 (PST)
Message-ID: <eee1e8a6-ed8d-4667-a2a9-18fb2a636a90@gmail.com>
Date: Mon, 6 Nov 2023 10:09:42 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 00/88] 6.5.11-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231106130305.772449722@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/23 05:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.11 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
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

