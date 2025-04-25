Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD99722B8C2
	for <patches@lists.linux.dev>; Fri, 25 Apr 2025 06:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745561198; cv=none; b=qsAKpAFZKDnCCZwc3aHBzdcYPzZxDjBnOqDoh0Q6oGNi+clsp+cSnVaFIeMfB+PqwjeVNCv9v7NMd0tZ+4G10XydgVXPMMRTb6Q0B6fq9czthlEdSvLVRhKsOdmCnCMvKcjlQsTm7kHAMqyIlpQ1g4fHLXBcIMNEausca0laECw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745561198; c=relaxed/simple;
	bh=CpBT/GJTl/qOHB8XXefQW8z5QInEFr8XQOgxoGfmDlU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BZQfzfYcSQ7J89AZvRWyRxPfPxJQnTQ2ZaIcPKrjZediXk5dDIq2AYJkNQOfpMaOllVHp6Kma0Ef1hxDgH7zcuxLpmlmM1yZTD2qWEO1vvs3RflHbdcqTJ+UWT65RP418HobW3GAA7Enl7Tv05JDHYOhUMQHB1WLRrzW0L3Ynq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KcBHlQR7; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KcBHlQR7"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-86d5e42c924so1835519241.3
        for <patches@lists.linux.dev>; Thu, 24 Apr 2025 23:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745561195; x=1746165995; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ajgJc89GPboKToxuB8Pj0D0uNjRPDnR6q+9b48EFZ2E=;
        b=KcBHlQR7r0XYh2SiWcz+e6PnCfLhMB40j6+LbBDG0IQpywtrGuA0ioBOka4gFEqDXs
         AQMvhiP2e+Woj/57cb91m9LDbU+02TV/zZ8zLLKxyUeQRcRR29dQsyT5upo7d/3Gt4Bh
         RnnHSD29i19Ft32UvzmRHMFYjSPjTp15ZPWy7kNmZ81vimmgkU40m/eXp/2UEuVZYDcL
         U5uKCrMG0lliZClFkonby31S0NA+OOdWyKO0wZFQTicaIfjkdCctY7NKYQA4/3rMp0s+
         wnbezwPIWdr7lwIDipPN5miSE/g2pvYx3An62KtZ8+oiQ2xy4dDgJsG0MqUBl6103bFZ
         d3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745561195; x=1746165995;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ajgJc89GPboKToxuB8Pj0D0uNjRPDnR6q+9b48EFZ2E=;
        b=Y3iQQfqTKEbB5MqB0BdCC/ctGj01SeeVWwH+nT+YQwVrzhSEuMo3ZuFiVvQmiNsqDn
         ti0Me/RCdo5J9zZHCJX+3eZ5zh4Am/2zur5LdfhGaA0g/vyZ8aeGjGY7TmuLq4ZhuKo5
         F7MbszqqQeO6EgKguz2qr0bjfXlVof3dHRNNstA/qLJLq4LTEaCP9CakFnL7Pvjxbj8a
         CpDtl2A/+Igo5xRvaaKSPyB0xshlJQGG0xuKAMWrkdmXSduDdCrDPJ71Bq3u+wwePzjN
         P4xpok+UtEQBVU1orhCSMQUfyK94apOLSjHL4InPwSYAvCFIXiaOSGaJkainj525dLOZ
         cAdg==
X-Forwarded-Encrypted: i=1; AJvYcCV/l9M60D93su2XjIOM3ujf+zE7RoK4i0BadZ+HLm7lgU4jk5O7igOP0AmLGpqvzBX/KpR4GIjg@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6H32ZQznjDu1ZB85tXzpUuTLrpl4ACXYYwTS4IlLaJU/cEHeH
	2y9dTOyAflXCBzQ7KIOubOWF7d6mBbox0eexSh4gPqCqImLCyuVb31ECnKNkDX3E1BNtFhQPGHU
	X/pY/1spILfoyfuKy6dG9baY8PEnB5r3xqB9CiQ==
X-Gm-Gg: ASbGncuc8y+XFlQphXYY5cC/WP9E5omCIU+CAvosyyzyCL78RGpyMPnFfgiCTu3xYmC
	tcefuACsyGmHbTaBtmCiPqiytqSAoFLqxZOnCRhYvqas4Ly4hHU3n2px0ttztix1PkE5jGA/oZ2
	s7CyfqUWx1Ntg52GSuPmqS+aFxnWrNrU2OcGr05FnyXN/Lf36d29bBxTXl
X-Google-Smtp-Source: AGHT+IHk3Sh1recRtL0I0FAiNETtYwurKFY0CJ0FDTy8w0bAg/KMEvL/1tmqPiwb61pQkrz7JWUirq46fq8oitTFWfU=
X-Received: by 2002:a05:6102:3e87:b0:4c1:9526:a636 with SMTP id
 ada2fe7eead31-4d543fb6341mr362655137.15.1745561195672; Thu, 24 Apr 2025
 23:06:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CA+G9fYs+z4-aCriaGHnrU=5A14cQskg=TMxzQ5MKxvjq_zCX6g@mail.gmail.com>
 <aAkhvV0nSbrsef1P@stanley.mountain>
In-Reply-To: <aAkhvV0nSbrsef1P@stanley.mountain>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 25 Apr 2025 11:36:24 +0530
X-Gm-Features: ATxdqUHyh1sPNfszHFCKsjMSGrXxYsTXLBiYXGTypFcI7J1MgDaUy852FfJYen0
Message-ID: <CA+G9fYu1GagoVWnhNFnknWf0_zk-O+5XQXDiL-XUdt8knhJYaQ@mail.gmail.com>
Subject: Re: [PATCH] rpmsg: qcom_smd: Fix uninitialized return variable in __qcom_smd_send()
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, 
	linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>, Liam Girdwood <lgirdwood@gmail.com>, 
	Frieder Schrempf <frieder.schrempf@kontron.de>, Marek Vasut <marex@denx.de>, 
	Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Apr 2025 at 22:52, Dan Carpenter <dan.carpenter@linaro.org> wrote:
>
> The "ret" variable isn't initialized if we don't enter the loop.  For
> example,  if "channel->state" is not SMD_CHANNEL_OPENED.
>
> Fixes: 33e3820dda88 ("rpmsg: smd: Use spinlock in tx path")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> Naresh, could you test this patch and see if it fixes the boot
> problems you saw?

Dan, This patch fixes the reported problem.

Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Links:
 - https://lkft.validation.linaro.org/scheduler/job/8244118#L2441

>
>  drivers/rpmsg/qcom_smd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
> index 40d386809d6b..bb161def3175 100644
> --- a/drivers/rpmsg/qcom_smd.c
> +++ b/drivers/rpmsg/qcom_smd.c
> @@ -746,7 +746,7 @@ static int __qcom_smd_send(struct qcom_smd_channel *channel, const void *data,
>         __le32 hdr[5] = { cpu_to_le32(len), };
>         int tlen = sizeof(hdr) + len;
>         unsigned long flags;
> -       int ret;
> +       int ret = 0;
>
>         /* Word aligned channels only accept word size aligned data */
>         if (channel->info_word && len % 4)
> --
> 2.47.2
>
