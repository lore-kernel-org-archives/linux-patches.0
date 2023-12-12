Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED91073171
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 17:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IJ57d/ja"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d319a7a35bso21635955ad.1
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 09:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702403270; x=1703008070; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uyRFYn/2E3bBEASN5RSINhi7V604PFIKYA1eHnIvDBQ=;
        b=IJ57d/jaIfqNu5KyUHoIpETnOAdAINIPBSVMdURMrwxNPoVfufUcCYUor1OUCy2VmQ
         +ZbcdkHQRQvI3wi0pjQt/akn0IPr2cE9uWGsCsR5HESEa/VYXuG5zbAPoBCYKdT+YW2m
         skwZUz3wfwItsrlAxBEKsLDlY1TiuFyqonJsmYYHuryR1zmLrc/oe1mlLxbPXXMHPgXl
         4oOioDAY9fnthnoX9j2Ui4ZRB0JToC9MN9asAjtjyi+h7F0ZriQFJgtFIoAoN3PpcwhY
         OQoGLYkeaVlG44VEp+pIRRipLl8BkvMa1SMODZv1YbBGjKYeFHp0AH4e3NQssUr2hl6C
         ipZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702403270; x=1703008070;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uyRFYn/2E3bBEASN5RSINhi7V604PFIKYA1eHnIvDBQ=;
        b=w8YetS8UI4xmTFQNnlcA03S43kv+FqyDmSeEyiuWf4MiICbZyvfQ+dP6ML/DdHaTFr
         qVFAgbA1aHLK7AD44DY8WZTSqqju4BGMDhJkHIdRCN5ANzpwaK+1KmvYYPjENPclUzuk
         azMZTqPH48vbqbn8KBJG9lDGk/Owno+xVaFDciXqDWT3aVATeDcjWbKI3tqA8ZvfMDtR
         t7WBQSAlloomfcmkp/hrCUjo4e0gS0qzMcbzl4shVYooWxr5WImEbRrcFkuO0soroBeS
         wl2U3J1KUkVblX2Pl+psYNCnVJ0aeTpasuOsBmz3OOhm88mCNLbG1gwF281UsHZfhiYJ
         v3nA==
X-Gm-Message-State: AOJu0Yx2j+rEEKhBNMqH9PQHgQjL4DGd/kGSG9r1+6MtZr3ikU0k51VE
	t0+ReEGg0sgZyhGkSSfowps=
X-Google-Smtp-Source: AGHT+IGmnTAI20jP+s0/IaukLJr8Qhfet/RF5DkK9h1IsC8L8kkioQiHzhGMiqZw4lxucT59b+eQPA==
X-Received: by 2002:a17:903:11c5:b0:1d0:6ffd:9e21 with SMTP id q5-20020a17090311c500b001d06ffd9e21mr7008997plh.115.1702403270014;
        Tue, 12 Dec 2023 09:47:50 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p17-20020a170903249100b001cfde4c84bcsm8905985plw.141.2023.12.12.09.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 09:47:49 -0800 (PST)
Message-ID: <37a418c9-06ee-4bf4-a26d-b7ac3cd2d666@gmail.com>
Date: Tue, 12 Dec 2023 09:47:43 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/139] 5.15.143-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231212120210.556388977@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231212120210.556388977@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/23 04:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.143 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Dec 2023 12:01:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.143-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

