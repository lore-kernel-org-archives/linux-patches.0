Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4D6328B6
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 11:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723894864; cv=none; b=t6MG+/Am/kxoVOuoVy9B2kZ9rxv9D5u1vicvUDPJJ70K4DK2P9yZprn2jJLn2OosJ0dyqL6A9RjC2ObdGHDXhwZoMuFOsiPoGD8n12wrj0N/z9DgLtpwLkHhg1zYT7+eZrGW/EvWa1Vs9VEZlbYow0d54e3RxjdHwNeJMTJkMug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723894864; c=relaxed/simple;
	bh=pHb1cd/bM5HAeb2aNJlmyYZrkZZKm2iDpqq5ciaa690=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GCGpbBJ9JzWCR6TwOQ5epwcg/r3G/wXq73CDRg4cYwQevBnrRRiXZgLvvQVX4DD2sZyu+ijMl8EVcfze5GJacqlay7V8OuMNpECDCJ819cMQNeCtc18ZYB5UkGrGSfRnGkSTrL0e59f5ZtUqDz4iWfUlTwjSPlW+OgAVRtvgqgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ma/oGxCu; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ma/oGxCu"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52f0277daa5so3718315e87.0
        for <patches@lists.linux.dev>; Sat, 17 Aug 2024 04:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1723894861; x=1724499661; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vRpUQui6KEL9xqbOs0Ea/v4MaqiDAscFoJmUDj6bZgo=;
        b=ma/oGxCu+lnNg2PZuMS8fCitUClORK26aW3s9/rYSjBsPuyvBnJHw+RZVCykw727hQ
         KZDWyUPqFRrPfT5HJTTqYJCBOJQx3/H17hzwEW7r0SO4S3Y01QhkyzNOG9U91zbDmeft
         xkT71LlZ/Wk9szsNevjZWbkRrQEMxwTU2WDH0Rs50a8W+7VNVRboTE6Q0c2KLHOABXmQ
         fWFNDcUW+UWn6bKAeqDRBv5BVY5QRsS6ieVn7YQ6gUO+S/xdoYszPuRWgFMwx0+lsmUM
         /Ynlsl4bI0pyTWdhrcDqpRDVktGIrP/Eqga8XZ2S3VuvN9rQUv0jMu9QpLj7VYiWgkYZ
         aDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723894861; x=1724499661;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vRpUQui6KEL9xqbOs0Ea/v4MaqiDAscFoJmUDj6bZgo=;
        b=rJaw8V2MakOheGAjnYHbMONoc0WSHkHEs5r+FPOrWxZvOipvXiw6BXhZBGLVLFjBIm
         UjwxTnFk9PxcFlQXaj+pQtlssbCCHVUHJwF0CHm49JgvNqtYskuDMdQicCJK07vodwmD
         vT/p9e+MYz4xqvfTBxEhh38M2JItNnCiPts8j4k2yDuPZrobR0+hWPCuJYDGFAm4LFGV
         ooHgWxz6qkbxDA716NIZUKrbW1JwXhFep6tE7TWFkMGf4SweQeGfmVsX4MmIVk0L/uQb
         bxWWdpM/hxW7Gdff36l6rtcsxHqElbxuZMpTmryEoLMHZ324av5hvYZcZ8U7wPmlELbw
         HyaA==
X-Gm-Message-State: AOJu0YyHBBJ1P5uE+GKJ728vAeIrcIiBhuYWj6ffeWcq7g1hnTaPqP0N
	GiBEKJLtP/2Kd3l4cyU7MUv5D5Klv1KryMVyPAycmkAjyD3Cw5w=
X-Google-Smtp-Source: AGHT+IFRrGmUNhCYwUr6r0aNdaQyrpw2Zl2kgseXIhOIL4K1vn+dS++NFAIzpV6T7Gr+tD4HzXyacw==
X-Received: by 2002:a05:6512:1081:b0:52e:73a2:4415 with SMTP id 2adb3069b0e04-5331c6dc95emr3852777e87.46.1723894860555;
        Sat, 17 Aug 2024 04:41:00 -0700 (PDT)
Received: from [192.168.1.3] (p5b05713d.dip0.t-ipconnect.de. [91.5.113.61])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5331c98c77esm622664e87.250.2024.08.17.04.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Aug 2024 04:40:59 -0700 (PDT)
Message-ID: <886e729c-d3fd-432f-8fce-6f6926b1fdbc@googlemail.com>
Date: Sat, 17 Aug 2024 13:40:57 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 00/25] 6.10.6-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240816085226.888902473@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240816085226.888902473@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.08.2024 um 11:42 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.10.6 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Now I'm a little bit confused. I saw you announced a new 6.10.6 RC and I wanted to 
(re-)test it. Your subject says -rc2, but when I git fetch from the kernel.org 
linux-stable-rc git repo (which I always do) what I get is -rc3 from today, however I have 
not (yet) seen a mail from you announcing -rc3. Forgot to send that one out? Anyway, -rc3 
is what I tested, and as I already reported for -rc1, it is fine on my machine, too.

I tested with running 4 QEMU/KVM virtual machines for an hour, and did not find any 
problems, so:


Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

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
