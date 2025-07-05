Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CDF1BF58
	for <patches@lists.linux.dev>; Sat,  5 Jul 2025 02:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751681312; cv=none; b=S7BLoiW5AwqSUBqP4yucBLlWUMdQcSZOrDXb4B1doZLkYn9cB3YOMF2+u6klo5g2rY4u0ktSGrGFxR7YRCX+dUZwkRIA6/iNXwRlg2KR8OQhxwORqmDRZ04yitOLPTWmTv9kB0ZzwKSA+LHELzfejLJphXLHEfkpoGZjkrTYSMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751681312; c=relaxed/simple;
	bh=be28xlpM98yPXvlNlJIYFuxj2Hb+eIwDL7/S1B/jd9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AInVyhacZYzEnwDqHQPDFECVRQkRGZ7JiUD5iWAKdNU9ehPcMs9GCqvsQ5XXZyxpMJ2LRLjOEgoDEf/8Xzlr02VCL0HPX+15ZOHUk+YAubKe9zUb3v1tvs8eVWzRDiVx3O6qeNZf1sDT/RqVDg8l3LL/fK1jNREAiBSAn1EAEBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Igx+eLvK; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Igx+eLvK"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-454aaade1fbso14864675e9.3
        for <patches@lists.linux.dev>; Fri, 04 Jul 2025 19:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1751681309; x=1752286109; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SGhOYIGfUjYOXxzUn04JCpCy8svnXrhg1yJxR9dK8Ko=;
        b=Igx+eLvK4DtE3tShv54WFdzGLfnjAcTqxAqVR7Ju8QJ5JkfKx48/6xRpffbjgfEMk4
         fq1amNWjTue5es22KOucZJ0buKPlU98GAiN0nR4vxeqKUUw4mqVYDA5hCJhmhMkc176m
         xMLV0wKVr8/GiPh6iK7VkbXvWvpv//6Ss6c1hWOfesCo9/naGIINIHaEbuYSW2BARViL
         jta5QRojhE1H8vVB5mC5rZmsm8jQ8QT0Q/ZGhPGLgHXuQml9rV2YyzaowTe2Gq7kS8r+
         RPw4saPzrgHpReS/ILR93MyN+5QEqvCckTeRK06KQn1U/ViSw+VHucZ8hXHyLFuZUsuY
         kdLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751681309; x=1752286109;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SGhOYIGfUjYOXxzUn04JCpCy8svnXrhg1yJxR9dK8Ko=;
        b=ltGDkm7VevTX3nu6RhSnJa3c5JSUxa2wXFuheP2kmGac03SJKRaRWnOoARgxwUgBsG
         9R1cnqyazgt99vrSMEcqnwOxxo+tKLZMtHjiyscht1Eh+v0PVC8Hx0kRfLHJW0Rbt5xk
         SwDfOWa7ikZlg+LmeN4J3ZRenjjsT5X88lse0zAy87FFzX7jIBT4u4xAoEPOPwIdTJNo
         uko4p5Rso2CxyakYwijbH2CV7ghphaQNTcUz/72TZGa2xNEM8XIj7ZIDQuvxMYTXAp9t
         rT19VjAoUhrzeqYcwNMhL12+QMiowvLDxcnON49aJJ5guTnvu16QL9uuL9VoY/PFxQXe
         f2Tw==
X-Gm-Message-State: AOJu0Yzd0TuPxOn7MydcTF5ZDVFFWdD2YPZLz2bpig2+DBtq1h4OHSBb
	5nftPRo6FgpG+plJTWxgje+C+pxrXvF7WXuGeirn4t+QNzZO8NFzaXI=
X-Gm-Gg: ASbGncuBkQHADeUh1f5LbwQMdReRjHitQt/gb88evcnIihBQMNYs9kpevdwFIqamt8n
	2of65uGwXBX4Tb5mLxQe1AlMCUQvEAW3BHzu1LBzqjEouFH+jXb03VeVtAkT0iwH5wQKVRAZqSY
	7iZUofXJO79Lc7A2tk7dB/XTW80Ysh0x4sMd2k3YZPTqSFEwmW7UD77gGsqEJO8u1F0JznafxYA
	V39mdsTsHDLI9FJN5KT5YIX7asVVYuvDvadkJFb1KrqQuuMTBpy9L4qDBkLRb45YqXE7KgO9tUo
	1ELQDgPX4n1Ip8B4WPpqRIj7uXrS1zPhlxLj7GSJtxn/ocPmVj+Wex7EXPdvjvyLqzdNd6LDS1e
	HFWkPCGW4PWd237fc5xfat5ossKK4GrkvDdFo3/c=
X-Google-Smtp-Source: AGHT+IEbwwUIxygLV+74Mmp1gwA1h8iRo/H3pyAhARXfAbRofPKW0H3SBzS/dGS+OguVGTTf2uf8sg==
X-Received: by 2002:a05:600c:8b0d:b0:441:b19c:96fe with SMTP id 5b1f17b1804b1-454b4e79652mr48274335e9.10.1751681308843;
        Fri, 04 Jul 2025 19:08:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b0570c7.dip0.t-ipconnect.de. [91.5.112.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bcef22sm71166965e9.19.2025.07.04.19.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 19:08:28 -0700 (PDT)
Message-ID: <2d467b17-ef4e-4473-8d95-80217fcb6ab7@googlemail.com>
Date: Sat, 5 Jul 2025 04:08:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/132] 6.1.143-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250703143939.370927276@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.07.2025 um 16:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.143 release.
> There are 132 patches in this series, all will be posted as a response
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
