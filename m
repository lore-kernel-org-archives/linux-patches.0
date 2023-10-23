Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B9F2135D
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f3rqWELq"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-41b406523fcso25008431cf.2
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698086309; x=1698691109; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wTZl9yJT84xQJpx2WB/28tP/KJ1wcwrESB4z0CgwnUM=;
        b=f3rqWELqlY4c2UhsSUHKVs7uY+q/bDR7LYyhmJ9aLwQtis6yQklZq9TddgBThRTOfG
         K169IoM9ZoKvY0nSA/d3fO/i2vDiAqIGNhOZ/JHMWOf4WxxJwjNbljEdNz6nQzvQzUrn
         sH8ijR+k/klITJMyvY0CoXD//kEQ3u1mWw/oIZp0iGdlobOKKWyYYbFcLLggO3vNOtfX
         TRtIztompfhGI6ZgTJGAtgeHmz/YAhqpFMQ487ccjj3Qjm/4/dFY1ydlee4J5nJ6LqBi
         l79wjnnKNrgWXL9s/gCdBF8L0g2B3zvIfCfmOZGFw3knSjbrz/ezQn8cRhK2sy3jGHjr
         6PYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698086309; x=1698691109;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wTZl9yJT84xQJpx2WB/28tP/KJ1wcwrESB4z0CgwnUM=;
        b=tiq44KjipFYvtdZQqoOgh/TYam5NE/RKVgKfoZBGvVUY5ufqpagNrAkzltbNwEftMZ
         pZg5m12KzqQcX6g82peQcLQAC61bk3X+xm4Tam07jPI8uGRFgYsHbH4x6kjvkSVgyCCq
         2etdqILA8RlW11LlaYGYRnEMDISTE6Qqr/6eBKj+9Dbu0l37vNk1/6jrEcDmWte9KSMw
         U9+pWbPF9S3CpDil91tGlJxoV9HbRbQ3DBFAPVjLQp8JiGi2HsCuiU2aMAT8PLCnhM49
         l3tCvLnofmRCxNl2wxB8tMnsZ1GU9h1/UCR/b2XnHWD4OEvxBmyK44SzAKvnqkqEFqQk
         Gz7Q==
X-Gm-Message-State: AOJu0YzJ4mDi9Zy/wsuOyfJ50mY8OW52z1VlH/Hf3qSv0/jyqXSTEHHk
	w51+7k2qZwfKe3dtkfH2PME=
X-Google-Smtp-Source: AGHT+IHToWlKuJASqgn4O8LRF4ZwPN6hJc83KOFuYbmuwdpGW/SyFk+UKhYVZ/LqyYOZ+CfAbL3l5w==
X-Received: by 2002:a05:622a:189e:b0:41e:23e6:baaf with SMTP id v30-20020a05622a189e00b0041e23e6baafmr1897712qtc.68.1698086309375;
        Mon, 23 Oct 2023 11:38:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g22-20020ac84dd6000000b004166905aa2asm2889080qtw.28.2023.10.23.11.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 11:38:28 -0700 (PDT)
Message-ID: <d2cc0c5e-1f33-4c47-8822-a90b62d7a3be@gmail.com>
Date: Mon, 23 Oct 2023 11:38:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/123] 5.4.259-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231023104817.691299567@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/23 03:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.259 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.259-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

