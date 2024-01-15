Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A390919478
	for <patches@lists.linux.dev>; Mon, 15 Jan 2024 19:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1OFX/pf"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-4681b72f2f9so421277137.1
        for <patches@lists.linux.dev>; Mon, 15 Jan 2024 11:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705348081; x=1705952881; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HhSzSqpM4RD5lUwEkRLdlmlmzOc+rc60P8bLEmJ2fEE=;
        b=N1OFX/pf32jVVp7RlJ0finFdL0iVMgaKVh1hwh4ZSr65vrF7a8YjsdibH6koZ22ft6
         Jv7od+QS5Poiw3KNGbcvP7cTJrdp3qh4jn90Pde17lMQDHK6s6p8JN7uHfFAmZVngZGU
         1kPZ2YQKI+o+ngyTI1z40CUOulh5L7Ruvjgm1xWO1WN8Arygsdm9lTzYZ3iXObQoXyQT
         YzN5r9BuSehT+M43GLs4ykifrvM5CI9h5BhXzyBLFLmlNEMeAMtVTYKbT76gPM2ub188
         Lwt7VOTB8t0Pt344vA3TcagjtSEsIjeh8xC+ZQeEnwuig0EgWNmRksEnzNng/OXq/R8/
         dPyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705348081; x=1705952881;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HhSzSqpM4RD5lUwEkRLdlmlmzOc+rc60P8bLEmJ2fEE=;
        b=JgBHE0XYsyy0/eT78RV8pai21el20Ia1fTZ9Am9b+qryC5buP+891iCyvUdx/ac1js
         Oickbl+kuyN3supnt+jTQu+HjSKfknX1frbac3tn48S+HBOKWZ6/xB45Kg2sx+4+aEO4
         z4UH6RJC7cY8k/vPMc5YckAHE/Zeg6DhRhokOoIsHcNOh5cb7EXdJcjykuKNMOXYxyC+
         SQ2/YhjBMMYY1tIR8O/YQRPA/J84zaAsF5wCK46KWnbK1VNVA+S7eV/yRa3odt/756c4
         yP4w3YPgIlY544N4TRTWszQJ5Ht5kVZM6chWYebs3+S75NYvexHIxnqH2aF+VJln0ly/
         PRaQ==
X-Gm-Message-State: AOJu0YwPpwQHAuo68HB4aWOGlsSEAeKzoPJx9Suk7vhR8W6bf8c101nb
	ft7LY8gFy2GsZNQYc87p0okehvPkj7Mf/uY2uBM=
X-Google-Smtp-Source: AGHT+IGgktmkY/M5xIKuehYQ1+S8h1tKJGay4wHBQL9/hhSxWWiM3b6eHLdMrGu4BkK+MZ4cFH175/FqXrWreNJNF9E=
X-Received: by 2002:a67:c786:0:b0:468:17fc:f4ae with SMTP id
 t6-20020a67c786000000b0046817fcf4aemr4170295vsk.6.1705348080161; Mon, 15 Jan
 2024 11:48:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240113094206.930684111@linuxfoundation.org>
In-Reply-To: <20240113094206.930684111@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 15 Jan 2024 11:47:48 -0800
Message-ID: <CAOMdWSLA4SYN_HvJoAAgGdR_KSeeqc5Zyy-JiLcQyM9inPh3vQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/43] 5.10.208-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.10.208 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 15 Jan 2024 09:41:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.208-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
