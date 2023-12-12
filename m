Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBDD5D494
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 16:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hE8vkxON"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-35d559a71d8so3098265ab.1
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 08:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1702397852; x=1703002652; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mZZsDTMwulx2C3PHKVWLrfVDevlLtMgvyrHa2kD2onU=;
        b=hE8vkxONnFQIBz9REWk69Zd4l2slJXzic0ojISNIvGDqljxR43INAd3zCet9S9CFVI
         llBWKgQyhR1xRxlygamETJO8Nx8cFx1WhBrti+JDq9iFG5t5RGaNLOxd1cMi6eXBroAg
         zAmJiQNBP6CSuQ8gtocyUGAM9VMVQ634bz/fw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702397852; x=1703002652;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mZZsDTMwulx2C3PHKVWLrfVDevlLtMgvyrHa2kD2onU=;
        b=Co3auEspDOwCz4L9T8xN6vueCCinITNZzXAoAiEbOIjbBTThA8ENcKYuqf/nPdNrLy
         98Lki+/M7MBQDNgbCJa20lbCIdkkwSLw4PNqgmn7Vlwq/my2/YB8nwY7v61WLk9XgBv6
         0jydvk4QrXGjM84UfEqJFECCPXfu6UnyaLm4YSmFDzdKeI5kfML6yf5W4+ESr8e65NN7
         wRjFgSF5kOthaS7a6vMb/cL6vdLc9hsZmoXInpAZaeHaLuuNlfKr0acT8PPJzeVgwtmE
         tMaEutMtlL4/sXQczk1VNYoXzPoP0a7+1wt253D7QQ2UTNbRWDtu84yvtiskozofQAGP
         3c7Q==
X-Gm-Message-State: AOJu0Yxn3JPPQneG/XhbhZ1tEToeslwVaex9EeShOstxGer28DJ65FEa
	jgzhLsCj+LCq56kuRN0dwq5mqg==
X-Google-Smtp-Source: AGHT+IEw06m80JBwgXxznxRucxWd2rsVfnN7r+g4/CDkw9yYXOxydY/mOkQq1kN0lweotU7cVET3yA==
X-Received: by 2002:a05:6e02:17c8:b0:35d:5550:76b7 with SMTP id z8-20020a056e0217c800b0035d555076b7mr12405452ilu.0.1702397852518;
        Tue, 12 Dec 2023 08:17:32 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id by4-20020a056e02260400b0035cb9b85123sm3014243ilb.46.2023.12.12.08.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 08:17:32 -0800 (PST)
Message-ID: <a716de20-d5fa-40c0-bb11-e34c1034d2eb@linuxfoundation.org>
Date: Tue, 12 Dec 2023 09:17:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/131] 5.10.203-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20231205183249.651714114@linuxfoundation.org>
 <fa221062-03b4-46d7-8708-9d3ce49961dd@linuxfoundation.org>
 <2023120932-revolver-apple-d4c9@gregkh>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <2023120932-revolver-apple-d4c9@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/23 04:44, Greg Kroah-Hartman wrote:
> On Wed, Dec 06, 2023 at 09:31:48AM -0700, Shuah Khan wrote:
>> On 12/5/23 12:22, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.10.203 release.
>>> There are 131 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.203-rc3.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Compiled. Fails to boot up. Boot hangs during systemd init sequence.
>> I am debugging this and will update you.
> 
> Anything come of this?
> 

Still working on it. I upgraded distro on my system which is complicating
things. Not sure if this is related distro upgrade or not. I suspect it
is distro related since 5.10.202 which booted just fine prior to distro
upgrade is behaving the same way.

For now ignore this and I will update you.

thanks,
-- Shuah

