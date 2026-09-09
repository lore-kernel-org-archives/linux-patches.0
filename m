Received: from mail-oo2-f43.google.com (mail-oo2-f43.google.com [74.125.231.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B253F45D937
	for <patches@lists.linux.dev>; Wed,  9 Sep 2026 22:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992623; cv=none; b=Kea7VBGjvfnvxoei5UIy5ESCq/B22faw8qLb9O0c5v5WAv2+i7Jv847ql8f7BIPQQzamWAvtL0wF3eDtVfSKeMnD3343g8C547JzCgHShGYExHIfmtvo2mnMVP5iIunu6cQ5FJk3D6gcPzO9szavrCLrSChKZz+ahpgz3dh+dG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992623; c=relaxed/simple;
	bh=jyZXnNk97yXcYJ3VFSCOyUv/maueSIIrc4Yrg9UCJBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qamAJ71MKJI04HAH5uUXQ/3ggTqEqjLDY3i46wjHAO1J+JM/vfBW+l2aixOJOWfYu56ZL8kVVs3Hzkt5MWNMnezEjpDjqmoj0yUdRfm5oGEKk8r/IzFpy070W4lkyRNADdTeQsDV5itECK9e0+TApwn++rmz6W+tnVaUq6dcGj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFyboE6K; arc=none smtp.client-ip=74.125.231.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFyboE6K"
Received: by mail-oo2-f43.google.com with SMTP id 46e09a7af769-7f4f0c89e34so572171a34.1
        for <patches@lists.linux.dev>; Wed, 09 Sep 2026 15:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1788992620; x=1789597420; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ij5mdruxx0QOfzgtgcdh5/VG5w9myB0k3AU4Kebg3MY=;
        b=MFyboE6Kh0afAhuB1Ckq4IasVIR4c1kytQs4Yqh62DtS1S38uxJ3THKN7TMEU4gVId
         VYLdlbMnPGCkFWfj1slPi+9UdQugN6+LJAL7g6XJa0bHLPrsc1n0wIsO9gNSEU73yAxU
         pAq8y+90VeY+EBTdMQpY7Dn/0ohhaVYKBldCQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788992620; x=1789597420;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ij5mdruxx0QOfzgtgcdh5/VG5w9myB0k3AU4Kebg3MY=;
        b=S1X/tko8f8QeyoQtrZ8A87SazRCC3/EaDnob2nttzLYGPMsOdOgi0StZ46bc7IYRgR
         INU/nwySzWadiLBvw8qm2AwhEnyDV8JVZwGn4sxRY8/RFhpTi1TTKVuZ/O7wwz0ULLwm
         IYEwsN5XHIdm/mlm++xQVxf2KpDoi+yrt35xVoFkbsAF231qyH/dX3FlxrZGQ2UyL7ZT
         qGbmH/kyXkgctXBEmZsdDtip8VX7+3fPRO7PMGcPNwI46aQjCR2jAN2NWU+bL2zVK+yu
         5bQ2eU6JnGJRDrzFR5iKjxgRNrPb3EoOnkxp/1a2taC5RP0OH5p4PZ19Pzj49krhUdfB
         qCyw==
X-Gm-Message-State: AFuF++kyq0g8ZsXjk5EPAczZwk5JnzJuQfsvsgrad40Z0VDHTpmUurva
	WK+slyw1bHt2t8dxqMMSJQYyNxpqB2NgR+z33S0fPoL+ev9JTGjp2vTQ7tyJJe9TzyY=
X-Gm-Gg: AYBFou0nMEopPJ0QD2mz1JciebsvuPj3bYvgvzxvyWoH+CSfJE4qf+k5m76fQSWd/Fz
	w4WxDBAGj9e7dvUlaWQCJwOU+26NDp5nMPhh8fZwX0+z+G+UK7LcBWXenp8FhOa13uFkp3Ftesg
	GMgBX+M3/a8iL3IJ2oIcQhMOIkOj3BUOzCAAeRWrqguRTph1vcSREU6qO90FHNVeIKmyhqLmq64
	qTOhClXBI5KmZA0l9CBdPQnMsh26CZ1YtRTJ+et7Dj3A42i+YtuLKzNtiojf789ejZv/jcbaBKb
	AJwNGh2X6J5aLsqkaQsyTy2HSG6QEN1YB4e2Rcn41EgIKf62QcPmU86dDhE63Dw5Cos3MpaaEuQ
	0YyWoceVNOSqFM41jD0DoAZLxlH7cumpXjtNsFaOzxDGQ9iwO5ojAvIj3psUyuiKdk3KQTzTFq+
	6qNnuUcdi2NrRlDa2XTop3xsDnA3/fUxPDOpT/nFmZjQRUerVLJ7w+NCjKez28ERcxxDq0F/jM3
	3tuz8T8
X-Received: by 2002:a05:6830:6404:b0:7eb:3af8:8c09 with SMTP id 46e09a7af769-8020daad7b4mr3472081a34.3.1788992620614;
        Wed, 09 Sep 2026 15:23:40 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7fcef193dc2sm12594318a34.19.2026.09.09.15.23.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 15:23:40 -0700 (PDT)
Message-ID: <8b138fb3-a5c6-45b9-b881-1c4d76bd1921@linuxfoundation.org>
Date: Wed, 9 Sep 2026 16:23:36 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/583] 6.18.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/26 07:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.51 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.51-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
