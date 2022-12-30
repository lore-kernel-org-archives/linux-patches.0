Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838F528F7
	for <patches@lists.linux.dev>; Fri, 30 Dec 2022 17:07:45 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id w26so14794253pfj.6
        for <patches@lists.linux.dev>; Fri, 30 Dec 2022 09:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3620dnlzLPDYDwJfxZUNq69cyA3CsvU2Mk22dUrg5ro=;
        b=Jq55x8gsEAG57CDEijJ905bb1zAl0AJPwF2Ce+V0wOhzYjHpaD1ZAoIveu43y7129z
         GA5VfjbOZTAnrRrYBqwdBxdwl1bSgC6IUjuDXXFvuEf/gWXP3PHdmU29dR8F4drTugpC
         VuK66mAQFy8UQlhQ64sbCWeiesWp77/2ipgZ+uxZoc2+V6Q/zWTQlgMk0bLiKbFT5xCP
         xRYo84WuBx+u7EdYWJo3xteNFiJjMnN7WI2qDbIUYJUgSFb3vIcEhpSUkB/m7ipssufw
         3WB1VSUutjYDVfbsF0UtKglAulV/qGVuVecTjJKaMTHq9m82Q6ubFW9hzhPA7/4QXwet
         CMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3620dnlzLPDYDwJfxZUNq69cyA3CsvU2Mk22dUrg5ro=;
        b=NwQI2PSglilRlbimMDyX7S9++AzoJ63SGZRr9fMU80I24hatgC+Wd7JxkSxzy8aH5p
         2uNHBNIweCywtkHY7apZMgbswQziK6ADVf4y8cKAdFfGmnjYGLOwsvll9aK7ZdAEEsfd
         NH05vGvA3LV5hS/1MLINXkl9ZKjXJxJwWGycpnQ7BEoyCIi+ZeO433KemeSZ65+b+BAy
         nSybe0MS+L+xeBVzRzWjYpjBdE0Tc8A8S7f2/s1FrI0tfuHQToWleZ/PEvcGT9e4Qz9E
         dkah+aXJFwkXFjFOhg7oQ4uYqCCDx4Ae/+7Ho0fbO7gWpfbUAaYdO5ln04OnD84Cdueg
         l5jw==
X-Gm-Message-State: AFqh2kqoJnyvIAXpX4KLDvHhC6vkXKEa06ISRONsRS2ZjSBn6aUqrmFF
	asCn4B4OlMbN0uV0xLwq07vCsZaiZSz+BP1y7G0mHQ==
X-Google-Smtp-Source: AMrXdXtSAyzbSBZuKm8FlmMoiULn24O7nbtAHpbFYhAwM3N+RFY0Cc9g1PNF98IadyaN8TMoxLf0Raa/bAm+FuCSmrM=
X-Received: by 2002:aa7:8887:0:b0:57f:fc4d:f773 with SMTP id
 z7-20020aa78887000000b0057ffc4df773mr2011406pfe.3.1672420064853; Fri, 30 Dec
 2022 09:07:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221230094059.698032393@linuxfoundation.org>
In-Reply-To: <20221230094059.698032393@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Fri, 30 Dec 2022 12:07:34 -0500
Message-ID: <CA+pv=HNdA=c7W+J5PbKruqph1Y4LBJ-VcV93rJTwiahjKhgX9w@mail.gmail.com>
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 30, 2022 at 4:49 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.

rc2 - Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
