Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED011DF270
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 06:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753250958; cv=none; b=ms3OjA3lQDvfE6+bffi/jgCL2vREN61jC4tCMN/czpMMDuSC0A/mol4bvVXB+YKuDWHGm28D/fGqeivuPrjT66iaqWGHWGn8NR21kCw6hm302jrl8+b+OVdLO01THD/+g6yGDPa+TStQWHnGIeyIMQIUWJL1zkbWI4z/ja+ROIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753250958; c=relaxed/simple;
	bh=18W9NYETu+o1FTtCXbfu0Hspkb64WessU+rabhwWnTU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P5C2K+fy3Uw9m+SKORo0uxZ5T9IT4SSW1cfi5SxFHIC7bVIOcOiYMRObqryyONR+Ysco/s7NzWNghjD3QRl+PdqXXxHacYODFA848478Motipv6Llx4wxXOsjUpOBqNu+krTOE8RKFVJGdVuYOYojgjJe+s9lAsxSLo5w4fFNCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=A1LFFzYq; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="A1LFFzYq"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a588da60dfso3741439f8f.1
        for <patches@lists.linux.dev>; Tue, 22 Jul 2025 23:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1753250955; x=1753855755; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S5hyH8mAVdQ/h1Za7Ty1QmGUR3EU99QudQ/Z9Zpd/LM=;
        b=A1LFFzYqfC6NN7YMyOK7Fv4Mio9GQyJANvb38dJbqnm/CW8zXyNBcbMgiZKx4TFPST
         F2KdPRZdUb2vOPD4Md1Wgb49iiUQyNoVNtGkqnJ+uBg1dwzd+nEof+nitbAb2z8rTr04
         pZTPaXtsbBWkdqg81JATXUjHSMfMCuosGCECooFWuXGeOGfKVHcu0S4PjqZTuZw2ay9r
         l2Nj79j1cwslRjJDVwNzGEfaR1mq8TLiyxq7MGbFiZKCVxkg+tmEX3JZW6iR7aCduQFW
         ddLLcMFDRBZO41snf81mGaKBwaXYqqJErqSaiX0dEapZ52k9HkVf6bXAFT/nbMrk5AGT
         bBZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753250955; x=1753855755;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S5hyH8mAVdQ/h1Za7Ty1QmGUR3EU99QudQ/Z9Zpd/LM=;
        b=e+e2kQF6n43f/uxfMYj3mtjwxeV3gxVgdM0gyIMzlwnpXjkKKdY6NZ1ZJrQGfiakf/
         X6Et6ysim4DkZZhuHVx7XlmdQJBxGTOtxST4jetaHXawFboIUPuGjJrx4Gx2GKRleiYF
         nwiUaeFGXJ9/1CHOiJ5Gt/XNm56fR9WDY3KKRuApOA7IKDIYoPLBT6dmzW6OfRIWa6aC
         nyDdKhSU11E0MWx4LFgb/dgF0go9b5vVrJps0uPcph66l3JL42X6iiedejCHRCv4RJni
         H2XQc9oc5xbRKkvdU/alZBY0V3wvnCXkIFLLJjKZewQiOIGumov29CUCtz9RWFy5A6Zw
         yCUQ==
X-Gm-Message-State: AOJu0YyAaGLN73sDIqixdHocOMMUFKnw5WGciwMdkhGfHQ+wgeBsLwYD
	x2oEq/m6dZS6XVXcLxX2oLpJ2RTUzS3Wl3UP8xGvgyMcrTQCU1zXAV4=
X-Gm-Gg: ASbGncsfEim4Gkws4RgUovPQSmg6KBUuJqWvnktH+yxoeFs+8qAMzhbMwMhd73Vo5Xn
	NvMricblqUq9v4YymyV0Lf/wA2RJClqcVEvHAbv0LyNpJfXH1DEvicEdwv7wAAuJL+IX4qlHTLo
	1NVI3Av/B5F4wPKalq5VpI19f8Rgvgmf30x0C3Se/8hncfW35ybdyqkWaT+NJOKkrbbdREbS9uA
	5kBlHKq8U1Scia1bNS0ZuwutXmJba98N9gDHXqvcNRYy0etXmWB14X0wgZ1aRPNPXHIameygTV4
	e6r4DJLIUHMXSaWZIqC4WxkbwjFvMLjbFQB+CDlUFs7GNXMx7y+u7PAVa7m0CeVmvUoCRJ+k381
	FSryS338uwhKMUbDDSjXPCt/mDlV2xjiZc1ge34nTkEpcqfGygJcenAKoyfjUL7NTarknk1Np6A
	Fl
X-Google-Smtp-Source: AGHT+IFItRiz5qph4V+LyeVHINY5CxZH4aTFO7Eq4z71uFasfv2pqOzNSspL7yNZ+s7Le9ULr6mMUA==
X-Received: by 2002:a05:6000:290c:b0:3b4:990b:9ee7 with SMTP id ffacd0b85a97d-3b768cb1b11mr1166177f8f.22.1753250954802;
        Tue, 22 Jul 2025 23:09:14 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac7d3.dip0.t-ipconnect.de. [91.42.199.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458691a1afasm11873505e9.21.2025.07.22.23.09.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 23:09:14 -0700 (PDT)
Message-ID: <47f2ade6-c86b-4408-be19-d8db81f3c6fb@googlemail.com>
Date: Wed, 23 Jul 2025 08:09:13 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/111] 6.6.100-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250722134333.375479548@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.07.2025 um 15:43 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.100 release.
> There are 111 patches in this series, all will be posted as a response
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
