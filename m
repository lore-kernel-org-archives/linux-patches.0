Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FE56FCC1
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 21:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D06CvBVk"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-423ed5fb48eso864181cf.3
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 13:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701812926; x=1702417726; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K7362aGWQn9YaOD7TDTBsEv+KjpS1wXfDy+Pen8Y6TM=;
        b=D06CvBVk01KlcsDQzrV/D7Fm3jnpqf2dILMju+d9f2J7YXqxIuwDGK0Vj+q1hXUR5a
         mCyWaoYtWED54mXz5VhdiahMDUxiZmsJJDkYYooPliWOiNrvQO0QAcbOrgfen2OaqfW5
         7GQk9QsAwLd5BapGj2UQrZrEk+NUbx5WV5Lt2O0Pfl7oac9ojO63ZRPLZuMPp1vUjdMJ
         gFhkDE/3sHKbvDL8FdSmR6boHqaKRQ8ViSCV80QIVJBgK6t49qmpZD/WQbwQx0y/op85
         rnqxXh1/hQjn2MDfwpdlrFfShV3+4O77SmgOhNqj0iWlJXG+LCcjdzuymFmH9aL62w9R
         PTEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701812926; x=1702417726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K7362aGWQn9YaOD7TDTBsEv+KjpS1wXfDy+Pen8Y6TM=;
        b=gBImV8L/JvvbTSWG57uYOsHDoLcA5sOIU+TJrE+XteMtT/R0OnaaJ2KDz6U1j1Yx9V
         07IopRQ7ty3vRz/yvxSi1dboO/Kj+LOJMm5YO99E4bRTQnKkRauxzEwHArpVLqRuAQIZ
         xF91nNoO+C+o4UoYm7GJNVPJnXiCDMoMaPsRabb35m9bFMMi02wZjTSLGbABnALJwsnf
         YUNr0PQbHemAmX+P0NMHvuqSi0EG4eCXbG/NtsnUN9zuviLO3ZDITces14XruOh72uqP
         CZFEsbi/JDorKXGo6cnv9tI7f4tmyO8m5WNefd/kOZVWl04/TpSmzwOA4L1jwxOwzvF4
         8vlA==
X-Gm-Message-State: AOJu0YzHuCJ8BGi0fyQfmI3DmE+GUw/21sfts2wnmtgAYHfzTbnfikcZ
	5N+CUDRkssx76oi+UdUceq4=
X-Google-Smtp-Source: AGHT+IHgqtM436SM+/NJ+YT957+k+SdVt9/DktYuKz5Ig7PZNhFVMMRwYCWRVMDK17LdiR3jtfFaLA==
X-Received: by 2002:a05:622a:287:b0:425:4043:7660 with SMTP id z7-20020a05622a028700b0042540437660mr2024910qtw.136.1701812925823;
        Tue, 05 Dec 2023 13:48:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w3-20020ac86b03000000b003f6ac526568sm5467981qts.39.2023.12.05.13.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 13:48:45 -0800 (PST)
Message-ID: <12cf2948-fe16-477d-bae2-39b5cdac527f@gmail.com>
Date: Tue, 5 Dec 2023 13:48:40 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/90] 5.4.263-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231205183241.636315882@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231205183241.636315882@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/23 11:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.263 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.263-rc3.gz
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

