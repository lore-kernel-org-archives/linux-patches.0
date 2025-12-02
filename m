Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FCB2D0C9D
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 18:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764699294; cv=none; b=rzzDufj8/8aLx/UlJV/NO2N007SDJzGbrQytJtMOkyFvn3RwVusMkyt5Ih9Gt4TFnwxcfv7MeOleI5HaDY08cBXHeaXMKs9Ny5ttQXrftY8wXET5ndlEKppxbSS7ooqEa34O1x4oun6OFT+/hZyk8sCjmGXr+yVbvxbyUniTV+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764699294; c=relaxed/simple;
	bh=Zadw4f8Rb9R9ongw9fXvygXWeldIJXphoIWzHsB5tXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qdl5yCjm4QmTzfBcV/VMvQS5hFqz1Yia0oMZnjZXJrxBpQZ5TW02otnK7N5Uyd6dz68/vj86d6y7ww0oQkAoyyXEmBuMr/AyqsUvXxvGFvdNShyQ0mLRH0XCEfsmjA4B00ZTMtjKB/SDyB8jYGCE8O4m904uZ9LRgiDKtQDdzNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ElJW7Fyy; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ElJW7Fyy"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-297dd95ffe4so51463845ad.3
        for <patches@lists.linux.dev>; Tue, 02 Dec 2025 10:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764699292; x=1765304092; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CNcow+v6Zimw2i/FJx4QwkUgA7xtuYBe8HXCgELidKM=;
        b=ElJW7FyyjttscTc5pZOrfblKJETbJdXvd3xFRCkfC3Z1iaBu67UY3H8mrZcZlN4dMU
         1nup5Bzj1/ZU5rzT1lIOzVQkgZ2kvdq43K5XEoYuhLZ0r+EIjNZwaXVWhC52nUwsO1T9
         Vy3NVyyxO3b8N8pPG4zXeSIvVEdocJxfbylrdAkRyXtXbod8czS1Wyo4686AsqdL5bdv
         gDaToQyc/DnlvOhQkzvkQBc3P0yNMFa5PLaCai9wtKxZXdHEFhiOoaqhsN/gZ/Akgnm+
         JmYS/eyIOjHvxUiZKhdmH8avKjO1T8JcQI6gw2L9DtzN3pm/qg3wuQSv9nD1kDuRBp4E
         Rmcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764699292; x=1765304092;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CNcow+v6Zimw2i/FJx4QwkUgA7xtuYBe8HXCgELidKM=;
        b=bSc4uFxfS08+VMJdQzJn/Vz8b+/y+OlZ5dPFjRz+WH/l35nvTAL4fithULvvIxGl69
         KmJhSbk0Xim5M4YZxix5/g22Dt8cjDGj+qg1A6OitGO4tZDzzr14QesrFGEbz/oD53Hb
         F/TA4ScqhoJ3je61uDR1pN/4+NqB0EFXwO3bY/Uq2NWDO+fI8fzQD3sNKchaxN/59shu
         5cijFYi6IeyAxV8tB2tPRJUh3IZXWx3zZoNQFCrx5RuuOS7Wsp73V5SY9evTfIZHSJu/
         mPBjllOfZqvThTB4QCSyDLd8G6XhW92BOcndj8lIjWcL58quRsld35hA7loHYy0dg6KB
         VkwQ==
X-Gm-Message-State: AOJu0YxZtHXNC99r6H6BDxMGkIj6FBtek3bH0uXdkV1iQ2RD7t88SkFE
	/9BYhGECnJFtdT0w+1hFfNJRDNUlw9D+pSUJagWbyOyn8N16NRmLKIH8
X-Gm-Gg: ASbGncuZZyvJeKnemXHInheLvdJrNr/neMJRr30g+Zn8XlcNPax3F473n/iH1U5RZpM
	AiKFZeEVdeUjn0cGcjlNlK4eMRop4haUFvn7vOPMaStP6qBq1PchegwmvM5yYHpRK6DWYj7xnxN
	6vW6bpmc5VvJ+4qEQyhAQtoLNkOTcHXlkR5g2RNvApzFpaxZMHiUCSHu+5UgBfkpIun+0AZHvaP
	6XCWkseTLO5Zehb0Q+q0uvK72cEwpuTaQM7an12zP5YHUkh9SFY5uS2wpDp1AhUu2WW1L6guhoj
	opXs2JUEPiKtaRVpi8vBi6fbHhAmlBAR/6asr2m8sWnrEtI3PkHpobU44he2xQSWO0HOw9BwPl0
	qnKAZi9hlEJJm5hLdtCGATAibJiLduXaeXMjCEjJPNXXscJQTPGGFDINzMW2h+f44rToLBdrBhi
	XvZQGkDD2d3dOFyE5U0JSS/FUWyY7XsjZYfkFd/g==
X-Google-Smtp-Source: AGHT+IHIsTw3gXnMmKVOvzDDcZQGs3jHRBbAwWl9PHSMB/MnRWehAbvLjOjpCgewlPbVBIfe2VtAAg==
X-Received: by 2002:a17:903:4b4b:b0:298:35c:c313 with SMTP id d9443c01a7336-29bab30b2c3mr346606255ad.61.1764699291725;
        Tue, 02 Dec 2025 10:14:51 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce44389bsm162812255ad.32.2025.12.02.10.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 10:14:50 -0800 (PST)
Message-ID: <d771b28c-bd03-433c-b1f9-695e1333756c@gmail.com>
Date: Tue, 2 Dec 2025 10:14:48 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/182] 5.4.302-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251202152903.637577865@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251202152903.637577865@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/2/25 07:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.302 release.
> There are 182 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Dec 2025 15:28:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.302-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
