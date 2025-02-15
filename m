Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC471E5B7C
	for <patches@lists.linux.dev>; Sat, 15 Feb 2025 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739640353; cv=none; b=ab6ZP9LHOW5YEc88day55WVAEfkNOnnZgEACnKggt14LfujZIP54qEzOiUraDlZ9M5b/jMCEkKR4IMhlSTBSe0yHdMEA915+DhMofbl5CXJiGiUT1UJUjhNXQo7XrSI7U8y/n0nPH3n/g8SKzJbkv/jScYy6TLLA1ErsZ1PlCCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739640353; c=relaxed/simple;
	bh=bWdwc4tU+jS/WtyYL5ZUs1E6ELOzM9Zd3g3hT2CGL20=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OMlhnTsIZGiTBuq/wuuaB7UTAKiHUqI3Ihhvg7UJ1tEZ14g3GF5AOU/qejMvAf5TwqXUD7DS2VZUJiMDz+Dv7rATCKZSGzNBmugSCC27BtCAm9lBrumdMIuN1hctrHKuQRfG0FE8ppe5JaztEuR3Mz/BvcE5MLLALTpkbRdQihk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b=fmquOgCI; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b="fmquOgCI"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ab7c07e8b9bso529938566b.1
        for <patches@lists.linux.dev>; Sat, 15 Feb 2025 09:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=google; t=1739640350; x=1740245150; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JHP8LGPaE55AxKwpSHf5L42NI3V/KQU7zbKAocoI1Fw=;
        b=fmquOgCIUAd+XuBHEm+dyQEB4FHK1EkbwbyFB9R+2YDmWaRhAqob44SUR7G5OVQJHW
         xmbANFSCkKt8P+zwt5VG9ZuHobQvN0oVeTbrIWUQI7237cv2hESiqk6L/2Q0rEIJ3Kjn
         gZzaqHIP3KjRGZ3R6GdRY2uay+TQ6CYX+i9EYa0xTS/ZU0vssccUZlaw0xQTHctgfva+
         IiF2t/rn3XaJZ8Zs0kf4peic6YxOnEQp54odiq/8XJhspcBR5h4p1zZ9/1zwzUFHi+C1
         DM9Ie08N3APurZIkYZyXOb3CzpMEB/U05YbGhtgw0UpuhUV1edkb+YfQxsvXS4C4GpBf
         HifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739640350; x=1740245150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JHP8LGPaE55AxKwpSHf5L42NI3V/KQU7zbKAocoI1Fw=;
        b=grzlmVLo+30QfzsDtH3clfF433HxIWlUHxyXF0tm3vrKN5CmPyNd5k4RcDvP7maKDX
         PreosL9l3F+EMr33xRjm4MzpBIAq1/tE2Dj9eQElCIP/n83y2m1zR3RlnezAcQG3PwJ5
         0uRR4vtQfGlY9hWdlYtIELeOujpC+GT0LIjp0swMM4YYw0NVwVXi6fFe2FvjHVZFNDdr
         o5gk3fD98AqUC5ljVs1xQB9+jc6RTLc77b8ZMFxrcufkcBzzxKH5Upfswz/AcQ1AxgoK
         chcA8GMyyfN/oIxFLZHZdpQIPu1aW7NHNQC9+gZu25J5///g6ERwCWTkB78Liw3R7bnl
         FQ2A==
X-Forwarded-Encrypted: i=1; AJvYcCVp7eexNAQyibg6fXrgX6n3p79Yjnbg/l0hPruyegypiavhGydlq6X7KKqfVEVYMuHRISq/V9JQ@lists.linux.dev
X-Gm-Message-State: AOJu0YxJQGm307CsFe31Gq+24GQCcchADsLnd8G3Ydv5p+prbF4AbLLw
	Pb/reS/aIxo2TUGkO4zlnoT1vNkVw8lrqYvKSBwFMNW0MJnGUunb7gIhW80yVD2SahqcaUK4vtY
	L9VwNGjHKwCs4oEDutTbu/DpREz5af2qt0R4D/w==
X-Gm-Gg: ASbGncuk3EzNCYaTwNurKIPW7O+DvrVcVCriaPIuxGZUTYHU53loESWDhFPsu1U5h64
	anmOu7f6COIBQFOY9n+mZJ617e0O3T5Xpzn1Zk868nYScoHPV7ob/zWrI02TnSBcFc+lgHwYv
X-Google-Smtp-Source: AGHT+IHJzLjc0Mpd+v0lswpn7DhJ2tM9BZti1csqHDT4yfjUQZtHYKVsAb7uI+EuHhv1xXJViJSu9WBUuDD1SVw30Wc=
X-Received: by 2002:a17:907:1c21:b0:ab6:fd1d:ef6b with SMTP id
 a640c23a62f3a-abb70bad34amr363614966b.27.1739640349746; Sat, 15 Feb 2025
 09:25:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250215075925.888236411@linuxfoundation.org>
In-Reply-To: <20250215075925.888236411@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Sat, 15 Feb 2025 12:25:38 -0500
X-Gm-Features: AWEUYZkvqJ1y-XsnBU_Lwvy2M4G3bDMXGE9SW7Ow2NVPM6dh7UJTVqGNeXXm7gM
Message-ID: <CA+pv=HOEzqtotB8hp4ikj_q7NWFB334CgPUT5BwYi2Re877dpA@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/442] 6.13.3-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 15, 2025 at 3:00=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 442 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 17 Feb 2025 07:57:54 +0000.
> Anything received after that time might be too late.

Hi Greg,
No regressions or any sort of issues to speak of. Builds fine on my
x86_64 test machine.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
Slade
