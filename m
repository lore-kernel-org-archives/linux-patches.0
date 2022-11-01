Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4570D7C
	for <patches@lists.linux.dev>; Tue,  1 Nov 2022 12:51:23 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-13bef14ea06so16678218fac.3
        for <patches@lists.linux.dev>; Tue, 01 Nov 2022 05:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zd8ew0Fcdtt+vn+WPQkyqr+cTA4/IsSUe1qVBtpnWNs=;
        b=JHsIdYCmoCKt/QIf+2xLn+VWR97YHma4Q6woPQpTOHVKnzSBq8fkOjBkQfmjJBtVkv
         8PIEvdObggiLjsfcAUfHlM1wrm8G7J/LZD12b4DXGnslFEUDNndQXjPhZqPoFPZgYTUn
         5degH08BD/HwLMMYsNlJA0uRF8sWOMI1z7eI+M2nrofZ6IYF5DU7rn4ZBPdOmXoazqGz
         Z4U+26mwqu4bqVFKRsSixpkXNky9cFQ/fBmztzCj6KvXOWwURtB0l0CvZSkXcn3959sE
         FlOaUhFtHFm5xjNsvWzATT9+F0wn4Xs1m3e1NPFjcN7QrwLlHMkhLf6fmyYanvUXx5G4
         8d4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zd8ew0Fcdtt+vn+WPQkyqr+cTA4/IsSUe1qVBtpnWNs=;
        b=5sSJYaPdd1O6c8L06pMvA2xb5KTuN/hqCpJPewFTB9RpLK6/gE1EbCHlruYfH1+YkD
         29eQDiW5toyRZUQpsgzAXV5h2ejkRh2kLmaZGO1lQOnfMr7eljXKlteEwPa7mbxsqYD5
         0hKTdUbETZd/jAGNhmmLxVJmU8W9+RhSp8bQbAW92vdLxpVKk8gsD3yAU8VxOaYowm6p
         psFp43tn/niPTsvq0MkOuZJOFUwSLLXHMxVNuyqDMwlJN/NrKllNr5VXh3dPDIKq3ZTs
         0AkCSPecrQrUBKVDjLruOihUz6uFB96tfh2WUW3XowKXIkePBrb3390YK/Wl5oqaPuCO
         x7NQ==
X-Gm-Message-State: ACrzQf1Dz1ZDr9ZApIAOX4f0CISC4GETXUOBv8RUmV02M6rCfZj6/C8r
	dxyYExMFTcLZSHl1pmtueiw=
X-Google-Smtp-Source: AMsMyM7h6iyk9rwLta5eEEXTz4x0HYN4lg7IfIg6vG8jwGcPHAov4FPbiA23wf0jno+Q4MVSs0QT3A==
X-Received: by 2002:a05:6871:207:b0:13b:92ee:89da with SMTP id t7-20020a056871020700b0013b92ee89damr10529640oad.233.1667307082366;
        Tue, 01 Nov 2022 05:51:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r24-20020a056870179800b00132f141ef2dsm4368963oae.56.2022.11.01.05.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 05:51:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 1 Nov 2022 05:51:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 4.14 00/34] 4.14.297-rc1 review
Message-ID: <20221101125119.GA1310060@roeck-us.net>
References: <20221031070140.108124105@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>

On Mon, Oct 31, 2022 at 08:02:33AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.297 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Nov 2022 07:01:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
