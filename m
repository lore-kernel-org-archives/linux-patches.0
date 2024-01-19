Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3AA54BCA
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 15:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705679326; cv=none; b=qDqpP3umMVXqA0cU0f5dd/S5nlbW0ZH3aveEAjqaXC4Erp46MnNrzbu6aTdrNuFCj98wHRAbHdb1x5+BLLOYAlC0Gcr4y1sVw1Ir/5eARzO+1uaVR9mYzE78L94xl0myirdSyIyDt5hY7iP3MNh8xEE7U5G09Fi010yi0qlBJIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705679326; c=relaxed/simple;
	bh=3KeVb8iHSTXJAHlpC+TiGoBdbDy0ujW0bVUfMh7M/IM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oc7XrGlo68snEXSyFfS1dUO7Be4+4916JqRzNn6MJwffoYw9/cL2NdJ4ow9gzsNz7BEBeXn+oka6CBV2IjT5TEuBrguKPJ0TXNphjhzXoXZhyM8uR1E4vxFFkTbwnB2LEhS4qeiAZyElie67hEQYJkE6oryKUb6yDcJy3kewQ/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lqDc3x1a; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lqDc3x1a"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-469531dd926so246082137.2
        for <patches@lists.linux.dev>; Fri, 19 Jan 2024 07:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705679322; x=1706284122; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kSbsPC/GT8f3pGBraL0I1C1S6tXlzFxSCmChfpZ5F90=;
        b=lqDc3x1aFovEV9s7LHcsc8AMe47h42l5NJI9raR1KUPf0qyN1CK4wDzOuhlIOi+zrK
         r6HiTFSsDYHmhg7mzkM2s1VLZLkxnchpKjpRJCwz7cyzBzJWUTu1K39IbfC/bTMv388s
         BBLiyWWjMCxNP6d/KFIO+T9ksO39JxTYru2BQpSN2abijwapMiU5cLeHEG6V07B+VyV2
         CcpZNL4CRLmQlv+Okb6mUw3bvCV0MM8+ePsnmUALL0c4Sz8voRq+yC0wo3UNjrNdBo5I
         uK846DlkNZ9EcbO5Y3edOuLK8IXm42Z4CXuGAdTyHFUL74/jKB1nOZXbLFxqzjlC3u1L
         Y4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705679322; x=1706284122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kSbsPC/GT8f3pGBraL0I1C1S6tXlzFxSCmChfpZ5F90=;
        b=ug4LfEIyPWXPrWZ4bZUnroPZEMza3y6SgQYGVydlO746AF9rSPV6P/ttsUfpemtiT+
         fcxmuqgYjwbL2KI7jWrohmPRlWyF+v0slYxn8AjL9FXkLEZyfeG07brHcYxnfSs3EMzm
         d3bvCN3brzkHCkfh4GwdlYmTBgk3hAuLkThzdlOBFvXhhAcg7TmtrOw9c4qYUTZjr8F2
         W2h1IEXSiMhksCYrF5Bh4bRHPLS3FEqFDlzg7u+pa/mfJ1LsmYsHUrO9OEjKKe9oXnj2
         iwKd1v1F1qgTcp+VDRHcjj0CT1/ZOOTo9aEfBSvBkq5y4yBHyIcrl3HZNOy+dvuxxVk2
         Mzag==
X-Gm-Message-State: AOJu0Yyy5RaG5CUSoJQSuh5cgAS6o0Scb31AYEzvle+LGaKQqECkHU4R
	XlSwi1Ba5uK4U0vip0QVx+tDlHjczpi7KsXX1+Mf9igCHWAAP0NkbEeGdK8XJFjrjYvJSAUgllV
	hrasMNNi45RV7ZXP3aBwTj3e4E3YcGYiC3CGnRQ==
X-Google-Smtp-Source: AGHT+IGLafI0xBDL15bbjTBVc+RXc9+ZzQCvlFVzHvfgKr0SoyjWZ+Sb6T/8NraCFHnMzn/9lWlD/bMD7rzeMqgfQvQ=
X-Received: by 2002:a05:6102:3229:b0:469:9fe3:96b3 with SMTP id
 x9-20020a056102322900b004699fe396b3mr510547vsf.9.1705679320997; Fri, 19 Jan
 2024 07:48:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240118104301.249503558@linuxfoundation.org>
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 19 Jan 2024 21:18:29 +0530
Message-ID: <CA+G9fYv4PdOsuFmd2BGoq57omiXWuvnSpJJ1HuLYT0rJ_h9xEw@mail.gmail.com>
Subject: Re: [PATCH 6.7 00/28] 6.7.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Jan 2024 at 16:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.7.1 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.7.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
The arm allmodconfig clang-17 build failed on 6.7.y, Linux next and mainlin=
e.
but passed on 6.6.y.

Links:
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20240117=
/testrun/22090095/suite/build/test/clang-17-allmodconfig/details/

## Build
* kernel: 6.7.1-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.7.y
* git commit: ef44e963b02edb00d4de5fa3528a21f3e7b33a85
* git describe: v6.7-29-gef44e963b02e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.7.y/build/v6.7-2=
9-gef44e963b02e/


--
Linaro LKFT
https://lkft.linaro.org
