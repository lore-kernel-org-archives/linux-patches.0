Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1074010EB
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 01:44:50 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id c129so4033311oia.0
        for <patches@lists.linux.dev>; Thu, 01 Dec 2022 17:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hvv9FXRsemW4l4PI8H5cpdCXf8vmtqJ7GI82fIK6u4o=;
        b=PKiIUIpGAFOfhhBaT8KJAuT9pkwk93cvcGzaJtFpLZUJF70Zv2fJDVc9qwuc6qr1OI
         WjRNy/ZmJtDIXrWNJSdpPGGcubnY2qSxNIkoPqQu0QSQ9QI6+NxtotZ2lj4lwsYytWxA
         RbzSVODbUVVNDMNefGRPppaWp6m2CcvVDg/usXYTWngWX1H+wy3WwbaAeSHH+gUMe3X5
         AibEVd3pXFnpOpRF/ZInKk3lj3SVKgiakgGR49RHxLQYUisjdie0pV2xp5KuHtzcrAbm
         Kj5rjiXJRJywaBiR6wvioNJ7ugWen3LZGmTKRuDWT8KOaTjednTOhEDAhhRZr6PXy4TQ
         EP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hvv9FXRsemW4l4PI8H5cpdCXf8vmtqJ7GI82fIK6u4o=;
        b=SHxTVrnfCqUTC99/+arzzSPxvBpb4Yf/9mcYEijhW7gk05KCe6bOef+hHAEedZG+1+
         4F+RX3FKNvqGrzqokuto2IVZA4Ztrl8S7mYsXifaOMJVjquqB1hmTtL3loNFbUSq6qrw
         YGjYs1S3rA82cWuGrurOz00xf8O8V3dmTBoBLE3YBXKKADmipNorrhDG6NGmVdpUxhTk
         C4Iybwvy1+fawy4JES2qiFkkEJuNfhLneeC4edJuDIRPzXkvkYjF27ZBkHapn/zQAq34
         kp4AHJS/8pt41/CsZv75YkIpy7jCDUCGumX3j5eYMSMFPK7JdIH1mH1y8LH4jimfWLw3
         zCsw==
X-Gm-Message-State: ANoB5pmzRF9BKGUUVJZ0L2OvBX4luRg+xZaFiSU9Uodc9urPnitfZUyz
	35MiUGqTCwFXViLI5+1UIkI=
X-Google-Smtp-Source: AA0mqf4H7tZ+qhYY4A8AFKeW70Jbj/ilQpfMxewTYF7ODE2Dx5NyfcWB3E0hJ8I4FtZ8AHyRrhdlYQ==
X-Received: by 2002:a05:6808:138a:b0:35b:29de:da29 with SMTP id c10-20020a056808138a00b0035b29deda29mr24974660oiw.55.1669945489271;
        Thu, 01 Dec 2022 17:44:49 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o6-20020acad706000000b003549db40f38sm2441136oig.46.2022.12.01.17.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 17:44:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 1 Dec 2022 17:44:48 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/162] 5.10.157-rc1 review
Message-ID: <20221202014448.GC2255418@roeck-us.net>
References: <20221130180528.466039523@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>

On Wed, Nov 30, 2022 at 07:21:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.157 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
