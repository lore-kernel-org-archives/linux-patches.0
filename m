Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68781F0E44
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 18:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737485061; cv=none; b=VSKa6RofqTA2yXHO+8kiJrsMPoaH3/SuZjb1YtxE5BcdKPX7hMIjcWP1Pv+h8jESv63pjIdyhiE8fOvtDn/2XKRaztzp4xzg+ia9w/DHD+dOfIzgRWR7auv3mlgW52meFxFrvMrbKMV9bontR7i6wRg1Yn+fmh/kg8Ba8Z2D9bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737485061; c=relaxed/simple;
	bh=O5sM6WxyDgfaS95qbllWleaelTQFOs8RpqIiYrTLnEw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e8cRdS1XtSkD1DD6fdCxkAJkTVgzJEFPbyW1czDG5RKHQwdmZKddvWa3Kmt16y+xSBqxz5PxTRSDDRUTTK4V9igDqjqD6Pmm7yQJJ25i0hfbihRk+KW17e/XxnK6vLVgmGa/fbRykBo5Lo3oOQ3YxBiyn1VQXN+wlHMgwX7hN0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OeGfEF65; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OeGfEF65"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-71e173ed85bso3041319a34.3
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 10:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737485059; x=1738089859; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=RlKJ3LgGHjZxMuE1TB21WJyzLambGQ/GuKtdAmXNl0A=;
        b=OeGfEF65bxMo3laWD84AL00pkfaUBJBo/mAsb4rHMociYBuAf8T3TId9OcasHkni1N
         1xNL/7KS6JxQYneTihZgRfSduM7+vyTGrDyVuk4WXUO2SXayZ+26H7bz1nZKPHsdtWRJ
         Llf0XymD//fpXkbI2Wk8c2ZIp6ZtINCLTbJimq67QTIpTShlvJtWdBil8xgJAnUuo7j8
         CmqCutZwGX5NhNxgDzVOyQlmjyHFwAw9aeg7xc+bBnHg26n3c+BkvBodUJS010uhEBn/
         6w+JjDfZ9YfLY/R1DrhGxPaqaLDHDS/OYuNndKV1HBCArRaz/UtNG4Wqr0qZnsVFO+xZ
         FtjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737485059; x=1738089859;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RlKJ3LgGHjZxMuE1TB21WJyzLambGQ/GuKtdAmXNl0A=;
        b=MC31fp9Qm7Vpd8WPODncvNcY8Sib4/sAI92DIGnDUz1r2vahrG2nagQUXG4k2duXML
         Y0fBOAokhr4z/3ok29aWYDDduAPxaZZmNz2UiX3If2Ef6AiFgnEPLBbW8810GAl64HMZ
         UF4kaI2ilCp/p3eYzpQwWXbDU6W3uX/dKobKuJYcRhPmX7YFlBiwBb4u1PHLolmF2f14
         bHCSMOQ7R63p40Ne0oP9f5LCTxU+2hrEpyXk984hMHc+OH27FoNQUOHWuXO0acKtM1Hn
         hJ5YgdU26o5OuD2sua0rxmtH6Qz9Td+qGK++DK+OuJL/iatmdqoVd/NIEMt6WRn6nShA
         IAog==
X-Gm-Message-State: AOJu0YzcFvrG5uf3soVHQ0D6+u2xs0WjNstYjAITHsXSBKAzBUXSdb0q
	1RfTJJ4DgMvA1Cyj9AaLpQssy9yteS/HCxl4b+ICzop3NSSu0qoK
X-Gm-Gg: ASbGncvzOGKovxMCZfjqj4VbOXIjKATwydH5IaPlvWouomMpBW3v7PAXre6zPIaaLjz
	PX0IAPPl1NMQdVg9HJZmcq0blxVtrWCL+YjvDuYCi5LPv/JzKtpu5iZs7O3kA8apR3SQ004hrKU
	pAqRuo9Hkqjadb7AWevxtU/+waVppbnwvdtX50WMTvi4gb8CxI6JxZW1Wqy0EiZ03mLys38opBI
	gc8rOrD/Eb5g7x/4KyH3b63CUXACD+NsIxzKLivqrA8DyEAOu3InmrIb9E0yeZ8+kkYexjTpq7w
	AbatlQzVy5XFeJ+cZi48UQ==
X-Google-Smtp-Source: AGHT+IESuhzJ8tC07LO6zfeSt9aRTR9FwfUMTg7k2e4mxkqPXU0IKjDJ5LS3GKmqxUADK/sZBZBAkw==
X-Received: by 2002:a05:6871:4003:b0:29e:3bea:7e60 with SMTP id 586e51a60fabf-2b1c0cdc022mr10166837fac.38.1737485058780;
        Tue, 21 Jan 2025 10:44:18 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7249b3a485csm3402733a34.21.2025.01.21.10.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 10:44:18 -0800 (PST)
Message-ID: <a9afa90f-2a2f-4ae4-8d0f-b136251b831a@gmail.com>
Date: Tue, 21 Jan 2025 10:44:15 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/64] 6.1.127-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250121174521.568417761@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/25 09:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.127 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.127-rc1.gz
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
