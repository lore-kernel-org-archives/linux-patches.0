Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4487C94A
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:47:17 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-187b70ab997so6355334fac.0
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 14:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1681854436; x=1684446436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VfZlw8AlHMxVsS3tiMBAvH71RDRSOAAoNTnFWBIvtwY=;
        b=Md/5OB4ZHkMeXPiXDoQ3mKe5o9xdDBIf7ZW33imyrQ1i778qqYLcYBiG3njZNyfsbd
         wK0xtH108mTALoDQma+YkiMjhwo3HHa0TuTwhdoyK0o2pwm/KpL/0yqW9c88x8PFGLTU
         0kly5TX0D0WvS81iEzSTZ8NenHqqUH7xqfys8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681854436; x=1684446436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VfZlw8AlHMxVsS3tiMBAvH71RDRSOAAoNTnFWBIvtwY=;
        b=CNtKOFQHrFPBoO29fanYG9GYtMoyQoxkqbUxSY3XvlAK9nQ8gkRL2vBKcGQiwdyLl0
         dUBLfl4SZs3Seoojtcibq1mTdDLqk/jzvutf7VJEAIl6s0yCMlhAHWyKSKoVaTxsDxu7
         dtT/aVTPeSlKi+h0FSANta24dXg4UWDObJX7tzJlIqLJJ6P4PdQbe1OjdT4itBsENvse
         TIbE6nMBsrIYPGY2SS7b7tFueQvKPWTlq2VNwmWrgKbQq06WTqXoIoi0XzWmBli+ee8v
         iwCRxX4KxszoWUc6qcB6eqy/mxeQh/FObcGfu8Bbtzn/dh7XeTHztcnzfTFoAQbAcL7z
         717Q==
X-Gm-Message-State: AAQBX9dvElkblObxAX5Oxu/kwDAdPLmFtMgtZ01Ue8xw6aAACoOBqYLO
	TznruV8zIc7sclo+D7UKdNc/DQ==
X-Google-Smtp-Source: AKy350bvwxZIoP1TokwhqCpLgUkLtNzYMkJUALfJwFX186XZ4vsH3m7WlpcgTtoJidMsj/eG06rbIg==
X-Received: by 2002:aca:3cd7:0:b0:38d:9dba:6a5a with SMTP id j206-20020aca3cd7000000b0038d9dba6a5amr175603oia.15.1681854436620;
        Tue, 18 Apr 2023 14:47:16 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id k206-20020acabad7000000b0038934c5b400sm6300453oif.25.2023.04.18.14.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 14:47:16 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 18 Apr 2023 16:47:14 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/139] 6.2.12-rc1 review
Message-ID: <ZD8P4gAi03rLRNJA@fedora64.linuxtx.org>
References: <20230418120313.725598495@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>

On Tue, Apr 18, 2023 at 02:21:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
