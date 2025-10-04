Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8D9286402
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 20:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759608673; cv=none; b=PSKCvgfZpheCnyZbYMQkJ6pJdqiPdAfuDphbKQM7nOPGF+OxTZYIz5XwlaNladz4BEcxXS3rMiCPlRmKV7+t5Y6mOKws94rj+XInSuCdIcMYEYyDfuCmnyJb1+euLm2+q/1Q44MKG7JFytM1pJx9NaTgPytEejDbjCmru5ZKKzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759608673; c=relaxed/simple;
	bh=TsiZxhP+vFGkyQbZ5Zbz/SpNDQ7m1/puPmZFEmdcmw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r8W7LagJTg1ZqPFKxbZ7tzHZIt9Ap3wXi2xcE/wYDQPo1aDeXRHR89WStUnz9SfkMXqYDnD4rssRJseOzgA4JFOMX7I2N3pCk7KyHaZ+BJPteX+hB+zFGsL7fIqwCBeuYPVZjIJ/6odsPq2dKsToY4R3+raD5pCwreb8aqpPw6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=N6LZSs0O; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="N6LZSs0O"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e6674caa5so18082115e9.0
        for <patches@lists.linux.dev>; Sat, 04 Oct 2025 13:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1759608670; x=1760213470; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7dnXcFXMk+0a5S/+KzBaKdbrz4oMHtiB2nPe7M0WGHI=;
        b=N6LZSs0Ox+ACkANNULhiUOurWqOlIecEIHZ+DcJuXZkCaidRdlCSAxMb6pi59loVUO
         QfMBtCGkT4T2mKYT4Wgmexa+QG/fMoD9Gvrfz9UJH/JMOWP+9U9+bvbdtjHolx6vGC/I
         /40GGTvVxlB58D/N5s7ZebyBwgDiVee/aq1ccqCpX4sOYzP13wwA8Qo8BQG3ku1xjFnD
         zZGpIgO9UrySQyCuBIlTh24coLRogwJ+77tOCVY+fuF7czIUkR2sF040wCyMDE/kYc/Y
         iMNknrvOJG8tIgn3YsKfrEFjEvHRcO+IF8At6v2USGFCXYhqBH38y7tYehQbbBy3RNlk
         /cgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759608670; x=1760213470;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7dnXcFXMk+0a5S/+KzBaKdbrz4oMHtiB2nPe7M0WGHI=;
        b=A2tfNMqCRMb+AP4pHl6LFEw39Rr0YuRKbpyn7J4KL2LYixAfIpkweFRm2wQ7jQug8S
         D69wfrgrTIAXm/RV9wkh24DeVKCfEsutv/GlFEUwaSF4jdFetWKHUPBe9XrwyWEgTY8l
         BHN4SLvzxUh3QG6+wXtVAVohDZqrDYaKjqAgUR1LVOz3gPh0ZNkCMI3wqAsrMzf/6ixy
         WSmcwjnMlMi19EcH0kA3kJ2cpyrSs5djSdpFqnWemw6ZtUoLmuxJnYeQgy00B5voAn0l
         tJ9LsAAxKJzHit1GxejbbmKsvC+VBXrbzzzf6Wqfe7eqZMTgYo7ZMwEWJ9grEEfYbjy8
         hnRA==
X-Gm-Message-State: AOJu0Yx6dmoAcj6ZvSA+1z+TnDssegU5V1jLQXEC7teQWOiqmUO9V2Fo
	5W+ek47Xq3UYMwWMu0o+BccTy2F48QmkcXNj8Y6urIs05n9JdXzRHJU=
X-Gm-Gg: ASbGnctoAAMood6zCyS0pIuJ1etXQBvV0dVGHVJUW6xbdvqwsZpvOmck+TjbPXV8eCH
	bGn2cE9cjWP3x1gHcxcds3UWL+2S5l9+bfditXhELY600l4TpWsAgJTV6yXXGnUBIHGiYImpQO1
	VL1pRUsU+d5oOpmqK9PjZeD41ZwfYSOvq8yN9Gx8PIq8JgE+Tl08aiOXZIHmTCpCgSYjALNrnYA
	6ycGVN7d2N4VjcdUAFDrlzMpOq+VFpsZeXLBC0qT90UMxQrixomrzHOtFCE4l5p/m5PMa/dUNXz
	XEuy9beIsc03nZrRRgdhVlnXqLxkfski0f1HG9Trvrzwdj93Lv7/jQYYHcWNjEeh+WI6Lp+uZpu
	7VKWDzuwwki5bLma21albB7JSqTg9LcqscgWE0vu0mJx9D1jUwHJDdIEAO7ZOxiCld3Q9Qn7Si9
	Bl9c3OvMZmn46j61TUv+fNo08=
X-Google-Smtp-Source: AGHT+IEV/ddfbMzH+eYcV9jWeg4lthVxgeAg+yeGuby/PPk7hXfNTMdQi2AVMg60OxNAsVRCYgvu7A==
X-Received: by 2002:a05:600c:1f90:b0:45d:dc10:a5ee with SMTP id 5b1f17b1804b1-46e70cab483mr53674085e9.15.1759608669468;
        Sat, 04 Oct 2025 13:11:09 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acd24.dip0.t-ipconnect.de. [91.42.205.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a022d8sm174613185e9.12.2025.10.04.13.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Oct 2025 13:11:09 -0700 (PDT)
Message-ID: <ebf0c3e6-1864-43c3-bb1e-219adff5c7db@googlemail.com>
Date: Sat, 4 Oct 2025 22:11:08 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 0/7] 6.6.110-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251003160331.487313415@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251003160331.487313415@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.10.2025 um 18:06 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.110 release.
> There are 7 patches in this series, all will be posted as a response
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
