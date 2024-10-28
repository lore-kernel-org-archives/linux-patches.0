Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C44188010
	for <patches@lists.linux.dev>; Mon, 28 Oct 2024 12:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119727; cv=none; b=DoMxDLVahEhSRCa3/f0jNGUopSpOOp0xG+YypGvbiLkL0GAs4bZKw3cq9sKZTh0DjKXVn/VMxp87A3BovbNHplX1hGKEVbpeklUj0UlvdTehVwwQ9RQTe2OFQHNVBkUW5K1O2+XKhl9FteoKuouDbTFtulw2T9X4GytSgac0jMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119727; c=relaxed/simple;
	bh=JoPSXOQeJqMKZgY81YXFOztSG1vOJXM3CX4fstflfPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BUbRbIeynpfU+K0yDs3uQixUye/lVc64BgQMVhZtSoamNUdIvsv9rIE+twMpgA31LVz+dZspGMfNqDbzk/otUSDrWOf7Mv1Bj/2rAiKRYpIvZjPyle3pc1suaZx+PW71+QlUtOVIsQc3LxTI7jhrVQScCJHpwMclGyWz67ZgNvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=VLzwfLB3; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="VLzwfLB3"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-718e9c8bd83so3619378b3a.1
        for <patches@lists.linux.dev>; Mon, 28 Oct 2024 05:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1730119724; x=1730724524; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ReVN0cLvWmqthK71mUPz9Vh7INJT2/+SuZUXMARwOEU=;
        b=VLzwfLB3Zl4ZPdFX2/fEGNSoEpNxKCBRL3ihCiFWnsVfpSgpK/gcuVVwLoKIl6E0CH
         yrnUmJNNIxacMAMdA7knoIi4VNzWjy10EIkCyysX0vWttLhJbyj1LqMR0WpQTciB9Oad
         cEIWIecSmMFl5JiQJDGN+iCPWhhOf58QiEbZH64QwQ24fKeIgw+xUpPgeTGZaX2ZtkWQ
         1G5ruyoD9BKf5VsLOdzZiN9Elj/GT5SzpMIWsujJe6wsOZhPBlFZwjrujmV6h9Au6yVM
         +a3wjLduaNjbU5mmQa2NyXrMy1Z7zYaOvl4YSSZaBLgbFBrMZsgLACrjUl0Yy7XiYvfj
         lfmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730119724; x=1730724524;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ReVN0cLvWmqthK71mUPz9Vh7INJT2/+SuZUXMARwOEU=;
        b=W1g8xZ6u/PbkpWzSwYxccb84UfjV4FDaVkDqcQDRBfBnxhl6Y1lDv+saxoGcq+/n1b
         XMbtxYOxapjaEG+/GpB4DoQR+L/I8Ky+x7Hk7R8+yP54El0kblHtpssHGkxktZo75psk
         ZbgKr0MgpxcnQk4nvoexKYqgAxfMz9hxRv6DmUttuCEjik3IdQk1Jd4tjKCAzrsmNZlW
         XjWHzNsAsvelK6oT72KhpNxdKUzt4b2asqG3sfhRBRsLqGiESns/Mrzcsa8r80bDHCfY
         +1GRAUbK1dv6J3neSqblhvPy2VRombDEeUGu2gttb2+orDH2eY2H8uQtygnS8EwXP9oS
         v2Og==
X-Forwarded-Encrypted: i=1; AJvYcCWcUgf3FJQ7Hlhk3nSz9i8/g5l3HSeipXhi083UeJEiugtkWyQ6wpPCA39m6KTmXQb7JoSvU1vQ@lists.linux.dev
X-Gm-Message-State: AOJu0YyRJ14yxcCFvfFRJBX9r5Vp7Gy4bsWP/Qw3MYudwxPF3t1x5uir
	Gjv63Jygn6uQwJ9Zil5AqiBDz4NujtpM26fsvGxO8kUiBu0nqwsz+8zK6lm05khAQ5ZaU90x/2+
	VjQqN2RXc2QtpbbykO1gMelvqiKS7fhBElaC4EQ==
X-Google-Smtp-Source: AGHT+IGhLfmQkrVqP4HYAOjiKc7239c27pDkdxqrymPqmidDyewNr77EbQ//qBWctOJ8VAhkGWdsckBMrKZ6g9++IUQ=
X-Received: by 2002:a05:6a00:1954:b0:71e:44f6:690f with SMTP id
 d2e1a72fcca58-72062fb21e7mr11792989b3a.8.1730119724055; Mon, 28 Oct 2024
 05:48:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241028062306.649733554@linuxfoundation.org>
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Mon, 28 Oct 2024 21:48:33 +0900
Message-ID: <CAKL4bV5XW+xCFSSie3tBE1GiB4pFZ1vSpHS9qkyzZg6ibxDVbg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/208] 6.6.59-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Oct 28, 2024 at 3:39=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.59 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.59-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.59-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.59-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Mon Oct 28 20:41:12 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
