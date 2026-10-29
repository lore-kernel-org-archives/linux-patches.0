Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291363;
	b=xCtXhDPBpDeKsjHwxg8fJ/VASsSA5EB1szR+1dHfJwtNTVXBJQe2ifoNznYXco/f88hh
	 nPIxUXvej22kUk80nG9PoWvf/J85yTWSzo0IiwTkYKhRyCRRA9rjxSQKhmJeo6S3cjgBa
	 kS9upV1U4lwe1tsX9V9WxMSCPmhR6YN7yqXDudDv5elXuFKJzyBHSDssLLi4o2n3WvHk0
	 6jJjE2/6lOpQo1hePM3QVbJBDNdtyCSIBHUMWEtRLnjAoWG04rwWwt6F/RDiLLlteWgfg
	 NajPpj2BXVLkhzOG92H9sl3oHoeBZREJdMIQx0jqYnSVQt7tmSlReJzJe4pVLxbWWUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291363;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=HO+j6ign2yj4NoqgE38MT77slEhL72UAiKeSfh5MQb8=;
	b=mXU+pWO3dVWhgGzd//PnqgCi9RL55D5Okgr3tfMgdh3nWeQcBuBmsaS3z8bF2e2xdcFM
	 Ym4xoqGcD1VVUwbRPh5uByA/cJ1je6U19s4rj6Bdm4hmK2vVpKCedYoryEK8lIy2wQuKX
	 yYgDz9x4PeOFbBf+9oPsokrwZXGnKx91LKhiGxICfcUt4QT/DELkWOUBrqr54wOnYGBIu
	 CanMQ1b9imhKFu03QlRwmQoYIzOWctc3qzvNvx3BpYx+v4VVcjw7NkboZDuo2tCOVdwda
	 j6kbG/tRFAQjTPIGz/Pvl7f+oK7Tae6YBNQagDx549pI+fi8JV6ati1HpJs7OTImExg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PTsAtNGS;
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE0B606A322
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 16:29:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAE0B606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PTsAtNGS
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cd8ba7c2694so981056a12.1
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 09:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793291362; x=1793896162; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HO+j6ign2yj4NoqgE38MT77slEhL72UAiKeSfh5MQb8=;
        b=PTsAtNGSNPiDpiJRfrAGnAZnHAP/YCC6kZrTKnO3mejNY1cK+0hqNQFIjysLg/My4D
         dBkINKI9XQD0/BzGILGgMwgu9/sTcAszSr/KbrDVHWNHAMPzts1EGGPK95LJR8L4CFJB
         RVG/2vD9ovfA+6XHWiJXZgAn3RIQR55PIeFkjU77WZGaPcQpN3hUvr52LU0FKexwIdob
         Mp3irxGchAChgWmyr6kOGWiNjm+H2upw7HMKHTKMaUdnSpTn+HsS9D3Lnt/lnA7Y3Q+Z
         Knnv2R2HjO152/1wi3YUtqhwORsYjUj8/Z93C1WpeTe0X9zjLDnjcZoq2sL2zX8NK4ER
         1OfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793291362; x=1793896162;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HO+j6ign2yj4NoqgE38MT77slEhL72UAiKeSfh5MQb8=;
        b=y20P61Gj0jTRFAs/YF4RKlVdI8FThkQfY/02U311toBLFvpzLcVKo+jx6xJHfiuK/k
         S9uQwtaLU4zApsKOhgjMySJJ8aOEdyDlsczjfRBg65Wmd9Gm89kJ0KrcmSEXV5iTkwlG
         6rybJmz7BIiXFyEIj11C6lFRhBPDS4WBPCSNQBejvw2rHntcCmdhPFrERrvssk5zUk1W
         CLF0j0Mh1uGzFTE/1a7ESPS3LtEbp8tfNG+P2HF3vVZbCotb+vVOhSehRdcsmlzgxUz4
         jdQEQKHShaIbHGvZUnjmfy1UvhlEvVgvW3pYyV9P2YhPi/gJrwpCyo8UaFM3Pq7UFUAe
         8xpw==
X-Gm-Message-State: AFq9FYIWWX3nT4t9glKaNPIQUmniCDyosAT8ncBwVUj28QwJjTF+xMGd
	lELVt7hNtbdVVBj0nIW0Qhoflr3X4ufHPuW5xZpcgdUvzwOCSJWPNee8
X-Gm-Gg: AYBFou3TgL148JUldzY4sIz7yXD7WvkF/B3A+HcxQmuJtMHZShppso8GSStfkhnDmHN
	bY6v3Yv9cCpxmnA+LmLhPt9xGDuPpEv3bqJksncpYiCKgZJ2YuN5aoLGoKaaQjub/eJkUyL6MCv
	57Yb0IutvkTG+IVbfRE/qARnFoL4Zkt8535sFRLKsMW3fcQqMtHsn32hgA6X95kguUr24zFbgeQ
	PM3tAaGP4Ef4xCVB2L/KQU2Az5dwglTE+dTz98lECY+GLtc5SWhOpm14rjqvOZuauxYqk/RwlXL
	mO1NdEIA9KzJp4iIST4/5844aKGUMVHW7/8Vcj7IjZVBchmAWnxjCM85KQNDcjO4iMEwtfB7k1h
	oldqLzPvKyqE/o0INHCHZik+xfAoPVVvMJxiX9a52M7bsxbR/hxH9k773lD33OyCNBDUgI4UAQ+
	x6Hyx/TSowvuZm+ZBro0BaIe1ClWeXk2Ll2HijxUBNtD3+VYys2XdYUf+WyujB81DWduDYJuLoN
	GF+NgyXC6rNe4XD0yjhSBaJe+J5qqeQB7xHuwTfN4t8e+axjdNCOtev/EYezlm34IHNMLElNZvw
	Dtt69/cDIglECAvnRxtXsDZzrBkYuimhovXwFh7iMmxmkCKwDdJEbimW
X-Received: by 2002:a05:6a21:4c0f:b0:3e2:76f0:ac27 with SMTP id adf61e73a8af0-3e902325a74mr5014369637.40.1793291362131;
        Thu, 29 Oct 2026 09:29:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a989adecadsm114437b3a.41.2026.10.29.09.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 09:29:21 -0700 (PDT)
Message-ID: <56e68cda-6c37-4d4f-b3fd-725cf432feff@gmail.com>
Date: Thu, 29 Oct 2026 09:29:18 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/109] 6.18.60-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261028165942.357251485@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 09:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.60 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.60-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
