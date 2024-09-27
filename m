Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF054D8CE
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 19:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727465563; cv=none; b=Nm6CWwb/MfYG98GRYEMOv7Na9Zs3Bx4JPyjhOX/IW9IAmW1d7iTrb3TR/D2Wrs4qdqztzgZYTj+SdthaanYbTTZZR6s44OvW0rrwFbBMx7EnoWrMulcgYdGke9KgaM3SARcz4LA2JiZ0cKRQrze58GIZO9NG/4XGfXJ2pPk8IkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727465563; c=relaxed/simple;
	bh=sJRp5M0f6R2juQwYr1JcI1DlvoVM9hEc1EdOE+xM0yk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YpYUL6esgEwNzgpTzC2O6hF3LwtWb+6sXx9katyvl9hAL7tWMCU76H3wXd8CztRJaVV+/ZmjkPNbCjeQRW7cUgX17tfOM+A6dhBdJK55cGGfHLND+7o8Fpby8yNqTZWylA1ZUHwgm0v+eh4ypI/Kgtqh6Gi7Cr1n6V8seEEB9pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RDSAGDhK; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RDSAGDhK"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5011af33774so837133e0c.3
        for <patches@lists.linux.dev>; Fri, 27 Sep 2024 12:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727465561; x=1728070361; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8Fh5W2HEXCsiK+VCosBNxjg7EhZqBA4xPzqKSyJkN38=;
        b=RDSAGDhKUP2mLiFHLJfs+jURqAVh0iJVTDekiY9Udp8JG/Hfju6nkTkAQu5d2O4qhy
         0T+Pg90IT6RJ2LfQkSaFhZbDDHzrH5HAjpZ890YU4tLreXvc/6Y4bciqa5e3cSwwwinb
         Skr8ITpnpA9x7r+AzqwEK1FC8mcMBnyAdxaswLk2ecTnCPpIMjc8Z0unnhlNCBLPhZ4O
         DnqcqI8SzTmievjwWqO7akBhCXk3XCowP31jFqllszzb9s+k0GKIUx2BSWocfHk+bPU5
         qfKu0uxkEuOkcPTAqDy/ddYwSmAi5FUDIp8ctbWYR4soBM2EoGwavxoxKEHmfGWd/47S
         vX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727465561; x=1728070361;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Fh5W2HEXCsiK+VCosBNxjg7EhZqBA4xPzqKSyJkN38=;
        b=uT6/DAY2Hn4gw8EyjzbDKUEYGhJIgkG+e6mO2vPzaiXbputUta3+qF9aU2Ibp7GZ8N
         AALFDmVMq6oa+saSzA3ILlmnrVVfSw/HYts/K57o5kbGdusVH4Ulr47fBLQCwAvlLmcN
         SR6M7Z+9xTSOv062bDhZ/6h+smeUYmL9mNkp6JtFJvMWt30okcZuj/BCcYSbKVr3ecli
         xPz40BZsklQErA8t+sMEU00rDBHVmHXo2e2bCc7i14hKtuNFPv5zBeOPE758B+tV3rpU
         ScXaqN7pfwkUhMDOgZGeKlAFreVgYzpBGYbYtZcJEBDC5Rsg3YNRuEskcvYqe4i35Kf7
         0SzQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2DocvNCWLfjdGam5TYfo/D70Y8vYpD2JoWnYUaSNWc6IpJzEgODXJw7jOukCooT4SpSB7eRe3@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2uAjHO5gTIRSCjETn4B/xvolOYwRUIUQSnN9QqUgbkQRnio6Y
	NfwuhPMp/nZAsvIz34TFtIlqeHMlhpSDOWeIuaYjrmAaAa4c/OkWS9spr+GzzCOpZYLZKzp88MC
	uS2fLmAenjCOd7qnxYWV5nNmISo8=
X-Google-Smtp-Source: AGHT+IGHZ+l6QU+gzzC1IXZtjjwytnJoq9ws5zJ8pdYCTCLJc6QsTyHwbnRwxqOdfxOjayJGcrRP/SA5C7mr9EE6eP4=
X-Received: by 2002:a05:6122:468d:b0:4fd:18e1:ab0b with SMTP id
 71dfb90a1353d-507816d9b26mr4035152e0c.4.1727465560926; Fri, 27 Sep 2024
 12:32:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240927121719.714627278@linuxfoundation.org>
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Fri, 27 Sep 2024 12:32:29 -0700
Message-ID: <CAOMdWSKcb78TZvOk29tkk=yDn9it89wTWo4QERTJSTM0h_70Qw@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/54] 6.6.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.53 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.53-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems.
No errors or regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
