Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764D98060A
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 19:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709752101; cv=none; b=Xa12FnoO73bz8BUS4jYOscYSB6tdTyXEtqLTC9Bkk1kv3J6Hj0yIX4SrSfN5yWhhYigy/yAYa2eLAiWs9/5clq/QpQLLuhtJuGshLpPVXrWK1GG7pA16VIj8qdJsz89uUyShQvu9WIBGOYhH+LvZ03rFRXeXGMRu62zKCt0oDZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709752101; c=relaxed/simple;
	bh=RV6mL5v2qERzLuB7fby5/iAWOoXRQGIT6BUiqUllKfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ji7bIoZavpuzj0/iWZxcZNfotaUDUyH6/QAPC4cxm18rCaFyLQf8vy5s6VRxSuxG1GYZyee15ko+jH6rVs2YGp3rhQUryiGWkxsaO6BjRGcrv9VK3qDv/Tehfti1slKxopDr/B3Md0XpeTnG+Gm1q34f5B7XKK86a3JjHfE7w84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YD/VgNp8; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YD/VgNp8"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3c19aaedfdaso4422841b6e.2
        for <patches@lists.linux.dev>; Wed, 06 Mar 2024 11:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709752099; x=1710356899; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l9ljfn8pzLcyr0pmoDnBqgXrNCS95cr4N6iPjugHZLU=;
        b=YD/VgNp8rHEVbn9GRopTDRnEvAclpoEFcOLKQU0Oansl/LvLBE7ctuKeMS+2hIQlvY
         1voWkRVmUSeBGrWgg2WY78b0dMo1sP/X1ofyqw5enBWnkzLxltb8ELnzVAN6IybLmBXQ
         zzI29B/IK5UtAu3O2guPkm48AntsrRzmqZJ4gvck1M7/YZ8yl5mWuDOaro1KSPAQWkND
         wC2EeJ7q1g2DUldAeBkfOY4XFf/P1QmgS0jQsG7qMHano32ufoDbZjzKef2wMOvTNYw1
         x9oLb/bFU9Dhv/HTsrJaG3OY3VCPWu/I7kEgDV0kSWUmrJs4HIOftPOfAVgXuyJKrpGO
         4UhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709752099; x=1710356899;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l9ljfn8pzLcyr0pmoDnBqgXrNCS95cr4N6iPjugHZLU=;
        b=NmlEEa3QZLAL4+pI+2ictGH5NDwDzSrJVQdPt0PwdniylMItUm6AQpaP4FcKJybEMB
         4t+WGkel0GpNebPdM5TtFG34MS0a5zbY+WlvgqZvpLRsHY5CKshg1BKQdjAO3uoBpVnZ
         s+0e6JBEgsNCEXabTu4urz8s7oQOSEzaGZ/HKO1awEUyF/4aE9mAlqvymuJBxHV0/Qe6
         YoMguGu4mbIqjlDfxME+DC/UX2tpN/HYAbwpXqKM4Pz6DeWgfRMBlcg1wSXvGxPKTLl4
         eRUZm901S09SXddyFpLUmEUyYmpYq6m7eR7RdjVXpX2+bOSO/ECc4gfAdo3+/bEF9/R2
         Z6iA==
X-Forwarded-Encrypted: i=1; AJvYcCXhgyC6ZGtyikCoJ1kQMh/DJo/5RmVMFojzjkoYYl3IqVp77I6HvuFCXfKqT6bTtEPxswKcNeePaopcxFkE2+oDSoPAz7KC9g==
X-Gm-Message-State: AOJu0YxPZPTz8qmwqTB7e9LLzTRVoAkh42i3XW59wXh/btVbI1PC0COZ
	siiVRh9Zlj4+65x1dWl93EbCEtUiGzcei7bv5IVe6n3wumHBEDFyUcbfeuNlldeII+8K88TKbKC
	ySaSIrxhZ3WaQMNJbbJSVezmPN3M=
X-Google-Smtp-Source: AGHT+IFGQgNUfYbTsIVGa0MQeXkalL+JAaMYuehv8v54bumXXrGiXEnM64uhAFoqLtkLmDxL77ohByHAhIPdLU4DRS0=
X-Received: by 2002:a05:6808:13cc:b0:3c2:1805:8cfc with SMTP id
 d12-20020a05680813cc00b003c218058cfcmr4403457oiw.53.1709752098638; Wed, 06
 Mar 2024 11:08:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240305113135.403426564@linuxfoundation.org>
In-Reply-To: <20240305113135.403426564@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 6 Mar 2024 11:08:07 -0800
Message-ID: <CAOMdWSL6uPRvG-DwOmWRs89WfchXzPUuG0KzkBFu46ibKfv-0A@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/83] 5.15.151-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.151 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Mar 2024 11:31:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.151-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
