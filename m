Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4EC1EB5C2
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 03:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768534059; cv=none; b=RV+Mq4+da9iRF9Wk5r/BfRlRVy3uE/4+hrANJx/CEEkw2PCHi/ahIq8r+8dfFyLMER1ds4RN/DIAiK62yTzV5lHsE6scLK5dFfonFHR4zL3HZtfvVGbN9cGF2MqmNdbCkklI0gNdZaeMErQIAz1qFzunNkYczMw+EvuI1yz6T6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768534059; c=relaxed/simple;
	bh=p3d1EHXMUOQeKyrfaJSUhMDbMgpFor3RXHIRlsf6DtY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=cJ9YWILaW8AvDuSRnVTSEU77uy3lUGgZ2hfLW0bxBp1cLRJcP5JIQfKnwOP+DQi3nd5vpmVxvqthqlrarM6deqcOjSIxFUqANUjPiLhmD0Ba9zieE+aQJEbh93i2M4CF3gVZGFVtu8o1pkjkgAim9PmrscFhpW7sU0/L7nCehW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R/BKQAIN; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R/BKQAIN"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8c537a42b53so246112385a.0
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 19:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768534057; x=1769138857; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q3AL5LKDwPeiFpaSLwckrMLYTWVT1GdxdmD3JKnqXBI=;
        b=R/BKQAINf1E+KArUb0ggWxQRkkFUajlicc6hDV7s+O4OhH4qAzeLu1RdH1P/z4AHuA
         GIB95k6D3Pext7UaGZAUbH/DHgPL2/GFL04v22bPeq2DkACvBc+r38WVPmKn1INOFS+V
         Hw6LS6aQpdnF4kOQW3h36kYHyi8p/FJlUmWOjC4pL9ZOvLDGixuD/FI6CME85UP0+k6O
         POY2suFokXf/Wdy6+/sxN/+GCkJUaqoLmz7PL+hUTssmlLBn8O9iNynuc7XmGN/WzsUW
         TzBuy77OK4R5Jj9Q8WEJqAQ5PJzeFTmoZ8LWknSMXsdVKbXO+TlgRzSMt7/R0Ucm1PUV
         mnJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768534057; x=1769138857;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q3AL5LKDwPeiFpaSLwckrMLYTWVT1GdxdmD3JKnqXBI=;
        b=PCt3/NQDDAwGt4iH4o2Kr6Y7ZIHblnnmprHoDqGM8SQx1wx/FF30MXYRrCAJ6Jqr9u
         C6ANJdEJIcynUcx3MBAnt+ATLAFZ526RTuG3DwsYnuedya6UiK4CHPE2KIdWzMMLPIU0
         jzyPASKJ0XzjKLmRd1PjasV/W4N5We6wUZr+qXa1gldw5f27t5xLDcbYuHW+PQ2tzf7T
         jJz/vzQmL+c6aWmpvxDG+sM4wKqGemYKtd5iraEr/bbfN3pAFa2+kPe+GFvc3kt/nIUu
         umGZWey2hvh3lr8CWrV122TUim7cxqC5z6y4p46UEI9XQN9k6ipXVAQegWL6BvFBltva
         2ESA==
X-Gm-Message-State: AOJu0YyiXxLbqUctGqpqKxbNvSY+5ejt32iEGgFLyj8ntWR+NEkyjxwd
	scFhSh7r3FF0jaZK7J3RdpfHBptZ15mzvS3tSdviG+wzp1IrSbzvZDk=
X-Gm-Gg: AY/fxX4YrfFDwdVWF9NtH17xZma8Eu+VP3X2a/m6GNLVEBR542+5dG27eFspnNqfwm/
	i8ZCZ7sgfulyOR2GaC5l+8IOVHeCHDGg8Ao8/R8/g0sN6fIjPsvIndxFMZ6MU0dTZsxelcajgNn
	F2yt42I3EBSmj9Lgv0NbtRpSGToTWCKY5G6LhyflNyHug8WD6ZGlXkGimbifhIOpuCvb3I0CwqD
	1/4VF0GyLPz2dhQEMLlSRfvBGh01LNp5V5AjN8wvWlH1VDXhIWxzgUL/f5UlwQBDNb4mgbnaJ6Y
	l19BhzxxdbvUxjjkV2wk4w9/GJtiX4G8hxTYpsQT4gah9UiSldM1gpRl7TTd4iM5fweAY6+V502
	T6XO4gYZaN9FVDEl2ge2CdPWZJ7Jwf7fIV6Cm+uOBrVUOFS/MO6DkLuyc5hrM+N/lM0GWp7OEC5
	lYhTves1cVQ/x7BFgMiAQRagWCzebDBQ5hqWkFVxg=
X-Received: by 2002:a05:620a:1909:b0:8c5:2e5a:5c88 with SMTP id af79cd13be357-8c6a6963474mr220639685a.64.1768534057140;
        Thu, 15 Jan 2026 19:27:37 -0800 (PST)
Received: from [120.7.1.23] (135-23-93-252.cpe.pppoe.ca. [135.23.93.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6a72985a8sm119245085a.54.2026.01.15.19.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 19:27:36 -0800 (PST)
Subject: Re: [PATCH 5.10 000/451] 5.10.248-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260115164230.864985076@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <2710f4fe-1ee3-575d-0bae-f1e8c02e9117@gmail.com>
Date: Thu, 15 Jan 2026 22:27:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101
 Firefox/128.0 SeaMonkey/2.53.23
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.248 release.
> There are 451 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Limited-features 32-bit i386 5.10.248-rc1 compiled without problems and run ok on a test device.
No regressions noticed.

The VT console fbdev bug seems fixed. Hurray!

Tested-by: Woody Suwalski <terraluna977@gmail.com>

Thanks, Woody

