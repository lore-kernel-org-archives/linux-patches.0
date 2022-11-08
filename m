Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006168BF8
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 23:16:49 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so277219pjl.3
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 15:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ouDJKeV1+9oucOYE87owMq/AqAQ66xsHnB+NY0a4rhg=;
        b=McFPNTHl3XwI5lZ/CSu3uvqILb1MdP91tLngcM2ucgPK/w5gRP8MH2/UvfLz995noH
         vh56vLI9YGWN04Cddx4AVi3pj1Sun3GDlQvKvmtKzVYu0SapBOS4LUXbjZL3i9mrJb2N
         NDbfjgViBLJvFmmZky4sNKBlZm3YBUrkbpF1agWvwEa6/te+OSHLNHG6XcvquKcXz2jd
         eAwyk7YPOmNuNtheM0xHIt64EZyUYOdTLO7A0cwegj2fOozEcnUd9dPOfd4fDXzLwj77
         ffRQNVWSvv7qual7C4oUO3xb7wI6sj+cpE5dd2oTYw69K6bvnW1cqIL/oFKT4jqEFwa2
         Lfzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ouDJKeV1+9oucOYE87owMq/AqAQ66xsHnB+NY0a4rhg=;
        b=7uiWVprTzff8azc7xFhXQfuJbMUgPZtJAjiTbX8UJhEYS/esS08VDKCHhhSxlpWGBg
         XGDKHP5SB1lbj2RzKyFUiZa7+ywQdo8NxOrnuQiqoAIK/ZqtvaF1l72OZa1BGXiAlRsU
         CEB0DdAT0BMlbqSExQTOY+wJw1l2OoOdFBWExNxMJEdI4d+UYtkaykASTIUPCBkdpQVn
         2+/8SPODJ9CcjGaA7j8CZDgesaztsTpYFyLy3ai0i18myh76C32bYOjni4+rrBVZnSO3
         zJIpBtLYTpkRjAFtzW2ujfQkzt1kxWm9/KF419proov9XxKiWO8VxKOuZ6msPPQ/eqZo
         Q06A==
X-Gm-Message-State: ACrzQf24MiyBp0RvhCz7miaE3AFwON0C6br8sbKLI7Ylnt2qTg6hYAZ9
	18Hn523vU+t/8IJpuUlPWcrg7/IBCErgIVBKsNg=
X-Google-Smtp-Source: AMsMyM6IOqGvBWCaLca/WddQ6k6vG1TcqJwuC2P0xkdBwPMWqIqSrYqmrqC6wfWJAXaWylIUezmBc+hAvRwwoChFVco=
X-Received: by 2002:a17:903:1211:b0:178:a692:b1e3 with SMTP id
 l17-20020a170903121100b00178a692b1e3mr60320340plh.48.1667949409522; Tue, 08
 Nov 2022 15:16:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221108133345.346704162@linuxfoundation.org>
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 8 Nov 2022 15:16:38 -0800
Message-ID: <CAJq+SaCw3-_TyGNn_Npf1+rh8gufepK7yVdKMEVehkKoawuwmw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.78-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
