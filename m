Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8239285041
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 12:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787745884; cv=none; b=SrBvk8s1L9umzQ77K71snGD+yK7P9nwlP99cyZhLcWXZTSRVhLGentNI+961RWX09qLgoFsrFqc7rUaKyBrrhQi8W2VebxI5bhTWiQmk1O3tG8AzJgMTz9etIL2kEn3uGI74UjubRlHfKfmfNAab7iQoNxha2efpurBYkf5WRWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787745884; c=relaxed/simple;
	bh=t8r9fwHDfwrrDslghKcdGeSg+FPh7HR538uqlbJfIIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GwyZ3IbxgJGuAUnBF5KThEcYvRtoNLJ5+1syAMkL6edaz+xXdcXgBjUPQU9ZZCI3vHYPqQyhYh85u/Uk7NUw7OOrzWqbkMwCbNlWQexut+i3G7gVxcfjqnolvckKEf26nsl9yJj+ALAtxL/b8kc96d0qB3PDRMyLNjZ8/HAQbac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=nQLJk+fC; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="nQLJk+fC"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-482dbe4d247so367887f8f.2
        for <patches@lists.linux.dev>; Wed, 26 Aug 2026 05:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1787745878; x=1788350678; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LUtXgdw64E4AMmrHZa4KMdOAunPgCi0nfhsHNUCmvGQ=;
        b=nQLJk+fCdJnINb9mr3QzztgXXI6R6Qs4ZJcjvpsWX3EZvRlNtnId9XwckiIu4yOOGq
         oZ1uzuyGa21tsWZRTjvojZogk3U526qjyLhwRJbEHJ1XrmZPhPRC98vMxjA301vttvwv
         DwW+7AJHvOFDkl6STZL9UfOsvgerIvtslfJ5Zh4lDBQbngdwCDHs2UxpGtSQwEOhlrTA
         s9jFb1Sw9Cx30VJig4rXe2g5ROKnFmxZOG7GaB7sP8QpgpERrEIRMsMcCCusWwtz26rr
         6OW2B0ebX373XWL0ufcNKwbHTonCQnjxDCdW+FYL6cX99auCkcbd2+6xqhmOYF83FRqR
         J1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787745878; x=1788350678;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LUtXgdw64E4AMmrHZa4KMdOAunPgCi0nfhsHNUCmvGQ=;
        b=crcg6j4J4YkDL4RkM930zsxyvfD5OaYJbm7m0mGdtke94MSwsaICworQ7hXI7ftv+I
         so7hatFt8rnz23JDiZFhraMmPhuQ9ywBOh4CMWuXgambwTlPNSM1CideV8xpUqi3gZjj
         Cb7S9ASCEvfIVZY//zMN0Ojg0M84fq94Bd4RHBI1H7xfrxC12tx2BUHznBUZNOVbjP9C
         JH2yfO3p7np55BYjeeFO4z+J3f8PvEypJQSqoj4Rv/eKF+eg8Tek5tRHWY9evTHzeph6
         Tme7H3/fBbuBwAeCAl+yVKcGt7MlYsuRw85ETJR8MGb8VS1MUN898yXV1PAthd57Nkxj
         2AXw==
X-Gm-Message-State: AFuF++l9N6Ed+Q52UHQokU6eELB7YDGP9xl6ifyCtAFe4MVMHVseR06B
	h5NXxuI0xJBwxnFCKvwS++C2M+Emh6Rc6eMbhUyOYD7iio3MqsCyC+UFSIil
X-Gm-Gg: AR+sD124HDZtRXYcustcDHcQqRSju3TnCOrbsLJHhZ3XNFlEaG8TP8vk28bl0ojIDyy
	w40yxuGWM48+DtYSypjq3z+yOj+xT5m8JjoQXhb23YTMjR3uEZCtJyjv+X/QxYgZsElcApqoaY7
	ufvBMRMlyT/tMoCTDqu8n6ihtOGsmcPPVHebHmhl0EHcD/ymwilUKh6PSCicm0lLQDdJOKdr7K+
	pGOsvmATddfGGZUcig4GezuyOQ+UZX/XvRWHi3iB7juDJJwRwpqpBcyh0x3SD25fgwUL3dNJpn5
	mJ4G6IQGhMcPfIDlrHW09ePV/KfXzsXA8f9/tgezx1WlD25mczXocqFzv/tFsF1KzD+atwICCgC
	Q6qJ9TJ+nWVie2rl6DIkNu8JTyzN+c1tBPnfzRUQ7fb3gmFcFEno5FgcCg5Wo0E4Cuw0ehSVVDB
	eTUfii1eL0VLbhORrgr2XgEUc0FXVSG0JM13+1RgNe6rdRxVWpE6OHOK8ysLIVRbV8muZ+hwaff
	uORaweG39aRULQwTSWwnutV3cuwaa0+tf9ufds=
X-Received: by 2002:a17:906:9c8a:b0:c16:3187:997e with SMTP id a640c23a62f3a-c250bb69c32mr689989466b.7.1787745842844;
        Wed, 26 Aug 2026 05:04:02 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace5e.dip0.t-ipconnect.de. [91.42.206.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250dfd6e6asm350863266b.19.2026.08.26.05.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 05:04:02 -0700 (PDT)
Message-ID: <5c014a1c-9139-4b7d-83a7-746b4a7d14a9@googlemail.com>
Date: Wed, 26 Aug 2026 14:04:01 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/87] 6.6.154-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.813800447@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.08.2026 um 15:25 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.154 release.
> There are 87 patches in this series, all will be posted as a response
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
