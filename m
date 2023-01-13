Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A4BAD4A
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 18:06:24 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9so24187953pll.9
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 10:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sa2g7FJOgJR5lztIY27+SRQnR070J0QWIXiIFM842Yc=;
        b=SSS1hANJ+OPfjusrDqstBBfJDVq1449DfXw6jgJZp1raIrNZXxztfQ6KWj3NIGgAi9
         uSFXQXNj4IqHMlGHaYQFf4JtHwpb96wv5aOUQm+27xfnC2dyLW8hQG/OJOOnfvuUMWjo
         5gruHRDXptgsUP8Gj1pvD5bzFfMiLxjVnuT8yoZdTv6M0sQt5K6vVgVQyegWJzojgnl7
         gFtzUtNcS6nxHQnPpluY3jbn2d/oFVgXVBi58P98vZwEd5XA1JT2Y6LdgxSceTS+mvqi
         06oIBl1EG3oHsyqrIe9IsuAd36wL8TEuAOH92aWwd0HM/+5nVyhKq85sxgRD3p0DHtF9
         EWJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sa2g7FJOgJR5lztIY27+SRQnR070J0QWIXiIFM842Yc=;
        b=QF8giTjpIi5kefPH+8QZX3I7OdKyJqm0nY2VJsoF4b1G4pbS6NHnzg1kWJfpPa7a3a
         a9Ew0QN4M61h+dqN1XX76HYQN8fxef1cUroulLmZ07DCOuv1rGQzkfj7qmG5iql+GCqz
         L23/YgDgN+BqiEddm1cL/nO2ssduCesm4oiWSmone0bwnAavlKTigp+qXN+AGEbW76if
         5ZWNb7qR0J69AhQoxzBugAcPEaxbyWaj0G60/MS+mNB4YDJOY2Mwc9iHpqn9ToVr/OSN
         hMuToLH+1EIll+zSz/KOdcMDZ5WRz8CB0J1TTWTI8E7zcHwIS5HXo5GUuHpjjjHnwxmy
         r3cQ==
X-Gm-Message-State: AFqh2kqLXP1QERtWUI3PSs+xMW6WooNpBnET5V09evzxEitIIOn6s1Ke
	WrBF3oxqaQpCacnkGzkcxkFJiDTuCe2k9hPSno8=
X-Google-Smtp-Source: AMrXdXtCLU1w6j+YIuF5eLVVD9LMwU9ohKdWtVdLTpdZcYdIeGCUgVE62yLP0VCBdU1VmbhiYQ+0ATQox+2xfMAcWh0=
X-Received: by 2002:a17:902:9a4a:b0:192:c6ad:4c35 with SMTP id
 x10-20020a1709029a4a00b00192c6ad4c35mr42031plv.15.1673633184164; Fri, 13 Jan
 2023 10:06:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230112135326.981869724@linuxfoundation.org>
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 13 Jan 2023 10:06:13 -0800
Message-ID: <CAJq+SaCui9zajxTs=wjm7mNx3yzOSZ9Rh5UtJ-XDbK31AY_zHQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
