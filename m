Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794102263;
	b=tKQuEoKPtVsYSvBgQ/52Nce2zsrkcgc17RW9CRdp8NhCo8C9AycK5xbkmjka8z66bRj2
	 mgdXlYYe9QEdWUZsrn3ZM9aOrPXtgD7iykUWnXtgDAX4HP5DjzDLFbdsNeqH4SR+nMO5j
	 /ks0XV7BTFQ7GhkcMgn6sqo8SOJzoiWUGv4QSng8Sn8odGz3YSwHcic3dniTzM0veePFZ
	 gMNgl6pt291C/tcvda7u4jZf/H1jd/nS+Wk5KEtkGxGfcaURi5TkDoiYBKBhxKFM+1QBq
	 FYWFnNBwGs+5WVNxcIuTB6exPdlReV2bddtkM3YkvAVevp9jPASs8L+b9prfKF3Lenw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794102263;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=/ej/hUBV1NBOGVDMaP5rt4w8zmL+CLNc6ALzKVqxDRc=;
	b=mannT0iYI4Q5o1kJ6ztkD2FrBljMpCJ1K4Ihwb6JZFKBs4uRVCftb2bhdqTIEzlnk6Bx
	 ptVRKkNKCdj14qxBVX1Dm49Q2qyBH+0CjMS2uIGvRpG7aiA9cssOoj+Aabfs04+xh6lGt
	 GxLd+HENBUbq6X0gu5HhGX/IQMzHx82R7M3PD0mK5lksrGx1o9QpGjSzuXycWa0Y6HYcU
	 NRioXnacDxruRFcc3oUUnocnkWwYU6SqlCvnIx16rBIAsU1tONfYi8mUSIi1rahmY6oV2
	 3wjvN5lk9x199u32haL/lyaymZhcc02C/fTT2IXNFIF5lUw3t2mdft6HLNad80LrySg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i6TVdUzt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E51606A326
	for <patches@lists.linux.dev>; Sun,  8 Nov 2026 01:44:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78E51606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i6TVdUzt
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-35159e0092aso8571eec.2
        for <patches@lists.linux.dev>; Sat, 07 Nov 2026 17:44:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794102263; cv=none;
        d=google.com; s=arc-20260327;
        b=QoGRXnKwlk0wc41RGjN6kjTmlLmWbjCNhfw/BAieX1O1fSkpmKFlKZU9+RSsxC4qHe
         rcH7zs1h2Q3spljI+YUvyVux5SbrB4dIH7f2P/53QyJt6VH/QWHL7kP3IoxKmJxN6uvS
         qfSANt09zat4f2bOMuMrO9Ub5C2gdYP2sG9+kvrWlixsgdvFJIyh5HEWViuIR4v+wO1x
         a733RrZhvUSEOmTX/5L+14xsxnJscGhCa+UrrqV6Kpndo0Nw96kt4N6Iu0OC9CznRgpD
         lNd8SFlKpfhr8WlqIKsfA7Kyq9qruNB1IqIr+SIW1DlJELsw2l1BTHksFGIkGbDcW2WP
         vfIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/ej/hUBV1NBOGVDMaP5rt4w8zmL+CLNc6ALzKVqxDRc=;
        fh=oI2h5C+6Xk3zeVhYd8Gpb/WUV4tqYv/VpjoK/Jte6KE=;
        b=Gid9c4OJyStOIoXMP70akpDq6RkBW/7h70mu3Vm7rZmYVQ3o214rOIpL/n13yoeq4Z
         Ai9RTkmXQ6y3WgltHb6M4ZK5PS93JhlvxQsefTUhGco5xgJXDGXWhaqZ9f9ksX5h90fd
         BmXwRzwwPFY/S4gC/0r0BhveS/GymLtr+tuU9jQeIDBBdkN701N+o0cQeg0N8QLjiMeA
         0A62WFm6b+GA4TGi7ZfIlaFRYw6tbc0WL07nYsOY43c/IOv+ffVClMvowCK7gK8wu59p
         Jc/Lc7Sox7bZW3QpvHeLulTTNZPjNbQJCu0o3Qtqdta/1Viuj7dM44dUSNWySuY8c/zM
         kWRw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794102263; x=1794707063; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/ej/hUBV1NBOGVDMaP5rt4w8zmL+CLNc6ALzKVqxDRc=;
        b=i6TVdUztDovzMaRHliCBa9LQKyH4cPCPF2H69ttGXnMOsJV3g4kAUmUomeZJ7IOwaw
         vFl3k7OoOUTO35bqV5dNZX9Cc9W6VNxq+mdMYuyS0J0rkun1qoiGI/YIsF6+sxw2l6Ma
         rZFB5Q3SaA2iaUJbDdn4hP0AJXDH6xFp0z4P6fGUNc1i+X5UgEYJbl8jFdJhrerc6lVt
         RgZoFKGUywEqXykWEY1Xx+p9MhWz9OIxt4o+mtx5U6DxfSdc5Y4cqNfZkjkR4hqplz75
         sRSV/nRNCGJfDyR3LINrDnrwUl31vuz/tNWD3IBOSfsvEEV37Xu5RKeFWojUIRaZSVJ6
         0mIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794102263; x=1794707063;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ej/hUBV1NBOGVDMaP5rt4w8zmL+CLNc6ALzKVqxDRc=;
        b=z+2FZllhghfT9NVw+/jaK+ziwO5+/fOmDLCkMfbYncOEEIzgiTPasdHhlM3B4a62DN
         GoBkRSs/5WugPdLekuLyP8olCaUdbcuca6NFjnKISrsN+dLq6suvqXTC3D1EFlTXS1oO
         kNEn14ARsM2df2m1z6tqEpyTxJ2gx344/EI/QwvpaMPUX1SA4jpSxNT6ImJL5YH2bsf7
         RxntHe+9p2NKqeRMa0g9oiXmxJsS2ZRqPxxFTBlR3y7g8YuBTAOyKqWwre2ElbdDec9A
         jhP4ILPkHGwN20lW/XQtGyOMhzMfX65VnoCC9meOzTS1Z8DMJ2cTaaONl8pBi/YzRr8e
         q+/Q==
X-Forwarded-Encrypted: i=1; AL+hErH5WmQ9dL/J5lVzdG0K7CQ+eC6OuvHschwSY+4ps9Gj6uaLqvDdDlFF0pwfYULsA4B3MEFMAl8D@lists.linux.dev
X-Gm-Message-State: APuU4Z8qbVy+rQogGEeKNG5WWMXhvH7suXvhMk9joyT5BtMRzPEy8iqi
	Ilk7xRtUdEwdxfwDPZ6OQR3Tggm7kGuVEAxVyC9laXVTCnAFfQU6+OS8d0j7aol55pTQ4OZnTyU
	yTr/jJ5s2SQd2BcIgxPeGNWOMbMDDqSI=
X-Gm-Gg: AYBFou16zke3eVlGECSDr0x58zB1iYAk98gLeOUGhiVKV7XJPg15NMIs08TaWJ9TkNy
	3MM/luDJi7mGSfxzi0rUmdgO8ulS52I+rMG9zezLNpsCXTMdcm3cb/p0y85hsCyl5aVTEIrTOmW
	EIgmuNNO9bNcZK42T0AX/8Olq9Ur7PhYdC/Gosy1noTCGE3GFMKdWT87gROdgYfcOteUewxyMD5
	fTUuwXMY3ULU/mIlS+XcAeNxjgBy582JsGD3E/M1wiStLRdgYvbIFokAw8qEiAEzPgu3NsfXna+
	+nEv9hh2oqAyo7orQ+Z4NDqByo8KC0oi8bXyTX1MA2sVIl3tNn41UDMgbKACfxRcteFYySnkF3t
	K1oUyyLCdT4BokbPOa8bHYXTl+W1zz/Ybd1HQSUaPVBAdbA4uRDm5iDLRysRbQJeC3Rh3HpBHbU
	W4Z8J24O/DPqMgPscwobLz59pY9/nosHdFHAwaXtl65zBH90xptC+nPENTY8E0cnRBYRn8B6Npm
	5J4dfAuCHwo6hiKCno2PzPfx5ktAiF8GJaj
X-Received: by 2002:a05:7301:6e8c:b0:36c:a1bc:6114 with SMTP id
 5a478bee46e88-37250050596mr1795949eec.0.1794102262529; Sat, 07 Nov 2026
 17:44:22 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261107134957.653319350@linuxfoundation.org> <20261107135011.630471081@linuxfoundation.org>
In-Reply-To: <20261107135011.630471081@linuxfoundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 8 Nov 2026 02:44:07 +0100
X-Gm-Features: AclHuK9nmE6X3XMNIv0YfpIZ8wppVgI9hnqEEIeGEre_LeP13ZN6imhA9BOOMSI
Message-ID: <CANiq72kgADu2_hr0iK3E2+8HjBNww_b-w0K0_3Su9hCeLiMeYA@mail.gmail.com>
Subject: Re: [PATCH 6.12 0505/1536] rust: allow `clippy::as_underscore` in the
 generated bindings
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	John Hubbard <jhubbard@nvidia.com>, Miguel Ojeda <ojeda@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 3:23=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> [ sashal: Added only the as_underscore lint allow, omitting the unrelated=
 cast_lossless/ptr_as_ptr/ref_as_ptr context lines missing from this tree. =
]

I guess this means the other lints (from the context) were not added,
which is what I would expect, i.e. the upstream one was only about
`as_underscore` (but I checked because it sounded as if somehow the
original patch had more added).

So it looks fine, thanks!

Cheers,
Miguel
