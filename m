Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330934F602
	for <patches@lists.linux.dev>; Thu, 23 May 2024 18:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716489359; cv=none; b=CK2H9lfKXN+K4kbmJf1cE45hjrLwxGQhc4midiXrcpzDjgVJfhjhNzIkzsHMOgr6cSQ3rKKDJpqcP4fcK8sxCoB8pMLNWlqSIy44ixTFVbi4C/uO/nWZ0iUvV7o93qVV+lQ0PvJAIYEB6EbzAs7VP3SqTgDS6kCrBqwPp1usuK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716489359; c=relaxed/simple;
	bh=e1g4M6PP/Tu52fL0+f5mEFTHjeQVpZLqOhGBVTnrLWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lf4s0ZdI7KQ9YE+k4q5UoD4x0En3ewkWG+IO0nJXa0IcKPLIzXdOvfFyBNtpIfZtZXuCABDiTIrOdrKEs2Te85bxzdEkbw3mj0nNx1Em8vmKeAJ0MiKFiL9R+jgaiyh+HatU/05WZSpOW9Sz3HIRaccAAi7QaQzg9RaJiaOULZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fo6lBfVG; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fo6lBfVG"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6ab9ce74bddso593006d6.0
        for <patches@lists.linux.dev>; Thu, 23 May 2024 11:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716489357; x=1717094157; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AcM1HEYW+RYXL509g3aAc7ycNKgv1hXSbOH207bKEdQ=;
        b=fo6lBfVGa+gKsrHaqRJahmRtTlfZUcdM9SqCHitfgdVKEdbEMBwzjQ988AdPDn9LI2
         krz11HG27LInCBMvuqVGZ1Of1EoUpXYx7KwGBqplC3sSHhww/lbVPBHDll8xPLfRVRvl
         D2pDji3QdRl9WQjtEY9EXjzjeIXdIOzWcAyEvQahfZBYr9wW66y3BaZUIrB6wxosy86+
         y1z8skbdeGaJ0NDZZW1WqUMvHGObFWv01Da57iD628F3Q6KDsVgVCmVdAn284+Kb2IBX
         JFJ5FKWYIbyICEug1nro07QLRr0XSIZTNB7Djc8K0C+U2Q7a1magcYhieIc3pZQxy4gu
         1kJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716489357; x=1717094157;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AcM1HEYW+RYXL509g3aAc7ycNKgv1hXSbOH207bKEdQ=;
        b=BuhQJZfpN0DmmpeYInocQkzXH7cd+iAYe4KUQszfwqg9/IfKPuNpZ0uUv/sRLEfB1i
         rL+tDlNCnZr08sBWhuUSgJ0lq1Hu3NM5XDRvSJCIIRkM5gM8QGTqh/i+zomDALeyMqwL
         oSfkKcPKx5WjUN52w0M54L+Xj+TPt3d3Hd2N3G349s9lLI/1orFzJh4w2eov2Dn+WUj4
         SaAlxedj91WDc1NQvl4LyKr+HkhfkvmHvSCf97HjmtIs6XDFS8APpKPiF/rj7X0xN609
         GCORhBXX34Isa+vIbYij1Wp+D0LOvhwGv49YHyfa3K+ndb0/BYRUFZISrO2t7GfqtzZg
         Zk2A==
X-Gm-Message-State: AOJu0Yz9AcuE5spir4KP2bwopNxZPcuXv80WNpXd3d+vfwYqC1e0jeFZ
	Re6+tdtimqKeMyooFEUv39L84h5o8PHTjE/F7g+wByNAdax7M00R
X-Google-Smtp-Source: AGHT+IHsvP5Q7DiWwyS3W7rrKp1gK0kHW8+e5/rS/l628A9sPfGlzh23EaHca7OdXue0kQSpK451lw==
X-Received: by 2002:a05:6214:911:b0:6ab:898b:42e7 with SMTP id 6a1803df08f44-6ab898b4406mr34770196d6.65.1716489357055;
        Thu, 23 May 2024 11:35:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6a941c29753sm51784136d6.18.2024.05.23.11.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 11:35:56 -0700 (PDT)
Message-ID: <44c42a1a-00d4-4d74-93cb-fb97be9191ea@gmail.com>
Date: Thu, 23 May 2024 11:35:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/15] 5.10.218-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130326.451548488@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240523130326.451548488@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 06:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.218 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.218-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

