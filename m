Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D834399F0
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 18:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784744079; cv=none; b=peOwV4aydXLnjGE+gAD7TTqHVK4op3ofjohNb8iG8cu+uZXJ2lvvj0z6NoAUdZvi1IU0QhshyEIm7079hDhS1HX5fmWPY2TtqN0t4DMJp0Fh3tDKSYGTtyJfVzQsinIEBTZ2OMLF5g7OpTZDuuSHZWxh4TmC21l6bK/hfiXZaXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784744079; c=relaxed/simple;
	bh=nMt6B4/q1TBCAQ6F7lNKXLoEDYctWbQcqkd1+vkzyak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B3UChCtGU+hPynZsscA3rNn+e7lNT02kxyOxpmnNcVuKhTczPu6jgFahU3XmXF0t5uZz265hE9QqBhX/mNLJBrvRPc4SIjkDMHsLk5u65kyvzXAMQOYxbs12u15X1433Vlr+ATLjvLODa/Yd4PquHhEzYdJDgwY7WoKKsBvwCXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JptoVtp7; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JptoVtp7"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ceb096e675so133557545ad.0
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 11:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784744076; x=1785348876; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6f7oFf4DmJuS0FEyIve6i/ssgkTTmEBTgdClK4vAOoQ=;
        b=JptoVtp70RuDQw+GZyzElky3nbBs0SJgMvS2/znE1M9AWLQEL3xQGvCNcVvTDvXcqW
         3LNem2uvp3LzqEZRZmFdZTaiazfBhaCQ6h63ziywor2JuN15Ec64WgPW7exybQNFvjYB
         WABpQiMnXS2coU4HaLcN5TVXScjazZRCwKsi+hQbWdNghxWKPPfOyNhoP8w08WPxDyQk
         NPkF0PY9o/7r36PVc9KkjfAdbB7SAqGERqe5j5jIpzyE1sg7Z+w1ye+xPtLJQgOMXNDM
         4KEs/QtItWlPTxU/CI5I0vpRD6UEH/G3vEHkHFiOeUNwgUF8ZCPBjNa+VWOHAJEfnY+B
         qtIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784744076; x=1785348876;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6f7oFf4DmJuS0FEyIve6i/ssgkTTmEBTgdClK4vAOoQ=;
        b=KVR3PrBAB8PgbUDoFa2/9wxKI9fqy/iC+zfFUQc0aKvaCaCO9ukLURTjHIXWfdoZ2W
         dS6nUFeB7a0Sp4Na7MUmkG9Ca7KvpxTlydFLWp/Sf/N+qB7iVYdtfMH5gois/YEJtEx6
         ob6acUEmwFNCQJaAr2Xvg/5fYxW6V8Br8GSDyaR9nQ9hFGLGZVCiySM9LYvohR0mj9j3
         22XYut/e9ZuYLsf1WTjbbZbbZBmJLJvrlDenvTsErEZFsEzpKGd2w6SUrMi2JHCxgkxe
         9eMdLhxBZ4IDFCqSLL0ubyiDjD2w56uTMJWNSl6pPqbIEs3bZWe7Wvd43/Cnr1dwRD13
         SW+A==
X-Gm-Message-State: AOJu0Yw2cvlB1b8Q2EqlLY6PWp+IosDVhq6JmXzrBtCqCWVaB8rQ8kjc
	ZO/7PGfvPYhKVu/tm+5RocrwtHbKcThzAgrCFMe7LFfuPgEatTG0hm5X
X-Gm-Gg: AR+sD13MGeOmZ5SLiUVkAwj0xTLvu5OrXfOca+lE7J7DUFPecuoXE9ycMOUDAypx5ld
	leHck3Or6ezrwlhLnOt1wicE9eCFyd3XOkqL6IHFPiiwmSzpNAdxeEkTQl+4IHAWS10UxmNtfKp
	l7AYsfEsLKn5SE1PO6eAAFX2VQrU5oaTp9Fmy6p/dDYBK9XsjjVKGxPHvdxuk/EFUcD2FukoAB7
	9oBCW5uu0VSh0ZNfY65up2fDsGsXQZ4NpBE/rp4NzbC09o+ZMgDAt9ExpvQ2YiTrCVQLg9V/RP1
	VZ3e+JhMzGfcHW5T4uqKpSt6vgxioYRLbkZigVtVUT260cDmPvrWjGVuzq1hlf5YjdEXwz0UhoR
	dZL8urSL6afkocELnrooC8MqT/5UOfOYkhNJY9X2c5/kjKYmDdZwIog5UQg026IYXPJgkwSOiDq
	zo+Gg0IUBjhpSB4LFQvmZ1c4QnvyrU
X-Received: by 2002:a17:903:13c6:b0:2c9:cb1b:64d6 with SMTP id d9443c01a7336-2cf348686a0mr256025365ad.19.1784744075796;
        Wed, 22 Jul 2026 11:14:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1bc886sm10928008eec.26.2026.07.22.11.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 11:14:34 -0700 (PDT)
Message-ID: <b1a98c21-f0b6-4608-83ed-63c49188a33b@gmail.com>
Date: Wed, 22 Jul 2026 11:14:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/1029] 6.1.178-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260722143218.909123637@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260722143218.909123637@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/26 07:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.178 release.
> There are 1029 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:30:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.178-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
