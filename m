Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642501C6FF6
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 12:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742993812; cv=none; b=UK7WUBWswpFg20Sq5DooLMhWTRj/kWFxC1oDd8IPEiOsIqrK5Hr1R9YP9Q+ohurfwBnx50iV/UwQLzcbcmvrlV/PmVUczoLN0LApafvo/Wyg7kHMhmWg7wO8wVfuy6U3pl4rTmfXgYlHRc2Rla4PeZQNpZRcJ4CE1VM8mmT2sFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742993812; c=relaxed/simple;
	bh=xvdRNCWSoMb4LFMgO8nhLmxtocYZrWldrhUAbUspffI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lCGSNU41YJHScqNdFr5zNgtTFkPKB4UvWZ0ZhQw5UCwE9dYbXXQTtzaAqtCb8f9Y9DdcR4rpIg3yUMLCYEK4OLBZMwESDkwBBHOkxc5nkofqfoiskCiPg8KncTOaxVSkFaM6Gm8UuBnJud5/AFvzB8ro9h4dzDofgF+Jr/zjwSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=EFKhVZ1w; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="EFKhVZ1w"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-30155bbbed9so8951050a91.1
        for <patches@lists.linux.dev>; Wed, 26 Mar 2025 05:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1742993809; x=1743598609; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRQTudAEXM13GUB8NKDUowp/QnTU6FFua+8YuPXk7Rs=;
        b=EFKhVZ1wbUhu/LIgvkQyUGx/AlzaS01i2a3xbCQv11X1wk59bKCikdY7GcI3bp8orc
         WzPJTUw2eEX7rbgpAY5v1olEeHKH+IwLxJ0AA1rautcubmGYAahXOGCBLekHW7OOPcnQ
         o6PBE/cIZkg24zNI8mNdBJ1PwWZw9CWz/oI3ij+AnDL36jPZWqMMa840WZMhcoNvxjw5
         ielGgxZaS6SAhEBq/dicsH3QO7LHtJiauGGdXDbUK2CS0K1bDmS9CU6xykUIemDoDHKO
         xMbiutWbbTdbsdmuGwt0KUKcdizUovw2K4To6erfV9eXVGPzZtrG65UqBiyh+WYePWUo
         lsdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742993809; x=1743598609;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dRQTudAEXM13GUB8NKDUowp/QnTU6FFua+8YuPXk7Rs=;
        b=TYLEIjn4fxzHw4iJ3fGWxQYV9/ujWlkb5jT6dHBuOn/y2r1gBFGQzSs9V/MnwCWYA+
         9s6/UX3YFj+Dla01fk4HSUuMdnElK+24MCri99s2+LI3kmoQ8pWqXJUTHMdckgWxhqHR
         jiGST8YfkERRb0A8grxjz5zMwZn2DuVLYIjo4EMF0XQhU4tkZynyLyTftzFZH0kyQKFw
         I+wtEPYCaIbDBuZ8xwbZbmilRFksX4nBpa8ux8CgEpcW/P32ZsdP6ThWdO/nKlhb2m43
         V42quu60m2Q+xh8I4oc8j4qbf3ZFSFKz17g7blcChxYB/hMtJZIPR5O8ENDz1UX+vd7o
         deoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPNeUZm4IfzONMbvkGjC/GMbHtF9DeiA+l2hqxmKP68ZiL9R02EneM8m+YBqKs8K9g7CwHKbho@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8Dh220tUWep/I1ax3cSFVk4Jvqd/Lvsj/fmcTKWpfDb+30cWV
	f0vsFSqQHHsYDUSQa6VtyPeSomH4Fy+6l5BfsQgtWTOYWHpuP+rgIiu8TrA2SIZrF1Z1hayj/EM
	v65F5rYj4CBOv1llnSxP/OIAAA5xCR0DLI78Egg==
X-Gm-Gg: ASbGncuK+XFTCwOyMxMNUc8VRTBVaMzl1ffbSwdiZwMksLG+REJIE9J+s5pzajp/hBV
	IjTOoCtULLB5hgI49au1Hkhdf3cFlZTcysOijIgYpo67ZE28jlbzX/k2Yaf3hX61hk7Kvs8K59H
	OwbPY+BNvuCk/XCMYrP0R5AzKTqA==
X-Google-Smtp-Source: AGHT+IEHnIi6oFcX3sSPTlCWyPe5+ORCR0E86AOeljuBB1GhwoNwr9EkT7VwDALSkS463AkNJD21fbYSqSYAoxTdCy0=
X-Received: by 2002:a17:90b:554e:b0:2fa:228d:5af2 with SMTP id
 98e67ed59e1d1-3030fea0d35mr35976364a91.15.1742993809451; Wed, 26 Mar 2025
 05:56:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250325122149.058346343@linuxfoundation.org>
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 26 Mar 2025 21:56:32 +0900
X-Gm-Features: AQ5f1JoR9ImdCw0Rs5T9hQLB-tj_Cg1W61XlOGDrmHp1wfzXHUlPxH1S6OVVqCA
Message-ID: <CAKL4bV66BuvB=-qkecDrkRw9AwOxv7pF6CGz_pLX28DQ+Dgdfg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/119] 6.13.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Mar 25, 2025 at 10:13=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.9 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.13.9-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.13.9-rc1rv-g3d21aad34dfa
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Wed Mar 26 21:01:17 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
