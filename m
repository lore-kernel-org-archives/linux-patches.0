Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860753D6A
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 18:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737485829; cv=none; b=BMPvssCeu0GX5s8MtdiNZZ5Qc1/iy5SoWnHgKDiG+74swtR5PFNoIWiWoBZI0ZkGBcXSHkG7KvcEaD0xWrbohvk+hIX/wslQ7IDv9wZbmlU6LBikJ8BvJie6H+ap6kU3+aX6GokEzgR/FNIv5jK1wZ+viE3PIAvnmkRlc0LqWqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737485829; c=relaxed/simple;
	bh=Tvw4fZSWyLzSnzvpIl7iBrKkMCoVkohH68kYuAM5wjc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dpyjzbTBD9VKI0BVc4FYUqj+wwAZ5iu7Cs/F4Ez0GFrxlBH6J/vj1V7wSMnPtgExrvUJSmFFRv47ByOpOCOfg2cRsCFCsos2vT5VkgjLJBOPbyRARwFSqLNI2vxpfNoYceJ6mkdsDhUFSY5pADEhDGhuPO4NUK9zJGkFJHIefnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lpbhv+H6; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lpbhv+H6"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3eba583fbe8so1801850b6e.3
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 10:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737485826; x=1738090626; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eC+WpwSNPwGjygQ8OK50SRTra6qeZjZzzhr3vyFEbt4=;
        b=Lpbhv+H6wDVXHQXt4h8Ihpn+KR3xHKTOu4J9ZkvgZublLFtgr5eArVn9FGhSwHsBeH
         u4mGqOjvq9uD+YaPO2qKd3745RC+fjzi94OTv3XeA+aIO2HY0yqCgraoX5dUxQbTWTAe
         wTbuK2g+r7e5AcFYuyC2tGlI3fXWuRvIqbkr3dmKh1U/XQ5KmbiiU6q9T5nfrUDr+v1e
         B975qu4cGTvqTyfibGdaTgaLdmitULr/XZ+y161QEZtNDFcL/w2sqbPzYNoa+t3zGSwH
         gMzN6jwbnYGGjc3pc8rNCN1yp2d4pBCmVk2sdubJIVx70uBwpKzRIANPD3tJhXB7YCOx
         9cCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737485826; x=1738090626;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eC+WpwSNPwGjygQ8OK50SRTra6qeZjZzzhr3vyFEbt4=;
        b=XiBHk0woQOYOkBpIdzzA6BddhS49POrsyIHHXNaXp4bhrmzHnceihO+XDn1ornhZSA
         zpR7g9zPQmCN8s3WTrZ+8a58t+nMry9NiEFGhhH/TTkVaYeyTVQIUKKjMZ8Pfb7xeysy
         ecAB1RvINxTmQ+iIeyTW9Snl/RjN0WsOKcF5DVOsjVz1x6g6bAB9CtCs2ZY99gO3mWfI
         Oi/WLXJIITg6ugofcPva2vPPyMnrkyyUep4nfgFR8IzSUcTZiRudytIzwsAWKlwypPco
         Afj2fakPt6KqN418qi0/jWrtcqPM593nEQdCf1shTvRiJVzrkQlOItNeF+CTNW7KG79Y
         9nPw==
X-Gm-Message-State: AOJu0YwUxDf4YWgF7MMmHYp3p4b9+gTylH5mU+hG0c94GqgX06x63b/Z
	NH2tgQephXnMnIYrpLisJktoXudqIFTFQD5r0bjz7u+7fISixCvp
X-Gm-Gg: ASbGncu9s/tP7Rs4/IdOLPS+h1TIwVz/yh6XKswow6nWXydQgPvJQPyI7wfXX0jEZco
	AfhyhKC3u/fNCTt3Ho1Cmb1BkPtbYVWr1Un68uF5zlc3D1WEFbkZ0L6e8mGLC9BAh/4wdcTq0FF
	pMW0wn+VUpKS+Nr7EqvrD1p6LTe+mWM3ZZqGfTYObwWULlprASBho/qY5v3pbejAorsNqtYVli1
	AEkHBMLiE9bdCMvNlq+AVO4KJlf0OORzSa8bS/Hkjy5AvQrzPukEegibcqqL1YkQdRp90xZpGKs
	sGG9jNr3tMenob8IfPJhWQ==
X-Google-Smtp-Source: AGHT+IHnCepBG2g3DkWHK7YuE7xz2m/AChhtm6Cuyuq20AUAOE8zPAooasgxDKlivTwmB7TrnSi/Cw==
X-Received: by 2002:a05:6808:8515:b0:3f0:4019:2764 with SMTP id 5614622812f47-3f19fcc1518mr8976066b6e.29.1737485826567;
        Tue, 21 Jan 2025 10:57:06 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f19da7d00asm3148889b6e.21.2025.01.21.10.57.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 10:57:05 -0800 (PST)
Message-ID: <a1b3d61f-f4cc-433a-a97d-9209610fede3@gmail.com>
Date: Tue, 21 Jan 2025 10:57:03 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/72] 6.6.74-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250121174523.429119852@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/25 09:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.74 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.74-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
