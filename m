Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793881098;
	b=Ol3ci5CBXSyyUa0dJ2Tvm8y5K+oQgwjz6Dpq5bNYEIADkRFr5HnLTtIY0XOTO9mhb1UY
	 MNQBQKn8c5PUaQO4HmqToSqtTJI+/9w7DoqodzxgbrJJEuJEr7zs2+KGWaPb/6eK9t7Bg
	 6jkRAIF1lqpOLH6BIk9voMssq1BevwAs3xSbP0IJgKhjhBNZVWM7HxXp3EPFu5gueclvo
	 SHIFOBo23ZHFR5MueG45+tBb8tNwFaYKGqFqpWc14SYlifzlOrsJg2kH1KwLyrStAzV8E
	 0F39huRGjJAxvUMid6sTwcBxot5IktMsG1RlipULbtvycJxUSXtd0Dw8bBDQJ7Kkc9A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881098;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=eefMXQAgx8LZwf0Fx8BRlWFmLt9F1+J29m11Vy9njI0=;
	b=QRaOhnZsCIxxIUWUDBc2YorFLFyBMYvSR/eW98fAv1Xd0hDv4D9NmSFlXWjtv8kKIC8l
	 /yqWLuTyqaqSTAifHcLPnvylRu/cZ5rwdgoT0gbRhJcp+6mmfTrpYqC1wHW9wgcRuE3tQ
	 u9lx+b/IK4wRlJsMaKbp4KLI3ynrF0R1pu2eaET45evoqncVAWeSW219c7Uwk5JJy6Q4L
	 XoZWe6APSc0urY0TX27RrS+5/j4TyDIPGDJ+2SacA+T5Q5CVpdLu2o52skXZWUWKclO9l
	 kvEeV86cGDnLZPrP3a68Iu/fuJSXZPEmiyObpR0fh5MarAnQVcXrA+UdrKV1yX7Aqtw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=futuring-girl.com;
	spf=pass smtp.mailfrom=futuring-girl.com;
	dkim=pass header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=DIi9Igu8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46B16082BD2
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 12:18:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A46B16082BD2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=DIi9Igu8
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4395d31228so296154966b.1
        for <patches@lists.linux.dev>; Thu, 05 Nov 2026 04:18:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793881096; cv=none;
        d=google.com; s=arc-20260327;
        b=QQRZR1MIWkoQpVPURvb+DCgveE3edVU9NtTJIqb5MviZMmkS8LiR/qL7BDC6q6iELj
         KOeJtwzLd86C+RcNcdXbs8+O9gFyyLitimZSg4huMbntDRrhQKZTfu5tXPv/XtYtTByV
         0WrZ6mdvae4Ut4/3v/vTVPxpBTsKJ0xvt5kxO0BERTCFcTCbIOHahOl1Xh8ZfeGfb48y
         TcruFEOq5CBsUJKcozFv1om5ZHBF8p8kl5tiduh6n1uGukiYE9FCojyux/Vi7lzvvRFd
         Y1FPG5xEMXzn/jinDn1XVoVUqyPy/Jliu8llD6QhLNB4jyTRly81hggheah3Gq5QBU/w
         oxMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eefMXQAgx8LZwf0Fx8BRlWFmLt9F1+J29m11Vy9njI0=;
        fh=BQ8D8GV3qfrSqLd5B44ONmpcpg9d27UTH2Ojz+ZCl2g=;
        b=YwSn6J3sHknQ0nGJcftiw4tKWOf6ReOAL8EZZqdSWZEW0y23+IcVVe4n6zNdx/u6oN
         FY3TSaJPsH7oyFM8QZj3NNwBCHc3NNrqy2oG1EONDHL6OYL6Yqnen6QL50FSvIYKY7yn
         ZWHd28FyCXQYAkNjKDq3VEjVr7v3Qr6jLxmqF6wFOxZzTtTJAg7TyU3R8kwN+q+rPtJ+
         2LjIk4wtvrKi6/9g4pAoGkVRcXyF49Ld9gclEyL+v9r4U3pBlPFhEGkXhj7cL5xcL5XD
         SLGHMuykxlRGkDvzHrEF969JXoylHbgaPRL/Die8qVQVyZ2UBavel6asS0pJL80RAteb
         oQFg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1793881096; x=1794485896; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eefMXQAgx8LZwf0Fx8BRlWFmLt9F1+J29m11Vy9njI0=;
        b=DIi9Igu8gj+H73q0lrBSgQTF8wt8n/p+WP9fzszfSzymNB7AwLbbxwDUpv3HBkfkM9
         WW3hdbFhb8kY2aIKXuaRhWSF199/hPvteQSb3JwXUW+YoRosOOP3OpGUAREjpKMS53c2
         63USAFv+k8KmdJY0EPyhbCa0TYCQR29SOv2rjGGxAgKh2HIPLrVcZmZBJG4Bhx+u3h3z
         NPgnLBag1LP8zjiUw8olEOLXfqvf6Q7o7gG3MzcDWX1xinCJ+8l4o0bKkQWNIxwtc/Ht
         YZCR2mYwV/1LAaKcVpamI/eTv2A9rRJpsT2Xn5xzFLYGhnldlGmXfIXCHZ80pjVowIvf
         PqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793881096; x=1794485896;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eefMXQAgx8LZwf0Fx8BRlWFmLt9F1+J29m11Vy9njI0=;
        b=YTnu/Jf/S3wsIOG/p4Dw0d4iUkG2MiRc/BesLWS9FOa1k8inBRWn8S9wc59bd3RuhY
         XFTVXWNvB2AUIznDnbNW6X5GXkCsRvfdaJ//CMtBWCm6gUqsVWO4xKdi2jytkQxlogWe
         0XWYnWf4mfez6c1lce0QWAJ67uVXoFwnLXmvdkGjv2fr9q3HEq0E3tkSeIHJZWuDWhxR
         q0KAoHi0qt2kTdns/sXrQrHqSxqWSq1GI6Pj9SRb3j3x9YsDAgQHrNx9/Y0dy95xw2GR
         +OympWU4kkssEJjscghJRSArXF76dYiRdcY4O7qNGVK0c/VveYBGbnCIiMxiE2oNMJMO
         O52g==
X-Forwarded-Encrypted: i=1; AKwUvBwpStlM5mJCpoAkMQBE6ySBV9AsOCeyhJV8gzD3UsLKfKrETbWzUhJ9TfOomqgLUZrxG0byrahN@lists.linux.dev
X-Gm-Message-State: APuU4Z+wF/ftiAk+zVJWzB3rSSoUPeLv74/2MtP/lb29hBUNeiiwSFmV
	2lctCNiCmMfcJzq3MMoa1FN0HwoLrkT3T7EdtN7G510qxLY/lkvJ6yEV/kf1i7/+MCqMSzFH0DC
	TLI0e6M7zC9gXygeXvwhLxyAnl+jNXIdDYYumV3olclA9ID/bCezDoCU=
X-Gm-Gg: AYBFou3I3LvniTmVlDz3LSzOzfHmAUp2JYDrrx8rhiGEHgkk4n6UNm0hpLE/fNX5Prt
	jqrO5SPs7r2InjpDe3yey5StBolc5Zk/YJP/f0eJXkACuaDrlj4G0J5/zoXu6mphMNAU4PDis2y
	wycaNYTwimIsXU8/+pjQzyBt7VStWBZZ+QWoDV41GREwh2EeaHa7Gxnq1NEVub+5KzmrGKjkbIO
	wgsFDgU7nWftZnHCS8Ea37rJCprEiG2ozqsKwK33GW+TlOgxc20IEQgRA4fpi8yocfWX85HTKSr
	a55zbo2n18/M4dVli2C37pBxAbCdcf5cG8OydeXnsulajUvPFHejHn1WEyUc6YaIgZDE5SahAp2
	P4xEfpzMWsJaNAbZdGJ+XfoEX/Y7MVMxStifX
X-Received: by 2002:a17:907:6d29:b0:c33:dbe8:291c with SMTP id
 a640c23a62f3a-c4ca7a4dd2fmr1811633166b.20.1793881095505; Thu, 05 Nov 2026
 04:18:15 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261104211038.406938024@linuxfoundation.org>
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 5 Nov 2026 21:17:59 +0900
X-Gm-Features: AclHuK_xKzr1_jGZskftgS9tYbRvEAvyWrEkQDJw4-ZYm6nRuyK-hjQJVu5MVE8
Message-ID: <CAKL4bV6VGE1J3K45KsOfo40zsZEZav4rxSVGRR3Rs7Z2E94_UQ@mail.gmail.com>
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
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

On Thu, Nov 5, 2026 at 8:41=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.3.2 release.
> There are 547 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.3.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.3.2-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.3.2-rc1rv-g75eaee7a6465
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Thu Nov  5 20:31:07 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
