Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D3F24EA6
	for <patches@lists.linux.dev>; Tue, 16 May 2023 12:06:12 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-38bed577755so4721637b6e.0
        for <patches@lists.linux.dev>; Tue, 16 May 2023 05:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1684238772; x=1686830772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Ih0ErHlIQ5YrjtNFsDq5EWsjo/4Co+mHOiUsuoIXj8=;
        b=QXRI5Ago1CcQP4kFd3qGyQw6YZ17B5FTy4HUQmbdA3nbAzzV281OfK/oZwb8Unedfk
         ERqrJgyciRBRptaLaVGuEv464Xp+K96hSAGqZMUyMOisTIrq3HNEsQ9kuCdnqe2PPUN3
         Rv9zvmHaqqyeQ2FRqwmh/DZDmh4EcYCFflQCI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684238772; x=1686830772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Ih0ErHlIQ5YrjtNFsDq5EWsjo/4Co+mHOiUsuoIXj8=;
        b=RdqeAoHHkSZkcYYUvOyfUu15GlKRqhYWnFqBwlSJ8q6IzY0vf0sNelli58fYrq3G2V
         BOxBmh3DCfRDZm91KeTGm1hq7z5lAsoOTrJYChmA71ddmdxXYFK3aopYlNXGn+nVvOw8
         ACPb/UiP+ZVnf9425Rdpr55LKZdl+uB9w4EkL8CjFcOV/cpdQ4p7Vikd5S891+xKnrK3
         Ugu0jgAKunEbi2iZuEVyr8z+uv/2pnqoRK6VXXjCwv0SWEcH7NrrRClloY/hOFfeuG3k
         8oD1ZJ7Z4ftDI0gqjvXtAzvRPv5Mt/lck9wTjxJrpmsF70nBGSO7H8DPLTwHL2PPZtA3
         typw==
X-Gm-Message-State: AC+VfDx0bRjkqVAj0L7vq2rms5dnZZD2x5KI/Tx1d7BwYbu/h/arTmw0
	Rzs37iTmkuvMRdJF552o7UKgcA==
X-Google-Smtp-Source: ACHHUZ5pyXTWc3+GB9fGPQkMkajRrD4ybxHoBRoZcZw43/fbR6Vi5t6hm4Cp7MHSlXVnTYJ+pb3XqA==
X-Received: by 2002:a05:6808:6197:b0:394:48c:8495 with SMTP id dn23-20020a056808619700b00394048c8495mr12076658oib.5.1684238771877;
        Tue, 16 May 2023 05:06:11 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id fu24-20020a0568082a7800b0038eeba6fce1sm8130991oib.55.2023.05.16.05.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 05:06:11 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 16 May 2023 07:06:09 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/242] 6.2.16-rc1 review
Message-ID: <ZGNxsdOoy9bwZWIV@fedora64.linuxtx.org>
References: <20230515161721.802179972@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>

On Mon, May 15, 2023 at 06:25:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.16 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.16-rc1.gz
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
