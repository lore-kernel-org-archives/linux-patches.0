Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F2715491
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 10:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPNH1g2N"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40859c46447so29958815e9.1
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 03:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698231118; x=1698835918; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cv65HA03cvoAKx8a2KmloKz5yACTW5awrrDOvOUGaOc=;
        b=WPNH1g2NuJ46K57h2ZWH/xnGC1n2KucF+iHOv81s6VNJ5s5LQrwfOUli08/oyLFTx1
         s2cVLjd/txdY1atSVMBFfkgNc24ZhzfzQN80xDBkUyzJmnHONJmXbbKl7ktl4s6RXTdv
         K8lAz37I0Una6C0W6pYLJ1VQOmWFuW+wl4n+6aGvvB7ms40XZY/e2NoDadrgMjzqg8vm
         18lYEWuny8LX9zZFU948ZytCLaxMvnR2LLJ7sa32Ong9tdTRFXZsTZ9KUPn5LwPB+jvb
         Cy9lV4DweJtPbF0JYkYGIeZ8QRkQONMlvx4RH6W9VkQBEDXwebakR1JCo7CEyPgJHSEj
         mR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698231118; x=1698835918;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cv65HA03cvoAKx8a2KmloKz5yACTW5awrrDOvOUGaOc=;
        b=UuxoSxp945EaXFkGLFo1IrYmXrePVxZzcDxARygudagBAqyPMAJtElaXkSw0wxKwcH
         J1XHMHZTtXeW2xEcsgFV+A6tEC8l/6oiS5liUEiqsgblQLxnKKWBrjdxfUA3gRtFm5WY
         nKZqJ/q8yAFY3PcUiKyN7IMO4SWHatE+JEMZlAwIgNXSM+H3Alpzg5j8j32gQsgiunTf
         DKZi2TiFf8XLn21scG7kZeyIxiXgPeDJgi4KcR0+PpTsWwmpp6EEqrLr0Clxp2TiYUF6
         w1MCRno8vTnCw02Ts/HpSaqNe2XSgn9C43W9yfzY/7jhSNPVXuaZOJKNDQYkppQLi+Mc
         JcYQ==
X-Gm-Message-State: AOJu0YxqzOT6kd07wUIJf7+ux+WIKTnNF3QIzK6VJ8f75Jch7Ci38UKk
	j8HUKeisZzFPvt6lsM8RQ+0=
X-Google-Smtp-Source: AGHT+IE9tisrZljoEq5Fuh1o5TH+dXqa0jPky6iprufzEjvQSQltz33lDSlYc2FHgH12nLqZ2wpqMQ==
X-Received: by 2002:a05:600c:1f90:b0:405:92f9:b090 with SMTP id je16-20020a05600c1f9000b0040592f9b090mr11656642wmb.14.1698231117943;
        Wed, 25 Oct 2023 03:51:57 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c231100b00401d8181f8bsm18898939wmo.25.2023.10.25.03.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 03:51:57 -0700 (PDT)
Date: Wed, 25 Oct 2023 11:51:56 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 000/199] 5.10.199-rc2 review
Message-ID: <ZTjzTHTo6ZaP_KmH@debian>
References: <20231024083326.219645073@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024083326.219645073@linuxfoundation.org>

Hi Greg,

On Tue, Oct 24, 2023 at 10:36:35AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.199 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Oct 2023 08:32:45 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230511):
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

[1]. https://openqa.qa.codethink.co.uk/tests/5376
[2]. https://openqa.qa.codethink.co.uk/tests/5377


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
