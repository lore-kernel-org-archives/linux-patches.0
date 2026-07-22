Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A101E227BB5
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 18:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745024; cv=none; b=he6lCd9qgGdfIpPI0IaMoPfIhduuTLqVf9YWId1SILa1MWNE4Xam41SNvrmEHhABzp247iXKG5AQWQQS3zLpbY7vsieZRnoguKvEKY4TAIplWLw+pQaDoei2GnNqiZIilc3+gqzzhllmafFzAN57gb6yLCjDXwpQr34Z09D7Rmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745024; c=relaxed/simple;
	bh=SNbj1L7zspeERKld3e2aumW9RaaJXnAzRlBpe9KgbyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ihdrBZq6f5RaCr1Mx46frpR7bObPHCrCraVJSNGCytGNe5XYRBXEU2IiN3VS0SG3wFxORJd+e12gLegB/zXlBnvEReO/KIk7l+8zAby4HsQS8aARcjGvLa2a1GorGGQadxGnwCQfZNUO7meqnhmHV19ARVmmGSm1xsaqDYkszzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jzIeq2m3; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jzIeq2m3"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c9aea40d799so4751285a12.0
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 11:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784745021; x=1785349821; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dRAeYjG5pyuBOUD0fjaGle6ROYAFcpaXD0DXyUg1s9w=;
        b=jzIeq2m316VWs0Kd9nfBAi2ftV6nPOTTJHHb7c6ppove5hObfIemhrxSWQFrZxVAsC
         lzZgps4jNWGSWBwF/ss3s0uWNGuLugo0LSnu3+/w+LZiTsdyrV7zN6DqKegjjjcp48T4
         +wRIzo2OQGMfW9N5xAKor9PwKWRJizndIzwm8UoOVqfsapb2LcEsyW4V48i0PmpppzY3
         Bdz/XgeQwIXgibzdlq0YJPW2Bwf6xrbZI7BYJqHyX14cTCvWnYngFjlmt6t3oHCeF8C4
         gpvYtM7gWe9ni38+VZQOOMwzJErM21NpROwcBtsP/BHEt5pfpYQu6a4lZkrQnmrCh1rF
         Jvlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784745021; x=1785349821;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dRAeYjG5pyuBOUD0fjaGle6ROYAFcpaXD0DXyUg1s9w=;
        b=UgzngMammXEkLYoavZItyqHBn8UXzLNxRxVNbTgP1e8BVECTICG04iOO69k/z/6oz3
         AMJ5ItPwlqB2lMYZZNn06yDbhrIfbcZWOOKVQhg2vqNreM59vWighEt5fEr3bxyvxZU2
         WOA5CTxqOSiumhuD+JF+KG2DaoWIwq++Ehcqt9Lwpu04zdvMGhog81xULQcXIiT3h5hc
         3PRGjVXhsor+7nabUeu3G8EckaRn1eraQlMAFeQgsTxIHYj+gRQxnK7SAv7sZROlYE7z
         lMpAReCtksDLjw9qTFJ3RFWBc5ZQTBKBMS/3h50rQe2VOwfkITFnNsJacDTtMpwz/I+J
         CL0w==
X-Gm-Message-State: AOJu0YzvTNqyqFJbgCUVAT2dnuRC+AEEmCIjTqd8XLBQcEIaME80sMER
	IMGgolFcHSxT0eXLUYkT2aq2h9jjlr/3fICUadz/8yemd0f+uqo3leZ6
X-Gm-Gg: AR+sD13WyJGRyWrED0dI//mrESYar9ti4lkBfIOs1OS614atQrYlH7y3XkA8Iz5NreG
	4XqxV0WucAcGHTZGEBZw1vYNVcVoYUiZNX1bmWJ8am3Od9ywHGSEML4CuLzVMX1DEfensR+aLRE
	cw2VmkAkajB2WNFYRjSvDHAENXVhC/TkixwOwwMT7Z7fkv5XXAt/4F8cj1/DQJqUTQNpHUuso3X
	UO4xlC9wr/NC2k0+YLUyKBqHIXw3P+Jwa5gu9DXEL6mbLC5zyfsKdwGjmoeWEmh8/3MsmXKG8G0
	exyCNiNz4Slh6pp1PqdSDtozvX4IVJJD8R+5lHFHRJpf5CLP6pC12VsDEtcGJlyPDrXkj8Sh2xs
	jcnztWCbwYssCOgsWmY4/Go/y9olA09OkCfPFFUPQPySOAXY8UVCfuhIUQKrSeaQYLbGLTfNjDO
	rBYhgWomnaJeuO0/17pWYL9sW+1QwgEHW+MNsdsIo=
X-Received: by 2002:a05:6300:228a:b0:3bf:6c07:b2f0 with SMTP id adf61e73a8af0-3c3ad9de8c2mr27016117637.51.1784745020892;
        Wed, 22 Jul 2026 11:30:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147df06864sm11471328eec.15.2026.07.22.11.30.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 11:30:20 -0700 (PDT)
Message-ID: <f9b57af9-ddeb-4a6e-add9-314d08aaeea2@gmail.com>
Date: Wed, 22 Jul 2026 11:30:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260722143258.264584003@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260722143258.264584003@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/26 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.145 release.
> There are 1226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:31:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.145-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
