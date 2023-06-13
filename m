Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550D438CA4
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 18:27:24 +0000 (UTC)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-1a642069ec3so2840738fac.0
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 11:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1686680844; x=1689272844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OD/sBnMhOS+76TBbX745v9EyDJOqWBR1zdKjyXB6hEo=;
        b=TNvKEBQDz0UXjGY82Rdzzk7mJQiwrkyJVwvuxu8n8m0Pi2aswclN30CIh/rhXgR9EL
         GcUphBoC3mHb5JyYtboioVzFLX76O5uxbzvCqp58ta7SwnjUsDKVDt9AWw9Y9o3re5Ow
         1Btu5L4SF8IUndx5WaD12X8bmEvsxLbVgaYM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686680844; x=1689272844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OD/sBnMhOS+76TBbX745v9EyDJOqWBR1zdKjyXB6hEo=;
        b=ROJycmGgddf+Vf6q9mbe+JJG5PkZe3EBJAOQe7eqo4Om1NAKx0CP1bKVSpONL1dGwa
         lRke91NhToQdE5Uzj8umu2NcPms4aqnmOgb7FOKtEMpom+qKzKfjLZUWmCP30Dk0PsfQ
         nTW1booLd7klsTDIxdJ3sCxiCJRCh0BDbFkZF2NDQjREcAKGBBOH6T6pwaBhYe8EGYHq
         htaRpGMa/a9/+tlK7OgnR97W5mNIwltEPpew0mir4BFU02eziW5dPJ58hvleR1jWHvZM
         Gu6IiM5BnTPJ0E4om1U/5/W+4GW2GdL3BhDh+/SootiLuY+kswN1JWwxFJk6v/ADxGyh
         fsKg==
X-Gm-Message-State: AC+VfDwppoGNO7dIn9Sq6u9S89IZCDdtO5W4Gbsxb6mZpb0cgARjWVu+
	XLtdbU/EHmq9lZ5z0rgfRFeD8Q==
X-Google-Smtp-Source: ACHHUZ7ahhE3kP1FUW/F7G37fNcHq4Fz7WbfGH3XVBVth497lPJQKvXVRBAUtifGjYjKR0kmMJqoLg==
X-Received: by 2002:a05:6871:69f:b0:1a6:b5e5:29c6 with SMTP id l31-20020a056871069f00b001a6b5e529c6mr1822097oao.2.1686680843802;
        Tue, 13 Jun 2023 11:27:23 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id k19-20020a05687015d300b001a66a48a68asm4236294oad.57.2023.06.13.11.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 11:27:23 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 13 Jun 2023 13:27:20 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/160] 6.3.8-rc1 review
Message-ID: <ZIi1CKTsIJo+wLaE@fedora64.linuxtx.org>
References: <20230612101715.129581706@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>

On Mon, Jun 12, 2023 at 12:25:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.8 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.8-rc1.gz
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
