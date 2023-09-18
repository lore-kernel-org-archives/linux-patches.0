Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787F01CFBF
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 15:25:52 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6c0b3cea424so2959273a34.2
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 08:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1695050751; x=1695655551; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YVKIu2PP2j4ok3fw5mLN5mcVXh2mH1/J+kvJoPupo4Y=;
        b=XMPt6xKG2nSAji4vnfItRiTbFu166BL8NvPTAcEaM/EpBKR+UsLmqgv4k8hpfJ3Q6h
         uCPHMtj7HrP9MAZfsiXf2bDhKYGCifzPQlLDlDFziwynxU9GYiVB3Zovcxb7UT4n6wuu
         xWX4VVjShw3TxYztYyWmjyPikn86aJj+v8Bzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695050751; x=1695655551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVKIu2PP2j4ok3fw5mLN5mcVXh2mH1/J+kvJoPupo4Y=;
        b=tjI4WTSqRr4ie6Wa0HcgLY2Uf75YZAVvSXBB+9+W7XjwTUaqVMDRKU4cR7rnb+bNAi
         TlcbpRDMTnIYOFnEC+Y6K6uSknb51IdVa2kTW8OgsieLaHN39gKmBQOvVg7C8SuLz3LL
         /5BRWMMtvmwd7WzzyFxkOuwro8iXxVIUW5tyUE/L5I81OA0cv3VX/uBjNuLBdIIvpO5Y
         IqWgTOO7YJ8D5GuFIrx1Oc9zVLrTeLYkhAjfqwrmTCJ756uojZiMEHRpUXWepi0a/tAW
         VKff/Px0yi5HtqJUS+rmtjaOqrPBhb8ikb+Im+YIpK8VSQvmvzPEIJN0m2sMMu3Tpnux
         vs5Q==
X-Gm-Message-State: AOJu0Yz8mTh3S1dErdEf/5kzj7JUSMoiPzHDGjoydTaTk+77qe25jXAz
	ri+5PzzJnTyOSaGptbVKGs1IXg==
X-Google-Smtp-Source: AGHT+IGe9SqnHwSEgpsYlD4JGoZ7FIJxs+MdYsxgK7B+OtUSYfkXctreGRJaR9bm+s8ZbO3v7rj0GQ==
X-Received: by 2002:a05:6830:2014:b0:6b7:1d93:72e0 with SMTP id e20-20020a056830201400b006b71d9372e0mr9169561otp.32.1695050751405;
        Mon, 18 Sep 2023 08:25:51 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id e14-20020a4aaace000000b0054f85f67f31sm4217899oon.46.2023.09.18.08.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 08:25:50 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 18 Sep 2023 10:25:49 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.5 000/285] 6.5.4-rc1 review
Message-ID: <ZQhr/TN/taOKqYIm@fedora64.linuxtx.org>
References: <20230917191051.639202302@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>

On Sun, Sep 17, 2023 at 09:10:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.4 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.4-rc1.gz
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
