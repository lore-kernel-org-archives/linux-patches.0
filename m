Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17BC819
	for <patches@lists.linux.dev>; Thu,  2 May 2024 06:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714632275; cv=none; b=GW8NqeKHQqifTvrDBW/WGmXTXyZhpbDA56VxIedOZvFqBuFz7i5Qx0+02Rj6nmo+Cxz4WqZNWetcwIP/oML8PwYJ6dXnqv0suXr/vQgQ/xqrI8bWn1X6q0C2VkUxZpClUJ3mv9AqTcOOi3Uw0dn93DAVCGFsAN6Rj2Kt67HlTK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714632275; c=relaxed/simple;
	bh=Cz9mH5GY/m0aLlXwPgcBkN83kzPXmWBTqNzF1/9qUu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YfGKVCqin50As/tCLQCm1lyfTBZBOkW0PI7wOwoPZdlCb8HGPqVZuymojBGXBLsti8ii1c/ti1w8Q8NE/dMN4fpHXPTJqz0kVrTw87dRJgnjB4pWfu/892QFXH10TUuMzipi41PfGfQUhHTCe85g4mfAJJbBpo0nDAOgIGyQ2iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=zXX2V1Ux; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="zXX2V1Ux"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1714632270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ln9lQYI410ocTqbjnBMUtrtrYzPJN6ne9YOdMjyBmeg=;
	b=zXX2V1UxN7vIEcuPU8AFpwaTUt6wIPxrp6iZbvrpyCTCbKSyIk1JZLW0zWc2HaiwCroSHw
	CevgP2iPgMC/1LDA==
Message-ID: <356c4202-875f-4277-885e-31fdbfd746c1@hardfalcon.net>
Date: Thu, 2 May 2024 08:44:30 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.6 000/186] 6.6.30-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240430103058.010791820@linuxfoundation.org>
Content-Language: en-US
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2024-04-30 12:37] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.30 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.

Hi, 6.6.30-rc1 is running fine on an x86_64 Haswell VM.

Note that I have *not* tested building the kernel documentation, and I 
suspect that building the documentation with docutils >= 0.21 would 
likely fail without the patch from

https://lore.kernel.org/all/faf5fa45-2a9d-4573-9d2e-3930bdc1ed65@gmail.com/

Tested-by: Pascal Ernster <git@hardfalcon.net>

Regards
Pascal
