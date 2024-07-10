Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225C818FC7C
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 11:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720609845; cv=none; b=OeGQTjDL5S3rJtDXGUK2weFEfQ2dAjD08w+WTBO9piFwmxhlHSkja10MPxP7GPJr7FicCpdZFlSmsOcF6iyKj5aYTqPGWnZ4UA8OENxNKRQVlK/dyasGnYNxW7iqyVyif2ltjwPVykBCaVqpMyAwL2NvxStfzDEUSqWxUOwkEP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720609845; c=relaxed/simple;
	bh=Pk9Dp0mnPPUcm8CNk/XoO5KLyYdGd5hWQYCuxbtJ3lE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qq1QpFxGMGXHcnIadpRhw3FPCYqZWOGdlBHsqkKzjHjU6vY+dP29A7/NcDXpOjq2gnUB9fP4HPGsJgd3Rhv9w5tQY8m2Q/gkNF7EV1EPUB4P8LnjOkHnItFqMpc9GjSSiGAw0cVFZNLQ6nCwawl+B8WdPbSfoTT9zY/L0Sa8JqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=WQgnylkd; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="WQgnylkd"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1720609300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+IvsDJVaB6RzaetSPmfHiiJoDXFHI0vEjBVyq9YM0Fw=;
	b=WQgnylkdpBykFP3Vu+wunVlwaR3KuYTDExX8bdWe+tPCFHBR52BphPvxDB8ggig4oLiWVv
	KG0IbfFpZY3ONaBQ==
Message-ID: <580c5ba0-1c23-4d83-9e5c-e0c1679ff5ed@hardfalcon.net>
Date: Wed, 10 Jul 2024 13:01:38 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.9 000/197] 6.9.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240709110708.903245467@linuxfoundation.org>
Content-Language: en-US
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2024-07-09 13:07] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.9.9 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Hi, 6.9.9-rc1 compiled and is running fine on various x86_64 bare metal 
and virtual machines of mine (Haswell, Skylake, Kaby Lake, Coffee Lake).

Tested-by: Pascal Ernster <git@hardfalcon.net>


Regard
Pascal
