Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F2D524C4
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 19:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712000050; cv=none; b=CaQi62V4+6j5AL1bjOk5FEyhuv8DK+OrMxZMP9Te36Z6wjkUIHED5/7V1A7KlLskptrBcnlZTwYteVxdo2GVio7Fo0xvQqYQJY3sfu2pYgPGoDvgXqEFyH41kdpGm4g1eO0PSmFW5hq0rwfvREfZejQeglyk+1WUFsVgbYaxljc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712000050; c=relaxed/simple;
	bh=aj0nrVkwljzrKd/TB28KkZj1TBXQPoxF8qMtTI4WX/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WemYsTu1Ckst/K2+a59D4w1WnjtA8sbWM/XdpoCvqLDAOc0rhLKaxiukfzPUWxdTeJ1HdbXNwKBRLftgbmaDuPpFapP1iFkUf55W90QUXsUbTgUbISIXYt7iJVvOvFJIo/tMzRkFdmmLPJt3Q15nWSUyg582QLnwNtlbKZepi+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RYnXtH9K; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RYnXtH9K"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5a4f7a648dbso2852755eaf.3
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 12:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712000048; x=1712604848; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wLDV/ht2C0Yhmxp9JcDfzPNyFlnI0fQ6zYIEoeG3/fc=;
        b=RYnXtH9KFEwmX91noRGnSrguP/ZzaDsZQqEqays4kGvcaXOq8kwax3WJ2eSUwNQxyV
         RFc8Uk0kV0dJ0GtNGq834jre70VuBFPa5wQuySegRNDgzoH4X3Hgs8Y/1BL22LuLWjDX
         BwbuEb/X1BMS5TjjXJCeu80tH263kTGQKyOjOd7Kcxldh/l11hF6tubrMPKGqdq/8+tP
         TBeulmWA3ZMk9RlyTTQaOPb40h+GsQ3oTDpNsPamQDKMs/3E/VMcFbbXqHjr9xspnzp5
         6LgEQ0RQRjeS9Vxb6iTAZEe+9EFFj4ac4Ju8HnHTWtV7zdXUg05FQ+CXXyPXbKPzjCNh
         BHag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712000048; x=1712604848;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wLDV/ht2C0Yhmxp9JcDfzPNyFlnI0fQ6zYIEoeG3/fc=;
        b=nr5hYLD2z+q9FFRg3MhOlnrBqKjLqiLiWAv2G/A4zD+xntPoRWxJZjpf5hi/umk5Qp
         QFTYS3pq6HTQSmMTEdAY+t9ehmeXS+eW4BBK+SKwRJSvlV5t3u3ZZsLQC9rzLs7KX2ZE
         3aEtNe0cOUl4mPKFffJ0q5v8WIxASChp1D1glI7H3Ti7at6HMYdPptTZ/eUEsXz3MKQ4
         t3D7gFmYfFiir2XUsH0EMLg9LXEUgWiNuO2FVaxYtQryFNCMLogZ4W3/Xzq52o36w6wa
         sMqPbx9mup9VrinEWWxvWt7J7taY5+ITTZxILRZ5EVCkoWBbWKIzT1EKzTZBFVI7GkL+
         P+EQ==
X-Gm-Message-State: AOJu0YyxXd1PBK1ww03PCkfz7I2WuiuHiDT4Npiv+RAyl6CVmHuxk6ze
	A5tWop6YxQTXvqq19qqo9EC9qDAWt4bRPbFfYBW14hmopExzVYEZ
X-Google-Smtp-Source: AGHT+IE3k8RINM6GcRHexQWUs5+L6aBvMDILTRqjzVJLOriiaxe4APNK3WoZMLuuc7QaH/1VNw01jA==
X-Received: by 2002:a05:6359:4c19:b0:181:65b4:f99c with SMTP id kj25-20020a0563594c1900b0018165b4f99cmr13803416rwc.19.1712000047846;
        Mon, 01 Apr 2024 12:34:07 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t1-20020a63b241000000b005cfc1015befsm8194438pgo.89.2024.04.01.12.34.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 12:34:06 -0700 (PDT)
Message-ID: <9c62616a-2706-44d1-a4a9-08f150f11c7a@gmail.com>
Date: Mon, 1 Apr 2024 12:34:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/272] 6.1.84-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240401152530.237785232@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/24 08:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.84 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.84-rc1.gz
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

