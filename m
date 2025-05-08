Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3CB2192F2
	for <patches@lists.linux.dev>; Thu,  8 May 2025 06:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686434; cv=none; b=ipVv7zLko9DjGzc8deymlue/pDVgFqrHS/bdFcYR1Q8UZUx5kJI7l8DsXuZStrScMiwAhmzt79SRf2v7wyYYDEIi7WRLnt1IdSnUa6CuOEwNHazPdFCdK8MPBxutoDIkk3t17VIYDYXNK/QQwP3ybkkdAF6RqxLZZgZ0elvSVgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686434; c=relaxed/simple;
	bh=mo7aBOYxy2laS+VfZHPupXplp+OJ0XZ0QwmwUj+Cx7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m9B7K2sZV2/7Ed1DcazW7O9GdYG1lTGVhmI4QBh7z4Fo5chC1Upy2A9ZSGLqe0yzTpH8Zb5YblkHI4dTjWKhU4iSN3NMVmthPq5FBV4LzizOjm6LNMEnbZ7ceynwy8Zx0uzFDrMRjaSxDQ7sL8+xKX1i+dZ63eTIZyuPaNiq+48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fH5FknSS; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fH5FknSS"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-441ab63a415so6269435e9.3
        for <patches@lists.linux.dev>; Wed, 07 May 2025 23:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746686429; x=1747291229; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m0BYhiXUdA6i9dCcFIqo30mmGVKS8d1Kjub/7fShZA0=;
        b=fH5FknSSGCWiOvo/XqDgiaBeHiqVwbv10HnDjAhVFJ/W5EG5VTBdTedzLtZWl5i70Q
         FGBIpwwNPUU0za7UA2Eg8L+1m9poElY/UtEdiM1XeYtsOM+3Me+a5XnJ7buiqSmCycdW
         ewoOPsfypZQ9yViI97yxFa1GUQWNSk4e++vvZob1pxkz55FbOSqQgXF4mIWJ7cu15Hv9
         +fs9oiCjN4Fur201G4kukQR240nd3t9VAlWkHTJSumXtlp9ah8a8lgrLO32rxp6PrqxD
         t/kCGog64Tf+WdIIoUMFbMNFLRRcinJw54VNYoI6/rFL4sJOeJzN3CBPr5JPPvXjwJl2
         GEFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746686429; x=1747291229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m0BYhiXUdA6i9dCcFIqo30mmGVKS8d1Kjub/7fShZA0=;
        b=oRSBmgGbugTkYLox6WXOcbtSptEd5C/SQP8AhphTej/Dr833XunCcQsLkaGpdEGZKq
         0GsEHKyRM43LJ8liwK5RZJyO9GU+OWqgnF4zwfsrpxWLQhtL7FO99ypeoaXncfLMij2r
         8+EMh3VD/EHbkFtoig6RUfyD19WSRHiDwrBP15exGToFQsShq35i8Ag8kISEDTB5gryZ
         FePWt1zCNvfhrnufmQIF4r8vx6PlFBMbBdVcJ2g/oPLeVcPsUp43BNLBqIO9STuoeW9Q
         zYb2RpJzwuC6PXl0es3wKfAUtHz6/7JUT1lGS9dxxLu21gy/MmxZu2Ym6oGdiTbdF63v
         2n3A==
X-Forwarded-Encrypted: i=1; AJvYcCX8dSoFkK1MwHT+vKZCEoaUgJNeHuq1rYFd/VM4tYGfE7xE/pxy25PCRDkspFPpdoWXXZ6n+4Q5@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7fgD6s7ahP3902vNYVGbwlHe0IzaDA1De35HAh7SP8GR8FksZ
	VW+h0evfczWubL3nIEvwHub/hdfmVfSddGKTjbPq7RF0dgoyv8eUAjRCXtmXwAA=
X-Gm-Gg: ASbGncsWT3tOwGOUuPSyZh5zMXBpdSKvNDn4oPWy7t4NhInshKVfJaQywcq+jqOtE3B
	RASo5v4zu1PcT2wlmBuCJlvjYkQsg8IZHCxRbUSe1qn2JOX0e8RkB7Np7Y5O2nHelEMUJd2sTsZ
	hp9p/AXzfI9snLr7G9nzBu35MvoHGAS+CGEs1FVTLEZ5v0KdMGTc5oa3AkSHQAdr3+nreAWpYpa
	zjY7mfTETtvvfyhsfCamJnQ45zEzNXIapAEE3+7kQ1Zwxs2kjWs7uh9O4zUQv4Uy5Ik0yR1pOnw
	mpoU2yXoyXZS+Xr8aL6GTq5U43q3zz19xtO9fln814NGr7a3qccsO9JX
X-Google-Smtp-Source: AGHT+IFZRIfE5PxRRbMe4B54cwayzKdn3VEZhgxzfmBDRkxcWCbiRLfEqYjfrSNjGm+C2f+T0IBaxg==
X-Received: by 2002:a05:600c:628d:b0:43d:fa:1f9a with SMTP id 5b1f17b1804b1-441d44e3359mr67512805e9.30.1746686429396;
        Wed, 07 May 2025 23:40:29 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-442cd35f40asm25158595e9.27.2025.05.07.23.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 23:40:28 -0700 (PDT)
Date: Thu, 8 May 2025 09:40:26 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Bjorn Andersson <andersson@kernel.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>,
	linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>, Liam Girdwood <lgirdwood@gmail.com>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Marek Vasut <marex@denx.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH] rpmsg: qcom_smd: Fix uninitialized return variable in
 __qcom_smd_send()
Message-ID: <aBxR2nnW1GZ7dN__@stanley.mountain>
References: <CA+G9fYs+z4-aCriaGHnrU=5A14cQskg=TMxzQ5MKxvjq_zCX6g@mail.gmail.com>
 <aAkhvV0nSbrsef1P@stanley.mountain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAkhvV0nSbrsef1P@stanley.mountain>

Hi Greg,

I'm sorry I forgot to add the:

Cc: stable@vger.kernel.org

to this patch.  Could we backport it to stable, please?

regards,
dan carpenter

On Wed, Apr 23, 2025 at 08:22:05PM +0300, Dan Carpenter wrote:
> The "ret" variable isn't initialized if we don't enter the loop.  For
> example,  if "channel->state" is not SMD_CHANNEL_OPENED.
> 
> Fixes: 33e3820dda88 ("rpmsg: smd: Use spinlock in tx path")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> Naresh, could you test this patch and see if it fixes the boot
> problems you saw?
> 
>  drivers/rpmsg/qcom_smd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
> index 40d386809d6b..bb161def3175 100644
> --- a/drivers/rpmsg/qcom_smd.c
> +++ b/drivers/rpmsg/qcom_smd.c
> @@ -746,7 +746,7 @@ static int __qcom_smd_send(struct qcom_smd_channel *channel, const void *data,
>  	__le32 hdr[5] = { cpu_to_le32(len), };
>  	int tlen = sizeof(hdr) + len;
>  	unsigned long flags;
> -	int ret;
> +	int ret = 0;
>  
>  	/* Word aligned channels only accept word size aligned data */
>  	if (channel->info_word && len % 4)
> -- 
> 2.47.2
