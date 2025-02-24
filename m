Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D922F26560E
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 17:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740419448; cv=none; b=ZfJYLgK9woAukVzKyfSKRs0FNypxLfKPtEZ0QgBKEyhFC3z3D/FBXI5Ysx47Wit4bZ+N3Vt5kVMJWIX/pzAPdEFZu7vtGRSoprRnxYRrSv3BjMHlkC+9YAhvX4njhiEWX9XlhQo1Ht4AbpHqYzrUoXH48So8bSHofX0pWeiKsrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740419448; c=relaxed/simple;
	bh=1sbYj9XJ/vBInBEsj2litIKHFYY+Vmr7AzT7wi0ndZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IVRYPJ1gtBcFzUJmlAMqVpDXXz9MWxxbW0iWMXkOAgc1vz3cKCjzkeN6gJmDG4ApH1FC7jQMyimWe433ic/paAkXfJEOwTAP7YbWhQjkEI7htEcmsKUcsX5AAiB9kKz6hrpZDWCWOD76JV2IgjBsn81A26SZJSCgQvreLAbAr/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kTXK7Y9n; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kTXK7Y9n"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2211cd4463cso94546555ad.2
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 09:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740419446; x=1741024246; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Yp717sg19PKK4Tm85Hy1FsWcO4NFeurovDRqfOf5A+k=;
        b=kTXK7Y9nnMIYQu0uELXAe6jDQBsumY1eCQqQLaLp5UzXrpToZd7Ma5BKzksXcE+7Uq
         +h++lindGBZ7PEAsJFbkfAYd8Q2pq0GOIbeeYNPLG+O+2k7pvLoZt2+5InDHzHzdYS/J
         3++K+2nItHxokQf17YykKynvUZjKnYgg4krcxC6A5TKvpGbthgExOCEiUAvin0MKL1kj
         nhIhi+bnjX+4HvEtmX085ptm8LEI5BuJVjIw6zCexnjAtawxVBTypHOmNSF5GoSYg3ca
         V3lS23RGX6Ek8eMbxCY3aFr6h4Er5OyrgVC5zZSCv+QpWUYj9KL73FtseYdvozgidD6F
         jvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740419446; x=1741024246;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yp717sg19PKK4Tm85Hy1FsWcO4NFeurovDRqfOf5A+k=;
        b=dRygo6nkfd56cB/BeAsAEfQr17aUznkIv8AJ5KUHM5ZDL/oXxbBPogqtfB+27E05/8
         RBxdKH0GA5DtHb2STNKJdhRtjhW1NDIPF/ripgokr+FkmedYGMBUUP2uP0ctFyx85k5u
         ZPNuQIYWk7PeDn57pHOB1XmENy3ZhtX7PGYLQosuLxk1kUiOxN4NvWbXDPt5vzFe1UmX
         lxy5bRssoVVlW8IfQWiKWDHe/kysFppTT5aP+tDQBdBz0g+FzZ6KAv3fimwp9QKfk+gS
         92IUEb0hD/Jl9V9ITMvRj/C4O9rwnRjz1hQDqCKMGcY+fpTltUZnYA6j+PAUEZqg6Nhk
         /Eag==
X-Gm-Message-State: AOJu0YwLQF6zdL2rRzZ9siVBq52DbbpKaPO4re8utVi0RZekIZdXDV9Q
	7P4/dh26xyROP9PmPk4Dtji6++Q9zGMafwRDiFlSHARg9AjUWtzu
X-Gm-Gg: ASbGncvORPtiLthTeWZp2tRgpsXqwu5TsSo+/EYspV+2G6q87w0jIOpkkPYpmLhldki
	Og2TVcvr93nKF3kFpCVntpzM8a9fk5pNMlN1faZ5di67AHfjIKDDRV5c1hgtqFdPiw/Jardu/ra
	sBM51ANZnpgy+kNmGineJwAJE9JN+d0n/2Mv4XrlvcTVF7FgtkKEE+Q7IlNzAL+1ktPUZmYzA5u
	xfcB5eD2x9rE4XyjMIWo1LwZPcEt82bfGQvibEQ48rIeWCPCFRCU9GpzbwcUAXGnS/pO0MXrnaX
	uHoSHE5SRMSWdVNfLgoJIiBZ9UkpeNXSxkc2EwH0pQ==
X-Google-Smtp-Source: AGHT+IF+KPtSkO9jy3XlavYWcIF/2z0hTytCieXYdePJ8OOYWLdbCw+hVPiNR/zsCMzYjSI96v1KdQ==
X-Received: by 2002:a05:6a00:854:b0:730:91fc:f9c4 with SMTP id d2e1a72fcca58-734791ab6f4mr164722b3a.24.1740419446037;
        Mon, 24 Feb 2025 09:50:46 -0800 (PST)
Received: from [192.168.99.86] ([216.14.52.203])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7326e02b1a8sm16793448b3a.97.2025.02.24.09.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 09:50:45 -0800 (PST)
Message-ID: <1368f7b0-996f-4690-876a-9923441bff28@gmail.com>
Date: Mon, 24 Feb 2025 09:50:43 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/140] 6.6.80-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250224142602.998423469@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/24/2025 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.80 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.80-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: FLorian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

