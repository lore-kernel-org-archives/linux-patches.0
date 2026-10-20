Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792504349;
	b=TJoetnq+AMojodytxcLEKoecxC9ywVfd+6l37dxgMce16fmeU8sBThNYVj8KoLZ0d+lH
	 78MP6DEswg4Fsb4hkl+yHC5+q6sNNY+I5wBDt+VKoJ0CkA5N8qnblOtjxk8BNVdilJOWC
	 dFGh3wdOeYwe8wp+Hzh8cePafoFWgB36Qzh02eqI5h0U9z/gqVX1+enKFjPadkozHVZkb
	 08rq9l/Gw45CN5CHIED3LNA2PNdSY7ucL5PW9scnWrmVCSrfxlh7WlkPS8+FO8mLDm+gI
	 MJ9RygnqMP80wnQdYz2qRWlUzLqWwE6gyngXCOwI3pQHzwdMGpru+HLJlR8SNs7/2Xg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792504349;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=k/hbwlcYMnNfV2mBX84KMoYZ1kQ82mEtSuTGwp2XYJ0=;
	b=wa6eMZf+IPZxw7g/Qv1D60p2EMGYQl4YciQvJZB7YLHfFO+pBul/X2T8oQCkCHtdjL1h
	 eboRpt9iwjNR9po4gzeoqvw4QIDgjpmruFYmSpx1GpLt7DDXajUXPIv1UFfCdux5wGw6F
	 VPanjSeJPGD3FgeaGt+5SJQm6ObvXJKq8IEebPDRn5xDtYTkl2FEieERbai3DcPydJSOQ
	 jH+2huY8e4SdML8ashX6Hp8BMnZjUTTN60mgE/mPj5UnPol+1VQpICSPoIzIJFq4fvlsp
	 vhyc3R8lK0Frqdcvt56qw+OMCDpcVpOQNt28tHjhAngBItk8TIYbBKSqn3yyGoC+1xg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CbA9Nkvv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3AD606A32F
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 13:52:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D3AD606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CbA9Nkvv
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8a070781f63so854848b3a.1
        for <patches@lists.linux.dev>; Tue, 20 Oct 2026 06:52:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792504348; cv=none;
        d=google.com; s=arc-20260327;
        b=gMhAvD5tI7N+W1GZtJIS2yxqLxRZwD7J2tzvVPfdAQs1pgNP8KCp0K+VuZbYrijECw
         R4Cntiwp336bOpMHQlyhh+Gtux348rySOnXbyvSYjUjHbZ+EZSEOHH0lp3Y79LPju0y3
         cOyWBE5PgpO0l2WH+tET2jwnyg8vFt4HOTdoGnccaIYtblfGIqy+hcUJbXi2QqxACDZb
         +2uXC2aAjzyFiiIWrSNOZLAJV0yB4F2znk5cDrJ27FLlWaOZAPV8NgjM/ZDzKQvIz9Kl
         qRhgPzdIblu0McqdgYsNI2kNL5efyJI2LJW+iHzFvBMOJIL0Mgicoa9Mukv7HTwL0SkZ
         FGjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k/hbwlcYMnNfV2mBX84KMoYZ1kQ82mEtSuTGwp2XYJ0=;
        fh=rAiyJned8WX9lmoyXku72VOd+Bo+hQezGGo7oPfoI1A=;
        b=WgfGd5VZV43ktiHk0OH+fJcgOMhQwWNnFnmgdbQ10C/uHRnxZiaoJopWXhwGBx4sXD
         Zt2Bc7ICEBmHmrVXaUjcj68wMDiGVTex+He0VOsFwjnJ7UdNjTnJw/QJcZzeuB9AtPal
         mYm9kP6fYWDJ3EPFk3K2z5uHtdjrXpgS7Yy6geB4DVv19X3N7cr+wZyYAcsV5n5dXb6s
         YwgaC1kY5ECh/NIxQ5cuKphB5PLjQI2zUhsZW2PfXQgChQGXtybwfvRkf8nm0TyF1ywJ
         j9DnSqCz3F20V6TzI7LqIpsesQklYQmAgYo1NMrSi1y0FMPD3YQI5UtIHXs8NFmH7T8I
         ok9A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792504348; x=1793109148; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k/hbwlcYMnNfV2mBX84KMoYZ1kQ82mEtSuTGwp2XYJ0=;
        b=CbA9NkvvigKa2lWwEWzMnR4+9DEj1i5ppfj1H1QoyAUgdsEa4Doq7OT352u8t4xGWC
         Ex6rOJwmRLuZBeLg2cQ2yKeHQjGXmMyI7rg6H5W+eBMmLjrTCocMhPQ6WCgkEgDqCLEG
         8ehBy7P69+hWdgWdfKl6hx1FXC7kxJFpunKpmAYQrs4cwCEkDFaLUvMI6lU6OJoLIyC0
         KUGkb5QQbA3I4gxQiKYeDiRze39i+J2e9SLble07noPHhiK7FxTuA+IP1ooIEh9UjJsQ
         mc/7HBuix0NadHD2LxJzFCipKh+nK5ADLPDambkcvWZiaOIc6PrQHlFhJ1XAKNhpc0r4
         /Xcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792504348; x=1793109148;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k/hbwlcYMnNfV2mBX84KMoYZ1kQ82mEtSuTGwp2XYJ0=;
        b=H8PnaxCkt651AiGzUWAu1kC8jmSfJRk57+xizmIq3eWTZKG5pnATgTUv2gGzffnpkx
         zkW9Ztht0ZR7hSSIS7HfUkLzqeqPsX0MQg4tS2UELY9gCwssMOWyHsxVXdueuKfepSl2
         LaAyyelce8ZWaFHVepUMUWSj/e9XPb14ukUyxUY79QoNCY/BnvvNINcGckC7oqREkrSg
         Cp9VfM49sdnR7X85zsdesqI28HH//xsJF2pfYwA6MnRjuidm62XvVv0H7eBXLmTv7YDc
         /rW1WcbWpJP+K7i9ereJU6Xj9gvSknzeSjkmrbJu3kSCAKY8kjknXZW3Sxbi1YPqACEz
         Zjsg==
X-Forwarded-Encrypted: i=1; AKwUvBxXpTOxge1ifMZ9yYn/fm6t7xoshKVDWWrP4mVObJntEl7q0xh43TyXRWXfPzgQNm3cFwVFpOOf@lists.linux.dev
X-Gm-Message-State: AFq9FYLRbxbk4BtxbbyK8RyEih1I/0ML6I31f+bODTZp4nITn6lAi6Xy
	SS/6HFR3MeV2vx1EAb5DkFkoIL4RS9vvROZQnxW8gJJIYUh+abuFh9K4MS/UYRivd8xLHkNqWHs
	zNLIryj2j+otj3p5aPiJG1Tv6ORl/QMk=
X-Gm-Gg: AYBFou1oFXcEFykF2MzvaCDmNlTPf3lj8WO+I0ysdNTqTqb2YLDrp5afTtY2zpa/jeA
	KK0+LAf0sDiB4KRBk4DiAgXVzTVTvn/6oRbceRxMYztrZSQ1VLGX5+9W6zCykNxc2lB2oaT3+lo
	oG6o89tLX9U/0ud58nqHflpGsFq4mFmB5wsiXzfoD6+0LQ07rw6Z7H+RGa9tFDvJueJQMHY/Pwz
	o8rVZVcRrvaXxNLbu3Snd4T5Gt/kqdi+q090ZWLNXxiQG0nHFlTJn4pX3BpPcbQvlkkBnh+4UnK
	x9NLEgGZPkzNxfQVWuDJyYScKL22rjHaM7HRCm1y5Jawyyj9Q/yBECrPbby6VJUiEsXQ5gChYeP
	f3xQIjvlFidxh75iWbLyAYL+eWzWUEEwgOsKky2cd7YxA8ImuoW+hriVKyf7ouY84qbTWBQUvUK
	yD1+92q6hlVlSRw2Y2ydq7ZTLqArYj2M3QfgYOEQ==
X-Received: by 2002:a05:6a00:2343:b0:89e:9c7e:fd51 with SMTP id
 d2e1a72fcca58-8a04ba30b92mr8261328b3a.10.1792504348492; Tue, 20 Oct 2026
 06:52:28 -0700 (PDT)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261019135441.1420968-1-sashal@kernel.org> <20261019135441.1420968-252-sashal@kernel.org>
 <20261019172836.GA1885@quark>
In-Reply-To: <20261019172836.GA1885@quark>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 20 Oct 2026 09:52:16 -0400
X-Gm-Features: AclHuK-B306P9cHCODywZCNc6I1CxZirkEbtUGcvZRPSRQ2med4P2bdTR4gz54A
Message-ID: <CADvbK_d3hcGcP21Fy_z9hkoSuQT0Bg7111Ejns_WxOYfCCGFHw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.18-5.10] sctp: auth: propagate HMAC calculation
 errors to callers
To: Eric Biggers <ebiggers@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev, stable@vger.kernel.org, 
	Qing Luo <luoqing@kylinos.cn>, Paolo Abeni <pabeni@redhat.com>, marcelo.leitner@gmail.com, 
	davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 1:28=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Mon, Oct 19, 2026 at 09:49:03AM -0400, Sasha Levin wrote:
> > - Residual in this tree: `crypto_shash_setkey()` failure still `goto
> >   free` without an error (mainline HMAC helpers no longer have that
> >   path). That is preexisting and outside this commit.
>
> I don't think this backport can be considered complete without handling
> that case.
>

Agreed. We should return the error from crypto_shash_setkey() when
it fails in sctp_auth_calculate_hmac().

Thanks.
