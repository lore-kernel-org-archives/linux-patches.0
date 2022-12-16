Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4D2321E
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 21:30:39 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id m7-20020a9d6447000000b0066da0504b5eso2117186otl.13
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 13:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=faGp3q5VvI8mnMapKFqjzxGSUJuGRKvhZk/bzvMwrec=;
        b=EG9MMukXtUfOFru3q0tQ7i2lPRQQd8YlI51YZCpfBI7Kpn+m1vJoe7GwMvs/WLSvTn
         CxQVQAkd2w3j+2OkF5UEekmxAPGflMtuu3XPorCs9L0aPE6+tqoEesTFcAqtt4QHOGvT
         g8gS47X7tDnFmSO6LQ2DDrA8C3pGRCZRr1WiCFwMh/Pi2nsYRdgEBp2MT9ENc7ZFu4+q
         NT/MIoTNJOsL/DSugQXVj6w0+6huCzgDtjnHmM62Sr5U2IVlY6dcThGlJT4X5oel/gbW
         lIrd4QUGKxLNFzIPQ1fr9UTvTi0HWwSMlv39cnLTz2sxFJKEbPNRGi4A78S8xiNNEBG9
         oJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=faGp3q5VvI8mnMapKFqjzxGSUJuGRKvhZk/bzvMwrec=;
        b=wW9gCP8NvY1zj4x6Ba91I6zTh1k+Oe50eEpD3lTVlKRmnHwbbazw2STaiCIK2kLqNm
         9wjcVrRv/bU9QlOe9UEBruaQclFr7PJs2q+n4Ean+JAGfwlNo/NhvNYpHs2+wMGZ/rVh
         XPCf9OAY7VnYiv0dybBFGFnlmQ8Qbrx//C/jFKddUDF/G4vpskt8oucB+g79+n0HhRnW
         bif+FHVnFCsa/3HK8DSrNEQSXSSqeDLVmSjV+VcgIavxeo1OH2HGEICju35D/vNoMuLJ
         U586DwPOvcnWvI6HAkkm9zYCLrDBMUNUf83W1Qw4NAtIVxNG8ySECiiDi4nmMHIM+2Rr
         LXuA==
X-Gm-Message-State: ANoB5plPA3aUZ5oYlQbm+eIOXQHALraTVh2MWP6e2b5pG2ljhfgTVFaN
	R0R0Mt85u1yaPrdWP7Dx4Sg=
X-Google-Smtp-Source: AA0mqf5HX9yHM1K70mNKMezVLvpwm3DRYe7ckKN4YczJWg3BA3Sr+ZAPbep0hgWbB5oDc6XFP/H8GQ==
X-Received: by 2002:a05:6830:d05:b0:66d:da2c:c7bb with SMTP id bu5-20020a0568300d0500b0066dda2cc7bbmr19924588otb.18.1671226238099;
        Fri, 16 Dec 2022 13:30:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c11-20020aca1c0b000000b00353fe4fb4casm1214406oic.48.2022.12.16.13.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 13:30:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 16 Dec 2022 13:30:36 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/15] 5.10.160-rc1 review
Message-ID: <20221216213036.GB4067594@roeck-us.net>
References: <20221215172906.638553794@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>

On Thu, Dec 15, 2022 at 07:10:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.160 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
