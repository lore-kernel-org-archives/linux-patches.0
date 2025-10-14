Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E72307AC4
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 03:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760413228; cv=none; b=E3MWOvT7Mq5IXcl32QLgaZlFaIL36lG/Rx+YokrgFZzsCqdHZ5T+lLJC2CuNpAh8U8JSsQCNd5SRohwl63qryW5qS2f6JnnXnH1ghLS5h1WER5lfdyqywSj6W20J2/Wvhl6vKob6wvIL2c3bFRnxyb5wJCd4z8eyEhr8y314jh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760413228; c=relaxed/simple;
	bh=VKGntvZN3GtJcSSMa1nguMCR6YJ0j+Sv/UrDmr5viNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uQuWyMLDfPX2njLs+O87TLv6a10LQ8qle9JNvV3EL3+ImwUxDGviJBVOUjz4EPSF+FKoZcmZltQj8gjpJ1JCN57U8WGrGjj0JiiL0Utxx58KwY/BO90yXu5zVe85/s9+H5zChMIOWAJ0beytlP3V5OsughUdPvzSdua9WhPWpAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Y28mGdMp; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Y28mGdMp"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-27ee41e074dso56206915ad.1
        for <patches@lists.linux.dev>; Mon, 13 Oct 2025 20:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1760413224; x=1761018024; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8vQD13QPg4OYqU4LJRXtRf+THjzsxA+16HameJIJG8Y=;
        b=Y28mGdMpxktTIM50p55TCHR0EJMVoeCaDaXCw0YJcx2FXolU38isLxLeze20YdoPKs
         JunonR9XOH4yYICG6S+d17AkkNZXpl5JltY4WO3om3gWoDJbmFkdw1uJUe8QVzjJJrqZ
         IJm+bAhBWqGIpI7AechDw4PGCaaXOClkKVUTXLBHmxQMypJf+Nps+dyhCCZbkmh+lerE
         oiidTmrlmDK+03JM3qdqqLsDVZVlG49wuFcSH67+O+sP+pyixQy6YGehwaKErNcCSYpW
         bKWGCavq4/v0NYhgqCOeMG5DLtj/VnBovFKVickdnyakKiUd/d3zRYNJynCsBjUpJQ3W
         KPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760413224; x=1761018024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8vQD13QPg4OYqU4LJRXtRf+THjzsxA+16HameJIJG8Y=;
        b=qljmV/MlUVANRMCGIECQG7SNSCccXMY/ZIt6fX6I9fzKN8s+NPuBOzU+xWQ1r/OVDd
         ZO/G06BDr59A41At7+A4HU+c9CgDvGHEvA3jXRjDaNgGwY2cvriq1g3mMogLS/bYa4yS
         Ic+NCfAESrDSqNj30C9zzfgs/7hLBBpSffRi9d7iEAVkHzKodTyQ/yaXtWptt48QBIeg
         5Z7VKglJn0ASigxbpCv8FnikUB+t3VDkPwtrYJVxMfT6tmFl2HQBERKD65WMfOF6I7lK
         q02H/6beLKum9GkLCYRNJR6XBYDvQWgQNgBpHzPOtoz5wpeOVPuPitstQYdlI1+q+I9W
         gVdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIbteaReBdUJ6P2jrXm+AsOpgc3q6/LrLylUZPWpto1SUbfoy93wAY5otLq765Qf77SrHh/h2W@lists.linux.dev
X-Gm-Message-State: AOJu0YwkiC+gBW5duz3qZKs1Jp/B9d1E6pX+dTHmUcyAq7m4wCcWQECw
	xRaPHm94jEEaA6LOBbMpG5Fqm3j4AVoHqUrHplEP0S9wfwxDikY96OqoJH2mAJghZ3N2qhJ7wC2
	ZLF91WS02choC6bhllGGcMQvRvbluWMBteckpdbprgw==
X-Gm-Gg: ASbGnctEdpqHw43Uz8Wuk/pzlVWsLlEfyJNayPeDWcBszfRl8kzMMLOOcFVvv3Yai2U
	qOBhO/ZXfIQMPTD7tHoXKwNBcvu0vT84mu/EUSc8bl0aWP/ddbQdP6TIqb2PlbxIW+nBdFpPaPp
	ceXrYJiU+WMUf6yJszuLDwAJttuEwpsv9ywl5XlXqQEEInOMYwyxqFJ68sdU+8+lVo04Zb2VQWG
	6HRlq7Y18BlY46TdgIkdxA=
X-Google-Smtp-Source: AGHT+IGsxs2zB/o2HDMRrXG0CDlIO/I666LTqgKADPiE2fPpkCQ25Qw5JRCeUi5m+2HIo6aoKW6CFhEClCT8ijRr2z0=
X-Received: by 2002:a17:902:ef07:b0:288:5d07:8a8f with SMTP id
 d9443c01a7336-2902724dc52mr282297695ad.24.1760413224085; Mon, 13 Oct 2025
 20:40:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251013144411.274874080@linuxfoundation.org>
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 14 Oct 2025 12:40:08 +0900
X-Gm-Features: AS18NWC2Fr-gWwcy9LStVOnnGEG1wp1A2vfCsJcVgNKnq4cVcnZwA7crRcv7UoQ
Message-ID: <CAKL4bV47oB56+6KG5btFQOqMtZUgzEhMibFScCSyduqiqaVQ-A@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Oct 14, 2025 at 12:33=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.3 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.17.3-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.17.3-rc1rv-g99cf54e7bd2f
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Tue Oct 14 12:16:46 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
