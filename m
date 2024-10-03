Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD501A0B1F
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 15:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727968795; cv=none; b=WV8K5F/TJE6MMuT0oLo6DJXSdnLo07FSC9LoFdzIOOC0PCoJWgg3EeQ7gPv4mKx/oE+BJcS3bLe5YEYjSNe5Rzn9b9wCH0ms5ZWlMyd0waog/8bBG/KaV6CS60zZHKuRemPJwDJ/AunCohcYrOptz9AQMg8EK6hbaD0VgcV5gW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727968795; c=relaxed/simple;
	bh=ZbJsTlshJ9ctmYeMqDs9gVt4Uy6L+q3FXxGujtwO6RM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FC1Olx8T5fpRU/04FH5qFr0/iewoWd4Dn+VEkzutMypozDF/XMar/Mw+ZALXPLss70lprnHFs/6kIrVBEhwc8EuGbxUzSGWBRhK3es4YmQZWFX0ffyB108a1PSoHnWvE9EI+p0xaVdwTS0IqrwAO0GLbdZk3YK1aQjhQYVg0wgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=nhDQvjgB; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="nhDQvjgB"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-42cbface8d6so14077305e9.3
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 08:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1727968792; x=1728573592; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oFdqUtE9eYCM1IPNkv++3HkROvJMx+gDwOA6w7KfOl4=;
        b=nhDQvjgBN2I2kvoa9+RwTjZSSeJ+LKrjS4s3FwNDGB9sZoYm7pY+6pxoXDMwrpwWtS
         CCjTXArFAMDL33JglOqJ/GoXhEz6NyM2PRoygA2YjaKqdMU4ELibE8GqA5xjwHzxO96Q
         lAThmNXP3KB1E9wFRIrXn3VPhfMtn/16gonk1uF6/PY5l7fe0hIXTTrmOQZ0D8CqDAEz
         OxMiQCEUN/LHhh2ZxTGbP54JM3uTirFmP3w9xYCRWtxEoNfqmI8ukTSsOTW1MhtxPEqz
         DY8fKdLWHxezAGSe3mSiiXfn4LZq+oQawcalvCRPBOHuQC+zhiQcy0JzsF+qa+STXj+9
         MLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727968792; x=1728573592;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oFdqUtE9eYCM1IPNkv++3HkROvJMx+gDwOA6w7KfOl4=;
        b=uAjkP8k4DrcYAHQ0+HxkBTtsc+CVKR2gqJDehDw+bkFzFd2dU0dHNajpQMPoq/JROQ
         nKcOjFPnjcpaxpjN9pnv6dRGPGzFVI7Iis/Xj3qeupymeyhgWKkrVhJbVXiYsMI5G2+V
         OWvyDbsDHJskpwWdmSrp1NzPNOfz9AT1J9/BJubn9CVrhSgiVc8wXGuFQ9QFbGtg3NDW
         0etcR65kTnIBtI6/SqMeX7hqvD7Fdt1hlf9GD8ausUufWEoL0NVAN68kuvp/6Wixrb4s
         rrePxeAnw8V0hPLVGiUOtYsk2/MphBZ+rQioSlYkX46aw/Kh66grUj4zT8kODgNyPCPQ
         0QZg==
X-Gm-Message-State: AOJu0YzWcL+Fk59Ps5Ca9jOwD+c6zGz8s3Nf20RXxyrivn/GQkeGyTu0
	ETXZ+jCvxCkF+Dr3O9OoTgALIDE9ey5pGGQTgovVJPYHmq0ni/M=
X-Google-Smtp-Source: AGHT+IFGcq+T4gdND3IbL3l1njNzyKwcGp1Qdw3CdCjkUB+ERAIltHU81L+Tw9wShL9IzFpaSlmHBA==
X-Received: by 2002:a5d:5d85:0:b0:37c:fc25:ef16 with SMTP id ffacd0b85a97d-37cfc25f0d9mr6168251f8f.0.1727968792278;
        Thu, 03 Oct 2024 08:19:52 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4899.dip0.t-ipconnect.de. [91.43.72.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d0822b878sm1482269f8f.44.2024.10.03.08.19.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2024 08:19:51 -0700 (PDT)
Message-ID: <9eccf0ca-86e0-4234-b37e-f8b5a0472d05@googlemail.com>
Date: Thu, 3 Oct 2024 17:19:49 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.11 000/695] 6.11.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241002125822.467776898@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.10.2024 um 14:49 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.11.2 release.
> There are 695 patches in this series, all will be posted as a response
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
