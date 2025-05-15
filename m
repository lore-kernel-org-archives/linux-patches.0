Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B027297B6C
	for <patches@lists.linux.dev>; Thu, 15 May 2025 09:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747301810; cv=none; b=T0sN8agxQgbMpAv3ZDsUwK5Iw3TNkSEgMg/C5hcnKefBqdvhcnKDKo1ELArGWoon1JpLo1PsqsGb1F/mIPyiXfmSoxxjoQD0W+fEvSOMQyM2ZY7SB1kpp/jTQ2hQYJllmoT2zOCDD2FaUY68VISru9BPGwQHXL5d52f7fpn7GSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747301810; c=relaxed/simple;
	bh=djpDvvX/7HFh8gDgjiZXIm9sq02IazDn9C1NLqrTLqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WvfIRIddK9W4BUhcwJekBrMs8MZK5tKmFNcyMFLadrEA5c09bP6ueDv7uZ1tLWXTvCkDzCbrKWi1tbuBdYhHfobHvqKU4LKcQFVln4PtzZ1zZ/LZoRgcwW8xL8YcfdQpnO8Y78nFOIP19ixTDk2JaOf7AH8UlyyIfTD4t76d/2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Z+gPHVW0; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Z+gPHVW0"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22e4d235811so8944355ad.2
        for <patches@lists.linux.dev>; Thu, 15 May 2025 02:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1747301807; x=1747906607; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vsn3tSS0YIiAYkn/3PtEEaMquElK/Qt1xrI8n22o3uE=;
        b=Z+gPHVW0ICnHkzV6iMMs3/uC5dtMVdtSpSVZZlo1jXQlX+5c9tlWNuKp1Do/lg5Y/C
         8Wr1uaHSFaPRMPu43+LYi1sSvDaz9JS/S08XbIJXmDpLlO7VWCVVltv4VAeaN1ZtQgOf
         awAjlgsMMqaalwOp5sxd8ZegYt2LzzRFaoYw1/gL55Lg47pOCV+ljIPI5mxKPbPGn1v8
         99dyXvBL+15MykGXPtusWUR1euXlhPQO26w5dKPYMD+io0X34KihWPNzc1C9RzLthPzO
         ACuJBTtaAimaRkb9wxENaPDQkx7S5qpmwDOBTpUmMKr/W7ZRl1tsoPLP9BCoQQcGVNt7
         eeWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747301807; x=1747906607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vsn3tSS0YIiAYkn/3PtEEaMquElK/Qt1xrI8n22o3uE=;
        b=ZvgCYfv153l3pyGR/BSj4fXEMV5+J9hjUQmzln0mAWxRoXcIOBvnwO27mkps0dR4dt
         q0uQC9x6uQhmJHD6kMAnUt8Eda9gXeu6hbCF9t6tS88qsCB4VsjuTcjb/9QU9QOptPwp
         xb915C8Mjfn2hMjRhQm2J+wQ20pMQ03iTOWLoNnzArfIE2rHqUnQnDeznJlfCPGcO1oL
         IrqyPXvMjpV6ZQtWc4yMe51ptNM9ivnEelycptsqlYATIm07dju+jLa+mvzMrtwDoEuq
         v6I7LOc7FY/a9oGDu1FU2uGdgF//1stn8fNfrbrE3XwUYi0+dC0wGNDGx6UlTIe6I+tu
         w7jg==
X-Forwarded-Encrypted: i=1; AJvYcCVVJmiszrNKO/eW083kxwBRj5kwfZ+jRwjmGrNTfMgakaB/2DvMjIFYOL2cTV6xzZByNsnDn0Rx@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4TawJMacuZwT6PjREk9+yH/5I2ayEVAAKwxSnoYGN32e1GWgs
	xSoFPEj1jzB0yhMWEShvdydY24Zl/ola9lvhYtIhiy+IEiNfWLHmqmgn8MqsKaipw2S8FYmR6Cv
	KRapUm3hHu7DnD04dXepSuYoc4LBuczB6EbkAGg==
X-Gm-Gg: ASbGncsBFdDbbNnMFHEgfvGECNq1uyCJAEXuHXCFYn4UnaeZaaVPrLM+HXFMzGSo6vQ
	ni2+3smeItCMsPUcJr3VBoZOGfjBRWOF3ChCcmfgYV48VYonEhwu0UhWr+XxD57B82G7NMYoX0X
	5DJrXa+ChtVEDOOOzXwkaTWe4n95NN/BeDPYd66kEgQRM=
X-Google-Smtp-Source: AGHT+IHjX0X5C3EUWrGSjnnmKk8PWbWMvSh1PDfyYwywMuB1EdID9s2hTSa4xV5KaOkCcMVL9ob0s0DSTPTzbHdCtvA=
X-Received: by 2002:a17:902:da8b:b0:224:2717:7993 with SMTP id
 d9443c01a7336-231981c916emr92027985ad.45.1747301807523; Thu, 15 May 2025
 02:36:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250514125625.496402993@linuxfoundation.org>
In-Reply-To: <20250514125625.496402993@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 15 May 2025 18:36:31 +0900
X-Gm-Features: AX0GCFv7LM6xHGOMDQ0YP04y9Es-FYO33imw6SrXtOdgeyWmqPX2PDvxohw74N0
Message-ID: <CAKL4bV5fxuXaCcfB+omQEj=XuK40VO2XdUj3Gwu=EwuSLn0j=g@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, May 14, 2025 at 10:06=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.7-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.14.7-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.14.7-rc2rv-g6f7a299729d3
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Thu May 15 12:03:02 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
