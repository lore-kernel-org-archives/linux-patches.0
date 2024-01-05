Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1891860
	for <patches@lists.linux.dev>; Fri,  5 Jan 2024 01:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aLP38esg"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5ce9555d42eso811078a12.2
        for <patches@lists.linux.dev>; Thu, 04 Jan 2024 17:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704416663; x=1705021463; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cSpoTLEcYmpyrX/0zTXHzhfPiHX5R9Z55hnkfOsGChU=;
        b=aLP38esg7Cpglz5RgSCR9iRBSI7/6mAt5n8/sPsaUdDAJm5QIRqqPqF6H59cSKBL8X
         JVtXbY/AOfLsMZtzcAr3wnr/Ob+aCZJUMfvNgWbtd33J97hwIh8qBcOFwJUvHj730b6g
         12oPDQnK2v5h2wZKcPN/+L+6QVnZ6vgCS7lkQb6WgntZ3rHTKMfM1BZOPE0T5aR/3Bnk
         DeNf+Tp6LR0H1LDhddbfPNsdhpcFq22Xeu/R+CRel9p7zD9TvB6Zw3muNJWtCuWSR6NT
         ntikPFxoYUBSxsXxfWKfneS+lhlD+/23QoH3tuttIggCRI+HiqTGlSFqX/QQbjp+EgTw
         JcmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704416663; x=1705021463;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cSpoTLEcYmpyrX/0zTXHzhfPiHX5R9Z55hnkfOsGChU=;
        b=aeDSisrHBozZjVbrG4ZGaafHHxFTPUGKY0ghOdyY3IAeRkXymKFXyenhp5rFNcuDyj
         UoigB3yoAnNEf2BtcEiFsAvTzwkqC/dtieXtzu3VoNj2uv7jUQMYImj3CWxqUbtiIR/W
         0O0hhh8+NOO3rW1Y2FreKw1mRXtW1f9wbR9cFhKLHazBxVsJE6NfwT5hvG2wNfrlSpoH
         OnwITX9sZ3GphUpSaJT6SskRqHGq8Cf294vfZKNx52dlRPXbPtDS3lyedTNuz5G2l5Zb
         33/zEwh0hOdAj/cUorQCT5lvzmDDurYyucS6RchiqOcYLDu6sPgoI0XRF0yIUMV7fsvs
         1chA==
X-Gm-Message-State: AOJu0YzmbWTvLEnHyJoJSXOEyiV7OfLeLltAydKTin6UE6Fy1MflFbob
	UypQqI+w2rULbPsVYXyKIjc=
X-Google-Smtp-Source: AGHT+IEjoco8dNn6aF8qBueTRAQIlsxisBb1d/K20aYhgpVZYzmWsUww6P2XFJbrOiojGC5vOxT2fA==
X-Received: by 2002:a05:6a20:ba98:b0:196:373a:554c with SMTP id fb24-20020a056a20ba9800b00196373a554cmr1266804pzb.82.1704416663305;
        Thu, 04 Jan 2024 17:04:23 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p27-20020a056a0026db00b006d9ad29b108sm258078pfw.202.2024.01.04.17.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jan 2024 17:04:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 4 Jan 2024 17:04:22 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 00/49] 6.6.10-rc1 review
Message-ID: <57c3c7b3-97e3-4288-abf4-b875cc04cb03@roeck-us.net>
References: <20240103164834.970234661@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>

On Wed, Jan 03, 2024 at 05:55:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.10 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 545 pass: 545 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
