Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7831378
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 10:09:36 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id b12so1436185pgj.6
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 02:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tMaMBgsq8eORmfV8+PIZjBPcmOMr4lsOOptzTq8e43g=;
        b=HNeS5nga8gqWPiRg5c33ua5opBuG1voX7d2wARSpZlPpoCxXjvcQTgIfgSO33sw97h
         7pSj3NvlJCgGkUriue23ShhsBZjkRUxT54GxUvecaT30u6u6XWLs6JgFNcLRaETrPD2p
         JGcSGNBBaHCB1KyvzRofUJPpKHbCXPCsHRDGm7Tgym1iypjZFpB+3JV63eAh8pb7H/HL
         8zDfyzKTx6z8cxo2yrVEPPgugTbTNBRDgqbVvS/rAFgSGSq3A7BgYHt9HY2W6nX6/cX6
         LDfT/KHhC7XmLmDyFZf5Wkk5AdKPRznp+hk/pegPHUS6JRYs0h+8XVdpK0YtzWWhhlmY
         tCpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tMaMBgsq8eORmfV8+PIZjBPcmOMr4lsOOptzTq8e43g=;
        b=FwE6m41pHTHu3fqbvzjUjWqoeY9RX0aYmZ6GvZwzWwqLxnu6+4DWDvuHDw+z7dHGHb
         /NpIpL16B2dUtg3/+IlfylbUD/orKS7gHWpVYu+33LQQY6Q/i+Diu9L9tDzfyOp6zeab
         oPpFMTikI7j2e3YXEb4+oXoGj5i4kl/gX60tHy1su2mS3qeDNfSV3NbmtoPSjzkTvJz1
         EXHxgZ4KcKZZeP4O29U0cKkw2+Cp6jptKpQsH9wMvMH7oaVgKfMrcF9hzAS79WAJSbgK
         oxf7OEYoD57C0CC69ARxo6FUSGbFUw4eQtKFwZ7uPi45d8PsbX/bjAMxza+M1LjCRbTr
         gsEw==
X-Gm-Message-State: ANoB5pm3vscLELRrjSOc7WPchv1k5IUS/jhRZCxCk+0V5AI6o9ohUD/F
	ew6gac8RyW5QxLlQorIksBZedhUVMlpMx1ZMiWk=
X-Google-Smtp-Source: AA0mqf4B3jGP7Pqepv0U9EHWK/kucZRuZDgnIaca7zxhv27TtAd0Ky/vXd5PzVkM3rXw1h5g/QNQ2KYoJw5GQeZN7mE=
X-Received: by 2002:a63:ff62:0:b0:476:898c:ded8 with SMTP id
 s34-20020a63ff62000000b00476898cded8mr78680687pgk.251.1671185376169; Fri, 16
 Dec 2022 02:09:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221215172906.338769943@linuxfoundation.org>
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 16 Dec 2022 02:09:25 -0800
Message-ID: <CAJq+SaCYJDGyQW-EFj3H3mD0uumCHGz5HfL=c0SS=NB+yWkt5A@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/14] 5.15.84-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.84 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.84-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
