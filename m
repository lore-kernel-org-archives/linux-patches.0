Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1A914F108
	for <patches@lists.linux.dev>; Tue,  9 Jul 2024 20:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720556843; cv=none; b=S+NSgChx2PK4YtF3WR7MgWsBmnUv4sfOSiT7fiB0HDFrLlBkdFVBv5UvNL76GjAcLINiQQqPU9RP7yLeQsYtkP4RjcZrvsVidf5oPhUZx4adfz9RnK37IVQE4NSjgKK5xmCt+onGWU1fOMgI0a5VqaDMm0uRpyoGQTi3rJR7S3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720556843; c=relaxed/simple;
	bh=Kr4XmoNdiq1x+7Cu3wngyAMQNWraTKt0MquCs056Yzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X0POYIpEZPqoYGiNUdNlfAv3UaKv1j0VAoz+YbOPNahJ8gzLkpb8oqV2kJNXnNaNJamWgPIZjh280mps+njDUr01+QVIUjQ/FJq9YPlj7ljNcmBtRRQfp6T8w+NdKwetB+OcvHd/UTQ5kMUeozayfqpQfUzrL81mt1ZmpBlDTas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FiuSeDNc; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FiuSeDNc"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4277a5ed48bso1892025e9.2
        for <patches@lists.linux.dev>; Tue, 09 Jul 2024 13:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1720556840; x=1721161640; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Go5tn3E+fiaOV5LrSumTLE44aCs4A5PSxIlDDqGg1vc=;
        b=FiuSeDNcNhXw84vuVb4ki5Dn/phbEN4NjEb6VDyx+uAEHo5oHkn9aoQ1CQx/+wsM2w
         j0geQ3+22oANIlyHH8JG8BkbezvfnMEiMzjmHPHOnq9Mdv5Ljv3QBg4TDLZgMRbrPIWS
         Kjata3BslBruEy05RsElY2GHwRpG3zdLLcx6fCzEow7o4wmwhgYFv43bC+sF9LdDOz7h
         WS4qBLyYWoBrtPcRfIUjXnOvq54sJjvULbuxeJAMiuFUivrHzxd4iodHBwW4Df6yIyov
         x18biQpinYPq484CxLUQsMeNu4gQc7MnQEffR1xGRuew+6CCNKyCtcxC/gyX6B+REkeF
         ZqUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720556840; x=1721161640;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Go5tn3E+fiaOV5LrSumTLE44aCs4A5PSxIlDDqGg1vc=;
        b=vAakLE38I5i599K04D01DpDQXsDXXmJSoSmNFa3q5ZGPRxhfihvLWuvR17bOAFhY94
         /ous7jKfgsJlEdU2LlKmUgs50YbDBWbTOtMINZWMBQENi3pGr5GvnT50mDvLyCymcNXP
         ppWAZapAmIz7zmHsPjWnt6BQ36GXpA3OPk7FWnNw2b96usVXvMHBchqNgZjPLxNMTF+l
         /r2TRHesMtzhuJ8/uyy6vs3/ZsQuWwmXzg2vyVgWHZE1wTjijC1pLI5vvV4xS4EvXwLT
         p4aZuQG2gVp0tChbdNjFHaMNZVMj8aGGnFvshjpwSvZfkHELpgRizDcU3B88BDVPQhwo
         kJSg==
X-Gm-Message-State: AOJu0Yx+HpN+2dIDwOLcJ1mWdO6aQTtl5o211s55NLIFIbABSVdss9Fm
	VoG5aBAdbla5VbgTquL/HSE700GTOAXJsXKqOzbBd/8h8oNNSP0=
X-Google-Smtp-Source: AGHT+IH7KbG3a8D4KEZUHKMnCt6K7piI2wcUDaPBqlwlWlA2VzZGH8hneeif7F8LPtb4Iuq2M/whlw==
X-Received: by 2002:a05:600c:42d3:b0:426:5546:71a with SMTP id 5b1f17b1804b1-426705ce6f0mr23477575e9.2.1720556840270;
        Tue, 09 Jul 2024 13:27:20 -0700 (PDT)
Received: from [192.168.1.3] (p5b0577f1.dip0.t-ipconnect.de. [91.5.119.241])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42793dc2bcesm3020105e9.29.2024.07.09.13.27.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 13:27:19 -0700 (PDT)
Message-ID: <89842487-8e2a-4958-87de-207068471a6a@googlemail.com>
Date: Tue, 9 Jul 2024 22:27:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/102] 6.1.98-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240709110651.353707001@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.07.2024 um 13:09 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.98 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found. It ran for an hour now, and I built 6.6.38 and 6.6.39-rc1 
with it, which I will boot-test next.

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
