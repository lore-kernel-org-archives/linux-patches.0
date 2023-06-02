Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE772332EE
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 16:56:50 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6af812703b6so1318086a34.1
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 09:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1685725009; x=1688317009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UpFkoBOgIhm6mVYnAm3/uE52vs/uGNgQbLUnzZ8e50A=;
        b=OYTGcuM33CecRMp0bGXgKRvNrSjIqKgpvkYDOSRdh6fe8CHOCEdAr1Frby7/3YtOWq
         seQc9WxsFfEXsBsVEPABs2F5x4iUvW4Fju58l4vzqWHstTxWJun+rg22pagiK7Z6HpEA
         W/72rYdED9jIxY/+FA+YrIo2TEfPcD2bQNRT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685725009; x=1688317009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UpFkoBOgIhm6mVYnAm3/uE52vs/uGNgQbLUnzZ8e50A=;
        b=frH73nYPqJSE7zIb83W3xNVP30P+NmNvOqJ8aG8YMKHr1mgO07fhb333Hm1fGvz/EG
         tjHMvu9bqy4HmXIioPKr9/U+qYgkNWE2NTDlo4odbZCVr5Ka3xt4MtUMKM+hX7QSrteP
         7R6UXV6mH6QujGdbZq5mJ1wU+sKr8CrYEhVWBhfXyHYrXnJwWCgMiaD1Y09Jgc9DImVW
         ZA8sd0TwIQDLjiBSkDSQVuTfBse9fq8G+3RHQYW3CnoHdurinsU5NcDcWukkwt2aqczo
         hKbOQ6OU8IRC5kStTcLygKFU3s6GdfbrM0LgAi6Olp4DJJzHBzTEYmkLuQV3r9JOy1W6
         uOOQ==
X-Gm-Message-State: AC+VfDyxf5zeHCAc99d/63rusxb7AQAmgNYCmjenjqPybjj+ehkU2HO5
	0/PMP9Df4lENx61kil6l8XPnDw==
X-Google-Smtp-Source: ACHHUZ7/PTjo9k0bGsi3dIeEZREUXDAf8wSbxwJM45eAIKUPenOyP0DS66nNoBJMRzqoRnm6VX+zDg==
X-Received: by 2002:a05:6830:1042:b0:6af:7493:79be with SMTP id b2-20020a056830104200b006af749379bemr1930925otp.10.1685725009629;
        Fri, 02 Jun 2023 09:56:49 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id l2-20020a0568301d6200b006ab305429e7sm807579oti.0.2023.06.02.09.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 09:56:49 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 2 Jun 2023 11:56:47 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 00/45] 6.3.6-rc1 review
Message-ID: <ZHofTwvKfnZmRhww@fedora64.linuxtx.org>
References: <20230601131938.702671708@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>

On Thu, Jun 01, 2023 at 02:20:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.6 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.6-rc1.gz
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
