Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DB5CA57
	for <patches@lists.linux.dev>; Fri, 17 Nov 2023 04:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K4CZMPuc"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-58a42c3cbb8so774738eaf.3
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 20:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700195064; x=1700799864; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AFveOmJik6YY9ZRLOk+sCI/MXeTb5qg3AWh1DG6limk=;
        b=K4CZMPuctQQKwrAflKC14Aa4fjlJiaqJgJHFLN1ZXVn988YcMGOxfIcTeJOZmdnW8e
         /DonKF8aX2eq4QgAXTlYnIIaPfmEErdofDxVTFpDOANnsxoaIcLfhq6P32Ho7C2xx0cz
         ASwDhXunXMjJB06nn4pBeRjsknTZFfYBIbgcJXvTjuWdbA88Xkg9cMIGmNP/G3CuGhfA
         tHahtrvpKgPJfMtbZwaPytaSP8w2iVLPbZF0bv2DyS7qF7Xt3XkaUz5HDTcXdqc8/4pl
         BDGjoKlAdoTN4ozCs2VcoHEszbIXW4sSdF6EWN8BeATWGFs7wJLTXR4XLtjmDw4YUVkT
         72Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700195064; x=1700799864;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AFveOmJik6YY9ZRLOk+sCI/MXeTb5qg3AWh1DG6limk=;
        b=sE9AsCWUb5KIRImEiNwuywWia+ACP5CwOONvzC0p2HUMrPP5RGrXWG3Pw+cts0IVCY
         f14j900lOKP6D4yr/dkf76fcEiNuGT85SX/0ecbes+QGTKa7S7BgzEhdIhvn6j/2+blE
         dVhTiQjVZYVu1KLMQi1Eb+5C7eWGvl5Sj2SNvSuQzj3soiK+bgH7fYdE6JCn+M9VXY6L
         TZZMsbzhT30AVpqbcoiFBfwTAFhiDIQeSJpFIiHsk915/oEGckXEs+C/wtR9APH4lITm
         0LUxr7F0l+mDpxDToIXesJ01+hpMrzzIXCQU76DuhyVNfk7jL/7wQWhTGYtOVuSSTztH
         0Lng==
X-Gm-Message-State: AOJu0YxGNfsfoR7b3nZP2T7pwkdiFVqKtr4qpTmVI6HBBTv49b/EASeZ
	Ce2jT4+iWpnuN4xZU1V+AMA=
X-Google-Smtp-Source: AGHT+IHuVn9VaCdTI1zb9XGaQfyybHaDC7kpyPSoItyKNID0FO3pFfC9O9Kc0l9ykmhdn7DC3EIOXw==
X-Received: by 2002:a05:6820:2c04:b0:58a:67b5:2df2 with SMTP id dw4-20020a0568202c0400b0058a67b52df2mr12344585oob.8.1700195064516;
        Thu, 16 Nov 2023 20:24:24 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u38-20020a4a8c29000000b005840989d13bsm169967ooj.44.2023.11.16.20.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Nov 2023 20:24:24 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 16 Nov 2023 20:24:22 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 00/88] 4.19.299-rc1 review
Message-ID: <906a58e1-ca7e-47ce-80ae-c6586156224d@roeck-us.net>
References: <20231115191426.221330369@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>

On Wed, Nov 15, 2023 at 03:35:12PM -0500, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.299 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 149 pass: 149 fail: 0
Qemu test results:
	total: 441 pass: 441 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
