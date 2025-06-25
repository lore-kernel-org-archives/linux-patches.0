Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EA3221DB6
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 09:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750844443; cv=none; b=Ua/rPPoIJGgM4qkv9MZcyuut6x63rlaK85udjsqt+iufApoBahzBk3l7Ba8bsWK8BOcnsTbxla5h89/BxH5reeEd56EYad2e0nEriXnUczJWIuvvPkxRZlKVHgcddj7yTEb1XCTsBa8Lb0Gv7u0QhixoeEG+yZPqlvXA4gRBYSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750844443; c=relaxed/simple;
	bh=tke04Hr1GWdS7lu0c+9LoPBNgUtdJPK/syvMJuc6KGg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eCJyPXB3fq+RGwG9RnpojUE6KpyRWc9/OYbYCcISpHNWBoT3CMdEhph1qzSSxdg8AvWKjRwnAOPC6/IE7u57/NAzNzufSTTGrKqNXkSPuWmMaCgvMCcF8nGj9yk3MF49KWxRvp7tsTG4aSPVCmxpNdM3csQs1U2MP6htpYtrR3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=tOV52num; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="tOV52num"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-315cd33fa79so1261300a91.3
        for <patches@lists.linux.dev>; Wed, 25 Jun 2025 02:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1750844441; x=1751449241; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1M0yLkQsKR0YiyFUjwpWUZCh7qwBerDpMZfoZtVAIXs=;
        b=tOV52numKRKtO4f9iq/Im6vtwy5Rg/l107SL1s3HjlCC72kf1xsSTae+ZSTqDm8NTZ
         3oDO1oaaKWIXgFn5ybPdMsSQFr0mCGi8Rj9iDS+TFyHby7Y9tRDmm3P8r+ZyrnK9jvoU
         /EUkpj+ymRg/FORo1t7UaZed8gnKcGKUQBVwQmsMozctMEMqt5n9GHS4X/ppJQVYZ1GJ
         UExqcfpTd7sSAUkYM+E5Cy8rLLCPOYQb1g+yQ+FdD7pqiKpR6DT1WCtf7AwwwXPmNYN6
         GiMBOmdXjDIlZ0SEVPC7YF83TeY96rSPeKXotT5e/LO2UKkl+xfF0FeHH3VXu1Vf5MrQ
         39Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750844441; x=1751449241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1M0yLkQsKR0YiyFUjwpWUZCh7qwBerDpMZfoZtVAIXs=;
        b=athp4VWQxThScugm2UPvqefmUK83ud/7yqR5AGu9IREmKd2cJr9CGe4vM5w9sOtWVr
         l3rDAZYfeI2lJ59oN4XhPXClnFxiGnGtolrpB1nLIw63K/XMuIvFuwdEDTaBqxTah+YC
         gjIiLDf7tM2lvxmitIaLh0/0KPCsCQSzZN0dnKDe0GFTLG2HaRbhIKjTh1tJfxsqN4Ms
         JuUvWJcA/08/49cryr9yc9DWX53DNe8s1JUO0FKfe2KwrjwwIMEVxvxYRzcw+mW0R82m
         baB2YJwUGnBjN3faihvrA2q9+c0qXAcVOZDy3LbRbm/YVwkhCMgZFAOPd8b96ChBBxSU
         xRQw==
X-Forwarded-Encrypted: i=1; AJvYcCVGDdmvP74AWvmP2dQWKaGSqY4j5KrPmK+FqvKVGMUFpgbZRpJYYrU/gDwFoIgKNlB/LMyKyHUP@lists.linux.dev
X-Gm-Message-State: AOJu0YwDMy7lfeZhG9QgmQEL8fifAgjeAdFL3NL/Y2/h7ORZYVTAjFV1
	DJ3oiqKyjmo6SRzljCRnP34hbKrJm33TCywtAjz91r261K3+y2h/xDN8wMfYy94m4MjRcp0qcgM
	0pWbasrfd89Rd7Jh8eaK8bHQiIrQ8c3us1e3z1UNwzg==
X-Gm-Gg: ASbGncuCqLZG3FOCejL9PFB1lEHjhpKxM3ozcWl5PbADuB+bXX/HJpW3L/0FyJ+yMeo
	SxkuMCENXlDrPaTz1y+bKUjPjCSm5LZy+0zSSPn1LtAj8lXtCF5ex2SpO6SqLS4+AFx51aMf+2R
	YrwiMxkG1vEV8KCb+u1kP7AFL400pZkxXJUiH4iaNH7xTnD97hDwCzCA==
X-Google-Smtp-Source: AGHT+IG00K/kpm2hTa2fP8BKaxOCVSF0UfugUyd93dHVunRMl1Fz8O1C+j++doQt83NSid/RhkIlZIGfTM7Si0uMsa0=
X-Received: by 2002:a17:90b:1c81:b0:2ee:6d08:7936 with SMTP id
 98e67ed59e1d1-315f268a404mr3102280a91.20.1750844441510; Wed, 25 Jun 2025
 02:40:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250624121449.136416081@linuxfoundation.org>
In-Reply-To: <20250624121449.136416081@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 25 Jun 2025 18:40:25 +0900
X-Gm-Features: AX0GCFs0Ue24bpACExUeXXuPVoyD4JIFjJgBbT28iyUyE73zbAYOm3Ich6oFbxI
Message-ID: <CAKL4bV7CD4udvk+-k9ia6GSKoWJB31Su3LbZG6k=9o7joTC4Pg@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
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

On Tue, Jun 24, 2025 at 9:31=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 588 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.4-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.15.4-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.15.4-rc2rv-g0e4c88a0cd37
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Wed Jun 25 15:02:33 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
