Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CA548DB58
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 08:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792397376; cv=pass; b=O5vwzLUBn/pR3g29WfgrnYRa9vrGUNYdWaRiImiBEeDbLD/exH7SuGcVxQiswNGZEptdw+FzokbgPFfC2j7N5cDysVLAP7hGlOnxNDAUyMy6CtyD5pAjELU1Z3HA9CwCmehcjjt/FlNMu2VboCMzeUz0rl104hVwaB3gWbeFhKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792397376; c=relaxed/simple;
	bh=9D5TqnkicT2U7tRgx/dr8Iw0EFKZV2iKPc6zOXL2J2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QCREJyMserS2DW7FswyAm+6UyxE1TJsBaw2IlyX2LWJjDrqtvIeDSf4l/tRFP2Aw/9M/tsDMSWsrE+32ba6vx7h0wX6dJHt2z4UI0ujDXrX+rbmB0a21UfCyY7SwSIm1OJ+2f64tIqh5KpE7+lHhfE1xrVfpq2Iq9W311lPRrEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=f/FBr3fH; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="f/FBr3fH"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c445c95d553so61165366b.1
        for <patches@lists.linux.dev>; Mon, 19 Oct 2026 01:09:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792397372; cv=none;
        d=google.com; s=arc-20260327;
        b=JE63GhG7ZwcP57zNten4DwnPtUcsCpU8iFwfUwmAx5WHfQGA89X8Zvu1Q5lxYo00Wf
         nsh/nk0oDWEIuu9Rh6wKo5UK7EOhKq81wG7Vx1bkxqX8wJOcb3qNJAqJUutzNn6+45WX
         Kwe7QMarfcJYNwDwSkTlFEhKOeOG+OKKAKicXXuSNofSw3tK+C/S6k+JJUVXm7F+d1DJ
         uYKAfe8bs8o7+Tk+sDkWjt2AhU0nbTxWipU9GM0OOdD/p1h5Niws5xcTubzpKyFjhs2o
         PcRwKIQw7mF5CeX9M8miq74arVuIV+Gqg5p58wR7+SuXRc7zyLsrvJkSn2ffEjxUjPcC
         pzIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mKp2lGowX8peLqRZk7J7Wle27OZPi0eWO/3k4N8FozY=;
        fh=ZOg+RLuX6Q2vo+UwW9/BN7NWjEdnItUILoVDoh7RyG0=;
        b=BtmVF4Sfi71dSL86nJ5CFQfzaKu8ee6xXabMagcIWP4SRC0iF5eROSOz//LkKXRooO
         2GPRNYrkQZykkpu86ep4KT/pLLSa8A3GQjYJwa4QOzI/lC7iAbvXKmZOYeckfTZXHIOs
         OdDi31Qd593WbQDezuLLZWgyr/FcBrmPeRXg3shc4n9x2goTl+xhLEBLIredlfzCMZpP
         sNY9Q4C8jmVCfuvV44XSHVZnz2EbHZbYduHDkJeCAc9FBiXczPgTSsOn88yl20lwP1gM
         XMGonr7IDkpoTT4q6Nt4/KkTp4JFu+R5jG9s/Bo5q4uGCx5qOMcMSx0KE+Use4BiPOOc
         jBrQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1792397372; x=1793002172; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mKp2lGowX8peLqRZk7J7Wle27OZPi0eWO/3k4N8FozY=;
        b=f/FBr3fHjPLtutWH6oLNZbODQ5N87uJpjXbJB6jkHmOFZPkQnR1JpfOJgrhxabUwtA
         lWDqClfBxaXktVSsLLEIaCyYIE7dX2l0CENFhrFepcjIuZxe4kEXqQxjaALhchHzMoxN
         00gNlEWgn+RnDikXbyVDq/MxTel1sVE/XAbWxccmsw1wEqCYShUaLVMSOTDgtR3ceZx9
         b/cU7RcLuZDM5Y2xKnf7gfeBrIKJE5e3dWBvxg9ouoY+9yGCAe/ijn45XyBflrclj3rU
         piGNncOVNIE9Z9QwKMX1//io7WMKTmSk+SJpkCgQfgkNj6EG1e9YCg5R8b2C3cTAyDJl
         slhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792397372; x=1793002172;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mKp2lGowX8peLqRZk7J7Wle27OZPi0eWO/3k4N8FozY=;
        b=0Stdvk7DdpvJkDtx31S/ItclAlq3cu4LiEVeIUjIEn1hxK2sWb2cqadIBHUKJSweQa
         Z6obXMbIyveWT5cXkLi88PeBZuDKMBINqz8VdhMNo7DNTuNmIEGGgMMGhvYRkc0JR/q0
         cmUjFeCaxctUzLyB4NeCxkivVb6hQnmnChFi8maTOt3GHToxr03CQKVaHl6DJOAj0MOi
         qIYUh7kvad8ug6fdXdqYZxM8/9jc7/ShrnZhzw5JLJzIbQLhYdCW1qRDIxuf1im4KgB1
         DYmv/5UpUkBsYmEUW7CzrtSUEkItzcxS0RQjs0FOixs/P7e464lFkt/FpTQbZdt4V167
         HD9w==
X-Forwarded-Encrypted: i=1; AKwUvBwjbYVWPSILLmvB4LFikZfu4M37qrtUB2485CxlM4FvrRV2ofYhYAT20yLLpyscFMJUY7SWBgFO@lists.linux.dev
X-Gm-Message-State: AFq9FYLdXLHGAzN27P2gq0DwukgQThqcVnZDZbrSwdwcPLo45Jr2FtRF
	Qvxykm9QGTQU+sApiAFSTCDDLxnCCz59Z+PJ4puD7h6FD9v3YoAZjCkNZpeE93rBsycW4Fmd4W5
	pj/aWujIUSP9JMNBK42fUzKEz0Tk+zq53E80fHX/ENw==
X-Gm-Gg: AYBFou2ywlKl3khV7CEpVMFrwLtJI6g6XSIpUUpAYrot/CHZe5q4xK4EH0N6Pgvd5Kl
	dGVWSvqAVRf2jM1cCJJgJjnJGvyr5owmshs11WSMXaEkshj7CZXTHmXGYXYx7Dm8inq1Tr6qhNS
	bAQU9PRoK2z+RFqc2cuE2ibHk7QwC2TJIMt0Y0ZAEhr8VeXdNXrmKLFHaHpaQ6Z9WKymUNO9mPz
	tUwimnw+q9ljqO6aYaDnKzI0Dkn29+gteaY+/zDmDuWVtdrwCdZodspEeJUXFGXBIIwcMdBjrMv
	KZQcTrXmQn/MGJOJ48gigRJKVRyWHDziMRKx6xQqUy3RBoPMOZaS79nHHgEnpucxeKVGiQRiWGz
	y/4Xmw1kI5yzL6KGv+JPKJXY=
X-Received: by 2002:a17:906:ba89:b0:c34:1ed:54d9 with SMTP id
 a640c23a62f3a-c41999720a9mr416234266b.4.1792397371695; Mon, 19 Oct 2026
 01:09:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261017155059.698368299@linuxfoundation.org>
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Mon, 19 Oct 2026 17:09:12 +0900
X-Gm-Features: AclHuK8Huz6jdrYWmKBBEhptdxroSHGbHzeJx-piV8U8UsZA0jaDmMp3LdQ65vM
Message-ID: <CAKL4bV54AZWUbd0w4YvkbJt3VMEN6VmOz3HZAPHRZ6S3CWA_Vg@mail.gmail.com>
Subject: Re: [PATCH 7.2 00/10] 7.2.12-rc1 review
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

On Sun, Oct 18, 2026 at 12:54=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.12 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 19 Oct 2026 15:50:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.2.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Linux version 7.2.12-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.2.12-rc1rv-g590446e5a2fe
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Mon Oct 19 16:42:14 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
