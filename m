Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FCA4A987
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 18:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KqIz1sUk"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-58e28e0461bso2164798eaf.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 10:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701801977; x=1702406777; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ztbwKI6Jcpyra/1f/euXfg6neSljT4kiu1G9pFbPYo=;
        b=KqIz1sUkOkulhx0UEFc9qz+9w3PlpljvuivENPmoIMrMwVVBiPmuAkuSlufVztnLWV
         DsAgVPSxwD35WMPSgCVlCipGkkGeVaRpp/Dgs9EbEluIERkRsXx7dnoGFNF9Z0KCD9+g
         FiUDAyhTR/dg4qyPyd09HaPYwTm9gNZUzkQj1S4ASoQeQ8rsC1LE43QpLYrwKzgB5IJD
         p/WD3+4wH68C57H933/KrsOE9qG2NCrEU72f4kJ0MsS8BcqxNOq2s4Soqnju35RY0INn
         HVw/tKXOQpVk8wrRjs02OQ1KFcLcILIGLGk4bxncmWfsH+sGZ5iyC7y4vkhBms5qE3Kq
         ZUZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701801977; x=1702406777;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ztbwKI6Jcpyra/1f/euXfg6neSljT4kiu1G9pFbPYo=;
        b=GfYbQb6ea9oTPM0ts7o8UbH4CNpmx83ah58y9puST+E3g6VKb6DADCXnI0N0y92S3h
         haJ9IqHGLmwEyPVrKlR4NbnhejCBeQBybQJDiX9aZ9oG/XC9XrmcIKqiCtAZ4eqoIyI7
         +Qo0TEhck7xpeWxjaIZNJEG8xQsRztaBGKej2ZUD6Vy0YqYAw+kaYykT6P48GKLkn6PA
         wDLNfyqJaOiFYz747VyfN8EbZSUb/9HrWZ/9VAuCWWgOP+vi7BMvwQx2xdLkH2k9yv3T
         b2EsDqhD0RlujYCBvYRzQ0I3gUEf8v/mlqdt725YEBwOzc4oQY7i6OOmRDqeXpqEEnSv
         LZoQ==
X-Gm-Message-State: AOJu0Yw7jXnqk1cDNBL5YJXVWic7A+hosdHu6nnOcXLZ+w/T4Jmvog5z
	xnciY0hLCgdfDUjcZ+4TuZ4=
X-Google-Smtp-Source: AGHT+IHNhTyeeUJawENhom0wRXWg11kt1GxkarCQx5XbN515tXLjDYVFoZ+lqxKQAtUfU1aMbrGlig==
X-Received: by 2002:a05:6358:611e:b0:170:17ea:f4e4 with SMTP id 30-20020a056358611e00b0017017eaf4e4mr4940086rws.49.1701801976786;
        Tue, 05 Dec 2023 10:46:16 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z20-20020a637e14000000b005c68da96d7dsm2520922pgc.38.2023.12.05.10.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 10:46:16 -0800 (PST)
Message-ID: <a0218181-6234-44d4-a8b4-fa2dea073943@gmail.com>
Date: Tue, 5 Dec 2023 10:46:14 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/134] 6.6.5-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231205031535.163661217@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/23 19:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.5 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.5-rc1.gz
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

