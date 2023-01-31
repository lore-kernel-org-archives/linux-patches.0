Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96EF8F4B
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 17:12:15 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id m13so3852613plx.13
        for <patches@lists.linux.dev>; Tue, 31 Jan 2023 09:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dKf5Ya064WBi5OgBkq2boKVDTlvDbMuuWdhqR5krYGY=;
        b=mqueMbfMP3IEhLybhAA8wG/50RMR8IPrnkkeeXekST9xj6SNcPnynFddM+QJjdzY9t
         wT59vqZuVUyOx9UnmEhpw51Di+HmojLtRq33Yx+AL4QzYPLm9MAeJ+D4BUhfaJuuETgT
         DbmlVtmd14YC/HixY3PQZBMux+c/4KNIThuphlvfNGFDIsQed4GpvEy+d5lBJT5XXEr5
         KI3s+rGNcZ3+ouAcDZ3SXgf8F3VhoM+UofmlEPCl/GEe64rcm1k/1rO00o+7CJYzYvoG
         09aE32nj09QjhpLh7DIFo/pK0F+hG0aQLLf0W3jJaRhx+RlvpAtPWbup8KSdts5zKX0S
         zQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dKf5Ya064WBi5OgBkq2boKVDTlvDbMuuWdhqR5krYGY=;
        b=bbbLXJdtGIFbLMbo/P3O3BuyY0gvY+EcPtRQa5Rgx16jZ2lj8MpjFMNc0GLo3aliQb
         Vpk7umLBOV3Ob7QYw46s3lUmmsqTjmSLsEu0qpg937CkQ/xx9IF7DpJUXb1Grq0MkN0n
         3zKjIfe6xo8ECp6+TvdJ/WMKu/n/9UjMiLFYR1OLV5avzEMLJTZAuqDrlCLMmxykECAc
         WsRLji6Pbvc0gz3sWYJgwcddSIST1VwqYAp+c70Eh4nhKHxXCX8jm6u7cAnJcPONeTgE
         FhpEJMMT9eBaomx/y/6FryisxfQOMpppdJlHDw1iBaB/YhoH318rEYaQtuRG5DYnIfry
         ANTQ==
X-Gm-Message-State: AFqh2kqUrHDwcIXeEppoxkUBVoMW0Ri/4AfSoK41RZu7nTgLqXzuocuV
	eKof2rC6tAoVY775qCP0gW7seBDcHTOyi1504pE=
X-Google-Smtp-Source: AMrXdXtC29gomKq5jmS7Tfuvvbo+9CTRB4gl4f4Ry4LIsjH2UKCed7susPKjMtgBInlgosqEbP85u2qV+fNMlB2cSlE=
X-Received: by 2002:a17:90a:6342:b0:229:4c59:3eeb with SMTP id
 v2-20020a17090a634200b002294c593eebmr5781742pjs.51.1675185135179; Tue, 31 Jan
 2023 09:12:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230130134316.327556078@linuxfoundation.org>
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 31 Jan 2023 09:12:04 -0800
Message-ID: <CAJq+SaAx2ripBHbmNN4QmdkmWVQ=ey3sBkO+yLRSqhWwp+bCOw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.91-rc1.gz
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
