Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794123748;
	b=d31OaHQzDet9eUcTPNjEyPdbpJES/bwWqgPxea+FXdSQwbN6O+cLp+UstxAWxQWNaALr
	 7fH1sKqZQGautXfiUXHXmFz8J5FEPk2ImGbUsf0dusDE7PxyBH61XXy35gasSaQEAMii5
	 qUtR8WSOHwHiraOGrC840nD4VOeiT4i8734cRO7P7IZXKoXHFFGGM1yHLe6DCUk7fve1y
	 0E8DK3d04Q62sjYqXeW/7e09Ym08FckKKbBSerEbCB3ojq2vbBS67tSykwfAA1tJ9blMB
	 gHahZ3wDY90AfODx0xof17eg5J5KTP0yOu7NaoK5G8c77Q8fM091VOGxrJ6ZpxGXjrA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794123748;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=VLNz6RHfyZ2V0vojI2Wyp9rbbg58O57zxxjtT74LsU0=;
	b=E5N3ty2G2LJetad6dCDETk3ziForS0Uqotc78k3oXwczMezXou79wUHR8e7McwBP8BPj
	 U1XMVg7IOLcaiM3a0FkWK4So1ncmqCiTliRjrsjPj5hA166N0gJfz9i1qihxdOteNvZ03
	 P6paKsqQNTcOT4XOAd/QQSSsakXqJDtZV52qofE64uIaW3TLmJBPUKoS9QXisI8hQ+kPE
	 RyVjqPR9J3PCgeUtai1oZOBWkTVL7dD8oHAStul5WYEPikh5u1xWaOVcHjfJlZIqMHa5m
	 qle37U+erd1cU9x+F0o2FNcEkIlv2sa3pYDpUiTANfXm0MWhPiGqX52iLVbY6j7vYUA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=futuring-girl.com;
	spf=pass smtp.mailfrom=futuring-girl.com;
	dkim=pass header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=W9DzEUS4;
	arc=fail smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622FB606A320
	for <patches@lists.linux.dev>; Sun,  8 Nov 2026 07:42:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 622FB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=W9DzEUS4
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b704171bc9so200745a12.0
        for <patches@lists.linux.dev>; Sat, 07 Nov 2026 23:42:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794123747; cv=none;
        d=google.com; s=arc-20260327;
        b=F0If2VhUW0dvrzeCLy4MncTAORguxnvAFH84E7B+XdqZD60OtexOs6BhDzKAmWGT6t
         ozPRHzfst7B7vi9WJYHhMaUYC+2yqu/KnCGokTKV7YPOOsD4YRS4+tL0YtHvTUlNJWmk
         SfKSZ6GGWmqmn1O52A+EgeVChiJYCObLXXLRbTSjOLEFmw0HwdC8xO0D8tAj5bIfA7P9
         2AoeSeMDTXMIFjxPFELBRimoZQEPbAifvtkBrln6UO91aPnMXbq+XsFSHJ+DXGb/GR/5
         NJmQu73EcodJrKFigl8A3YC7QvepzdObjU/1b/LPjYB6Wx0BGYAA+O0MUn3iWm/zsL7P
         gO5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VLNz6RHfyZ2V0vojI2Wyp9rbbg58O57zxxjtT74LsU0=;
        fh=QPX9sPZlLX1UCb+olueHhkV9fcbeMvprlrHCh7K4vl8=;
        b=IsmCar6YZuZxszgHRg/H/CB6Kx8V1RpBVevQiJzNuw4Ir4wBWuXX5fhBzBOjFFn3Vs
         w+VVLyfioaG360xs0qzbNuEzqGyi3Gcb54jq9hnixpGH3hmeiwY3tmKvA9kW5cBQREaE
         vro/P26yb5ixL7HFGP7turyrTuVDovgj+voru9vBKF44qakfEwZiV7TSBOoiBAwEJuvC
         /L4Rt0f7gVLPpaczU6vluYgkgVuK0SwxkmswPX1DqzER0u4v1gbZ774+ZU+6o0xavcQa
         nCm6nyOgjMpAVhtVXAJvbdL7EhS/mGwaARZ/HSGJgxDCMaFMFBR/pjnh3zi4Nr8mhGUG
         PHww==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1794123747; x=1794728547; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VLNz6RHfyZ2V0vojI2Wyp9rbbg58O57zxxjtT74LsU0=;
        b=W9DzEUS44NiCyN9VI9iSUNOQ/TNVMHGJ3d51Z0tqwjtscQ2gJt2o7GxQi+e5K5i8mz
         C1DYZV5FEUZHhTAUzb+MSnOi8wMfGJlgoit6gWsBXENxHDOX0AhTTkbz9lTpPVqwxXyc
         CVDRv9T/35m5vtDRMQQdq2u989yLl6DZ+p5rksjc5llbuEmOJODAqxTKLLx7f4fOuqHh
         6gtfcmx5hzmSkgdUT6zfx18fykb257XG0qpnAGW6QbfbVky5Cf9ExUAcdAno0Ei6LBtM
         IQgDKMoBQw/3RZmmROpAsYhrrtzmhOkOWT1+80zYQsRJ27e2wV2+mp03Zp3R6KHl2YOb
         yJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794123747; x=1794728547;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VLNz6RHfyZ2V0vojI2Wyp9rbbg58O57zxxjtT74LsU0=;
        b=PIFtjgd7opFSpVFoRfmjgUHcxo+zLQL2ah/+8lRE16id6e7kxrPpecu/ORLFFZWFas
         4SZPMqLIX0A8z60G8CHrtTtPzVig2SefZh5rmfLZL3tsOxtQlUVvy2YnhkaMXi7LrYIJ
         XbNagRr4HBYylxyMmjs9WwaxC+IDHy+Z8BMkysdmtaZTUhi11thmQNTSuWWzqQI9/y+x
         C9CxntFxEu0ucZLreyslRImdSzlEOrkquOY9VpSUvZGtZWO5EMo+vcTKUyLC52K5dCTM
         ewZ6uTML1CR0K+Ga4Ob1oNR7qHdFi31nayX3DuAA1jILZtCsRQSjdySvwugqL8QR4Xbv
         0DuA==
X-Forwarded-Encrypted: i=1; AL+hErFeRyLhWnRfqHdvud3Fdab7u9DiZHQJSOcldoAd7alOvWPVvy7z9/nDgYeEgbev57QJcDSQJzCa@lists.linux.dev
X-Gm-Message-State: APuU4Z/y3v8BVUzpnSf1EA7VLIap/rHtJcNKOria0hc9nIUkSb/EYeTx
	PjKmxM9s6Benq52QlFU6iFaLI1H4QfF5f4lew9dhfvm/AtCQz2SwwDt7rgz5051x+APoz9U1+Jo
	ggrMOIwivlnPTjztQXKHE31N5B9a+sTJIsl7vR+MIvg==
X-Gm-Gg: AYBFou2QzylIDogjLxJb6MIHyLND/mWV5Q/2ccTa2eRe7xWvcOOOzuBkGGXHDiTbK2F
	GP+cubQGPHiXwdsDgDeaSuRAiO72OqQpbI0NbeWyWNWZepylZQO6fJRTqfOWvBAvegcykqnunkJ
	FzvNFOKOI77pN6AEGGbUmBeO6AFZkEh4xHXzCF1QFFnvcnbmuMxeKsPMbTOmHUULo2MZ7dq4jil
	Clb9yTc5kopjT7nCwFAP0aT635P9KBtgQ46xdOJMU+P/ryUOWu1pF0rMHeP71KZA4lSDjmgfMBn
	tp3etxanHShNmgqcf4R7wJ5TE30e+rHxAQu3o1+9yoBZQoGxRZ+NR56pmbsGvtDGWLsBtUFeb/0
	1UvrRPIOmz7mFs/rDjR3HFSPiONa8Tyi06Gsc
X-Received: by 2002:a05:6402:2b91:b0:6b5:96e9:ae97 with SMTP id
 4fb4d7f45d1cf-6b722484ae7mr465101a12.34.1794123746308; Sat, 07 Nov 2026
 23:42:26 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261107134939.434104957@linuxfoundation.org>
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 8 Nov 2026 16:42:09 +0900
X-Gm-Features: AclHuK_4Y2M3DeuqST9ji-ywEkqYo_2N9_-1XAV98U47LHLOvTm2zUmbhhFxDD4
Message-ID: <CAKL4bV507bkW7uEgo4BqgE-ADALXc_ZhH1OjvwUVoa0QT29ysA@mail.gmail.com>
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
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

On Sat, Nov 7, 2026 at 11:01=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.3.4 release.
> There are 1257 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.3.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Linux version 7.3.4-rc1 tested.

Build error
The previously reported issue has recurred.
Built successfully and confirmed startup following the procedure
reported by the previous user.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
