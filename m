Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D6225F989
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 17:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742924298; cv=none; b=AthCQ8sj6boaJTFZkS75oK0TDThrWafIfCJt9UZcjVmuatY9t18WH2KDRQKHfkfoGZmZckMIDQOuR03M7CQBZM3UmY2NYA4Oa7UhS6PslLZnCo2mCQ1HStKMisa1ynAa0KTyAJrHfEtA6X3XaloyOOpC/742MZ4tBZXY/AK7OAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742924298; c=relaxed/simple;
	bh=ZnwOuPQszgGFnJ7ASTrb72w0n4+MF6tVe4dX5uRrVUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=awrHXzhF36asbhKx/gJ6NQqPK7TuLRPAwdBwS93ZL+NXr9MEIWwxRsmCVncMw0EW9pD6nnyW+L36npy3AlKP8cAPDBkU9lVD4KRDXZoEeV3PY3dA9Dgvsrcj2TX5R82c1HQO4LuSRa1PDdah+GSL8EylCX001JWOD2DE+qnq7SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aRApZ0Dh; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aRApZ0Dh"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-2c6f6f75a81so3096265fac.2
        for <patches@lists.linux.dev>; Tue, 25 Mar 2025 10:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742924296; x=1743529096; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pwqYH740eHfa7nr66Oz8rz112QvEfxlqWsjIWzeytTA=;
        b=aRApZ0Dh7akvLGmE6e7plLC71yxCmJWwJzNYdo0pHjIIeCBpcbYVFJVDvw6cZZyUbM
         AAekCBjKPzjaM9zDrbfx4/g8oDEZ4pUG13ZlyTOo8UN4S1Ms3BvGOqEtKu/hyykbd9wm
         PDUnHgHZ4dM6NgYM8pFehflKFfr8JLvbqgry5ts2EXiMZX1/JTS+3t88JUbzo1Pvo2dD
         bExx5cPKwTbS7HMoP6cjsRJL5uK1Fb6X1ezUlblSS1xKPn0u7x265E11uAO+uKqklNKH
         VQ5kEfUsKw6PrJGIg+Q9d62FzoideGT3yYaBWpqEdoAYi45N/22mD1CidvKSZWKWZ0N6
         pfew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742924296; x=1743529096;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pwqYH740eHfa7nr66Oz8rz112QvEfxlqWsjIWzeytTA=;
        b=BvmM9Ij0g+oR6V5pDirY+Jt8gavLFxKKP81cavT84dPO/ZDmNaW9CAe6uc2fVAeTnr
         Vkpr38evcbeyHVXKDb1nyunQwBkCWcZuhSBNekEz3wqNJLRcTIOCpFVCUj54RE1a6zkU
         XqLFMbMXyjTT6lKpf7jr53JrURP0woM8OaUViBGsp7dngoTHVwgLJJkeFtQxLGGi3kAH
         ooW00HjQnnmILq7rtD2TYEd3iXLaNWrXhSkRWTtma/kFecqVisQBhUWpCoSzhiTcSzh1
         mJeQBINQs0hfqGc2hBe/pw8GYVJFgoq+4cPWr74Vetka6ZBUbI24zzjRiWy/lf5kdEAl
         Ufdg==
X-Gm-Message-State: AOJu0YygXiOnkEdiLWjJVBhYBqEMfNsejWeLTqjGAFAQTr8Rqb/lhFTM
	+zcSQ1rL0OfCet9BEfh2/7JlRpO4TNw2makfBh5wfufWD/Sh17tw
X-Gm-Gg: ASbGncvi2HV/Vh2lzzeIIU/lCOvv2Zyv2jDinkaYnj0ghNInqokYSOefHc4odT9i1Be
	Nn0Qm1X7zgC4nrF/NAkGEm6QY4O5Cd4SHIo3FbewQoHdqvMumB25SsSiiHglYer3DxqHnY91ZJP
	eqFut/mhF56WWeT33YQpEG6ynhksJA0HiqE4h8WnaY07M7178IgvHoOdMuKbTR5Ak7uNAXPXOBG
	HIAHtEN+xuUusLW6ifpWm+AhrRxuhmDqUjLM+OOM2AejNaS4Kj51SSUID8ix/9X/135gwtsnekg
	SXacwszfVyxtVkGcF0QEv1Jq8heGgG7y1MdB3UDzTPwP0/pGLMsYptzDOTw8u7VEYtmjH5/0
X-Google-Smtp-Source: AGHT+IF91Adb740CaBkkzjchwnIb0t1PYPF6DMBIepjROWrzdPfXlPqlaH3T+uBSaaRR/gfP31TwDg==
X-Received: by 2002:a05:6870:ff94:b0:2c2:3eb4:e53 with SMTP id 586e51a60fabf-2c78054aae4mr10641137fac.37.1742924296229;
        Tue, 25 Mar 2025 10:38:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2c77ec50cfcsm2572389fac.15.2025.03.25.10.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 10:38:15 -0700 (PDT)
Message-ID: <55f9a6c4-9248-4a34-9488-d09a543a4a23@gmail.com>
Date: Tue, 25 Mar 2025 10:38:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/116] 6.12.21-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250325122149.207086105@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/25/25 05:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.21 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.21-rc1.gz
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
