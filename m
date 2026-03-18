Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38D0354AF2
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 06:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773816624; cv=pass; b=nD3tTVU8/iz8t7FZHr6MlUI9/wMcPaVXHP4ZrCzf9YygXpq+iiAgc3U737lLsjr6Fus0z1iWEpODF5euhbUR5SHzWNdNlKM2LMAVkdRcyAUOj+B2St5KlrekqTIK9p4WYgnKAiAY2k/JHqq8tfOCRftiok7Qh8DCq+3KN9/CZ80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773816624; c=relaxed/simple;
	bh=D+l8pH3fbSGAAiFTAKmcMYwmkdh9ywr3O9jc/b+KYUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=epf8teFowJlhV4t1Be7jM31ibwtDWqCioq4CZ+7jmRCfgmbR58GNV5LF2f8SPikHy9/RdarPf3eM/wJ2mhzVvTs1VPTQqZQMW03tVECIb88HIR+D8f3wRJRZEs+vvOk3WxJC5MN8bwfS1fwIC3p/TqE0ql4/XI4YSiJcWzMDVlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=ZZeqO05C; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="ZZeqO05C"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-661b16ac011so10961833a12.2
        for <patches@lists.linux.dev>; Tue, 17 Mar 2026 23:50:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773816621; cv=none;
        d=google.com; s=arc-20240605;
        b=X88y9NsH+hYfxO35WPOw83j1VDlgkmnk48TWv8q2Fzzd113yDPFVrsIusWdzyydXQa
         AunBJwScvVOSYx0bLur6fyyvoN8udt0k+5ldyBe55im/hcLvtZli6mLYukaugbjxKQAT
         jcrj8YN5H90vsuouv0H9tZD6ymy3t9uFHj17rcIJCxbv6KdHbZsI1ph6yc/NQHYpAQgf
         xuNchQX9jgsUqHXm+iFqxyA9k5KlsAwNxWzigMPASxZiHSBXutLQYVmpfOfCa+qqDGtV
         q1dRn5bX85+9uhYPreIwE3vNR05g3Vm2MGlW0nFdLvMCtm7KKLvRJEf/Sd+0qL6aH6k8
         Xm/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Zdvi6hWM24Xo3eVCU2axEwOSGy4gAnAXKG/xyveFr9A=;
        fh=Cy1nWCPxA/9ExglqLmyckelGioqlZVfkjxwWWqbU2Z4=;
        b=dsCKmmEvtz4Nw89yxxNi2iu9d2VOeMQpGZ8Co06RcqRevPpKhc+fML1VNAhj7GDdYT
         +/+qH2XBop7AG/AKu7+j5CvE+eb/1N5I3elrj1MuLbtHhMdYZaFjWwrVCqUocNq3tRcF
         6wdRiLePlX3MC7TRhvDBDAtW5SQhBmllaM+Hyv/5p/zR6Ie8Iw/YdX7oJYvuAtkuOoYj
         8R/jFFndiJlJOEbmqlDNZ5BBVA7dKdhxtl3/NypSUBVNEegJP2Dd7W/Jz+iDGz7pLPSO
         YzEYLrjlk4G+qmX+zEu0EjJnUreimoTLl905Lkeuc8+gZOI2Egq1wUqv/FU3oG08ZTyA
         f1yw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1773816621; x=1774421421; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Zdvi6hWM24Xo3eVCU2axEwOSGy4gAnAXKG/xyveFr9A=;
        b=ZZeqO05CJGljecTWEJE/hG8Li151JXnOIU9rGpzFk37cl0y5ZEjWQPvqQXjCJ2lMa4
         J2+0CgsQBTDr6nD811UvGvSa5SLzygJYx9lF+oVlVn2LNu5xDlqxJ3t1OUFFDO39T4R2
         B5bbPq6OAL2Y/OpeG9umMbskObc8QX47BUL7/nuTffZtk8KbeI5x7xzW/wkAymneeUsx
         K/nIu/PZYKG9kDOOMmSDZtdsB0pWSqCa1pUKnMivhrk56CavZxOYJ3x8DvhrBV70w1zT
         RyjaY2xH62dt45nuoLEw55EtL03CFkhrNenUmOhOFt3GcQZdVIRM3RuJNZ6MTa+AmMl5
         tOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773816621; x=1774421421;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zdvi6hWM24Xo3eVCU2axEwOSGy4gAnAXKG/xyveFr9A=;
        b=N95o+SNA5bSEV4CIBcFFVGYJUvOBpCFFI9Ma+JQy1/bXfxFCGO+X6iIzOPh5xjHwvg
         KoK2knZdDAZd235Tmsj+K61rQ4/+DmWIMcFZdFAj2moLtKbaDwWox8RNBmD03Xn+WFY8
         2BNL54K2jYmYEqhh3UkTT37GGvA+iWMfeWbr01ftA022MEI2qXKpimHFu/sUQiTgQv1d
         qKZq6YquMHrE8uo7ZBaLegBhZqkgQkls0GXkKtvCCab9pyVdtnttztea7vW+JtaCTLDh
         6WJTc19qrcMVkLgH6FrcNEAe2hKK4nmvrOPmn2wETYhonHTMDtJAtXbgPUPCW/ApjJDD
         6uCA==
X-Forwarded-Encrypted: i=1; AJvYcCX0ONyOlXa1CUJO/bBZsq8fZjQyBgJspDimgZELJ2AstT/pSBn6d5heIikCdEc0T5p/ovLS8HAJ@lists.linux.dev
X-Gm-Message-State: AOJu0YwZVd4EmZnzJfY/ysZhPltFqJ/YZUmVMr7XBDate7S8j6VC0wed
	Kl2VCxTWIKcmqR323EjtePDnULpYCp4pi+Q97j1agtquGavCFKKT5GFzimMfIN9/ZiswP9W0DZd
	gBp9PAd/85DwS5oEh2vsz2YueCJ3fkJxGZeLIN7w9jw==
X-Gm-Gg: ATEYQzzvnRSdBUHH/q2jQtuKN1da4VoWM66fsI2NHJFNt9ioO93J1efMR6CiRFGECkk
	x+luY/5LRI3Ahx91HUVJWUnKypQTfHnSNr9SPozJfwUNtKThVZx+Gzao3wsHr5Ahc7wPFzPvyqb
	ak+E6OjQo4akbx8yDU0DhHityWMqGuW01UlOAra4SFrRbFMXEIrph40LT/86ybZOF3yz8nYAt1N
	W0tbCrfj3t3CMhISDgsKyuvI+GWIvihiZVKxQr7oSpBl9Aq/x9FRyoq7dBor9f7/ixpwLjxtbCr
	Iv2X4Oudl20/8V8PinGJilIE6zJPe9zfmhLpO93aRzryoj9pJDCwrnC0D6tt5qH8q5Btjz8=
X-Received: by 2002:a17:907:7212:b0:b97:ad82:973f with SMTP id
 a640c23a62f3a-b97f48ba054mr121944066b.13.1773816621097; Tue, 17 Mar 2026
 23:50:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260317162959.345812316@linuxfoundation.org>
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 18 Mar 2026 12:19:44 +0530
X-Gm-Features: AaiRm53yRWxBBTQF1p7uxw4V_pBVj0qnQTGxwtjzEHQXnfphOan0wcD2pkPn8N4
Message-ID: <CAG=yYw=mjEuAttBzTOq4VpVhwUFmGdddDm4XWxTHtN7Rtm5EbA@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/333] 6.18.19-rc1 review
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

 Compiled and booted  6.18.19-rc1+
No new typical dmesg regressions
.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology-
