Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AA924A078
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 20:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664985; cv=none; b=M5MvYP8sf1JueWZRi96knnbUTyJTihfzUc5MBl3HidHDjOl3JtSAkeichgOM0ZSci9NlkFpGUq/BZIX74Bl9Dksl22sM+lKRYLcpChOQgxhoT+kpItZjRdCYl43dvDtKsLq2FTn8EOaZP4OaWtT0GJyPVtrC7yYmbfVmzHTMQ/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664985; c=relaxed/simple;
	bh=2nW/jag0OFDmdU0QuqvgLMi7C7DzkcAZdE9Mb2LmPvk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=XYPdXLeBFwVrFg6blo10CwPTqwuE5dOaecijvL0qp+AO2+0+JueKEem6zlRkhkt021IXO3ezv/i+J45y3qbl6FTvaV5w4fCzfp3G0B3KvuiLbh+RYfVif6PPIxCzT9kK/3nn+t7Z5xpgiWtkLGzbUqXxDD7A6uDZr0XEvqwqv+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DR5HoyHq; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DR5HoyHq"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e512a9a6bso757398385a.2
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 13:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784664983; x=1785269783; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Eq/I2Yx4I4ai7680JlcJEOI0mPA0NT1fgrQ0REFG2zw=;
        b=DR5HoyHqGaXUmdf7ko/vZ5y2zvZVViCU+9XC79U88ZZbQN7Vb1GxIsPX9TxuOIgs4r
         Gj8HEckL6E6YmlCH+3lBYzzvs/LUNgOTiOn7uHJNzVlBKzmVGW01vp2HtZfNQNmKkSNi
         rIue30gwUWUzdCo0p3U06klrunyAjx/QbIJbZmcXdQYYFP9mLT7yZXXXoOKYZQd7RYwR
         BIIv5E654YolD8w5KcN1xoKk9Z8HyXbdqyckSkexOdJdzJcM2rTutAcRWQ8eN+tanSUw
         DQXrarX5UAS/Z8OlW+YcGBOxmctzpogj5L5/qTnSXkzWtxV0klBwAOKYUbUS2Jsnv9gw
         M7sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784664983; x=1785269783;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Eq/I2Yx4I4ai7680JlcJEOI0mPA0NT1fgrQ0REFG2zw=;
        b=ilYUo/6mRmj99NAfe6PIA6n8iOgR4hC6ZYCkYTTQ2brTuISsnoWJrAREUMnVzrTlmz
         hKknU+Zs5MV3ysLSvPaDTaHMRH+FgacucOFSK99a+IE6EGEt9rCKT+UIYtIoejzQWozc
         Kzt8Uh1nDPsNptq8KMiXbfLyP/yP7navzDgmFa2HbVighcWNfkdxlPrpQtqHIUTCAyrg
         3kiC8gqTHGMnI0zRua/AsWgim0oZ2B0XzZlxJwUPBW+N3t9T9s1OcuXGNhd+nZ09++5d
         rPasGhhZCAoTs3H/F6zRfzqx/+v9f+ebDs1jFN2yYqQVeHBIgVrFVhu/PpB52GEHFdec
         PIXQ==
X-Gm-Message-State: AOJu0YyYFodIsQ4y9d4mi26LOs5eCVUHrp3fSLeZvmdHEdDbVGtQpEVo
	f9dMWdhJLYJl5M/96gz9Z0zsST5qJfrnl7lwH8YKu8wkyHXqXnjDyRo=
X-Gm-Gg: AfdE7cnmV6223KWkYDhol/ffa762Ij+n+iu2IGOaPnS/AZrHl95OPFfW0+BGfB+uGkl
	EKIoMghPHck2T0agaJx/FmKTJX2S7TSo+qAsbk7ChAooQ5kvoptyusUEPpcuPiU6DpuHkrkIepY
	c/6kRzbfS+dH46WdSXLuyrSOW+KOzsvp+yV13yo16zelqIf6nc3imOy5wWv+e/xF805s8LmZedX
	dgFbU5pPQoV5W13sXKByPPne17MVkbWVwabTWzs8XeA8FAFUewv1k2k4hluHRwa2j/PpGinA7Vt
	ks15bwturt/n/g4uZ8V/Mkov8J8/2n4Yc50MqCQzne+exRodhqFY1b+8nBNma6Bj4O9Pe+h+Rz5
	s1Df2l0CsISvcPuJPnRXSoJTl95D0YNzSsewNv7tyvk1oEEr3hCTI6x9e5axGrmlBm7e9Z7gAt5
	zV2urGoUXN3Dnusx1F0ww46hWXz27H6oh/M+f8LxC0
X-Received: by 2002:a05:620a:d8e:b0:92e:f3ca:2ebc with SMTP id af79cd13be357-930b3ed6f01mr2150766185a.37.1784664982638;
        Tue, 21 Jul 2026 13:16:22 -0700 (PDT)
Received: from [120.7.1.23] (135-23-94-154.cpe.pppoe.ca. [135.23.94.154])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b542e60asm1223396085a.31.2026.07.21.13.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 13:16:22 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/699] 5.10.261-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260721152355.667394603@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <eafe67c7-4e17-ce8c-1a93-e018074b6973@gmail.com>
Date: Tue, 21 Jul 2026 16:16:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101
 Firefox/140.0 SeaMonkey/2.53.24
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.261 release.
> There are 699 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.261-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
>
Compiled OK for an i386 and runs OK on a 32-bit eeepc. No new problems 
noticed.

Tested-by: Woody Suwalski <terraluna977@gmail.com>

