Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882FB2D46A1
	for <patches@lists.linux.dev>; Fri, 23 Jan 2026 17:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769188153; cv=pass; b=OgFUxAKbsWVnHvP04DvNWOrOof20eoxAyF+x6GDTYoZcSNIVl/4EIi5eCwbnlE4hGlf1QCULGFVc7nZFL+154Q9uUjYnZZ8rJxWAr7QoGAolsJSuYxIM2C5KZqQvQuqmbByHmdctS2lCVWQxJ65jqVwCdgtexIaF3Ou7JX8zvjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769188153; c=relaxed/simple;
	bh=baSVTO5P4JEdejZ7McLW1ShJqiWIQIoZuEP/cZI3+9o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=imAZkx7o0VnvL9F7gK1mslc2DXVCOFLwKwexWC/tqT35XsMjkXvm7h1asj2l+NYYnFMn9omA81xyG3/Z5OSHKf4vG/mM6V5pHMen3msMRqhMUgQLIqx0HxZMdWw3LrDcmKuWDas00e1H9d+iWDDFmErOlAdnt3/SuyNwm8r8qiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dkNYxtKU; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dkNYxtKU"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59dd7bfeb8aso3146113e87.0
        for <patches@lists.linux.dev>; Fri, 23 Jan 2026 09:09:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769188150; cv=none;
        d=google.com; s=arc-20240605;
        b=Q554NJJjAhlxags7LW7tr3d3DTjjOii1xnq3HEEirFOcRrrgUzb7DuhAUI8fiddR1y
         noOou43/m+dTtvkRrJcVg7rqEt4rnsrYcQbk7CJO1b7PJ/d/WkaYg2xg0AfWIeGzFFe9
         hOdLOWCOksobDYSyGfYOwEhCH1d+ouppRyhJJ/eXmVJFmyEGSo63w1VoLlUngxQiYQN+
         vb9LQfj5w9HjA89z2gjVmegUQQ1+7qhlMB1ecdYX4UoB18SZ5D+lcUmYMBwN68Nt6Sir
         ZuEj6/pMTInr8cREnNrMCFHch34TkH1LOWSnDt/mf0wJr7i6k4h2DTRKNKJs9rbaOmSc
         nfpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KDi1jMTaR6KPNr8Xb3B/fDVI4Wv8VBtbYg00h50ejLw=;
        fh=IkEt9Y9XAMGoyb2fGDANrLxfmVyGWIUbJTd64ThtNDs=;
        b=AUI/qUhtDNUR6PTo3ypEP6ulq4aqqSdVdR5Dt23apgacYBQUUJQc4snjBJJKRgw3Oz
         0Qi5mM4dbK+WT2MURs33/6FNRFT3E+Tgp97tB0aLDMQKiJgrtYD0IbL7diP0Mep/he4s
         2UFVbvvbf77gWsiW1yiBGGWCDQ0jf4N0qI3TyhzL6rYahp+R6wOWRtfsEn0YUoPaQCet
         AWiKl7MJwJlOFRBcUFpQ+wwc4d/MEcrs0aW83vs5WSMtrE9ocyrauNL6tIi6Hf7h15b/
         9fzY6Fh4thInlv2hQIyDOI6jbGAF9B/001dkqbycyztfBl/5PfgqO/nKIGRXNivynIer
         rzmg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769188150; x=1769792950; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDi1jMTaR6KPNr8Xb3B/fDVI4Wv8VBtbYg00h50ejLw=;
        b=dkNYxtKU3bBwL3rX1oYOVQQm0AoTYGpLXUrANM5k+I2ow0pRN6Zp6jSsGmHTURjSsq
         YXMAAnrEOCd3L/Sat+9XVFVOOJeSqyxEX5lljxvlPTXzU6qHp2Cmp9tgwUKJe0NFGWl6
         bT3jryYHw3gTybariirT7jAQXl58XbyJwwg9NWL6fk/m5Gw7hP3A8g+D6g4TcjREo6cF
         WwRJcQOWvUPmjQWtRJt2SYZZfrErANJ5YXZjBfyRI6BPj749RvG3zIg3goSg1rvkeDAS
         zPGMJooJPrbjEFcx1Fs2qpaAOgk5S5KdWO6lWm/TtTrLAxbUY1aOL2kLsdHTvYHB9ekA
         eELg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769188150; x=1769792950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KDi1jMTaR6KPNr8Xb3B/fDVI4Wv8VBtbYg00h50ejLw=;
        b=Jlmb/Y2M0q6yUg0dEDUmA6IFCvKNeQp1RA+dXWlIIiY4cH2PkviSPRyB+ig0/Ui0gT
         WYGSU20QofJ2V2gEToqMCRurUfL/rgYr9lOI4MrTOQhgHyxHJqxudYz02wkiZTyrhVhh
         ARKXzlpLeewO+bQLMwBAWQXUFfR9XnYaQ5eJBKD6WwuymMlRZmW/7zHxph/u9/iXpHfA
         JUHGEq2z2Qm4tjbfXpUxbDJMm+bp6AcaAh7m/o7xBpi67E+Io+0HvF6DeNfdJuFAu454
         Ru04b4iC3oFiyWqw5ryPm4FsBoYWJHzF+wpjxaQINB8Gy25eAvyKihI2xFYWF/oYdkKa
         JJ5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWq/ko0ZMGD+4MBkNV48oDGz7PTs0TuO1vTH9VKCrlU9GDE84HvVe4jAkFAmHEOIQXm1PF2ktL+@lists.linux.dev
X-Gm-Message-State: AOJu0YxaMCp37mL3mCvI/B1JdOx/A6QS+tX/c29I4jskCbbakI+TGHvS
	rmAyHT7sUO/ju8NWGZ+28y60U2uXafbidN2UBPrX1DfG9PKHxPqsi9M0UrmdL9Hx3Y0ciY9++Hk
	DlSNedlDkjqoZKbYFxr4LZSc/oFERMR8=
X-Gm-Gg: AZuq6aJuEhBLKFqszcU1FiTOYRSDOC/z9vkV7PbhmSC4QoEdHTfT/oQUsUoi8OJZvjc
	Ju+3JiokXHwKMaRI6IDw3LQYj/1I99EQg0OiX7z7Cf4Iy47+wmAMVoAyUApj62kY80/l0cQoiNn
	Gxwqx4fyLpg57Qb8b+vE2uiqivujr9t2cyzWBYmFirSkj8EN8z8YJzLcKTFWTDx5Gbgj1Sxb+gU
	5nxvreCL1lH2/S9IauAadrMfoNnVZDWtAIGAJTAtCe9SOXPxI8m+QMzl7NZDJDsm/aD31h0jf1s
	Qanju3RUtfc2CYNL9jGxs/Hs8CZ6
X-Received: by 2002:a05:6512:ba7:b0:598:f283:e12f with SMTP id
 2adb3069b0e04-59de48f3b4dmr1160430e87.11.1769188149316; Fri, 23 Jan 2026
 09:09:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260121181418.537774329@linuxfoundation.org>
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Fri, 23 Jan 2026 22:38:57 +0530
X-Gm-Features: AZwV_QjTA2OROAQCVcF7Fgzm2P5YXYzI-sYXuCwZDz88Bj-LHvwUJ9n19S-RNn8
Message-ID: <CAC-m1rqcA9e2-3NYKagEahZFxYuNBs8yzpVUEeU=WwZix78f7A@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2026 at 2:12=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.7 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Jan 2026 18:13:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

build and boot report for Linux 6.18.7-rc1.

The kernel was built and booted successfull on both arm64 and x86_64
architectures using the defconfig. Testing was performed in virtual
environments,
and the system ran as expected.

No dmesg regressions were found during testing.

Build details:
Architectures: arm64, x86_64
Kernel version: 6.18.7
Configuration: defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit: 28a73c31d7f5d9d2276c92e1d4891c18a5631e6e

Tested-by: Dileep Malepu <dileep.debian@gmail.com>
