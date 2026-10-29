Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793246489;
	b=Zq975E5oX6qCI7D2eSAlzYjcPed1Ab9TjgacqNhKZ8W80Y0WEKN15rCtObpGEs5wvw+J
	 jisr9S1iGs8j4J/6U/fqdZmT7kdSSKTeuYl0h7SjTUB/ABl6YxEEvSsWQuu36PUYj4nTU
	 lRuXg/DisJFh5MDLpG55HKSwdpNxM9whi+JoETNoz/vy9vKwV+kzOYhkx+4sL/69vOazY
	 h4+kZrH25t/jGkC/spZNZt7n5VnXEZf4EFeINDdK6NuLAkvHwEXNjmZxGESriCeUbdFsn
	 16A4p+4KuoI2ohDK64K/qpfvNDBOcyKBf3M+EaXFueqQg5WcaZkb8LruDqQbs8QhO/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793246489;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=iT3nE6ApyimTzCCmjq7oZisX15Tvs+j3ci2D6D926xs=;
	b=VdnhzXVCV6cUPr4dZ/FeVErRUHiq6wIH7bFtlk4EueYZM1jB/+RC0PCMiwAdZFB/aFTe
	 b8JS5EVxHAzb/sY1mSB/c4/1dQ5R4UZZd/DkHIyv16x678UwbpUHhiuzGU9ctdDxJYHys
	 JcuuEmnNK4ovhZ4UoHnOdiKR976r1xCrpc5Y2M9bzYR6jGMzfchSxf+Bj4OJI7Bi9EaNt
	 Nyh4lhy6J1FBcd8t7kz3R6h5VAwdOWNyOJ0wiL5ykbfwpIm72gD9DSx+WY+q/IQ+fvV6T
	 LuvK4LR84givJycVr0PgFGfxcNLNAF8T9QoQvk+d3EjtKZubAbZ2rO3QTZO8UArc7Eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=futuring-girl.com;
	spf=pass smtp.mailfrom=futuring-girl.com;
	dkim=pass header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=t1zXQ8Bs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47216606A31D
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 04:01:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47216606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=t1zXQ8Bs
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b488586facso2190087a12.2
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 21:01:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793246487; cv=none;
        d=google.com; s=arc-20260327;
        b=pd77U7lL4bnOXeZe90nENQx/llxyE6XeDYiH+6Gvc5pp7ia01Dd1/y62bnwmqJL6HS
         Wl9shsuiLdlE5VD/l6WzQxqWwhqati23sSs8DLIIrlHVwEGijengm9dz1Ph5dxRqXcJ7
         CRBPBXoVThQMob5OmSfYItcPnUKVj9oC4Tm4nfV8c354lqnR7PEXD1GlBpRoNwUFGsMF
         IiGUdTofbPXn4mbYf/4TpViYaD1pzClCWkLs8d32g88IzsZengqtFIPB57luyNiiyBLa
         pbLNCZXhfQuMjc67CPxGyRlDCKufInFjhP+7MNB5ZbAHqn9KonL2wsDCCfbbEHLurGnn
         /+ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iT3nE6ApyimTzCCmjq7oZisX15Tvs+j3ci2D6D926xs=;
        fh=QGJ6gyrBcSGVfdVz9TmcxHodmn24x3mc4r9gNzyIxx0=;
        b=sg8+AQdIzfTKDJXdtvJLYQxhUzIOflr4IOctz+RnL1cuQRHVK8Q3qXvb3x5LtCN+7t
         DCrFo1kXDMIyTA2X66+9yM8ybbO8c2Qb3kZTJ+rCg1Y7rkOxrdJZBo5FxqoupzQNdrzb
         3J6MuOrI2TosvlI8U8qbr8633wPZSh0DwIkjvs7+/NOjQRre3uaXkEU8DD/I/UyftdUf
         3cLX1yhNcCOUjPl+D2UGDRQS4JpN18WFxzyn4zLNQYzNu6EL5z/6lus77W2MG6kqAQHE
         FoLp0ISDiChx8vi6NnXCdqdLZmBt7Ie4DHKG9ElT8La7MNQvf433eDrKFGM1DGFFNa4q
         eidg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1793246487; x=1793851287; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iT3nE6ApyimTzCCmjq7oZisX15Tvs+j3ci2D6D926xs=;
        b=t1zXQ8Bs86fzFdlXZyplIWPAJsYHf6s5nKiHvbtAEXRqqeRQ5ZJLQK5sSvUMGK7zAG
         XjGvIgmBurQUH+ddBGWVbTj1wHh9il5I4bL5ibtCnK0wjyb9tHBkm2ZVy8mflUk2W+oZ
         1AHZhtYH1skUo0kvKWeOhMUZLZcDZt/QquwQn3GeGL6t8Be4WZWwDtBmzCemrH88TWX5
         heFQNGe0f8GFqRWm3vcxnqmbKXC/MKoYN/E9nAHfCUMasnpfNk9m5sNTcY1MeuCNuvUl
         hoRC6m5dD9Lf+5ak9NG6Q2U0y9qWNz0sYyoD0a3Bu69hUPbO4aiKLJ3qyWhWNKwE0rsY
         3ALw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793246487; x=1793851287;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iT3nE6ApyimTzCCmjq7oZisX15Tvs+j3ci2D6D926xs=;
        b=NSS5z2/fG1RddM7fThT3YMdY2tZqS+qY8gFlw7Fm0as+prnyyIYRrCI7yTaqslhXo8
         xFzDfUCBd+vaCUdbzKK1ymdUGexdN1xDBN3IURiDX6UyPNnAfMN7SKjvNSxkjZFqBplX
         vAJn2tiIs4jwZNlC/v5tqlDR7AgHxiMdbt9dhtgz0fkgL8D7BVVW3U9BQbvgw3Gjm0h+
         XNOKiJlHQXF2Q7OnTtNUFiPLUwnly9y//95qJO1XtHGmKLKoyEkivaobNWLlLxyLnuZz
         ofvDXJFR3l70MrwekoEMzuVWwMigwF1YunA5nSw/UfMGicHl75dik+qePIg/I/vJ/UOM
         +zXg==
X-Forwarded-Encrypted: i=1; AKwUvBwVtG90dhPdYiX0hOaxiN4LjBC0IpsLKjK/1PlAoB9CxxXtxu/AVckgI3xRMP+NFgEl+FT//xZs@lists.linux.dev
X-Gm-Message-State: AFq9FYLOxiSsOuSIiG8ccWpmcVTWo4U/fndybT2Ix6Or2U2reboPj71m
	u6tek1ewZyeDD1/m/p1B6DSnKjIcCWtjOQXghgEcNr6ToC0hrjBmBGgLrhBE43hc2csQisyFLSJ
	Yl+gycjxVQ8YzehS7497qoh7PeJCGHErl2Bly01itag==
X-Gm-Gg: AYBFou2ycri5QbeE+rffoz1iqIZybLhsheLKIbxDKXnNvx2p+nvhRbQI1ibRMehOAaz
	wM3dCDH+Ei3pk1fbXCfnsSNdk9z/SE84hZpl8UI+UEqPLrprzVBFaHoK7uujE9bhu7r4bRFODpu
	gv9f3jlgb67rSUy8SpCQ1pCz6t2rr5jAmdpG63ciuNnRTn1ht0WXQyLUXABRR0hr5PC0jj+iMD5
	hbxG2yzV2+334DInuVWiMONCTN+H3JNf+qdi6KawbAwaya19d5ZMgRnMW8npXOu1jRdJggxWX34
	guVZhuiSpsxfCy6nzRDMXJmh8Lt/SMAjSD4IJi2S/ECIonXo8TmVJdP3c0sd114MRjXSiZbxvqr
	TMnByYpsBv7W9KrnthyDKBjOIesboMdIdwLzblQAJfBzltQTNaRIe9ZGrLVyZMdkJ7RCqH2Yq+H
	6MXWOhxE2wubTu1X4=
X-Received: by 2002:a17:906:4fd5:b0:c40:d920:747c with SMTP id
 a640c23a62f3a-c49bddae15emr389406866b.7.1793246487395; Wed, 28 Oct 2026
 21:01:27 -0700 (PDT)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261028165940.394092994@linuxfoundation.org>
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 29 Oct 2026 13:01:10 +0900
X-Gm-Features: AclHuK_TGkwUYP149PAu5-_zJUxgBCxS20qXFuFYQvsPLL8tgUO2MuyiuzkyUOM
Message-ID: <CAKL4bV6ci2U6YcAYniNgZq8FL7QUsSjM7GPJE4BqmK8F-Vmczw@mail.gmail.com>
Subject: Re: [PATCH 7.3 00/38] 7.3.1-rc1 review
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

On Thu, Oct 29, 2026 at 2:07=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.3.1 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.3.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.3.1-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.3.1-rc1rv-g57ad63e19488
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Thu Oct 29 11:59:18 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
