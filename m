Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97096244E8C
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 12:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741783269; cv=none; b=tUObSgEj7r9iG0hMjgThBHzW+i9/K4gbhIVF0UfpuAOmfWBPB/4FuSfqsdOQpO9h9QqNFzRiZ9xfZS31NL0+Ri9zUZmu4nz6E9BP0VbVm4JEwC1GaHYrkllyafjsE33Be69l2fwja9/xqZ6Qmyl/8clw6y+nXTNzGKnBL9TyEGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741783269; c=relaxed/simple;
	bh=bUaSlUg3RSFBTsJCJQtMWIt/F/YS6Geb3jIJDsgvVi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MxOyME1VRV1smu2mmkZjw2t3ksuVynC2F8LTwk3poTuGfDf0I3O/YwYBuM8cUgv2Gc2UwCtcAb4NrS7b0VCB1f2ay/zov2PTDAx6ISo2QMVMzCG8J38OPwIU6/VMSGJAMQMf7JgCtph8vEkpOS6vPrTK8rkAmTDbnp8BBWQ2+HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Vf69fp/w; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Vf69fp/w"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-85ae131983eso463070539f.0
        for <patches@lists.linux.dev>; Wed, 12 Mar 2025 05:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1741783264; x=1742388064; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9dP4A1PaPKl7EUlUOAH0m0yidu5CcqdMAHhNJvQYeKs=;
        b=Vf69fp/wWpdMEuudUSWpNyHOGukVjx7vWqFwbu5mW7d9o1NakPph6KvUW3GwO29kNC
         dik0/wfwHtw18VAkZTOcn7mjt+sftNHbZ+O4n9BfCjfvew7AdI31BXUCqLzCrRQiiLbe
         BP/rgscnG14y4X8nHunqCWdD9mOJVdXwEmROc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741783264; x=1742388064;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9dP4A1PaPKl7EUlUOAH0m0yidu5CcqdMAHhNJvQYeKs=;
        b=RlP5b8EzGOB50Vsy5ROaW1wmMQkiy0fDOKvuR4Kih3D6MN/foBhkWqcEPj1zPCXwQp
         oK/YW66U89fAePMaUgbcyInpZoSNdN+PMheiXUFbjPuO7UQD4Yy55ieYXcpe737NEcvA
         +ovfJXD1iepF8oEnwjUS2Sb0MtSU+enitMGFeGaRspR2LY9xHDLnsVzXuwqct4Km6VZ/
         BdXkXgAeIgwba6sQwVJHRSvA62HkysN/ljR1ACfdl/TU8txw7XMPYGUsf0fZGuEN7UNx
         kIW5elqzZLq5BTpARFSiJ9DN4wGzK/rn424G2J5ht2Hp2v9QVcibxUwaAlKOFap3VlcR
         urjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrHPf16wSaJ83q4YMceXCqfz3VyKFH/mBMLFNXxSt/GdOhFkZ8HeZHMbmAoUt+fD2NVfIb2gPj@lists.linux.dev
X-Gm-Message-State: AOJu0YzCt1Sb8A3PGs60L32Sm7ndqq+pvEj7pcXU1g17PE3ZaPWHjlW6
	+M2SQ5vMbqucjb+Di/rqtM/2W4LLxwb1VZA/gZJVqay7wC15rzg0njhrOFMeww==
X-Gm-Gg: ASbGnctcmBfL3TzbH4bAXJcra09GJP9tCtTfOCMcSrqhdD2GNyWMuI3pScyGKCoGXOv
	69K2NMW9SEZAsZMYRLAqCQLpTtJudebRROGJgHOsxZlIHIVwDtS3KiZ7s3wLZnu+4gQN2icx1xz
	tIrfo1deU1MebHiL8Wyn4cX+yDufodPRZcWnjzpZdZXimNCgoJ1SBNugFPJQ/u38JbHDGqY7go3
	CIdSQq/JrNPD8Y4X7w4WUnQGFnjL0gDWO4nHzJzDEtFdoKL3nmK45RaN8+dQ1qvCNn60WUUQKUI
	OmdONmW/wD+Pt6G/8PCOUOGLXkJc6nkdTO/OsSHL54C37zGoCFMtQ07S0FaztA==
X-Google-Smtp-Source: AGHT+IFLQqpuypHSRNnz0zBPbGSRwBTTy9nuZ3EEUDWO1+xrScavLssIudJZMqoxc71JqTU36mYhUw==
X-Received: by 2002:a05:6602:4008:b0:85b:577a:e419 with SMTP id ca18e2360f4ac-85d8e1ac1cfmr810913739f.1.1741783264692;
        Wed, 12 Mar 2025 05:41:04 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f209e15822sm3165046173.37.2025.03.12.05.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 05:41:04 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 12 Mar 2025 06:41:02 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
Message-ID: <Z9GA3nNRacBJxmiX@fedora64.linuxtx.org>
References: <20250311144241.070217339@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311144241.070217339@linuxfoundation.org>

On Tue, Mar 11, 2025 at 03:48:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Mar 2025 14:41:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
