Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F8D280318
	for <patches@lists.linux.dev>; Sun,  7 Jun 2026 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780847358; cv=pass; b=GAYQ2GD4+Obor5BtERP/DZsJdmW9n5GpPZzg5GPDXNffQ+C7Y9kQB6P4jsf0V5drIof+4D+xCxueUncr+SgDKzUEsmMCN/OwbG/KiQ/yNnHu7hxmNqPBc1di3Kyni0nyARgTkXAMGUaC5ASmdGi4zC5DBoTC/cEb1KGKwnoCg4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780847358; c=relaxed/simple;
	bh=D1n7Uh0RRkUlE6NRiIjR1ZGk/n2yO8IMKee0qspWMv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bMpG7KukkI3Mze96rpD9m7hq2OXlJ5YZAOMW/7oenUD8RVHg9Ve9uOW+MLSk5VMx6WvNo4WEXD7z4NZKgcyKiEAwjuTsjnivZvLDdrS9eMDyEHKN1hMKZIGdmlB4mlbVZ6toAHZXCdUOXJZoqCJwVjHJyvfLBmPXdDcO38vOIFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b=Ak/Kt/d7; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b="Ak/Kt/d7"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bec3f69d343so505772866b.0
        for <patches@lists.linux.dev>; Sun, 07 Jun 2026 08:49:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780847356; cv=none;
        d=google.com; s=arc-20240605;
        b=F1BE8kpQavnvTrDBXVbt6zNMF+TwNr9aIK95uQCjG4k6SLpw/yAgdMVym0oxwzl9fd
         FSwld4cyTFjSMwLJPqzyusAvui7rfuvjcQh6B5ebLjY2paddSWnKPZtlRBApzxCuDYVT
         QNiFhfGUQ1zLtnAVpzlsKsmj6W1Wa0htlnwNUxDRwgCqp9fbUvWaXDtBndOweK1vSm7C
         MJmTYaPohxaxB9z6VINS0AQdjEWal+QWFyrQ0oppTsBfoZZpF23/B6LoR57nBRVZAnFG
         DWcKWMFzF27D0Znl0vB+98wH0hJZUPYKPrOuTSbxAnWZgH6SvLCbPtJ4+SBJQb+/jsck
         f2qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xILyxddjfjQZmYMtoGm3pp7Hh4z+748HBnbedYkhxSw=;
        fh=S8npgCIECt9SL5zosvpHHWmXYkMc9zFgDPZ233w1fvs=;
        b=A+GFeztnTdEqUeLnZPeku/FCrsoq1j3i/PzpCYOwSXlDacRrgd32mTSIrrV5MiWG2z
         yilIkkc+zApmADEUHFN99qNTg370r+iPDf1DLRIZuThE3tSq0kVBkvus+bfgtNd1jp7t
         xtz/6lh9qDFdE4la3dZJc1aajNnh+9flTttLHFmWK7RcPV+44srWZCghIMe5vl1Fu0HQ
         lAouSzv41bN7nwIxO4xbs6HnHtyBVITOP2VOr8DjfdIZBo+BptKsmtV6NxUfs9FdtTHf
         +wzwaqZf3lMkigdNRDl/pTDxcpsTzjqGY3lx/d97X+SlTsQXJk4oGRu4NrVZDMQ2Tt8y
         mAGg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20251104.gappssmtp.com; s=20251104; t=1780847355; x=1781452155; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xILyxddjfjQZmYMtoGm3pp7Hh4z+748HBnbedYkhxSw=;
        b=Ak/Kt/d7oR22t/feSVqpy5F+znOZfubtrtti9Wo31VZPAhPfl/MAf5sdDdO2ExK6UG
         4ZB91I1s6s6vWpLnjH/09RVbLVrFvyUgo3WfIJ6AdKluwLniMVSGtHYDiATZDXK94oMY
         G+diCq6dx2V5zTiVfVbpsPw8wPeOzMBHUq727Yv0WDWjKn/k2mQEdTI921I5MVKsM3Sw
         fnSKmnA+nrv3+bEFO9pDAMj2Qi2ro/QehQuiGYxs9gDjSzFI1LSaB4KoruHSas7OqaUI
         46+OJV8w/ufeTuLqoIovqR0pxzF7hGesdJOqr0cFXIs6n8dN5NCDHlO4vyeE9TjuMydR
         2+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780847355; x=1781452155;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xILyxddjfjQZmYMtoGm3pp7Hh4z+748HBnbedYkhxSw=;
        b=Vxt2/A5oAUngCgkFN+oJfgET2rXQj+eSbXw9+JQKglLRPaNmGmxrZHEUVxtIwtQw8J
         6QqYIKAcj5JwjjScDclI8Tqy+6expxo9EN1BAF5nuK6PkToWMESaEbCZDJSbz754Z8PN
         nOZQjI9mUYaZgWRtXu4CwWhwFk/gWOfqkDaMkeeYJqtXTQVPBVBjAqCOPzTRFcReJ55D
         AVwVM8FmZAPfUhTe0hZ19Lvnr/kWvhBJU/9xVLAbprimVkOkCrbsQ7IMmntVy1VjHxIN
         YmJuA2KHHpHR4SOng42ZV2dlvMf8VXhyomBQ4l+OJuZD6zCzGaZ5oHynhtAqwOMhYpti
         //Ow==
X-Forwarded-Encrypted: i=1; AFNElJ+L1MLnjPEpT3O8KizJdLe2rRJsH4ftkV3y0yP7E5QLgfjGeQb2mIRseFplEUdathWF0aYOop/e@lists.linux.dev
X-Gm-Message-State: AOJu0YxkX8kbklIKryrDP20hgcJZrwDgdEj6ywb48s5OaH+s+TZBf1R6
	71ETOSVnd6XGMbY0ICg+bd+6kGo4QM3DN6UhToJuc/Pn/LfH+wfh4tN7kxE4JC/4rR+o5L0rSxQ
	jJ9zbxto50CfWKUuHt+sXqdNbuaKg0P0nGcrt2nH0HQ==
X-Gm-Gg: Acq92OG/54O1ibFfh6NO+8CWpNpzTnV69eX+p0UdIMoJnRveurv+joS/C7eWweh8F7+
	SKpC0+4WeouYse+uzBFl20hgWyVCW7pyYu/G5xZSfFo66xHoNu2sayw56xDGWNM0aCw8751+Sag
	qkyUUa63J4uYh8zgpE6iv3+2D2TJhdqYXnJTwE1RKWtymF535zJb/lUlUo2Wjf/vPwW22EBO9rn
	HPw8yD/ZOpmRGVPNW+Wlc83slM5UyQxaF3penaqPIYRak2qpeUJ11rW9H7eHS1RKWK2ee513Rkk
	6HrNz2mEntdLYhZB/Sb/bGGNBnJvqOODx5+zyE6DCC7280lt+WoP0+mnSsjfsbnKcjCXXMfS7U0
	i+h98
X-Received: by 2002:a17:907:6d05:b0:bed:afd7:185 with SMTP id
 a640c23a62f3a-bf3737ed359mr555128866b.43.1780847355515; Sun, 07 Jun 2026
 08:49:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260607095728.031258202@linuxfoundation.org>
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sun, 7 Jun 2026 21:18:39 +0530
X-Gm-Features: AVVi8CeYeLBHlhJ2tTYI6qDwpS_oBJoIdqCJETvngCdnlJrh6WvqcUlyLmSxt3k
Message-ID: <CAG=yYwn9Jwk4VfM_fiEs==xpic0heBDS8X-H6jCqU1cUZUCP0w@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/332] 7.0.12-rc1 review
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

 Compiled and booted  7.0.12-rc1+
No new typical dmesg regressions
.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
