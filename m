Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D743AC0DE
	for <patches@lists.linux.dev>; Wed, 13 May 2026 21:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778709539; cv=none; b=mNN/LncGQFeaAqlLgkrJRurjU0Dfa+oM9P/6m5Wgd3GXj5HswZSW6Vqgw431+7zASNlNuQQVIhNHoD0vtALOQkV2XKHJSJOf7DwP/kalJOejSodvUkYRZ2uICzzh6VPS1Hq1a+Cw6e5HSRFwio4+LCuTMY7eBogRAoaLS+62494=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778709539; c=relaxed/simple;
	bh=S/LePRUV5aauwrD2/aCKy5ZB6QqFqRXKBlmyivFUPpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uy73JTu2z8QbB2mpoE9SkoX+8q4FGh5IkeV+M01kgs8oHR/L5pkQlsvG3Vq06Xf3zk6O9iyiq05QnPWyGRV0ZeFd687gDA2sUQfK6gpRIRVc4q41JLK0+idQCe8DHYKZ7vYfFH76psxKcn99uhe7DKpPCOEP/ZxGTuCeCX5Py54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=P6ic4fbk; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="P6ic4fbk"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2ee990e8597so12441897eec.1
        for <patches@lists.linux.dev>; Wed, 13 May 2026 14:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1778709535; x=1779314335; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NTfDsttXTXW7TlK3rMWi2LRQ6SPJ5zcQ74dCRudTTV0=;
        b=P6ic4fbkcWP8QG21eM+IUR3O6TdgpjaytdFu+zGBm/AOPmd5CB3dJaWkA4HA7F/tbm
         x6ugWRymZSLEWv/nNwMc3t5g3u7KJwkp5ekfjxrp+Fwj0VIq0I2NOzhmBgdmYe6zKZ55
         LjVVTU7xqZOzMkmN6m7J+ga4zutCvU401Cg8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778709535; x=1779314335;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NTfDsttXTXW7TlK3rMWi2LRQ6SPJ5zcQ74dCRudTTV0=;
        b=mTlIAyHUoBajDuv6kYOjokZ50kIDt+O6LowEnD9h3wnMt7Yv4pjTMQoeqXjzzD2SnV
         ONSHyGtqTJ8U0RcJ65KOcprTUQYn9U7HMqQW6cgiCQd3gz2E4xMn/rIhiy/tkQlnmpgP
         hNb5TWQaopV4Iup6AJKP7/8ZLjoEzwO1pbDw5EJzr1yeNzPDv197CtmUfyM5e1hR2Q2g
         VE1WhINAnOb0AFNzlyGFUay7obXyl/pqUF7uAIs3H1/NCgx8ZJFiD0AyEJ+Ykcu++jNm
         LwK0dJp5NOkw2/oeIii+MKSlglJYwM5vYkLKQsVcyeUif7SdK4yobV99ACq+oif0/UaH
         P61g==
X-Forwarded-Encrypted: i=1; AFNElJ/syWHkSTDi7T4gGlUwD0axEAcsqCe0R7J8gZNGo66/wqUmC3q1G8bOnkQYRHFmjh3REPM3f+cQ@lists.linux.dev
X-Gm-Message-State: AOJu0YzkHdbBZOSJiSFiF+EU+ekie/9/zr5ivhLa3Nxj+RaIYBDe6/rB
	5aDf4m46yVGFTzjS2mUNPovPaF3e3Y849jk/E9/xUM3jJgQ8lHGqFEEPYqiqh//X+Q==
X-Gm-Gg: Acq92OFKTOc5sdB6BDulJG3EDOJVxfdrxN2obIrUemCVHpCYNRJjH7hgjCiUMFNAfn4
	qAvPWcUDmu5UljwshacFLu91cjmQPClLyLMgGY8zVCbctH/BUFAlr6oZvAOechc3wUK4zxrJGPu
	tA1dVskWnOo5gO3R3LbQJfSC4v3HY2mdQuYNe1UAO6kpb0PyCRytOV53hVpFIr7uN0NpmJEIeYQ
	RPKbNAyZM16J9PyBPCuwJ/IlGtPDFI8MakPyr+jjaoukkFrbuoyiW8fFENwyPd0ScgybACLo6jp
	/QCf7o768MR2o6fyHjSH8fNswGsX3m3m2lUlOTY9knE+wGNHo/uxTwtOSr0DNrjIdjNh1TQ5sq6
	TComDH7OGL5IhoLVSUV+3ZrWo0lngo1bcOtTOOKYQEik95E/TSxSwFgjbMcX+TAWlTbn4HZCtMa
	vmIPqdP/GGHTxoBFXLNs49g2UFRbvdgf/Ae2BEGWkqVA==
X-Received: by 2002:a05:7300:e105:b0:2f6:811e:c840 with SMTP id 5a478bee46e88-30118daa1f4mr3316321eec.18.1778709535579;
        Wed, 13 May 2026 14:58:55 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.105.111])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30296dcc458sm804611eec.18.2026.05.13.14.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 14:58:54 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 13 May 2026 15:58:51 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.0 000/305] 7.0.7-rc2 review
Message-ID: <agT0G1B4cLWB4UKg@fedora64.linuxtx.org>
References: <20260513153754.934923793@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513153754.934923793@linuxfoundation.org>

On Wed, May 13, 2026 at 06:17:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.7 release.
> There are 305 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 May 2026 15:37:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
