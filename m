Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47841AD27
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 17:52:53 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id s17so8045778pgv.4
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 09:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SCackxgxqPZz1OiILJ7kCheCg0pnGW/YdL0a2rTkB9k=;
        b=XRcCKELQH3Eo8zQ6OvBMT0+5rBLdXMrP0ymDtbLGilAJXOy+w0H6VIlTb3rE/Uv7kn
         CFmJ2AP0cyhSJPq6dcxRfveh9LXHBmg3QBFIBNo/oupr/khGN3VcALoOAuBNZtqWMRyW
         cOGll7LKLG2mdz+sfyB82hokbgitmYlJ1JoWy2jf8Lieb9FewUXL+WPIm85yY2ZIKhQJ
         CFeREGf02W6mZiG9DkJt/QS1qEv+9+V/hQXwGpZ3McEqxMyLfGWYr+ey84KFNRGi5UCD
         p/NGQTv8JbKShnrvEsXeLAZnjrAWGNefZ4E9sSjYxoIbqJ/Qi3yw071+LOMF6Jz4D3sc
         BgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SCackxgxqPZz1OiILJ7kCheCg0pnGW/YdL0a2rTkB9k=;
        b=y8meUm59twvwXepfDCOSdvKAURrFFJbP5W4XhsTzSjsR0NTdbPosYoBpKAeZ57JMeQ
         tlHUYh5M20gAlSKOHcvkapypp0asVq/sgxyvDx73unA5Akl2UIhEdexZJGwB5XNzTgfQ
         Kpxm3ah1efhAB1tKH6Rmfejyjnr8XHBI7iIhWV6AoV2Y/HDwpyPWyBOChP1VdVWBiS9m
         P7vh1576UE49JfssGJdIRp1UrIEXtuijEYMIFjh4nV4BukpuCVQY473QymxgDHWGfGxr
         zYyAOYWzejy3ruGY5Kr46XSF2qedVEhRBcu54x+O2tREagJMcTkTiBsZSEp9Wy+5g6dh
         OBaw==
X-Gm-Message-State: AO0yUKWvivM4uM7cxNTAcbaim9tcOeGKkksK9PPOsQh9YiDs/RnsFzv1
	k/WKr45WU3T6GpAZLFLbaR4TyB0Zd6nbCavpuzK6FQ==
X-Google-Smtp-Source: AK7set8SGDB1zD5kMker4QuUup1RIlK/YZsel7dljbjx2fj8/qpmnbaOvZqH2vWLc5NzROAlldWOXeHidwcAyfe7llk=
X-Received: by 2002:a63:9251:0:b0:503:20c2:1752 with SMTP id
 s17-20020a639251000000b0050320c21752mr219087pgn.1.1677261172625; Fri, 24 Feb
 2023 09:52:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230224102235.663354088@linuxfoundation.org> <Y/iRLeEsyiYHjeh5@kroah.com>
In-Reply-To: <Y/iRLeEsyiYHjeh5@kroah.com>
From: Slade Watkins <srw@sladewatkins.net>
Date: Fri, 24 Feb 2023 12:52:40 -0500
Message-ID: <CA+pv=HPDzTjHokT3Os=0aEEsR-NEHskjGRRXhuHPPO=wOyqxZA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 24, 2023 at 5:28 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Feb 24, 2023 at 11:23:55AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.96 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 26 Feb 2023 10:22:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc3.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
>
> Only change here is that the permission issue on
> scripts/pahole-version.sh _should_ now be resolved.

Hi Greg,
This is fixed now, as far as I can tell.

With that:
5.15.96-rc3 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
