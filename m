Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7D319A298
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 11:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725537347; cv=none; b=qX3lk9KOTZIHZLX/vpowdJ8S2PvQxa3mFSJJ2K1Gl6XJxx/hVmJT1jkoIKNryuxzZI6tfz9Tk3WsQDGimUGNa9wCBIOkAaZuA5/NmuOmPuZ+H2JhrCbHeNm4/u0dzSsokuAuyhkNhJ9RDDydW/ox33X7FJqr1VxY/LR8y1LSC2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725537347; c=relaxed/simple;
	bh=9NJQoo4LMVMggcZzkDEPcmdJE9FtDyLAQZGKEsY1FLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bjpXJPcEkH6sQrIt7NwWWym53lFgbJA2i1J708BE/XpGXsAE0TVA+43qF0x9ap1redwht/MpwZ6gHOIClWnJU9k9vBBglo5BoY0W2hcMJC0lcQl3PeL5Mbno6W1/gM4Cl3piBEimLkfQH3DwuVqAuXdbEUKgxsx196SL1tdBNSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VBB7qJ3X; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VBB7qJ3X"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-846be74b299so201889241.3
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 04:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725537344; x=1726142144; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qRJcGcRJNx1TW5diCULQtEUQCwcWsO+dA/2EMfBnxLI=;
        b=VBB7qJ3XTG7EaguQ8nGRydWk4jlwEquU0g4gV9S1jEYwSlEmFBJPY6T96WaxgkCfvc
         JEnF19Jgog+bKwz7ZMJgJf8nDR4PtS1pNJqFcXwdFtBD7WNzgMSj+1/eAixuyTx8MSJo
         N3uRIIekqBSRga1Ctqj9DG7dNQ48BlwT25Hg1fWPUxc12hhce6ptAbnDmyjtnE0uHwZT
         G44NAWF2YEEDF7jxZukmV3/YN9NUWivleGGUo25MtWtzDicPMukvvzBF3LL8x+EhSq6o
         6C3vyGvd/GA0OnIJYyhWeLSP6R0OwwjfgeUYnKVOYVJFAT/CZnWXFpl4UIcfDQ7jlfXz
         zACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725537344; x=1726142144;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qRJcGcRJNx1TW5diCULQtEUQCwcWsO+dA/2EMfBnxLI=;
        b=X6EFjachAK5uoxZ5iDis1OvOUah0rG1yDRnj+4jKJAKu4z3jgKXIJJU9sCTvREF8FD
         O56WLRhfSKeOskY+Jw9z6H4Pzib5QdR6CcN9tVwUbRAmIlZQiHZ3eqfS2GvKwyNfU1nt
         9VQldYPfEvgDCZcB6SBs9RGYhgiI36JzXROVjHdq13029XC73lSUgG2kp1AP8yQhcC/I
         oOLwa07CQ/fSa7kevT+4QRLURKmDCYjA25QELksngp6NAgEpWwdeiyz9pPgyh6bCYEmw
         Zp5Jylj64GY1JOJCyV+o1aEuai0NY2wbNjAAcjWRzzMCDbEO9ADo9E5lV2GBt3j+Hdpr
         RGaA==
X-Forwarded-Encrypted: i=1; AJvYcCXLrPa4tKQ9ebiHOyYuQbKxZFeXpwDqkKwl2VypnDHY9yxqQT0CH82OzNmz+MPmBduRKvaVqh2/@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8A4mGpznm7N850YWFUWJRz5ivLP/g4IriEtu7YnbSxpMJHYEr
	h5O3AWaGyw1uy2iUbT1T3f4S5/7HS2uoF1lGLKxzZpN6AO3WBlo8exQVxrLUFZXlUTVqX1h4Tsf
	J+sB6NYhM7TFly3CTjKZHwG+aKlRFqJHmNnc7Ng==
X-Google-Smtp-Source: AGHT+IF81MA398iZ6b4Y3eucXQLIDL+C3dpW3/7905P6ameFiZ7xV/TUXSEnEfZ4bjIqf/xqhw7rYHJecNOySvu0Zrs=
X-Received: by 2002:a05:6102:26ca:b0:49b:d24a:6860 with SMTP id
 ada2fe7eead31-49bd24a6c82mr1314728137.8.1725537343801; Thu, 05 Sep 2024
 04:55:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240905093732.239411633@linuxfoundation.org>
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 5 Sep 2024 17:25:32 +0530
Message-ID: <CA+G9fYsppY-GyoCFFbAu1q7PdynMLKn024J3CenbN12eefaDwA@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/184] 6.10.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Sept 2024 at 15:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.9 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 07 Sep 2024 09:36:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following build errors noticed on arm64 on
stable-rc linux.6.6.y and linux.6.10.y

drivers/ufs/host/ufs-qcom.c: In function 'ufs_qcom_advertise_quirks':
drivers/ufs/host/ufs-qcom.c:862:32: error:
'UFSHCD_QUIRK_BROKEN_LSDBS_CAP' undeclared (first use in this
function); did you mean 'UFSHCD_QUIRK_BROKEN_UIC_CMD'?
  862 |                 hba->quirks |= UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
      |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                UFSHCD_QUIRK_BROKEN_UIC_CMD

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
