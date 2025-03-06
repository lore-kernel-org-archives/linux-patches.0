Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848FD154C05
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 01:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741223987; cv=none; b=JHGE/y0UYoM0x+YPA6vVTqDMf5wByzxCds3YntgI/ezYA77UfVS56ZzGg7xWVX8mkjHML/olIYC7vDs0SJaEui5AAv9dp3ubE94tGAdHhoV1C5SvzwC26Ne79ZdtNTwjZJPWAlbxtGK9Be5F5+2dw+FrfLndbcvK02WuOcbg+Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741223987; c=relaxed/simple;
	bh=NQ9JaqO7/f8BskH51rnOv+3ZlwJ/qLixzYb9yoPjjUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CT7P2p6ARmCqtrC8CpI/I164maOXAqhjSTkjIa7ARuum6YzAuhJVTtv+//IjP15TOhG67Nszf/L34LVoePZbfr7mmvJsVl7+DfBd+aK2cAzX7/zE3ehV+JqnaPpazU8r4FO1r9+o1mbWY/krGiWPGzQli4Yj7YOwKbaclLPIba4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=WNknAGy8; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="WNknAGy8"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-390dd35c78dso924289f8f.1
        for <patches@lists.linux.dev>; Wed, 05 Mar 2025 17:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1741223984; x=1741828784; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tKo26csy1Wj+Q6iZIefqxzUixDxkCmTqOW6lRWj6/Ho=;
        b=WNknAGy86BtxUbCtq+T57K2b/gRE1ayHTLXz0zHT8SJ3JR8BVbmYKZ6sYLegLGAo84
         q2VJHdM4cktvKMBkNpM6veayt3yigXQX3huM2qX6ljJmWZtQ8RMjGRm3mXZohrZKPD+m
         FC4OZVYrAHoJRUnDDOoL7MhFxiEABs06ZnpqINLHm6QT4CtGWDBCFi08yT/C/2DzRKnZ
         H1v8y9+vZqRCRWnxHg0HDO7lmoHeSiu5xU+a8ezaMtKLZrgU6QkWu3kW1gHnNRNCCAQc
         UkUDj6sO/ZkpVjaF3QsE9x31uIqQyWVSbPDhc6vX/nXX9StjbrKqIBOz6cuNYfDMhS56
         dvDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741223984; x=1741828784;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tKo26csy1Wj+Q6iZIefqxzUixDxkCmTqOW6lRWj6/Ho=;
        b=CTZcvE5S15sxe62aIdDvNeD7h/+a6Pkv8vwY0LOgG0rB+PouRV6GPB+dLy48aeLMnW
         3PmDUilgC674UWVr4Wy5Y15NZ971v/HyHNkayerD+4pt7ykHfkBYqjffERFVg0yUv/mt
         dPdR81s1fFiyyBvR2u7rvsLOpyoqrVSa1nkprZA2J8MefcDtM08Mv4jP8dpT4gG8jQp5
         xcmZro6ogIH61o13yVSEPAGXQEhqdKjaGJb+Fh0tAQdFX/M8tKCMr8e9BcuVsw1BrXwX
         VX+wjmuAS1snOkCMM8LPn7Z4R1EyCJbRxtI85Ox252dtoxndc9WYdpVBOEMvBUIVzIAp
         FHNg==
X-Gm-Message-State: AOJu0YwgLWcISi6apJMDoTmz4gOjUEeB26vN33qJvSJyChqtad9EGgxH
	Skb8rn69a9bPNXLN9/aws8zbgeN5d/No4l+zsAZBgND9maVX6X0=
X-Gm-Gg: ASbGnctJ9zakpVQRLxfm4Exq6XudbgfDzJwboNO/67NPX9PxHq0jIb/MOLDgFm3tA4B
	nDahf/0h08FEoPdcR/Yy4JSkz4cajgUrheIg3qLohpkAFS7aE14SwJoGt2kBcdH4PZ5WIyo+FX1
	QgmIHaIiKJQv9Ns0pW8N/nBTs90tuxKmGnasa/QmPRj4T7BKCOzB4ZQb/i8rqcmSRBtT5V4z04q
	c1XJ8ObuzVud0MkzBQmir3nivqDPGJzb7T8oxnzQWxQRheCnFXVRKV6eLiiV1GybNjfNuVq1Kvj
	FOyZF+kmqbPRBPibX25lONOnbqBq2ep2GzZOheSUWLYdTOWeHYUBu9fT/DGPK78dnqp+lb+pWM5
	WOrYT4pdKtHVDTfbkmmvJ
X-Google-Smtp-Source: AGHT+IFpPgTvwRArsdAwnNWcjZHo/WphvoPPh+mSd9cE5f54PpLp9KMuL1fBCvQFKa40509uQgVZ8w==
X-Received: by 2002:a5d:6c6e:0:b0:391:952:c74a with SMTP id ffacd0b85a97d-391296d8a65mr962184f8f.8.1741223983547;
        Wed, 05 Mar 2025 17:19:43 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4217.dip0.t-ipconnect.de. [91.43.66.23])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8c3d61sm3465675e9.15.2025.03.05.17.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Mar 2025 17:19:42 -0800 (PST)
Message-ID: <5b7bcb84-5ad8-46d2-856d-38e3081026bb@googlemail.com>
Date: Thu, 6 Mar 2025 02:19:41 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/176] 6.1.130-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250305174505.437358097@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.03.2025 um 18:46 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.130 release.
> There are 176 patches in this series, all will be posted as a response
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
