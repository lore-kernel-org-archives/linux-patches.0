Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55F2BE5A
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 13:42:27 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1ccd5b1b9d0so1210229fac.1
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 06:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1693575746; x=1694180546; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=605GXJuY9VF2iuE9QUTMQaSiwWf8mYV89VIA5q7Q680=;
        b=C/9TUlmpDoQsGzmvzBoZIKRDnskJQO/VIhuztzSoDkV+tGhfR5IGxVYkFNZIliwjwE
         Zjx6ENF2+ESwMyXfyMZdP6CYKmvCnVWABzF+j1dlvWPc/dbDjmgPkueof7ECBaEH42Ew
         8gWvpbg3ejEcy1GaMdfdttrhROKdx4LWL0dMA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693575746; x=1694180546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=605GXJuY9VF2iuE9QUTMQaSiwWf8mYV89VIA5q7Q680=;
        b=R+UBM2JxVzHz414KiPsofrAAYTsu4yzF3TNsXXFxufrnpDWQ5IRPXRqzLx47HwcG1P
         6Y4v1rmV9T32M9E/LLOoAGFAv+b2BGx1UaY3HaezsyCwrmSZzrqAszVWjs7Dp8ZNtve/
         ccwlQBaj1qwELEvCZXMpJwbYI/mHdmZEx1MsUIqen6S7gYp6BwaNHVoZQ8VSeZ/RX9z5
         djk4m/UBd72+eepxGEFMxTacDy+hc3NYj4tlomA9uhBSqHjciqe0v8XBmwRDukdMxae6
         i4g5ndPH4MHHDQXdaFz3TXDNF9IT6+6RPox2nM2zgpnP79HC69XJJ1K0lYUpkO2LM5Pj
         8MYg==
X-Gm-Message-State: AOJu0Yw6HBO2CdODfZjIOjnuFJUWpAcAvKt83Frt4qPvvJsusnuSL6+H
	Z76TsYldHpC4joyvSbYh0yHYqg==
X-Google-Smtp-Source: AGHT+IEnz/CwVS9UgmJ48qny79FGnNZJqSMHcHKkMABKmFxPd2rM5sdazTnUXn1t+J4QxMgAzqE44w==
X-Received: by 2002:a05:6870:6312:b0:1bd:55be:5880 with SMTP id s18-20020a056870631200b001bd55be5880mr3066060oao.42.1693575746481;
        Fri, 01 Sep 2023 06:42:26 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id t23-20020a9d7757000000b006b83a36c08bsm1792754otl.53.2023.09.01.06.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 06:42:25 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 1 Sep 2023 08:42:24 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.4 0/9] 6.4.14-rc1 review
Message-ID: <ZPHqQGaILoFNy6tX@fedora64.linuxtx.org>
References: <20230831111127.667900990@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831111127.667900990@linuxfoundation.org>

On Thu, Aug 31, 2023 at 01:11:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.14 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:11:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
