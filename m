Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5209612B72
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 16:41:12 +0000 (UTC)
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-572a7141434so2093755eaf.2
        for <patches@lists.linux.dev>; Mon, 28 Aug 2023 09:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1693240871; x=1693845671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/YxFxiHk+V4WPvxmce4sVK68Zw1aZ82QkNmJDshmYps=;
        b=ABFGf+UCJrERZ8Rir5RFXLgrlhU6YGPPPNs/LtQKppVzEbwXKMi0JAY05X9oAWQY+T
         O5CXvHrlicbhWI6ensHMDap3S8cYH91eWCOkaRCloyf7iDUTEWprj0HHUmBlEHO2ePao
         OE6170fgVEmXv38ohxGU9vCGL7XRS9B69aCUo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693240871; x=1693845671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/YxFxiHk+V4WPvxmce4sVK68Zw1aZ82QkNmJDshmYps=;
        b=ElpMrlCL/WNEj8y4+A5yabQBzy+gT+TINENe8re0tQZmYuZakvsALkBn+ghcrq+DJE
         9Yo3fKAbHU1wm40JRvwe9aKgO5zOy8k5A3IWHXOX8xqI0IkWOrdloVmGvMNhu0dmY98G
         CoFvm0jngAqGr22K03/7+6rstwGwkBBPX2jSFYbagKZ1bxWrL4PisIyN29P1DOsxbP0I
         U3Yzv++Kn3tX62wdJVSKQVADgSBRhJEziiTS11IjfdEaw4swSMziLQW6xQTwqx3EZq10
         3/tLF3+8W7uNHccp4C8UjsvGIQbgaKTvrRPJjwDCYUT7Ee93dOvfrpbaBsfTMzI1NjoD
         x65g==
X-Gm-Message-State: AOJu0YyHy2JBjda+emwQPDysYHW+Ld01PcAsq7X5KAxGK1vG1a5XAFtn
	u6CTwt9bNJCMyEVg3DtShxeB9A==
X-Google-Smtp-Source: AGHT+IEjYCpyQaKSkqsuwF3CM021iTI/a22UZD1yTLU1DB+P2mSTJnOXxTfjx4GvnBPSA6DMVg/njw==
X-Received: by 2002:a4a:6211:0:b0:56e:a1d3:747e with SMTP id x17-20020a4a6211000000b0056ea1d3747emr11575028ooc.6.1693240871184;
        Mon, 28 Aug 2023 09:41:11 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id ay3-20020a056820150300b0055ab0abaf31sm3812150oob.19.2023.08.28.09.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 09:41:10 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 28 Aug 2023 11:41:08 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.4 000/129] 6.4.13-rc1 review
Message-ID: <ZOzOJEfDcR4pS3Do@fedora64.linuxtx.org>
References: <20230828101157.383363777@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>

On Mon, Aug 28, 2023 at 12:11:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.13 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.13-rc1.gz
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
