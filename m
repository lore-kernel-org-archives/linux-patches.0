Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BA61F8692
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 21:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743023909; cv=none; b=Q4arIpvHnSEQteQkpmvN/R4/Xoif/Hy8F3YKH4QzWnT0vcLyC1YbYZM/oFB7UBM+Mp/ndafEcH0h8rICp5Uf0jKQhlhcKstF5K1rirQ8zRwVLDK9TslhJZnPrJDW2A3JyRVFaNQiWLwOjWCLn0J2utljXuAsLBi67kg+EPFa03k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743023909; c=relaxed/simple;
	bh=EtebjioKBAjwwkcdb6cdmvmGljQ7daTD04eDyBOVc+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PZkqXBPmX53FYhFB5QAgYqKDZhUv1x1AMzn7k1BUiFFO0fBo9YzuVJI2fMnlHAcCjiHRc+ZaDTVxfj7HoDHtMbnmqE/CuJM4F21GYWXD3BuxWdw6rudfURB/6qxDUuc5YmnVUfGltM40VMcoFb9bo+gpjJ+bcsBAPYMxCnKWnjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LDQ0czHF; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LDQ0czHF"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so2731575e9.3
        for <patches@lists.linux.dev>; Wed, 26 Mar 2025 14:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1743023906; x=1743628706; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K5aDv4/p4YZ4hvd0+24OMdNG2SUNxl+JoR75kjs+xoo=;
        b=LDQ0czHFZUE8VJVHdhwtwzTG/clgszylWFWVXD092Sy7YOoqRdI58jU/PVBzosvOe7
         suijK6DiquszTuwv594wpwVDwwpwOm3vqGZsHE0eZCxBsuNhdWIEPcG9ejLBIaeqIhHR
         HgcWo5K5cCVI3VEHFTE3P8nA3sz2UEldrjrIObtSsXWwPfPtp5BVTK3EJgOEjbR2e2io
         yXIbAieQr69I/FYeZVdYR/MMQe9U5NIYPMolGVeDHzYMtxw2pNQYOdiQEoDy48M1rsiJ
         Yku6kXYgjQf2fzJhsjOurwmT27C7oGD5EiaYO+Qanu9xQg0V6KZ3RIPLoTJgugp2H3GJ
         pLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743023906; x=1743628706;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K5aDv4/p4YZ4hvd0+24OMdNG2SUNxl+JoR75kjs+xoo=;
        b=V/Kq1u+GGLya/mr/9yMJ6yOB7LsIClvUxqt0pFL/odJwf7N+ZC4QLp+SAuI6bKdE1q
         wAiHeLfh4gXOYcuhkIrvpe3QdfhbpYNkOcjMcJnge90r6yUqO69QpmsRUSuaXK9e+hfH
         I5MFFHCaBipeyxU8KcHxNtexr1GiJBfH5ectRcFG3SofTVOwZuqZP1O+sAFu7XIumMda
         VbKiwlKiSLXf1ROitNxp6H9rDbHa8QHW/gd4Gz/UiemUOBX7Fn7tKOR9ZZdTcjp3DVJU
         EUheNB6A+rAIOcgizsoJXQICDKkvSpJkziEkeUpYImlc6t8oC00tFqk1zBSVAPVA5WF+
         Hucg==
X-Gm-Message-State: AOJu0Yxakz7+u7hN58PsJmQcE3sYdZ5CEdaB2dsi2rdwGURzcp5SKC8E
	EFae40EtcYIDKco8IyvE8dLYAnPp3Zzr8MIfhAW1N/98tLd9qP4=
X-Gm-Gg: ASbGncsnKFJRUWS2ibviXt/Gou2O+uHRbj5D9VSdGO9cLdi8TPD48XHj1NqYOo1wYh2
	ahTaUKGw95U0wD8x+TqMSS6h+vSuEcBFfjX4Qgfrs6tFGPHO6oHQ226GHN6anAuOqV3xlisFIbh
	4Pe09yQkOd8djFbKHWbQjY0Njvmm8kHy26Sq/WAcT5RCYs4ilOXgkfG2i+4SkQCcMQksPSHooAD
	v4aPu0h9jjzTE7YGWflmc+92mw9cB2pnWH4aiDL08g1mJzdfP3gtK3oCB9ajRv3F8wZASVYvurZ
	KTumgMu0sHaAJyJvRYNM0rtSsopOosZajyTRJ4Pgs/gtLnrUbWRJ3SJtpa2QyetQaYr0JSTO4qP
	R0XLM6g7a3FDR6CvyWMHaCMrpKi4fK0I=
X-Google-Smtp-Source: AGHT+IE5XCCVhPuBcalvEhMCh/Qrz+4i7AieIwvdyBLJ0b5CDmGEn9c22Xv5qXdYHR7I8Um+eZ+FYA==
X-Received: by 2002:a05:600c:4f44:b0:43d:94:cff0 with SMTP id 5b1f17b1804b1-43d85065900mr8185345e9.19.1743023906123;
        Wed, 26 Mar 2025 14:18:26 -0700 (PDT)
Received: from [192.168.1.3] (p5b057a21.dip0.t-ipconnect.de. [91.5.122.33])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d82e834a5sm15499865e9.13.2025.03.26.14.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 14:18:25 -0700 (PDT)
Message-ID: <5d15f324-a848-42e4-a008-ad4b466ff841@googlemail.com>
Date: Wed, 26 Mar 2025 22:18:24 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/115] 6.12.21-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250326154546.724728617@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250326154546.724728617@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.03.2025 um 16:46 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.21 release.
> There are 115 patches in this series, all will be posted as a response
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
