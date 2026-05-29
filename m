Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C97E3C7DE1
	for <patches@lists.linux.dev>; Fri, 29 May 2026 10:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780049858; cv=pass; b=jkVGTqAli1HQu8xGXb3Zqgto0xmt0sK3q1Ahwa6Yb5Y+3qWgbuE0HOnesTw/WEV4yQecPrUBs0e4+nj6yCumZIhkZlLBZaYTC05R0N3UXpwuskQBesWFJiTKucUb8YjP4EOHAmEW9Ls5EbuTNGIMoyDB0t3qxdUhSSDisEfucKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780049858; c=relaxed/simple;
	bh=DdoSdrQ+89tESFM1bFydDaaZ68yxYAOFRLyfghWWbMs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=acgHC2VItbPzhnMaV0iTan2DvHkp5SzLx1bcf59Q0A9hJUtjKS90ynNGyWc7U4sBF37mHzHqHOf0w0604q2DBHWlGi+5ldxPpu7vyBqnaCtYiA7gdlfO9xAyPcYKy7a2AKqGAlXb4n8pfvyD2SVWksOzSZUZxJIY2Q/0nIgyWv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b=CXJwxyj3; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b="CXJwxyj3"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-68af2ac47afso2277550a12.0
        for <patches@lists.linux.dev>; Fri, 29 May 2026 03:17:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780049853; cv=none;
        d=google.com; s=arc-20240605;
        b=DTkolRSNEh/d4cbM9l0L53+nLUmisG4WWxzoIBcEA/QMzr1fKd4VVonLlszz9VMR+Y
         mxaqQfcpJeqgpXad+SgpuyCPNX9O1b0DTKtAeqgSVnHWWWeyPXwUoEZUJVIULvJyr+OB
         cJKdYElj5kPjBSjzK/av0q4Lvzg9Abp3h6m8f8p24GYj1y5+7CMS35mKh9RFllSUCPBn
         JBehTAn0zOvfHNh6LwPDnSfH052z167c9OKsOq7yxnv19YoKqDyfDrGkdmbFE4UCrZO3
         LGVXrmE2oo/nK7lljKRE7O0FGj5nlX92NGYvaQkJ553N6LuRKHCMZ+yhCQBpvkTVuhXv
         xNLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RTuQXj3d4ekOvv+GEi8JE6sp9274elScrD+Oea8c6fw=;
        fh=UVhsg1l6oep5XNLILQ3KfC/+uxubNP/njaADZxzMp2Q=;
        b=Csqs0iA5NQha/L6rihH/etwVh0FJhEwoZw1bJGjQFmGQiqHPaQbjZmolXSKPCKWRvQ
         +q0IKadoMtWlgIokpR0iZ4RkARd5hzVEJ2KBoSOJDDaiVffj6mwp9yBw05Lc9RzqUlv8
         2UjBglSzGrnb6vDN4/BT/AppxyXslwCghFljlbb2E86fd/lRW9+2FyG8IQ5jR2VWZR0J
         VtPlPGmBMlnIu6n7L/lDGxG+nH+QdJ1QvM+O5/6SK6wupafCsJEx8YSmYKZy0RMbAJWe
         sDr9Gia36ZtrOEfrvmEexPHYoszJj8nzARqRmJ66yoKhDk/llF/5ic5hQbNFUlF5a7YB
         6sPQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20251104.gappssmtp.com; s=20251104; t=1780049853; x=1780654653; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RTuQXj3d4ekOvv+GEi8JE6sp9274elScrD+Oea8c6fw=;
        b=CXJwxyj3AkGq6DiT6KbIeb+My+K2bn4bUm5T0Giygyoksc5Ply58J7ELyfgv5R4GOl
         gClbBFfENOmPjhjB6h5/cOsFMSWnhurGtMoxd7Y2NkW/fafLW3OY4bFHr5s2eCgUSngr
         uUzmCQGYUQJVaZJSJqkFGloSUbrhIrFPlIefG/ZtXFCEpNlSZsOwmG6VTAZPPoOOmsae
         UIHBeNXk3Q4JhdVA6ElcmseYZ+2k7sCHiNOoKsDKOSxVBKYP4S12RE3uZh0+B7FXQd5/
         MSXyjsmLXEXE7Fwmk4BJsbuYgD/7zdTSpyHl0m9/VuqvgLgcbm/XLGh0xOrGu2tmVnW2
         O1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780049853; x=1780654653;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTuQXj3d4ekOvv+GEi8JE6sp9274elScrD+Oea8c6fw=;
        b=qJAxdpa4d7z8ZMOuaNcRS5gHs0JZi38XGdfUu86usaSlL/7WIZbG9fgDZ4a4QWynL8
         VxO+h8rLvsx51CYvqaOyEvyfpWvrXs5eqlg9Wc+ZT2/wf/9vddLJlyeTCMeNtw8Jh3dQ
         9i9GoveEUSTmpGXgO5/bAaQaLrh2Bpwfeh3WTBl/rBbNZWl7mIUlXN65Z9jQuvaWFw80
         q9El3zgQ3H5F6IAeP9BKpC2KbmqPKmdmRNPasXNyJ/WXtIX9wNgAViRx6PvJw51qYX8D
         ZPKwQ0aXXubdW1vcvzJbr2rkSlFdyF2QrY7BIXffrZEU4Nh/W5rp6lNtLhRzyEaVfmz2
         /esg==
X-Forwarded-Encrypted: i=1; AFNElJ+LJlsN3WFonTj8V86ffkB88ArYjdl2knRJ3rnfsIsxKazwL9n6bjRjwXahc/liKrV2ZORujvFp@lists.linux.dev
X-Gm-Message-State: AOJu0YymGcwC5N5mXPnyrbJRzAkOPCCThsOteZoiszV6j/m74SKJ5L3s
	XFHhL5peoMNKLql7c/3OmUCkq78JNW9zRf521HQ9GKA+RZY0/XAsukZDelOt+5XV9AKo0M4eKcS
	74cTpX4M64NaBnH0DcLJRRCMOZEOmyLNPjpSFi/EKzA==
X-Gm-Gg: Acq92OFZ9g0jKm7qgp85j/l4fS6wJGquC4vPGkppiykDSuiLoKq8GLwsXFyz9t8lUFR
	CxYgzFda2f5QdWLrpyQuB8FlUSTW+noxf62SguFXRO+NvUM33Q4Yzx2DGIZjDr25AJSBj8pNK4p
	q10mNGqvIhIONHNS3QLuu+P/eRECRLmWnpjdEMHqLIcxIv6TnODsoBdjgvZuzzr206cou/Ghxw+
	2nvG2RvQCXDisE36WIaSGqhM3SbhqnlSTIP/2qtlgYYSSWPYwYorto7/AWv/924tuHJKsiKwVpb
	XRd5TZxEI2+iB579ICmib8uUadpCj2QWXfpp/OYkr155dqNGyM9J13UezndadgjXV8BzAXBrpv/
	cDAm0
X-Received: by 2002:a17:907:7b82:b0:bda:2929:6f07 with SMTP id
 a640c23a62f3a-be9cbcc7e5emr118816366b.45.1780049853340; Fri, 29 May 2026
 03:17:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260528194646.819809818@linuxfoundation.org>
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Fri, 29 May 2026 15:46:56 +0530
X-Gm-Features: AVHnY4Iw86EbGmfBF3JCXmbOjYb0zoxBSO5fymJ1DtO6WDRAQAX9g5GxBs0O2S4
Message-ID: <CAG=yYw=T_fXbb+a5T0ot5rZdJ-Ph3vXnfR4bUvJ3zRUiq8=t=w@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/461] 7.0.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello,

 Compiled and booted  7.0.11-rc1+
No new typical dmesg regressions
.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
