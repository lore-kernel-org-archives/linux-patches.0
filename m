Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B254C7B
	for <patches@lists.linux.dev>; Tue, 23 May 2023 14:33:44 +0000 (UTC)
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-39831cb47fbso404818b6e.1
        for <patches@lists.linux.dev>; Tue, 23 May 2023 07:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1684852423; x=1687444423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GS7c6oHmTob6/hE6yrL3ruWPbjjNTps0ZQSki01BgBM=;
        b=OOYnMeNzMvIZ/UmDhCqiWGR+hsoJt35UBBjyInbWS0Faszmow8yFWapBWXv3E9qRI8
         fVbAq7Y6g3Jz83v6krxhpMGgYP1vu4CFgrZEHivastnBOVIAuC1PQIf2w97l3H8ScQgB
         A2Edd1VHeF+R2EMPi15RaabTgaj8c5O+NrAto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684852423; x=1687444423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GS7c6oHmTob6/hE6yrL3ruWPbjjNTps0ZQSki01BgBM=;
        b=blrXkhn6m+AZmTk4bFnLl4MFsGW8iyWp4MEwXylWvP1Isc6f07Nf5PNdDG9HHGibCm
         D3LAkBdZYFaOrpa8Y25nlk1xqAkETrZwu2P5uv27hcsnXJeAlITQY3O3q9E6fTlhXIt6
         cwMwB2BuR7IwZQeWXsa1u3JbW1bhZC1aC0qdYtl6nNTLOnDLf6d9jVGbSvkBa1Pyw8oJ
         kC7rBQWwR7UwBz2vk54hm0Zpyp1AjPq5uJ/kxf+FuvF4SR/hyig2KPXKMw8PanDufEAI
         hlTunBe6s7PgyS77GLM8Yhr3Zm49QFKU1ZCFi1C1hpqAnSkDRceMtUOvl84qW8TBSgaR
         7w9w==
X-Gm-Message-State: AC+VfDxUArZVLeKSOcNcatvTbf2veO0C3qFGcllkS1fSJrCnQ1IpTXcg
	aQEwdNnWrOXfGFMzRQBHVYXKAg==
X-Google-Smtp-Source: ACHHUZ77NQuNSJ/WUE59ifAGWs+jieauwYGmQqT5t+W0QIlmrLSPFN+DDf3VNNqvVy9mlFIG7pDzQg==
X-Received: by 2002:a05:6808:10d:b0:398:2fa5:2eba with SMTP id b13-20020a056808010d00b003982fa52ebamr1014772oie.56.1684852423319;
        Tue, 23 May 2023 07:33:43 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id x21-20020a4ac595000000b005526bfbf131sm3387767oop.26.2023.05.23.07.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 07:33:42 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 23 May 2023 09:33:41 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/364] 6.3.4-rc1 review
Message-ID: <ZGzOxWoPVEwp5/DD@fedora64.linuxtx.org>
References: <20230522190412.801391872@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>

On Mon, May 22, 2023 at 08:05:05PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.4 release.
> There are 364 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 May 2023 19:03:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.4-rc1.gz
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
