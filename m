Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE611DE2BB
	for <patches@lists.linux.dev>; Mon, 10 Mar 2025 19:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741636692; cv=none; b=ABlgIRHw+63ARUcJmQRnWQYkEo0rlv/3pyuh5ife4AvNKHW/vRaoGUBo0zyAv6ve8+00DRGYi55wbhwsu5DxYcDhNag/KYjTrnwcjwXyEcTYLO/IB+5Fj5TIdz3wFHXHSwUDPX9Oetpx+8uws+IdLZPl5Ms4H5GvqFkRNfrYcrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741636692; c=relaxed/simple;
	bh=Uwt2HcHeYuXl07ByeuBJJmznqQ5B2Mc8QdjkAV/iJpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bHxolGG+qmnZOhLxcTTImyu2mV3oZji53kqaAFT9Hb/JEIigrLQLMJT/WE9x9rtYYydX+oQxzzp6kwUEi7VeEWm32yZd5rsh2IBuT5vXgixdGaanpH923q+t818aiWJaBENLU38tPirl5shNNeR1o8Le8I92be1IDmshvZzjqp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jRwnNiDl; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jRwnNiDl"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-2c12b7af278so2761455fac.0
        for <patches@lists.linux.dev>; Mon, 10 Mar 2025 12:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741636688; x=1742241488; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=F8q7Q57w3E8EmZnIar1nUonYbaq0MfF2pBQagYJWkKs=;
        b=jRwnNiDlgk8tDsElk8anYTXt47+6STPKcM4L4Z7iJbtwq7fRyZU76cCoIuN1mvGM1W
         yOpDovC+zgV3Her+R3w6tElOFt/GA71FO4+iUIDq3GJST7950RBmuPzD1DM83gUgVKk5
         eQmaUzxxYRPUz4inVr13ZtIMx2yVNusY0Cq1oGBlIcMVfqNdJYdYWCNEV1xrtMHEmLge
         7oNLdTj3u+GCAxWh961nbJWSPKtabsflMYzB6h3/iMXow3Vrm7qw9me2MD+++VrXZ1Sk
         leSLau31+4PrrDFiz3kzpWU3gi71kKqlQStjnuZxP7Kp0cclOaObDpGVY3SI+R1vd9Nh
         bqiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741636688; x=1742241488;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F8q7Q57w3E8EmZnIar1nUonYbaq0MfF2pBQagYJWkKs=;
        b=aDeevcpwU229n7T6cDWzUnRQYD6j5ztRnVA048siOV9WlCxMvDUBM588Hf4N7b7NbY
         Lpsaz+prqLKafs9aXfWIAiH6eKnL9SF8jDuPc+QxN4B+RBMagq5pV4IsS6VrITh+lOd0
         d6wzy/VjL27553kiUIi7OqKhjpFiQCPJJCfwZmD5FD1C4nxJClT2Go2qSFmIrfFR1pl6
         rUjn+bl875Z0dCPYMMddydMZx4q5HJdtu0F43PniaYtx6MZjoD6pcAFrQt2cpJOUOtVH
         cBYiE/XZNK8wzOBPLxW3F1zpWZJNhsq9OQT4CYFETVfNYIN7I8xfT0QVvcu8/G4iO9id
         +vTQ==
X-Gm-Message-State: AOJu0YwXstKlFhSeXb12uPlmHAq0KjPdPd+qyfWsASE34tT0TmAMdPeu
	ZpbELRu4kvdgpRxbbID6MRh/oiB7CjSVtykBaxZqjt9DTlT3qK2A
X-Gm-Gg: ASbGncspWxwlvbkeUH9xlPgMHPEHL/Z+Mi/XWgVPKfwAtHsNtUt/efsNf7hFtYJBjAk
	6FYWsxmC9P9fQNIedwvAPBN1C2PFog9FWDgu7Dokq5JCcqrPpW+Y1F0NSE5TpWOTTBE53JcMygJ
	9Bo389tFt/sIHua4JtJQZksM55Kv+BGaIZV2sz8zOye3i/UvkeDdcfWyoqjloAEy5iaZ+NH6oiC
	Sh/oMGZsCBW3g5xjDrArJmzA5VNAtJhFr6uE+ebyq5/YQQgwVcAWsBHp9LrAZOgeAFLTW80Tf7p
	tZz3n8JdEXyzPb7FaXLpJCqn5lNYizNKsWBLAT4nA9PwcCN/sqj64TyQCP3SguxcTCVWC64n
X-Google-Smtp-Source: AGHT+IGPkBDfscjixObDGict643PDpoKVH4Q2VSB/PRUhcncZXP3lKsubEw4TBfYr302pWA+GFV6rA==
X-Received: by 2002:a05:6870:611f:b0:2b1:db0e:e22d with SMTP id 586e51a60fabf-2c2e8ebe26bmr512522fac.0.1741636688174;
        Mon, 10 Mar 2025 12:58:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2c248834c74sm2278037fac.3.2025.03.10.12.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 12:58:07 -0700 (PDT)
Message-ID: <5ec34abf-9e06-400e-b822-cc5e61a2ee4c@gmail.com>
Date: Mon, 10 Mar 2025 12:58:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/269] 6.12.19-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250310170457.700086763@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/25 10:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.19 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
