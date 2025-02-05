Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC27A21505E
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 22:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738795345; cv=none; b=sFMu18NfNwMR7ibHcieah1ycQbIorYqbk4Z/02AUHWbVR5py0uAFrcOdnWMY6CkS4UMcyvozILcF7yWZfZx2Ej20sijkMtj2k6AC4g0OfMyspVUsPwFvJIbIRwLz9Rh+SdFmPwxBw1rCVVU2LtO/KPXZ5y2tGRYEErBHQ5jDCe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738795345; c=relaxed/simple;
	bh=/ISQMuy8TJweFhV9wi+G3bCohIloJCiIhAsDlnXTEiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jshv0MnAmFeypFmxm7Rd97dV1VUYM6wijIYNuwXbwKYt19BbPgQj4ksIWA0LINUtVx8QMWSDq9ukztdkIouoXRSLgNGyrwNzSww0RYuJgkvd9gKEF8MVHBiBG9d4vvepolUkyzdiRCEmSQplZ0jp8Qb8xswba7z2dwIyreu3F4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=riPAEY4p; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="riPAEY4p"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2f833af7a09so301216a91.2
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 14:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1738795343; x=1739400143; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ozsWjdqVYNU0uRL31d8089cfXtCPdIVCrl4HE0WQ7Es=;
        b=riPAEY4pCR1XDo4izGslb3iPP7kkJYWPr9GDtyxPhpNlUUX+WyTkean1d7O4VRTvmO
         PZVzReTgAkOdejvCb0usQG+i1/vW2LUyzmn9deDFDG06XkCrlsho+09SyEHZGljhbsU4
         Up3iJ59JjKd3Pq2MacAxfO9xxDSKlh7e1fNC929Yfa859GC3griCOD1y9moUkxvTszM7
         gi6CDrcJ18jey6i8okWsjiUlpiPgAEiVKXCyhIgCWoGISGgVOcFCxMwAbk4IYN4+uCgZ
         HV515hWH7/GqR9ULHFu4CdD83oaLU2wHRWTSlR3+Huwj2XY1A1LrBKSMexVk7HN5D3L4
         AR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738795343; x=1739400143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ozsWjdqVYNU0uRL31d8089cfXtCPdIVCrl4HE0WQ7Es=;
        b=w1dRlJSss4OrcljEpcq5jY6/us9Ldqi8qfkJqBRDMxA2VhiHCGpxfYUUY8Dd44ClZA
         kBPNdF/GUe8rJM7idQWuLFQDbtWCeNCtOHUIjhC0NZwuez3S8rSbDCaCEmd/PHEwoYf6
         HGG1xBwxw9H0LikwHYWuBwACAMpNsVW9Nx+1ePLbskjjhIm4Vygaa0dmnCKuqS+UlCH6
         T0lObAz8iZUnMM/bT74wgl+33l3GxtZZDnVz7hTVJ3nsfUBLkicZo7r4xXnP8IrsqtIx
         visnScXIB1PlbzIrycT5y3u/dkDo8quwxcS59rTdwYagwQ70p4A1nTCJru986XXtV9W8
         bc3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUVND6e/p5L+dUQxcUa/zcqf/usRGllmo8fkDDL1laPXNzrVDRMWCFAn7qpQoDEQF1eOP4NaJ56@lists.linux.dev
X-Gm-Message-State: AOJu0YxRyfNi9A4RxXrS/kYE/eSg9eLsmVFfAfVF9WxSw2fHDG8LG7F/
	d8ilK0ZujVlE9BZL+q3BvUmXHsVMnwY2gXpK8isN2C6eHHo9xmboNgSFBzmmoXc1Sdr23GqLdMs
	TBOPzpwwCPeZZo5jeAtde171G/tBFUvVNs0EHBg==
X-Gm-Gg: ASbGncsoKD1xNlSTOi7Zhy5i29TzeFYed4JE4kdjEMI4uWvSSxXiofLPZWBGIpdUPd8
	6NSVHunvjGwIPvK9Mec3QoPMOdL4Ie55bf/aCZFSLbQX0Ljio2YKvoM/sQyG8sGBX6X4ZBw==
X-Google-Smtp-Source: AGHT+IF+5Y+LoIrO4YuSxbGFrnDo5RLIcaFRLcMBgHRINZAU5p3dn/ssnoapM9nTRlQd+7IHrseRlLHy/LjeE2HNVbo=
X-Received: by 2002:a17:90b:190c:b0:2ee:d433:7c50 with SMTP id
 98e67ed59e1d1-2f9e0834385mr5968269a91.23.1738795342921; Wed, 05 Feb 2025
 14:42:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250205134455.220373560@linuxfoundation.org>
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 6 Feb 2025 07:42:11 +0900
X-Gm-Features: AWEUYZk7lKOEl0-nGgXhekrrvXEexlCIVMEr93PPJnNE3QhYX6lEmgtZbFPwaEE
Message-ID: <CAKL4bV7oXvwBXF877=40CfdvaCTnBot-YSp+H9wrPcTVki0AEQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/590] 6.12.13-rc1 review
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

On Wed, Feb 5, 2025 at 10:46=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 590 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Feb 2025 13:43:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.12.13-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.12.13-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250128, GNU ld (GNU
Binutils) 2.43.1) #1 SMP PREEMPT_DYNAMIC Thu Feb  6 07:11:23 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
