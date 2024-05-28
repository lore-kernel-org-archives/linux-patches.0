Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62366174EF4
	for <patches@lists.linux.dev>; Tue, 28 May 2024 19:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716924829; cv=none; b=W7SrcXAnzUNgCvE4ZTMCpBPagkNNlUlxYAjODN3E7x6aWR6p+HS0ofkW/9Y7w6UaswSo22Oc9rLYcUOXGkXAKfpj4mC8uflypEkZJ/Zb4RTlBP78QP5Jik14QMd0pOzVRWb+lkpVqjXNlq28vBirLd4f0V8f04Ralw/P1ED+hTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716924829; c=relaxed/simple;
	bh=SAzqYRs6ytcvBAT2gM+tFTk/FkMB41AMEmhlw5Oio+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZJJAmrd2LR1NYQvJMYCacWjMJLOwiUPVnWOA7Ss6llt3LrmSo4oZkB0PfrRajJW4EtU0xr8LhjYF35BbKmSoAYKhyZtoynGqp9/QETqCuqurh3QimSMGpHQcUQ+6qkKFgfBIt3ghqkvNBbVwIiq6Gam7TKHy8vCpxxvpn6g1bOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=0HhiQ6gP; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="0HhiQ6gP"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1716924817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vEcYrtC5/5DfStl4dIj37jhAbDFQZAJnvaGpqjqdsbY=;
	b=0HhiQ6gP6WIuQRoqHpxzONbELHFREJpGNPmsWk8aDbbCc9SMtQ3rwOj5r2YsxcjE49LSAH
	mzO4aRrAS9x/zMDw==
Message-ID: <246d760e-eb56-408b-ace4-3c0e6f3c25d7@hardfalcon.net>
Date: Tue, 28 May 2024 21:33:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.9 000/427] 6.9.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240527185601.713589927@linuxfoundation.org>
Content-Language: en-US
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2024-05-27 20:50] Greg Kroah-Hartman:
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


Hi, 6.9.3-rc1 is running fine on various x86_64 bare metal and virtual 
machines of mine (Haswell, Kaby Lake, Coffee Lake).

Tested-by: Pascal Ernster <git@hardfalcon.net>


Regards
Pascal
