Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CBD2F21
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 22:37:21 +0000 (UTC)
Received: by mail-oo1-f44.google.com with SMTP id w3-20020a4aa443000000b0051ac1e0f6b7so1354632ool.11
        for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ILaLJ9YR+MoneWuXWsO60RbFqEPdAmDr7KfJYbc7HOQ=;
        b=dHgZoUtmmMYrAOBfecVNoznwGuiSrgaLDInRvVzPGCALMXcewC0op5acIKOmcMgo57
         rzAsPlyqleqC5UHYZAZzwN4oMOdHDjR9cQ398xaQHNtx6GAkdTvhREUmVaO3QeEgoPXL
         Ay4l51dSqHQvZW676bLFDiCbHP5OurCKTIAu4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ILaLJ9YR+MoneWuXWsO60RbFqEPdAmDr7KfJYbc7HOQ=;
        b=h55iSBbbSY1Q4OtVEhVU+eO9AtvrLEvxUb43z/JgLI8/0+rgeSbZERfWfAu69kKzNZ
         W4xxm+WYOi8XFtYeYF9M4hk/xEGYvXCMfi8PjVHHxtOX904reAC7NLLCMG/4e2ET1RIh
         Ki+RKgGzCeDCd5y8d4lFWN/3sac+8aFOrN7Cgt9mCWw2zAhLMe7YhAZijvQmNKLWU/Kf
         Agkh8uHx4xjraIfS8wOc3BOM694xx/AgkL72fatJiC4Zj+L9ec+XKwpIZqWEUaP9gEHb
         4jUyUWEX4rslxPtyXiS7gAEabHNb3ikPiMeGDpM3FRsdZfnr4DJaePunOBnDNs/EPiE9
         y/eQ==
X-Gm-Message-State: AO0yUKVfeQTPIuG0bcEO2KjCmK4c0HN6Ld1lvqHbea0T+DpLF2JkfHUE
	dinIj1hjoAGz+LdHhspIV6j2SQ==
X-Google-Smtp-Source: AK7set+oJDpiX0BezbSDLHgZy5zuKdFJxOKFo/m3LpiD5p54GQW0gYJpZtkdfmsmxFSTMXVVAiW9Dg==
X-Received: by 2002:a4a:6b0f:0:b0:511:f3d2:bb8d with SMTP id g15-20020a4a6b0f000000b00511f3d2bb8dmr13170775ooc.5.1676327840082;
        Mon, 13 Feb 2023 14:37:20 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id p25-20020a4ad459000000b00500c1100651sm5321387oos.45.2023.02.13.14.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 14:37:19 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 13 Feb 2023 16:37:18 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
Message-ID: <Y+q7ntjaI5oSts06@fedora64.linuxtx.org>
References: <20230213144742.219399167@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>

On Mon, Feb 13, 2023 at 03:47:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.12 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
