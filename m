Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D919424D74
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 09:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799241; cv=pass; b=L0C5ziBsopnI92G4/amVPzJIPLvy4dCvRu3fhUWvH0HdAD1su8Ug3jR1xgxRxzJVzYC/S5+H0m9Voc3FAZdsnFHAt8E79OHGZHnkmAY1kmT59M/bKYx+G4ZuklSGFu4V+goBo6ATIazwZ3dHtagBbNMWG8m72XQ9YrpheX962Qk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799241; c=relaxed/simple;
	bh=MR1+UGAksB0ZHbOjOtwK56UnQo1V61gGdQfz8WdaJ8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BcGKV8xNaKBcPsJw5pPe3Z6ibvJBYXZzQR5VYM035A1NFOYaBDRbM5O7a57DQqqYs35lkkgIcK1x5Uhlf11zeBT3VFLZQD8du55w2+55bgyn8/gKibk9feX6k0OXb7K6qOKY/HfYPMymcosL6ZzQzhbYYjs6hYG8VrxnWd0eLjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B5c6bp7+; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B5c6bp7+"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-80e24970f1dso2663537b3.0
        for <patches@lists.linux.dev>; Thu, 23 Jul 2026 02:33:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784799238; cv=none;
        d=google.com; s=arc-20260327;
        b=Y2b/8SPlSl5q2H+vGh4edl5fVifTyvIxf+WbTH3pPmEkM1+r+KWVqDvVjG39on4O8m
         umMnt+zD/P+uKSlosWzrs5Q3hiiNJ1GrrN0YvX2WYPv08pfgIqKJnTmEIeD7+O5AECK0
         q3ZgwzIToUz5sly5D7x/huS9A+73t0mMlILoguIKMQD+7gI8I8xtC9GpjKCIOd3fO6yD
         7Pf/C6pBoaZWFYDBltrPJdIO1YfxSNREsB0xZdA365OldNiIEEAEcI5pTDjOcA9UB24b
         E85sEJMcFn98hge0DzAbCbZXnmbBMSJrlowuHw6IYIlAf2p1VdjfDt6ELQGDsnJ2VBZf
         JImQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A6pGsktlBQ5QmHb7ucHJtEWa4EMBUusAW9zHN8nzqx0=;
        fh=2PIvr7STEt6saLOt8dPjAzAxrHYEI0hQ7ZYMTSCTewY=;
        b=NNt3IkoEJ4czfRyU5eY0nufbdsoiWprO+5wGYBrdLhO4pgsMEgyvlorsdF9qX+neJS
         HoiEQeutRghWLtZcWOg1JmEIz0+LpwWFTe+oNjroUsXfUrw4MIrR5rPJb3VlbXRYT+U0
         VcI9PH3rPKh2VqEQJhY5coin7kgLQCtL9oXZGkWR/Z3ry0LaCNlGr2+ihTyPFQ7Qv0lz
         5cC4Q1o6GJpYyaVYO3KlNy4+3A9o9XfO/8We24lB09bN7mCdKe6VlTs7VgDk/5mzE8YG
         ODc1YaB8aKyVsJzelCt3fV0tF7quV/Eob1J67wBG8Br7QjQnRk6nn9pcX4cQbcZsGpBH
         J1Aw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784799238; x=1785404038; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A6pGsktlBQ5QmHb7ucHJtEWa4EMBUusAW9zHN8nzqx0=;
        b=B5c6bp7+X7OdpiE6AxUBxdoXeVHOJBQBocJ+1BwjTEyCapJpCnK5w/gf4Odmi0TqDs
         TJBJ+U94LcmGB6PXSdjgT7GLroLwc4qpmrc+D1jV0L+bAp2FIrFC6X4xYigugQbgQ/zz
         zy8A+S46gWFjtN5bLkqzRVDfz80gldswJav70shl3cf+jeSUqhmdQqdUHHwSP9LgSRLV
         0PIy4vlNBfdoR4mo+XpZNMpK7+dRXAkJtBziMLQIsqagEK6wnK1HDtCpRXLoCBsFnt0U
         oT2HdHru7jCB49xY+dImU6zgJ5SMg49dwl+MkZjl+uvBS4Ht4yqf9wt8kPAM0BsY/tJB
         rnZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784799238; x=1785404038;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A6pGsktlBQ5QmHb7ucHJtEWa4EMBUusAW9zHN8nzqx0=;
        b=N8giSPwPr7iVEy2qFfu9+PbN59YB1SHwjsPTk+vMzNzrBKPc1y6exWbl/7FFG9CjGk
         AVSGRiyDQ5DFetJ1u9kurQjEtdFqgGOIE71LRv4FVzkBiVpbFG5xyQyTfirGnINd2bl5
         297svD9Uc/YzFpHCkYEEOilfDsGAVZbeD01s3v5vtstuFyM8CYbciNAqCo8itj5MVapv
         HCnnIuI/Sp8WVmD4qhNtU5oSpCN/59VPlEozDXnY61dUo0nPoApfuQD3UWE6sSrMSYmv
         lz8rKV8WeAYqB1zpdo/c5FzXo/lz8qzdQ+Cyal+MzQoM1nfpnTYh+/vJD/G4bAHRExQ5
         cdvg==
X-Forwarded-Encrypted: i=1; AHgh+RoGWjXJ9ezh4qfyT6Lw0+GVci3HVEDGPA828FhkhP9ujgfvC6GG6R1JII9msgLoG4nINyODQJ9+@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/pUdxjDprYptT1X7v7eF0YfCqjyKxhw/cIL/Kd7OupNqixEUP
	zmbx2tw/SrTC2CzckOsPymyhljAowSoDNXGo9QtiLfG/MgIMkLvPUPzjAGsr6RSUSzBC9c+a1Tr
	G8fiTlCZxEfe1SlAiZP3YEn2wQRP04tQ=
X-Gm-Gg: AR+sD12Q0L6orC8JxWeA9IVMT2FVk8juCvMWcy0F2Pp2cnPQJParcuGyFOJbEd10PgS
	x0/iCZ2pJ8LeFYRFiGnKgQ2Y43WMhr+uHy2tdNYWOQNZT/vAGU6FZxNeyGjh72PTgnllk+gdovb
	aCPZv8EmLdIzk3Sk8cxw8bzjWnMj1e8FK6xy1CiDAlteYx7ImfTjlLh40uEWzR7HhWYW5RSnG46
	5wr3ml6KNGNDBJqsUriBtsOgZvd3mLvzWQ9N7jyqzpZdZHyPVyUPo0b1zAHoQ==
X-Received: by 2002:a05:690c:6187:b0:81e:b2d1:e3f5 with SMTP id
 00721157ae682-81f4c2daf48mr6691777b3.51.1784799238005; Thu, 23 Jul 2026
 02:33:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260722143258.264584003@linuxfoundation.org> <88255dcb-acac-4a74-a086-b686aaf15eca@web.de>
 <2026072333-creed-overbite-b2a9@gregkh>
In-Reply-To: <2026072333-creed-overbite-b2a9@gregkh>
From: =?UTF-8?B?VG9tw6HFoSBHbG96YXI=?= <tglozar@gmail.com>
Date: Thu, 23 Jul 2026 11:33:46 +0200
X-Gm-Features: AUfX_mw4RSJwhEaYdWWTmVo28OC60dIXrfiSaGtxUXk-C_Nwj5ZxbMfl8z0vj34
Message-ID: <CAHtyXDeQ5UBrZ7xB+AyTGzHgwc6Ozjo7nxrV_3kCzi84Wb2wDw@mail.gmail.com>
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Frank Scheiner <frank.scheiner@web.de>, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com, cc@epic-linux.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=C4=8Dt 23. 7. 2026 v 11:27 odes=C3=ADlatel Greg Kroah-Hartman
<gregkh@linuxfoundation.org> napsal:
> >
> > Can this be included for linux-6.6.y, so it continues to build for
> > ia64 as is?
>
> Sure, I'll queue it up.  Does anyone still actually use ia64 anymore?  I
> thought those systems were long dead.
>
> thanks,
>
> greg k-h

I have been doing various experiments with the architecture in the
past 5 years, and co-maintaining an out-of-tree patchset for the past
3 years. This patch also originally comes from there [1] - that's why
it has my signoff, too.

[1] https://github.com/linux-ia64/linux-ia64/commit/a4085ca68e49f49f962ddff=
46a901ff3468574b8

Tomas
