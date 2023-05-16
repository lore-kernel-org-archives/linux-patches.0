Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19EB24EA6
	for <patches@lists.linux.dev>; Tue, 16 May 2023 12:04:27 +0000 (UTC)
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6ab1942ea59so5711744a34.0
        for <patches@lists.linux.dev>; Tue, 16 May 2023 05:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1684238667; x=1686830667;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kJosZkuHbiv9aC0zid4KAAbdE5AYoHy0os35a+6yEh4=;
        b=Hcjeuhev/jBUZbhhXSUbEKHdp1VBSFZN5JNVv5uUtxT099arEEawMJcrkMjcuzn6/5
         xjtNCsEK4UxMhhGHiO0vk04bpev1//ZxPGcPUTUvWVtMShJE2H7X4Y//7mGc+pCLmaYa
         WDiRJKeeXeGbNi2tR8PKFFd4nC7Y7p4FVwlUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684238667; x=1686830667;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJosZkuHbiv9aC0zid4KAAbdE5AYoHy0os35a+6yEh4=;
        b=FhvsVT+bQ8VpIl0NiW5vSK02TXKNTocvx/9/MSsq6oM9VDqdZAofiZ9ig3MTAb/8cB
         zeFxy50pvrZ5XV+5cG6aN3HZ4T7QYm1YlMXvtZNw6oaq0g//ZEPBwOWcAuDuSQkhSzd3
         avcncz3hDWZ/2yWtXKI/L6gSWi8q7BbEw3aYf5LtJ07BnoiYeFdpb+kMztu/p2irNYxv
         Dn9qOXBdVpJpT8MXNUADNh6eMlWXZP1eWHQ347xLEwaR+BzCDZgOseXu7YwQlHCP7v4V
         kfqLB/6MKBc0VVvOgfeyBEQe8Uzu3X8PFP8hQtwfuxAMB2dTpJzwQ9nkAxpABMYdTN1I
         a7kg==
X-Gm-Message-State: AC+VfDxVCwchFm5Zm6FH/3XYpmyhF9VEmExC80oM1uqWaNOqPJIIRrch
	w4DYdH77GXrXxcaHtpj6bo5FLQ==
X-Google-Smtp-Source: ACHHUZ7H25k9zBFLAifLfWin8oqXETP7UGnj9dxYlhdJA5TKaEpBbP9ob2KBM3FhI0weuJw9l8GF4Q==
X-Received: by 2002:aca:2301:0:b0:38d:ed4a:52eb with SMTP id e1-20020aca2301000000b0038ded4a52ebmr12456332oie.38.1684238665298;
        Tue, 16 May 2023 05:04:25 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id u14-20020a4ad0ce000000b0054f9f229bddsm8082829oor.15.2023.05.16.05.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 05:04:24 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 16 May 2023 07:04:23 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/246] 6.3.3-rc1 review
Message-ID: <ZGNxR9S9pNU2+BiP@fedora64.linuxtx.org>
References: <20230515161722.610123835@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>

On Mon, May 15, 2023 at 06:23:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.3 release.
> There are 246 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
