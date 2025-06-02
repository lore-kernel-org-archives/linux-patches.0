Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1892413BC35
	for <patches@lists.linux.dev>; Mon,  2 Jun 2025 17:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748886144; cv=none; b=jQaVDn1WRIK30BHIyGtEbDGHnUxY7wq7OcrgUuDoPXegk3R2lvXbL9SiVuZ7zfNimjfwT/KCVGEwzEq0i+YZmfQyav6/326BrkRqEtTqQG4h/ZKkwfdnJtCnYFYwcLSx5eec5w3fDiClOAiHK6jP3H58mmJg0M+buZ9qigR+paY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748886144; c=relaxed/simple;
	bh=U7CAb8BnAtTJFCli7APtV6H+DEmqqsPJrtdC7ZKPIKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JEexje9jUjcfJBkpX80H2l+JrlaMHToZeDUJE/SKF3iN4BKiZdRf8oQncqf02ItcjGy0vINbz9/RpWADWuk8PixJHly6DagfPujnagls5l57FAhZSawKcQtf+EUnNvhs2IqgzLUJbN0GtDTysdbniIezrVGcXf3oWEU/mOY+VXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JJkzumYK; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JJkzumYK"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7425bd5a83aso3555290b3a.0
        for <patches@lists.linux.dev>; Mon, 02 Jun 2025 10:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748886142; x=1749490942; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=l/N8ZuvbAgzSK+DMiDG8OUbVN0w+Ue+YmvcUiQqN7lA=;
        b=JJkzumYKp5xphmqa0J0eiRx9ez7sFc9xAkeUWmy37JbzpsEKOU0H7Mf6Lmf+H/QQja
         D+F6CbMIFS8dAC7KGWN7GmSf+7fQiFkXlF31qVkzN6oKqxbtgT2r994V7Cv++GfITkKp
         E8rIDJQuYGYjJ+X3IVNH+0NufNyLI13OvsrCKdSKIInmsP+EYY8A8gebta9hCHVFQO6S
         wKcnSy5WYznUEgX06jVvAgP0bBLua3huOYIyv+LiNqoyNcITSDZJzSlvfZd4Gg0bPrzF
         RfXI9ALJr5TnNPz1RT/Ao/ePSWRmeszurKtlRLaTV1kRk/G8eZPLc0lS20BUcCsEnka8
         JbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748886142; x=1749490942;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l/N8ZuvbAgzSK+DMiDG8OUbVN0w+Ue+YmvcUiQqN7lA=;
        b=SS4R2tQND8AxqebGGgAJJlA83ctfFUpS8WGqKn9VaENwiVEE6ecu+HnJyy+WgBkf13
         61Ybc+RhRSTgjaGQVPoj0MucGgrGxr5NX13TkUK0DrDpu5Cn7oNikOnmfnVv1ZJ42JIq
         y/LZ6zQYGpCxozR+YhwDmrr2KPhj1zA5I7c28D7QFEHKv1rIiKC54UVn1xRyATsRnaqQ
         wuT+eIA9derRKaaLaRjd5eRB6J8T9FO1SE6I7xSVxRrmQNJMPYQRNy3Zbs+H2lDBRuUp
         JW0KLghjDxblaI+vSKXV+VYhCUT6Gyf2r+hTMClhRdn+4jDksBfaQpceNSOZJMfzn/8i
         15sw==
X-Gm-Message-State: AOJu0YySqXSbDAIfjLZXRpayuY8iEYkByc2PKRvvJaDmBpvsrYXdATE7
	utHQ92Ae8KnM3LYIhj9bh4obG2C+7uuagA6gB7Q4CIzh2uPDRq4jyCzY
X-Gm-Gg: ASbGncscUBNX7gIzeKjGpp4Vxv1KvXa9Emyi1d94bzHWFYdwP+O9juxpGlCzc/Hyg/k
	VBEIbN/C4bz3ndoSGfejqrGOAvVrdI60qDuJ7ajVvwCc1M+JekAAhK7zTKKzW9zMCcUL+eni9/1
	jnIa+jfFuPRLtAVj4R80CGUMYxwTZL+wovGxpJww9vqDiv3hW0aKzYmGfG4iMH9GsJ1pG1+/Drs
	L1mKFsSdIcq+S/ozrpv4rqpgQA/McpiT67wcdUEZ1+UxdZRKXTOg7Bf6X5BylzxyHRpiPCKk+WO
	9qW5ar6pkKsfvb85Yza5rfgwByRcrDrlIqwpCHKMvp/dLFVSKRR0tRt0r1yY0Py9zsOcEzOuaJQ
	WoNxCzWqalJeL1atUxkLJXsAq
X-Google-Smtp-Source: AGHT+IEQWDi4+hbXVMyn9KwRlZNfzc6/xaqK0KRvAu1NW5sDJHhXGRjAq2vxR+Fr0ZCfivfFEqMBpg==
X-Received: by 2002:a05:6a00:10c8:b0:742:ae7e:7da8 with SMTP id d2e1a72fcca58-747d1831959mr13852223b3a.8.1748886142304;
        Mon, 02 Jun 2025 10:42:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-747affd441asm7927087b3a.153.2025.06.02.10.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 10:42:21 -0700 (PDT)
Message-ID: <8f790a6c-bbd0-4f6d-8c13-3bce2b050fee@gmail.com>
Date: Mon, 2 Jun 2025 10:42:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134238.271281478@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 06:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.32 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.32-rc1.gz
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
