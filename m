Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174663C3D
	for <patches@lists.linux.dev>; Wed,  8 Feb 2023 18:45:33 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-16a27344a17so15088582fac.4
        for <patches@lists.linux.dev>; Wed, 08 Feb 2023 10:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KSn/C1OjXBrUNFQN3FvWdY6XkcZfs6wdWyMFAnR5BhA=;
        b=HNzAQhW3Ao8fSueXBzGJed815Tdu47jyiyXtlkqn36u/ShQ9xb8BnCpHzOj3IU+chh
         IFYhJFCGPU8WheCE5omseiGLHofOgkWH1F2oJFOnkqYPY7R9wiaauXObsS/IN9JQ/8qE
         ZabMHrrXFiyiJSkfVtZwax/MMVU1EkA+WaPSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KSn/C1OjXBrUNFQN3FvWdY6XkcZfs6wdWyMFAnR5BhA=;
        b=vIqJ9k14BqdMyrl8dAqTW78MGv2K+JfORFRrnT+HUByiEF+0CdaQbjt2/Tv7GUV6HI
         syFONjJ+s6HrTd0NEhxQQPdAYTuOSKBVfQUDK1+lPb63Xp+GhkW+GO0tEWTlqfaq1dS6
         WzYGhmIOZ4ncSzjAVr5L1SHOshrKfo9s9oLBTP34Cx0H07mw2iPHIt1Od5QmeV2cm7t2
         APbTxwLgz0Viej+Cp7dsWnUQeikpOfZNdnwj3qaQdwVnyCZ1ZMI1zZGN4nKuhfhPEdiM
         n8XnZ3LHLBYAIz9yI/O2Y3h5UDEaK2jF3Gc5fODB+qTxqMDpSqKl3ESmMekLtVe0bECn
         ILZQ==
X-Gm-Message-State: AO0yUKW2gDn/GZ3czbXQe5F7qM7wf1tEEPOf9BUwAU/GZrD4B0qdOtR6
	i6WjiANnTbBUvAEcXkDk5wp2Hw==
X-Google-Smtp-Source: AK7set/D/rCf8TU1DvW7e62jT2Yk5a3LyTNPjHU6O9n6cyi0Qn3mDOAhaqSJ7UNa+DREMN3yIT5jzA==
X-Received: by 2002:a05:6871:726:b0:163:20a2:ddde with SMTP id f38-20020a056871072600b0016320a2dddemr5438224oap.42.1675881932929;
        Wed, 08 Feb 2023 10:45:32 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id t22-20020a056871055600b001600797d1b5sm7051291oal.41.2023.02.08.10.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:45:32 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 8 Feb 2023 12:45:30 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Message-ID: <Y+Ptyvz6M29TT3W2@fedora64.linuxtx.org>
References: <20230207125634.292109991@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>

On Tue, Feb 07, 2023 at 01:54:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.11-rc1.gz
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
