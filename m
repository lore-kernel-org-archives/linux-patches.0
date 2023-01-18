Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B142CAB
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 12:17:01 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so1277749wma.1
        for <patches@lists.linux.dev>; Wed, 18 Jan 2023 04:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nkpzOUujUL/bH5pG79UVQRHaTTKQoLKlTvXHncVMSXU=;
        b=UsajSL/h4KOodrBAOWeq4h2gvPN/ifdI+pGmybkA31mnmB1LIPMUN48Hf3S92UcrAh
         b+Bz+U/ZcdRNtvjpwhNLQL7H953xZlpzL3o6Co0ID6gDAk8LE8/Qni5Q5GZ+KCAPdTa2
         BbWcWxkKaZyCwt4lnj6ABUkrG2/mJiH8jHtyJWCFxk6AzmCf0JOfse0xO0M4+mU/WxXx
         FImhtCum1QGCzm5NMEQMy5XmpbKxAsfzpMqdZO2pTHyo0PACSvk6ZNDIG+mdk3B6ZORg
         sCZABmjsIxdE3P3JvJ1ex3oAemq8ca94mr+1/B2ASGZkMtJa6+QKE9t/tPAiZIL/5Etc
         uRcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nkpzOUujUL/bH5pG79UVQRHaTTKQoLKlTvXHncVMSXU=;
        b=zljmJCMXtrn1CTxmOaVBdDg9tCTt7XKokhCKujLgAYWn/XXkP9YbJqrsQnj26huQCs
         zIm4RaQ8irtNjCw7ynlwsQdamhtnvjRez2YdURg2+d1NnAd14rVzdbBU363rPjYrt6os
         SCLWFfZ/PovMjeMO4eX85R5LeXAijuaEHaGBNnJ/bG7Dzz74BtJ/igQOuS8NGGEqVRtJ
         ySabu6wOXhd9p4Alk7NNudatISb/tMQ91BJiu0SQ5VlTnQMmHdEIVwYt9sBzSA3vdwpd
         f3yejlOWIq62T1a005brgQOIC2flqTV6PCtMRur0x5HE0Wcd1KMgwEa9li8wwNdkLxlz
         bkqw==
X-Gm-Message-State: AFqh2kogGeHU273atlghgbulgej9YnztUX+LLsZhQ/obNS+wcnSL52F6
	JovSg0uNHXPOcFA5rbcNld0=
X-Google-Smtp-Source: AMrXdXt98Cg68MzymuRIgwrgiV16gUS9AyNfHMl3DQSLJx2Z5tzO+T398OXxWwRWRRohm5fJpmHhCg==
X-Received: by 2002:a05:600c:3b18:b0:3db:eab:3c5c with SMTP id m24-20020a05600c3b1800b003db0eab3c5cmr3527109wms.32.1674044220067;
        Wed, 18 Jan 2023 04:17:00 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id o2-20020a05600c510200b003c6f8d30e40sm1957845wms.31.2023.01.18.04.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 04:16:59 -0800 (PST)
Date: Wed, 18 Jan 2023 12:16:57 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc2 review
Message-ID: <Y8fjOblGA1JjOF+E@debian>
References: <20230117124526.766388541@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124526.766388541@linuxfoundation.org>

Hi Greg,

On Tue, Jan 17, 2023 at 01:48:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230113):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2675
[2]. https://openqa.qa.codethink.co.uk/tests/2682


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
