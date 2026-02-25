Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5793F3D902B
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 17:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772039270; cv=pass; b=sRCFw1amv97idtD4Qk13swMs8TPKUXPgjfL/o/ylxJSuW+bT0xlLZuqxELR5HKDMiNVbj198pkEw4RQBLsdYhQmMFKQjgi9hV2bxfvMyXWYMwG60UJJycFL14vBvg/sWt4Td8Nc3txtn3U9qQnU1s+N5Q/k5I+Y+w9hci/VNALI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772039270; c=relaxed/simple;
	bh=BHt6OhKSRIG7K0eCwlhqf9/pM6TuVhjVuDYDu9/5bnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aXnDVAhuZ/nkpu7ws+i5lqc+Q9CW9ATt3ba+rKydVA0/9mFpdhgDxYDc/o5GMQPvSdfToQNWH4ZE+p3/H7Ib8Jkq3sMK1m08rXmQ6/Q63SGP8NjJq5luvh/9f5MtXKDs0LeuGKLRNDMg9vRSSw9ffjHbXjNE3FeyT9eBrB7VFKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=xC9Z4gdd; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="xC9Z4gdd"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b8869cd7bb1so1134251766b.1
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 09:07:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772039268; cv=none;
        d=google.com; s=arc-20240605;
        b=FbA53QyA/1d3aRhAm6EkFCTokL6Qih1kbicVDMaz+j0pkicgTaseKpe0sC1v9Pq+aD
         7NQT0/FhnJWYMjXciOXG2lxTkJFLz1yZte2t8oYANtJ4jsW132UvVIwOrn/SwVrT8q4c
         tf2Yg3IUUfAVmqK8TYLTOFwyZ6WyeX72MTabJAbgteU8oEVcJnAEBcwrOXMbvyUyDORC
         Bn9gtVXa9YnUdCzSow8Z4nIYfeJxCsAaoFhxOczJNaTWXhFJ48TG+9HXxZ43ar8CNKeN
         f4T6rLXIPcYn56A+FqVLU+TGSy+ymIb9Lp9yssa752u0r0Uxf1rcuKZlieijc36yp7H+
         p/BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=0mMGJPyNubjSi/gW1GVHGktA2Q5Zc/kPJnBbOwa9/Vs=;
        fh=0RzUex0KSWXcSsoY3Gb/VCfM3vSDCUcowNGYJobCaKc=;
        b=Ddp8mabn7IP9xnbazxFH+j1mKZMZRTRY8GjS1+ONBbvHkNkBgg0tRsEbMx055j3nUY
         ZDEKg8NGXp12+P/z5wFBKt+RjyT/uCcmSvjoR3lKILVq5oV5uC0Q2VvZCURJwEFW6tsf
         QuE5t1J1nkxwiwACh59LuASENS6CIZ4KydA8P7AGDS5/TzszBhUG+nRofUVy1FJgg/9O
         G3BgIW5mm9geT+PLvPTioVEqlsQAkPdGro5m/ZXoIOnsnwvJEJNsla6IuIYHklNCs5SJ
         VJaNjd9CtIODpihBM1G4E3tdYxl+F65FVELvUsEtwvKk7J1qSwRLJfbjmWhr8wFzCk74
         PrPg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1772039268; x=1772644068; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0mMGJPyNubjSi/gW1GVHGktA2Q5Zc/kPJnBbOwa9/Vs=;
        b=xC9Z4gddxvfAWYQLfhvRv5VC4JvKskSTBIpxxYq+Lr/RRtJAeVFuC54KLmKPQmqzHH
         qZbRPI7MfNWMD0CM3hQdtJpwEj92lY2UuMCcaUlod/fk7O2j3tnBJwZFmimbzrLpB3dc
         ILpuZnfja8t96gRQEOxsiY8vyuoosHTxMRK39n33eV4vnq6S7b/x4wW1wpaYtZ8hx7sx
         pgJmOj6gc16E0tDmK/rxRzqE/hS5Zr4mlvxptDWBsEFzbQ9XqHYiLSsc8xPqYK+qhpZ5
         J3wI2tdqxMzzSc49X8lnISawaALvmpzPnUYEEXJvFziyJfVD9j3Lodg7x+xFqRikX5EU
         HZWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772039268; x=1772644068;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0mMGJPyNubjSi/gW1GVHGktA2Q5Zc/kPJnBbOwa9/Vs=;
        b=ASJokljXJSaIYjlhAhWK82ZU8BRgm9+fZTLPUsCOZNBFhCq29ERhdvbTi0gw4TEY3a
         p4rtkDvTpLvW9GkaT31WJRtfsnrzdsSW3e0achsV0wq+jq7abuaqCyuKVI4MIrYQRJmk
         p/ryMugv7Kq4b/62pYU9OXopFCK2LGOhC6Bz61VmQt8xzkgxhj09ckivPGn/C97pmeFa
         IpGqaX3KWwhPsYoNHnvkb84b6VdSzj1uRHUKaw2E43IiYik2HE5t3mmswNgvaHRVyZ/q
         L59XTe1mKSkDdBqo8tlfz/LJERREhzzDZWuNjvzvXq/Iv3OXbeGVYBvxb1z6XGkErrnT
         rNKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOLj5jBT1VKljMp0DPeMTZmJJzo732dCNdC4qzQsNvzVDvfAK2xynIHF5nQpaXtCVr/e5gEYUj@lists.linux.dev
X-Gm-Message-State: AOJu0YxnHJosNX9zdv5wXFqpZwLlnt8K2dPLMOIxjNTOzOKM+hgNwBK8
	zRy3E/Lez3YwId90fXrHm29a716yxk/Qmd/5mY7zyD9HugS0KPy/KDSzMqJlXPYvjUZbUPgsuwz
	58h0hjmV2UGwc+bQnwfzBqDE2CbhcXum63FBoJuVyJQ==
X-Gm-Gg: ATEYQzwW6d+fS+tYzczG64PQVevvM3oeZUZ9vJ7rG8LkzXa+uhnKBHRNhnCHyC2YinD
	kh+chi5USsQ4NEob/heFdaOxDF7SqD3S+q4EmGfcRN5riVJbrVzAFbYczeBQSI0qmryU+Jf9RJi
	/btYm1bFrJ2NAP8UejbbXQd9qyLfiUWdLWPaeKK5ygEZQG06NOC/fUjr2eV2B/VVTxAqIKvMiu9
	wpKMaUJKpUurZMYOtir6EZFGNGeQAJPDO0s1xJI2LblavyyXZ7pr95sb7pnavCgoc+cqDELmIT0
	LCYzp90kx3aTS3D4JyG9q2CTRdBHzggacUZhVh4eqFSHUA8vQS06markbSvRhRU0mdbmXjc=
X-Received: by 2002:a17:907:db03:b0:b8f:f6c5:3f3f with SMTP id
 a640c23a62f3a-b935172f984mr63678366b.28.1772039267527; Wed, 25 Feb 2026
 09:07:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260225151847.709818960@linuxfoundation.org>
In-Reply-To: <20260225151847.709818960@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 25 Feb 2026 22:37:10 +0530
X-Gm-Features: AaiRm50gCERmHyy5gDJze0xWRxS2ihcgUJwcE5zXm4dDX0vxgKBXxMTZRU4-MwE
Message-ID: <CAG=yYwm8kPbrbFExgW43q9NNv3jzBMF9OtdpT+S7k+DD5eOc_w@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc2 review
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

Compiled and booted  6.18.14-rc2+
No new typical dmesg regressions
.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology-
