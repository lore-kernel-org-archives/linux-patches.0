Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C671946DA
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 19:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739562861; cv=none; b=s2uuTORrmzfvw6VyU9wStj6fg/3HEeDYAr0ApX/wP4ve4yZsuiiC7rRpoZ8mNVHaXwPvkhgXP71CLe+JMTiQo2lggyMx4zBBWlZ5J+RtiV2DVudLHo5Avra7nbgc7K/2jVStZj8wGtbsY8WZH06oicowI9wl2lKWRCZRjwqv41g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739562861; c=relaxed/simple;
	bh=F9JPbRGgy2KRFJMR0L9LpCN/bMbxo32cp8WwnNHfDxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n04u3UlrVhbgrvVexHP8FRtGOkbiK0EXmTt9R/anqmLOdYEn/A24FaBwTW41kCc2m6fTVtZVv2lR/qGpFUS3NfVQKh+KwFRlrUl8JqRlV7lC1zWaPqVo5dk1vsHvI2lxAiKBY6BY1jQHsGCfvZKXI9gMxDN6j5RwqFhO8wMfm6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b=eBoAuZZa; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b="eBoAuZZa"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ab7f42ee3ecso482821466b.0
        for <patches@lists.linux.dev>; Fri, 14 Feb 2025 11:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=google; t=1739562858; x=1740167658; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NIYB11+GgLlT+s3GNd9t99ckB9tkO/E+VJIoU1xvL3g=;
        b=eBoAuZZaJCDNjGAyhBvC76kVvE4+0Uy7ogkNyAwP9R0/S1LbbweIEdTALCOd7V/hcu
         fctrbkD0HDfg5/gwMH53XXPzQZYS+Wn73+vTQSsRnhulkMaqkMyOIQhr6c7El6QkPJbf
         c7lxZ/bggHmeBZ2i+JwRdEGBnDAQSgiW01GSEWxAB4P1R57mOZM936/vf00KlU6aQq6J
         sH+etlNY+2BY6eabdMKC0MVm8BWTG1ZPzKCjf2HPVZ0BL8t+oqXAgMfktM/Abcj7QL/c
         RjIPsH70Qci2TEOdgoGdp/3MDjJ96Qs28u/Jr4MWp+m+Rw9o51VNdQ+ou0FqAV0cnXT9
         VeYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739562858; x=1740167658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NIYB11+GgLlT+s3GNd9t99ckB9tkO/E+VJIoU1xvL3g=;
        b=oTcY28+nfw6MgO1Tafxu3Mq8EGTnBFbo2WMrLeINIky+7pUX99VeQ5POESYAK6qTkC
         0d+3cOMImpef9VB/AWVo0Fu7u2A9yrfiR/8KOBIZy9C8E39opDxxzu+84qoUlZ7BAoF0
         ZkFKd9M4Y/ai02ts5+qMoCPO8kVM+miM/I5iUDakb4w2fbIdyz8ZMhdpb0EpoBbtbmK3
         /J+BGmuThKn+TpcpGwSraWYXpMl3FNAIwrSa+LBjm238a3Pj5iYRkm/Z5nGgHihWXrgx
         XV0Q7idjhQO+fxh3Ui56qXC+5etIze0R8S+QgJVhNw7ygViZXvt48h3RAtrckTS61RAg
         Z8sw==
X-Forwarded-Encrypted: i=1; AJvYcCVNrnFIDg6RKz1pmdLKxSz9s9Lxu4u0q/R9wISDEPrfX3vYrRItrHO1g7hXykZlzyHXF3ZT0C6n@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0DCiuUlCfwiW16A/J+nH7YbXrHN/sYeYhTt3XiZyuD8LYcQGS
	BKqoMtuXenY2lCOlfNS7QiVOIvGYoJ6qOK4eNIo+fT9ZLDG45/B5jZyZGoi67g432lEDGqPsLw+
	xUSthpw+orBpePE5SKG21PLUi73BC8ZMpIA6Fu1oQZs2nErJotNpDgw==
X-Gm-Gg: ASbGncsTAIv+Kz9YpJaV2w6q3ZhHdxUsFOXz04YWiPaXTvxyNGGfABDn/YHq0+ws2HT
	ZD/xR0DhDT54xRCNvn5ixLFN1Mj2WrgRCq+XQSMS5grQso03yuWbjbbYkIwQ1wO74x/rS/sY=
X-Google-Smtp-Source: AGHT+IGQyheLGif/JTgffbl1Tim8k/BNZyiHL4jFBQkQNGvERc0kVB0mvtU+IAjUoObD3Z+Y+98YsIXAOuyjFKM8m44=
X-Received: by 2002:a17:907:c1f:b0:ab7:d87:50f2 with SMTP id
 a640c23a62f3a-abb70d9f296mr32132166b.44.1739562858174; Fri, 14 Feb 2025
 11:54:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250214133842.964440150@linuxfoundation.org>
In-Reply-To: <20250214133842.964440150@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Fri, 14 Feb 2025 14:54:07 -0500
X-Gm-Features: AWEUYZlX87hyFmnKvOA0Y1WpH0vZar3xq21qN9aghuiiKzi-M2gyZl0dPxatvaw
Message-ID: <CA+pv=HO4D0-d+ir1Vb9xjUcsYd1Lz8j9OAzev+CWWak6dD56+A@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2025 at 8:58=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 443 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 16 Feb 2025 13:37:13 +0000.
> Anything received after that time might be too late.

Hi Greg,
No regressions or any sort of issues to speak of. Builds fine on my
x86_64 test machine.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
Slade
