Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBC224DCEB
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 20:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759263537; cv=none; b=H6RzeAnEi/0OE4tjHJenXEf8IJ3afnz7U66dowGyrKLcktDKeeoEtvHrHkQTJQNkCLXRJqsss6OJzaRJKv68Ro3Vfl9Gvz1cO3AkZIWIlIapF64RdXKggWQOEF1oqxdQQlYcA1+/AwOpAPcRYgJVLTWFJUzX3aB3hExWrRi9Cr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759263537; c=relaxed/simple;
	bh=MmXauHjASPTNlj0mQwEIjT/B/YzKvv+oNcG9uMvXJLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C65raRpaSm2+fCyU3g44P/i9VIvtN9NLH6avLlHdjcLvqYjWadW1SJ2I7WBsvHia6/zO8K/PusekysyrlU1b/bX1YLA0urf43hwWhGCqyH3/BPOwaBXpHda7XuqpM+XdP/M6PvEOocqLwgexS8V77ID8BQ2Pppz/YhleOiTAWXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=NvmPCk3b; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="NvmPCk3b"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3f99ac9acc4so1385182f8f.3
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 13:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1759263533; x=1759868333; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8I6dbvilgE5CwAYRRTgrE+fX48lvio4oI5BZ1CMQAEs=;
        b=NvmPCk3b+9jbPCaTJzDd2R5MqZSHRg0cUHu3gwzVT1rxaTNMOhBvyP/mSDwfH6dQMP
         kV9AmHzUOZHtGVmhX0t3IUxcB8tYtemHoklZI/0SB/Y3p0XWIs7Ra2jv55I+qCWy5mMl
         QeJQs49zFY8IgNfN731AkT8hshEeMHg2U8TaRNupfns4uXK8mNwXKIU7hh4DjuccAsak
         jcjYoXQMcstmba/KjHBnyIuiK4wHPPO4cJlwJxZOMeWmvMkq/mOs1mygsSLR/aKCLpeO
         b1vxwOKocQjde6erVbo/p9Rjl9YPLTPX5bVXr2WIileiQSvpfgjByoqUVgYphaeP55WI
         ZdOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759263533; x=1759868333;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8I6dbvilgE5CwAYRRTgrE+fX48lvio4oI5BZ1CMQAEs=;
        b=kLcJFs7FA6DmyUT74BKxqNv7KbRn9SBQJ6/mSpj1ic9V2PAItv+8HWTMy4e3bK8JsK
         O1ODTMhu8j7P3/0cVsZ0dl2leaymhsYY6IFfzCxTFeeu1qQfPSu+y1PEJ+DJX1h6Isn8
         IQjPnVgAksuBTSCpZEV0jJAnmwrCWdX20WjQP0NbXgt9QwrtbwUuoDl+T5X0ZBynm7Lj
         4e19gz8S93TSyKIHnv7lAKTKlO0FtdNW8q2D/d0uPFCP6LxYRBDGBoNNuE3ox805heua
         Q5Ts5IiHHD/ai81sUmR1aPqmDBt81wT9u0u/gkdeSHWKAnK+T84l3Orx2hx0tjPTUawI
         hoJg==
X-Gm-Message-State: AOJu0Yw7Yag0W8htDuBNfXKGid6QOzyFpT18noPRPaaApf3YIPV6aI/m
	jMgsjKJOkLYvGV4Ub2G6HWEz/qHo+36xt6EozfwcnULfYUyF6tSgPhU=
X-Gm-Gg: ASbGnctWhN/JlDz6Rg7dr3qwRA1tF1OZtbwlOb6W61UcGzhnVpVQVTpZvcddpfEk1fD
	5+7ZTojMqaWEJRykaKLsUBM+7Cdc7noloXSl19OfW/B1ke2DJYco9VlfDwtdQDw6OH73c9/28u8
	pPfyI3xIn7OH4kdV3s1l3E23pDP61Rb0dmggzH00yE1SoAnJIcFv9/x2qwsgUk6ZK7aPDNQUTvJ
	8qxzTvSgPgUdckLsueP0xX1JsSw32Y+xiyv1kyzKMhQN/3+2pC6eB7bP0gWs4VF0fhwAcFGvkz1
	E7gzJ7kx2s29Zt2HjQmGBDnvjP5dtjbsFwNIi7WFFNXHA6WINs+kN9/dq8gz1Hv6GIrHl9QQiKn
	hgtqLoweOYgd4Tvz8vSlWLj3BOvF4wQP4or7dJlhFSRg4isLhDoo3JN43ScXqe2NJV30dIhlITF
	AjiLdKxXBbRXpBFql4uo7NPv0=
X-Google-Smtp-Source: AGHT+IHVX3QXQRe9EuiPExL8BKNrajYyrxG7WzB4GC1B2EjOUomUTUBpPzTUhvs5y/w6rZHI4Wb2Fg==
X-Received: by 2002:a05:6000:4312:b0:424:211a:4141 with SMTP id ffacd0b85a97d-425577ee1d3mr734255f8f.27.1759263532907;
        Tue, 30 Sep 2025 13:18:52 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4965.dip0.t-ipconnect.de. [91.43.73.101])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602df0sm24133218f8f.36.2025.09.30.13.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 13:18:52 -0700 (PDT)
Message-ID: <a7b6616d-c5ec-4f11-9c51-48551705d535@googlemail.com>
Date: Tue, 30 Sep 2025 22:18:51 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/89] 6.12.50-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143821.852512002@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.09.2025 um 16:47 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.50 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
