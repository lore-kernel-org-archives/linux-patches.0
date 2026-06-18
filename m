Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806BF3BF67A
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 11:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781780692; cv=none; b=LI4DSP3NRTuWUEMJcVdpmfC1UGdjc5YWPe7pHiWiPZtCpqpYs4tgLXuwzOfBb8ozw14Qz+7JdFmjd1FUgiYQ0zr4tLAWpDSNbLA1knZzT2lfC36AAdT21OJfGVYjeAmVE/QJyp6/rXF3Qjck4Q4fA9J3775Ks+Eyq2yft1RaFDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781780692; c=relaxed/simple;
	bh=8zFYWjXdYiGvx0RH9yT9mZEvjJjd6Rtna/2LMh1peKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dDUWVnxEOeBGn/aWKdXXoY0t1ULNDvbnc6ZKPKzlMutUAAVDDggLlFo1c2SbazyKxafF495a1Uusm7FmFs+pMgvQibuwdI733dHDqmSjX3pArAvTn1fakGRVOn2fhXtmPfzF89oA+tIoTguSqFp0yPtTVz64trVWFCzz/pYnbgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cZ/0SUpY; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZ/0SUpY"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45eeba68948so621060f8f.1
        for <patches@lists.linux.dev>; Thu, 18 Jun 2026 04:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781780690; x=1782385490; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=khbR9A+QxbHPJVF0qK+zhaccvVI4avoOke9tLCAjmL8=;
        b=cZ/0SUpYHHCPX5GHU4a1Ggt0l3WIexWfv5qaKm73N5LNfCe80t2LydXkZ8kFm+1QZk
         ov0oJf1vTMywRfMMMbQDG4/lJReLA1RqsTwb1M9A1ifv02tA/85xeeZxBohlN6RhxMJS
         6LwG8Shh9Ro/DSPtmx3GwVB+pineHlYiHfk5tGwsP2BVHJKvKNJM1oDS9RaKBsjm4tRm
         mYQPPHdajP9oidIE8vinFxorwTaZN8w0h+eUYvTWpR9Y10ToJwlKyD5kRUR25SxxGO5H
         ot0oKhR+bSOK6Y/smU2bABX3we6MNcltwS3WePtyQNeWXrWwrJ3xzjISUa8b9kAh2A1L
         U1Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781780690; x=1782385490;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=khbR9A+QxbHPJVF0qK+zhaccvVI4avoOke9tLCAjmL8=;
        b=cQ0AxRsk8LwXW1Fz0NpYL1og39ucElX+LLj0mJwgFIag/4VY87cCtFmZtCNEPbEO7y
         /whkOdJGvpBM+tY5dGohQt382r9FrtYf184eWtZbT12+80ycmS8LMgLCda7daDq5vypc
         t6pdTQ8pHtp0b7vfuJQaKdbnVzGaXDP+f6vDTYzv8zhvA7Nuiaa8vcxoLiiRXqmsu2gp
         553hONc0jg3ced7dob3dTykvQ8N+LFFWUXX9uUFFOOUo2i8CKI3EKWWPVN7XO3awD+np
         otti5gwE0eEDngZxTtw7qwR43gNyMpQk7RtIViGLVY59O9BI2Hpck7GjDiWWJBhgm5vg
         ofRw==
X-Gm-Message-State: AOJu0YzF4a2M2DNmnhExsrsvVjClFD07VocEj428+4+62Fep3J6NeBvc
	GK0eVTdK17JJ1B2r55ps9tS4YLOL57jpeyTehBIT58o6/QhybIxJMzYT
X-Gm-Gg: AfdE7cm1FFudNZ6DYwdweBOBNhWwkbCbpIAIAD58wzwmqTjd1KK4Ps6kQDB1cao/OGk
	qpErHeHnRML3/IyA/LEowKutAePvv+EFBmlfbl7iYNjdC6EoxBwkaNhZo2o+E57DkMVJ8PXdHCf
	YHw0Wn+WDaSC/BWr1vdyfSsidgKeE4b14SfMOgo5hKUvnVVNl7uO5P1AqajWEWdxfcu8QrJyZ5H
	OIY6gsEXgboEXVu55gnrjBClQyAJyyxOXDJtWb3nP7DPvZuNjhFaRA236Q2EV5C8/ZUBJw+V+O/
	PqwocthKdjPiRl4AHv9daYZ1wDATiL5AF6j0aFSVtvsejf55XUPcEemIRrxcZFln/wJrDiL8ku9
	lWz5K1qlnImHWFYRqNYgq8iucZNCF17qrj3Zu16bdZCjyh/9GJQiB1UGhdDC5Zc0kZtZ51XmvWS
	QSWECb1pXkZdxRhe1jb9AWtmj1aft1yw==
X-Received: by 2002:a05:600c:c04b:20b0:490:a298:acf7 with SMTP id 5b1f17b1804b1-492333ca341mr115712445e9.17.1781780689705;
        Thu, 18 Jun 2026 04:04:49 -0700 (PDT)
Received: from [192.168.1.21] ([41.140.50.249])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f309sm57289428f8f.14.2026.06.18.04.04.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 04:04:31 -0700 (PDT)
Message-ID: <d4980037-ceba-4bc5-9aba-79432d6d6ae4@gmail.com>
Date: Thu, 18 Jun 2026 12:04:25 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/342] 5.10.259-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260616145048.348037099@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/16/2026 7:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.259 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.259-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENEIRC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

