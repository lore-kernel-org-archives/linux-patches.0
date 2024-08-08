Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A7118B482
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 13:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723124147; cv=none; b=kopg8z8vG/9Sh+Ft60O+qtnN7zxF453SktlwbbwgzxmXampANZx06WuralyLmJGk8QuqzCq0JM7Mx7W40EqRXzTjS+EPVzpKOTAfahL6ewB8c+zRgJmCzm7NDS/SAjOvHwaJIiB6ePTvvH9xQmUQIlUp/eYT/hAq6hnvrnFacyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723124147; c=relaxed/simple;
	bh=2VxjvSo5CWeUGj2UqWljBijX05JHiU2D382WZGpQshk=;
	h=MIME-Version:In-Reply-To:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type; b=lEJUhdmc5PgFjJ+XzB2TevlOg19VuK8j/O+w4W5CvBLDMtAMX3jZxPQ0YDs3tklFf3ptbYXV6A9zg7Kli4a8BjT+vn12CUXKRKomBxFoiEiw3J2V6yrNNQj7ycMRri2Z48hcixaFwjOsivDAchNvOtf3HyDnl2yvSgBQSxbsRak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b9dRW+oC; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b9dRW+oC"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1ff192decb8so11098235ad.0
        for <patches@lists.linux.dev>; Thu, 08 Aug 2024 06:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723124146; x=1723728946; darn=lists.linux.dev;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2VxjvSo5CWeUGj2UqWljBijX05JHiU2D382WZGpQshk=;
        b=b9dRW+oCqpMyK1GRkdab0oe43WXXHq15fQVEEhcvBqcT9TzNSpaeIWXBN/5a+6GYHI
         w6FaaBYjLeyUOufpauWONlX2SAT2pFp6rbJaP2IaFwVdOKtSzjlK6706TeglTQL/tW/l
         Rx/gxiKMWetLeNYXJvuL6YRxGsq25L4akrlC8vRaJEgp1ZSBr1REbIuec0D65eA9B8bI
         5zBrDO+RoTHFAtNpPFNbNw6vTim5DiXTlQ7Ob5EVQkXTp0CY5lkJRdSqvIyYV0pobUeZ
         p1xwRj/W2Fpisq7PLkx6uVA21Wxin+qFcjgEvQl5ST5JPfJHZoB8Wj904MJbbjaKHjmu
         TYHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723124146; x=1723728946;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2VxjvSo5CWeUGj2UqWljBijX05JHiU2D382WZGpQshk=;
        b=aMvMm9N+o/27QTdy+P8FYYzNPjaYXbipXLOyWnpnv6nsMVvXBq6JeH9FGanIpELAjH
         GhWOpkC/iTXFz/SeuhcVx6HwyDYlGHU31xh43S3VicltdEf/323g0aCZsILaW72QfkD6
         rr/3PhtGxspyMwnfsU6EFFqL2OWiNaOa0fysxRI99IqytUs5FTJTZK7oJdOaZnVJSkCo
         O3Bf9aOAfRF2diM3nMKIIuV9Rstu4wKKRBU+k47UsejgO8SwxgY15eNN/wN8QXe9SNlB
         Hi8xfNarjVki+K1hiHynPMLxB0r4zKqfMIJ4ari2LDlT1NfJY06s0je9Jr4ggWLblv/c
         JRsg==
X-Forwarded-Encrypted: i=1; AJvYcCUyHwcpVYggyzkgNxE7CcvMns+3qwlt6vEOnoKmubDNHa5ZpKgStel6wGpJx0euv/pBntbood+lCoCF2kJQGC0A+WpvUdJ/6A==
X-Gm-Message-State: AOJu0YzMD8lBsmUSzkSYcJdFo5VCcgpkQfPeaM3pW2KvSjDYm29LWWgb
	M5WptMStkKAEvNGoXUkTiF7tNF2O0UZKFDVF4eOmOR0pS0aSm5fv+zW+vOX/zD8/0o59T7XtsSP
	+kVwsOPVf6Qxsid37wL7v1N7WOMHDxlnTzMfxlQ+FTL2RgH4ZTW+WQkpfjJHrH4qvQwAW6BvDAg
	PCRADFWani4VKqleM2vv0R7I5XVEv5
X-Google-Smtp-Source: AGHT+IFYnhRclT0lkgMKhJlVtiYmJB3iQVlz9EWjWvJ/qMbE/TeWDH1hqjCLcKM9l13PdPH/Nagy7Dj2L2nYNmFFgOkNKgx5jYwIYVlvgUPBnlRRlw==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a17:902:c40b:b0:1fa:2b89:f550 with SMTP id
 d9443c01a7336-2009522b657mr1711305ad.1.1723124145897; Thu, 08 Aug 2024
 06:35:45 -0700 (PDT)
In-Reply-To: <20240808091131.014292134@linuxfoundation.org>
Message-ID: <0000000000009f2a72061f2c1aff@google.com>
Date: Thu, 08 Aug 2024 13:35:45 +0000
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc2 review
From: ChromeOS Kernel Stable Merge <mdb.chromeos-kernel-auto-merge+noreply@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, chromeos-kernel-stable-merge@google.com, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hello,

This rc kernel passed ChromeOS CQ tests:
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/5766148/2?tab=checks

Thanks,

Tested-by: ChromeOS CQ Test <chromeos-kernel-stable-merge@google.com>
