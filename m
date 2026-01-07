Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FC123EAB4
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 20:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767816361; cv=none; b=EJ+22FbPAXasNa3VuDJYCcxcOKsDddM9VXDuemUH1xuBNpnzJgwp9Qb8Qimy7PQqC+IAB0fFzLeJm/DkJlUVqQi48TIb5yklo0wP6fwO9+xF+VzmgTFrs6JtDmMO4fcGGPePQfUazQmyVgwsk+7qLwi4G2OTaUtxoVHGi9XJPQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767816361; c=relaxed/simple;
	bh=t9A9hORhtN3HCYm96L1VHkZAq5Vd1DywfLUoz+Q5yWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WKZ5MyJOD9IVrTuDhODlQbY6/RuKe0CgwSwZGV5qzf2e9OvW3NEXYkXnhjh94gx/MmvI6U9Eqpdwq5iGZyh/WLzXw92Z9gsNJbDtIMym+ewyq7V3meUSp7fwhE2/9/5BsJAdPTWRW6BjvLqkiGYKfytoAs6+kp0vYR4XGGNcRUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=bVbYRA/l; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="bVbYRA/l"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-88a32bf0248so19156826d6.0
        for <patches@lists.linux.dev>; Wed, 07 Jan 2026 12:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1767816352; x=1768421152; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HdItqAtOdKbHygORltxGl3KfHwHC+ySfh2k0akOHf6s=;
        b=bVbYRA/lqL5Z1K1edZ2p7pTgw9wVuT59HYqU3lV2juqtH67fTWyhiWdyjDR3yizbBG
         2M+PSQvgxvTgbynT7OQjIPlRewqP17zY1DUsQZgVgwGLSN+hVHHgfGN+fp8Gz2TWyBzA
         BM3Uh1TFTnO9iHXrVsW5ObcK80cB0KeguicJ8ZLfG1WHLRAQ6+wvSwbNfYmbQtvW39HD
         aLRVJUDHJX+t2ZCvYcEiR+NQQqKIuA1ebvOo6geMF8p2Ek0jm0iAywDpAfN6gi6lZRK4
         qNM06F1dzteuzUXbA0DCKQzyV7dGL/4puzfnQfCA4w6FMrf2rw1MOllIxXQHVw9EBlLO
         2ezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767816352; x=1768421152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HdItqAtOdKbHygORltxGl3KfHwHC+ySfh2k0akOHf6s=;
        b=SKQJkBieDnejl4IZTq9duyED5Qe3xFhdY/Cj7ER5/4KpcKUB1C5MCp7HaNIhSjhZAW
         hVi1W1ut3xKY6xriJqISF5waYizQFDQbl9VP0+k6m7ny5C/UhcCC6JdHgmbVo5gnGf1N
         B2xYga69JTyEqFrl+l4ZbyiYX0PAAKwNyMMny/grurjQLUmeBCEOp0TK6te+x0v4MEDu
         Itf9KxoKezgQQQBX9k1dShPPLbIcsyj7idX84ZAynLmuJLropS9ruuBv+X5rEQC8Z/vN
         5TozsO6REM1PhlpZSsD3gYu9dF/Kqjk28RNMufzV2oA/2V0TYY3Kw153oXWnEYJA6b5D
         At3w==
X-Forwarded-Encrypted: i=1; AJvYcCWiMnVvpEIrZmZYavlhqv6YLCR5YnZ5KlmPlClfhnmKsmOh+P0Y5cIcdlbZBPjQBbGalKg0OPjC@lists.linux.dev
X-Gm-Message-State: AOJu0YzXQfj1NYHGJW6tGWZp5Gj8HqgQAqJBoKqmG1oP8loeeTpTW1WW
	Nqx92eEoZxS7F85dBtqEQ77yWSs0BfJoz31Fqj688u9+Q8Cpb7iDfhNgpoRME28mLCeYxMTN8lD
	7xuMSV3OnzzFV1fpOM58Ita0sefH9SbuzCp15yp06lA==
X-Gm-Gg: AY/fxX4IcJCncowuX2EUcqk/oknZY15u3qeV6dvkqnAPfDnVli5IylzP/3Fj+4HaVez
	lb3x2Bihry7mI6+jvqtWqsaYczL2qp4QfI137U7IjXlmVldwrQeL2fx7jXDlI9YJDXASftY0opd
	ijwKcvo5Z+tUyo6yxQnwqb0w5O5R6CLUXggCnuoCpP9I+R49AmafvM4MViZvIvZE9BXncFa15W/
	zq7uoSGn750oe0WkH2ZXbv3sORlSKD9Nlj6ijS0x0Hb9DuvSWWf62QK1RwvuChXIXAe0VV6
X-Google-Smtp-Source: AGHT+IEuk9tPmnvmyGvFyLAmgkHtv2aAK6/xA2+VUYm8MzCaKkoYfBuP8RFfZgyxIH2P6GWVu5oquafUmUEO3WWQfDY=
X-Received: by 2002:a05:6214:460a:b0:890:744b:9fbd with SMTP id
 6a1803df08f44-89084183a52mr49510436d6.10.1767816352044; Wed, 07 Jan 2026
 12:05:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260106170451.332875001@linuxfoundation.org>
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 7 Jan 2026 15:05:40 -0500
X-Gm-Features: AQt7F2ov7z1jVxyxz3XzKNh8kYSCNbZ45HWfSmYQ65xpT-Ot1X7tkmswrIwS-g4
Message-ID: <CAOBMUvjTnbz0t4sKBzSq1HWUGEPQpq1RQahY4cxVT=Vc6uymiA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
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

On Tue, Jan 6, 2026 at 1:24=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.64 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Jan 2026 17:03:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.64-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
Builds successfully.  Boots and works on qemu and Intel Core i7-10810U

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
