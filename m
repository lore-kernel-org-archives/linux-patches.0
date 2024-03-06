Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB06B13BAF3
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 19:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709752144; cv=none; b=raoj7mE0H51Vt62RKws1KkWSYw/BFVhr2rmJqvUm8EZqJ+44ZNydRkKSafZ9qS/c6RVmUPNqoHiSnP4crIt9gvEGDNzSm7/bZWKHsmGQD7DKY8/BACrOUpoQuqSaJ05Q1OjzupNcnVDsO5FeFz30Inwg2WB41fOmsGGlfg92Q94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709752144; c=relaxed/simple;
	bh=Jx5YcUSMGpbao0LQhgAqxzAS5Kk25Nmxc+dmsrTnlWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eogKa7Cj0SPNV19CUbJWu9FPbihmhfN1WZGzYHijGoqUFvxbASWbTMZGY3vBIy5NthgqV+AUm/wHy8ZlMOJQrQX6vpsLY923WOTTxNQ5C/wV0E/2zEYI+dFiLUch2m/UP7oj8R4vs0qzEHY4RCCLR46DEdzYZ+PSwpkNLcGNFZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GiCCr/Up; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GiCCr/Up"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-4d35b9a4b13so64208e0c.0
        for <patches@lists.linux.dev>; Wed, 06 Mar 2024 11:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709752142; x=1710356942; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1MBwhmXT0GNigfPvd8pOX8ehNc0dJQsD/F/tCLyw9ak=;
        b=GiCCr/UpbmpqZhcMPgcIsaSFZ82cWoND9WB1i3n/9WjkmLP94dsRqt/yUyiNAQqjPV
         9EwWGYt8hqvBbelI9ODvNfxFZWYwh2fTvTC1W3eko3chDmtDczGiZXwJVSMxhY8xP9j0
         bjXQYodSXYsYi9XktAtTtSENH18ke6kHP0uQUgCCoGxI+eMAdN0klgVQFewKIjDio0W6
         IQTgyFAr76/3WnR5pKCPXTLo+ehHDB1qoB+vWYwGp5QvbEdx2Sav+KpY/zMUDwLUPw5j
         pWJpJAWzYmE1vgXg6fVmIh48WyzsrdxLBJNJrRQaFvRtxKadUGT1OYqrFq5rJ/SUChVA
         LQIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709752142; x=1710356942;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1MBwhmXT0GNigfPvd8pOX8ehNc0dJQsD/F/tCLyw9ak=;
        b=TA58VGCW+3FRYWsAWuPbUMuXwBdyLOICMfKeTn1jLAGV3j+epyGgBirfDhhAmnA57q
         SlT1PcIoMtngYHGNkrkRw6xSO/V1KHZiFORrQXbstBNTtG6fELRFKlazQOOutGSWPr1S
         kTEswXBaaTX0/howb08E+ypvrOQWRb03f8wXJsocExsrX8a3k+yG3ApfrrXmZ4hCXznM
         ry8DDqRJKj9M8Rjw4URT3nZglDGFpE6qExCzf7CmRaCNjuE6tKmcpIQQHpvlORTza3ms
         mFv1a87uHH2kFgTyaAs+NUKjXt4zvbQJgIYIAgar/v4aL7PeOQM6FMqEQ3Kgy755P8iv
         4jGA==
X-Forwarded-Encrypted: i=1; AJvYcCWKMIdkf/lYbB/cK0nvlcXNfxXsqU0xriDiBNz7UE7+SAQMO1xCteMPaq6MutB2Cljf6RSAII093YiaJ7omj9EZmGEqJHflaQ==
X-Gm-Message-State: AOJu0YypKXGC7qAfCiVwy5UFwto2I5YAqriU1BnxtMiaU5eruFYZA5tZ
	zlG4GOk7ZGLakfBTbR+fuSxnbdBAi6XSKc5PtYr4B6IKZHlo56W4KQQCGFsgnKvEweMyED2jzQJ
	glyxeMX1KifZSFyFWMv62LjN3Ir0=
X-Google-Smtp-Source: AGHT+IHSD205Bw7kFQ5g85sYG4JAaOTjsZkfbzYFFVfjsRAerokh0J5v5leMfz71NT6uScbQetKY4yvDLPcftceTHrs=
X-Received: by 2002:a1f:ee44:0:b0:4ce:96b7:c2f6 with SMTP id
 m65-20020a1fee44000000b004ce96b7c2f6mr4447688vkh.5.1709752141889; Wed, 06 Mar
 2024 11:09:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211549.876981797@linuxfoundation.org>
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 6 Mar 2024 11:08:50 -0800
Message-ID: <CAOMdWS+9O6OV99UHDHALvxconF066qh2KVrAdvnK0AvhHgLUeg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/143] 6.6.21-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.21 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.21-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
