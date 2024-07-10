Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A081218FA32
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 11:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720609611; cv=none; b=f3oV//CsUNfXL3LxxEfu1UozyqkFx1GtpGFr+JXBlOc/9e8Y6ysRU5Ssz/loPBMaUnMHI5A/jaitaH8+ldG7dGBMq4gU5AY9FK9H4TmRpPSRylA3qQRqWHCs8xR5caMFpvxp3SaiJdfNfqQsqva92qMUN71gqpO8gM3wd/rX7SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720609611; c=relaxed/simple;
	bh=hkZwcoQ2TO5xD0fdhwzch7SdWXBREARmTsnM6TVCWdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eIEz8cPJcrpXi1+gMycpqNEt5RAbcP9UZxgesaqsBwNidUKbrp9ypSTOWJMg/W0C12TbNFJ6lNaSL2Y8oA6eJggB+4f0CXTb2kSOfxv++z8FVh29mP0519hvCHhBpgAtkTZYg9FLPU+HijPCBPwv7RCqp5VzHpXxMmgTbFOa2a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=g1zFzdJZ; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="g1zFzdJZ"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1720609606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JkG+eRDrbE3tB4n8sCQ1TXoCScGItZHmbqnzq3s/HFw=;
	b=g1zFzdJZ2euynluiYP5nSTDVh1+QJtMbHkS571Vhi1TPfipGvwFb7OqaWJ+dVTI+ZhJ/EQ
	sMNY1wwLhWlc2DBg==
Message-ID: <96fede14-1b25-430a-8b99-a14308bcf9c5@hardfalcon.net>
Date: Wed, 10 Jul 2024 13:06:45 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.6 000/139] 6.6.39-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240709110658.146853929@linuxfoundation.org>
Content-Language: en-US
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2024-07-09 13:08] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.39 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.39-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Hi, 6.6.39-rc1 is running fine on both an x86_64 Haswell VM and a 
TP-Link Archer C7 v4 (the SoC is a Qualcomm Atheros QCA9563, which has a 
74Kc MIPS core).

Tested-by: Pascal Ernster <git@hardfalcon.net>


Regards
Pascal
