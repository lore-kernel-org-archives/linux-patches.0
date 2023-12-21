Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3CEAD4B
	for <patches@lists.linux.dev>; Thu, 21 Dec 2023 05:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A3QNJZd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEC8C433CD
	for <patches@lists.linux.dev>; Thu, 21 Dec 2023 05:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703137286;
	bh=mIi42XPel+rGMek5ax2xp1+ciMxsEzHSYpFKaXe4RB4=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=A3QNJZd4giLPcplcbdENc743CY9QHqJLXRCZ0GdXz7w3i3jsJmeCYxqgyg0mOz73D
	 E4My8a0OkpbR08L35prOXEcnaqNHBWA1f/zOtPR7XMuEjpYkmaEKktHYiBb4pG3QWW
	 i8NmAz837FH0yKnRHRDpAQqdC6Pi7/3Xn0N1AYd5b+doMYHrlmJ44wCwzGsUY5ks99
	 hlWAgynsGqcdmO2eqhCp/KNRtPh9mVLZXJmY1qRYR1KK25IDdqPD5d7e7p89oB81S4
	 0Y2CyFlI5IFNOa2y3TmZFCWmG8tVODmgbeblBd31DX2EW93KbAOYy3ugOfqSok1wog
	 cVavnii0uE1vg==
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5941f390701so272272eaf.1
        for <patches@lists.linux.dev>; Wed, 20 Dec 2023 21:41:26 -0800 (PST)
X-Gm-Message-State: AOJu0YwBebzQjpiU70J65A/mbrkvo1foAfzwbmMsvOCV4SFOHHLFH12v
	FXz644M5eNPbw6HgmQtcIB7J2T4wxy0HfF2ekE8=
X-Google-Smtp-Source: AGHT+IH72jfKE70RF1Oa6frBAhrkdskftu8m+MAM/A7FQbZKX74yiySVenp9il2eRaFUaw7reE5LKXWJYPxYeSmRZBc=
X-Received: by 2002:a4a:682:0:b0:594:c1:2bd8 with SMTP id 124-20020a4a0682000000b0059400c12bd8mr1560281ooj.10.1703137286088;
 Wed, 20 Dec 2023 21:41:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: by 2002:ac9:6686:0:b0:507:5de0:116e with HTTP; Wed, 20 Dec 2023
 21:41:25 -0800 (PST)
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 21 Dec 2023 14:41:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9cd9hZmtLc2zyuVbMOKw216bX5fNvo_=SZUtj8YkwkJw@mail.gmail.com>
Message-ID: <CAKYAXd9cd9hZmtLc2zyuVbMOKw216bX5fNvo_=SZUtj8YkwkJw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/159] 5.15.145-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

2023-12-21 1:07 GMT+09:00, Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> This is the start of the stable review cycle for the 5.15.145 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Dec 2023 16:08:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.145-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
I have run the following testsuites against ksmbd.
 - xfstests pass
 - smbtorture tests pass
 - file operations test through Windows client pass.

Tested-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
