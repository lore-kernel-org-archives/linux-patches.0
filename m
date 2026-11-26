Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795702894;
	b=p3zGk304hXw9GrI7PX77jftU6rsH1twinRn0xo7GCz9TUNiWPaIEgh7CpKxNiyszRVdQ
	 tV3Sx5yeBh5r3NIUhZbhPZJgAU7M96OZmAgMeHp2CyMAuOvKolUMP0xds6S0BT1gTz+V5
	 ZyVtZc2IzD2Pf6rqnZYQKopMubopoomludNr9c6Kp3qKGMXy+uV0PpmN0x1fYqr+4FiKV
	 cjZXr3SVTBhEOEL2fHSV8rYTc2ZoUXXywWzsELuzELokksy7EAv/XTUC0OX9TorON4MMt
	 2EOVkZ/26MabFobLapX7RVX0ulvrTCv7SvtBA4LtcCGDPK+PxT+Fm0aLjRmWWTzhNrQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795702894;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=G5RY+0srkZ4dl/m2XGcBAxCwTBJactXCq+wpKVumJ4I=;
	b=3qDXc4XK3e7sDgUfy5qjCM/pVKdzF6e2uEi5XLQCpWNOUfmvXcOEO9srYR+4oqVhTIdc
	 rvp0s3Whrf+knttTqLdvvK2RZzMDeIrX7VYrCuOkmzkYzmaVmcV0wxHkFNq7qcJIXGWTr
	 VFe8ixMxZLwWa9zS0GHhPjLZpNUc1mb6eWM9Q1WubfPA7L6kq7QT8zwegTN7/o0OeBTkU
	 uk1gm0sVwEp32tvDSJ6FUio2VkCsouNy+Uf9u0cLnenjAWNFwEcZ0BMpQyRoaYNoZm5h3
	 /zGYhZXjkBqw8EH2KnG07krd2O/Y0NIRLhhf6MBB0qDHOOdZmpM9cetROPiGLk7nxyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=futuring-girl.com;
	spf=pass smtp.mailfrom=futuring-girl.com;
	dkim=pass header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=CR3HQ4vj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892F3606A31E
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 14:21:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 892F3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=CR3HQ4vj
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4cac7a7d3cso1053443466b.3
        for <patches@lists.linux.dev>; Thu, 26 Nov 2026 06:21:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795702893; cv=none;
        d=google.com; s=arc-20260327;
        b=jArxgolDkyReC0ItZtv0p7HX5K6rI9Q8XQJV3glLlPB4KR81Rs3j2UxVcs+wkq22BQ
         mNzQ6mfZEb16lCgSZvcQT4r3LNjx1wpsoZ6rLXPxo6JeltyOPfwQYVAf/YYMo7O5YPKm
         vnoX2qcm0rwOMz6wruULobH8q1IZzCiQzTkswR2iIQOI6B96fIwuRY02kxgZU/3RI5sc
         sNpCant21oHXpaTjSswtUtU3NqDGxYXGRuAJ3qyA783vd1c/xf/44Q1VB/eFe2GhQSVl
         FA71PoVAYyBzVtcGWG1oxV11S+ysHuWI9z/ySi61X/825OVuq8QRXxxOtk5UOVLXMiju
         NkGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G5RY+0srkZ4dl/m2XGcBAxCwTBJactXCq+wpKVumJ4I=;
        fh=C813y/2FMYky0+ar5kLHCHRjNiqExWayLuS5d18v6lM=;
        b=BmM+zlyRlkdJEb6gKxp2XJC5fl7hDcacYX+csKFIwiwkZi3j6HnlSiD0XAXBuLRAZT
         v6B8EUH1klyMG4ZAR0PnyEsbcNCjIakwI0unEQaq3OcnupBoHHG3NRPMm/ARuuyIi29m
         3KIpFUI4DwdoePP2oagpvedStwVz7/cBGBOTt/661lcKxyB1l8tfSr2+DuyyucRECKoP
         CCo+195tEKiQJcNUWyqsVa7fEe7/94W2VwDXGt02CKGy2XX2R17V2PYz+umsHgpYh/c0
         tEs4m9B3sWtkYKkEWTuAmaCypKia98ZVyQf6P4bKRVDbHTAveICVLglcghnqqlP9PlWM
         g6QQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1795702893; x=1796307693; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G5RY+0srkZ4dl/m2XGcBAxCwTBJactXCq+wpKVumJ4I=;
        b=CR3HQ4vjl0Djl0s5N1cQw6gnPsxLvC2JQshDQgXkR6hbs9FeifBmM+KmMNOx4F0mKS
         93a22e8kOar7OR3GHy3tFmCD2R5gjZBcBVs91ARAJ0r6x3fMulQhCHo5V+TC0Ykho6qr
         00ldDh6dEsm6r+XcS+hoRAuPZcZlrw4lrApGT0Lfl5vK2UM4Xd2uRjtkFPKi68j7zpSC
         rAc+VKlUi99KPNnqQ6s6tF5cLpIeKIO56bpkKVrQfaKfxs5goqhfcjxoYXs1qnkkxUCo
         +mCjE09Aat9YMnmjrOdjE6s2yrp3qSR/CgO846GGcGrr+3zmPQh1ljWy5vvuSx+MjEhp
         s1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795702893; x=1796307693;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G5RY+0srkZ4dl/m2XGcBAxCwTBJactXCq+wpKVumJ4I=;
        b=Wqy0rU9xReYyyI/PHhoP747T128ZJdisEGNi3X2+AWd9/ZqrMjbPpH+u7NxtNwbvOM
         ZWIfwLpktvrWFyPx6LZDtmKmO4heNw9k6YEPnzOehRI6jo7WGtU1r9P+g6LoXHQ8e0TI
         AiVFO3dB2MyZkv4Lu3Yki0BKopoqbBPchpmREuBpCUSeiwPCFjmuvQhvFozzeWMS9S79
         IBfLB8G47AoWrX3YkM4iZ5bUK9yxWLN7fW2S+5bAQZrSFp7K+aZZiWWulOUy3qOvZVOZ
         H+85aysAhtLtsj0npYQWV+14UYBmltk/fBWzkcaD55l54uzUio1CwNnBvpwH0KyPNtbz
         +Hjg==
X-Forwarded-Encrypted: i=1; AL+hErH6z9cWdArxQAjH9DH2XpUR1YI0brJ3W0hRfUw2XBxukqTYp4d0Fx9Qw29O1883jHhCESN+k9Rv@lists.linux.dev
X-Gm-Message-State: APuU4Z+unLye4sSSgxLwha7AOaM5mEst+3dNa5zZschnEy+SQv4W66s8
	vszHjq0etYcNDM0hiUrIMJUFZci1A7UCwZTNiGzvE9xGykKh7vLEdo0lnmkgOqaZ8wrAcHcIFtI
	jQuxD2/V8GnVOQDTie0HJTMkjfGmRZRJ6kVcGS3Yeww==
X-Gm-Gg: AZFdTZdh/EMiy07VE8tUtezUQ2QmyJvGJ+CNHRVp+wVWwXtva5Y6xc6RCE/Toke9ivi
	y4nK2WGL9blD6rrwI80fqzdYkTypCAercMbu2bDoxWoKTkpiPWC8zXaGgpioClijLeS1ryvLe1R
	t7m1t79ddV06aL5gAIwHdGHXiaYV99ZC+1jXrUgT88GxD6fOFWgYDlDRl/t5UmIvVDlznuT02OC
	eSeTKVxBkCxhXeF6uBcaxgExmuU9AqqkcZl3YqhPAwoD3Q8lNu+EwgDMzPdCB8Wca8AqNcbcP7l
	a0nmfiaEFCWbguZDhxJHascxJrfcEpbkwetDlmztcEH7j7Ye/wd0ibZS6UdxuT6/5xO36Z0mEf9
	GV6HiABsQ7GbzmrPGj5k9t6ouJ5bnJUjcIc9C
X-Received: by 2002:a17:906:9c10:b0:c50:e9b4:3c9f with SMTP id
 a640c23a62f3a-c513a88bd77mr1318692766b.14.1795702892675; Thu, 26 Nov 2026
 06:21:32 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261126105729.110697432@linuxfoundation.org>
In-Reply-To: <20261126105729.110697432@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 26 Nov 2026 23:21:14 +0900
X-Gm-Features: Aa3M54rDhX9gPPGUUPqGNn55Em1IdriVZL7YAVT3nsPcx51a8eHytUToqjQjQi0
Message-ID: <CAKL4bV7H4EgWB0j-0KsD1bxNWwaad94Gvg86+vNVNDh5vR+ZZA@mail.gmail.com>
Subject: Re: [PATCH 7.3 0000/1002] 7.3.7-rc2 review
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

On Thu, Nov 26, 2026 at 7:58=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.3.7 release.
> There are 1002 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.3.7-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.3.7-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.3.7-rc2rv-gce73b94700e6
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Thu Nov 26 22:44:37 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
