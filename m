Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFD42D039
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 11:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="g2vXNy7R"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6c431ca7826so563748b3a.0
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 03:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1699354983; x=1699959783; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PC3d6wWHpqdfS4D388YBQ7NgpKv2etiMwEuLXnGK4bI=;
        b=g2vXNy7RvxjczAvwuGsQJULJX3w94iq52nZvqWFPJJdPkXtdwzQ+yf8XgEFX7wvUjw
         TRHSs9OZ22d5/EmREa2u7AQzt8VL4zPU74F879JYZrnkOIkC1JRRdfpaaFKxd9+nDfcT
         FYCowMK7Bj6nDKkefXwxy70unBzJPLHrH0q5uVMzwrZQ4dZO1pRIpwjWHGPnLaKu8hnG
         CCqZy07vx24f7a7R1GeLfldWCzG5IaN19aHBJy/TxRqecqWVyxj+kz6v/jcY/1lQClEu
         nnrI3DXpnhKyGCkyCqjDKLV/Ci7KzmO4158/m893HDDweS3Qvk1b66L4s+kMQNPj0r42
         Vymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699354983; x=1699959783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PC3d6wWHpqdfS4D388YBQ7NgpKv2etiMwEuLXnGK4bI=;
        b=DJp++Q+46Vnj6CsYooc+z2wZnd47NaJ0VxMjbvzB2jLq/g/JXrfxThEIKtdEO/68NP
         N+xJ9Dpzx94siGpFHCp4HdFjtxYeT/PCjyOMI3Op90bGJn6Cr4ScB6vTt+06vYEhcrhN
         vY1FoapGt43t9gysfeTDQdF3T/p4kk1K5iuJLB8bT/Wcb9J7WjfWpHco8kesw1dJOMda
         mRNKfG6qXxLQpVFpS3BVrj0DoJW36wFfMR31FEyWbAtLeVM4Fe/+lttCkywA2egwqsSk
         mMC5JxoKYnCgRvM4qnsAcT0TeYJddkfr7/CpQZmJElzcmW1RmdcvwykYyx1sVg97I7hX
         9SuQ==
X-Gm-Message-State: AOJu0YyTH8ZrvjWG4cCSFmXmCLTCgAhWxJuUDzDLKBOBOgcHO0khfUds
	du7OA5/HDov31bMKCieF50qsqrUXWv4tqJJ43xuoTA==
X-Google-Smtp-Source: AGHT+IE7iI43DIi/hwt3+oaAr9mreCpy5srt9xD5cwQpQTRLmMVPxEuYq0iKgOPV3XgIuhu7aw/nsI9WwKAbjdKwRrg=
X-Received: by 2002:a05:6a21:7742:b0:181:3dde:deeb with SMTP id
 bc2-20020a056a21774200b001813ddedeebmr18127765pzc.33.1699354982747; Tue, 07
 Nov 2023 03:03:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231106130257.903265688@linuxfoundation.org>
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 7 Nov 2023 20:02:51 +0900
Message-ID: <CAKL4bV7DhfiRGXDTtMLvHjEKYApXyOmH+6Uvs5y1SWkJN583DA@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/30] 6.6.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Nov 6, 2023 at 10:07=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.1 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


6.6.1-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
