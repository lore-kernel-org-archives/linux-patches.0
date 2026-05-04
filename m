Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA66364923
	for <patches@lists.linux.dev>; Mon,  4 May 2026 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777911460; cv=none; b=n/yNNNJWdTrJ62AgeqHCzWL/ffrvg9gbowmgPnE20gn+lBIRLsPBXPqSp4Ym9/Z9ebRni6QJRME+TJ5NtPmXjY0hQHJ3D8FM5ZGm+h+bjigq8RHcbAlqaLpfOEZJqBMDsDpMjCISBBMBiqFdtVUUXcTJkS1v/1qshLMYAKgj7vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777911460; c=relaxed/simple;
	bh=e+cYlcR/4LfpdBr8x2GQmIc7u37KbjDc+gIlNtqc2B4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KbYaenkNWm7qPPQKleBvXtoXTRPVgyw6g+/HRbTVLdggs29Gqb1iUNI8SoTSnlNEizrKcPBcxQEG/9ahpVt2Kh1syqruowLoMHoDMdWjiDJWDWMloe8VoxWHHX8mW8XUTrHRDX9awaIEbP3EQQlrgfz9eZHaLxfTgafTqW7+jxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bTf6vlG+; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bTf6vlG+"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891f625344so45461415e9.0
        for <patches@lists.linux.dev>; Mon, 04 May 2026 09:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1777911457; x=1778516257; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PB0CX69KAx5rnBO+d/cQTMDVxCggaKTqEnwtGGRcSVw=;
        b=bTf6vlG+5UNGkvRouRg1/plfA2bGhjqXzWrk78GHij0it+1qBpdhzoVheYrwR/0yhJ
         RTUr17kwiU4aG6UH2EGKeKhpyuOyKMm4nPRJuAaEou2OCoIkxl9uIGq6gGmzQ4xLSqQS
         bqWH0/J4SqE2nzXlERSBQA7kmE74LwT367VEWMKNyAujezZkR3OReBzcPgDEyUsXFgct
         7JVePj0IUnlERhvugGMFoc99LkUBj9t8hLRMQ3hFYTVC2mULHbEjJhnW5gCMyZFLCvDj
         FchUTPFpzZSlgol5QiVhaWAm1MdZ/Kys6xcW0RwjBx08xLPoTwhNSLMFEFjY9WKq8FXi
         QBRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777911457; x=1778516257;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PB0CX69KAx5rnBO+d/cQTMDVxCggaKTqEnwtGGRcSVw=;
        b=PDOCi/zpHYmfr0GUPbzDO5mLwcm3dS7Zn44VugRsW3NYJLXvxOaTMl1LRhnhJwH+Kf
         KVOFZayh9IONGjZA3IgfKS54Ai90SEG8HMroXi8RKcq+2DseHjTZSXaeccKwfcJwDmP5
         YK3ZGySux5H7Bn7LVMPKEjOFYnJtCY39JhSrbvNXvdsGf7uM2wSJEDtS+u34Rj0fzKQs
         sfPGbZK+pExeKZIZsx8SjXwGKObDZrr7/1HXPLwYZhsDGub4iGl4y0TXGsrtUnwobygW
         oI9qMeS43mUL2uWrSCUhfxbsODq3KAD31si+8iq3SWiGLXgwr9TglQwgp73dwj/U6EIM
         ozvw==
X-Gm-Message-State: AOJu0YzsA1q7nzK7lNTm5DiVQ8HTvIxUhtcF9GfN1IOOPJ8f+FDraOjH
	4U8x9rpmb+JA6W52U++N/fvukIVS3gzJiwtLyJGXJqzYUdlYKs0bSRg=
X-Gm-Gg: AeBDieuX+w8ACDN5xMiCnybj/YVqVjG/0Cq6ryHCnMh56yQcwO38atpkrdIXsOXM5T4
	Nr9e2BKMG1vC9ycahfxn3eOz+/m8AuU7jc3ILFlTTyLqoOEGv5v+D6biseHx3lAcLT67aEbekkr
	qVTI1kUdYViap4dP1+wx8zIncwCEvT354WvWLZGH/yPhntTVGFT8IP7XXtv+eJWWqDgKacvbaym
	+/NTFEdZqz9rFFUHbPo9Fi9C1d+QruvZPS0CVCwGkUOK9X2hhiSdwG+ZGWY5guLdorNwnFxrp8c
	eOhAfpovRiTds4Ihb9U+3pdylCjSkog1AlHUmCLXnxDHRR+ShUlXfClDhrKvWXyIYKZ7nKf3tZd
	3Lif3BzrJfEN2pc50fa8gRNVcYhNY7OBH6r1N/0lzDnMziDfySSEsm2e6aoZEsn1+5H/7rp9VMU
	Io04vnbryfsfcp4TcARd8N4RDFJ7nFlPvHQ0jQHcHR43VqRw5nxx6TWnJZQQ+TCB6RIv5idqadR
	BlVhdMV1Gf2lg==
X-Received: by 2002:a05:600c:4f42:b0:485:3cef:d6ea with SMTP id 5b1f17b1804b1-48d1426a438mr3174505e9.13.1777911456922;
        Mon, 04 May 2026 09:17:36 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace33.dip0.t-ipconnect.de. [91.42.206.51])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fed8ea0sm143100235e9.5.2026.05.04.09.17.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 09:17:35 -0700 (PDT)
Message-ID: <aa485951-fcba-4e09-b01d-e586001e54e9@googlemail.com>
Date: Mon, 4 May 2026 18:17:34 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/215] 6.12.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260504135130.169210693@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 04.05.2026 um 15:50 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.86 release.
> There are 215 patches in this series, all will be posted as a response
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
