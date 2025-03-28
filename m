Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA5C1DFDB4
	for <patches@lists.linux.dev>; Fri, 28 Mar 2025 18:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743187299; cv=none; b=ajkfNHgPoZxZap7PMP1Ggxn1bbuUbG4bo+/nCaTAUVLXr9rQFG2KVK0FHNlOJYheE+Q675Fb+mVV8zQesKQf2PwV2lFS8IfEoWpsrJw4+wamkvjEbVqbnxL57hqNXoyMJs1b2ukjIR3NvIHekagCOWoRPrevRJvfwj5sVqzXp0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743187299; c=relaxed/simple;
	bh=nBBmE2RxZp6NIWrtD2YR+UuEN4LSkgNN4JCokPTjVyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y5r6kV4ODbLdEaY5TuwAsX7TZ1dS/SSi+m6Hbdcoa7cT9sztbkKzZNpBEyRT4xLTbJupGAByPX3JLB4GMWNc185hJmxDhQhI5n3dlFH7lNnLgJkHloDo9j1LCRsezXCMWmTr+7zCJV76HEUaysWnhfDcOoSm/eVZOh9wSTSdpTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fi+Uwy+o; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fi+Uwy+o"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-602513d2201so1203670eaf.0
        for <patches@lists.linux.dev>; Fri, 28 Mar 2025 11:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743187296; x=1743792096; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=G9o9kMhE5UdbSc+QmWRC0lyBqoo7YvUBLbl8Fqh4Iqk=;
        b=Fi+Uwy+o5m40KF/OzKdBa8ENylDmemLwnTcMbFkJLUZ/g6OgQOQtHfVzJNSHpMnt8o
         Iv9RqC1gxS1laqcdxKFozd/q+CANCdKFxuMnsFdeqM4aFmWrPmbTi+iVXhKSaSLOGHFv
         EGTDWe/rVGTIAx2yYXSa3BwDtC35Zd0lrEXMIN6Sclc/WiEbL5Q1TQCu/00AD2Bd8WzW
         Mt4BIhkNMwcuyoBaTyvxJ938UKztrWjaoFTVH3JEwj31bonJy01W+4vVSzPK53d3WV2o
         FQTDdAXuatWf765hvcvJEjMMu02jeHOTvF3+gD/BloFcUPrcJPVqfz6HSmfPgDynOqSJ
         fjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743187296; x=1743792096;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G9o9kMhE5UdbSc+QmWRC0lyBqoo7YvUBLbl8Fqh4Iqk=;
        b=Jpdal4KZxCoqahBqU2d09IzlOlWy1Jbb43d1MfdBgyaRS7N+9x5pBTuy7JrREfPoJg
         6bjuj8Z4HNbv8yTFBSXya86pN9abfKmP5UthzQuL4wc7Ogw4D30iyuVSovLFQTc6bRFU
         J4uG+JAwdg/HZvneXCEtdRAXAHl1hQuW5JvJiPsZxZArq+Z4xXdj+T2ZgrqYlMEb5itA
         cL17SES1Rg+o+IwFWHUT+yeCasOgbth3HlQcTKJSHP5NGkElxnPLgxBw7CYUp8XJ+17K
         Q0sIVVkv3mqbs2IDejBsAnUNx0tV8xCp4KM9jNGbqrxGfW0tRAkY2sK/2Iftq0Dtd4AA
         Dwcg==
X-Gm-Message-State: AOJu0YxBNSv3waLKRvVRw6pYFpINz2KHrJAuaXyWixZEvXyofXbpG3gC
	6ueDyA8yBhCVTakYywcW4OSV75j+ToO3l8beIv7rQqU1AhKCHl8s
X-Gm-Gg: ASbGncvvC1gEKcPJcr6Z2ftjJajDwbloWTLiI2UbdxPKcebYDoNxqVctJmSWTb5keDe
	GLqN6nVB6qPyZSRPiG3YVCbHiH7vGri/hdMYHAuz3Pxy1sypP6g8NdBBcUF9fLtwG/vhql7iAUZ
	5PG811dhCohHQvzRDuMrTx4P/V18+vMzWBObRe/P5VhHM2/1EiZml71tOQdknG0TaUdhujLRqEg
	p5dfgtMQiNdR3VTFeNv7wHjfJ+v0T1zU6B2A++lZ5lgLCOiw3EUfv5zQAB5FC4sE8p1BHYjG2Ms
	8+mf9+7/evuzTLnKdPf0P26MMVoAectOoHiYT+LoYKycp9Nl/2ccdcCMxRUNtjE0qTJSzgDsOAq
	9wPosLzs=
X-Google-Smtp-Source: AGHT+IHvm2PyJiKouM80BtF5bu0WNeH59ysoYWD31c4Uw8WAwJtKaeV0ODNDDYa74l3xVxtyirZs7Q==
X-Received: by 2002:a05:6808:13d3:b0:3f6:6d32:bdb4 with SMTP id 5614622812f47-3ff0f5b4178mr212821b6e.24.1743187296477;
        Fri, 28 Mar 2025 11:41:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3ff0516733csm429759b6e.2.2025.03.28.11.41.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Mar 2025 11:41:35 -0700 (PDT)
Message-ID: <32ec9d16-ad39-41e3-a505-640025ecc92e@gmail.com>
Date: Fri, 28 Mar 2025 11:41:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250328074420.301061796@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250328074420.301061796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/25 00:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.132 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Mar 2025 07:43:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
