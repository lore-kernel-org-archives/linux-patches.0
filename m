Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB7F7E766
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 17:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706115646; cv=none; b=VGVA7cBtGlVSqycNfU+BYkZVqmeqgAXKqyUcbP9T67S/mO4YLr1dWDRUye8UKRsj8RCmdv+Zoic3WSsBLqFq9zgJ+ohON7uPr88Vc8SPUMpzOqFWH0J+Eil8+UR7uBrfCBk/03/CfjxNrn0OeCv75dGoxAf01ya4XFRrojsryfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706115646; c=relaxed/simple;
	bh=1kyIDfJabV6lwazMpxM8CPtpStKPapFOQUDAe+cwJWc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JwbaeofZ6xSyAO/FkcGsuOdovLZECFTWYtCj6CJbLvr13ww8pzYCh9nleTu2I5vrcqeOvG3VI0e8+XLdBOfCt53bgxeccBXcXdv2/0oC5/talh0lbq+zV/96fUnGDvblkZXGiRJApPdaB4q5tv3pUWjoLVx8C3trI2S2LeBKPW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HlJbUrG/; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HlJbUrG/"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-49618e09f16so1295681e0c.2
        for <patches@lists.linux.dev>; Wed, 24 Jan 2024 09:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706115643; x=1706720443; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f5qJWQaQ6Ftn2s0qa7GtyUkE0k/qzZPL1w9AnZckfKo=;
        b=HlJbUrG/8Y/qEs98XjCx8g0IbvIyK5t+OG31W3xhcVYaJsNJIjYeIX6TWlAB82Xneg
         mmHkZ6PbzS4o6CYYEfFOXnMAzP4oXbXr+nr7xjvHoXZC913RTLh3xx97A8mIP/N5HIqY
         Cqc9FzbiFzNWjHD4tClWMojlZfvArHKlY7SaGxDZtoTvz1T5T43k4ovlswRsYmfGMYae
         t+KQ7K9YfjQHi6FRvZKE00HfUSQHLyDB/GX0GSt2D0azL150Q04byhJ7u8/Pz3Nziq8S
         9SjFC0a8NINi29VJauC05bVP5+sCt6tD5Rv94s+j2M6KJx3r3BoltmftMZl0fp+4XRrd
         KhrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706115643; x=1706720443;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f5qJWQaQ6Ftn2s0qa7GtyUkE0k/qzZPL1w9AnZckfKo=;
        b=o5aZiK8lf9BeCbSSeb5ca3ZhwD0N05yBp+HjLIallQHjnGGi/ilw6sNOnp4XN3hi0t
         QrCCgNbupZ87zq2CH7cwiUkFN0fzVisEqBH8uzEP/8pGBEVg+C3KCHqUexQdWBVguUzb
         PqakxFVm8h92YsY1eqrsA7evsz1ONxHolOauX/VKYjHCpcsWdtQZFHNcTrZ6kr7R3l61
         9lLQB/voxsFLufO0bujSZIbVrr55t//O7WZeC3Zd3HP4HY+LBKTeOwJGS2c7wqBxpo08
         SD2NqApBIkWFugsgXWt3fToqiKIT9F6ZqxR0w67FCdKWfbPAz6DB8c7CM9vvqvUYkWgQ
         HokA==
X-Gm-Message-State: AOJu0YyZyrcvpFG0uLA+jw4jxeGbLQeHVizPaPAeykYbe17mTI9m3VgB
	uhWeN3yZsSs7SJumpe4/Y03nUEvLQGQAQQ1rXgS1aozpf8tsna0FNIuH78uhv+H1NTWenND9/85
	hh3HjhOMBI1mbbflY3lE7+Wpcg5Q=
X-Google-Smtp-Source: AGHT+IFlIVFnROaZ1a54V5nFAgBGV89wOM5M/npkbfrCexiktOJgxnmU9rhTkjRO81X0lYzGRR7MqLDp1V5vbEbcts4=
X-Received: by 2002:a05:6122:c99:b0:4bd:7bdf:31d3 with SMTP id
 ba25-20020a0561220c9900b004bd7bdf31d3mr584729vkb.23.1706115643187; Wed, 24
 Jan 2024 09:00:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240123174500.819179356@linuxfoundation.org>
In-Reply-To: <20240123174500.819179356@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 24 Jan 2024 09:00:31 -0800
Message-ID: <CAOMdWS+Ch1QKhcYUSVo+Wpuz4=C_D9hc4vob6cyXGVj9uhCb0g@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/371] 5.15.148-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.148 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Jan 2024 17:44:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.148-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
