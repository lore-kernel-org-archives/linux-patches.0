Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC49D306
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 17:47:44 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id x8-20020a9d3788000000b0069f922cd5ceso538989otb.12
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 10:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1679420864;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oh/NRypT41xqHY7iBI+4eeqSHLuP1WSz+18dRCjF/yk=;
        b=U960HkFExD4cUMhKJoYwJZ5BCAQOcY38BnjdWdlowG0QjMHx6JxQHjftx5kE6lmxpA
         FJBv124lwiBHtOsdYdNc17qHaKO4yRuKR7NndENcLWxMJznndJGGqUnnhexuQ5pKn650
         IJbql1auv/7Q3NgZnakIANEf6AtyXNyTWSRQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679420864;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oh/NRypT41xqHY7iBI+4eeqSHLuP1WSz+18dRCjF/yk=;
        b=BgECxIk22d15jNlpwMaHPgBrw2J2jucxYX9gOSN+AjfNbuKGtz9VWbE3mRH98/blDw
         q+CptByZ4E5JqgehDF3fC7oZzwRU90MNYYnULzERsENfZhinIBEwZcsIvrv07LcLHYZO
         oFN1M7LRAsQDdUC9YNoA0HONVzxFJIGy/tMq3kuKHnPoM3m9wmA9Bu1lowxPbqMdvpAd
         +wbwiAYQjRqzJrHIax8zpIP3M1beUjQAllrsORNYymmOQRcxNHQkVWr/Ck8kxvt+GmN1
         gaV/+Mrn3mgOyRWhrY8nrOftgt7coaZa41YaHubzzBwtFDCN6CDxzoEdkc0sVAtpGHkx
         7kGQ==
X-Gm-Message-State: AO0yUKVZRWpGlnbyEHpGZZhVSUp2GAYEkhzVWVselztJbl6lNIJynptc
	8/NxLDJxupueSzphSNuiohAntA==
X-Google-Smtp-Source: AK7set/i5TBQzSzoNWAOLP7VH6qXuwvqxtDuxdnWQyD+FOv1VNFNbEhe8knorRi2x/EJgHc1QrIWyw==
X-Received: by 2002:a9d:6a07:0:b0:690:f7da:5390 with SMTP id g7-20020a9d6a07000000b00690f7da5390mr1742353otn.25.1679420863816;
        Tue, 21 Mar 2023 10:47:43 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id g4-20020a9d6c44000000b0069df89fe195sm5319452otq.37.2023.03.21.10.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 10:47:43 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 21 Mar 2023 12:47:41 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/213] 6.2.8-rc2 review
Message-ID: <ZBntvcBaPgleWaa8@fedora64.linuxtx.org>
References: <20230321080604.493429263@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321080604.493429263@linuxfoundation.org>

On Tue, Mar 21, 2023 at 09:39:22AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 08:05:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
