Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B291D254AEE
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 22:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744152172; cv=none; b=gK2syfS44bP/rKIQp/ks08xPflzWjzTcEGQlxkCb58FGWqL6PJuXgaucPUwJmmWA8O/6jRYYqq0yUu+HAOhTczUlZkhcxZZXfJPc2xNgNaFCZicegJxOb0pRErONQgHYZcrv+5nElxzYmHjEo0U2Ntt9eQVm8Ha0OFHFnUsvfdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744152172; c=relaxed/simple;
	bh=MMGyFU0ai24R96XUwEZvzI7AeGg0t6okiIIxZ7vICuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sQTHjh1dXIoj1zS30Hel1mrDKtgA80daHaGAoYnsSR8ib2Oh2ylr0l9SBYyWSP+tLIbWuravyw6Uaf+hVN3MkFHupNlwJ0jj7jyLOQn2Me2zAFMGlt1LRWPavH9FpEfI8WoJBncExjbNiQtprqLPtaqOJ8OA1k/8n44xH91er6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L+Xlvper; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L+Xlvper"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-601f3674116so1653935eaf.2
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 15:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744152169; x=1744756969; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jC2t8OsWOeSzLz0xuFwhCnvAxOOMlUaiN6NqG4eYHEw=;
        b=L+Xlvper1XHZlN3dfTWoZvCDJdFhIdP38YGERAa3a1HPHyif2/CLoF2nUubFundEgO
         QPSHOyR3PdrW95Xz00Ez3C3kEQdQHKGlattZcAd2P2pzcafYJSWNf0FxisULIQtxyDCa
         p9GfM01c5lM8rGCRYy9OnIY5oH/zMDBxBlajKo/QIuGZ49D5WjvBqG43w2NJ6650RJDz
         Lji6GpqlfSaVknVyKIf3YrER8o1Ut3Qk76WNrEmXwniHTE7h0VGxceshLgNrYKZbZPv2
         P0VgS+Vh4YH9oYreE0x+C72n/XZOjVxdyh8inVsjmci2SAWu++P7qMEtyWlkF+FYxRSw
         xmDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744152169; x=1744756969;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jC2t8OsWOeSzLz0xuFwhCnvAxOOMlUaiN6NqG4eYHEw=;
        b=qZGSfatgoOnRxVx+wRum+rmuasjp1LdxyRkoNIjvv/F81Fct5eNi+i0bKldjP9Fm2S
         1RiXtFDPqxXRlPf1WtpUfXgiN5zCVQF0b3crj4Vq8DhnAF/QiXQ9tfd2F4DCGnKNXqPP
         7Tze26X1aqTCz9ZkIolcHKdVLl2D9B4K2iId7cJpLzsyOVxYC1mQH+GJI4j4gkiCkW7t
         pSzxEGXieKOU62kzXLbD/fwHTPoG0FB778n7AlMFHGGdhTj9uIegRtKcEZw1U90IIPQz
         YR18brfimI7K0th6sTsasBcmGXnzLom5Dk9SSlLBHFA1ZO3Se2euaGyOVNUH6W0pnK0m
         iV7Q==
X-Gm-Message-State: AOJu0YzVrPiAALM2n6QdqfWVwXE6YxHBlmo3aq76Aplf7kcDTCTPpW2F
	V+F4fd3BMneQ9xcb3syEkfkTOtsnGidEa1wp+CaovS2SSJewd8c4
X-Gm-Gg: ASbGncuAWCdHxc2hLjjCm4SGxEdY9qfK437CqEjmdNJXjUmFOSHJINRlUBidxWbnCxG
	IUGYP8+YWO7B9PJ63u8erpwXI91wFcuk6RbxCTaMga5R9YEAb3C/g99n9NyT8QUbJBcaLRK9dGE
	iMts4XElZ71hUYh9/pf8BV9+dBnrqiyUNKNZM6wz1/ifEOBFEvRa/8csiJc+G/VVfYAmozsjYXB
	TeAQ6+1goy67sQ43BugyI8cPWlbwczVyvmHYqHC+tYlZt6aomOsDGfolNP1Pk/b0kEGyNT6nvll
	MBcDUMPfo1dIkcy+dVDxzSld6tZesm10PiGXZP4JVvGzt+o1EiH+/Ph1aIim3lm8QvhF2aji
X-Google-Smtp-Source: AGHT+IH3fGo7fEnnX1/uos1Q9JygvkVOfmqlmjmpV6JzDUYYBb7akW9C+GUHLtLthwCeqF9qLNhXig==
X-Received: by 2002:a05:6871:aa11:b0:2c7:6f57:3645 with SMTP id 586e51a60fabf-2d08dde79e5mr430138fac.18.1744152169494;
        Tue, 08 Apr 2025 15:42:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2d0930cefa3sm20333fac.14.2025.04.08.15.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 15:42:48 -0700 (PDT)
Message-ID: <82d02940-cce1-4cf5-874c-cc998e151b66@gmail.com>
Date: Tue, 8 Apr 2025 15:42:46 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/423] 6.12.23-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408154121.378213016@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250408154121.378213016@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 08:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.23 release.
> There are 423 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 15:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.23-rc2.gz
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
