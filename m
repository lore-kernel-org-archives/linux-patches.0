Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB8D17B432
	for <patches@lists.linux.dev>; Tue, 28 May 2024 21:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716931545; cv=none; b=Lfb74yGTODVfzQhmvOmDJ4vUgKdA/QoHvYHNGyZraLpG43NNHI1yijKxzky/XHWeRL4lJxcNgG//V4LbariifxO+mdSgFJLLtc/tv5+vPctJYW8JqDRzLUyNrWYYD29HjxB47B6UnaJu9nMVkcc1vtoqGSBTIWtN3WUiao+izhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716931545; c=relaxed/simple;
	bh=fZlxPWbgGevjd5cjd+01/dGc0pmuLz7vTQ5MZ5u224Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OVSybVE0bydzBqm5LxOstbdwQ+jvTL7HI4B2S4+GrbsJU7uInwl9Jviti7kyrccITA/RZ2thNxmxREatc5i6zSDXU8fyHSYUp+6rSYrg5l+M+eVwvMRfqasjlDVKWDp4omZNF58LPPteuMyJWgbo8uLWc3ECGWXP/IRSxW6N7SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y/3PsnXe; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y/3PsnXe"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6f8e98760fcso1039002b3a.1
        for <patches@lists.linux.dev>; Tue, 28 May 2024 14:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716931543; x=1717536343; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q30G+Ol17wTE5vxf3RQS0d4phvzRCZNYkcikIChxgJ4=;
        b=Y/3PsnXeUBQ2uBhdt9K7udwvHAAxGO0vxJR1N6GWvrZux/qB6lsP17Vg2VdmUJEM/6
         WIHi9dg28Z/j17MsZph5QbhQH5iG+uosl88p5E9URPLxUfj3Txw9UBOXThAzGzUP6Q0O
         6W08zSG3cD9+DtId5GP3r/a1aS/74l0X1RETWFjlPJqFWBUiNl/zUD0Ki4NB4T6YPysE
         FWKLdUvrevTLuj5IUznpvXLVOVWU03Mt5rApNSLIskVj8oF+O0aEiww7zMkbi2778DAX
         NRw6vYJi25a06ESCb+v/LMt06YdmTHD1oT7nglf05w5QlE7dXo0lMtQINDGqju0Kx8of
         4Myg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716931544; x=1717536344;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q30G+Ol17wTE5vxf3RQS0d4phvzRCZNYkcikIChxgJ4=;
        b=AF+M/oei0kmPMmbTv3okH61sjHd93My9FgEgTjP/Kg3S5sGtH+lhD392Dq8mWpswEI
         upjcybBH3CHCw/G5jnNrdT7mtYoA7+mwL2YKOy9tQdcWaJD0Tfr+rMq77f8lggYZ1v/p
         RA2jggChB+sy+NwZ+YGxQrUf6GjgLUOW2p9mLtbaaQGNtfAEkp9mUb9NIFoBOulR2ZFv
         cgbWE2mLaDc5nQViDBl5yk8pPzuiBMP+3Nj9Dq4M+QoVMt7gFO+xMuC+teBMjudMVvBs
         ii+zxlAbciNjBxiWX/AvIc963TCEN58+c7N3iEV4/IrZ8VymO5u/7rVW2LnKP7Tdo9WK
         46DA==
X-Gm-Message-State: AOJu0YyzqNwCNimOwMGu0sDb4koHdO8/lDhgUGw0NKW+hFRdVtppow0V
	yHIY8L72MKQf1Qh4XpfnpkgliWZ6Qy021Si+RMHxnL+nKCIijxZRD/SPoYpH
X-Google-Smtp-Source: AGHT+IFQQrrWfOhxR3usxN/wz3KXihWEswWZyob/o3XFZPagZv2IXPSZBbO6vbHoq4971OXdZ6Em9w==
X-Received: by 2002:a05:6a20:3955:b0:1b1:f6a9:6b0b with SMTP id adf61e73a8af0-1b212e2c3a4mr18856286637.51.1716931543494;
        Tue, 28 May 2024 14:25:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-6f8fcfe64d3sm6860782b3a.167.2024.05.28.14.25.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 14:25:42 -0700 (PDT)
Message-ID: <d0bd078f-a4f8-4928-9733-d7a021b91dbc@gmail.com>
Date: Tue, 28 May 2024 14:25:40 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 000/427] 6.9.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240527185601.713589927@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/27/24 11:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.3 release.
> There are 427 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 May 2024 18:53:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

