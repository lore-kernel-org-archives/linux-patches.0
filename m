Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C31621A1C
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 19:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="IdZx+F5f"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6ce532451c7so734145a34.2
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 12:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1698088224; x=1698693024; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V5dCh8qscABtOqwm1BbzDvVj8ruCpus/OdmtCpZWjQ0=;
        b=IdZx+F5fUsgLyfvRHkUGLJEQ1dPF6ySu4yjnV4keju/Bi+XeN/22GjBHgiduVSQ430
         xxKTzh30hFU2BaNgklQlaOa1d8qI59PWpBIvrP4DGm+4kVmk8nky0h7EMfb5N6KPAfMG
         fO8JHkXoWkan5jKq132xEUop16o08+zUBk7Nk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698088224; x=1698693024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V5dCh8qscABtOqwm1BbzDvVj8ruCpus/OdmtCpZWjQ0=;
        b=RDUJA+LmCsfwJWBsTxoYrg/b/AFa2zGeIl8QN3KAmaasWQyjFdRV4Y6eGSCNqN4n6a
         YblQ28ltCiKmbRO6lnZ2x5Iueeck2o4ncGVwNoGMmfDqt7LtWphObDl5DfqN6UY7+90S
         QcTlFTSrFjzrrTZAx5XK+Jb5AZ1UtcJJCTWa7LugBqogvARR7DZe3JB+TZNlv9duvw7E
         ir8Iq9zdOgpUhJ7vHP6b1dRrz3tWnuxitEJ1b+ODsUHPxjmBI0+fmZRWtSI/nywNgkmW
         PJjvqHoIT+fLyOXSgIW2TwheSi/6g0VXmMaIIFJrLkuj+fn/jDP/tJA1QtebwrgCytMa
         owFA==
X-Gm-Message-State: AOJu0YyyhAVrEczS3MZzXcnTYS438t3bD5MP13g/fNtVa2GFKibd/PFy
	IpiruuKmCeaUl5zrP+fZd1wh2g==
X-Google-Smtp-Source: AGHT+IHCpcHou3BX6f5py1fK64rYTiaV6rKcRtQ6XKHVdySmwQAxFZ6RHax21NBS+y02N6pwIh0adA==
X-Received: by 2002:a9d:7483:0:b0:6c0:79ed:be35 with SMTP id t3-20020a9d7483000000b006c079edbe35mr8435872otk.24.1698088223968;
        Mon, 23 Oct 2023 12:10:23 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id m26-20020a4add1a000000b0057bcbc23738sm1612572oou.17.2023.10.23.12.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 12:10:23 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 23 Oct 2023 14:10:20 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.5 000/241] 6.5.9-rc1 review
Message-ID: <ZTbFHKxuwhf2LccC@fedora64.linuxtx.org>
References: <20231023104833.832874523@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>

On Mon, Oct 23, 2023 at 12:53:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.9 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.9-rc1.gz
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
