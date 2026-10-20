Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514576;
	b=1rxcP9v/shT3L0ljauPm/IO68OdKpg4o+q5+fK1swwPYb8ct81afUdCoR23T8QQ18h8M
	 sMfqUo8Vfq9DlsrKM1uQ5BqG0mUzvSpj6WK6Zlt5lM2JZQ4qQ5rNo/boDmLt2zyEfIz+u
	 6M9Rkyu8AgancnzoOG2011seUNAmGwp8YWEPutdM3aTJggsNDGmCbK790+DBaavDFVTFd
	 WIGSmaHT/Li1qPpqAbVCB4V/yGt9+cA5iq7ahz0nhylj0f+MwcTHvWk20L7+kUtcW3J5l
	 DH3so5M4SEiCzNuGbskzZhbqMRMhb+cAiuxskWvO3472TP//WWHFiyz0WBtOZyY1jqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514576;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=+ipB+gpogUeHkQr3iI5OCJjKITatusksUh2DkAn6oNQ=;
	b=1nQIQez8KKJ3O6zzT3fwvHVWjepiso1NsxzWymbFVMUTqgfoo2ATf8jpHOPalRUY2YuZ
	 75a8B60g5GxfQhrCdn4nQnu393+01dNh3ebJKbL1CXPZZJQQUpsSQc9+6JR9Y4Trd4cD0
	 s2vNZuNt8s/YlKGnp+vdGXzNdCuiFcLNmqZYfS/3Uhy50u4PSZBioj8fqHPhijFTKel3F
	 AaBpqSfl6l1u3sUOJnvrdFA/fNZNvPvsigI5TRifiAqnz1WhPGB3QltTlU73ILwGpTeOl
	 BFbBB2Q2whhQxwbED+lN+4IuJh9jaW+O6BZkJa6xnJr7q/s3DKjfNE6krJBNwwOuUNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZZRuXCDm;
	arc=none smtp.remote-ip=209.85.221.182
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F077606A32D
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 16:42:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F077606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZZRuXCDm
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5eae12762c9so330233e0c.1
        for <patches@lists.linux.dev>; Tue, 20 Oct 2026 09:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792514575; x=1793119375; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+ipB+gpogUeHkQr3iI5OCJjKITatusksUh2DkAn6oNQ=;
        b=ZZRuXCDmedShVF7kc2ult+b30nVhGvT3XZmGWjgZzt97XpgL/3ymU1StP0moXi0PDM
         vGrkqbCYGTfcPxYxFOD1/18cz4F0a/MlomIbQTdtRRc9fghcU6oERNqzqRbXnBuX8egq
         3avKv6kZEmrBudA1TyJwZ2FS0J4InPVPc5al5569KQqhAj9dL6FhbABMkGuUQsh9IVb6
         vqzaYO+Vc/4N9wn2YU7FslzMoa9AeC72Pv3lbBQw1HFqT/Ku+oCF1kXNffknEp76cRLM
         ET+6CXVEhxLer88RLYl8glbunZhY+ygb06NIt/YjisXR5ocbX0C6U/ThrmbhLPKBY3uL
         e6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792514575; x=1793119375;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ipB+gpogUeHkQr3iI5OCJjKITatusksUh2DkAn6oNQ=;
        b=UhHjI+2Z8FprP4gtfZIjvzpd87+uc0xzOlCLR8A6jEH8gwd+3ne1ol93gJBS1hdlYg
         zBcoAmX6WK6FZ8M6A8sboxlJ6BdN1le3amWYRIfMRaZOpGXCkl4K7VlOYALGpQHEnJhL
         7542oSJ9VeCqGisLbFG65+MIn5ZKNTQTLKr/oX44blYn2hD4f4ayHIt5EUzisFZ8kMjG
         Io7Q3FGcua5WyzBSb5dohPAQCwFzJdWZxvkTcC4zimkDo1riPFbxQIWbnTkXCv5pSL0z
         YRwvcbtyWzJWbKUGl8qm2dDISv/VZu8qoD66ujX16MQcl+Mxz2zOOi97OY0b8GhB+hMK
         UBdg==
X-Gm-Message-State: AFq9FYJ09Tj44EjPd+KfAXPTbgRhQsfvU/gPlCfdUMvIeaPkIUk/da9x
	/q3SzxrKAs6v5XWjjO2gMXrYyTC4b7Aiw6Iez1k5numxLEj/peZwIDNE
X-Gm-Gg: AYBFou3ZnqzsBHSlp+tHlilSNdjHDpKLD0ZEzhGESqwNp0ZM9bFXBzFDOXO/nW0R/X7
	9JH1f/rAiNLQwQ7l3L3QXYw8qoElVgQHj0Le5/IepioO3C2mRidb+8gzFcZZ05klFM3dJqdEc8w
	H3t1yvVD/M9MfjS/B+rjogMH+xwuOfonQE+d81XT6z9jhu4nAtyiKPjzCQgeVjztNnnMIvcmY2E
	beg21Un5/c0nV3KO1dXsBYFL2L0n4QH2HdVIl+jnuAs5dukBqr9PBXz4rZF3awLxJ4gp+tEk8xE
	37J+O25UXGk+sZYKo8ZOIy7y/NC2s0hRbouNctldMlQ1t0Gr/a0LuEqLL3r7EbI9b2Sz7XNUire
	lHyIUdio8+fqIuh9TuxFk+vj2JNvnZRAIJ8q3zAWTqoTyEf6+ONDIX0NoypLenwFy2ENWwqz33r
	0deNe9+cdPfe9kjBa5neCWMGMzVcUFrkpCrNtS8bcPvhQvlZDabgSyyxa4yQkYdEHzatRXlUZSz
	9u5cYpLtG4hZjXs3Uja6Evp
X-Received: by 2002:a05:6122:3d10:b0:5ea:c51a:37a1 with SMTP id 71dfb90a1353d-5eac51a3aedmr1843253e0c.8.1792514575062;
        Tue, 20 Oct 2026 09:42:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eae97ec3fdsm26291e0c.12.2026.10.20.09.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 09:42:54 -0700 (PDT)
Message-ID: <d053ae85-17c9-4bfb-944c-63e4ec77fc56@gmail.com>
Date: Tue, 20 Oct 2026 09:42:51 -0700
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
Subject: Re: [PATCH 6.12 000/858] 6.12.114-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261020075246.861837975@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261020075246.861837975@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/26 00:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.114 release.
> There are 858 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 Oct 2026 07:51:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.114-rc2.gz
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
