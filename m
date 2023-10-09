Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E5B1428B
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 22:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lTqnigdO"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5859b2eaa67so2727907a12.0
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 15:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696891732; x=1697496532; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q7VKEDJKM9mK6XMWRrXy/cci19BVhFbaDyUV9SYedmY=;
        b=lTqnigdOka1wXYvuw8DA6DaA9I9BlLrzx+SYDZQDMTTOBQPceMj57L1MOGqZaucr0A
         pD3uoFEd/Cnkl1r89hkwawcJE/yFuGgr6jkjCjTqph/+gzEZyOXtSweDvkZxWu39AF5Y
         ivC7qBXcpWMAUYDgbksl1dcfH+gAygw70WWbFZJcoZVwO7AF3bJ0zziLpQc5ZKKyB8jY
         GwWTCjAgKg98vK3fW9DaIkubcQHJpdW6MrQ2rNAsXIdfZxUVouq9Ws4K6VCB1ToEKlHS
         46t2zNEMqsBQVeRl6v06fAJd8dybtZyU5E/qA/StB1lCEdw/J1B2jsOGrFdRu8rwCM+n
         6FCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696891732; x=1697496532;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q7VKEDJKM9mK6XMWRrXy/cci19BVhFbaDyUV9SYedmY=;
        b=nfIUdqplGl1/AyK8pzeokDVgSXLg9CesPJ47q/JHx2aMdTAuGs3Z9KFfEkTXKaBDkj
         c8MDa2bvihBavi64FZNuAwDldhJ2LsyTor21nIuogPGojWTxs+PLI36aMqs55lpvBrdH
         vvhKYXjkDwfxs0AGRNyN2iGad6vwyz6JrkYsnDJKSe5WV7Ven3fJ26vzc3xbrQ221gAj
         E5594ilHHoIQYxTVTid+6JrWkVRTO1QW/pftGieZmVyN/PvTa3jWArK/LWSny5ywaar/
         IzlthMjt+nRwPXbCxfTOyAJYN5yIns+jGX1wECy+pq9ZybgdyGWWGmeaKR4HXJnr22Uo
         ujjw==
X-Gm-Message-State: AOJu0Yz456RNG3oZqPPIalwOLUn9LIOBfMLUd2JmP2AvgPLdDlZ6xFtS
	QhH4HKnkJI5iaGHyP96li6Q=
X-Google-Smtp-Source: AGHT+IGKZ0PJdN2LNmFwDtzYbFcGrW8ZWUBGyRN5eRv/pSoWmyF5A7jrsXidpX18xJF3bjn1sF21qA==
X-Received: by 2002:a17:90b:3911:b0:268:5431:f2a7 with SMTP id ob17-20020a17090b391100b002685431f2a7mr14535964pjb.28.1696891732188;
        Mon, 09 Oct 2023 15:48:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id dw4-20020a17090b094400b0027768cd88d7sm6985811pjb.1.2023.10.09.15.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 15:48:51 -0700 (PDT)
Message-ID: <75252507-62ba-4209-baa4-447517cb37d7@gmail.com>
Date: Mon, 9 Oct 2023 15:48:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/75] 5.15.135-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231009130111.200710898@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/23 06:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.135 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.135-rc1.gz
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

