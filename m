Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A9333F374
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 07:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791248; cv=none; b=Ydt4CXWJ9XkYLfRDEA2S6b6bD4tSnOtiYgwEFIz1HCHPx2OU8EkHLx4lHhFEIf9+UZ+JyRzlqcAOCcuKhc4LY5qI3uDKUls/xMdALsMf8/X8nFLLj1aZNtD8oOtMQJcgcqNnNXEetZY7S9/kNXBpeNv5qSZ2fgjvlQQt6u7R7WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791248; c=relaxed/simple;
	bh=iWoSzUYJLnENnLJ+6d2f18+YRDfc0wb5KlE4uEi2kZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GGHYe82hXDd+UgOOnCdqd56tlDhnrPBjs7Q7b+/Nr0f+ReVxIU97+IHgLbSWqKwAyusX5e9gajZWRnSqnZOAPMvNFYXk0AHq7I9nGKaqJ/ejv0VtKUwv+HQEYUYLinwVWiiWm7jWXIe0ZfLbS6xqAu8p2yE6KFgW80OWmT3zx9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=JxrQ8d25; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="JxrQ8d25"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so233226f8f.1
        for <patches@lists.linux.dev>; Thu, 23 Jul 2026 00:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784791245; x=1785396045; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nth5iIvPYHQYLZs/eqFWoZtm0g6LK9jEijFjgKUtDEA=;
        b=JxrQ8d25iZ1DPpcBrvM6s/du5Lra4d9ttF40dSW5Hr/o268SL12uV4fKTIRzyYOI85
         XlxLw+ktL9hsHZ8tp/OOTWRjop6qfnuKmsl84X+0ry8FxHmUXVYj9RAp/SS4CSJ/EcP6
         FPA4ttA89zUcnSpdJmWYN5n1kED9hTf/1oVC6mc0typFBcV5isublt/eQNbsthIym9oj
         O5PCQh9kxjsXJEb7mFJ7YHYBpHPPGzJhSi0HNI3YGgjMHE0Fsb4k0QQIKrKhEwEc5u+0
         FLgwCCHK5jvxlfnGHDx9gUvVvGy8Yw/dpl9gtJoLlpalhi0Y2zbtwKrmCTj1vwJ0PuLC
         d1oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784791245; x=1785396045;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nth5iIvPYHQYLZs/eqFWoZtm0g6LK9jEijFjgKUtDEA=;
        b=Ysap8aN7JcAsvYp/fM/VuO2dUXBVQegfPallNlfttVTjXoxiLY2tXS+mGL84ZTCcxr
         4y8XLVQges8bK7rCmnW6D8xEio1QxP+TBZde13yurG1VeWWy0GRLyhccb/SaTe1raKeZ
         RngibzK3paA6GmBfleH08XorEZozF5ibDP2ixJ/PcXfmEeyK3UK6qea4xffMqdK09FJF
         6uRPXruVENOquYI8O96nNNl4Z7Wp1T46ObQQSQ/aD5FDVTmdXgegHMNstXOeBEwoGwtY
         2+IB9fT284ZpBErNsZzb1dHvVVE1CFi2CHHbVn6NnhMgNlQMuvqhRZwukNDDWfrsZW3a
         n4Pw==
X-Gm-Message-State: AOJu0YyUofzp0tTfzJEy3XAr7pLEDPpWPCSp2T2UvEDlgbnV9KhZED6x
	58CMABwrhnS7Ds36MKVeMwUgxSIsrx3M3jGxsAAgbheiBBqLIwdnqxc=
X-Gm-Gg: AR+sD10Te3vivmwodu4LsjjcIORIfBtYXKDnSohQ8OWGFwWXOe/Pf5Bzupwf8CVfCgs
	RnUXS3w9TrxOGzrNyKwO+EQzWYGketvjXrAGJLhaKQEbBiJ6i/Dy0eUTK/xTB2eHLEE+9+hja+7
	ktkKDb21wWN+pnIbE+iPCFLanFiseumJ6Cc0CxJMHpkyaAc/GecDEYEKwLKtPdF5ZrNqIkewxRa
	m9EP112UJHpgZIrAAbYDDCDXXAMxUdoHq4yc7ABo9qJXvVbWtKzOT0g8Gr1S+KEyDCSA/+Cyl6y
	R5/3VwkGd9S/ODgkDBk0Y3QJZa44YAMjEmevaWsaRIOAIKheFm3Gne7AI/we6FJcrgmigoovV9p
	kjRc7JjilWVoqnTlb6klhzge6BES00y9sXEWkCtrhVbwPhAE+nJHP8aHBxg4xO3kWarOAh2yq2x
	8bAauUUZACW+yJghm5F8jT4W6J0+fuZaBwofZvVQzR5lN6gT3gTp9mTX4=
X-Received: by 2002:a05:6000:3105:b0:47f:83b3:2cb2 with SMTP id ffacd0b85a97d-47f8d770508mr2274615f8f.57.1784791245138;
        Thu, 23 Jul 2026 00:20:45 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acb97.dip0.t-ipconnect.de. [91.42.203.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a5a2sm13809444f8f.7.2026.07.23.00.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 00:20:44 -0700 (PDT)
Message-ID: <a01ad02b-0b9f-4af6-b3c9-748814f3e3b2@googlemail.com>
Date: Thu, 23 Jul 2026 09:20:43 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 0000/1029] 6.1.178-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260722143218.909123637@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260722143218.909123637@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.07.2026 um 16:32 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.178 release.
> There are 1029 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

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
