Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010FBA480
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 22:18:58 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-13bd2aea61bso17871471fac.0
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 14:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vKUbdUX3qdflcVWi2z65DPQbJco33U25TAhGa9To338=;
        b=g+QrmWAS9mrAm2NJ3L595Koub6YGAgrJAnsHt+xCQMOyNMtdIBXi9yTt2E1+j4C01I
         9uCI0pHSqpWRtYt4aPdJJ2V5d7Jo5CGpI2TKVGKwv/xv6F34JhFQssWW0PZ2FYfmVrQF
         IFw3Uv3pfiXMbRPIu4xccSn3BXcxvV7WOdm+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vKUbdUX3qdflcVWi2z65DPQbJco33U25TAhGa9To338=;
        b=8FgjfY5cREEUr/QfuFHQV96WtnQsDeBmk1PMqh4WiePfA6aZZ6X0rQi7aHCJxBajr0
         GwJZ18Ov5LYRGoW8bA99njGFBh97HLJAzK6fPJPTiqsg5wDjofrqk0EhrXAo9evIFMf8
         NXRXuvoRfXzHoKI0czwoc+OdSfUgLVe3hrbbK4IU3zlyDs+GVlGsIDU323DjZlB+a3ev
         it1KNf8y0ifQ+/fwJxtbibJB/BEoWdEMyzadWONHkCaICuLXIDcBsgEOPYTfSNsf8Ie3
         DGWXBw4akM51hPSeEPNodtIB0/BDzYMTPbeZ9utTevF/mlKwj3lhKTmfUu9feKLcUctU
         hXXw==
X-Gm-Message-State: ACrzQf1Yoq7+mbQOOzKQ3bghIiyZPyKdq4UCnvRYrhbqhaf6SAWIRNtw
	Yg7m2XVCAByatQnqS7CKqkObuQ==
X-Google-Smtp-Source: AMsMyM6Vc4kPAkvYK6wM2lKQRgXSGyuamtYWKlliPsldhkcjQKMlqRS3k0u3UAUG6cLq1cBzcSfWmw==
X-Received: by 2002:a05:6870:96a7:b0:13b:ceea:baf8 with SMTP id o39-20020a05687096a700b0013bceeabaf8mr44646620oaq.88.1667945937746;
        Tue, 08 Nov 2022 14:18:57 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id d132-20020aca368a000000b00359ba124b07sm3931285oia.36.2022.11.08.14.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 14:18:56 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 8 Nov 2022 16:18:54 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
Message-ID: <Y2rVztl+lEUftkAF@fedora64.linuxtx.org>
References: <20221108133354.787209461@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>

On Tue, Nov 08, 2022 at 02:37:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
