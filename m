Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8041607B7
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 20:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722459129; cv=none; b=iIEkMZDanTSLKh7wHBcP7nBMOdaw1bvzKtNlJdUlmKv+gvY2WYxhpvgS/HBsVX3hN5phYzhzc2Ek6Lbqp1IA4WalRTKuBa6q9My6OeA0mAekG7VbaiiHHDNUUvEn7lZzl4OlmaKVj7bEkeq9ChwhOP5bodofFQiyCYioKVc+LW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722459129; c=relaxed/simple;
	bh=A3gD26s2NXmBTV7HKjEy2yFxyKX1FyIBM/cldbA5FmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UIQaTZtn/2Sx5s1kS9vpfL2tsZA+eLapoZAqea8sZRy58ziYzQrCrhs5EV6s/05Qd9yNOsIc3yRW/RrnQCyqlpoXZ9L4GGJBA2FEi+eyVFw6La6qH+wtamRCI56Q6CQN69dre/cpwGFxhNCSP6LTuznWMMbnGGsfQrqRpY5nG/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h3cl3hm0; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h3cl3hm0"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70eec5f2401so3609739b3a.3
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 13:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722459127; x=1723063927; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U6QQny8V99NEEFnUaCvV6kdfdKgC29wv2xf+A0AoKFo=;
        b=h3cl3hm0qy6EE6LRwtWLKqnpzQyV3z+FykRbY3Cx1XnxWVg9FJlPQ0jl2gDWszS/72
         WAY5W7vrOT5PuK9GVojOl9pr3woYSoNqZWZufkigeBVbbku7IZCCxXsIu+hWLkCeNkSy
         +BT1J9+selOXOllmaxPLRFqwyR3zNuAcRa3fmYFXILkIe5lldlXz9ZxzPz7yPZpcfXwo
         GVuUz7lXukfl/dLduSYCmPvvi8t5jO+Vqn75p1M7DzzDAifP1fvDhKXKgNh/3KDmZfCh
         5vpP5xahSuM4X2W4+V6LNCMofH+hL03VmCqQC/J1D7dgDMI6CXPTgO8yBzzZcFBjHaaF
         Jd7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722459127; x=1723063927;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U6QQny8V99NEEFnUaCvV6kdfdKgC29wv2xf+A0AoKFo=;
        b=HiELJgXImgJ1U1nKXkGGIf0iefaKRioSWquEv/7/OvRzfcuytQ9iHghVtZ8YSs6L9+
         7PKD/QEkN86SkW7/mn6qmp4Z9sS02+0ejYn3duP2UZJCq0H6HF78orUbsZRgvlfdJKFe
         Rdz5id3sBnHlhedxQbwt17ppXSzalyDgjfGzmIjlyzt3ByJ3rtHH/p52s7ClezYNe+jV
         AfbhHw9YZ1OiP9Ve1+k97Jot4MHYm5LKDXod5JeW3qgA3ZXaaOlx4tLQ51PAHTGqPKWS
         CxypvTfG8X7/vkeNG2VfQOezuQp0fA5Dhcybg79xE5nzUg+4oOfh12ikcXtq2k6sVClO
         9zbA==
X-Gm-Message-State: AOJu0YwaTmjYW5pkFy4LR8WKwYAYu45cZcyxSdF8qSeRtHVp9io/Bigt
	sCrXYwZ9+JvDEz1eTasq+TEd6YqBDk1RkRtLBvWjWIyLYjsUnkJI
X-Google-Smtp-Source: AGHT+IF/AdlMshgvwClMC4XzkNwAlcVLrF+f40BgcsD7rL87BunoA/t/Zf5eqnC1uXAmRDYXBgqaOA==
X-Received: by 2002:a05:6a20:72ab:b0:1be:c6f8:c530 with SMTP id adf61e73a8af0-1c68cf2cefemr933547637.26.1722459127285;
        Wed, 31 Jul 2024 13:52:07 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-70ead8a3a91sm10373946b3a.195.2024.07.31.13.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 13:52:06 -0700 (PDT)
Message-ID: <e2cc38ce-62fd-43d0-87f8-74002c90ef41@gmail.com>
Date: Wed, 31 Jul 2024 13:52:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240731100057.990016666@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240731100057.990016666@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/24 03:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.103 release.
> There are 440 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Aug 2024 09:59:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.103-rc3.gz
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

