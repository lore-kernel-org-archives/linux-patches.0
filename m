Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00CD6E58D
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 21:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VLNYmURz"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-46491d5b814so837403137.0
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 13:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701810876; x=1702415676; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o/ZBnlG/4O4Nf+VPlwuFFktfrixZ06nlRki7xqoRblk=;
        b=VLNYmURzKaxOE+AIfyTIeeDQ9wX9Z5HFo1Q0Jn2EKEracIOsZgyg72xINe/lLUi4dn
         FrTpavFIOMZRXWWZTXG+AdgwVbagZtD3JsJnGQdQqi4gYtysYpTvskORypcNYW7RWJu6
         WXJA+od5m35T6+GVz2V/R1f7OUTik7uN/hHLqHpID/79SP1m8TMR+VKGFz0ra6DhATRU
         2iai3oHibKux47MOb2KEd5uT1hO234kCBj6HN9ACIcd/gZbHlw4+a/xK2/A++Faj8jd3
         ujqtjmEHVU+BwqpS4Wkqf1p2GG2YtHa7b0kj42er8HUeQeTc21YJ+gFMaaALhO4W5JJz
         Vl9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701810876; x=1702415676;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o/ZBnlG/4O4Nf+VPlwuFFktfrixZ06nlRki7xqoRblk=;
        b=MdrpAuiydJ8UDqz/A3yD9xmjoKuV3fJTekpaHwddQvAyRsNEnN57S4LiwTs3hXX6Dc
         vPfoi2nkDD4CiaIVn65gatjz2q8pmG2m2AIuwkg3nH3XKcOsyBxKG+8FEVASE5FUphza
         lWroJ98b5Z8gE1G/BRJsWUda3WzDe3r1jJjxi5KiboKuc8uZYPMdxbobI+iWnJuR7abN
         mbTUaZkcrK7HskOpOV24uXzxNh4nh+R+FOQ06RO7ZW+reiKngSMVzJ3ZvSKqHGpSLtRt
         ZmBAhK9npv0g7neGksEzN9u1mfCaVl6rViMDEVmCwcznsXf3FeYOBnArskXFdPH06rcU
         Ytwg==
X-Gm-Message-State: AOJu0YwyURIkzs9eettYF/wO/kZcuSgowcdvaVCAbs1WX8ouxoXgIAc2
	nDjJxXBL1mP8NsoOQXmGxWXNTlBbCuZEdNhTz1g=
X-Google-Smtp-Source: AGHT+IH+UdlfWyVlMgyHnqKWo2m141tgyAR3pqlIW+VX4wUkEZ6lSV2rACyt+JSRvaT0kg2N03iEUaTiYpgOSsOODxA=
X-Received: by 2002:a05:6102:284d:b0:464:55d4:b41f with SMTP id
 az13-20020a056102284d00b0046455d4b41fmr3539942vsb.0.1701810876415; Tue, 05
 Dec 2023 13:14:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205031519.853779502@linuxfoundation.org>
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 5 Dec 2023 13:14:25 -0800
Message-ID: <CAOMdWSJRR+iqqUD4iVuxV0mL45CJ10zSrTo5YXn+_f2bd09ezA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/67] 5.15.142-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 5.15.142 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.142-rc1.gz
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
