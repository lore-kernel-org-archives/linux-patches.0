Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D90E242D70
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 05:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774328990; cv=pass; b=PP0m3gAZKmLErQQryp3O0XBM81ipalct5YPquAD/GZChrClqlspfjnkeswlnbbMLDYk+h8BADDheGSzbQE/MsM6sJMqLtq8gWU6oqDPXJ4YEqTQj/faWhYUWTixMLYgZp8e0jULNMWcSpfQ9rCWKHgS4RIOfkzGvVumlm4zhWVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774328990; c=relaxed/simple;
	bh=IfqcTmHDAWE8rS1BtGDDkbjcR8fgsXNjMuHL1a4N0zA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hez8IKZPuRTaXkQChBUOw+vfK2vY78Dy3s8yYUt7nMbl4JZLzj11xrquez8Z6e0dfpErik+o6sAfMxjDioKQrWIcSbcBeKi6B5BiYOHY16e+dzmp6n0Vik2rTMOXrmXvAsRkdkbdC12KWhDTNhgED46/SeYugYEl8TpH73Bd9oE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=sW32dyMR; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="sW32dyMR"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-668e8df29b5so985443a12.2
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 22:09:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774328987; cv=none;
        d=google.com; s=arc-20240605;
        b=iPlSIVHF/hwK2jAqmgZvEARDK5hjBSrjO/nrryYkq3RP86lgXvUkhXKHjGcVqAj4ab
         xPzU78f6EZFfu0p+ctiTbby/NtS+jYhGEaR+SIDaHT8GHuLcTwBvkI6/HhAn/VhnDVIe
         2KrCMVgVB8bthYIvU/wZ/MXLyKxljfDhvKFtKX7/7Vw6J9Eyjlq80zJJT1apQz+yHoa+
         esGO+iiufeo64aIiLwGw5fgOHydD8qsum9N8LgBacwwUV65H/AVpUTo320TPbcx/i/hk
         2LKElEl6HtDr+nA5BeF66mGxuvZhtgK5SlHIRubOv+zoq6UlHmdBcX759SMFjWSkZoDL
         ppKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=MI3TsyI/afRVwYVxFYP2teMBdppIdDJRMOYMsQlLkN0=;
        fh=mYBuchL9nNUykg+0pM6C5NTLiugcYDJ5M7fRFxhwBmM=;
        b=WjfdulxLAyxZI+DgnoNpoa/xgrV5zBJL26xSV1wzR4+IWmxANT3mcKzjqDjrmWcoEn
         MUOdDzjFM4l2tVYNB8VKl7aZdKzbt/E7Djj6ZJlKIxyxu8QO/61Z6v7RYmOEiTgxFq8G
         e7430BIg7gzVLfBlPK3QwFgfGSHLQFwwh66Qc52N5nZ/1tNnlGEu2g9S9sgCIy1jW9mk
         +lNqKZ/Ikz/L5MaHCC9HDvnqaTcxoUaWoK+fscQicGFYW65UZIubaBMj5WB27GGNKdVV
         OSRb6W2FdQxLx/U5Xz+9+rWBc2emXHk0GMjVDhxtWu46C0/csdH54XvPBpe6sDiAD9so
         pbQw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1774328987; x=1774933787; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MI3TsyI/afRVwYVxFYP2teMBdppIdDJRMOYMsQlLkN0=;
        b=sW32dyMRRx2SwTSX08pe18X3FGP14mJ4OQUnSCAQF5530WSpHHW8kaTEYEQLXO9m9/
         ZIAO9g0H+85ajkKijcMZHXy+RLV6uTXoIo7YC8tUBlrforHO82+Mh3dIh+n1vbawrylW
         JH+z5MCeEKgwuVMPUDZ96SG+3+HIv/bjHS+KDBPjiHUBtG0XhC8QetWOkPZGFvUgiawz
         B+opw5pLRKOPBVRSIlERndOItaQoMjzIFT4xh1yYLM2BdArPLvRdk8bGVWo/JC332hfR
         QCIWJh9pvusfG2DJlDCJEBWCFBerdHAr1wucpc7jy7uH+U6gNLg6epglzXP8fsL12dvD
         EkxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774328987; x=1774933787;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MI3TsyI/afRVwYVxFYP2teMBdppIdDJRMOYMsQlLkN0=;
        b=rDgu2vpMdV5PL0Xahx/1pIY9HBaWBHxv/PoXwg7KaRYaZPIpXlbZp3trMZr2DUGVte
         pyIkf5ETgjzCzjfJMPOYZp5oTFCpXZq8hGe17pe9xWuszhBHGsjebqchLoEvQG++IP20
         JlnHBzSgD67K1VDVi+tiHkIxYS5kKNXneATPqyDmEekfoy0Nkyf4RRgfldIoTEjNz3HO
         hQtZ7iCLfV1bF4Hd6CSCV5dkze73TX74UYOQW4yL9irKLDxzHno314ThsQ1BBME/rokv
         84I7zKFxKqLLAmr5zmhR0o+z/4/20FnzSjP5PSbEUi4K0DBoAbqyNoUGnYdbXJN+CDoC
         +azg==
X-Forwarded-Encrypted: i=1; AJvYcCXYjQ22i5hpSlpilJM0hUi9amA89tYpunwlkn7B1leuS333Df/gvweAQJSQuHSbng3+I8iZSV8Y@lists.linux.dev
X-Gm-Message-State: AOJu0Yxa0sIDtbWoMv85GPyaK7Z02ypAEU0RceTS+ku2yMLi2HrJjT6/
	4Y1+FUtaw10L5b3mRVqVJbGbgR0CJDnzny4b4kvZrGS7uqZSJSdVZzyvs0Oiq1ec5L245UTyuRD
	hDg6sQd3JL1+ck+XzRLkoLDpoO+Zjgfdh9oDjncsR+A==
X-Gm-Gg: ATEYQzyTAdtSYjX3+c7jbaz6Xb478pkZMrNjLZmLkL3NOkE5KgdGfmPt3vCo1jgzig5
	FOTJQjhKOMMU1DfJSDWk5QK2667bJZZ8sd3ALvlGNoaGsz2HB+v6Z6vTr16lffeTFHZw2yP5fH7
	tuenLqL+CYHiZPSw7PYAliObb9T0YozNzj4o2LSAj1GucpUloTjldop/dLdp594Pk92S/SSOaSn
	n30SYboOrVP2iKIYEManC+jGq1BJRDyf3MrMS62A3SBFbVDvgTnxGdklMmGdv1NgtwfG8e8puBc
	V4SrE8erDgX5QIgRSuVJ4wsQyWxpvaUrgmt929bdEYVwlQ5Dx5AoMH2IlmMO2xQIhsql0+8=
X-Received: by 2002:a17:907:3e1e:b0:b98:57ab:3c44 with SMTP id
 a640c23a62f3a-b9857ab3fa7mr543257366b.7.1774328987437; Mon, 23 Mar 2026
 22:09:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260323134503.770111826@linuxfoundation.org>
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Tue, 24 Mar 2026 10:39:10 +0530
X-Gm-Features: AaiRm51ycle4Dlzbyh1AtKW1eSsjfY-4H5rWphYFfb47-MTxxAPUDLCeC905FS8
Message-ID: <CAG=yYwmCMf3konCjMAL2rE6-q=CHHLtouV7C5aDPHnpKqKLUkw@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/212] 6.18.20-rc1 review
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

hello,

 Compiled and booted  6.18.20-rc1+
No new typical dmesg regressions
.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology-
