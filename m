Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029466A039
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 12:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721825048; cv=none; b=GzvRPsAv4INFh1OVn1zpJQ7cgh4lrC4KVc0XoQouiJPP2N/G4hC5YRbNee/R8REenIrKZczf9oZ1X1/XLFFl/TqlXXdVvZ35zffg79YBjjQ4Vz0RtjE606Et3aIvNjgphyev9traGfUU0XnK596pdoM2baJCu2nPXn3lzF+2SMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721825048; c=relaxed/simple;
	bh=yv5/QFhFAPb65M4s7ugL3tGNyxlTw74LY9qjyiedrP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bT5YHHTmx8Rq15tN1cC7ugVTQzSLURP0SeJjDXdcU1rSD9TSRg4iWJi9FkIGbFOhfU1JXCeLQrQlyiE1KJWf6wJmslS/Zc9cWP10FabG4ma62PkgPUEp3dU0fEidOTsC3VUGMNrInjQQqcPYbY3hbIxRVuAyalEDKaJudMFa9V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ReCpyGhe; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ReCpyGhe"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5a2ffc34677so5770414a12.2
        for <patches@lists.linux.dev>; Wed, 24 Jul 2024 05:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1721825045; x=1722429845; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ljAWzXfJkg/wQZiKSeXe2JJNOkrb9s8c+erMRLk0VVk=;
        b=ReCpyGhe1+Y/1bbnZRdmGK8MOKp2OdiatpY9s/KD9oUGVMZA3/BZqp5rZietsXbKpr
         HPnKXNyGhKo1qUSedlpoHvbIfhdLsDi+lH/u9Vf/kKuR7k+7X/21LehVn/lr/bqETcga
         zkYV5qHnbBltFcrNWRpcvXXRMTn1aYUaVddCVGcbD7FIviAqz0awvrQ3asPbsxlpjhvr
         We4HNoDXrrj1jDHVN1GeaJVSMVhiCGoZ7WwC1odH6LIj468/5JhtkmKR/UaBdU8iqQiT
         q7Z59jQS5Q9jUrwHqU9GS8/ZmLFYyySvr5XI4EOnAw785nUJ5eLPSQBFjg6l1M/aBqAU
         k70Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721825045; x=1722429845;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ljAWzXfJkg/wQZiKSeXe2JJNOkrb9s8c+erMRLk0VVk=;
        b=ttdJ0t5CmpaDyXW0d15sqtHgEEPERs7bPaEdNjYUVnJRLdbzohD0T/ZZAHi3EnZQ1J
         mRjFfgy3eWKnyrJ/uhahu9ch3gKkANXnJVuqECutXUjaR/fz0L17KnabIL7TTkdci3C0
         k0+4yCbvRVoXI7VWS9YpY64z6XGKAzbKGQuC6jEuQD33ZPN8dLaWxPE9jtL5C1qMRLKd
         OoLu2qni7losrm9mOo+02n2HHmrgSlTlFJ6DkdR6/WKepYcy7LzympzHAyUsYAN0aA7S
         q6S1R9kOJ/Y7m71lzB7mJM/tFKXnP9HjFonGKb2nsvKG7+L0RZuB2dAZOFoDFVeKWX4A
         NFQQ==
X-Gm-Message-State: AOJu0YylAImWO9AXaSyjjp/lLoc/JGbOfc5Wl5xp6+KM5F/Wej+A0oCA
	1HVOYnny2qKw6dVEHiuDUvjq5bUWEYKzx/+BaHV2lFbGWHjZJT4=
X-Google-Smtp-Source: AGHT+IFVd6T5XYoTUmgpbHhyW2avvsdaGGLt+mZ1T0qM4LuFCMsIW8oLboKrmG0yXmG1GTZOf9q/dA==
X-Received: by 2002:a50:cc97:0:b0:5a2:597:748e with SMTP id 4fb4d7f45d1cf-5aaec1608b7mr1359251a12.2.1721825045039;
        Wed, 24 Jul 2024 05:44:05 -0700 (PDT)
Received: from [192.168.1.3] (p5b057b1e.dip0.t-ipconnect.de. [91.5.123.30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5a30a4d6c17sm8934583a12.5.2024.07.24.05.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 05:44:04 -0700 (PDT)
Message-ID: <42fcb54b-c50f-4a4f-8248-e0e4f8ebf539@googlemail.com>
Date: Wed, 24 Jul 2024 14:44:02 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/105] 6.1.101-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240723180402.490567226@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.07.2024 um 20:22 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.101 release.
> There are 105 patches in this series, all will be posted as a response
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
