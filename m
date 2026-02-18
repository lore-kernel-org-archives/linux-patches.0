Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9662830497C
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 16:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771433334; cv=pass; b=sN6aFebgEWl5t0Ya2KjsEVp4nR3diBcGH1L+L8ESwOXj5lC0dHWsJmaNYPAvjCF0b52vRNoA3d5/QBUZoMiaB7w0LxglO7rMjjVxeEGOKKBK24+HzDktSooO6XmbW8zwR1dsdf8lQ+oqO92VO1bkKIZot52gDYZt8gwL3prSng0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771433334; c=relaxed/simple;
	bh=NDZWkf75fuSFgGmuPbAdFFylXmr6cKJW+FgcMv3BRp4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ec+xZ3jnU0NMkJwW5yK0UtCGjIam5AYX5sGMZei5qesOC3cZQSCnRdwdenJ0cTIw4pUnPpTsBliXbxwMAO0b7j3S6YJOsQZHSKH5J4GOtOGhvdrWbz8kuXZHh4Pp7QlTesZl3qlVauYX22adkmdutNpOwrRqZ2Nzy4DbCyGcoWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=A0Lm5LWz; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="A0Lm5LWz"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b886fc047d5so10904866b.3
        for <patches@lists.linux.dev>; Wed, 18 Feb 2026 08:48:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771433332; cv=none;
        d=google.com; s=arc-20240605;
        b=EHu4owLY05yc23xIiC97Mx50Sm/1f64k55mpRZdgdDgqsSh0hzk9oKZxw4p0ovdXLN
         lXOyXSEO8NLNflFNEqwGAp1dA89H/pmWyaMpsyTtCnbW+Gp5AFjCSLCm2tlG7kyzqT+l
         D8UTBET8aA1Q38paWgmfdOkce1najnC3gJZY13tDmyELgHvDHsauYSeqHTnQBO3zbnqO
         BYeJEDVknPF18HG6WNzt/AfIoIBKDkP5Y7nsyyU6hJlheiU/vPvNqId/fgq42slzgIGH
         uyKKQDZPGuOxwHbipFiCg0s+mC4hhUpRIZOwI5DQfD9XuLh+FeWzT7NW7zb0uPAgAa/N
         lXyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Sl0EJrX9qWQgs7Bb3+x2webBMo2tPrGnE9i1r6t3N7I=;
        fh=WHbh7MEmyRlwtVsu1xtschTcQ7HH21ELqyTWLBDaVq8=;
        b=EVVjCUb52YMPwOsN/pJN9mn1f8nO6NeJDxdJRjdZneXJa96Mk7oE2lIamilzPFaXGi
         Ny3NU01ysXGGJXvT3esa+00psV6VhDnWvnA/xDFpM+oBqStZau+wJDovU8EYPuPDP8+y
         tZXdM12veExOAeI1jHdKGiQGifY8JbnudbgzyevbQu7Hef8N3G/wdu4w0lF8prqt62aN
         Oiw7MA36DsLT3iA2bEo0tuJ5lIWdVeoQ/t2XsUpZj0KdchkKuwnxJai9uZDTSEyIzzSO
         VuaxJWLrF6hOc5+GSTtvgzBSLqHt74KIhK0A/F7c88mBDCxLOCFq0jy3gHFGD4V6tUGT
         4n5w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1771433332; x=1772038132; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sl0EJrX9qWQgs7Bb3+x2webBMo2tPrGnE9i1r6t3N7I=;
        b=A0Lm5LWzrttfB+7JYXaO3FC6kWGC+wPyNzJA83pB3TelPhcqpenp1y4C5f0LrvfRg9
         XTXW/0pAR3mY8LHuaon8rf26iraQbH+7+upDEx0aOmddkiHMz0SxBU+6rdIWKTlD8uQW
         /ALGzyYrfV4MyEV8FB1Wd3L6OiKzkFzErtJoi+DLUV9S0GcjcnRy1Js45EvLyBOstN29
         nlrLXvqx9brJyQc+moCjFcDSUlaDWjSuZw4GUucBI9xHqS6jMyLUmwlSYxAVj7Jgpqrh
         ij7UELQt2yA7K29FknLkm9BMUlQbOkZkzLSpGs6COmR2fJnkMr7Jy/bRe7joXgw4A4Gm
         kDeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771433332; x=1772038132;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sl0EJrX9qWQgs7Bb3+x2webBMo2tPrGnE9i1r6t3N7I=;
        b=nKnfdMDI/uSsGck4Ic/H6uEUZQrTcgsUhkzOSOwqNrgCWAqpEEJDn116tSk1XInHe/
         vvews86Mn/BM2sCH5poTbaPdbI5Z4yJtTr4G+1voCGPJU4DBRj4BU+g1f8Rusn50l8OI
         OLK36Wb+qqQt6uHuQAeqxlut8edFUdZdq1cPSNrNW4e3TOpqOemKaCGfeT+pMHCkJgkr
         iVEghDR81l3/tWQu+9oTcDY36qTjDSPa+G4NAoTi9Ii2bK95XVFsHrCzyHD++XlMJEU5
         0360hKJ3FSiuqNDFb2qNeSpfIXTF/SLRrcYA7ib4iaSvtM6gzLqn+LfG6rYf/3/7I/Nb
         T/kg==
X-Forwarded-Encrypted: i=1; AJvYcCXuol4ZO+/O0/kcyP10yLCdvPP9IjoK05mhDjEChKmBzqn2yb5qoxt25hR2ZSMD8VBSKWRHfXiv@lists.linux.dev
X-Gm-Message-State: AOJu0YxiLqBp2yaiFklDeggPTTnMrKT65WIlvV0BWo8dY+1RejYLUTfH
	paE8mFP+e7N/7LxnXjvod33q2KHSltO80R+n4d89oOZKqZ0lQo97/oixgAqMsLwxRagDD9/cSmB
	aZcsH6KmlYPnw4msZdZw/pqgbguNJtlhUdrfe75XrLSblXEGLIHtILE9Fpw==
X-Gm-Gg: AZuq6aJUa4iI5LknW+n8BpLt94yyO4/dEE1ztBnhVUc5qifq4GNDapygWCs0ShET6PV
	Q89SRpJ/3xJCx90v+jQaW1dAPvXJmhsF1dWlIqfeUtXaV2Oh4TC9MC4GqamGL3oXE5Jy1wlt0mc
	6QKZejiL5aBIbUpiH1VlnbwyQm1gKYkqfoRO7Pc8f4L41r+iXr4GlRjV8XGK36xJBUmXYe8Aby9
	WXnWFIHEA7qQ2RvY8HpM79OgwG71f90u7fAUVn7pgk8qmooFJUEoa/Cd9MwQ6sECO7AYxP05UZd
	HeF5tAKSKfIT0pfOiEQUeiWU5cDGZ3jnwSxa2rtxZrvTlHYFFR2uo5F7Z6g64EEp10BNIQ==
X-Received: by 2002:a17:907:982:b0:b87:718:5da2 with SMTP id
 a640c23a62f3a-b904d615300mr1530766b.1.1771433331917; Wed, 18 Feb 2026
 08:48:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260217200006.470920131@linuxfoundation.org>
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 18 Feb 2026 22:18:15 +0530
X-Gm-Features: AaiRm50okWH3DSk3tmbkRt2VF_bXv0FImyY0cJg-Wxj8CuzWNmO5ZoVpgJfzAPM
Message-ID: <CAG=yYwn4ve1f9ydGK=azDkPFnnKiak5Wk391U3JhSgf1+Ukf1w@mail.gmail.com>
Subject: Re: [PATCH 6.18 00/43] 6.18.13-rc1 review
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

Compiled and booted  6.18.13-rc1+
No typical dmesg regressions.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology-
