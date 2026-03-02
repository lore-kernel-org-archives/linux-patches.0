Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1023E37BE75
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772477197; cv=none; b=P1BsKd+x2zlxTMk7jcKoZwT+7IadZHOXzM6cFJ6WH2d/RcrzY84edVN0SDuGwZkkpLFVFHOxsqPRSJjnTdB4vuILMFSJ6lWLBnyC7g80XroJqujsGrFxYfggExf258mOZeJ7nPm+JKnppRz5LEpU2RCCHsFyjMZipQ/lYEM203A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772477197; c=relaxed/simple;
	bh=Lry8ExSeWB9EpusoHkxojQVZihp63rGi1LQPnn8u6D0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ob+sD0CuRiS2wfpmdWI4szBd2Qsr0LdevzJ0mBYLlMqn3Pascg5bzC4EmcENxLl43oKdYvefD44LQ1MBHcNN1Lw6VywyYfiaBbEG2ZKQiliWClWfypHYzFJ+Q3f2TN+BTQ9Kczx9vMm5/BN/g2Cu/deH3iugtlQFerE34vqYg0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BTZz9EoM; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BTZz9EoM"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cbb2329e7eso499283785a.0
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 10:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772477192; x=1773081992; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2/fCL0PVbWZ+CTSzMuw98+KycxkLtqaDaxlUz1qwLO8=;
        b=BTZz9EoMwROS/lXQ8BuDS63Nejcim1IzYmzHoiK9Pr4O2w4ZWGBt3GbV9mKO1ioZb0
         hk4I4l92ysWZ59AjEvZXeJoqvb1jShYtMyAM6ficp5vEE7M2wye464X0J0cCl2COoOZq
         S+NWPs8PG/ig+xFuLMqNprtWNcQRnBAiCzX2ER5IA2q/XA+Ms5zwY10Vb29C6A1Br20o
         5q4sOfCa3O9BV4kD5aqsUkHZZXIPpUjqJDkJhyWx988iAeQhI+FuY3IyJfo7hQuEkKFj
         lVyPoRJ7c7qlObhDF5ulaktzwA/kEiNzEsAS+MAaoOr2LDeOzweqivyQHBBrTE0Kvqsh
         dVZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772477192; x=1773081992;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2/fCL0PVbWZ+CTSzMuw98+KycxkLtqaDaxlUz1qwLO8=;
        b=cAvwKHssKg/FS8vv1STv5F97+On6Ioyllv7d6AlDqHEP69TYVZF0wyy1CNjYMmBbVx
         whbSpqAmTxKtId08NwUejowFEfdkhLAlH+PJ+OK6JxlNfW7GDQ0uhnFXkhDB0vIREQgD
         wsnPxuGAyyY0NAqKzcgFNG3UF42ty/fTcsXF4+Y4qKaloVC5C0N3p6C6rfBTLRL0eOXi
         3rM71J0GbPqdUCszYuOLt+/KpgN56rrCEhmNdSAu5zxPrc5RmPZtKOQgmgUaX7OsXlWm
         mb0lOGyY8SPAMheKwfN3xU1EorFt4loq2ZAuUDXeCyHIUnaodfNgq4Stox5UblN1W6rx
         5Jfw==
X-Forwarded-Encrypted: i=1; AJvYcCVojwySbtuAnwz3R1F6W0/Z9WiMk2aS97NdPoVW2XCIz+LEGy+fwdUqufAjGCmYDk4Y6cTlI/iD@lists.linux.dev
X-Gm-Message-State: AOJu0YzXGFUvN2v3Jzg/3pXRrtPl4sgpZVN/XUERNNqUg92JoBNmWvQv
	S+en+RncMMcWBpBBf2Fk71XmuxV8vMMKTyJWlCapKFpg4p43VHAqNEvT
X-Gm-Gg: ATEYQzx2xFV6IPpIdKfNccVzmFslxrSi3AAzU1XNDNpVUJr91JOJhZQEVN2Xre+LNyJ
	z3geKgUi6Zz8OxUl0Dxjz0Ga7bivXARmsp1VTru/rQqHP2EJ6MgMIIilR4NA3JfDwaLxP8964Gz
	rKxZbu8UG6FEbgpmqAyJGE/BsG5RoXgK6T26WX/5Hgxw45GFNTa4B74qApcGfibSI9YCCgtaaNR
	mSuV7Fe8+Wzime329M6mTIrS3awY1GOtmcuqlLWEzmiEkbXaK7EtT/pOc17/ArfsAd7GCXrjNuL
	3bh3+lI79Zmne+nzYKgt1HsjJUUDYZXqwsqC3RrAmYF2zu0LDWHeoE3s0J0rRrLRjPLyAwmLVoC
	/qbsQTSISrEQzeYj1Znsp42VShzeL7SxE1MuI3bSfMyLEx69CiJWPcqnG695YCBuyhPQqp+kQcR
	uKNe457UCRrCknkWf7AdJK8nEllC4GCJ72rHOd8BShij7IP2BZhg==
X-Received: by 2002:a05:620a:4141:b0:8c7:19f4:b585 with SMTP id af79cd13be357-8cbc8e4b595mr1721232985a.43.1772477191900;
        Mon, 02 Mar 2026 10:46:31 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf717301sm1199062585a.36.2026.03.02.10.46.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 10:46:31 -0800 (PST)
Message-ID: <a2baa254-0b3f-4514-846d-e905f1fefb10@gmail.com>
Date: Mon, 2 Mar 2026 10:46:26 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/410] 5.15.202-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260302160955.2522727-1-sashal@kernel.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260302160955.2522727-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/26 08:09, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.15.202 release.
> There are 410 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:54 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.15.y&id2=v5.15.201
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 
> -------------

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
