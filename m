Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239D43CAE65
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 11:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775042073; cv=pass; b=r7mx4s5F16ySK/gxncrKNvm9iW4yIIRSSqRSQ3U4LWo/DFnjnIrgSlJUG/iwAqlCcGe9tKUNejHIZQiMBBQ62W7ROzLiUKTYcDHH0Aa3Ia0Hl69AMWnttBflLUd/sikrX+++d3hdVxNf1FeoylXtAy8xgXIdJWVkeRx3tjnxbbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775042073; c=relaxed/simple;
	bh=pc5H36RuEHckCC4rxZiHAV25J1O0MfCUQosX2L+946Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OZp6wsIotQkvsh5tBkZxarmKkka4kI0+A+OvYzzcs7IucDvvcZcEI/9SGo+ZOJcRqUVT0PUItQz8Zelfz/PlWek+s6O3eeM6MDAF0YdnaIcHYa8hxZkgWUxm0Rv94CWe6qIy2tHOXPxAa8QU+20iqz4yjAxFlBKidWv3udMr5Ac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Y4FvWPVo; arc=pass smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Y4FvWPVo"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-128ebee22caso393572c88.0
        for <patches@lists.linux.dev>; Wed, 01 Apr 2026 04:14:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775042071; cv=none;
        d=google.com; s=arc-20240605;
        b=iuj2Xea9odU4/MMIxRlkwc7443pmMyEEiG5Z/x4SQdhMhjgxTUaiEpulnh60D3llli
         Y7pl+nRqIYlAX40oe0eXi6kz6Esthr1Z1AkPwqrQ3aDSu8i8+JToTTQvmz08fl3lVSMy
         Xu1ceFNFsJdeW/LfIDZE03iYtsEg3gBzHUZ3cNtSqDAwETLai7q7p79Q2Qm9h+EfKY5x
         fXuOWLsBg5vTHz7RSE96XEhtI9zds10hhyvg8EmKPHkVJrpEkFBcAS1oHK7UcqHNpJ19
         KrhMziTBOojjSktk6ppnB6aLJcO/sDG2490VFv0+nbxtQAvrLCWa8YjKuDo63POFaJho
         rAFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tZhdqGF0+1HrQa1yHew2N2aXTxqOA/y8rCZpynRhAAg=;
        fh=wsueldCg6ylOrEdSgzJooN3FJycd3Ev/gihFLQKLsM8=;
        b=gz64qUdjnGrV6mY79p19QwkVfUYxjv9t5k+sfVN/8M6/efJqjt0J8sLebDhEJLVFuj
         Q9agPNZZBIEXgdyQ86zs56fKdLJ5I1yB96GgMOcPadLWhPFcyMRF2oHJgvVYbY7ct6M7
         jRzugc5giVcgwNSss/uOagmUv6v10FjKr2bKG/IFQV+n4NMgTCBauOVZR7cnOjLvXU39
         vrazFE6deVpLPOT9PGsWzpy/SpMn2lRTqRyFIs4UqNbKDbBvJc4XTvfj7M5zuoYPKeDJ
         EEGVpbTXe/dmOvx6NcwM3sQDgyOKbQ4eYqmcp/l033U5ho8hOZK2pWMMQVSKaucXGWju
         YRlA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1775042071; x=1775646871; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tZhdqGF0+1HrQa1yHew2N2aXTxqOA/y8rCZpynRhAAg=;
        b=Y4FvWPVoZ9FS/d7jYbfSBQUwunRGa0PeZkQ3CnRWXZNas1+dzk7vuHRkvhz8etikDT
         /pgAFhImpyHllswFUttNmtrg0Jf9zwgIFZT7wKPR9RKjhasLzUrzuBAuNoVIfEWNu3Yf
         ihNH77rbzF0MxmsDMEYjKO9olCtdLMALTDkJ38mP35FTcYLBZrWYDiYx26qDLnEn/w4H
         mlHCyPD9H53Vw3Aggmk59IwhtI7Bmy3rh5nlm8zrDCxpINNnAq2g28NM43Ufu9W+Pnbm
         0MYDQzRy/yTf0Bui5sKjVcJH6uLQipzk9H11cti7LEKPHwtBERPFhdEjMpU2rvyyOn59
         xN8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775042071; x=1775646871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tZhdqGF0+1HrQa1yHew2N2aXTxqOA/y8rCZpynRhAAg=;
        b=Ufujb/2NLmrh0LVL+AIKXemElh4Ou6PnIaHTorusTuv+JLDsSclvswvqAMp2bMPZiI
         Ji5AmHBUcIW+rWGpsOEsMu9WrNBPG2e/Yfo99nzlTnMYpKf0+QG615q+6KgEcFetQJt5
         +wn3vTXF7JsrbbmqOWIHJ91X2i+IVdv7Nhkxu8/r6Sq9M9FOaHTDn7oLODaGGTudK/kH
         wVVVtCAuzK9IwnArqfFzGbhslCbxlTYZebx6pb/xvWTpSPLhp5q+j8P9f0hjgFV4a4DI
         +pYOMLVPdfDEzOrzsCVl+vWgRhUOLdgGPmmvi8fmnHYtSV8M6xsCXMFF8VY/w5GeF/8U
         S64A==
X-Forwarded-Encrypted: i=1; AJvYcCVbbisqmVjXR5DfzfQ6bdW0XiIS9a1/uNva7HZyCWKm0WjC4x+2plqDoOMNrsmWCAxPE8yYflNE@lists.linux.dev
X-Gm-Message-State: AOJu0YyF6Ujcyz/E6dtXcA6G2L6FNDw9xO/WeKVMap6xlchjjlbSjgxB
	Z8Y2Vd4Q9b6k3h7YfnLQcNhxYZ7bshhtVWOH40yDS93WnmzcHwP8lT/JuqYBcCVfagiWQZfUmIp
	lmIHR0Jtjy/giGz/mYG56Jn95kHjSwKNVAlEzXHWwoQ==
X-Gm-Gg: ATEYQzyo5TjRSXD1picYuqgfKQvRWAGxczOOsWEaqkFWLly5IFSQscCcSj65BaDtsEE
	F3St8DZ07kKck70eYnm4Nb7Nhf/Ggmt/3vhMN+vPcGDRWC2afin8dkueHAu1a7ug07AKyjjCQyV
	KH2yuhTNgtfFSS0f6TFjse52c+R6KYlOb/j82pX8QDTed7YrgglS81TrvZJXiJJrTgcba9lYx/z
	4Nq8UrRNnzgk219hUpt36F49A+HReZ4e1H0ZAglkSK8dj5KmvrsptVmDvlUADZQAbtaOy6ggiUh
	tc/75M8G
X-Received: by 2002:a05:7022:6720:b0:11b:b179:6e17 with SMTP id
 a92af1059eb24-12be65988efmr1913619c88.34.1775042070889; Wed, 01 Apr 2026
 04:14:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260331161758.909578033@linuxfoundation.org>
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 1 Apr 2026 20:14:14 +0900
X-Gm-Features: AQROBzCcWjpIDbqMiVDnMHwjdZ3Du7329NtkcMVFmn20aZQ4M0bdNteoauZCp2s
Message-ID: <CAKL4bV6wXdd-FRft9p69+LDNfw6=yarXgRAmNVZTE6PYLW0kNA@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/342] 6.19.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Apr 1, 2026 at 2:01=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.11 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.19.11-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.11-rc1rv-g411f8a553ae8
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Wed Apr  1 19:21:05 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
