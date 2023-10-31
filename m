Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583DA1DFCD
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 23:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SbEt/yq1"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-66d0760cd20so2999466d6.0
        for <patches@lists.linux.dev>; Tue, 31 Oct 2023 16:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698794171; x=1699398971; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=atmiYi00WMCyp7aFMPt4w9sGV6FatXJOBSSrDMaqG7s=;
        b=SbEt/yq1gpgmU2uxDM+VO2WFNemhQ1xaGuJtwrcm5jNZlsa8udHLsmGp2xEANX9H0h
         pJlMBhzJTqoTTOUXFlG5GAHidNBECHzfc1TaVhXq9TgF14eEA84u/DY6r4O1CI1uliTC
         3RYzZgvLc3mBvYOm+s2GacpLFSPuSAFjZImyx9huYitGRpvDiXRfXyyblDvqDIqXAT7F
         dGIuKVCTYnKVjBgnYC7rc3hxJwpKrBcmzo7rxfF+VbagH8qkU7G4eLxDCw/afGWBwF0Q
         ECdnjDnZSsju2PZyBo4i0ThF1kDDANrmg9QiHHyU+2PRG4nZSDl2dMw1cY+A1hy/lRPF
         EG7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698794171; x=1699398971;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=atmiYi00WMCyp7aFMPt4w9sGV6FatXJOBSSrDMaqG7s=;
        b=GYKbfJ/qLiSdNwazNPfUC1t4I5WkAtOFrqG0jwOzgVheE1bohMry4AD9ViRV6kNqr6
         ALymNvDWjoq6LEXA9csR5yzaAKz8naDq+gHnU7VDsIrvXOA231JwliyKQth89ZI7hbHE
         pXIbBg+FpbQ3byWbiPJ+Z7anfobTIoswy9GqTiDI9x2QQ9nMcSErYUFlNWJGSYfFbsgb
         Cj7xP+ArSb6r0Qh3e8N9klByNvIBVW4yn6qH0iJtWrTXdUgkxFYkznNrfTAkayJnIkLy
         bmwoV0hYCWbNDgp+2htbX11/Cna4CFcn9ZqBiPQv4bEjEJYrjRLyliKNbnRxJ4OF8MrC
         d9CQ==
X-Gm-Message-State: AOJu0Yw6DE5ORrIYBhjSxkjJu9pbvpkde3dmMuttYopSofSjbkH1yAHj
	t8uei5hCb45nAAziKhCLnBE=
X-Google-Smtp-Source: AGHT+IHzClK0Yy/DDg5jbTwk9MzhOqMDsSgvTkzwRWZOi4OOOoM6R+CxLmO15DBkYC+qiQUZ27zW4w==
X-Received: by 2002:a05:6214:321:b0:671:560f:3306 with SMTP id j1-20020a056214032100b00671560f3306mr5041211qvu.4.1698794171063;
        Tue, 31 Oct 2023 16:16:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id dc6-20020a05620a520600b00767b0c35c15sm912709qkb.91.2023.10.31.16.16.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 16:16:10 -0700 (PDT)
Message-ID: <2cc5b202-f024-4fa1-a2d1-577fe463d633@gmail.com>
Date: Tue, 31 Oct 2023 16:16:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/86] 6.1.61-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231031165918.608547597@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/23 10:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.61 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Nov 2023 16:59:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.61-rc1.gz
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

