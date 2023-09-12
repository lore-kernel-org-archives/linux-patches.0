Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30871548F
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 12:27:53 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6bf0decd032so4179325a34.0
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 05:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1694521673; x=1695126473; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LW6egm8EfUZADa4f85G/hF9JcQWbHdUo0uisWQrhFUM=;
        b=IHylcxYLcef48PKUuMZT4oci29MW560WvQfSsvbLAPLpBHHqIKmc5M3hj7dD6YfVoq
         KHhpfF3yvGKx6ymOs6AaUB5ib0gux8KBKwy983sgUxPKEywnr7ScKwVO61ndbSOdFEdf
         OO9DbaSFbW0vXW/yc5Co3BE1pPGTl35tLG5nQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694521673; x=1695126473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LW6egm8EfUZADa4f85G/hF9JcQWbHdUo0uisWQrhFUM=;
        b=ZNsVF6v8kH/ZF8k8hh7W/YaK72NStDLilNKPvIXHSkKmBx+n2iFQVety7K3gDvkMb1
         cgN0NCOHvkrFSOJALseXov4N9ksR5Rw1G8LDyjKbbsCGgViEasTHLuw0Yq1Cdp4nhopM
         qaWse62BpW8meuaJ7Ig81AQvZq3g1JDus12yPysXZfaoe6136/7GXydWJhTcHC2jDNCA
         ldt9YbIoR5quVFXkKnCqUoZpt/iRX51a3lDnqUfKdaUALg2EbhzoeZu1UOQuc01Nr7ak
         mO+jMhixVS8eXvyevemtc2MpSvO/QpRrxUMyoXKxlDVq1akxu69VyJr+2AbaDnL+GAS9
         DKiQ==
X-Gm-Message-State: AOJu0YwdBiyy8I5DMYzJKi9VzuZdUGLSZ0Vn1laUXOWuc3LGq4KTuCqd
	eIND2vYRmqghc5c5bap1IUTSqbx+Lgx/UaHypxUek9yI6gbflg==
X-Google-Smtp-Source: AGHT+IHYhWSb/77EH45rfz5++hlmG6uS2RjCpx31TFlOZp/3hO4QCJww5a7Duz2eTIkBC4CZcJrFgA==
X-Received: by 2002:a9d:69d8:0:b0:6b9:a192:aaf3 with SMTP id v24-20020a9d69d8000000b006b9a192aaf3mr11865415oto.17.1694521672873;
        Tue, 12 Sep 2023 05:27:52 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id a23-20020a056830101700b006c09291cde6sm3979906otp.0.2023.09.12.05.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 05:27:52 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 12 Sep 2023 07:27:50 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.4 000/737] 6.4.16-rc1 review
Message-ID: <ZQBZRh24I128Tftp@fedora64.linuxtx.org>
References: <20230911134650.286315610@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>

On Mon, Sep 11, 2023 at 03:37:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.16 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.16-rc1.gz
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
