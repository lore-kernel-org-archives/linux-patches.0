Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35069285066
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 07:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765957238; cv=none; b=Xn9l9wsYWPnJZy3unuqVh/5MOyAvm29VpA6De0K+P2gBnBkZnbmD5Pu5r2hXjVodZVycMO8D76OOGuBTerc0U/6wenQOiJJeDzNbuZlHzdaQBcDqTZHNYTmvsLsvYbwiepIJW6sjVTm14JRN5kDkV8TQgWdltdJ41bCDw1qudoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765957238; c=relaxed/simple;
	bh=fU099nj45X0tht7QIRvdYz8ExAJLyqmNMEoS52Por40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jNGUNg1wJMU5AIb4yf8ZbH2rROCV+O9SMJGRMGRpZk1V4Zhs8joGte6Nz5KwKDfYS+kRFx+J7PKUFXxVCicAX5jUWR6OGBoDSziMg1RbvF7nGAFVxiLCyv/HRG7vaWvbiNRsmuW+Rs9fjzvPkGx1eVQ3PNkfCdDYlj05xT7w9jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=WCNB8kI2; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="WCNB8kI2"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b79d6a70fc8so956403866b.0
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 23:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1765957235; x=1766562035; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d0gyntNuzpuZQ4YLwBZHoVwxkZh9qXD7dDqgmQ798Qc=;
        b=WCNB8kI22wC72zQeT/N8rgeQdOUD7UNrl19IF0crTUKHXkVxpZDmH6dRmvylIExXGv
         4p1sBaMx7ok7OX5xPRdo1Tz4WTjUadjJiRZZpxLnNAkTMoDeivhVpG6unRmIH/vce7+5
         ir6TGkHz+5TZG5l3wlvQzLGkC6xemm0wuHuTjNPf5LDCsCaKY+X/mMWEq4GQyucbLH85
         B8aDDU9Wq3AqAC+bbB4lbBe1Zheizr51iwLSf0myzGhHsYCPA0loWD9Jd5FrPEdHg7HX
         cGN3wEO9ImN28IaJNj5XhhRrB3VctCdS2PZo7MWqtTmvqdcABgD3Brknz3zq3qNEWu81
         /vFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765957235; x=1766562035;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0gyntNuzpuZQ4YLwBZHoVwxkZh9qXD7dDqgmQ798Qc=;
        b=klkTJIkwfbXUEbi09jx0wJ8//2jZUUryjuj1ENrrc2Pe3+l0IH/tGEQzyyYvfsqb2V
         Zax7sjdxXCv05JGyizcPSYvIm5QqNQ300W4gd5KqKrwi6cUqXq+/0Cjr4Yj1/bPsyGN0
         UNEvuy0jT4eR/hdr742YFFxif8QA8R1SboCNjCwv484uZHZ4T58l45DZhjuCYfWVwDNM
         KvlW3GCnUj+46khf0XaVz5oXtvctnqKMmNhaidsKY10q3lGh8IRZ9/FD3II9ojx5Djf8
         Fgm5qZCwnDo+WNasekjqVYns29Yth9tNkvGt7FBYdN5OK6JjW9OU+MdUb1lDw9YSipMj
         ocvg==
X-Forwarded-Encrypted: i=1; AJvYcCW4TMG8rlBHgiQ0ZgSqHPx66cgHsMWRo17gd1zamAp+oRvc60B+raAZs/ub9Sj9lj5YkvjK8RjE@lists.linux.dev
X-Gm-Message-State: AOJu0Yzf/SNLZYXBywQ2jdRZRclP6AjUeVi6QCX8w9xuOg24ZVO+uDPJ
	JJcUDOVI3SKi0F7mgaqQBq6wiZYfXXMp+Gpa1Ifxc9sCxv23ynvzU9vAkwcWf0bDUHNo/Lsk3hB
	a0ObHdUI7//E1jxWRiR6oVhWJiULU+FXWJomkZumFdw==
X-Gm-Gg: AY/fxX7Y95s7kiAK0wwV9LMSv9edVHRBjXN3A4f2ZowLWZfrpIZR/s5xJorZpW/WvDS
	aZ8anokX52ucgY+pmVmdkRsUj8WORvunWIdebLt0TdWFUcbeJPfcU3puXDm6IEMu+v5WcTH+5XY
	YYeZSBi6MNvXQ30mtzzBe568XJo9G6lcZ+f6lVOobYcMbtjQPEVhrPjflNHBUViv0wPwiB+FFBl
	IQlbptc1x+lBOMSVbu6hpnDuZ9TvkY2VxgjgAXnZm6C+gncd+Gnrf79m16jHea+HSID4Rw=
X-Google-Smtp-Source: AGHT+IGRmTV0LqkvYsaR/Ni74+Dv9OY5BQXHZ5fquyjz6BfKca0DAU/hhccIkjejdxvyIWeabJqKfKwyVOohgaSWUKQ=
X-Received: by 2002:a17:907:7e97:b0:b74:983b:4056 with SMTP id
 a640c23a62f3a-b7d235c8495mr1625314866b.8.1765957235313; Tue, 16 Dec 2025
 23:40:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251216111947.723989795@linuxfoundation.org>
In-Reply-To: <20251216111947.723989795@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 17 Dec 2025 13:09:57 +0530
X-Gm-Features: AQt7F2o_ES9P9Gs-Tac9DwXIzKB8s5SKa6EGyWjFsp86EKYa3uiFWdhy2Knc8e8
Message-ID: <CAG=yYwnv+EsEhOSUFFFGQYm6MXzDFzPKq=pp+wk2J5rvLupoQQ@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/506] 6.17.13-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: multipart/mixed; boundary="000000000000b3507c064620f5c2"

--000000000000b3507c064620f5c2
Content-Type: text/plain; charset="UTF-8"

hello

Compiled and booted  6.17.13-rc2+

dmesg shows error...  file attached

As per dmidecode command.
Version: AMD Ryzen 3 3250U with Radeon Graphics

Processor Information
        Socket Designation: FP5
        Type: Central Processor
        Family: Zen
        Manufacturer: Advanced Micro Devices, Inc.
        ID: 81 0F 81 00 FF FB 8B 17
        Signature: Family 23, Model 24, Stepping 1

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology

--000000000000b3507c064620f5c2
Content-Type: text/plain; charset="US-ASCII"; name="error.txt"
Content-Disposition: attachment; filename="error.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mj9p5x4q0>
X-Attachment-Id: f_mj9p5x4q0

WyAgIDIxLjk4MzM3M10gQlBGOiBbMTEzNjcwXSBJbnZhbGlkIG5hbWVfb2Zmc2V0OjIwNDEwNzYK
WyAgIDIyLjE3MDUzN10gQlBGOiBbMTEzNjY2XSBJbnZhbGlkIG5hbWVfb2Zmc2V0OjIwNDEwNzYK
WyAgIDIyLjYwNDM0NV0gQlBGOiBbMTEzNjg3XSBJbnZhbGlkIG5hbWVfb2Zmc2V0OjIwNDEyNzUK
WyAgIDIyLjYwOTExN10gQlBGOiBbMTEzNjc2XSBJbnZhbGlkIG5hbWVfb2Zmc2V0OjIwNDExNDYK
WyAgIDIyLjY3NjgxM10gQlBGOiBbMTEzNjc2XSBJbnZhbGlkIG5hbWVfb2Zmc2V0OjIwNDEyODAK
WyAgIDIyLjY5MDE4NF0gQlBGOiBbMTEzNjY2XSBJbnZhbGlkIG5hbWVfb2Zmc2V0OjIwNDEwNzYK
WyAgIDIyLjY5NzUwN10gQlBGOiBbMTEzNjcyXSBJbnZhbGlkIG5hbWVfb2Zmc2V0OjIwNDEyMTIK
WyAgIDIzLjA4MDQ2NV0gQlBGOiBbMTEzNjY2XSBJbnZhbGlkIG5hbWVfb2Zmc2V0OjIwNDEwNzYK
WyAgIDIzLjA5MDM3NF0gQlBGOiBbMTEzNjY2XSBJbnZhbGlkIG5hbWVfb2Zmc2V0OjIwNDEwNzYK
WyAgIDIzLjIzNjE0NF0gQlBGOiBbMTEzNjY5XSBJbnZhbGlkIG5hbWVfb2Zmc2V0OjIwNDEwNzYK
WyAgIDIzLjI0NjM2OV0gQlBGOiBbMTEzNjY2XSBJbnZhbGlkIG5hbWVfb2Zmc2V0OjIwNDEwNzYK
WyAgIDIzLjI1MTA0N10gQlBGOiBbMTEzNjY5XSBJbnZhbGlkIG5hbWVfb2Zmc2V0OjIwNDEwNzYK
WyAgIDIzLjMxMTE2Nl0gQlBGOiAJSW52YWxpZCBuYW1lX29mZnNldDoyMDQxMDc2ClsgICAyMy4z
MTE4MDhdIEJQRjogWzExMzY2OV0gSW52YWxpZCBuYW1lX29mZnNldDoyMDQxMDc2ClsgICAyMy40
MDYwMzRdIEJQRjogWzExMzY2Nl0gSW52YWxpZCBuYW1lX29mZnNldDoyMDQxMDc2ClsgICAyMy40
NjQ5NjddIEJQRjogWzExMzY2OF0gSW52YWxpZCBuYW1lX29mZnNldDoyMDQxMDc2ClsgICAyMy41
MzkxNDVdIEJQRjogCUludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTA3NgpbICAgMjMuNjgwMTg4XSBC
UEY6IFsxMTM2NjZdIEludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTA3NgpbICAgMjMuNzI0OTcwXSBC
UEY6IFsxMTM2NjZdIEludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTA3NgpbICAgMjMuODUzNDgzXSBC
UEY6IFsxMTM2NjZdIEludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTA3NgpbICAgMjQuMjU2MDQ3XSBC
UEY6IFsxMTM2NjZdIEludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTA3NgpbICAgMjQuNTU1MjQ0XSBC
UEY6IFsxMTM2NjZdIEludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTA3NgpbICAgMjQuNjU0OTQ3XSBC
UEY6IFsxMTM2NjZdIEludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTA3NgpbICAgMjQuODMwMTc0XSBC
UEY6IFsxMTM2NjZdIEludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTA3NgpbICAgMjQuODQ0MDEwXSBC
UEY6IFsxMTM2NjZdIEludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTA3NgpbICAgMjUuNTgyNDU0XSBC
UEY6IFsxMTM2NjZdIEludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTA3NgpbICAgMjkuMjMzOTg5XSBC
UEY6IFsxMTM2NzhdIEludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTMyOApbICAgMjkuMzExMTQ3XSBC
UEY6IFsxMTM2NjZdIEludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTA3NgpbICAgMjkuMzMzOTU0XSBC
UEY6IFsxMTM2NjZdIEludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTA3NgpbICAgMjkuNjQzMTc1XSBC
UEY6IFsxMTM2NzBdIEludmFsaWQgbmFtZV9vZmZzZXQ6MjA0MTA3Ngo=
--000000000000b3507c064620f5c2--
