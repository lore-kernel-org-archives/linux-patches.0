Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1238F59E42
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 16:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fXX8nzl4"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-58e22b2baadso1497269eaf.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 08:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701794748; x=1702399548; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CG6BJUWe8kC1FHX30s9/aNRkViYtrDmsP1HwdN1t68E=;
        b=fXX8nzl4SfsEaGnRptexl+bN5yN0YtCkNQ5N7v2OPHMxAuWgJFhPqnyh2f9miReLlN
         P8hbgAFrUS9wHOJU/tPopg2+JfExvecnOuX8owIdl0pKRbWnne5xmFN4A/Vlf6Pl5S4Y
         gVG7mkLb/Z3a38r5Y8zvzplWnirvj74iKkrCj2cfH9vWfZ2gWkoMPNcT86Cmd3tzo09S
         8RJAvD6sBfkJ2a2WfCBI/FOCofXd1Yszfs+Di4U60crtCbxHU7SlmTEdqifzbAcB/6ul
         Xi7F/khWvsSvQOmcDt3M12acxutO1RraPwrjMvlis8uzCnAFK1SQmUz1/PqhEIq3jgvg
         9zxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701794748; x=1702399548;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CG6BJUWe8kC1FHX30s9/aNRkViYtrDmsP1HwdN1t68E=;
        b=VsENvxeAvNL2YxtG5n2TgX9DnKT71haguUS6Yu3pAaEyH8dyQI+he4Md4+6h8h9jhW
         wSVG+GsTXpETOiuxYDNVAAXkmPhku/2IzsdE8w5ymCD6wcmmhXIAaCgT3i+5/rMw8IKw
         +Y3qkoaV4ICyztjTAfXUvmwHlF/9VeGGXi1ViEBEM9MVXS66qJOgiOl5pip6ilz1CUDF
         mpNAqci8DEgkna/qmpJ0TJUFm7+cd92cOcXYEoTRIyhUUumhWgBcGpHWCdRZtsEVp48V
         5syv2uo73T0qLpNZU9TqXdAeMCvCXIzsem4qiAA0L1aSYWQ3VWGx5hI8ZDc1Nm+zl9HL
         03Fw==
X-Gm-Message-State: AOJu0YxQPrut2bKHaXvMwlUqWPkUBHWn6rNCgQ8EW2OPHXtd9nT2eCSz
	4pm5j8T8zpVjW+UZNC2OyeA=
X-Google-Smtp-Source: AGHT+IHkZOxOZeK4LMXia/JEeUnAt9yE31khEXWi3y/sW8j3h2RRoWkcat/YYyZSpTercanDVIueLw==
X-Received: by 2002:a05:6870:1707:b0:1fb:75a:677c with SMTP id h7-20020a056870170700b001fb075a677cmr830776oae.35.1701794747950;
        Tue, 05 Dec 2023 08:45:47 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id qx2-20020a056871600200b001fac77ee907sm3051603oab.33.2023.12.05.08.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 08:45:47 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 5 Dec 2023 08:45:46 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.4 00/93] 5.4.263-rc2 review
Message-ID: <830134bd-9bdd-418e-8791-2890f1677f0f@roeck-us.net>
References: <20231205043618.860613563@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205043618.860613563@linuxfoundation.org>

On Tue, Dec 05, 2023 at 01:37:00PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.263 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 04:35:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
