Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7A48613C
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 20:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709670007; cv=none; b=BVtX1eeUC/mCoQAqpCLQ7wghhQQQ5EM31/O+CnHuL7g3mz4Mvy+nnfkmXn8ISDqSzMm8UeboqOk2ShRGNcdE7wmcRwKGFTR8SdJbhCeC09vSdSKYorojW5p7MtXkArFFIty/O3QW3IgzpZb8zbN5h3+Nm0pF7zbSuFDWc9vsBQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709670007; c=relaxed/simple;
	bh=2yEo52nUqEosalh8acVmH3pa4TOwG+VL1d7ZfEeFLx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GlicSfwrlOpBQ2/GybprJvwkWCMBXunQoBRUNCG3Ts96kgZxX+NGNFrYSimcTATjPT6FiwGVwd99EqlA1lj4e4O6PZ+mUdRMOkWyDqkjUe4LDllv1wja79sIRQ1d0SzV2VjxUlJX+Wt+LPjpKEuSeXjM0MW69B9j+qZgrsYaENk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U2b1Gps+; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U2b1Gps+"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-68facd7ea4aso1432936d6.0
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 12:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709670005; x=1710274805; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TcL6wAeqVuoZZD/5WSQ4uqaLPsMl9CXzbiG1AkNovjo=;
        b=U2b1Gps+caNtCa3xW9hOZNutqqgVcXMGsFEL95On5HONONVQL1pvLO8SDh9VR/IaXb
         9nUzU09LXPHJvrSKPLFkk2vF0Fgc3r/ZxphjwQuGqTQwLTzAFP+1lR68l+Pr2C+97Pda
         U56LESDDLFz0wtPg8vfmY/vvR1/Kuf0OjDH37e3drsJX26mtJ/fpt3wYNEguYkpTKax4
         Sl/WBz57gE44k91UME8MVFy/1xr45Q+bkLpaGB1zTV1QUobwasBzUYQmoZkZuNz4+qFS
         DWDDCnwhgtWjsLJG/bufCXO3km7hFop5kCbtk7KM9FXMsP+uGXk79cE9MBwLVlC78BYY
         N8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709670005; x=1710274805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TcL6wAeqVuoZZD/5WSQ4uqaLPsMl9CXzbiG1AkNovjo=;
        b=m+MKuIhlC3BSdXKJrnunRHfdpctKPT82bhpOSqn/RwFkjxHqu8a53H2gYKOkxgdtQn
         OkutklVX8HL9B6YQOP3xE9e01xJb/GiI2UzU0l9RQ5zc33Mk8aiIU2UvaA10+vSfyCCq
         GeNz/GuHY4aEQXzkQYYVCsY36Vgc1sE9hAvs1wmFvKNGexlW+ijciSnC9/+/zS5Szsd+
         AAerLtmOIfjogCQ1f2LrUtmNm4jXWx+Jfy3NtD0BS9jYE9zEvsiwR4tPfH/WOibVOEw/
         n/GapLz6OgGW9RzV3lUt/U32Fo6jHLcIRMG5MnsALu5WoRWayXp6Ij485qF7ynE75802
         lpEw==
X-Gm-Message-State: AOJu0YzPOUtkPQJ9T47DynJqQqlW+M/ioHvkcNWp/IXGoqTUuFi0Zmdg
	s8TF4QHY+Hr7pLFcc4kye+x2RVDwV5nKUeCQfyw+DnrQpM64dAvk
X-Google-Smtp-Source: AGHT+IGtZnMYmjNXy7Q24MFgCNySt6n03fjiEkX7ZqjtXEWZZ8Lyan3TNq/IbL+j0zffMjdL1p4W6g==
X-Received: by 2002:ad4:4f4a:0:b0:690:8f66:5d3a with SMTP id eu10-20020ad44f4a000000b006908f665d3amr2781140qvb.7.1709670004785;
        Tue, 05 Mar 2024 12:20:04 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ld8-20020a056214418800b0068fef1264f6sm6529329qvb.101.2024.03.05.12.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 12:20:03 -0800 (PST)
Message-ID: <70b66780-0f63-4192-b5c9-ab3ddb08b330@gmail.com>
Date: Tue, 5 Mar 2024 12:19:56 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/25] 5.4.271-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240304211535.741936181@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240304211535.741936181@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 13:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.271 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.271-rc1.gz
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

