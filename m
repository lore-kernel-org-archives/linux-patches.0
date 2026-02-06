Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE06F2857C7
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770396785; cv=pass; b=YTMQLzfiKPG/tvJ+P4Lp3DEEbSwGxNmabxOj/bD5Xv+QPmKqgk2RdT4IJYdyNFFf+AnWSxeRLJb+WKn2vo8NsKosEtZyL4e3kq03R4mOiHSDm1n1Hp/+p3VliHXcV5dkDhfQzS5jKmzErbO8BR/MxEjEhHzQPcbdihe5LkBX150=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770396785; c=relaxed/simple;
	bh=zYWW6u+UkPXLyU3uuryhZGjbfPnDbJJ4Icg4NsSbQvE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ib5mXMnUZHB48wKFqzZe5w4cs+89yc0qk2gnRy+DBi28T+h/EQZsv6+V5gEeBTldNlz3rE8z6KGRQocC7AW1nt4vnB0JBC2qTYErm6bf81Q6lUl2T+QRu+LcacNzQHX2XywI9a22ZdmZ6LqQRmGkDMJtBok/gVAEICcqWWnN/0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=kaYBVIQs; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="kaYBVIQs"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6581234d208so1478072a12.3
        for <patches@lists.linux.dev>; Fri, 06 Feb 2026 08:53:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770396783; cv=none;
        d=google.com; s=arc-20240605;
        b=Pt31zF326WM/7ZWPSJtJoHYEQE3Z+giNQz/xLufCRTkOgtAyK2yRHRm3M6KjXlRZac
         ldffMqL0q+TBO+cPIcA+nOa6V/06Ce3b9Za7AG5Co2UFDmP1BtnyaO7JVAuKjvnkB6sv
         jeIY35MsJ4g5KGEMJINpESbfVhzMNz7XiYdUivia5ycttDmeBQlv6G2tE6z9tZanJX1W
         pdv57pym2sN40kJBI3v8+6bJb3tRozzrojY3IBWyjzsTGreZDV1UybzRrSsTwjZZBfSK
         FtN/tG0loaoN6P9HcyjtwB+igctELxCR7ZvTGT7FutCUWWWpudHsddgLi9+Kbhp7zfU9
         Mlrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bgFS0unxSCmVNV3e9euzRJlesOrpe6OnfIqHW27FT0Y=;
        fh=v4DHB2V84ob6II1mrxgxRHT74ZLfPsjKKM4eekErtIk=;
        b=AOap/8dlyqT3xgOoXIyHieCojYIvbWwYtfiJwLwbX0YYpTnZ2/rpD6bcU7RKr4W2xD
         Ypcg7iGgGFX8laO+JK3o/wV748vAdQQ/RwIoqDDTL3GR0SGMF7NDC41gXrsK+Cpy6pLr
         dsTVoeMTfjx00n1G+AJljv0l9ZqK5yCzZ4H3M/G+Tg+FIX3Q1Vp+s7E1K6KLq5py+8Qj
         oeQHke5YHQFf08yN1Pa8M6nVCn+oTBec3PAbUqKSWNJ7/CyCTDEsHIloHCz1KZdwg6gD
         R0Gty368JheXHNRWjcKatKdarszglG114Vz0hWbyaTvatzw5gkC4wFm2gEUO4AMmls0s
         gdmA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1770396783; x=1771001583; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bgFS0unxSCmVNV3e9euzRJlesOrpe6OnfIqHW27FT0Y=;
        b=kaYBVIQsBIup92m5rtw27ohc92yPECCdKmgzG984D5Lx4kcYWYW4WMle08L9S6yRFw
         ihW7CPVqltAH/N5OkujisPDOzVhCz4Ma4c+m17/Vv26uz2AVIohk82ub3oiQN/UFqgTW
         yvBDGhDJG7/+ObIX89i/eBb1w139PDBs6qS53+ErfRchmXQFYiGLwzPBKBar+D24eDE/
         ATS8vViVv2oB/Gl22PKW7nwHszH/+jM2Yd6pMLqIzHD46HAxSTitz9DTgzgucSFeLUWE
         mdkCQ9UpGDKxsyzcQyDakppaKPRYty6cb+Sgi6JdaE/aifKk5b+T68uYWIQjcQwSZ59T
         WV6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770396783; x=1771001583;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgFS0unxSCmVNV3e9euzRJlesOrpe6OnfIqHW27FT0Y=;
        b=uT5yuPbqA5azROGlNY0Qor+4CKaafyQtbiZmU4kHL6tLdqfJmayuDlv8dkFzMIIkzG
         UyzH3sPafop8q8mpoLybEcgtpiKgBwPuE4cghKHwsWt0/NJXmX+EZoZHmpo98+cxOTsG
         2yRxO/6Gpnn4w2FiZRZ7NAqBpSSsmZDM8tAGhSCFl2SuICd3jeYmij5+X3i21WSEbB2r
         WapvQWlikY7Z9JUJ3U/GDNitcRMF/EIF1qcKb1eQuMoSI2SdqDXJnr3o8lWyZJu5cQQK
         oWzXR8qzAR6e30z83SxzOHsJTudmy9EDAgEp6rGOsdjtrKCGBJN9xj5F/L+sWYc+Jjb7
         WXLA==
X-Forwarded-Encrypted: i=1; AJvYcCW84jNXzDCaQKH39pp1kOwx2nze8Y2MW1gZwSoFLWoN85xqFb/JHFiLW6wkREgimpSxEJPGQ0gW@lists.linux.dev
X-Gm-Message-State: AOJu0Ywq3AvuEbt4Ro/Sr5Ga7KYkESZ5Yes7AhACiGid227BwEn9rHE5
	ircONqLQDytIwawa/lh3icKz3cuMXPz322vdXfPblSxe6KTdvEXEKEAitXFqjAn5cyAfrPE0/kO
	23i9oxO74Cmoq7oYRKU3Sa0xnkyNM96DOKZkUdgRg3g==
X-Gm-Gg: AZuq6aKFagr0XGO2N4p0tc7MIukefNljBMqAiqVS+SDFjpQeh0FElennDxniFl0jiSd
	h9SJLi4IMHvpMfLzHyjFIdS46Ufd3mmWNrNbTboNNsZmrsSqEkUn931Z+b8Y6obH6gfUUcH3hNr
	JwcT9rnVUJzgzOer6bujWaAWpJnodIXERurPGbdCOoEsIe209zYuITUMiUumcs5cBC9by5smZ90
	16j3NCW/rU9u2xx4IOC0q5MXxDw6eyxebQ8GEhyneP3b5YvSMQfUuuys40MsGI5qMT7Li+f
X-Received: by 2002:a17:907:3f03:b0:b87:6c1e:9ffb with SMTP id
 a640c23a62f3a-b8edf3410d9mr207702166b.48.1770396782893; Fri, 06 Feb 2026
 08:53:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260205143430.733102763@linuxfoundation.org> <CAG=yYwnDVbTB3Y+zX8yLATGRKeZzSXNu-eiU-ABReZhJ0vep3A@mail.gmail.com>
 <2026020619-eccentric-retaining-86ef@gregkh> <CAG=yYwkOvV_=hhzSkQ06UqUW2X_FOm6saGqBaz4hLxqAg_WcvQ@mail.gmail.com>
 <2026020646-lash-celestial-2c7a@gregkh>
In-Reply-To: <2026020646-lash-celestial-2c7a@gregkh>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Fri, 6 Feb 2026 22:22:25 +0530
X-Gm-Features: AZwV_QjA2n_29AcwIK8XJ6XD2j0Vy-wlYaEYqKlwDlV2CIcfqLRaaDTXE80AOBU
Message-ID: <CAG=yYwkLUJJPVTyAeg=gu0jHYhoeXWcdGW5m2sbr9APsKChzng@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/160] 5.10.249-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	lkml <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, 
	Shuah Khan <shuah@kernel.org>, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	Slade Watkins <sr@sladewatkins.com>
Content-Type: text/plain; charset="UTF-8"

> I tried your config, with gcc:
> $ gcc --version
> gcc (GCC) 15.2.1 20260103
>
> And it built just fine.
>
> I did have to do a 'make clean' first.  Did you try that out?
>
may be i did not try that out with this kernel. let me do that

> Have you ever built this kernel successfully?  If so, can you use 'git
> bisect' to track down the offending commit for you?
>
i have "built"  5.10.248-rc1+  successfully.
 let me try to built this kernel with "make clean" before doing git
bisect related

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
