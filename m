Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D0B181320
	for <patches@lists.linux.dev>; Tue, 14 May 2024 20:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715717357; cv=none; b=bTkhis25c9XaDKlnV2HZt5ZcwGo5joLTyma8BuOmn4glj1B5O7/iAcZOUkPIWfsuAxCF6IehUmhVBPOxkUe9f4xfqW3UW4D4xYzpVrgJ1cXub944eHW7YOFhUfZSNAI+T9IJGupISBS34cbdCovGSdfoLU7wbcrPeZUsefCjEi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715717357; c=relaxed/simple;
	bh=+uoIFCvGVIJRk4s7hsYigwIzua9WwwOe/QuG0eGniAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CtYBXkJ6KwtuhFJsTsX1aEvn1RjODH9BqphmRJZOa/o7T9hv6UcoCrKNp76xI9S5lVc0cqtNBuTKS4t4QgE/w4uQgm7BlfmtMtXDe4bYPt/InUkqGaDHd7lf4eo2js3DM7ajG3Ix8r/dBLJKVzzXU3uZw4pNiXe0ptEy9mzLF0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h2Xm6vy3; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h2Xm6vy3"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-52389c1308dso437386e87.3
        for <patches@lists.linux.dev>; Tue, 14 May 2024 13:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715717353; x=1716322153; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=it1t5+uPi6v7OLKk/MMFS0PswUkDo02K79yDDA3ssT0=;
        b=h2Xm6vy3ocpEAPmYfFZdiyz9esnPTZyBxKkUOJGCYzN/tjDj3dp+9v0PjR71qIky3N
         N+N8XQahrp6zvOzzr1rl9fLstRSyNbF9+ShR9ytum/RmCh8UA6EkMeLobenAAUsujwMC
         /GcfaIgnoER4T4hw6yh3ap4gLur7oZXj2S6g7LUddzezOrxVkT0T2r8iwEwIBGZPhMVX
         5waouklRCUK36uVlIeBbXtLXcM6vqmmUH+N6PScwwi1aGzAC20n2ueF+d6h5W8/i73L3
         GoAmlbrzictALFHc0MbXk0+uHKOzebGmXXRcuoT/vRk7ZZkoN51HZRxu2X0qP5oXpI8D
         tE+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715717353; x=1716322153;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=it1t5+uPi6v7OLKk/MMFS0PswUkDo02K79yDDA3ssT0=;
        b=t61idytILAWtYzwr4Wj15akk+lUKrXSzWQhHHrwrYJgvAu0y13SZvgZA3Fnmz12dkM
         RBrWw64rxVT2s7dwKvJlRwjflefAV/eSN+VAhUfUtWVRhsdqwj/Lw3Z+F04lX51YB415
         mcsslAGjn4TthWwnQNDeSmvV3Wo71RbIzcZ7rYKSr31J3tGVDKIZKQt52OtCw5oGzZoC
         MoB7/Vgq9aDeaK4y7Lu5YbKjnqKki/K6yC2GsJqJJffH1PVWrg6NJA01td+Azr6zmJNl
         23hz9P3VOpcKeSdXUnOULXsrjqUlHQ8vSw6/LCH39vrjupHIPSb5Co0XuvjsEtUFA+RK
         GobQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7kbUiDq6E8YhH3XWuhVE+FSAsA7IkPKsPFKMWkXgYwRdvp/VOwaGK6ipTopNBt0G7CvpIx3OxltyVPG59QzvMcndYyfR0Nw==
X-Gm-Message-State: AOJu0YwaELY0QxAb3UTmq8/PLg7oja4LArjKUGqgTdTU9vNETW8iKZKT
	bk3eo86dRmamxuPf272cRIVBwU1AQ9GV8QGkOfbE/muziHkAHED16vV4qaTehJrukjEXbqCXzgc
	DfF3+p1s2kQHiggjdy1FhAEUn8VQ=
X-Google-Smtp-Source: AGHT+IG/LK246gPxJGnzQKXI1WEdowT9ELP9f70gsfduDA9emWPXWQa2w51EHhaB7QwmOwxLD12mvLIwloULemMPJC0=
X-Received: by 2002:ac2:5f89:0:b0:51f:6a38:be0c with SMTP id
 2adb3069b0e04-5220fc7d370mr9122388e87.22.1715717353120; Tue, 14 May 2024
 13:09:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240514101020.320785513@linuxfoundation.org>
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 14 May 2024 13:08:57 -0700
Message-ID: <CAOMdWSJtHwT8SxBNuzyig9qfrwhw48ZQpTt2x+nF5cp1=XRY1A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/236] 6.1.91-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.91 release.
> There are 236 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.91-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
