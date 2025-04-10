Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DE3267F64
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 11:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744285076; cv=none; b=fKDmSLuq3OqzUKoOvmvaI/iapLxGnfx+FjArrnze29+uKxXpntVOejzYth44PbVIYWaiqhOaF+74xtJWD/t8eHJKMAfae/Ogo4CWXMPEXr4yrVcMTan3m202HSjAyQlkP581FlzUd116S2unOeveda/ZPb6l4L1FHueU9PlCRs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744285076; c=relaxed/simple;
	bh=0Of5U4z8afXfK7Xi3Rsr1a6ex6vo7JrOynH81ykhVz4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dTksWHfpU0gVjvkpdc2RAV0+hdzZyrqElJmkl9Ytt4Deximr7HMhw+bLObwBSwIPrGzzqCZW5gBYH93FDvtf1aUimYc3q3Hrwvs6V2LTdlk7ok5IYIeTKUBG4wwNZ/QIz5M6hxHU1xQ6G69KXgDNqIoC7GEepO7EQ0B7PyL4Bvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=wckUaUcr; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="wckUaUcr"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-af523f4511fso663021a12.0
        for <patches@lists.linux.dev>; Thu, 10 Apr 2025 04:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1744285074; x=1744889874; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0f9QEAX1CJe5R8QcJVmzqkTEC/iZNvG/J6WAAg8e6aU=;
        b=wckUaUcrcJUcBaf14lUkv2oBCHe+4UWCRPjkHVKEGPrbbesWj+NxmEFTh9r3KMOX9t
         P/8Yy6/CTIuxDzYroTXHr6A1L9m3hxIGHdQcYNaT78WpBN+M69TjK2PD1G8euiXCsk1c
         O0K8Brp3cH5V0z+25pXIWQs+ZapPXpnijfo02mMBNf6PH8DwRccNue4p41Yhlo39O8Lt
         qiz24mlUg/6wgGPMPAIaYLN1nqYGhUETilgXA2AlHEOYrTYWM82xVlbp2HwNwzlD0zry
         QPWSsPf6tKwKifko2jwZ3dMSJN/CARn1aQxrTKngxBbSsYukyIxLGwQ+8IJoCDL2l3m1
         To8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744285074; x=1744889874;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0f9QEAX1CJe5R8QcJVmzqkTEC/iZNvG/J6WAAg8e6aU=;
        b=PVjKW3PTdN9GtAuIjosJ1IqiBUZJkBJ5DwS+DiRf9lHDMtU/TGSq/TeVrLopd+ZZ1w
         mpuVvnC0fujSCfkDB2UKzsrQSOokpMcyxQHd208S4VdTHzhioPAmLo+fmtf1WrBVXbJ9
         45MYqmrpwy46e4uaow3em11Caw50Qo9qTIQpyp5YNvLnwkU5TmJlYNriEKkw76l7eIo1
         q40c3Ll7qO01Pley4o2K2we72Rbwb5STCy1a3jGeYAbPn3YRhLREdFYmLTgprtgmHCqR
         t3bxkbbQqMMNnUN4Zc8FKOu4KJt4F0neHNMNxsWsLER8+gt1tdJntXKa6rvpgO5E5enp
         OIBQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+WUOgp+BJba7tAoudqgduoanZ+SQjb4Q+5iJkR/EJVoDFeoFLlRu7qPti9TsR9ihdIY4lxezJ@lists.linux.dev
X-Gm-Message-State: AOJu0YxGdKnHMJ1bUdhY8Wzo3GGqlet+n3Hk2hRzDfvGNpHfPnLWW97R
	uoxEGseiFT6h660lXypHspVv4j9vnbmwOITFqvEylLonAEbOiVlIP1wu3FrceyJuEvwrmoytB5f
	qrld+6xKrobcXpg7mb6q6lLphJnxhOOK8JkJvQA==
X-Gm-Gg: ASbGnctCNJpWznWOqDVgdasgZZIGEGa4sA8NXtP7f4pbw2AR6kGd1bpkrKgsAV2jttC
	bnUScEj6mg0VlTQLiGlNeJSu4KQpMWLZ+tM7LIGGF1bD2+51RKoM/UeQdJ8lfmDCYpUqhICYGIs
	/NTlD787dhrdAG4EO19kxdxg==
X-Google-Smtp-Source: AGHT+IFf9b6rD0mshIXEsi9eKtMgmQeW8WAUbIpHUW9028hvz2quBzJ17jpTHpfufL5MoDKUhrB0LBxePV2EC/lvj7w=
X-Received: by 2002:a17:90b:2d47:b0:2f6:be57:49d2 with SMTP id
 98e67ed59e1d1-307e59995eemr3269202a91.17.1744285073875; Thu, 10 Apr 2025
 04:37:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250409115934.968141886@linuxfoundation.org>
In-Reply-To: <20250409115934.968141886@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 10 Apr 2025 20:37:36 +0900
X-Gm-Features: ATxdqUGFfH4m7c8SppFhuEE7O4S7fKdsw8gN_V0ons2x8pr1JB25QeDueDaMLTA
Message-ID: <CAKL4bV41OA2u8LnGk6WuC_5sO8moTSK-w-U2r0yqEQ+fbFsTGg@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/726] 6.14.2-rc4 review
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

On Wed, Apr 9, 2025 at 9:06=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 726 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Apr 2025 11:58:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.2-rc4.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.14.2-rc4 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.14.2-rc4rv-g2cc38486a844
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Thu Apr 10 19:57:30 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
