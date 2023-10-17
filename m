Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8E342BFF
	for <patches@lists.linux.dev>; Tue, 17 Oct 2023 12:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="S6CoPJge"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-5a7ac4c3666so69012587b3.3
        for <patches@lists.linux.dev>; Tue, 17 Oct 2023 05:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1697546065; x=1698150865; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gIl0fBWnXD5rRLm1M66vQJGMMeQ035Rboe3KXMky3Ps=;
        b=S6CoPJge7k6jldrU/W8tXHqvyVsROhkekVlAc5UoQGSlJ9hMPXHxE6vKIrr163Bd9k
         lIz5CIi5mhjJgi9jvrCI4n6UDig+8r8g055bZAKnJcPCIO3x2ard/DgEIh2eOB1zOdcd
         22yMgIufajH0Uex20nBoExi5WJs6JbxiDIJGg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697546065; x=1698150865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gIl0fBWnXD5rRLm1M66vQJGMMeQ035Rboe3KXMky3Ps=;
        b=WEFWxJFiynZZfSchqMIml3WRv76k9OYiuQAvUgU1Yp6p8sZ4gmSOJ6XFLVctUUzaE4
         pX77jB4wzTlwCvGUostzZvSWkNOFCsH9z0Fku8D4FfReMfPRr5AZlTYGH5puvqO6F76p
         yD1HHZZEaYH0vJ/VoafN3pYyws1JXYxc0+2eam/ilDMrm1w24emcQ48kChQFIt6qpI7k
         sIRSJXY3aFg4sIDZHQhXTd/WhKw7xHgqBTU7Rg7mEXE/VtslWjYbMAODFiOVfRWXvewu
         t46coK2NQaGyUYqXdL/krriGH4zQmzsbCsCgHq6ZwrrWW3EmEtCtH9isw6h3FvvMGX70
         5B5Q==
X-Gm-Message-State: AOJu0YyeqZrIHllYDmeqf2DMYDmeAj+/emQvokCHZF60m1/VCP4uPfW7
	p5kb4ovjbY2GZA6b9kFUhsmmjw==
X-Google-Smtp-Source: AGHT+IEuJvyjNMSwYyn5xvBEcpAUsKV61Cs7TO3ZfWjOoko2MioWCtZU9FfFVgeRolHZ3Xwronhczw==
X-Received: by 2002:a05:690c:387:b0:59b:ec11:7734 with SMTP id bh7-20020a05690c038700b0059bec117734mr2107670ywb.39.1697546064911;
        Tue, 17 Oct 2023 05:34:24 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id d77-20020a814f50000000b005a7ba08b2acsm587509ywb.0.2023.10.17.05.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 05:34:24 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 17 Oct 2023 07:34:22 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.5 000/190] 6.5.8-rc2 review
Message-ID: <ZS5/TktEeU//QCuJ@fedora64.linuxtx.org>
References: <20231016185002.371937173@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016185002.371937173@linuxfoundation.org>

On Mon, Oct 16, 2023 at 09:48:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.8 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Oct 2023 18:48:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
