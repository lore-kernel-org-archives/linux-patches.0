Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211513F8899
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 12:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787745828; cv=pass; b=b0nZZp4+AjsGpkQi01iJ8/JA8/FZt5LfFSqNNblHu9RD6ktGTxn5PPteggBtzlOYwRw5NMp7KOiYdz6QFbHa7ekYPLqi4Xzr0inra/MQhkJIiBr02GN8yfKajxdDjW87SW2jXJ6DnkOWFfzsrVLxKxJsUlVrLnWu7JUOCAxNCqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787745828; c=relaxed/simple;
	bh=VgpSkfkt9+IsahxI1cQp4xeSvCEjsBixCuyMoUcG8B0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OwrVyJ+irz0S85W1u/o+Ki83yqa9xo8mBOwj3hJAcV8jgmYuPc10URGgSEwUWWIlVHnLANvGf6EyfzLjR0Ov9WO+PckFFSdeH5iUvYsYXcG2N7CXca//+aXHYqHhHycOXj+a7w4P72ZHfsSr6l2gsmF9u1GvWCzYW5cltMIdKxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=AdMeeJg2; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="AdMeeJg2"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c1c52d920b8so105651666b.2
        for <patches@lists.linux.dev>; Wed, 26 Aug 2026 05:03:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787745823; cv=none;
        d=google.com; s=arc-20260327;
        b=cpaoFgKv02IWdc0EIa4I6cIEL4pStSK1bzerLm8kLGGbNxGnWH4wkNALGGnHxDXq2X
         bx/h9x5HiHvFG/8gfEWKCzpfs/GtAgQ+vnBoQdLP+jbNyQKtmH2cZunkcYmNDW2/27Z5
         I0kIxT7Yuiyitw/mcJ1tzYhn8AVX0XLIvStcQWLtirhxNo3mwJHg1VEuG2QBj1VYiPRO
         y9LBQui522DJiyH3r1jCeasB9KQ6wEhBsl9CvAkR7yCDej2HfdTjN4CqjkyBF09rYzbn
         yUYszk7NbNB//8/titaHZ91fUpTrIhqJBxhYdp0STW94JsWTj1A4rg6P5u6QdueXhJA+
         5IGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KHczRSOUNQAOaPV0/pSLE0qgfPRAm7Vb+2aII/l1HUg=;
        fh=Rsgu0XsmKeTnE9fc/QnQjCjMrw5jDTNWm0rVor/mLGs=;
        b=s2fPhjWUrDnqOC70brHrl6ZYw9fpk3TEaWPNRdl5HWVhikHXPMCxazH1c0w/Q2YEUp
         ushnSN7CR4hHtl+iXgp57xdFD2Jn13e97FjmqYVAbjw1X8ro2GipKXIAf+io7b9egWi1
         JKfI9npIghAfFfg+WaelxYSTKR65WV0Vh6yDEVhhIx7Bq65LtDMqV05qa7g5wspndTGF
         6wpN6QWEA5Cb6hwfZQCHhM8FpGW7KrByPPVVkOCpmlkKRfXhaXPEHFQuwG1e4NIdBtsd
         pfRxaV/kGVKHCo/2KDF9B2Q0F2BBjZD9/PKPHkPIAs6fW3lWrs1fzW8inP6VvzfhhTlx
         HAZw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1787745823; x=1788350623; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KHczRSOUNQAOaPV0/pSLE0qgfPRAm7Vb+2aII/l1HUg=;
        b=AdMeeJg295IcJOmAFW0nT3Mqa5BLSTmZaluh/eL2ullqkdOgeaT1CnzfxT+ajVEDD9
         6CYaXe2yNG82DfZ6RAz5cvcuj+m8T0sLwmvrFRL6f5tWMb2/ZA7VI6hI/s5Urik2cqrp
         7PJxa7HuNlHstl9kKsIzp8X6RNg8Vpj0LsoK33Wb0TQ1SwfDGMdj42Y/PRKfSJGPEaWO
         URWluBv5Mi5WPNRgaIdj5rcdSm34XOi77wnZg32p3jerMZfxIciY2ct/W3V3eXE2yxbL
         gV49pDRfb1MaS+KkXkcpOGCqjJo6u/nlLBHpvOlIfh0UNqda5vkQscIp/L1bGJxHzTjh
         KIAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787745823; x=1788350623;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KHczRSOUNQAOaPV0/pSLE0qgfPRAm7Vb+2aII/l1HUg=;
        b=LbGGDkCzydwozE2G34lgLopG1e7YuSQE5T7crHmKAs3dcIPj1+DfmGH/pObQpu8cVE
         3GKxzfL3T+r7STNbh+tnw+fP7tCI20UJyHy5bmKaan87o30qjY4HluDDZzxX6/UKKpAU
         NmcuYXrxHvaj07ePEEfxyg2gJvstrKdAeRhyjKt9dE3S0JynolCZfrXjKYJjJ+mo6jPK
         qG1+/QB4eN66Fkaek6bz0uSBo0BQjkH1fB4l2/UHVbli8lFaOkcl1ci8FpRX/fh9A3SE
         Td5Ue7ijXt+Mp12Vqrk93VXPLi0jmOV8t/XWnNNA2lHPdvuNzRjEEwYl1fVcyTqrmQZn
         f2xQ==
X-Forwarded-Encrypted: i=1; AHgh+RqEkuv5cAln+aGwrtv7X/VexswYS4+v1xLMMZTNXKI5i41yq9t5khUFfViLv+N1gH9V5HQjLO5M@lists.linux.dev
X-Gm-Message-State: AFuF++mD+GxdDid5/sFJ7h/jgwJMPUWMak4DJJ0Sv/luEjJlziSdoTn2
	UiRCLGZeuROa1J9gjNG5+LHKfW6niO1h4yIXH7bFHGApdWIXiyxbesgZLrMnBcCJF3yfiUdT9Yo
	AuUWB6gpEFoZf+FmigIF3EWpZV7mltr8QKPgBUjpQ8A==
X-Gm-Gg: AR+sD10J9GssMFGNvatd+/aVX0+AxZOwEAdB9S4cEI4vEaCN0xQQXq6sq6IEJWDEv2N
	Xqka4Kowy2ro+U0lFd/mhSV1YjMCyIDJznRMF9EumHo1hSWEpxbimVuuJoNVeXdmk11BhTPmiBi
	JlikQLhR+Et1ST2JGoKObXG+E9acL4MfAQodYcSl/lVP0aryw5Ks5I697xfFS1TnnVtifVKeasg
	qb+CcFGmmEn+5Jawv7HoIgYT2V2EufJPkGwDVWD4iAf1TelhXATw8cOKC8JDMK8rm+lJqj1hDAs
	QVW4s2340lz2A6qihY7Tp3RAWpWKWY/2HnQoZQYhgJORNmWLRyXyEP7y
X-Received: by 2002:a17:907:9616:b0:c24:457b:86fc with SMTP id
 a640c23a62f3a-c250c329bf3mr603822266b.21.1787745777707; Wed, 26 Aug 2026
 05:02:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260825132541.986300899@linuxfoundation.org>
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 26 Aug 2026 21:02:40 +0900
X-Gm-Features: AcwNN1WueC4r3S8GatTaKBZIWNFDc6UcKGJRNI-BkTohTSoeo8p9V_YfbG8RAPM
Message-ID: <CAKL4bV4730AgqL6=U3bABvedwAtA5Kr5stJfCaCHJ9ZVyvn2XA@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/101] 7.1.11-rc1 review
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

On Tue, Aug 25, 2026 at 10:40=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.11 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.1.11-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.1.11-rc1rv-g822f846a60fc
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Wed Aug 26 20:10:08 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
