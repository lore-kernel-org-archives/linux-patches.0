Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4467B3E1
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 23:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741736352; cv=none; b=knlMq4yh/499N4OcAiQTruOcLf7HRHAa5h8hMclVzM0RHllhos9reX7ss+YX69HeWW/zxXGNmZN1jztMzagWA8NskiXpM/Irbdfs8Et9qGtOHe7ym4JOFth18euUvncx8Y66kx9aK7xExgyTTA1bC0jZ3PpWLKWCanSx9zLxSas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741736352; c=relaxed/simple;
	bh=6HAhvN/5aIuhTDN6TVOI/FwZa+MffuFYrNaRthKhni4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qb6vB89RC2g9P3OmdSslJxY9qbmQWtOoFVDcZokq0jsjwUxXXIH0NAfcjNWHNwmLzL9de+Uc4IkAvaTYUE6hNB6tfGbWlvi5VLw8X2LT4zgGKjaw7/JT8PZQ2U3RQV9dRj7wsRJq87BJvQKlDXCZ9udlQvC0J9KVh/9khC1QNOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lEd+8fW/; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lEd+8fW/"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3913fdd003bso164080f8f.1
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 16:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1741736349; x=1742341149; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fr/QFLpp8Z15v7bm6/9JOnLIJ+4Di2Fpgl7HneN3Q24=;
        b=lEd+8fW/qY7hwdJkUzxs18BpjB8zoMHIVSfvDLX9tRal54hgquOO6EpSeZeOcWKK82
         PEDa7S9jAhiQiM+OPpgQ1gqBkLZ17Lzv2DQ6T3sCwDS34pE/QxW3VR6KA5rdpLS/4F/0
         bb3sA16qN4zZPSNdh8aefbIf1sGP1SCNTN4ubeOhyVQHo/pl2BZTL3iR1L9q8/4cF15O
         BI+nZfPIJ8+QLZntwocg0YfxZ98gmeEhvLQRt8bsGHI4uO+CJ4pN/55HSFivk24hQ5q9
         xTrkt4WeX2w+RIyqDc5Pg3ReLB4/3Kv4arZ5wZZEG1IEHOxqsbjYshJApE/GDQG6OaUM
         Uqvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741736349; x=1742341149;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fr/QFLpp8Z15v7bm6/9JOnLIJ+4Di2Fpgl7HneN3Q24=;
        b=c1IPrNsow65ywevsToz49mtwJGTeFcF4ckdB+FuiYs1dM6PR6jfFEN5qvSqSc6TjRl
         5XHo9+xXTISQmeev8Ke+eEo45ohOKQtXsRbVeHZS03piox3xELklp80/0rfy7g0DeKUn
         7iMjGuuiA9ALx4xxQgyOcWJBKpWmwfCWfEcIGeWkaASYRqbhClQtsG4kp+4KFIiSPZbn
         h8/4qQ01jNnpBEKuBg8Bisjm3ghStnhQddnxLi0ZI5qE+2H/+UVgv4/oQJJtnd78xmHD
         mIRvy5sVtp9ngplIOAGBxvcFx2tLqa9nSnxbEUFH/huvKndpJc+x2eJXyOlLL9yui/oM
         H7Cg==
X-Gm-Message-State: AOJu0Yyafxi8x8Gi95YuQ3UDLZSqUw45pKPJK4+jsgNtgx0hRg+Zb+Hh
	Nrb4vpfIvgXSaVMF07eXdCyvpmHdYsoy9jhCF0p04d79RAWMqzc=
X-Gm-Gg: ASbGncs+DvKF6s7TNZ3UxSlbpvgbo/wQKXF+L3q6rCVkf6rGDQ9ABP9MOZvIL3Nlacp
	3Qp3E2PijN7jVnQH71kV7PWaK3NUafZOR9idvjWC1Uzc1UJWIXTCFqTtSNANha9VIXoCEYnkgQx
	6zxeu3IX4BZl7X2oOYn7fNPVeoBEUF+fFFoqIM1tyd6HeUDG7lOGY72e0IH46Z5DMqrqIU1PUkj
	yg1QE7eRdRyjieYLnVDZScxwM2OVLk4ftdcMJUuAYftvfGYJla/fm9A++AVcretS1HAvV7+UVFo
	9SYi8WFujQlKQCGDiZX+b20WcVk6TNo7NHpOCoVmDDYX9YlmUapsaknDVjopJIy2Ch8WHMmdLqf
	FrnDw93qorVT6xwtF/cLzAg==
X-Google-Smtp-Source: AGHT+IElgO/rn+31rKgW6EfhYeGVsPC6cevj0duDKkcYSFutb4R8C7FdoW6sdeXEklTLaxi3bXA8dQ==
X-Received: by 2002:a5d:47c2:0:b0:38d:d166:d44 with SMTP id ffacd0b85a97d-39279e5172emr6258102f8f.23.1741736349266;
        Tue, 11 Mar 2025 16:39:09 -0700 (PDT)
Received: from [192.168.1.3] (p5b05767c.dip0.t-ipconnect.de. [91.5.118.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfb7ae4sm18857564f8f.5.2025.03.11.16.39.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 16:39:07 -0700 (PDT)
Message-ID: <da0b659f-b1db-4ff0-bfa6-b875e4be76a6@googlemail.com>
Date: Wed, 12 Mar 2025 00:39:06 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/269] 6.12.19-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250310170457.700086763@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.03.2025 um 18:02 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.19 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
