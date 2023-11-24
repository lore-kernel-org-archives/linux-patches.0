Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CB02FC4E
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 22:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="QN8byp/3"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6c4d06b6ddaso2018778b3a.3
        for <patches@lists.linux.dev>; Fri, 24 Nov 2023 14:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1700864972; x=1701469772; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wtO7rC2KdoTCgc8G93D/JqXyAf1FXvlF8iNq8cF+6uk=;
        b=QN8byp/3gN3koiRSAOClIJCdBKYEXetp3SwWPNFFLGHqjBeMF7ElW7bOa+fsVJwXvM
         cwFr9t9t278UN6rYSn6SPwtJQhaIkDIb8bT0AD6v+2msgVydDjb3mHzuULzL7lZRUxp9
         +XhIx7J+WO9z74rEqU3cJQX5iNFiBduK/rV89BXy5e0NnR9YVu3yLe8fE+nLiZ9gIQKG
         jrMueYLQ/aKfp0XwNaADb5DH4BzLNJI1oQJ27VH2HQq85AwU9XGUZxYzpy58gER8U8Dl
         8/CCSAQELBTk6OuVzQ/ZxNr53BKaTBKvGuBnBk8GpIWIumHcm1DnhdMuld8vaU1gwJjJ
         UHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700864972; x=1701469772;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wtO7rC2KdoTCgc8G93D/JqXyAf1FXvlF8iNq8cF+6uk=;
        b=h+9Td5JepjX9k3YLz2h5M7SzVPEPlBMkT0rKhX+AGjd6/Q8rHhort0h1JDb1MU8VXr
         /iJ+ForVdTefy1LJB5x0/KgDwtbT/cTsKfzfHSs3+dMnF5lO32bKTrFFahu574204FtL
         QHgzR5xC6CcxTTFQ6c1ItqJx5WX8pVoc4aclw5OWtbsl9l7qsHd9GJkskBM4C0bzX3/s
         zxUuTdoqMUAGobyL+J1v9IPpvBnTcrF6wkPPDPCZpxeeh39VB9Pt86saOQfR2KFF+aPS
         Z71mjUyo1562HPPMVxSpoyQe/IPZ8yfQO4jBBeeMre8iVdpvlaFkph0WiHUTCkToOZDp
         Qi+A==
X-Gm-Message-State: AOJu0YzKGcIkl+t2b+KifDwMP3RKwPfXEVrUcqdfUZZC7A09YxZIYAPb
	Tf6ERfwT212p4D+acTnKDO8vj6yMi9lzEjaJug1fAQ==
X-Google-Smtp-Source: AGHT+IH5NbPttjWJkpecrastRq53qLAAtUK4Oazr2S/MEe65+eKyE/40H+jjaEPBL+i3tRuz7vCgnz3jR8yu91mspg0=
X-Received: by 2002:a05:6a21:3998:b0:18a:fbd1:8e1b with SMTP id
 ad24-20020a056a21399800b0018afbd18e1bmr5700264pzc.26.1700864971900; Fri, 24
 Nov 2023 14:29:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231124172028.107505484@linuxfoundation.org>
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 25 Nov 2023 07:29:20 +0900
Message-ID: <CAKL4bV4T4ncGqfZB-qJO8TE3eoeSGsb+f9AXKsX1aUZOj=tPHQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/530] 6.6.3-rc1 review
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

On Sat, Nov 25, 2023 at 3:04=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.3-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
