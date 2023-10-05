Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D79330CE8
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 16:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="HBahJC6H"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6c620883559so784330a34.0
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 09:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1696523770; x=1697128570; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vYHj3JFmAZKHkL+wnxS109TagHXpAewcZFhlnZKyAfc=;
        b=HBahJC6HaeOm3hLANdEyLcVmBwgp1hY7c2vgG+TJAv2xwjZtmAv+JN8oT/ZwmAniSt
         /Qlm1KtWkyg0wKMPaCcWsmY+1iF1t+fPD9LPKxFjIqk+H6iyKjO9gt/I1t64DBeJmqt6
         NCk10HN9sj/SivIMHO9GFlm1enCRAmLuX5dxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696523770; x=1697128570;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vYHj3JFmAZKHkL+wnxS109TagHXpAewcZFhlnZKyAfc=;
        b=N89w6rCLgFGFw88g0K5CxNeOKTponbr/2x9zOqo4GFm/rNq0POpcvDLMLxRsfSQ51b
         Wz8BNNDui+qLIcd4I7NSWJGyX6h31EPs0v5XlRQ/21Vd41HWr/rJIkmQSR4EwtOme6jV
         2kdM2cg66sxX4YW5C3uijdRXLyAIojP+NsDIo2nXRd61tgj7h3aEib2wYdfetH3EQzvU
         k6kSInuoeBfQvZ81k6KoRWJlEBxjrhhVJNFGm/Ceeax6oCS0OvOQEBzbEQ5tIxKJVhh5
         sU3BcERIMB+3dS3MekN0coXLDD6hcgLeQgjCOPjN8x00eh/UvFLJ1Nzy4hiFQNhxCJqB
         gD/g==
X-Gm-Message-State: AOJu0YxW2Hx6+u0RR1VWMYO2CQ44kSZhvPvIoQnuuLslYaqsucIFYIkE
	KfvKste5OFHqmJMYUMa6kTO62A==
X-Google-Smtp-Source: AGHT+IF1vZ6WboGp9C0l3uWZGG1N65oSqv2B+LlOIp2OMdFj2L2Gs4NqCVYwe07cua6EJsyW/v3WUg==
X-Received: by 2002:a05:6830:22e6:b0:6bc:fdc8:d600 with SMTP id t6-20020a05683022e600b006bcfdc8d600mr5849783otc.25.1696523770407;
        Thu, 05 Oct 2023 09:36:10 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id q23-20020a9d6657000000b006b9734b9fafsm304356otm.13.2023.10.05.09.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 09:36:09 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 5 Oct 2023 11:36:08 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.5 000/321] 6.5.6-rc1 review
Message-ID: <ZR7l+IbugqOLaQtV@fedora64.linuxtx.org>
References: <20231004175229.211487444@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>

On Wed, Oct 04, 2023 at 07:52:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.6 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
