Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4FD20E7
	for <patches@lists.linux.dev>; Sat, 25 Nov 2023 21:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="A6QuEEjr"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1cfb3ee8bc7so5909745ad.1
        for <patches@lists.linux.dev>; Sat, 25 Nov 2023 13:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1700947560; x=1701552360; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZRuUkwAJQSc2B5TiukCCmiozHQbQ8NLMPMFjeYqUcY=;
        b=A6QuEEjrvhqlyeexQrFF1UpQ+cqMZylWw0AISG7sw6f0Uz36ldLlqUCID5uFQsqgtU
         K4dHl1VR8KTtDCm8Y/MwBsrXHR/t/k1TdCKq7d473NUWhhqQpih9vS2YN4yq8KuwZnGh
         W9K4iU6fKVFGYK2ZJeIVRmbJ1HSOkAnGHxl9srSRSWjpIBaF7ZArzdJCqOC/leCmRFd/
         T0S0ooMuDN2gntBGgbZMRDJNtgg28mY+53QvrvbmOXl7ibsWTb7IjukPqT9eHzz5L6jG
         fXTAHJZ+cpDv/JEzosch/0FDAam2YkfCJDqgbxGVqiL0ErZVIfa9jqd0pmvH4hFJtoDe
         Vqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700947560; x=1701552360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZRuUkwAJQSc2B5TiukCCmiozHQbQ8NLMPMFjeYqUcY=;
        b=ksXNOmDFcAroDw3sHPcloUiRd+XyCKHLlRGpV7F2eMWvkqI3p77H6dRe0Nbk+FhIMf
         hMuFwtYy0RcFHB7sMk/NscWvMMH5D/g8mJDA0bnY5HuuFMa39uRCLq0mUxHQJkCb6OKO
         L3w7y7RTHAjes8aWvSrLCmjQAu4HqWrY6/+DkCgRWkM2TKTQR5pRRsGF225lVfjWgubo
         XRXe+nuIM0YlvUf4VYu7LE6kNNLaYItNo8oZMhImfS0V5iScG0Y94/go0MqUYO2XeawH
         X5gqQOm8kXFudYnp/lvfW5jDjDzuxLbE7AQ6deuvwjavGYx3aZUGSTKTurq8vBRKIo8Q
         PXpw==
X-Gm-Message-State: AOJu0Yy/FXZ0d3OKl9uUGc+gfXN/3a0r4BKfGem3wCoObnMWX/61objP
	Iz2wf4aC7Oa8Z9PppcKWdW2iOQY6jsOIEmF+RofYMg==
X-Google-Smtp-Source: AGHT+IGTUTKj+kSrY+r7f26g2zZ+p3i6caFNXxcPK1JnynJ+975K68HCL04h7m1UuQQ7vEmVaqfUL4Z+n9UO7j24ESQ=
X-Received: by 2002:a17:902:ea10:b0:1ca:29f:4b06 with SMTP id
 s16-20020a170902ea1000b001ca029f4b06mr10068270plg.2.1700947560518; Sat, 25
 Nov 2023 13:26:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231125194417.090791215@linuxfoundation.org>
In-Reply-To: <20231125194417.090791215@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 26 Nov 2023 06:25:49 +0900
Message-ID: <CAKL4bV4DwJ49GLjiP2qE1dhiWtuLn2ybTWju+QFNwQfUckTr9w@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/527] 6.6.3-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Sun, Nov 26, 2023 at 4:45=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 527 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 27 Nov 2023 19:43:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.3-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.3-rc3 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
