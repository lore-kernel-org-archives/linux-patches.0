Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9F31272D0
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 17:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706118653; cv=none; b=Zqa9eDrZMG/RfhzpHzpUcTMSXW70N0DwerSLzVSuDI2bRdSVaWisoGAJUIMIDv6sWjUxCws3/XxqCCKKnjW2QNWdJVT4NaKQRQXIjgJTJfFLKgdeUPD/e7musWoAGP5YygS8pDK6/UdT2sdY6J3H+YaZTO/rFQ6//91W8nLTdhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706118653; c=relaxed/simple;
	bh=zmpMtbPNi11VZtlC6OMkLjiOFt4LIwYNYu/Xb3aM49c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t1Fwq8E5L7itkqWVOTkaE1h+tbMAOHALfwvg+C8js1eAK5rxILKclncUYu2NZbVCRW8zNRZTdA3SjZAomnOiTTylAZNOcHSRJM7ijg37XRevWuiDL3DXMZWfElX6l0f5qPOLXWGD+/pXK0Gam7HwlfJr8nRbM3SuENcSOjG7zxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TdJclKVN; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TdJclKVN"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7831aacdaffso505038485a.3
        for <patches@lists.linux.dev>; Wed, 24 Jan 2024 09:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706118649; x=1706723449; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mV/Ca+SH/xfxgnTjXdWX10lc/dyq1IqSKNfOcSnfkFc=;
        b=TdJclKVNcB+jF650zp91bp7xyuzLDFgNqENZRWk1rdz0fy63dQ4WkQ08HkQWo7eKJR
         nQCQ07TfW7mUjtH+1b/VrxkbvwRsOK2GKcDbIAN8dtk9yZM/qAcipw94tquY8I2a4gPM
         oQ/8oPIU/9O3CLGigZ73Abjny7tUsnCBZwsWVR1v+4lQT2MxodL6dp5rCjSaHRa7FsF9
         Em0WzvssTPrekMC6Z39V3/GhBtpHLtzzFyKpp9rfnicScB2DtSbSDBrs7dsyRlkmi6Yj
         Aqz0kMhFMYWkSJjnQ85fg7tAF8DMPY3uXGddK9aRvW8IOi0ODPGS5WSmqPOPVnZMy22V
         395Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706118649; x=1706723449;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mV/Ca+SH/xfxgnTjXdWX10lc/dyq1IqSKNfOcSnfkFc=;
        b=DS7pOAEj+7q5oovoK6kZnze6l/XF6oG3RWhofnl7eOHdvHFt3wCpTdNwzsgOb6pHkB
         Ga1rZ59oenslzK+G6A5IMknh0XTljjWasGuvulNlJn776c8z4lbymWbLCqLEanwOoAB3
         0SHoZ6kAmiGTGX303zXpzNncje+RFSu4GhJtDsh1p0ZTjUJAOY5IteQP2ceWE0OjmdAH
         hog3frnk2DH4hj0AvKH2FRnJEwU1Q6BszHIDiEAjhy7pRiYkb2uhjE6O1FvKiKjoX0Yw
         Rmk/zwSwVOEr5nmQJ3ryldXjK/jTQDZf/Cs8QV+VsItXU/szdfkx8CorSVpwRrbr2ANV
         RSjQ==
X-Gm-Message-State: AOJu0YyvFHBYpboWYi+swumtcplZIPdltpfJsPcZ+74lVzCZueP2hOOv
	jF10/I+PFRgpCKratx85FE/LzWbOx4ZUUvRTBomKnQu2zebGag7byfIaZsWZ
X-Google-Smtp-Source: AGHT+IHbcuCuw0k1Q4GLr7cIkKxGbFEY+cx8KBkgDCxdC9f5fRfvBRz8LAbmIQf/xPV8AMaZMIJ2gQ==
X-Received: by 2002:ad4:5dec:0:b0:686:acd2:9b60 with SMTP id jn12-20020ad45dec000000b00686acd29b60mr1685402qvb.46.1706118649605;
        Wed, 24 Jan 2024 09:50:49 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d15-20020a056214184f00b006819a4354basm4705402qvy.37.2024.01.24.09.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jan 2024 09:50:48 -0800 (PST)
Message-ID: <95210b70-38e6-4d7c-acb9-d2681261f8c7@gmail.com>
Date: Wed, 24 Jan 2024 09:50:46 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/638] 6.7.2-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240123174544.648088948@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240123174544.648088948@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/24 09:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.2 release.
> There are 638 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jan 2024 17:44:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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

