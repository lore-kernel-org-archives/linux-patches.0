Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793833505;
	b=Ya6Y9muoosvYhVIMTfSeQKGQipmcruv0KdTJjrUyoigkBNpg2dI3R2GDxTFPRQoDSp8e
	 TjDtForNTj1vyW0Nw8mf+QcAW7n7nMK44QGxzWRsM86hPq65Can3fSC14kKR7E9HhkAE3
	 EsH4JX7WIMG9dYInW+RBLfy+Cyoy4AyUyyrrj5QJWd6gJA4ihLg4+yVB9LlIwoeklNviG
	 ZS6lvZz0lsPAvBBd+4ZWpS1shT+EBd/cxflUHzZeJ3cT3Es+lbiRQazh1qsptYgzfc8mE
	 myJrah648UacqQ1ktWc7g9eXdlaiwT2jZ2j8GSKD5BW2nU6EXl77SEJILe9nTgB43Lg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833505;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=fdKcInFwYxEQdF2Iwzxw4Nto24hXOYR2F5pyiTFVT6A=;
	b=auaLr5B0cxZhO9S5en0bLy1YLAUAH2E3gV6eQbLU9I2CmvB4HKqalYa51XGJqFZqpenr
	 MPYtiCYAU9XR8zsRDwOJJxYN+Y+1l1sniePfLRp6HJUprk0JFNNtSKapFBiwe6bWmatOI
	 YdQIb5mrwR1OsYJrRNFI38srzPCDbKdKVqJXs1+EX8EI8LTstrXt32OlgmyeK0WjGuwUQ
	 b74jWYOK6Oyge+0isXSCmfgwFYNvTh8SyGTP2X99l1J4B4COFXZAFbCdz4FrrNgkJpp6c
	 5Rh/lh9YsQbtGbhY2hiiqoZ5Cb14i2Vtzt8vQjmOO6r2gPZBubfCmbkoFDd7zmT0jzQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=u61s0dM3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B03606A337
	for <patches@lists.linux.dev>; Wed,  4 Nov 2026 23:05:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4B03606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=u61s0dM3
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36a0f27c9f4so2324995eec.1
        for <patches@lists.linux.dev>; Wed, 04 Nov 2026 15:05:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793833504; cv=none;
        d=google.com; s=arc-20260327;
        b=eUo16si5nwm79DEPQH/2aFutWHbaJG3Cz1jV2vfcfOcsOjmusKIFkZEQ6LtQLJz3l2
         Y3SbeDMn0o0ITx3TmRa6FG8MtG4NE2HaoiMt7yf9JunHoSMwpbesf3vUK5DXuxz5HvAl
         YeREhrEhfQO83f1KDAomiprBdii3yjMnW9I4p4ugxpkVr3dMq5PQ3Y+QyHVZ+QtnU/2l
         xBBByz9of1loTw1eBzid7pUQELLffNdlbtj6OvIHxP1bsjuioUARSRhvbIp9gxAJbVm3
         8FlRs4feVtG//UEcCqbNyugdUPuXz9fbOea1NhGnzzZOesCwzF9IeWElhJrSSagnmHCC
         0o+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fdKcInFwYxEQdF2Iwzxw4Nto24hXOYR2F5pyiTFVT6A=;
        fh=eZjNj2mlATjnpbEZ2fOj7v9V9t7IY1RhPJRdnZUW1nM=;
        b=cmRH/6ieyTaWlZ01mOQVz7AtamIoXJXbiZIsgIzj37AXcsbGx2V/RTSeixaCo6X8GW
         cVVHCYBakFyPRQEx6LhHvu9oShx61Kmi8rrBkkr1zDAqQVfEkhnoGs3LlnOrYgLVZ2Hy
         CO/7j+ZwXvArHYwkfgbYM2Ev7uIpLNWNQfVxG/swJ3ljdbmhTolDX+EFo4nTLl0ezVLm
         mTHIsQ5DMHWqjVqChdd/sLA5pviRhX+AYlclfc42CckBWpYZD4kx8r8RNaYASszm3EQI
         iYxvxHW+7xe/TQmNl1S0MDkS8VoOTLxrID9eob5GOmraZUupk1fkiCAwFFTLxt/J1QMr
         HqtQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1793833504; x=1794438304; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fdKcInFwYxEQdF2Iwzxw4Nto24hXOYR2F5pyiTFVT6A=;
        b=u61s0dM33tmYpAKfs8ftVMuo/9VWFN4G0YMltN9iHSw7xOGozMDZ0hQb3APM+My8Mt
         MswcVqHkrbnXCj0JpkAr2g0HcfiUE0m86pWwQgz2RYbxaMLtYlrybFLCo9dn6v++EWd0
         Qt37Kk2lCASCq2Yr9smOqF7so78/At34ATS+TPpbzI8lEGtgkfw+ceHEk6DKGhG5ZFBg
         PYF9H0EQLR6tesngggwp/0Ym9fEoXaca5okruYakidXi05j+GE3wX1pb3aYC6Eg5vW5J
         NGAwZso48oKJqblVffAX8xRC0RYB1tfPwsbkElULBJ4+mv0wxxzw+CS3Bs+6gyDTC3Dm
         DT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833504; x=1794438304;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fdKcInFwYxEQdF2Iwzxw4Nto24hXOYR2F5pyiTFVT6A=;
        b=VRvJU8K9eSuLaugvi6HaY2Z3b0u4rkBqQeRvAw+IvlD7cCtOOUU5swzRjUa+HxJzQW
         JEmZ33WXcDVfcMFX9c2I3x/t3Z1pe8/L3tqG4l4SArA+rv+7DPNsdT32rXVR1gnc1z2C
         WKE9kCrCO0UYzfy7B0tyjVW586qSDjLMptTw74kCWMC3zANycqh66c0LwynrTXNIKZmL
         1i4k/4pswbMcZxkLJbevzBTj8G53DEHqTBmna2hAP4J2UHTWc2vFb/zEKGEjtoo/IHLC
         3VKvA9+zKEiM6FskMSJvj7JFP65/8zpEjBfuLtXxrhXgxSF9LeenYp0UqBv6i5fPAmtG
         dxzg==
X-Forwarded-Encrypted: i=1; AKwUvBxbHtE2s9TpntVGOr0XX4/eW86SIbdn6xGOpKwWW7UBLlg70XmuITAOF98QRnsYV4LGr3jkHJsG@lists.linux.dev
X-Gm-Message-State: APuU4Z/p73nYL/ht6QCprUU1U+HCWQBMDbQ4p8MLrdwP0O8NQ/UzZ3Lp
	lo1Hm8x+ztUxAMCGFRtHBxlGjPeo29MmrX7Lh1e3xnK4pQiDVv10JLjv4wjeqZFEs++1pmK/+9A
	4AwfmkEGBsDSZirY36874EWCBlRdV3gnDokZz+3oPOQ==
X-Gm-Gg: AYBFou3pdepq1iFPIsOY1mSlCt6t8DNVJoU99XXsveRBxhNHFb8slAETarECX9qutA+
	Wcnn5QryVRZPcFsYeDkjQqV4jLyKE5kQiDktJqzyX+NWMVZi6gL3ldUpxhSzQA9aJ57r4t1TH2Q
	u9SzzfcTJrawBkSQ8pJGEeARfh2tUT5/E3EdcM+fWDvxMsI2UxjGR8g1pU9LSLdnQaPLueZ4kjS
	Y+bLZEeYBm2AsdsciExjIn5wv32guM37DkQbRYzcIXnsibahv6qZmp1QT9N9KUn7ywVgWbx2BB7
	Q8aZXuqOerJ31s4oTFDDmsvj/8yX36e9Cm1Ln3f5vmOUG5MvchbAKqrM1Ef4ZBnXEJ3qvTf59yS
	7C5nw3dbO+BLXe4tWcrCTtzJhBEj7v24QBpSpS/uxBnD8lBVY5qgunhRKeK2NTV6KXt3MK73cov
	bMcdTnPoFGEUcEFcQE/aZEHoWWDHAdyJB3QpZVd4Q=
X-Received: by 2002:a05:7301:4246:b0:368:7c2d:a612 with SMTP id
 5a478bee46e88-36a42345878mr25113685eec.10.1793833503438; Wed, 04 Nov 2026
 15:05:03 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20260930152347.700140858@linuxfoundation.org> <20260930152351.156698628@linuxfoundation.org>
 <auj7ZUcOlNC-rEnk@maple.netwinder.org> <2026110444-preshow-shelter-42d2@gregkh>
In-Reply-To: <2026110444-preshow-shelter-42d2@gregkh>
From: Ralph Siemsen <ralph.siemsen@linaro.org>
Date: Wed, 4 Nov 2026 18:04:50 -0500
X-Gm-Features: AclHuK9ErX2cQvIR3BHxau2O44hKq4GbcDvQQlooLxeAojfKv2Z3D8f5iBXKHQM
Message-ID: <CANp-EDaxZTff_UvEwW0o5=0XeDSzO3edT-aPodkXwJ2yuiGN_w@mail.gmail.com>
Subject: Re: [PATCH 5.10 159/595] gpio: dwapb: Mask interrupts at hardware initialization
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Liang Hao <haohlliang@gmail.com>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 3:52=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Nov 02, 2026 at 04:06:45PM -0500, Ralph Siemsen wrote:
> >
> > This caused a small regression on 5.10, details below.
> >
>
> Can you provide this in a format which we can apply it in?

It was submitted by Miguel Gazquez and Sasha has already queued it:

https://lore.kernel.org/stable/20261103-dwapb-fix-v2-1-9bd3785d1365@bootlin=
.com/

Regards,
Ralph
