Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D85A31283A
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 16:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765385355; cv=none; b=dF1zgSkqVjKqi+cYG+/wKKc7gLVCZLaYPkqERpSFqjuD9FedWQu7Uuhz5GxROx29aV0fmoXpT9Os24o+rzLMpWbssAA+RkR6lKeqw9Elu0QZbWRvrLjnKNOXrLqDq/yZBy+12gcXpt9j57bpauzLwsyDGS0A18MCLNgj1xabqCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765385355; c=relaxed/simple;
	bh=WjryKRyGSADBuvbSpI7v7yfJSchEyUut33/C1V128gY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=grMcSSrnu45DX/5q3qCL1kTR7m1fvcOgSmg9moTa/HiiWhx381Rq9y2vfu2e6pmhoMDhmKmKzw0a5YncIaQezTYGHTNdWMBq8yG3ErO2QzCjO5FNl52/+VtEEJ4Bld4xFr9cVFExHEmcnNBBJqpWWUCEa8dRCpBzj3r3SEZufik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=mj7/W4s3; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="mj7/W4s3"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b79ea617f55so118922266b.3
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 08:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1765385343; x=1765990143; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7aRZ2LeZjgs+oT8fLSX3wAeN/zXbQNp1vbBsVzoBojU=;
        b=mj7/W4s312pXkog22OismxRuaTMcrI12vL69YHne8kS2wHTNysmaVQFYPSJV0DeWSf
         Fq/TbVERKHL2/Cwd6xuz2ww4bG0o7QQ3FFFdcLy1MG2NnWqfhDGHvk3/YnGml6dpGtAV
         HUSmsW+AHpAd3Mi58qFl2VndDX5GEpT9qkxtC1tfE+yABfllTXNRUPhPr+fYYIY/Ks7T
         7lqe64J2OAGpW/bKxgx7/S6J3pxRDnRJnNdw2aoUFLiEdRB+QqH7tA/UknWo+TAr3Bkx
         C4hbvQKl7Fe+IRV+fIEC1zn8Ng91o12fmXrBJfm4bPnJNxvPJOT3WW0PHIRZ+2UYYpFt
         fqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765385343; x=1765990143;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7aRZ2LeZjgs+oT8fLSX3wAeN/zXbQNp1vbBsVzoBojU=;
        b=ma8rfUGzX+Xbn6Xz2nRkZ9ditMeOjiLzaQ8S/z9Cup2rTsFsqgTxi3F+65W1IsqRKc
         uRKDrVfWc0LULKTC25C/oIroQy2c2njapLedX1ZDNkYAbRByeegnngl/s+uemRXVneAd
         nhA7pWOg7lxQWIgNzY1wTYtjGWE8PSonuP1XFRfYDlICeaq+OYOp6ZiYhv/qcD6WrE0c
         9aWfWZq9C6E8jFiYtRgWnGgEwfdnZ9oeyK77TxZZR4QwgHJyjQkFgFyzQarRQIah8Gxo
         pQSTXHmjZ0F6mnAnS9J4CbxokKteVyL/N5Gn4Q9AGjZwxps2z9YozQ1Hw96hUXtvau/z
         NJUg==
X-Forwarded-Encrypted: i=1; AJvYcCWgobibEEU+WQI7VcEvVjRSc68TAL+vzCcu6+QaJgPbsdDRcLtE5dId8nfpmCUqSQCJOO34rbhc@lists.linux.dev
X-Gm-Message-State: AOJu0YyaGnJ7VqgbQDIWV/f2X3KmP1l2Col4yIoVOwbzBbZqljn6AkGr
	P2qBI1sDjiX0qxhFdhGT5qm/plCJUQFYcj0jDFpCB9bWxT1ZPITYzkmZqOjWpyuGhqQXy5IaTTh
	9da10WnlOkRcBoiHO4yyR3m2MmfyLEfKOvGziHN+SHw==
X-Gm-Gg: ASbGncsb3ZMjymc7oU3NP5e6CIwJbw5PHR+UxUWBnuceZL6CDlfYsxgx66B6/QuSltZ
	fLneTwV7FIX4O9vifjAsDqAAq7lb+kdoxAn8MF5XanQXHc746orr0kLdzfW2ZNsIuJ+A19ypCQx
	ckccj6sUFlrdDIYSgdVox+y3sAdMZm4HQoz+9WGNx/LwHxDTIpzvngtiCITwPicsGpkPm5YlL7J
	wMllnt1QPdRYFkrgY0zzp0J/FfCxorQsciIJod6rBJtY09PdAQ+yvzLv2R52cxYg2EuYa3BouWZ
	rTHncQ==
X-Google-Smtp-Source: AGHT+IHG3EATL/ftGHhQuFqxHwYTnzohbFRvs6w9NLW+Dk/26SkKGS0IjJ5H1uKtdDVFnNpnL//uU/iFq950dlrLdvY=
X-Received: by 2002:a17:907:a08a:b0:b71:29f7:47ef with SMTP id
 a640c23a62f3a-b7ce85308bemr296913166b.61.1765385342687; Wed, 10 Dec 2025
 08:49:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152414.082328008@linuxfoundation.org>
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 10 Dec 2025 22:18:26 +0530
X-Gm-Features: AQt7F2poqMWU986okgWXaQ_Uv3mpP3y-4c97KhwqKkvBqKbjtGSV7ZSeV6nJIyo
Message-ID: <CAG=yYwmkjqHZbSDN3z00G2O=zDar5pR4GKAE-w-Ur7MYCgTmWQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/392] 5.15.197-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

Version: AMD Ryzen 3 3250U with Radeon Graphics
compiled and booted  5.15.198-rc1+


warning  related  to   dmesg

 [   13.924408] block nvme0n1: No UUID available providing old NGUID
[   13.927216] block nvme0n1: No UUID available providing old NGUID
[   13.930683] block nvme0n1: No UUID available providing old NGUID
[   13.934469] block nvme0n1: No UUID available providing old NGUID
[   13.935844] block nvme0n1: No UUID available providing old NGUID
[   13.937880] block nvme0n1: No UUID available providing old NGUID
[   13.939234] block nvme0n1: No UUID available providing old NGUID
[   13.946032] block nvme0n1: No UUID available providing old NGUID
[   13.948137] block nvme0n1: No UUID available providing old NGUID
[   13.950842] block nvme0n1: No UUID available providing old NGUID
[   21.906207] kauditd_printk_skb: 126 callbacks suppressed
[   38.522153] uuid_show: 4 callbacks suppressed
[   38.522159] block nvme0n1: No UUID available providing old NGUID
[   38.557254] block nvme0n1: No UUID available providing old NGUID
[   38.589733] block nvme0n1: No UUID available providing old NGUID


Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
