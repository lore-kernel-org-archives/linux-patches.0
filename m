Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19D64C64
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 14:58:44 +0000 (UTC)
Received: by mail-wr1-f51.google.com with SMTP id j2so4567664wrh.9
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 06:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YBrJ85EH3k3XzAz9yUFw3O2II5N0HmyEMyiwRdmuUgU=;
        b=glIEg98cWtsH2PMsrQRNTcoRdByaCs4DalccUliPk4r5k7JSb7TZzcbIg7iDzv0rlx
         vIF4F0dpg0BMHGkWf4/JeMVZpFMMKWbk15ih/uJMtbTiEbqplvoDxnY4YCnndSQRR1ln
         I0a88w06aOGy5zIMf70iz+9EPVUTIk8T4TjXHRPeN+A21mFP4u96bqPwv0r16iz6p4gs
         DjYS9KorqK5BMHTm/7jxmLr+nDctjWhQcGCYJPNXlALt44sDuSgbuUncHeduFPNyAadF
         LEgVJq5aLxPW7sKQLaGESAE9CxUUXi99q6Dz/2vZ+HObCSPBlF9mD1h+ztfknbsS7TOh
         HLwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YBrJ85EH3k3XzAz9yUFw3O2II5N0HmyEMyiwRdmuUgU=;
        b=QPMOgTSwnKtVoWhx2GAPn5htpFf1qWzRFYWHJmR8xYLpgY7FbByXOPLSFVpADZQpie
         9mGP0ALB+97jumh/4cD+idFQf63jAJ3jMRIH8uDiwXWA+yyS2krgC4llDTPZFiwgdQaJ
         EllLWWkChj/wrRs7LlhlTz9M062GFQQ00xR72Hj7PEKrdpn6NBvExXq52c5fvKRcK/Me
         eFOFFpTbBMV5jrgpyVsPn/OlFfLcAOBbLRXC/Iiv9QdbvsuuLk9bejgHC+CbgFfziqZn
         AFmy3kTXE8bhMulrw3SoT5PnF0U8C2HBfoUtN3OFXU/GCIYRbrpRUlf0ldO+hjj50k7a
         VshQ==
X-Gm-Message-State: AO0yUKWqarUsV+J8rh8yFLUZ/ow7wRJI5KiCSJGMcFsrl3ohb4fgx6AX
	tY86WQOlU6yw7Jtjj2h0/sY=
X-Google-Smtp-Source: AK7set88cVUNoCClRxFe4yiYbdu+Ls3NWX3/ieTlylw6onWyXRKY/7Eem8cU6MoHjdfl5FYd6ptTFA==
X-Received: by 2002:a05:6000:1866:b0:2c5:5e34:6171 with SMTP id d6-20020a056000186600b002c55e346171mr4039332wri.25.1676991522956;
        Tue, 21 Feb 2023 06:58:42 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id a16-20020adffb90000000b002c54c92e125sm3790020wrr.46.2023.02.21.06.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 06:58:42 -0800 (PST)
Date: Tue, 21 Feb 2023 14:58:41 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/57] 5.10.169-rc1 review
Message-ID: <Y/TcITyntQBW0q5d@debian>
References: <20230220133549.360169435@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>

Hi Greg,

On Mon, Feb 20, 2023 at 02:36:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.169 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2906
[2]. https://openqa.qa.codethink.co.uk/tests/2909


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
