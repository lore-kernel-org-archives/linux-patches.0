Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B08D1DBB2E
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 23:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529501; cv=none; b=ln6K08773dZGm8mKf/31JCwt3PiCmMDeZsRRIgm68/GmiR3g+1nSS1sCnrB7GmF16u/vqtyjN4CuwmGSvmyCSRdfl1fkqrgnj5s17GorRqZLKPqe2xSwtfMbzlEkeU7ABMr/t1Q4cH6jaGlLI2CyE99o+lO28nYj6igSBda4Nlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529501; c=relaxed/simple;
	bh=NP4LB1TdrbwYoE/qGnK6kqxraStnmXD2ZB0lHgcUg8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EevxqQK7srr/ADrlg17utMYqlz8OdBnL0lCxwG65N0hI6Vi0F6mfz/2dSgdOxdVVR9HNRpY0gkiiZ6/q5MzbONpayYQdNu00mjpAtzTTCsJCyVPc42skcPbOubO+3D5U5pW0LpGhom73xnWQki2G1/tsWwvkDwRdv6J4mO3G07A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=EST80zgx; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="EST80zgx"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-434a45f05feso29104415e9.3
        for <patches@lists.linux.dev>; Fri, 06 Dec 2024 15:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1733529498; x=1734134298; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=joUDrwCiOf41zwhP9RpIICtMQhuen0a1v3beKVMGZQ8=;
        b=EST80zgxB6OrhAiFiYcJaVF3GKF17WDZ7fgdAMFj8ToE/GPp/0EWsJgvF3jr74HDL6
         9PYNicNXw96mR4hlQJTxkNgvssoZI1vMmRqCagWdJkX+dS+uOZBWUCOqrX0KDL6pWdis
         /EYvzD1dyO3w0POGMjqPkPGLiVIaUmzrXX8ijJoVTXCcnfIb5xVnQqu6QEKyNUHunQ6p
         pfryy+0gJP0PHiqutlzv+hexrG0ppqfm1kZbseAWbtakT68QL6rUgTXx0Vt/EpfWyPlp
         E/xRqhu54c1Ghq/4PaOWSbYa71xJ6ZsSima4FlyBByvcMZBURAFteAmeHTLqcQeahaJM
         IVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733529498; x=1734134298;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=joUDrwCiOf41zwhP9RpIICtMQhuen0a1v3beKVMGZQ8=;
        b=r5Gv94SA1YJDVEMCDiNbm+G5O0OauQ4xFe/vT1Iym/aocwyXGxNYbaL7aE7cTnQWmF
         NT6Owh2+xo2zJi+yjD/nTJCHlRBztb9GKm+WYZkZqp1Yf3zZzk/2P3xXw95p7OagH8zz
         rot/BY7HRem9DvDpt9LIPbtbNEnIowVDBYjN7xa89F3t81xcHpqlPKbZ6Kw/uaG0UAcl
         pnQXBWyS+V/PMp7UeJBycy1W6jo9wBIedPtmEL2TVyswBZtUciPbQ3TH18IJ1YPdrmIW
         JBOoN4H+84Q7ChtbCdVyk5IzD22kFlNx7/p4eNVf73bqK0snkPScnGB22lpOA6wNrHNw
         t1zg==
X-Gm-Message-State: AOJu0Yz5BVDsJ2ksaSwJvNmagPTXj9jr5QUIY3Km2pRrMMxFzTqT4BWP
	6KESI4OP62lciRmVstAqJ55kPjs+YaWulG03zEESKG1V0ywYSlI=
X-Gm-Gg: ASbGncv/p9xk2WiPKuQvCkwZm50V15bQbZtA6zHw4QiUU9ZydeHIf+cnHoPB+Or9q6+
	VkdpRDpHXtyIRf7fPcb8DXu3jhqPoGqY8nCA7pYToDxGoG5HALMhWzCzYcuNHriVYyDLU4misDT
	C2Dplf2wvk+KAUdcgY6gQXC48IbBB0/bYc0pzbX1Lt7O6qHMgoLsA+cVBPcNH3LfhIXWw3OM9/t
	+pdxP5ReRCu1GhXSOJkdvzuQWJ3Nm4kbs5VAhh2JenqmtVM9Ji2ZzJCH/JrJN5GdB211Sl5YIrl
	X/eIJ0MTFy39msaxPmx6mYyu6Q==
X-Google-Smtp-Source: AGHT+IFPmPx0Suf2weJBJcMcRL2iILyN9EfWHl/6GUyqeSE1eZlDPG8bTqZUZM0ji+1N6Jg7lfCWIA==
X-Received: by 2002:a05:600c:a45:b0:431:542d:2599 with SMTP id 5b1f17b1804b1-434dded8234mr43416955e9.22.1733529497395;
        Fri, 06 Dec 2024 15:58:17 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4e5c.dip0.t-ipconnect.de. [91.43.78.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434d527eeedsm105792745e9.19.2024.12.06.15.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:58:15 -0800 (PST)
Message-ID: <b5887a1a-169a-4772-879b-fc4934acaf32@googlemail.com>
Date: Sat, 7 Dec 2024 00:58:14 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/146] 6.12.4-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241206143527.654980698@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.12.2024 um 15:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.4 release.
> There are 146 patches in this series, all will be posted as a response
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
