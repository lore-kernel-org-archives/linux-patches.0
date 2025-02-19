Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9A71DEFF1
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 11:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739963910; cv=none; b=Jl/ZKgsQs346OFJzVitNo4OytPRw18Mzlx9pfux4obpDYfM1FUPWXbfBZ1D9LQR5le/uGV9BzRZ1/tKfkWdfHBVHqGnsqJn96XymhVs6SJu2t6DhM5pkiAha3WTQE8I8eK1Nmk72YO2uBZos1sIRr2ZSaBG3W59Wq7yAIa3JAi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739963910; c=relaxed/simple;
	bh=40mCJlvF8cko1+OgcezwWGuKpQJ0u8WrathRhG8tZPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WApSEx1rPyj34izQUr5DXT9CasjGvs0Oj9t1YZCDQDFBG3dWppys7WrYOWLV/ry0puUwDbXJMq9ihgnJJCKB2Ke/OSe9pJBOIiN11ERBoZ/yxrFR4vpXME4gvKoGwDFr0BQ0ZZXM5AQmq6Zx9nyzfEXMm1yGNEqR6t2YwTReef0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=DdSeynie; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="DdSeynie"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-38f2b7ce2f3so4331276f8f.0
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 03:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1739963907; x=1740568707; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7nAXyqLiQShxXdHExWOGFHNht5Zg/ZSArUtFxZtpy/s=;
        b=DdSeyniePtq9qjLwPFgx/CEPmwxjjBle9N0iaH/fPe4BVvLBi/x5tJzBdAp+QzTWPk
         N9+h0kmxGNK5PwBbYjRKxQ1Pd1XgzTnzQ31XD3JcrTjwFzQwhm+y9X4Snj65WX1F+nbH
         05+FotWIL9F6Bau5lGsBykcGynb8AJKVHdQeVpMph06vCNBAaZLhC20Y6IYAujjsACpL
         iVDTGHRxOsuI/ndsRm8/lWfncWBUA4WX9NXmH1l0X8uY/c4OBNe2nxb5e8Dle6d6WeSm
         skxvE/WJ5dxf4cGM7SwZlNXBclcHfQL3aC/4gc8eZ5Y9doBccChS33oYgBbx/1fM/9OM
         dUJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739963907; x=1740568707;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7nAXyqLiQShxXdHExWOGFHNht5Zg/ZSArUtFxZtpy/s=;
        b=u3UaXlq0ZOQ0aT1H5ktudGhT9PYr1PausIWmdAS5b65BAqkYTBnHNUAygWvl4LtvON
         V7443fDwBDqFERSHR8cBYihnvNogMrvIEsjoz/UqOt0RAY2CbGjuNwJE2PLBSMTizQbl
         Rl63PYBHmaPie/AzHfTCF/arsE9V+8+akpb8BKa/Tf/Mv1Pz4uPeRIpXSO9EhzALRV5g
         KfJkMv0etzqD33LBU/AKawcvlOV1s3DUuFe7R1phNTl1S9Xpcr9gjjTdVWsXGMy3PJ8C
         2RubZ9xe2IcOcpCzEcZJeX6oUOQ4/57L/adlydlqr/Hw9Wa+GFKUWQvWbWwYO8X5RT3A
         i3Cg==
X-Gm-Message-State: AOJu0Yw/TDzNeEHyEzgGQSeFMpgtfUnWVdTS8wcV6WLDl1YYxhiLW+YU
	GxPtHRAFHIZ5fHmYIYie4trBA+s5Ph3TxzTyHHBumCGT26azXuQ=
X-Gm-Gg: ASbGncskJESuTRb6exPwSmx0dTg0w/uBwg258D4qQ5Mg2oWDpLg1MtXqzRJRBlDhB8L
	Pp5q5ygDZQzYy7difiNNUy9fpqNlZoE5fMruFAB/xdSlMfKtKNBJycsvjr8G48KSbTyoVSISUm4
	HBFAOhCrZRXiwo10cs1vNCJ55lqZ542XTX/8zlio1MqceG2+Z0bG0TTwLHf+raD7cIXk8DmPkjy
	Hei3EFef5ArPgmD2JS2cQXtvgcRTIFlnnNHDC67qMsgf+4vFGXZ3iSmW68f1xQuc+xx3BL6HlJB
	gODw4SHQf/l1lHvvGbXzMFwQiCsJa2E5KZHdyIhU5nVpkmKpYDX8iIO5COxWiqUKrGJS
X-Google-Smtp-Source: AGHT+IHqSbU/mySv08zQ+ZnfmJkUguL9G8ebWxSbh5QnTnV41gOwaEKyh41mQEtSGCtKswwMTupuug==
X-Received: by 2002:a5d:6c66:0:b0:388:c61d:43e0 with SMTP id ffacd0b85a97d-38f34167d68mr19545175f8f.48.1739963906782;
        Wed, 19 Feb 2025 03:18:26 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4e7c.dip0.t-ipconnect.de. [91.43.78.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b434fsm17819691f8f.16.2025.02.19.03.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 03:18:26 -0800 (PST)
Message-ID: <7a077c71-e325-41d6-8cf4-d3fa8827e51b@googlemail.com>
Date: Wed, 19 Feb 2025 12:18:25 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/578] 6.1.129-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250219082652.891560343@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.02.2025 um 09:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.129 release.
> There are 578 patches in this series, all will be posted as a response
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
