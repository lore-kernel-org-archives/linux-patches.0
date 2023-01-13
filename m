Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055E72F2A
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 15:48:51 +0000 (UTC)
Received: by mail-vk1-f172.google.com with SMTP id l185so7174334vke.2
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 07:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sjh8dEOOgcZldDsl77ZYrTSvmKIK20XlFulb2zyWnx8=;
        b=AnLIoVgFPahZ0SLfc3kLAeouXizP96+BR8eOix5vANkp8TTN33WkWOA3gIZbeyv8E+
         2eDDPq8HwINGcLp5NgTCew3h2rNGay1NjICE409Gmq8CrJB60opLT6y9mQkoBVRgAFTj
         8Mh/o9YN6QLF/y6Pqz2yWRAFwybSoFBUGLYLjpqYXqx1HBkSQ4vdhLVKqv1JJKiZFspI
         lRfT5zmtvK6pt8Joca7p+DeAS7cOUooio7tlj0YQjxNWsXBD1id4TK3KLKcUOBA9H7u2
         FpG6ncD0QMJ0BJnOvsiEP6FLxe0kQH0L7j4svxeg0T+fHsP03JoRkz02gad4TZ+rURGs
         69WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sjh8dEOOgcZldDsl77ZYrTSvmKIK20XlFulb2zyWnx8=;
        b=L9SQwLGAwu73n7I6ZcoAJD2Yzox1TSEDLxaHDQoRJUMMmEy+Fon6Ed2Z9twZ3a78Me
         cegX6gsffXRT9s3U1YOX95WZvuGmjA7jCcrZCyJZRrEOEB2rXWYKl0L/WaA1CcyPMvu7
         Q52RftqgqofsW+znAeWpqTUh7o0OKoY/le7gSdtCy7lx9T8NkegYALBII5gB6T2hquDn
         34m+yFYC0d+Iax4PPVg55COG6VUF38xTpd1M236bQhUeB5G9S+gE+tQNBOZ28tKoT721
         VqSjF1YnDXt+R11WHMDfCsHUeY3/YjTaAxOsM3YrHEY9/yKezntz2h4K/bfH0X0Ii67t
         oZ6A==
X-Gm-Message-State: AFqh2krUr1aE8x+4/2nbaqXHvlP0/3fZez82P9TiXIZTYPFQWL7h37J3
	k7wiDwaFfQKBQUw03gYDbh7hXsL1jqquIxYN1+E6MHkWUOAbXlfM
X-Google-Smtp-Source: AMrXdXsI3jUe1ZOmxcBuPFkKStLnmNlMx7lM3Z58HMQDqrP86jptXCPC06qiPeyDnCmvidNT/WWExc8wwMy3H1VFgZI=
X-Received: by 2002:a1f:3215:0:b0:3d5:86ff:6638 with SMTP id
 y21-20020a1f3215000000b003d586ff6638mr8205679vky.30.1673624930613; Fri, 13
 Jan 2023 07:48:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230110180017.145591678@linuxfoundation.org> <CA+G9fYtpM7X15rY6g6asDxrjxDSfj5sDiP8P5Yb1TS3VVmjGNw@mail.gmail.com>
 <Y8ElS+jivE5FWvku@amd.ucw.cz>
In-Reply-To: <Y8ElS+jivE5FWvku@amd.ucw.cz>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 13 Jan 2023 21:18:39 +0530
Message-ID: <CA+G9fYv=ZcY5-hT7-RZmnhwyac3cf1DsG6WSeOSyHqSHSbALgw@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, Arnd Bergmann <arnd@arndb.de>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Pavel,

On Fri, 13 Jan 2023 at 15:03, Pavel Machek <pavel@denx.de> wrote:
>
> Hi!

> Full log is 11MB. That's rather... big for an email. Please post such
> stuff as a link or at least compress them...

Thanks for the comments,
And i did in the next email with a trimmed version of log files.

[ + attachment failed resending with trim version of log file. ]

In general practice, I do share links to log files, kconfigs and artifacts.

Thank you.
Naresh Kamboju
