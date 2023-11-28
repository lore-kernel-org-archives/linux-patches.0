Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875C61C3F
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 02:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jJnOwBjS"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-1f03d9ad89fso2896711fac.1
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 18:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701139998; x=1701744798; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F2ex07nmMjEWp2BjNQtRG363aSbn2cAhcrhyQytjQ5s=;
        b=jJnOwBjSjQEjc/vjYFkztvH1jFfq0hmf7W8PCE8gTduv3fAWTxlb4dpXzleQ1VeJrq
         EPfs3KyO1D0o090WjmwhTx5iZCIzg88tNMejRLjO1vYOu74obiwDq8jBJ0Jk/K0GgH7g
         LK2osTL2Y74Z9xenhc8a2ToHDf5YuTMVBnTl0T2MSOzimQUmsYQU+j1kD17hZhehtTec
         fPoQqOgnMwRib7+rlSJ2itmZwTjUihBCibUvtMr/mpsuESp0YUPCybFKfon/MBFM6t1+
         4/MJaZ03M+4xnct9xZ1nQ+sQLz8XfVd+7znl7PDV16pthWkIRYUP0Tpn1CA+XqfJ7bMB
         kDjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701139998; x=1701744798;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F2ex07nmMjEWp2BjNQtRG363aSbn2cAhcrhyQytjQ5s=;
        b=giBHKmVJZ7CgaArXLzhaxCwgMyipeN0roAd92orcpdBH1YbRGz0n1hxEFMc7YdeHWj
         qrGLg5ai2EmryzrzIlaU0VCqH4BiTuR6WrbOtL7M2P3g85SS7tbdggBKRQcTCgwdhbDz
         CFrKMoF3/yl5s1HqFLLX3rsUN0vNn4HC9nXCmiOCPNYhQt7gxOMZLv+w20bYeIOrmnco
         XLzFDW8rPg1Phcs88x0xvW3iSXuMdNVMaZwN5kN9uZzPqgTPTumyL9OoT7l6BJhNVlIm
         EE7BToMQm4mMN+nWEwC9k5BK7Th2wlIjSno+Ij5B0YVFASVfeT/kQWmX0QWyPrhpU1Fv
         p1Qw==
X-Gm-Message-State: AOJu0YzJrg4L9DCFo+TlZOWkgLZ3QjEaA/Jey+QXYH+LWWQksRoSXAKK
	7lhFSRFiO2n3W4t3bBKg8ug=
X-Google-Smtp-Source: AGHT+IFUHJO9Gq4zHuXz6o3de4wZBdfUK2vNxGSjqTwOLYyg6bhTxlqSjFrho3mTVlrq9LaH1mmTGQ==
X-Received: by 2002:a05:6870:5587:b0:1fa:3699:3bbc with SMTP id qj7-20020a056870558700b001fa36993bbcmr10100189oac.41.1701139998266;
        Mon, 27 Nov 2023 18:53:18 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id py22-20020a056871e41600b001fa39dfef88sm1198357oac.37.2023.11.27.18.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 18:53:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 27 Nov 2023 18:53:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/292] 5.15.140-rc3 review
Message-ID: <0b9a7fdc-907e-4233-90be-ef36e8b2c3d6@roeck-us.net>
References: <20231126154348.824037389@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126154348.824037389@linuxfoundation.org>

On Sun, Nov 26, 2023 at 03:46:45PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.140 release.  There
> are 292 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.  Anything
> received after that time might be too late.
> 

For v5.15.139-292-g659e62181100:

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 509 pass: 509 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
