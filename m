Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9945163C0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 20:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XUCMFC+u"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7788f727dd7so230591185a.1
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 13:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698092795; x=1698697595; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0oKSEdBXUqRCSV7Bxm6sRKTF2Sn9JAV4Bp7UbQh4XsQ=;
        b=XUCMFC+uKR1sCO+bboVUTZ+azu7CWKrI/zk9AuXn5dkIDk+3DTUwMz08EMtXZni39Q
         qXaO7wwDoEiCZBWzjEV2x+iiqZMX/teR2n/3vPisSAHNAiqT6ACugtd+6wtnD5eMIuhn
         Ke7L/t9zTNn5Musv5MOSEpI1no1iVoHuAe7T8dsxzA9yJk3j0qHLP61V72HN1QQyWEJG
         ffBupovPDTKl6hIzzNdJ4QvS//DewOGw5rPQ1S63u74nMdzPF/nZpb19WpOpvreKBYdR
         fgnEDXs178UMHMgDrfVxRNpKzeEhb16gHDn+qYYh5asHVwrsckzHYA1cwRn7Rx8JMsU2
         UUSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698092795; x=1698697595;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0oKSEdBXUqRCSV7Bxm6sRKTF2Sn9JAV4Bp7UbQh4XsQ=;
        b=ljOAxMOz7LvFPCuAgVgvKDRwf4czQhGoMS9ZCPF4kwVD5Jk2ZrCQMRM1cST6LgFx4N
         Aa4IBZ8xf8UAi44nhte++k7evvkEJikpaoc7vDmUTGjsK7ti+6LBeixBJYn3S4O55831
         9maSHaZS2wH6eEdpKpCbnrDngAdjKIiYUOlsegdEkkziX84xHbfOBfhfeJ/rF3RkQBIs
         W+UX2u/Hph/r3aZMSIQeAfTpJBW9moSB7l8YN6jMbPm2f7lTYJMr1+n6Er2g2bQmOm5t
         KAPbWzOPDMuKOiSfs6lUHhz862pOmwF6PAmz3QpoKU7QQwdpH488/rqqKL87v9KvH8SH
         4N5w==
X-Gm-Message-State: AOJu0YzpENhO8mnTl6tgZWQag5tb8VKw1XbQPv1Ge2C0pFtylgU9fkB/
	rlwRNCZHyPDLmwO0wI+7LGY=
X-Google-Smtp-Source: AGHT+IEsjf5/mz0myw7K9E10LXvqraHROlIr2wrSuiRDCCP+eXRLueK1ieTQ76Bhs+alj45uShMm/Q==
X-Received: by 2002:a05:620a:1009:b0:778:9836:3ddb with SMTP id z9-20020a05620a100900b0077898363ddbmr10144992qkj.34.1698092795350;
        Mon, 23 Oct 2023 13:26:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i7-20020a05620a0a0700b00767d572d651sm2963285qka.87.2023.10.23.13.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 13:26:34 -0700 (PDT)
Message-ID: <83337b9c-35c1-4a90-a822-3b320ae8afa6@gmail.com>
Date: Mon, 23 Oct 2023 13:26:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/137] 5.15.137-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231023104820.849461819@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/23 03:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.137 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.137-rc1.gz
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

