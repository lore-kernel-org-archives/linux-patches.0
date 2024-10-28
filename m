Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05A01DF978
	for <patches@lists.linux.dev>; Mon, 28 Oct 2024 18:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730140533; cv=none; b=Y0mdxDJwkEXGvETP05UCP4NphjXUE18VhXODAYz9HN5Q2EWYUigLsRYijU/CFLJrD3iZn06PUrga0qlOXeoMOgx6/o4G5NrME8Ec99MbaNcokYL6d9+U1tmU47PVXN87URmvavvhzMwGeGooPymSOAvix6+kBF4E+Ou0+m9FZsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730140533; c=relaxed/simple;
	bh=jnb+plD7goaSH8wIGYb1CGDhYn4Q9ZI3UyivcI/bHVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g2LgXfmK49C1vf14Ix45vjtJe3ALteo44Gq+P7oQExRYhVyTKRIviOkwsG89Ib7BxNkr7CZvpJJGghxj53+gQeZJZRV1BzUsAf1wetxJbcPmR5p/bopNHvOY+1bDDbj0i2ZYdzjT2FbJAABGoFPUTogHmijhxfFlrz9grPUzKzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=JRIeBYtA; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="JRIeBYtA"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43161e7bb25so44908775e9.2
        for <patches@lists.linux.dev>; Mon, 28 Oct 2024 11:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1730140529; x=1730745329; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wF7rFSZwpkrhJ/3IUc5qJkA4CHR7vXwnPrWxE1l4Tbo=;
        b=JRIeBYtA6zwsS5VA/ksR0Zsb9xUMKM+N5kWClfui8YXESvV7yp/0E6X2CU9uOdgp0Z
         c6maJJ7ckKJpmWxJ2zYeNwMFfd5yBTH5pHFtykZppHNIA1RCtJCquMR+WLu6j463lGgZ
         fmbI7LDKgyDcl7JchrACUIrM7YkBfXbO5zfeeT3w9bD7nxVNKS1oLVllojVz0ZFhdNlA
         M2X4acZKhgKB9TnD4o5yjyPIB8r/jgldOcNXg8ilsvn1OYTx+UgPcI6IxftMWzepJhii
         Hwe2Cu5NiVafmoRwwMnbauNGr3KrSy0gB7pkct7O2trODRxqcS7fLUOVjaIi4MhGpxkP
         TxTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730140529; x=1730745329;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wF7rFSZwpkrhJ/3IUc5qJkA4CHR7vXwnPrWxE1l4Tbo=;
        b=sp6V/bQPOM5SxPZAk/Mm3/ac80FnfdLnw2aF5TKYPsToRp14mHbAn+eJmxCt2guGII
         99OFQQRxCoUwdE2K7TkuSRs3XTDWUF17Xm990B0EX22r0lq4Ws+oxZJeNyfb1Ohnvil1
         O7qicb5OQ9wjBOBJuBR5fMSjceqbv+Zw75IfnF+ni3BwtYNeABpXsr0suiGvM69oN1YQ
         LLEP4OA0Yr+GUW6JS1ZeDy0mnyoapCQJAcL2zxegyxWAtmsRpWEbzgcmYbRhM1awXjRK
         ZJ6lFvnXI1/fBaNaCZHRKztrVAHWeHU1PQqf7kLwTo06YRxBaunTnUm662G17Vm8zltq
         iajg==
X-Gm-Message-State: AOJu0YwXlnxWY7NcBN23e/LZIr+2XHURtsXXGw5YF4Z+1H+CnyRKpGFN
	A0DGnUwkxLWRdygiDooi67+h2VN51/eTYD2m4DDWumk+YOkEDyk=
X-Google-Smtp-Source: AGHT+IFrF8O/vgnRf0qXwQYhmQQg+RuS042PM83nWHPdpH4prvOhTJm8gB5BidzVpegSXMZX+Y7NPA==
X-Received: by 2002:a05:600c:314a:b0:42f:8287:c24d with SMTP id 5b1f17b1804b1-4319acadbbemr85321105e9.21.1730140529141;
        Mon, 28 Oct 2024 11:35:29 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace6d.dip0.t-ipconnect.de. [91.42.206.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4318b56eda3sm148736815e9.31.2024.10.28.11.35.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 11:35:28 -0700 (PDT)
Message-ID: <d5a2e80f-0482-43d0-b5a6-db3a69673060@googlemail.com>
Date: Mon, 28 Oct 2024 19:35:27 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/137] 6.1.115-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241028062258.708872330@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.10.2024 um 07:23 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.115 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
