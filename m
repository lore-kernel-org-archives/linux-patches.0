Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E645A31DDBF
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 10:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765363986; cv=none; b=D2NR4B2wowG+OsWq3Lvi8h6SNalF0MzcS0J8PdnhHv+eLTeEp+5LdbsrakIMImUZ7myQcWBIt79FqsHmVUHAi5V0ZIGExt9cR+Il1FNDRTUbMb5/z1FVXgsYhWZW7y5oRZxELLRVcnpQwfOeev//iKcMPv8mwZo3yyTEMFNRLaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765363986; c=relaxed/simple;
	bh=hdPTeQuwLO7nazKVxv13M7+YgWx/R1Ig5Ft93YvGDTA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oarcNw/UdeOGmvuNYn8ujUWXQsfcpUnvRvl8+WYardm13+J56XDLktLcwER3NIPH6qi2JA3DUJprrQ8zUs+36iyD0MQKzQc64W5yuh4QDFq+40d/AM7MtFZjrgdKUk4Frv/HwIxSYrZhf0zuaZ5ScIkBfo84YKVn26BCXARILXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=wGqnd/5N; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="wGqnd/5N"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so8038466b.2
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 02:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1765363978; x=1765968778; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SiX1h2OqPOIl71TO5rHafVk5bI1qE8eCSevWi2fIwEw=;
        b=wGqnd/5Np6T0dRE3sGGQm+IKk4Jdu6IBKPrBZdpGYk+pbqz0jIFTBqBbyKLi8EG0AD
         NgD8Py4Jbrt2iav0CoCR7NsXyzI6e0HrtINV3lwuEIpkLwVo4V5YNcJ1EdZVYlmBRuwR
         F9jaPRmTai3BEOODoKuwUjv8q1sIvvHvUi3kuFdzLS3yqvRTyDK7sD3vzmDRwbkPzKXy
         0YlxWJ1XdVApspRaSDEooqclNBL3eW9mgZAWb0TOZlk7JLqnPwFzKUaBB4UtSqtcL2Fg
         yDUAwPmy70hmCQZUpMLOAzk2HWY/haUWPlJYp61VqLSSlie4eoHvXUN9vx87Dx6wILSu
         ojyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765363978; x=1765968778;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SiX1h2OqPOIl71TO5rHafVk5bI1qE8eCSevWi2fIwEw=;
        b=mFJNXllJfh21QicbkHXvjD2eN2F4udTBVHCEUtuVRy+ixlJBuvF+KEZgOdceoqJs6O
         GKmJC2b4X/Jdplx05Tujs5VyZPirPIXgmayDhKJgqQEOy/keMDULe4n0EI7OxOS/D72g
         AxkznIJVcRVKIhi8AOgmZIvpD1S5yGFlWP9XCazbgqOkmYYygl8eTU0PJNULLOyXw/ny
         MU0GrgOBHRxYEIzgl907yGJbCA97LXaUV6NYqy5SvGTYu52p735eMRAybXZXqfwUdNfj
         kqPVTeH5uHY/0zUYKy+/JAGzulr8STSGU9j1+kmURpnXUUvz3vFbVL4/tetnBNRWeEpf
         SbZw==
X-Forwarded-Encrypted: i=1; AJvYcCUR/rrr7qN+hLXlTCRZEoF0C/Q/jvKEq2EbkLKmTOoX0NfaEKAD4U8Jf6oL8k/c6PCwud4iPrIq@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1EI5Td9VB6D85se98vS9KvJpC43JBJplmYNiMs01B1cKvUgiq
	xZGTQ6zOrLxboiY9+3OxU6RlSATdMPXnKSXF+HzW+Ano4clqpCFf+vdgnk+EDLSwHn0SJRQ/pt8
	jhaUV1ZXYnJaLj+gW0ZF/l+avgEwo5f3Eb61mKypqDA==
X-Gm-Gg: ASbGncutFB1qUe18r6LXIZcH8iEGaz1cYphnrKrq5CcEz2V3ZT5OE0VGmUYvIZ/1zgl
	SeLKToEgyYYomnJBl4rZyKwDtGCQgDL8YWZOvy02GUcWNlGQuAssf94dhsnJ2fo319BtNzBar4l
	Tb99OQfBaeD/tPXAtkEFLZFGqefHln1DDP/+8tfMuVd8gjsqWGBB4crWTTm3msqf+SHLoGN6nm/
	ppeLxUMoCeLa6wnD67AseXxd9SUFh0/Tv2eEV+0C2LBzehosAReXg1O/BhoRLLXcrEwr4Y=
X-Google-Smtp-Source: AGHT+IHnOyX+MeIfc5YygFoHa9XnwbAGln90nbQwzkSU0JLZLA5md5ZP+J21/Q/q/KDYEoIbinYN1M/Ahplq5mMEdHY=
X-Received: by 2002:a17:906:6a01:b0:b2d:830a:8c01 with SMTP id
 a640c23a62f3a-b7ce84f8116mr202027366b.61.1765363978430; Wed, 10 Dec 2025
 02:52:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072947.850479903@linuxfoundation.org>
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 10 Dec 2025 16:22:21 +0530
X-Gm-Features: AQt7F2oborVC3dV6Bsvx5PRC4tBGvN3PXLhGN5xM1ExAoAOOIAgKUxLQUelhpZE
Message-ID: <CAG=yYwm==BjqjJWtgc0+WzbiGTsKsHV3e4Lvk60fcartrrABDw@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/60] 6.17.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 compiled and booted 6.17.12-rc1+
Version: AMD A4-4000 APU with Radeon(tm) HD Graphics

sudo dmesg -l errr  shows  error

j$sudo dmesg -l err
[   39.915487] Error: Driver 'pcspkr' is already registered, aborting...
$

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
