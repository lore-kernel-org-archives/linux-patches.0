Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2EF37168
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712768136; cv=none; b=Xc1RRDdKCx+KVjCVoGu4BhqOH/FAjJqlyggaSIYk4DadzlbLh94EREQIy5xHS7h42xZ4Dt21N67BxULr/MV5TwF1iU9XQSUenvmWVx5nqAZo0Tk/4dpYB7yUOU2hP6XYnthjJbyUw4iUWq6Oe9FNXWps+mltGSyBBwBqwk3DJr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712768136; c=relaxed/simple;
	bh=9FGLAozPYT08B8QqzbTuZsQRhIqrVv2OVR0opnaqJZM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QfvER7ZBJxAzgf4CnbQoYFu4+dZHLcj+3rW+LTBg/dGxnSl9uZbKltTnXV7wRFnGZ/zklqiHs8aOtwKhFV8N/5zXR2MPdIw1c0GsrhDZzYTqY8jhI/DDmnGxktYq2Z0xZzhqDbIw3e3HmJ4CxczITuGonKCDoSGY1WzHZ1DDxXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MnlzAJpm; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MnlzAJpm"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-4daa1be011dso2081731e0c.0
        for <patches@lists.linux.dev>; Wed, 10 Apr 2024 09:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712768133; x=1713372933; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mlhnPVBkd849gBpPLB7C+8g6xLIg9ro6ZK3Rrk9CvkI=;
        b=MnlzAJpmahmIvJoeBNESmu6xiYxl+wzyWlaJDatvATXoWL2p+4I65PP0Mvz2wl8kUe
         AYRkP3akiAbaty/MNAr+RKMFHS29FZlz6Zd7BOUrhRPmFwMeavalgE9OMky4hcat/+77
         OuI4y9y6I1NGWy9tOSkfKn/ICjzHPawDWA4stf2MtpHDEK/OM27ELvH0CNIVkH2/qEtc
         uitZt4ZMrtoJQq+Ep9AYRdzad45IAhdbkoysp53ZZXE4p5f/pfRvAEJ0/CrvK9fw3EDY
         g4z1EBf5UEMwfkhtdKD4xp4rVepN/txkfRhhxuzgMQo8cu09mguT/+6cq9LNV2wf/hG0
         qVaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712768133; x=1713372933;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mlhnPVBkd849gBpPLB7C+8g6xLIg9ro6ZK3Rrk9CvkI=;
        b=RIZxdFQx1luWlxbjqQ1JKyMgMT/kKxcBECK1IELILok5achxjYKW9q1BUa6+Nio3KS
         xDyNRGIDe/JllkopH47YKgz5utmvZyFOXp1nhG6MsdHn1H0pCoOw9e7b5wPBvbj/2wC2
         slYKPN3FEeG08xIKrhXcK+mUa8FeeR4fWbQYR+n3Jn/eNxoz6E0aFB9mV5pX42VT3FXA
         eg/uo4xpTSP6A0sA5tU62M2Ip5SiyymPjhwqnUkooQBxYLhSI1hWO153MTeJ+BhlzTsl
         R61BTYQ/vlb4y9CDeP2n0a82wButy7RUnA6lk4ZViRzQTvcnnli9hyJR+jeGoc/ovFDQ
         X1yg==
X-Forwarded-Encrypted: i=1; AJvYcCWgsapufSjeCx5xRim4+S1gGP3C/7DGJo5zFvZmuLoFhdsrjRZ92o090y5p64so3fmd+3PD8Rrd4r/YHhyum/jQE4yea9ARjQ==
X-Gm-Message-State: AOJu0YyFg8qjYMwl14PrnS/L/h6Va8bsDqdOi3jv8G02VXVZ3ch5Wgpt
	xyEICwdvq10uUZ3LVG+JMiiGhhTUb+nnMUoKoKFW6guEXzVozLP/n5YNZUvPsrnzb1vZdWTaCZ/
	7Jj8ucYeRqL/OP8woYtmuUVk/O1I=
X-Google-Smtp-Source: AGHT+IF9pAel7nMAX3I9Rg1aEgBOzdta8G8E3m1sAmDZh3iIQ1Ev1SSmSrFgHdlnLugMYPfW11kKhWz88gCHEs7dau0=
X-Received: by 2002:a05:6122:8cc:b0:4da:a94e:269c with SMTP id
 12-20020a05612208cc00b004daa94e269cmr3401326vkg.16.1712768133288; Wed, 10 Apr
 2024 09:55:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240409173543.596615037@linuxfoundation.org>
In-Reply-To: <20240409173543.596615037@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 10 Apr 2024 09:55:21 -0700
Message-ID: <CAOMdWSLF=Xo=raUUfD27MZgTzpMZ==zp0D1fGfjGsfcP66=kcw@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/280] 6.8.5-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.8.5 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Apr 2024 17:35:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.5-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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
