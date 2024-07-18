Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2957F144D13
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 16:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721321811; cv=none; b=ryVJtux4f6CvWRKIl0xRxKuycGAwtUCIVfbT626SlFv0Dv/VwHSPeoToN6E7cOn5dyZVT152N5/ak0A4s4V1aNoOLWnUgZxEhUs+8AAK0FLbRieb8rjzTzpczHrb10Mk/WcoOwJjcn2SG+nIsJKzMLB/glr7+X9vc/M1oTWcnXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721321811; c=relaxed/simple;
	bh=vNycuE6S7BuQIAvXu3VmSLPTI+xFJmtdQWvVxVWu2Yg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RieT1M8axG5eOG6cxqV9SK08HVZFyaSCxAAjA8J8A01NBBlo3LHGfaQjfVGBVZCrkNXcyVaLTLHBTGpHpeJ5gCi1tsDgdslu7WxHxinAmSCGOCzfUHSMA8hXhitxWNmfMRHKMMCfClqffZwlzIWee4Vg0fzp5HptJhoVz0YMYSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XOp666XX; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XOp666XX"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-80fc4fe7a8eso457507241.1
        for <patches@lists.linux.dev>; Thu, 18 Jul 2024 09:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721321809; x=1721926609; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N6aEJS3ZPzDIEoyWlBsShm3zWqq8TNQ9J6QXNez4EB8=;
        b=XOp666XXplKnLd0VXnHhJt2v72Hooo5FoTDZMN+DwTabHmiieFlKfu2AyB/GmN9KwH
         DPMrgQ2Hb8Ovg/qtmuLhEkD91tXA4Yiqy7xbqH/Fx6khhACJByFhzctgEforlP8I7S7W
         4IAGyKbAdKzyCj6R0sKGa9oVjU1ZAM0u7G2sE6idTy21B+pfV0A67RIVBiRDrnDVpZkj
         itcjvC6DzUWAHPLm8CAIyEEDIoj+puTzMz8fL9Xfp2Fyn97mBRXhzhr/0t77io6rG0re
         T96btmkNpW0fHb9KC6Ov4UOfTL2L905i5n5BGYkMAY89G5MJjQ18VJasxI68oN+MlymD
         8azQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721321809; x=1721926609;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N6aEJS3ZPzDIEoyWlBsShm3zWqq8TNQ9J6QXNez4EB8=;
        b=Yo5xq6RQHd31fGd9jdGnY8WyXmG1pW8XMqu/xpHnWmBvbtRf99GZgf1DmKf1Ua4a6I
         9mgtnLodJmFI8taddzUyjsMA3RACxEiOork5q0YnfUkN83IdhkyAetZ4X/AsHejNNLIv
         I5ffUocdD2G9TSFamhF6SM1Kyb7Yfkzn7epehQqK/Y/YoBnr5cRoouoBFAwPo9wWkPVF
         nGUm8wig9bH95nCFd8dQYWsqS5kjdrWLh9C28qT/3WylRCy7CgAqp/UCObAxbj/r5ok4
         aPIRmS4RbF5njhvITaM3KtLLV5ldZs8UIx0BqwuSQSY6fRIVphVFdqUGduY7+4Av000t
         6Bsw==
X-Forwarded-Encrypted: i=1; AJvYcCWOLrqUWWe75G1rmpa/zeN/sNHUvqw1vXbtuPQiD0uFpqUKnp9p6CyxBHU6yvqmjm/MfMpW5jmtJBlSdSOaEnPNfq+ST0CLLw==
X-Gm-Message-State: AOJu0YwsjkAcmOopxfNntTzVmt6TjQMr56R5t4GTWIj2UGL0WfFBN/DJ
	/nvA+gmx27mNukN22UMq1o7PBWH+qvJWznxy5Zq5um2AS47Ioj39+ljUO8YQUaQVWeGblz4SwTl
	f6hgj8WJoU/qSLpMmALYGxgo+Q6SuxP4P
X-Google-Smtp-Source: AGHT+IH58sUM9LXnjs0x7sBz5rke0fe2dE4msxSSDtym413q2u9R+/rI8KIso2MhGpih3P3gSU8uXTXLmfdk2Du4pFk=
X-Received: by 2002:a05:6102:1517:b0:48f:41ec:b0bc with SMTP id
 ada2fe7eead31-4925c1f2030mr3820256137.4.1721321808974; Thu, 18 Jul 2024
 09:56:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240717063802.663310305@linuxfoundation.org>
In-Reply-To: <20240717063802.663310305@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 18 Jul 2024 09:56:37 -0700
Message-ID: <CAOMdWS+V=Z=8dfYd7bF+=yirzKtg1g5GqzYZ=bSZKKCT9SAomg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/122] 6.6.41-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.41 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.41-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

-- 
       - Allen
