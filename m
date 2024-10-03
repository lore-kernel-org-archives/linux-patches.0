Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9366219F11F
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 16:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727972121; cv=none; b=MqeM1eyjROOuoW20SRqCuHdTh+Um0cd1mmveVup4O7hJZE14Oz1XdPg+Pz1Klm6bJnkFZFeTBrMlY3fOpCc8DI5YQs5FKzPRQ3M8l3j3u0Y3ytXvtE+ZMP3pq8iwQDmlcm3NC8ODBLWVWOt5MGq9KivMnVQL5bUs4gvwH5f7b/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727972121; c=relaxed/simple;
	bh=YUNppPO/cOH//1Ehkehu1ue8+aIJzkVhMeWCKqzTRic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RtkLFQDLKcPyp3I5CN+CG0ZloaqiX26kweXKNHU8w3Pyg0kuFNacHSWVZzH5Xqa+pfrN6G/1WB55rdiefSL2JQl+rQPh1uVclxm2UKTZnmO7H5CaJOsu8CcdxSqK7u96a2mWSlU5sOS2YkXZoU+bYIxFKnO/tXEzBMO5DFJ5rIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=UmtY/zm/; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="UmtY/zm/"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42cba6cdf32so11715275e9.1
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 09:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1727972118; x=1728576918; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uNrQYa8R60fTxvWUk/afRy+xx37ZXVxha5xqKTzH35M=;
        b=UmtY/zm/FVhT10QYpaHXqvajGAyQ9x6hkdZfCi3gdZMy8L7rm5FNmTfjOhZ9sBdJ4A
         ZAT7HF+GMAogIjZFdlglks5nib1TUEss9L2WV8U/uB2eeXeQGJGqFxZeGdocywGTUfv0
         MByrkp3uGDNiGzvGPefGP9Bcp6KcSO9pHryKai2npGcLHEVUjcPrnCq8LxHhHocmKg4u
         oR/zQr/Q8buofYTYrxpjjPZnrnk+BrTvrDBZl1xDck/gUN9gyf3wCibZBcgOHYOI9HCn
         3FfiF56cjKNP0QMejMrU+y/I8Gt/7eNk5rMsrGc1Xzh7UzynhPY6s010O93zUR1rkUAo
         ++8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727972118; x=1728576918;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uNrQYa8R60fTxvWUk/afRy+xx37ZXVxha5xqKTzH35M=;
        b=emQEHbZxVMxT6GPzAhKXF2pP0ka91TNszVFtwnLwf7Nt5gSNpfsh+Y6o1fhbtL2H1Y
         C4e5E55BRsXGveooCbjyTKvBR86+U8MV0Ozav+PNgizj3+wK+46+kfBvCFBlAmx9PxSX
         6v9OSlqP2Tm3wskrB2k1Zr+nVb7yzqKsjhP4JePoA0F/86FJ/+SWfFRTLE9xjSm5hR3S
         f7kRCIxpw0mPbsXvlGqOpkLFnfEWWiqZ42sPNJcQXStfRUhYn2wDs6pEZbElomG1L+Ri
         4n2tuUwnTsxMjtwmRY4HF8HUyfs/mDT6TPDp2NPGQjO7zIwx4mMYzDYmRhOiQ6bO8Wjq
         Q+sQ==
X-Gm-Message-State: AOJu0YwweZY89IiX8jWy79rgoFCRCQDuhbmYo0QKjpOUxuinyuAkZLsC
	a+x0EXQAK9hQfxpqdxkd9ozrL4qBHKKF2wguuxY0DOkazT9o8XE=
X-Google-Smtp-Source: AGHT+IGaLzIlnDEzK/in2eQeV0K+Ol9xt3lMWUpzcjiTJ6tO5rNm1hpOMR+ia2Sh7MQHzD+/DmRStg==
X-Received: by 2002:a05:600c:3108:b0:42c:ae30:fc4d with SMTP id 5b1f17b1804b1-42f777b64c9mr56927265e9.7.1727972117648;
        Thu, 03 Oct 2024 09:15:17 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4899.dip0.t-ipconnect.de. [91.43.72.153])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f80255f01sm19156435e9.9.2024.10.03.09.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2024 09:15:16 -0700 (PDT)
Message-ID: <78ce1271-3e96-4bbe-a359-c376596a4743@googlemail.com>
Date: Thu, 3 Oct 2024 18:15:15 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 000/634] 6.10.13-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241002125811.070689334@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.10.2024 um 14:51 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.10.13 release.
> There are 634 patches in this series, all will be posted as a response
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
