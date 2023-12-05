Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8277405D3
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 23:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WshESdkK"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-4b2cef60577so913998e0c.3
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 15:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701817829; x=1702422629; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ex0xuJD8dLtr5W9ktKmdcDTgblnS82FZlDJnqATe3g4=;
        b=WshESdkKYNtwswf+sYYsF3H3yNdKRQl42UfViuzp66ZNgTCMRPbIsYzBMQZU/qFXo+
         GDnuLVa1ZCeqeUfJmGhw5U2fLV7+Ej1UupWJfZa6a21mKaGYZI94eVlBFf4h9TXHDDCv
         KJtQ1z7DMvo39uFvCtYbUiRplblyl6mgX6YgtoTK65zMFiWN+9B7f1dofvYiscT7LU+B
         SlbAn5U8STgRhkpqM1H29KYlN7CD+izOPeac5+ZW1B46WVquy0xtC0i3F7bucVhSYkn6
         LkLM4hoRXMxHz3RzSHM1m7u7fHw02aj1BxgZClVHXdcYeMKTy2V0xZ+inr0d+sWiggqA
         5mJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701817829; x=1702422629;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ex0xuJD8dLtr5W9ktKmdcDTgblnS82FZlDJnqATe3g4=;
        b=pdvL/1WGoy0jLvWwpQ2nSHWiU6266XqR4c8litXztDbK6yKPnwy88Afm3ptCpZVWkw
         tN6RvVSV2kOcld0fKhYO8WxqyUurpyYadFTKTjM+NjKSzFMKBymluB3wMk3g1IUHOadj
         Qbew0IVZxOlcjpVC+Q1ZmD+gYe2eW5OatT4pfoNlnnui76Z4jvrEwVoU2/DU11udDyOy
         31z6SG+KlizMmHOBezAluWbnfrP5EQAr2tZrWz0Y4MS9OkSYLm2KfeSSFdRpFV+fErPx
         zva9ubt/+n8HWha4qh1Xo+FLsxcFTBi2vXh/5VxFktzTdY6bDUQqsGpfIf8j9oigOw8j
         +Pfg==
X-Gm-Message-State: AOJu0YzCS3MsrNWARRkJAYilX/0fdKOocfNypJHQv8/Pp6EyrRIdQacU
	zk7hubortFbDXVuTo6fLZqoFuceClslPBJkhLa8=
X-Google-Smtp-Source: AGHT+IFaovgYQ4wrDhxWUlbTwSEWewXKPDQW59WqOhWKaNUvPVYJ9Qd+nU2ms3ispWoLC3oQmcYI2LeVpK+FDuHZLWs=
X-Received: by 2002:a05:6122:d07:b0:4b2:8ac7:1a92 with SMTP id
 az7-20020a0561220d0700b004b28ac71a92mr119598vkb.16.1701817828563; Tue, 05 Dec
 2023 15:10:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205183238.954685317@linuxfoundation.org>
In-Reply-To: <20231205183238.954685317@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 5 Dec 2023 15:10:17 -0800
Message-ID: <CAOMdWSKuSZE+fY9Q6kuK6YY_iOmKSOUNxRefGGwtq1dY07g2rA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/64] 5.15.142-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.142 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.142-rc2.gz
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

Perf builds fine too.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
