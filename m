Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D8ADDA7
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 17:09:32 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6bdcbde9676so2245863a34.3
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 10:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1693933772; x=1694538572; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7h1pOWAWn2f3/0pIwmJa14UCgmY4tfc3A2xWVFCKn/A=;
        b=HRrCIoq1Yj0HhyBHeeequXw894pZnH6kWIyXJDeWJY69i23voLyFHQszI3FFRowHki
         btlHfho5+wySALQtISD4Fu9+itWALrvY9QJewsMK8cSPkTIUMYJjVKXXXvLoLYBxsqA3
         AefUanN62NsCKs3dXsE6ZDIyzuzZBnDt71DsE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693933772; x=1694538572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7h1pOWAWn2f3/0pIwmJa14UCgmY4tfc3A2xWVFCKn/A=;
        b=bl0uVaWhwM/KYb+KXJyAK5GWY5IZBTEpbwbYctxFhJAYaEYZYiXkaB2TwjrowNpsok
         ZBtiYx1w4MJ/5INvrnCKyZO06nVK6q6cjRpmYVMa+TFCI9QRHCxkpZ8SKEAKSwONQMZC
         fZsbSALJOYCrD27omehA38WyBdLyM7PhwT8v/jYGsNaxaEQbEy93uq3WPZIC3MU+FAmg
         wPJ5SCEY0ZNOk5kJCuC3CjiaXQp4tErcDTUVkUUrxbGOWnX4+aHnV9vvyrPcSM2/Nh8L
         mdeP1rdYP5/8fu6Ry6IkwH8ZA0fgNcgIJQ+fST0Ge2Nh6b9HDfmF74LZpQj1XtRbrpi6
         sHXA==
X-Gm-Message-State: AOJu0Yy3/jfMHpYZtLe8GEXocgBiusC0JnZ2munYCKhNO7BDnvCivqhM
	SgTz44zEeektgnhu2QJXgWduoQ==
X-Google-Smtp-Source: AGHT+IHyoieeDB0PNwVvLRlAczgv2xHwUxOdj1W5kcWlyPok77Aa/jXmKT28xB8W4J/4Y/qekumOfQ==
X-Received: by 2002:a9d:4b05:0:b0:6b2:9bdb:a84a with SMTP id q5-20020a9d4b05000000b006b29bdba84amr15026049otf.32.1693933771878;
        Tue, 05 Sep 2023 10:09:31 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id t25-20020a9d66d9000000b006b89596bc61sm5666307otm.61.2023.09.05.10.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 10:09:31 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 5 Sep 2023 12:09:29 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.4 00/32] 6.4.15-rc1 review
Message-ID: <ZPdgyWKSJkXf7Q/z@fedora64.linuxtx.org>
References: <20230904182947.899158313@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904182947.899158313@linuxfoundation.org>

On Mon, Sep 04, 2023 at 07:29:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.15 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.15-rc1.gz
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
