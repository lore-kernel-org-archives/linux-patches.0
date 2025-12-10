Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1DC277CBF
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 12:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765369041; cv=none; b=IGCmocPk24OFRUQFcM/wqI4HHU/iUe4sIc7C5/zmfmTmVj2/1eZyh/YaE809WxGMd3TI2hsGGvvs8gMTK2KdX6IxSHh0wJIMKLExeCe95TlTBRK6D0i3K8WLOUWL1aue07yRcLuAxATE001fCc6lg/eFnIE6ZsnY5eGJbfTu/2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765369041; c=relaxed/simple;
	bh=CqddzwXfg+iqUA6B+bgarDhsZ2CwkeqjbcD6pMA7Ges=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OhR/sUPayO7wb178E4yCSLqo7H8pDtbW8jO1t4o8QYUfdgNlh1+bpJEiBkeBHHVkN2zVLQgIQePP4EUbSRYJ3GVK9fgBSVx+airFA/HySiraiSmbgZB5OxHWdvwRPnUnqD+phIxt05yOoT8VPIa7tHvjHEsUq/+expIVn0appYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=oTa5F6gg; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="oTa5F6gg"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-bc29d64b39dso3941356a12.3
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 04:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1765369039; x=1765973839; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O1xwdwbZyc6XmBBbHWBkpSZmTvfwzWj9ylDCyZwxUU0=;
        b=oTa5F6gg17tWHY/rVqqhOP3ob1MLA6e7EVMYLhbmIXx6lOmT1jXOvEQILqKXjR0XYh
         /P+BgkpQlJtAsXHghNHLfC8lUBOSKzW6G+gYCm1L446qFTzVYjXa5MQ2rAfZVxm9c5pk
         gVOIQMlEvqL6GgAlwXkeBDcI8i2akYdEmIWy9H8HhpD0dzfmkXRP5Os78yVKEedRaNjx
         NuzTK5vmCXyEwMdRbY+UgEvuvKRGUq9UiVGkEbO8Rz3XenGUMgg0kBkCiun81OZ7mOYK
         02G3Zz1ze/WQR4T3WtnWkGooG7bZ9Z4SeRtq6HTQiLuRJXM0IZXC4gmfgBQirwfhsN6M
         0r2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765369039; x=1765973839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O1xwdwbZyc6XmBBbHWBkpSZmTvfwzWj9ylDCyZwxUU0=;
        b=nBuvmuRMgesJet+Dhq3C1dME67+mMrs8h5VAm37Rcrdqt+0TVb4PPmLn57olqQo8dp
         YDjoNvKGmi0uAmT5eBrMCi3qdnHC1udNGyoN6OtIkjKjiGiThQ8Enlq0Ld7UyrDDqh15
         ygB39AHFurlnxJclX4Ir4yV+jhtWNo1TndtRGNSjCPRO5g84PeeM1cYx/jLIEY+jXQw5
         27n+dKBCLttHnuaD/aTllklJB0dPo71Mrk9/vGvO+bM3qNpWkCKT0ZPvD/FEsAfy60Pa
         9l1C7PwQ/o0ewC4uO6/I2MVNfvJw0A5m7J0aXoBkeri5f78PrYNGyzWASbi/Uqw6NSJC
         wzZw==
X-Forwarded-Encrypted: i=1; AJvYcCWS0mAGbwLZvRPectg522cOV9drxcAq6ayTM50X8UETEPb+zaxZrxdfonn0HSj1lB+seIb5bhe1@lists.linux.dev
X-Gm-Message-State: AOJu0YzTKC/69ZWz1RTkKwCNRkExPEVt1akEX77zXMoAG4/i7EURCbDr
	W/7jXZsXTvE/uNS5jFlLOIyrXz/6qrn4ZywZilTFuPkjjYaIQlUz8kY4cAKAn5a7ElfaSc2wAgK
	gYG1BLcT8pNVZJGJ3yx4iU6pt5Y7J3KWSWap5FO7z4w==
X-Gm-Gg: ASbGncsyknn7RuL7FrGZmmCVoAZkqw+EBTKTaYotj7I3SzpQ9DCfmBZiIr9XUQH8/+a
	Ba2eKfRIxN/PXdtCxs/ZpDXZwp22RdPy3+l/8oXwj5Q0OYHJMmHzyzJisy+1WjMRgYjImkfGLUs
	0mqwinVrDZIofLFIDTNQf9ZNcy8RYPs9oS+UOg9wFdBDvldv/jQZxjbp9GhdYm4/S7bsqqNjAtm
	LR0/yL+ewOOrAgDAzkGhiaBcWaVe8VTBP97+H8Wt4hOMvASJtCK1ufXEPDbWtwRr77XEx+08Q==
X-Google-Smtp-Source: AGHT+IHBgz+FmtVPvJu3SCy7tALN1FAmhPzb18VCi3/4ZrVRGY+kOcv5Fz+irwsD+vLtWKOs0MzTStN2UBe7MMegzfo=
X-Received: by 2002:a05:7022:4381:b0:11b:9386:825b with SMTP id
 a92af1059eb24-11f296c4100mr1746123c88.48.1765369039130; Wed, 10 Dec 2025
 04:17:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072944.363788552@linuxfoundation.org>
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 10 Dec 2025 21:17:03 +0900
X-Gm-Features: AQt7F2pTA2Cii6t8rtYmLN11BKTetwmg6gtStkBaVhUsG8qqSyx6V4L8IpnnnJY
Message-ID: <CAKL4bV6LnoRjoyqss+5DBOC+SCa+bKbyyS4wCA6tTRaDpqUgWA@mail.gmail.com>
Subject: Re: [PATCH 6.18 00/29] 6.18.1-rc1 review
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

Hi Greg

On Wed, Dec 10, 2025 at 4:36=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.1 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Dec 2025 07:29:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.18.1-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.18.1-rc1rv-g7d4c06f4000f
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20251112, GNU ld (GNU
Binutils) 2.45.1) #1 SMP PREEMPT_DYNAMIC Wed Dec 10 20:19:12 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
