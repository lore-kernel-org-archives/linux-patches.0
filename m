Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5633B288B1
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 03:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724814148; cv=none; b=nsdTrPkpI5q6hOi2PWbmKr6wpTIumOVWzn0B/AWECneb4KBqRxiq9zK4JvRbJKmQ1O5ztTtKvlcrKY7/w6V2uN7PIthvXYpdYdTVdUY4ZIQBG1q0wtfRhHjuIyNAS8FUqV3St1CIT32b1X3u7Ez8h7q6POTpbn1XB25NecA9yUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724814148; c=relaxed/simple;
	bh=SOTxwbFrMSqTW71U+pEymAMKbZxNgOikX6p9B7/ca0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E5+M1HMx5fPgo+X/VyaSSV9kYkMXkO6uNlFkBfUfCibOP5Yr596K9IuON1FUQdAr+vLtc+rH0YaZtPvgEm3GOo/9lVgJRKzlAUuAC30vJM2z8R3sV4CtBcCQmoVV/t7uOAoMSWXNK1JQWwF1C235EGs6M4vQz17PLjK9W1n77iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=V2XhFbZa; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="V2XhFbZa"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a8696e9bd24so666209366b.0
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 20:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1724814146; x=1725418946; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bJAYrp+cQrXiacMO/ZldsdhoCD1fUbRejySfU9vG1kw=;
        b=V2XhFbZa7ruDEaddfAP/rFgqCy8UdM9RDvgckDBubo7S3fJV9v1bChOUFauDQnGUTd
         +4SerYUJ0MbgWWpcP27ulxWeqmRxxYMraiB8W97pSp9puRczV+G3OjWebiP5UQz764BH
         UB+WUTY8+W6aQzd5qgomAOX3jkyqxO9WowCRen5bWhlyQiUXfsiPhAxwNw1mqdFNwk9R
         l6+91oLos1pzg7o/iTPn9dewn2nfjpRllGMG0Avs9dcqVOaGQhYJTKB1P27jLYosfl5s
         BsW/dJrOKUPiu+mVdTbDRBKdwj8IiG5rSGvEGswLFOyaUplGS/cRhLSLRYNxiQIBNEx/
         Mmiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724814146; x=1725418946;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bJAYrp+cQrXiacMO/ZldsdhoCD1fUbRejySfU9vG1kw=;
        b=YUOgTXZW3k5D/K3sI45VNqRbhG0jXKcTc9a69OqX+9f0w/iOdti3j5G7zr9Ti09fj9
         ZWN0072oq78YpoO5EDaFaccmAaqjKOyYy1vsG0NC3gkh6sPp5kdT+ChWduOQzNlylYDb
         VYnTBxWw4FfwCUTIxEFd9UurmGu7exTgAbT17PyTfzDQUBIWZ0epGIFHtqcwGWL5/e7Z
         8z5gSb1uOIL116jdCbWScKDKwxnt3B4Ky2me3C6awcZFxXhnooKZ6MvaXyvdvBKzZ0TA
         jtakWmlIc0pgYW5r3ZKe3ogE7LB8Mr7e9anzYBQZ4B/iZ1VdazOJvwchZ182e+OM9FyJ
         r02w==
X-Gm-Message-State: AOJu0Yw3G4b5+qX4FGH07qsp9kHhcTJne0O+ifnJqnPVOmmuMsyP3gxF
	35JUGaZ2gdYNY22gxtB6PCIkH8BNTTT9K68jTUutaY9sJXtte34=
X-Google-Smtp-Source: AGHT+IGnRvkbr6RpGnEb2i9qd3/t6Se9AspfMmTn6r7ANZTx4fnF//jyWcRSwVeMlhldo5OoDMYUTQ==
X-Received: by 2002:a17:907:9812:b0:a7a:bae8:f297 with SMTP id a640c23a62f3a-a870a9b10c1mr48077466b.15.1724814145336;
        Tue, 27 Aug 2024 20:02:25 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acd20.dip0.t-ipconnect.de. [91.42.205.32])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a86ecaaba4esm147767466b.132.2024.08.27.20.02.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2024 20:02:24 -0700 (PDT)
Message-ID: <ac87b6c9-cca6-4eeb-b5c4-c65665873f5a@googlemail.com>
Date: Wed, 28 Aug 2024 05:02:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240827143838.192435816@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.08.2024 um 16:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.107 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

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
