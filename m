Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793230244;
	b=FkqKjwcFcQnbbYCBD7jt+1WyIDgOsw50QvZyXac58nn+9OMhoDOrSSI/VMuNsa0nf8cZ
	 HQWsKjjvHCzZAt2xYTbQYFmXfvKAWcIyVwk2a6fu6Ud4zJxCLsP5fK64SFOBlPjNaFinn
	 qG9buCpedqfeADnSTyWTrJ773CgqYFaTm0rL+B51OFO+GKEdaWkkPnUFqXrO9MJ7cyBu3
	 Ajrfb+q08SbSkEQjzpYmwMdqIGbeHG7ckHlL/ej3ZTRbcdgRfoCMsxdvDRQowYOsatvFo
	 F+SFz5e2aY5aZkTcRFL6D2a/5iTqV3dolTtIyiqE7KoqI+cgBrDl7U5OjUEkdnqxatA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793230244;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=R9k+w7oblnXJNcegGF9hKmQI/r1FxkDOTnMI2L0ySfE=;
	b=XPn6aFWash4NKf7SGhlLxLPrtW11r9j29PM+OLXZm7MlDeFx+ZbAV/gM6CX8BXraBNPZ
	 PfNzHCCf/RVmNc8wM+ep4sMal5Hca7rQI40GGBrEnoUOb+JeFdt/J3Tst+0iregAiuxv7
	 HVqXOAeVnGBEwbAXpGSOSJ30pnhhBEF7FzzG6kymyM/v4v0/aiR93DppiWJnREZOGJpYh
	 X5z1uCZjM0gMZltHXBF/ICf815rKGxpeJq5Lly+VTESNNXxUOU8U7Dq2LOt8y+QWyWavr
	 qFRp0jx7TXd6VEZwdzhpFNlfBL3SfwTzNZXQndsZafLRhTpPAfd7qhSv1fA9wbfqNWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J1Bly2Ho;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B39C606A31A
	for <patches@lists.linux.dev>; Wed, 28 Oct 2026 23:30:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B39C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J1Bly2Ho
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3adf5f6833cso940064a91.0
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 16:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793230242; x=1793835042; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R9k+w7oblnXJNcegGF9hKmQI/r1FxkDOTnMI2L0ySfE=;
        b=J1Bly2Hoqpy7VOh2ZR4jwTLJy1ZZ0x5Fe83Lb6OZjz69UWfWj3MxDR240X2gC2hjz3
         dOoXuJNL4nED7q051/XU3SYreoDfaxPlOkJBAH8vUoGl7D5bPcI8FOlMg/Hp0Kv/F0FH
         HK10IPjC5WiFsAjjvJZ0MadSgIKjYZ5suYGbX9PC855EMnFnVYt40p6Oyiv4G896IiLr
         B+NYbO0e/cWQt5T3Y4A8G0ZooB6Qg++iImIY96IimI/SPuwGx8zy+YPuhY1cNTSyCXzc
         QyVys3zxuz21k96Q3FrAiTO9q3Mhm/3zY7aQY/Kr1f4ydEj55SHbEyBvFvvn83JIW8NA
         3qmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793230242; x=1793835042;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R9k+w7oblnXJNcegGF9hKmQI/r1FxkDOTnMI2L0ySfE=;
        b=PhgmVytmYri3ReqbpV++s2Me6Y52QZQoxZvJw6UO1yymrwfpMCUd4OT3JORnYhRq82
         rk+kq82NF2lFhiAMagUMrhXN44jsn9BC8k7rzUzZePk/5tE+LLCUAGHSasklnEW0XTCo
         1K0KTAa0fDefQq27iqvGL53iVbh8xwHLoBZvcOvTlBPYFjjdYnb8DoP8yZbCgo9HDXY2
         fIbrPZx+Rektr8PSN93RgyOcKDDbYhXW/WgrYQsmDD1XsJxzXT0yWdVO6BoWrSyqhx1z
         wPX62gECsdJVydbnWm/86Hpv/uczNUBpjPy/9YTo3G6WpDrFq9CkF7n+7RUBH2wHcFQt
         GmUw==
X-Gm-Message-State: AFq9FYL0Dt/jD1q1ADHvF+O3t2r4gNS9kwse5lPO0YbUhuSuhy8H6Tmb
	74joxwHQXMqqVOwbUyccPCykgq+G+XtjsNLLHkzxNbGRM+pVq05frbpC
X-Gm-Gg: AYBFou2hTnO3Y3HCExd+iTDiMc24Qz1TxFSV70ldSzcXXkTiKzTpTTiIiIUEA4TfGD6
	Psyc6uqQFxcya6Oizs0tzOno8Gc03H4N2d3FKU/dotd9eXzOb/31K8ZQBGZ3qKTqxpK++SgIYkL
	mR/wsBVpj5i3wgpYBblV0TlSigZbgoesOgjp64HactOy41rELBvRMDQHVbRXEii3toi+Af7X/Kk
	+CqL39eQITSb/OUYJo1NEp1Eh9TK2VPn4+t90bXEZTVRPxf0O58sT6vkwImqEc2XPVLO43WXrsW
	6KeyrfJcPRhGbBkkQb260TNKrChpeKBfzFut6wkvg+oH9ebY9B/6Jy1EVvxp+p6HaF7v4+HPsTC
	qaoTZ6aDV4HkiF5o+0UoYG+NS2sHZMEOm5fcLz7VhPtIqpt8D8HOQpjOLgjOGvOdTDkVeFC+OyM
	Qf8UQHcZc5gqfTu1B3FCRKndLPYVIAsoYcAeCYe4qTnOxHaFEq9BoAoM68nm76QMsAuHFpgnt2M
	LuU3uroEMqNv/31AizENrEi2epkO+1m59rbPl+oqe4+xV4d8Df2l9Sx5tENQbToncFOUGx4+7rP
	1/mGm6dWyA5W6awICHXkExbVWjur5WyTOnn6gK/IVpTzC04ciSDFv6Ng8A==
X-Received: by 2002:a17:90b:4cd2:b0:3ab:884b:659e with SMTP id 98e67ed59e1d1-3ae57f96d53mr2559235a91.9.1793230242204;
        Wed, 28 Oct 2026 16:30:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e7ac44asm1305555a91.2.2026.10.28.16.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 16:30:40 -0700 (PDT)
Message-ID: <2c58625f-954f-41db-aacc-5340ee06d368@gmail.com>
Date: Wed, 28 Oct 2026 16:30:39 -0700
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
Subject: Re: [PATCH 6.12 000/247] 6.12.115-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261028165947.349197979@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 09:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.115 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.115-rc1.gz
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
