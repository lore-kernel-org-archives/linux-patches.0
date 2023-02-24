Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B467BAD27
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 17:54:19 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id n5so8582985pfv.11
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 09:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UoZ/TQWdeEYlMakdSAImOqOTB/EmUvCrkVRx5u+IHUY=;
        b=aXPwO1mklJNYlZDcoJYTxFGMIwDp4fYzv3AWcs5vdMwPTE/jXfTwpHJK+R6B+LDGOI
         yvfUa/8HrqtrhrgL+jOpmmyxypu7ixu4Zd+oJlDVkOGtj3w7VvqG0lUwwNl0JzJfk91u
         0npRCc/lMMaYPBvz6Pf2yCzQtogE2GXyqLApMyZUvZ479oVHidHTfMJqcq4c+vkfr3x2
         JDNVRHlh57SEhCzILYAfYpxM/EccOXEmc2O6XFI8HuWLsZpRSV3/KoKo16KF6QH1rOZs
         pPmva7PNCZMPnW5NY4rZCF+l5mF35nreQQgTH+uSj8jC1yi4w9so+DPb9HZgRjnh+RpT
         KwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UoZ/TQWdeEYlMakdSAImOqOTB/EmUvCrkVRx5u+IHUY=;
        b=pdPMFJ105PuqCM6yHUED2cRJKX4X72A23nEKGpMGl/I8/IbYEVViuDCD/hlnBtNslf
         OU7YH095g8h0kxI8uXgO78rCkxgiZMjsO4EThVeSEij+flPcgyvQAIeXC0GSQLuIfC5e
         EiDeEiUK4byYrwwgjMcqe8mi4wKW1cu1kosP4CjRadvcC1RyGFQU9Q4UPX4VIPcVj/Oh
         ++ZborQ1j2hccm8Gn3/F8nyaCqJrkfzxphGY1PgoorjxtQxjQkWzGzQzS+huTzid+G88
         GdBGTV6NvZQdnVDd0TDFaD8SrrxQKeLdgZpYXxFTGTJut5gEWju8vh8P14533BrH2FGm
         IlRw==
X-Gm-Message-State: AO0yUKVy2qfqrKVjots/Acc7GTCxXY9wRPuL8PZGOFs343XaTvzdL51V
	bAfqOqwa73bVL7lOJbO6SlXshnKAG1AR+NIlKDiqcQ==
X-Google-Smtp-Source: AK7set8qzlAyQdNABBIcuKPWgCcVwkP+UNSeQIk036boMWnr5/Qx0DDVpDB88PdMX/eGoFBhUHX1E5s3+gGmJ+PBe/k=
X-Received: by 2002:a63:9255:0:b0:4fc:2058:fa29 with SMTP id
 s21-20020a639255000000b004fc2058fa29mr3203415pgn.1.1677261259075; Fri, 24 Feb
 2023 09:54:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141539.893173089@linuxfoundation.org>
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Fri, 24 Feb 2023 12:54:06 -0500
Message-ID: <CA+pv=HMWE_y9NGO0ujD3roH4pAqz-17X26HQOxO0xqyg=xmmCA@mail.gmail.com>
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 23, 2023 at 9:16 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

6.2.1-rc2 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
