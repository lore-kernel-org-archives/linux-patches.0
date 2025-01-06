Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBC58C1E
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 20:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736195170; cv=none; b=sBIhS8+CNjy6fkJ/uo/Ed4v2ox8I4mrmeEZ6kRwSxvNIBMtw/n6Ov10UarVnLyXy1x0n3J7GlTHfC8peUmb0pGhcaIzvu78+jO0QV5y9SUGXNzwghlSyVqGLbSx07/RR6p8CpberpOs35i1CYfUrrWEbkk4kUzZhcDSevE041NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736195170; c=relaxed/simple;
	bh=Dmkw7h+pwZR7PNRImWJv7IGq90ezHGUewtcDGaWcLiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vdtxw7qblVB7DzlME+y9D460ofI8gudBRUn5OMkFfKslpgqM0T7NKmfGgTDFvZFReq8UDorggT0Glgq3Glc8g3SwfvPO9e1YkSq1VIxALixcFHHgpolwO9uPdRZYr+eEi1O2Fyos5FWrzGO/MH4HVn4W/PgIICfbx/VIy9XdXcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hc6/iWdr; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hc6/iWdr"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2ef70c7efa5so17183499a91.2
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 12:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736195168; x=1736799968; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GrNl0YQyCQOVQbp1qVmX65QgwqOhk6aD8Sj9lELyy+4=;
        b=Hc6/iWdrWlaDYQcrwZiWCs4KADmbPCINWtFSYgmDA+DYviglwFwaFUUIPctPzkSD/I
         Da4mj+tGVChJfIyCDX97ON5d+wmGfz7DF7pjpKkXkZUQ3Q7La1IpAl7flfnI0SUL3Ue/
         gJ0RtXpHD2GF3AoRVH6kyrAobOMmxOjnJrOImaDJWFSMSA71gEVoD0B11t65qXsTcyyU
         VGYdWPwTJ7/U4Je7V5nlrk78+H5Hh5uMwgaWQzS0n93U+6wgOe3yHefJLITHw8jqvSmT
         JoAE0bQurUWgPc6QrtD6u9MxldD6/WYUhN4oGPmDOwTZtGYbjwxO3WHRxnWq1C5oXV5S
         61ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736195168; x=1736799968;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GrNl0YQyCQOVQbp1qVmX65QgwqOhk6aD8Sj9lELyy+4=;
        b=sjYZdf+fNO/gjbGguJHTQ6mkSmc70HhERdIg5IwMdSuO/HUQ3kEsDlMHAtO/ltCegY
         BnBI7WuSlAWZAxnYsFzGsIehBLmP66mdIh7bLY2/Ou8/WrWJrSwDI+yw5CrxQ+cNxWVC
         4vpsH+wMabK27iiACtUSyI6omEmFI/b4u7lcFR0tlpKK8+JrbXSJh/OkPBRGpf3Ws6Oo
         LwdBMRDSR0q8JI/wiRy2m9ZJ74ZawyPd9ZPWfTC/WybcwYm1AGqygUoPnKm4+XK40AqD
         XQMnnTq0eB87CsMtW8xNBlvQIM7RSxRvkB5k9phNE30dXyargWaaGfUEy2dMEPf8IYtD
         uSSA==
X-Gm-Message-State: AOJu0Yxs7z0cSfhBCOh3+goXwT6e7IRwvHWgejlFQOxyANNtBS8px3QV
	By/X+wgtKcm3O9cuiPXRr3ew46ln6W9+99ArKf3a7vC0pRh7boZu
X-Gm-Gg: ASbGncsY9y8cUrpfFdRFB9mQDuK8YJ7uvc5wbbxSoun/hotj8N4LGUi3pY6WF7Zq9Eo
	oWSFhQVWyz9OVwViIMNyynSfvFc3LCyW84IVEf7NX3dPS7SZpQX8cHzqqAZXBBWdUCkQJG1MUT/
	pkHQnT+QK2iorXFccgrbRWcXN8Z4QDuegREIi7KRDO/zK3iTvf/0oCuc0ep9P8xA/9LbYHhsvSn
	l+QQw5jy4N9VfLxsFU5eyUwk2F4unMWUxJkLnDthCl7lZ8BLm08Aj2o6JaQqsLYfuadA36TIqwV
	kWWGBCau
X-Google-Smtp-Source: AGHT+IERgVCR9lanqnApTNc6ho9a3G65/9nbvdrhBX4OSNPtos9CVWLl9qPXcJJuOS4O2ZOqRWtZpA==
X-Received: by 2002:a17:90b:2e10:b0:2ee:fd53:2b03 with SMTP id 98e67ed59e1d1-2f452ec6ec7mr81836991a91.25.1736195168413;
        Mon, 06 Jan 2025 12:26:08 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f53e1d31a0sm16269a91.1.2025.01.06.12.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 12:26:07 -0800 (PST)
Message-ID: <95047ec5-9f40-4b49-b211-42387db6bf28@gmail.com>
Date: Mon, 6 Jan 2025 12:26:06 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250106151141.738050441@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 07:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.9-rc1.gz
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
