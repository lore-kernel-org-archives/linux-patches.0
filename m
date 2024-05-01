Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E78824A3
	for <patches@lists.linux.dev>; Wed,  1 May 2024 12:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714566351; cv=none; b=Z+/QDET3naPBAsSSfWYoOwNZG0gbaGLFtd4nd2/SrLFFXl6xtguSuzpJoj7QlCMQQdoproIlNqu02c1Lj03u2J0F7yVJTHLJZ07pGp39DrU0qCJPKQZfy7678+awPZikuVS8VjLVA60YugCPl+WvD1eLWppQhg/FKKDegyI8P08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714566351; c=relaxed/simple;
	bh=NSwHWAOCmxw85tG4MpaDkx4K6KlMQMGRZ9GWBGkHOuQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ncRgJxxg2Wpl84x+b2zpBGiRqdxLW7Gf7abpiZlf6H0JsvxeGeKJg/3lo+gaaZCjQ+/NNls0NTLGpb9hA026SVNLNJev1QV4UljvwzH5bnLDhSwl1fkfprWI7Wq2E1nwIwAYhYs2JKP5MQOIo21kvVMlfkH2+VquN5p0VkiaB6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=k7kAN1S+; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="k7kAN1S+"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6edc61d0ff6so6697447b3a.2
        for <patches@lists.linux.dev>; Wed, 01 May 2024 05:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1714566347; x=1715171147; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JiVKU3GODS4dwlptSTMaoTCW/CBkEG4u9gcmVKIN794=;
        b=k7kAN1S+AhsUrDiUUfrLnQ9UgAtHHz1s1o6fv6LP/gJUIoGjjPPChPtJlAku3uXnYC
         /SZRusY57LpgKLn+nqNQHUwY4RtpmZJtM7z/b0phedDIvGRybqniCe9JtE8vJevMIf93
         fkE09vMljfV3pj74+7/NhYZcDJxsgdxsJ0L1xoHwAsfWl5Fz0m5G8z7MKyVpHA6G98tZ
         Bv+Fg0dNN1LokIX+2Aq75WKUsay6PreNPnUIT6JIjgZlvPzdq9WWNSBqzpc7/ZpCxT9F
         OUIDjdrs+9v1TKGZg9QKaa+PJGW22idxN4bMWOYF5NnBGdCdRm8XzHBEsuLj4KUpo1Y+
         TyuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714566347; x=1715171147;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JiVKU3GODS4dwlptSTMaoTCW/CBkEG4u9gcmVKIN794=;
        b=hSSEifdzlKCpIzw76jU2Pfp6O8BeyqGQDXHiayCS3IyyU4azaP4eUUhvYj9vwRoHIF
         Zo1JRYCA/jM0uAoyaO0PNSDbRIRWCi91hZFN+APImaNf4YsTLz8ae9eGWHhA2EAaixcT
         EtB7D+6duO7clRr4aTluLO/kIvV7t3zLbDAmlhgb1kL0OvoRZ+od7la6en3+T5hQXJCV
         vB6ScmZaKkppbtYqjLxrZrn9RH6HSWLFjVXel+eDmRY9OmyhTIBZygz+nfQ4umrI9uSd
         QpRy+BSHmOu0L4arzvodMHqAdKlSsBuSAK5i7I5aPnSfJQDtw8mPkk2Pos1g4tG/CIcl
         MjPA==
X-Forwarded-Encrypted: i=1; AJvYcCU3uKiks2YyJe2fNUBqrLHQTbsC9cMJZomr/tNwr8iLAEFn7UXXc94tZs31EzDtxxG3dwwgXzdKXlZtsfrhApZj7PDucGYcgg==
X-Gm-Message-State: AOJu0YywY2xUzEC0U7uxOuAzGh3DZryJPSlZd2NJxOovGBEX29C+EXPy
	UZa1/Y3zS3HTg+ROdcdAhP7DNZ2RoShcITi2R0xJC+hjETM83uRjC29cupH7zCARap/C9biJBK7
	VN3FOAHvIRh7oqBVT1lEaCj6AfMKCIa9VV3ro5g==
X-Google-Smtp-Source: AGHT+IFu7bWRAod+fNBklmqwmdOx9dOl716oP5Qi4fuEP26czGC5fQL/lUqerfzxAy382qDKgagM6DDf6j+5N6sB8SA=
X-Received: by 2002:a17:902:cec1:b0:1eb:1698:ea0b with SMTP id
 d1-20020a170902cec100b001eb1698ea0bmr2947039plg.6.1714566347519; Wed, 01 May
 2024 05:25:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240430103058.010791820@linuxfoundation.org>
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 1 May 2024 21:25:36 +0900
Message-ID: <CAKL4bV4UNZTAwz1Lge9qXfSA4dRwZp1NVgv3kXxiwzEhPxfDyw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/186] 6.6.30-rc1 review
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

On Tue, Apr 30, 2024 at 8:08=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.30 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.30-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.30-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.30-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20240417, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Wed May  1 20:29:45 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
