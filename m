Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C75E44F546
	for <patches@lists.linux.dev>; Fri, 11 Sep 2026 07:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789113439; cv=none; b=TC5o0GhHgLAbQ3XNCv5YN98MRhmHlvlxM5/Oojw5i4EUVB6v7n/R1GmnJBuW/Hnz2veIi5xTUdqcOlLIGgbEEw+yYAxsq+G3MvD30EXdonm6dTb+ml4wwxCZDY7vSDAkDm43BIInMipak3+8aa0M6UNz+aebYQ9c4WZb5vFDjb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789113439; c=relaxed/simple;
	bh=x7ObKTZ2HTGus/JCQNOFi9VSB9tl7CEINYbybbpc+gg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rdpzfT05dLjDDSSHGa4F9Mx8MMz4aJNvqYIWFFCdJjnKpQ56wqMo0U9rv2oYyexbEDKdOgH+8dzx+SKO1YQEozEAwGpD6HV0tbCSZZ4K23w3PB6DPJYfuMuJC5RNS4XxgrwAY/mmaiYVh3ImifH9ROzUgrlqRqUBE1o5Bh9u8Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=NFw/cmFc; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="NFw/cmFc"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49b0d8bc2aaso7335095e9.0
        for <patches@lists.linux.dev>; Fri, 11 Sep 2026 00:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1789113437; x=1789718237; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XDpaAa1elq+LYiq/gSdOwz8vvhdeP7/6a2iuH9Wx1YY=;
        b=NFw/cmFcSNqSP1E6d/TQokYoYB0oe2wVSAxQ/U4Zn9EgIaZNCKnGK3rjhzV9sPu5Of
         Xs2PWd7rvDsbLa8LndA5ovyDdMGqL+9NESBLNmeEy0gZ+PoNTBORWGjJ8+AyHG/u6FQ8
         jK406XxS+f+6O1knOQK5YXG/x/ThMtkocAr+4640itJhniPWbsX0PjypGLpPZZ00ZkmC
         /Ak3AOgKOiGpRzFwN5NaxPQRG6+KCqLxxmK5RFbi6Cb5XdXvZniB8Oy7Q7vMfY3iOrNk
         Z+wGkbSN2kTE4fyIW8Wy2lpZpUE9v4WCRpsiw+Fb1El7bnG43Qa1l/P1G0LJevuQv+n3
         pSQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789113437; x=1789718237;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XDpaAa1elq+LYiq/gSdOwz8vvhdeP7/6a2iuH9Wx1YY=;
        b=XydRlp0n0+ekii+t3zBo84xaaW7drFEgJpa0tSdryzGNUhn91KKLsyuoJcS+i4eY1I
         9w2aT0fhqMYNrsQj9TYk5BVHYRYw2/uGepEoZBk8cxo7vNhDNkaR7G5mvjzoOJ9+V1Lw
         jPPwzNh/fIDgb46bsgi5OWji9P1DxIsNyTCN0cj/9jEJ1npqX+KuQON6tqXBwEgsWr+5
         TPAOi/AQiqIVp2Yoy9BYfoIalOybRknR7kworyNEtP8+RMhb9Tx+EXYLl72X3c9Ejely
         waQUqCsJO1wOnP6zYVECmjnjDwkO3B3AqVIxSAoQLyhCUhS4J0UHK9kcAGv31WhwhKbM
         k8tA==
X-Gm-Message-State: AFuF++mSO2OJQGK93VwVwT0TN/c5h4Cp6mDIt87R0GtF0hrz/vYpegy/
	uNJi+zCfItLZGH38qs+SOMautg81vaXx54gNoIXG+avYEbfVtxpDa9c=
X-Gm-Gg: AYBFou3aP26FHOlKxjMOn5vlxu5Odp4CCdxXVL18OKfueyxLnHhC1wRDy2AMVd0Hi25
	yv7YjMF0goHITJFKzu4l3PIWGU5CNI2qfIMRhNIMJ6iJ9McHOXEj7pmG8rK11zJ/aPVFYgYR2je
	ABYJZIKKDH8/MxOcm2kl6OMKG1flPTJHmO3TG/I4oZgj7K7ZRYWCfB8LiPOIQNWh0sCnhZuZZW+
	/jQ6uAIzZ85Bp4VvCqr4+/i/xVFakbC/sBGqYvje0W93MVJPFNt6jSOquqGzspQ+h8qW9ENSU39
	prUfvWCUQvGznTPvrFiATTGg0L+y3TfL8avdNNA6qOAFG1f2H6EOo//yieikdblbGFsY2h4qvE+
	w8dxzWSHv+t4nKTvlNHAu0D6P9R/zTs8hC1u8zVUdESbbXgm8vPajhlHbW0fnyKG07gwDa8UJ2I
	NjCD7Nbk97TtnJvUSy4xmSwtKHaQHTyt7YrLW+sAGVA6wFZ5ojsg7AIUemzTTrp5vm8ATYO9iy/
	mMVmpUKX/0oaPtmZr+4u8YdpsY9x+NJ7rMx9+6mIS5pFzCnwp8=
X-Received: by 2002:a05:600c:1c21:b0:49e:663c:c69e with SMTP id 5b1f17b1804b1-49e663cc8bamr5307935e9.24.1789113436464;
        Fri, 11 Sep 2026 00:57:16 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace69.dip0.t-ipconnect.de. [91.42.206.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26c1bfc1sm158082945e9.4.2026.09.11.00.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 00:57:16 -0700 (PDT)
Message-ID: <de4d3fcd-6459-4a8c-bb56-741b05b10198@googlemail.com>
Date: Fri, 11 Sep 2026 09:57:15 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/583] 6.18.51-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260909134237.773280130@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.09.2026 um 15:34 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.51 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
