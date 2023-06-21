Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8577C10FB
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 01:43:56 +0000 (UTC)
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-55e4a928a06so1685262eaf.1
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 18:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1687311835; x=1689903835;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SiQP1jHlYts9ei42Kje7uuybDGFkCPMKW6fLxqW0GiQ=;
        b=eyo2+1tt/wjSAvh/4eqexOZDURyX977loFHrLQnKsrHGxskNH7ih/3HVCpYB9ojeKI
         p/zcgnVaOXxZnb30n1yG2vWeKs5o7hm485rJnho6CjE79pZvj6udvWxW2cU1sbXQYJis
         9qarAptK2F8vgDD7vVq1ICwfuqvm0eDjs4lS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687311835; x=1689903835;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SiQP1jHlYts9ei42Kje7uuybDGFkCPMKW6fLxqW0GiQ=;
        b=fFoZ1XOkVa1KUzKVDWpg2z4iUr7R1/N9j/LSn+RJO/wW/RiJBr00Qam+2jqsL7tqpa
         HG96cIqQUbNB4i9bXVyuta+s/PHcVeOcqI7aw7lBQo/N2WRga/CWm6KsWWwOACTgwgpg
         dkuVxwyGBT7UlmytpmhAVBT7PC82aMrB1HL+3VsAeSWnBJAYnhjQBkrQxr0OxLtqyUvu
         sf4/+D8dUahTCba7ONm7D4p+6VEJ9XrTLD0eYRhkmMbc58jQb5t/9bXrn8weOs3I0/nN
         /qB+PfZXfRMGJz3RThMMMOUcNe/I85+ftYeqOz8mNfPMrdPRDtLAHBp6FyohJW6V8PVc
         Znpg==
X-Gm-Message-State: AC+VfDzynDRmaCMRVem+tFOym5Re/7B5dDDdFiVoB+mIxhlO5RJyRay4
	BSEOdJ8XsuvEJTkTFyZQOOli3g==
X-Google-Smtp-Source: ACHHUZ72lHHABBGAJJ86M1jspfPWwX/74CyldiRGocbUhmTFZQaawSSzMyZO2vBmaiYBbJyJ5Vn1eQ==
X-Received: by 2002:a4a:e888:0:b0:55e:5c65:c6d6 with SMTP id g8-20020a4ae888000000b0055e5c65c6d6mr4697130ooe.6.1687311835171;
        Tue, 20 Jun 2023 18:43:55 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id i3-20020a4aa6c3000000b005607e78c3a9sm1511758oom.40.2023.06.20.18.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 18:43:54 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 20 Jun 2023 20:43:52 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/187] 6.3.9-rc1 review
Message-ID: <ZJJV2CUyz6E6Rftr@fedora64.linuxtx.org>
References: <20230619102157.579823843@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>

On Mon, Jun 19, 2023 at 12:26:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.9 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.9-rc1.gz
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
