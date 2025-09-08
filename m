Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111EA311940
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757351162; cv=none; b=j+Af/sZ6m66qS57q74NqbJbk4h/jPeOmr/wat4HuNPpDPipNlY1NUxYBkdHiUFJfMcW8e9aLkQL1JMkVlrByVqI3OWjVPOzFrC9vXy42IE2wHpBeq6KmUIe2swK/QGJcVbZPGggVnV+F96W9M2ROeHPG7mzDJV7MY7PZqeB6zuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757351162; c=relaxed/simple;
	bh=UereUCrEkQNC0tu3rtwE8zpk6zjz0QTQfAA76et2u8Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nNdfeQM2nT3rMxoKi3laW781hBTFR6Zw3u6i2Swwb/7tuYR/79xzoOsxodAWcvwGYh5uZV9vYwzfPn6a8q1mNXEf5NFqikdGe5ERLrNe4OyLbPGa+HF0VH/euPBYME2U5KqWal0yjwxYqfTjAMcZI4SQ4KFyl8heHAwSckXYRy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=eeHj5NmV; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="eeHj5NmV"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-80e2c52703bso412379185a.1
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 10:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1757351160; x=1757955960; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C70iKojrY7jdN82MqXaFezbDGouxyq22uvSJHJ1WlSs=;
        b=eeHj5NmVxi0em+7v+rME07QKhzyhdj9UDjZSbpEB/KXAK6KMnoMYZPHo7TKdpNAYAH
         0GV0k+AxVKTvAq/4G4Kc3BtxYQJN283RQZuRHWWuvImrcLGXH6UhDMkpx/VwViIkNQ63
         Oum4dA6L8T5ji2E2zBtwLvg9MTC8VXG2iaIGAtU4WgwCp54hjKkjBUHDdbYzEtIlfou4
         IQ25bksB8W+BO3m3tVrBgLFw773Qtc29Gk/8FmQS1fGGbwFMtWsusfQ7w8H/4jMcD98C
         MdHzwwHfCz/HIqtFG4yjVnUKxtO63/Fr61YTvmsImUDuLtTf1EOtvawr6Qf4LMslwnA7
         ItRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757351160; x=1757955960;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C70iKojrY7jdN82MqXaFezbDGouxyq22uvSJHJ1WlSs=;
        b=iVZffjWr45EmQi7E4+rKucJZdX2TKZ9MHV0l2EcdPMJHPTURveE/skmXT40uM4sYZ/
         94hSW/JoUIw90fNjO6f3gDAwyz0f+uJHIkT5JSj0qXIgxzoKWJgDH2zPFYUoIs3NEL+x
         Q9uDtHpaH5YqKkOuI9PcKE30bRTdGPyRAd6Lijw6zrBA64I62CoilNPtJEK63XlJIPDO
         JO29aN1GfosBnZcXXOLew8+dR1jP3xr77/MlGAF6O8j1hLWPrSi0rMcAgrL3z1s2ulDM
         f20+HPT4+M0vHp8lP2n7DQGFSU5n54QeAmTS0RQZ+L1IiMZ1n4G4AIiXGkJBPjAIWb1v
         ZLjQ==
X-Forwarded-Encrypted: i=1; AJvYcCU959/8xAke+OgbG+oUQodCekDCXqGvtiBt6LrRtC2igWzZfAV6CKa2NtOTxSfbcyKG99bE2KuM@lists.linux.dev
X-Gm-Message-State: AOJu0YwDUdJk1sb9Xcis9DNuNMPxTowW6bxl46fX4ZTKMl6QwEJN2gJk
	mXhfyqyYGws8sUo8JYOSfb+wV2TAIZUTwOoxyYxQfLAzP7X/O9KKDNhv+fIPFKqAtsKhD8M9EsR
	6OlcQUmEh+VN2fNlrJDfKSMJansdgxV1gMc8CVE6Qdw==
X-Gm-Gg: ASbGncvc+bUUnfVEVS2mOJee/StU23QYfNOXZIYqvKwsJelg8TqaQuJS49ZXdH8Scse
	M2mKUbzzcI0h/9K6Wgh7I2vG5ncr8tx4s3RwwizgmivPW2YUFEBE3r73dTL2C25RpVzWasu6BhI
	T93W+UzKrwTzMdhta5i4CLdV0uo5hRQWyvJdBCDx3QvVcZW4HsOZgCajeDuxehUzJSBd0zNqKw3
	A8ELTud
X-Google-Smtp-Source: AGHT+IG4c7OCzdFWJM4VhsvxR/re4+afJCA0GQQAlA0lULwfRtpZH6LGwuQ4VTihA22lXylz82aOiBirWDgwUthD+3Q=
X-Received: by 2002:a05:620a:4082:b0:806:2c5c:fdd with SMTP id
 af79cd13be357-813c1f89a1fmr889509285a.16.1757351159587; Mon, 08 Sep 2025
 10:05:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250907195614.892725141@linuxfoundation.org>
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Mon, 8 Sep 2025 13:05:48 -0400
X-Gm-Features: Ac12FXxb4qpTT9OnLVbol23evRBLxN2yd-jE-8wHxvMJAYfbhe7J7JMejRQMjcY
Message-ID: <CAOBMUviNfJVJXTuVkgwyxUDQp5PHfEcRQ=LRpVjUQVo-DKqOng@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/175] 6.12.46-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 7, 2025 at 4:29=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.46 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.46-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
