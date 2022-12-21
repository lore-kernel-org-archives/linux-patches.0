Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2938D28EC
	for <patches@lists.linux.dev>; Wed, 21 Dec 2022 16:18:45 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id c133so6790167oif.1
        for <patches@lists.linux.dev>; Wed, 21 Dec 2022 08:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M+bNXioDxNImLTRjcMNz5wv3wPkQ00PwGxcuhrFvOFA=;
        b=ShqBpPcKfU39heppFQgA+EfPn0ynOOQyj+YmUmCRkX3CdHJjmyJ2JK1jkHdpAHr+LL
         F9B+EYn8Yz35ZsMqBsJ2/jDVd/9Qsacr+f/rOu785CEBZe65aEkjvpO4vws43SnUodHY
         LzvHj7lZskMbNHooN12F1rGCGf55BfggbTl5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M+bNXioDxNImLTRjcMNz5wv3wPkQ00PwGxcuhrFvOFA=;
        b=37fMnEJ94quVB40rhm0lRwyG1N9VIaEEKoxSMx+viSH2eud2GJ6QUczThUJYB8QwjP
         +qA8y41buj6+f4Gi1gGL+8iJH+Q4x26g5eq2O7aEJuIvdKfdHahk/HCOZlD0z0p51IBg
         9HeYhTHZNPa8C5ALSUt4++jOaWzwScsxr/sx7t7Sxn/G4sCJMxSAB8gTU5LogdOCaslU
         Tq2GepAktONk7HUTASt05ZKpK6aUDBwmuz9ycL3SG+J4gC0vJdG4poBjBP4B98mXL3yZ
         1yslwGt+aK2yV4ySEJJ9jltZz9Y9373NwSaGyVhAgLuoDtTmiDj25d9b1BKXR1wvxqsv
         lbxA==
X-Gm-Message-State: AFqh2kpDDeBS8iyBaaKOWFFhum8ZsAOGRewQcT6TNbImi7FUuqGLaDIJ
	T45zJrzX9eQSxVrumh1+COlDyA==
X-Google-Smtp-Source: AMrXdXtcRbZ41cs7IPkAwPfKR/1iE5afGVWCLVd3aADKKt5k7zhXfOz0qVd3i2fxizOY6AHvkI9m7Q==
X-Received: by 2002:aca:1008:0:b0:35e:bfd2:4b9b with SMTP id 8-20020aca1008000000b0035ebfd24b9bmr1022506oiq.55.1671639525042;
        Wed, 21 Dec 2022 08:18:45 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id es10-20020a056808278a00b00359ad661d3csm6891742oib.30.2022.12.21.08.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 08:18:44 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 21 Dec 2022 10:18:43 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Message-ID: <Y6Mx43EwwV1akWCV@fedora64.linuxtx.org>
References: <20221219182943.395169070@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>

On Mon, Dec 19, 2022 at 08:22:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.1-rc1.gz
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
