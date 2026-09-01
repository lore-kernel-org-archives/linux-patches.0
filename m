Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0824D3242D8
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 12:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264401; cv=none; b=PqPeOfqEdZKI2ZTsnORtSmK7e3m7bz8xsFVT63Z1yGmrWqUcFAKizo71Vg8vO/wbfSa2m3Q5Gy2TVmlX6WbnF5MlGAXTIUEJUGnnf9wF8acQ27phz5XLD7h22RmKKUfFY8hwr2bmgX6c0jMsbkoEPWVar72sDPzrEJrRtu4bIOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264401; c=relaxed/simple;
	bh=5HWcCIL4fHBqWvcmdL83t0KPJjnu5DmgWOGGa84lqjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TLe3ofCMKnsU8dtnR2MZOKLmhbEcgXCY2mQTq8WVgY9IsUpL7CcZcwya1qsXDWZhZDijU8NehgGx4P5gTs6IbYcqJDigFzj1hjZqRlhHMO7eqJXcK9AFHLcI2gq2vh718kC0o9Oe8WfOhquQzN6Zcby2I2oL++RFIXycnJu4Ync=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=TVsLAmdL; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TVsLAmdL"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c259e5c22ffso355530666b.1
        for <patches@lists.linux.dev>; Tue, 01 Sep 2026 05:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1788264398; x=1788869198; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f4eFl6qx/4E0gORJGZv7Bh7G1mDGrzGno8aGjAChFm0=;
        b=TVsLAmdLpVBLllaypHOSw1syUYSSWx1a9o/0EBTk959Ez9TVzOdA+Mh2SFeZZKM0S9
         6uI3gHVlx2396SlKRS0sIdO/MRnSLc6czBurmo7zecCld4glrOgKv6BrVESinoV84KnC
         Tsex9mvGcAGKD4r2aW/saYeVci9Q66hCGGQCiWe99GeqRf1ikjT7X5Q6gAGtMrqIzs9Z
         B9bq2UT8gxc8oLK60wI7gmpZXwmUCG7OXROfzxWv85amzOi+Q+99PWk4zg5UdF2fnJJT
         UD5f5NMck9P/JkCjxujGvy9WePcQufDLjo09ypP0enWIUdUGH+PFN3cI5vOVDkY0qktC
         RknA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788264398; x=1788869198;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f4eFl6qx/4E0gORJGZv7Bh7G1mDGrzGno8aGjAChFm0=;
        b=OdYN51aX/UZvbNAZMFR+WO7jBTdtlZC6i3Ld6/DsSO1oaMLi5GWCfcu6zdej9XSdqi
         ZvZbHNR1yc6NRDRMydjW12v/leCquM2GpQSBNZTndG7P7gC0t7bZgEVWVE5uC5sVZcfw
         lVk3yQt0pwv/Ce02NBTiA+ulB7lND8INB3kguq+MUZ6sBAXh/FkXNSmRzXXxlfGIjMo+
         Udgj20umB09fUGkijXjD1z0FDFTO8nqnBEL7kB05fxzkhmkqJdQiVUoG8Y2q5lPZBTc8
         4TcdGG20DDCrEq2Frr0abc+bkxgFkxSRFnArHeTke8xpCQKButM6Q9FitPAIYZTIyNfG
         VyFg==
X-Gm-Message-State: AFuF++kyBjLE0xdn2LTmisNy5F+ZExerm4tX+3CN4FUFa9NPI8rJQvwo
	P0iHPXmmfOZUv6YCw7cdYj+YBWSktH/7+FVI1CLqggITLWBxfXOjDwY=
X-Gm-Gg: AR+sD125IlIA+OuY0eA28g9Va2Mg3RlO3W0Y4FlsrqoPqYAUiEEekl5ocs9dItNrBmW
	+x4HheiyV/jEubSsZuOuyLf0x01txBGW0HiDSN/fCsX4UfPnzEEiV3hEiInJ4K71fNpsjQ6Pj1Y
	5C7Mpad2rzDVAAFygoxAzb4YR+nsXn8ECN9IxIpuE3PEO1tUbvbXvizFV3lIokx9/d8E62X5U0K
	RII7n7rkfqP69kpto1RfuTed0Hl/OQoA0pS1R9PnrSLDEZezApZotT0LtKASzN2aOGZa5c3A67M
	EyvXQWsD2gRhdL/FFj2+sypb4z+6llt9wC/z9qpwe9E6EYgQhKchiflDokxJLp6egnaKfcw83OX
	+FlJ31WOidG+r3uqM67KXWHBFQGlBgEs8hCuKyNy/I8Mrbp44gyc2kO4ZOGshWONNfCyyNhXZTK
	sJHARa6iNGNBgg23BaK/FWWeGQg1QRI9jG46A+iDn89BGflvCALpDQLdSoh7/l3p09JYPrH0uGF
	MkA5vgnVbY0f3nZTLPfzdZlkHNOaKkUo2A1VdpP
X-Received: by 2002:a17:907:3e28:b0:c25:192:99ee with SMTP id a640c23a62f3a-c2557203984mr2039838266b.19.1788264397984;
        Tue, 01 Sep 2026 05:06:37 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac7f5.dip0.t-ipconnect.de. [91.42.199.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255f1fa3ddsm560432466b.45.2026.09.01.05.06.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 05:06:37 -0700 (PDT)
Message-ID: <37339c80-2809-4dd8-afd2-4a5e5698c3af@googlemail.com>
Date: Tue, 1 Sep 2026 14:06:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 00/76] 7.1.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.185608553@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.08.2026 um 15:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.13 release.
> There are 76 patches in this series, all will be posted as a response
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
