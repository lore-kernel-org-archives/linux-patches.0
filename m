Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852FD19479
	for <patches@lists.linux.dev>; Sat, 25 May 2024 09:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716630112; cv=none; b=pE9DR67PLXjbE+U3Hqogpowj0htT2WmxuJXEZ1eQJ/vZt/A8JiuKfQ8XLxiLGEeqFApd/rA66xiwslsg9hix5/ec1VwsKVTWSI4bS5UNHVvlBmsNMaOOIu2RaXo3q2mMHBRcyOjmM/cWb1p2Ca7sZiYH3F1SQjc1IqNF85cAh3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716630112; c=relaxed/simple;
	bh=SJ59JMVtpyZTcrEGLV2jLrMerwK7VxltPx9DOExCwN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oD1bX3zeIM2phtkaqpHok9yTIfTRNTqDWXqbQZPAqppnsph+z73n+x/HsGTUVxUGjb8qVjrJqHcqlr3USDpqbmxc5SftkYFbicm+/VY1jDXi8ctm8AUYz/LWOYi91ILQi2SJHo4zfvsuuXIcmRTt3LUh8YxSijwbQ3L8ll3zJFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=XwZHjcNE; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="XwZHjcNE"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1716629725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=48NlGMNTZbB6+4Wz9FsN3ZNPb6s0eRmxoFaiI7zXOEw=;
	b=XwZHjcNEeSF/Ir845/eBpKE9PekDrpxsbPMolFg/HCjTNfqudO6PDBYXp3kAzLdi9wKKTS
	k4h5QnkahPgtkyDQ==
Message-ID: <a352133b-935f-4d0e-8e98-beb657938f81@hardfalcon.net>
Date: Sat, 25 May 2024 11:35:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.9 00/25] 6.9.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130330.386580714@linuxfoundation.org>
Content-Language: en-US
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2024-05-23 15:12] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.9.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Hi, 6.8.7-rc1 is running fine on various x86_64 bare metal and virtual 
machines of mine (Haswell, Kaby Lake, Coffee Lake).

Tested-by: Pascal Ernster <git@hardfalcon.net>


Regards
Pascal
