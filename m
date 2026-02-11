Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF1E366DAB
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 10:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770804549; cv=pass; b=n7l+3S/vWcRgkQXKHdJi+91tjq5knuIzLdHpvVkx1RTXyfVbTpyRbdyG6ORWLa7WrUu8kUQpvCCcqz+gZSnW76wWgyLUY033cH6S1e8q0DoSnO0cRi0VEfMa5X4h18fGwIy5FX/Elvz5qajjhVkEhnCPIm9mOoOkM3jwQXRSsJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770804549; c=relaxed/simple;
	bh=l1D8gw5i2W0/j8zDgRzT9uZ621ZVhzaysNHDR6kRh44=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DNesMlchzDnGZQ1UAchRFNcy7wNsmb8rTQrSh+Z7PSSYJkkaDID/U2Zu8bMJXAZPHoLK2kcJ0Ks6XjgWXFR5Ez9Q4D449VYRrkXBlFk3lUYNKWT58qOfMoRSBeZhKQ3rF5/BPsf/s9R6voGyGoApEzIzBlYw1WimQRhrlmsWwsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=kMZkmu6u; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="kMZkmu6u"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-65a36c8bcabso1514473a12.1
        for <patches@lists.linux.dev>; Wed, 11 Feb 2026 02:09:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770804547; cv=none;
        d=google.com; s=arc-20240605;
        b=Fqknf7/i7WgyBcrQvFY7KHwfixGoFaF2z6X4xaw/myxesHcYDzV9t75kDF9MZn/81w
         gzXcmOtTNYLpzouNCkLLRYclhud2Jee7VgmE4OEtSU2KF85I9CVuoPGcI6Kg388Y6sLl
         MJJ/A4mQYEk3g17WI90SZ7uFPAa0GsMSuaDN7GENDLe3B36vD6KjeU63h5UEIdI/bV6E
         uLT3XAbwarz8xlprGlQI19oyZQxdgbINjg9h8poqmT5Wcfe1DCR6/BsxsVODKZj9RnAV
         Pnh1sxpuDbZZD0+mbXuFGQr+TLOA4GyRaNOI/JywQxRF7WjPPkI3E0e0iRLvjzMwHm+a
         GyYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=pru2SUTXC3VPuTIPcsJbrEeU7VXtLClZTOl0vZZxfiY=;
        fh=3W6IS5SBUx15AvzX1L9q4kTD/cM8Mo3gxyg8sqvyGwo=;
        b=cgWkTDuGvZW7PSCelJcXwCu117WtjhEg/5y5abYHljMx+vrGkO8t0/negY3FpsyvII
         6Dz7YKXLrjms+F8qQ3jagHAWBH6yRWLCSTQyQ9aK8X8yAasBtcO4jgCIeXO+6ReFRy+S
         IGlpeEuBDA6HCbreEEWhAXzQKuvXW9LSMs479orljovUoftkF6GtYUZHGvFgVo1IWaq1
         +Mxgt2tiGVepB6JPZbmf/BJDlt6xppig6iXfZp0toZXrZi7cyPr8qOIjXgVEqJJwWRsE
         d/fo0tMXxNxnkblIpgp8FiNC8m9HTN2G8xqQUpLGspS/f73jAjY4NHeDVHkzhrdfxX1v
         xE7Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1770804547; x=1771409347; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pru2SUTXC3VPuTIPcsJbrEeU7VXtLClZTOl0vZZxfiY=;
        b=kMZkmu6um4S6779iiaaaXwXZ4N/acZ57ZMUt8by4Rq8GDF8vJ6AHV8NVZ7CQM129H0
         oKZScTZs6NBR5O8WECv2Y7mP6boOXsP/HpXB7I4DsQ2HyAEv5xgJCpk9dYmAaPIjVoDc
         Y1mTlvu53Zw7vX457vNXJB4NtCSbvII9rJ8X1nRiBFUVtgFnFvtPD2X1iwgPwJD9kGXw
         A65EMZn1S6MKouxA+/HyccqDTOinClE7vALMV73nlGmpBQfbblGl+iVV2rZ3Uso6/p7E
         Bps/AAmgjn428nvHeNb7UhGoZjmPVZsc8b4vE+ddBI3l5V4vH5fVu+ho0282dh0sO7+N
         J5Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770804547; x=1771409347;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pru2SUTXC3VPuTIPcsJbrEeU7VXtLClZTOl0vZZxfiY=;
        b=NFVsVcfTi1/GHaIo5J2GskuIbQMoCmJWnZp/y6t3dG2Mv1vWlHFjQGHVWqOtwQoyWY
         bMqD12v9r/29cRm1COXiOrmW4AOW/SliXnWxqkpqouWfw8LhKRhgUgGLRjEiId/NBKkF
         /QcHnzD51uH28aImKkUmh5AQ4sSzcrrLbm7/Y9g9uiTWyc2g4N9/5PjhAqOxEY/V7clj
         tFhKblTjAo4VqWqqdfExt3bV2Prb26r3UfHdBAEwb2RmGfLOHdulxh6nRJdB/m94X+PX
         UKIvnlH90zoXg0/pTyMMcCJN893m+JfRldjlNJX0wA/bpRoaWRvxhYIdGVD3uIbByF0K
         VBtg==
X-Forwarded-Encrypted: i=1; AJvYcCXrnsqNL6LzEub8LDngsArCG1JHe6AEWptMyHnMr5v7g566UcHJtf0r44XoElEWHui0ZAI1YBeX@lists.linux.dev
X-Gm-Message-State: AOJu0YwJYflsrPU/C1F1MjQbqI61Tr1PQVrdjQ2b8MfbGXMbwM4a03am
	AvtLhN8Za/RanXJ2OhkRbgJ46RHjhh2QorMMCKQsQlKUw2QAYY0TNFeG5rTkT+BIoscNmOvNBfw
	hXIJSeyLcX998QPj/aXRpGkvkIqx1yyNbxwL0jh0KuA==
X-Gm-Gg: AZuq6aJyV46ZmqHjcfV3Q8hAu00XCgjHFc3tfOZ9qF8Xjh8L4kteP+aqiiS0/eW5xSr
	2FwJtIyO5wy0+mbnZBmeRX+Qj9VatVhhGDkX85dEz2MoOuhtyMCXI4JtF4bD0Qe/TGSRnw21LmI
	5Hk52+ndnwV/FDbRcAWX6frTNASovFsBmhChnVD65j9IfFxWEp/+Z5m9WFktP68FflcfZdfIZq+
	ypybPYz0VhgtlQWdeMrnlOHPW/aaRGzfuv30lIZG8c2ohqGW6B7bDMq82PN9kBOeQNyKFM/Vrw5
	33woF3gD/9KWnX33tgDH5VdCBckG5SCjx7V4x+rat80lD4FNDVYdvKDnxWcxVesnS+f+zQ==
X-Received: by 2002:a17:907:1c83:b0:b8d:bf4d:7458 with SMTP id
 a640c23a62f3a-b8f715a7af8mr82185366b.24.1770804546772; Wed, 11 Feb 2026
 02:09:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260209142301.913348974@linuxfoundation.org>
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 11 Feb 2026 15:38:29 +0530
X-Gm-Features: AZwV_QiSl-YLGb3rIqTrwEAhC38cFxhqIeltHg-6NkIYrjTXQLV8imvIeyEw0RU
Message-ID: <CAG=yYwnY5cnTVpwNn3ECWSZdmSyayepkhSCZU8osg2kna1ihpA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/69] 6.1.163-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello ,

dmesg stuff...

-------------------------------error---------------------------------
$sudo dmesg -l err
[   11.536507] kfd kfd: amdgpu: GC IP 090100  not supported in kfd
$
-------------------------------error---------------------------------

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
