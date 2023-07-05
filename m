Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E207511CAC
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 16:28:08 +0000 (UTC)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-57688a146ecso81439897b3.2
        for <patches@lists.linux.dev>; Wed, 05 Jul 2023 09:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688574487; x=1691166487;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bkxMlZkzxcysGkTdihnDiCidqfVsFE06UkOpIAnvMdc=;
        b=lAq0ZB1eGH5dJe58j9ci2XXr6ef1D7OEnFG/jNK/W1/C+bvNZK619vhRQFzS9hk614
         pbtSlTih9e/sznVefJrdZp5nRYYYu/2B6gutDBOLQfuENvZa/3mWHtOWoqoVNpTJBYZB
         jB/R3MJrHft4HgdmFTa1nLYKczPbka02i8VkRHvMaO1v8oexVFM5DvLSumDVXUA8TKvI
         wHeqrsfNVL3VFInfvC8FTJqocO4UaE2ao8xIzuFWEzq8uhMslmOaKkB1Y4H6v8rVpBn2
         FfDCrjWrNSjcUe9URURoBjFfCKMXtPBXVJlw2gNkZbrXRyJxQwzJnqdEqa446MCnLl95
         +0PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688574487; x=1691166487;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bkxMlZkzxcysGkTdihnDiCidqfVsFE06UkOpIAnvMdc=;
        b=eD1HuNiDQtu1zBhTgfapn8ArgV9yl17UmwpvJjbPs5gjJ/dyy/sKJeIs+Q+PsXbZrx
         5GDj3KskIYG1lG7j0bcBE8RcdzxaxijHh82PAXxN0Jw3BoyAU9Kp4BU0ow2eWbgm3I6J
         5d2YtsFUWu+m3D+03VMyJL+mROEnlCEKSKIVNBJo7h6LFR7taau+wjNRHFrre42f9laM
         Ji0ZpUq8jGfgZk8MaGnRywTKTwi3dQ+YmkmGmdo9jOtllpgTABcMoQy9+2Fi974i3Y0a
         /OGPUQaAh2Dh+h+g1AtmEN3cH9KLyU23w/QR/E6JxNkDXfhqaGscR36k9Kma/WRQz/fO
         +4Mw==
X-Gm-Message-State: ABy/qLYOpLPF7HrgFj8t5MUkkbTe+DBTWiAZGZaaFG3v59jKevf8wUDT
	g9yLGBFYul4UNNV2kuEbeEFiDGq3N4U=
X-Google-Smtp-Source: APBJJlGLYHnbvn6/Hhhn0iphucwrngQ/E9k2ghdR3X2ehjg4bTn+GtbLH/9FHSJ/C1pfaUL/dT8GsQ==
X-Received: by 2002:a5b:14c:0:b0:c62:fded:6559 with SMTP id c12-20020a5b014c000000b00c62fded6559mr1869676ybp.5.1688574487594;
        Wed, 05 Jul 2023 09:28:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r17-20020a258451000000b00bb0a8342723sm5138047ybm.50.2023.07.05.09.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 09:28:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 5 Jul 2023 09:28:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 00/17] 5.15.120-rc2 review
Message-ID: <8d6e9db9-22dd-48f3-ac3c-9d4aff8459d8@roeck-us.net>
References: <20230704084610.981452877@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704084610.981452877@linuxfoundation.org>

On Tue, Jul 04, 2023 at 09:48:47AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.120 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jul 2023 08:46:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
