Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B434E7808
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 16:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664234; cv=none; b=KJCyaDMnj73HHfrWLrKw8lirdwgSAEIQufOML1S8ovL0jZFwNyTrWMV7bYF5LJeOvm/Zr+GY+8Kpw2ETHv2jhwtMWJHqJfQUVmJM5gaQhMFXLUzV3jwz2MXX4MpkSh7AanHn9U/OwsXG5CTM79uz+qg+GlbQthbKLTRvlgzK5CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664234; c=relaxed/simple;
	bh=zydFOkLusCsvZen2mb4Pq9HJvg/Y0I4yNFZXUL0us2g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ohFfxtWnk7GaUmGi0GDIe9Z2g4gNUMbD4FSvAAW0jHOl+qqVCXd03l9lRoloKjiVbO+E5z9WsrvLYE1ij8BVULlpowDw/nJrMRrWN7Kmp7lrCvFsSc+RE+/lGQnFb71aMcs+34KENllnDWKZZVd/ALR/Oz6xc6BzImObKwNpmXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NW7bw2Zx; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NW7bw2Zx"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-52fb766bfd3so8119091cf.0
        for <patches@lists.linux.dev>; Thu, 17 Sep 2026 09:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789664232; x=1790269032; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3nD+nNF4AReTcmzz2bWEK23wh0b/1V/6DLReQB0yfH8=;
        b=NW7bw2Zx0qQrOamvtoz2E3B5GFc0Vx8Rzwz/At+uX4RAj9zMK55a/I1Ob7sKVJa9q/
         SM4sMB8EfCyu08DZPvSjTs724dUlyBmanTh1Jo3Y3uUhb/X3HonRbkZl5md5QTwWC3YS
         0D3aTN+hGZ1D64gDcpkVw2kyYNlPlVkU8Y2jjVMn3XeKIBBuuOQYZ/FUmPb1AN5NgKdy
         ZBYPD5arvjE+JvODG2/uiU38POlYzT+Go2VUndabLU3CfvV2Z72D2jKlKFL/FwJwxt0O
         vAEMgbZtaVGSQdCSjhL0A7Yyc/K+v4dVYxwLI4tfUkaJUDCJRmrOXbHqo7KTHPyohUZR
         NaQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789664232; x=1790269032;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3nD+nNF4AReTcmzz2bWEK23wh0b/1V/6DLReQB0yfH8=;
        b=dNH1riSQP07aZ2F4uNQNhcbUI2bfb4HUScuiVlxi9YssHRgMTeBtKdar3eCBCqJIZa
         DELIvGf99/h0lXwTb79pnqX2Jitr3wn8iEcNXV6COKerPscPx4CnunGupHody81rNZnp
         UbXc6r3pL/ibjo2/bnF9r5T1oKiTU/thCth9aOeyAIOz9ce5YRk/SwgUNmNxoIBsT89p
         n0T0JdZP3RyYbgomDg+UTpPlvT7wxsHBlqsPSFLOI7qfEzViGCWq48x0cgmSO6i76ki5
         9+gmMfYXxHra3aw0If2xHVouDnqlx1PWgz7ikr15WRvOdODXtw41cELNRL8UyoBJrbeL
         lV3Q==
X-Gm-Message-State: AFuF++m/cYSgLaVINBCe6eU8myy8qgb988PXd//HzYkoVTydhNhBctol
	pI4pSOclaoDkkiq7AepUBlpI90AdLK+n7DKIWp+DkqeAHbw5kUap5ena
X-Gm-Gg: AYBFou320F04NEvR9Y7hxaMf2Srby/ujRdxQP/UPxnZL12Qomzql/nLzBsApDHrmSO8
	zphJHuxbSFr1PSN9CN9Qwr+xa/ONwBr0tCOUKuGzWKWg0GbAOxyu0xeoN7kTMyFS7s+6gWWCaZb
	dekVEJU03edXpZCMtp7lTHHA61HiEYAf4Rlv7lL1+HQyK2GnwFDxWLOQtrCtYdRl3Z+lzzaZJR0
	l+d5Tx4iYjIw1fg6j5PZ5gwqr/mLtMzW3gv9vcS0k50qMBHrIc5WxPXLWBQTP1VspWRQoejxRmY
	ZYYGVFWcsuT42XOZjwnEdm3HT5b2pP9K4WQfq/sPGcxkSg8npj4c8qkSxc5cnW6wOZ9aX6noQ+q
	g+TAkC6H+Wy9tWgdiMiyTRzFKFNX/eMhzNCFjpJoIpKEZXNaLi2urm8vplnr7uWtuVFETPjbb1I
	GE/i9vmIH0WiAy2Fa+EG5qnxGVxCVYnuhkqUzmSB/7Pj4O82E3FXBw13stKpy8CjuOCjQ7zzGuz
	4XpNwNxmlgYk2P0yaaXb9TVSQ==
X-Received: by 2002:a05:6214:e8a:b0:90e:7c37:230c with SMTP id 6a1803df08f44-9123d701242mr168976896d6.1.1789664231623;
        Thu, 17 Sep 2026 09:57:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91252cd40d8sm1989826d6.35.2026.09.17.09.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 09:57:10 -0700 (PDT)
Message-ID: <d1d113fd-2943-4262-b8e9-b0dac7e373b9@gmail.com>
Date: Thu, 17 Sep 2026 09:57:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260917151539.408551884@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/26 07:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.111 release.
> There are 1102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Sep 2026 15:13:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.111-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
