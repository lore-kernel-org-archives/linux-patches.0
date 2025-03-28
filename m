Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB161B4257
	for <patches@lists.linux.dev>; Fri, 28 Mar 2025 14:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743172979; cv=none; b=QQ+g1+M4TTfSZtp1uzJWVaD8acXI0unRAc45YtVDCzODtSq0dMw+wW1FC4Hq1jcfOPVVb9TzQmB8GmxryC9n81qxFySelCV3M94tdKUH3lZY8xnrRcg2BJHAyid+sy78P2/gkCBxuGhWRHFmMvewDU8UdcjELwQpjyC+TXXVoSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743172979; c=relaxed/simple;
	bh=tjAIKgTzm6/MGyLQfjiuIHOp0fmSUV2cxbEbpn84D6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MU41DTowYV73MNsrvmEMG7Ov+RN+CNGB4v1xpjjT+R7CYcQlxTeM96F2+s3vNz9rVaDg8KpJETo8xG+ynLUz922d9C7q6+FauQ3uh1iqVlG3D772q+30sfMvjWyEMXLGkqivrSTjfkN9jqIFPzKow2Ol05xl47DfHJXNTSh++4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GWnAu7jM; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GWnAu7jM"
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-86cce5dac90so1020262241.0
        for <patches@lists.linux.dev>; Fri, 28 Mar 2025 07:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743172976; x=1743777776; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d6ToKzHT6TF8RQ5+cmvhkhRs8kpZAnpcNS44iZJDBN4=;
        b=GWnAu7jMCEb+Nfi29lw417rfOrEorn68TkWqeVTTn7M4u3LXy/Pg1RY7mBFk5EKTAv
         uxFJljlqVXGfX0zN7jayYsFE3WAgjCN8vORFQayvwnjycm+0+lrYMy5fR6JKdGs1ZkOd
         65h+iurPRpmQfuzcKLkUwgUe3A0WyIHPJnME9oUdO9HjPexFFThNoTp0j2+oKgARdqZV
         TXfh7GqESZqIntVjp4JXCCczfsP3IyHQutjGj3vEs+bcI1cVXYX7Gw5H0WaDAi5yrD0E
         c71XDrQdTFRAG+Nck6xTTKqE1VNSklgRHy9x1YBZ0p2cQYKC13FSHgaP8lcmA+BxAt9q
         MX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743172976; x=1743777776;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d6ToKzHT6TF8RQ5+cmvhkhRs8kpZAnpcNS44iZJDBN4=;
        b=aRp8sgB8l0jpPHeQkg9GoCFaLk/GStGG31BJwvx9MlRUPX5mniJ33wcluBsW1b+zkj
         u7/qqwURcugs9hnsqTKQ22haI/RCuS+9rP9nQVXneeEdXd193STYQGWGIEMa80VD6gfs
         9NH+3bDTFiQss+z0j4+wTleYNLpLhBrsuz5mRh6s9LqTO0QCaQFMRsvt76tdZJHOfUox
         PxmkSd58kxVaPOOotDtDqd1evyo2uz4n2yHRxzMQvkeIWJD8ka77FE63w7I61L3+meTy
         sdqnTCbD20vsZIkukUaw3Na7bg8SxKUPBEB0kBt9pRvOqs/fsoOyImGfYe/eH0bm5u95
         l91w==
X-Forwarded-Encrypted: i=1; AJvYcCWdKN6j2izAA1FJNOaWAcgCTVJibtuO3kQcOXUkIeZHb1y1J3yfv1ufTBYJWIixU3t8sX8coSzo@lists.linux.dev
X-Gm-Message-State: AOJu0YwUWEcZM4ksiRjZhMO7i00AJPYxSH6s0R1cHotbXzq7+j2hBGfX
	D3BFjcP6MsP/O/wge2/jF18FE+qcqL00A28PeJPbkvwIPtEB4W9VhDJl+T9bSmJQVMa4pJHNSru
	TDkZYBtydXTfZLSQYsId9TSjLvBt3U5OOoUqu+w==
X-Gm-Gg: ASbGncu/3FzO/euhu4lhQJlG04h961C5xc1DRWl9r0eUVG7A3G7RIPrBT7zTx0twwuX
	pXnL886zite7L/XrEnyWEO9XebsvyH1FQKUZNku20hIhoqHIY/zF12Cs5d5lm6bmCREoSHokdE7
	Phe//eGkcAHnTTDKCogoho1ACoeN4yxBFtgEysUSNgIHrwaLoyVxbvA4I8xA==
X-Google-Smtp-Source: AGHT+IF4Hqd0y6tvOBG1L9437crSiShcfp+ae/DQ2Kz7JAQEC4Ms9UYLukhP4MfVCN7OnazqSSf3NmzN1q87oneOTuk=
X-Received: by 2002:a05:6102:149b:b0:4b9:bc52:e050 with SMTP id
 ada2fe7eead31-4c586f1e376mr9399814137.2.1743172976411; Fri, 28 Mar 2025
 07:42:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250326154346.820929475@linuxfoundation.org> <CA+G9fYuY7iX+3=Yn77JjgiDiZAZNcpe0cW-y_M3sazhFN7dGLw@mail.gmail.com>
In-Reply-To: <CA+G9fYuY7iX+3=Yn77JjgiDiZAZNcpe0cW-y_M3sazhFN7dGLw@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 28 Mar 2025 20:12:45 +0530
X-Gm-Features: AQ5f1Jrr3okkYsKcySxu_-gULq0rRUbR8tw6Cwpyo_vJOfJMTAWnBOuVF6pmc6E
Message-ID: <CA+G9fYtdg6OopeUQWkVmW9CYoprtqzWVTQfaoaY1vUtXKEXD2Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/76] 6.6.85-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Cgroups <cgroups@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 28 Mar 2025 at 17:14, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Wed, 26 Mar 2025 at 21:16, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.6.85 release.
> > There are 76 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 28 Mar 2025 15:43:33 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.85-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Regressions on arm64 devices cpu hotplug tests failed with gcc-13 and
> clang-20 the stable-rc 6.6.85-rc2
>
> These regressions are the same as stable-rc 6.1 cpu hotplug regressions.
>
> First seen on the 6.6.85-rc2
> Good: v6.6.83
> Bad: 6.6.85-rc2

I have reverted this patch and confirms that reported regressions fixed,
  memcg: drain obj stock on cpu hotplug teardown
  commit 9f01b4954490d4ccdbcc2b9be34a9921ceee9cbb upstream.

-  Naresh
