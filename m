Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8BE1C7011
	for <patches@lists.linux.dev>; Sat, 15 Feb 2025 17:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739640290; cv=none; b=u8kE/CjMITlRTyQKwD1YmqBwvIuY1mURIiwr3miHYvnyAhPIeP6CFG6vzKyZBq7CZkzKzqY8wUkM38Z11RDy+LtSOdEb0MgoS0zNiMVJGdVH1OhHvGAqc9x53Nz7aPJOU7dMdXOmlkJdOZLMZLmdfCoCrDt9jAQrCZQlx0dxnzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739640290; c=relaxed/simple;
	bh=teKQ4hdjN7BYX7EoxvrsCHltx1se2slKk6pRdKtxyvc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IvIyOoBaj3pZbP6DyVjXFAfd4oqS8C8QhoTdmcLigL5gRuIcFARFlRLsZ8yNYb7GZpYtoSs4to8L4EAa7rUualHooeWxFlb5TWguaMWUMZUjifTAfhvBv9N2VJpev92uOcal3NmBJtGK4gPIFmYcJKUuZLmogQxY6Vh8H3Lq018=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b=UqIGs9rV; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b="UqIGs9rV"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aaec61d0f65so655208166b.1
        for <patches@lists.linux.dev>; Sat, 15 Feb 2025 09:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=google; t=1739640287; x=1740245087; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IEbvPfbzlqpfyi/ZuM8Sn6es2AIq+nlH6qd/TbLpx0Q=;
        b=UqIGs9rVbYij+6K7X2Z+WRT6kvw1Sl0TQ0oqli1WjYRhK7Ka++7qi7CS9el7NGlDs/
         /XqKcCIsjpTELVDSy8IYg8nva+Kar5U/D5tRpj5vu70y+s1JEblieS6qyZuNdQSSC+La
         V6PbtRojKbska99eJArA9vXo7ON/a9jim1vK4OORNGOKvB6usDOiQms0bEXoJuNdPwNn
         ZPOwKod03g5cOCBjKra8mypaSrYSHjxhIasRnEWt0spEsJ2Jm3BJAM5KvnljebHQwyXm
         U/6+X+0v/zHz98UAd1/aHPD/E/AV6Vpx2ypvIJCoG6FHPjOMEXKCZlwb7ebKTaACrQmH
         e00w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739640287; x=1740245087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IEbvPfbzlqpfyi/ZuM8Sn6es2AIq+nlH6qd/TbLpx0Q=;
        b=h92hHjo0K3CWCL039TXl6NfZ3vH8XkH63ySAPHvR8oFHG5OQCrWx+WiXo9rBuynbi3
         yKfuSmuZ8u56EKDl1YFXa9dmo9V/uFTkUm1T7Z9S7SoQ5K6gVVqkEMbCIyYJA1jElkT6
         3HbBW2w8J0pslz9N5bKJ/76nqkLVE1ukPiK6XVnbhX+iXKJhCKSa5r5KCoJjL+7ardQC
         VEt8XFA7H286elzc3kcYm1FKcPqyXdDtbVCsi03RKe7lGQNCwwxA2HvITZjrx7qZWp1F
         jDYp60sHrXt+lcgBJ9VDaYKMeTTagpebhy8nA/Q6+jMhIwG3eufEMvyV+QRrgqm4EG+v
         Zs9g==
X-Forwarded-Encrypted: i=1; AJvYcCWkDg/oYLG3jBxmCw+E8QHCzA6U6GDWcEhZKfspqQ5IQPA+Eblw2fjTzhZwDTZrIX2cJmcPAHDX@lists.linux.dev
X-Gm-Message-State: AOJu0YzybhT8iHUNYvDo41gzLnwFNRTLaTRVAP7/KIzhfBVPKXlfVk0+
	iFjun5TX752uMd2opkzegw1xylpf1N/NUOahlcQA5l4GcaDKmDpWEdbih+d7XDPgSvt3m9lQl2Y
	EbZDuLBesWcErwN+wwhHkxnytbmMrfKtTWoevoQ==
X-Gm-Gg: ASbGncvmBb+OGlnfFSxgIngxdcJNO0ba86sjueMBbc/ls5ZZnfSx+T1bTGNtMwD2X8S
	GScLZItErS2+8DCLyeyKq9pDYeBR2AMEc1N4nefx3jIGZFfyHNaPfTlALlJZLfNjAo+5Argqd
X-Google-Smtp-Source: AGHT+IHpM1eqc8tlYMhaHVIvfcF2/sov/Rb7t32A/3fz4T8tN5Lqj5CbXTDRT00b6qYe7eMIRGaa1Dgm4UxTcOcxbsM=
X-Received: by 2002:a17:906:c153:b0:ab7:c3d4:2551 with SMTP id
 a640c23a62f3a-abb70dde461mr387599866b.33.1739640286846; Sat, 15 Feb 2025
 09:24:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250215075701.840225877@linuxfoundation.org>
In-Reply-To: <20250215075701.840225877@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Sat, 15 Feb 2025 12:24:35 -0500
X-Gm-Features: AWEUYZlLRXmnBt-692KO7vYcJFwLxQMOVLPLKrHkNbf4YYJGv_M_v-aJo302zFo
Message-ID: <CA+pv=HP-_uNh=Tdx4L30uN2TUO8K2pN2adYoXs_1HH=ScG0t2A@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/418] 6.12.14-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 15, 2025 at 2:59=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 418 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 17 Feb 2025 07:52:41 +0000.
> Anything received after that time might be too late.

Hi Greg,
No regressions or any sort of issues to speak of. Builds fine on my
x86_64 test machine.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
Slade
