Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E845D2DEA94
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 18:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752001013; cv=none; b=jQ5ZXJdFWqPmmNZq7+JDImwI3fWv+6Bcr6i4BMz0FyhkCtSpR9A/d4y0bNywyMjMvbqhbVgglG9yKPtt+UqU9Wlll0R2CWSJjUneQpr4ildb4vbTRSHoGZuWHtuNll55+E/V0zcK4nJ+ZAGgYI7NQwzqW8YXSUW1jp9KdtRas6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752001013; c=relaxed/simple;
	bh=+RR63u8LOhfwsUaOFs86tls6qDuvK04AjP+ESZntZSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XNIvgHw3vO6VE+l70N6zk8W4GTFOPivVlpek37qg/2G/WuWZMXambYap1BKU6qHi5YBhKO8JKCWZZ9zkgxM3EZRSe0cYSD8tjPpaeS2gKeNihdvKHKftSQSm8Lu7Cc7t2IEjZW3twjdQHr4vmcEWxGERL9r1MLW0n/8JmCaKihs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D8S0UWau; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D8S0UWau"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2363616a1a6so45542935ad.3
        for <patches@lists.linux.dev>; Tue, 08 Jul 2025 11:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752001011; x=1752605811; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BlikTIRDCOdj/5pvDnwYZdM0zouTWd/o3USm77KPQ2s=;
        b=D8S0UWau1K0KuCMgiiHuQLibSI30cgK309T6oEvaV//QSi0VWmVGhlqS/o+ey4iFCY
         rVfvHcQ7ACmOqGT5DQPxQOWAIYuqWvUoLdaEyDOq0+b3N2CubtJoyQD21czl3lEKxBiI
         xn//nqoUx5uqwR6xGf711YRbhp4+/PN1uCR/HhuAzV0pMGFdXkU8FgxnwEjUQCNVrhg5
         eXI+xkmOqHORD3/tePwjrSP7zNWcI6rJmpTVktHedM7mKRAM4cRQXkSQeOFzbhqes0po
         9edFq9k1d9coyGabUAPwcWfSyVpcttuo3/cGU+FcL7F59u6uPuG5tEsg1XDypNnok0QD
         z/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752001011; x=1752605811;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BlikTIRDCOdj/5pvDnwYZdM0zouTWd/o3USm77KPQ2s=;
        b=izXH7yElTAHheyWcg0Ecfxd4lNax9gpa3kBFtGDlZPUroNQepjAZXZIzjbEOF5nyTz
         4VjS7MXKVTAEHeQTMKt5vjXXwgRcl5CEqiSDZLXuAbUfJZbrKS1wzNKD1fMrnORNEp3H
         rcr+ZktLywVMFc/CppaKRb+D6ESS7bsIlSX8g7s9a9ixONjYs/7iEhR4RFJwjxXyBYVP
         ffcENywl0DukXAsAUbnrNkIUJzDxVKNVixPRfhYiJtIPAhiULvS/nueJ3lMehSNhQbIz
         H2HNm3tmK+DvG/QxSs9ZbMq9AgRzRpi8NmyphSZr1+aadUEeNY4WDeQKdclfYW1EQnnP
         apWw==
X-Gm-Message-State: AOJu0YwLg7AmkfP11YX52rzknOdSLyS7qM67YKa78z+hUIWYWDXpaXIp
	DC8KOmx4WokCAKeDAHu1s7uhM4msLZ704KW5vZr8YEPQhUWpMCJ6nExB
X-Gm-Gg: ASbGncvM/vmvPLcURo3AQOD2Z+xZtWEMSHGVAZiV8bCsC6WhUU+QYldCzImLrCN+Nfl
	eZrPuoSzaqSARLzGkc4YIiLpWWYOUJxyhSyV1IbsjtCertJwvKWtjANUFzkN+yoS7Zx6v6T6Quw
	6NCu+IZnRb7RGMQ992Py3hrwW/rsDWGhtMT7rQBj0u0eETuj+bDDiSR5jsCQi52hpwa3YqxHvLs
	JF7LIURJrJi2z5IItXXCGdZKbkU7W6AEpJDOtojkA2fWQvQootnourDKyQPnc8IiH8vbFJTgcER
	Z/YTTXadedFDrhOI6p4gV6fBkTSPhWWYE7j5FFEeaZtztQ29vAwhv7J2wriaxoMgIfA/w+7cpYw
	7iTFJzw==
X-Google-Smtp-Source: AGHT+IHsB9hv20/vZjLR45OOhCSsAWmW1PQ6XMP6kbr9FsmnbiDqMwH4+kTNHJxFjD54qg03o0MKuA==
X-Received: by 2002:a17:903:3c4c:b0:236:9d66:ff24 with SMTP id d9443c01a7336-23c874661aamr242035135ad.8.1752001011131;
        Tue, 08 Jul 2025 11:56:51 -0700 (PDT)
Received: from [10.230.3.249] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c84592ef4sm124991965ad.191.2025.07.08.11.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 11:56:50 -0700 (PDT)
Message-ID: <ffa5990d-6ff7-400c-a6f6-43edfc957381@gmail.com>
Date: Tue, 8 Jul 2025 11:56:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/149] 5.15.187-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250708183250.808640526@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250708183250.808640526@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/8/2025 11:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.187 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 18:32:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.187-rc3.gz
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

