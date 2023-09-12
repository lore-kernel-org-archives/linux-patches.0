Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DFB18AF2
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 12:27:18 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3aa139a0ab2so3913807b6e.2
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 05:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1694521637; x=1695126437; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6jl06CrRvDgpTNRZmZef/yKV5B26LF5da0hksP8EsMo=;
        b=LU7KgaoMzwZfsMNSY9Snu3+9FCoxj8O7hMtX0vJxMDj9/45zrYCmaiVTusHF/uJWDF
         p8FWdXxvI5WnadinnHeW3We14RZo7Mq3Bzmql4NXPcLryQsF5+9qtp7aqWCz5xph7TJ4
         LsiAc1vRWszBiQc/+pvK6oxOfAc8CMC6vgUdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694521637; x=1695126437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6jl06CrRvDgpTNRZmZef/yKV5B26LF5da0hksP8EsMo=;
        b=e/iYPDV5HbwZ6HNUSctmTL1hYb1L7UGCmC44roQLbk2XDFdkSEiyEIc64c1gocI4qe
         n55Qixnbnh4SQGD7btdM2PUnR93YWch+DBfibkdCPNbeorHW9iS8xYB1+8XkleY7MkC4
         T7CJDaPtUlY0hze5Qq8oMUmzsQ8fk0QELDw176KznaZ60efi/4PSHpRmwy2jd0rl0R7F
         80yzT9zOR5dcP+7d4IQynUXKVhJXx3NF4Uzu94XC/fppxeMCPUUw3lswTJiFO59TndPn
         X22xTVkn7EUswoXMZdLywN9nBcKlDUmVSptLSwbYic4XeND7v9CKQ0TdEWHx+Nu96pKK
         esxw==
X-Gm-Message-State: AOJu0YwyPZ8sbXWGpPUB0gpxu9QIfp7exGcYRH8TAcNl7FfxhH1AcWb+
	You+j3bSn7w3IH67PrDkYmN8S/vbIHF/U6mCjRaiGaFgUhG0ug==
X-Google-Smtp-Source: AGHT+IGDfW7lad7Tfz375iAUI2X0OYcP2OBbBnUmiyA1DuosLZBDGCoT7qlc6cqTUVMHaEmrf1dhTA==
X-Received: by 2002:a05:6808:1141:b0:3a4:3072:e597 with SMTP id u1-20020a056808114100b003a43072e597mr16456320oiu.54.1694521637430;
        Tue, 12 Sep 2023 05:27:17 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id h17-20020a056808015100b003a7847cf407sm4116228oie.44.2023.09.12.05.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 05:27:16 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 12 Sep 2023 07:27:15 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.5 000/739] 6.5.3-rc1 review
Message-ID: <ZQBZI3Byx504+Ys3@fedora64.linuxtx.org>
References: <20230911134650.921299741@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>

On Mon, Sep 11, 2023 at 03:36:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.3 release.
> There are 739 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.3-rc1.gz
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
