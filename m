Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53474A9D4D
	for <patches@lists.linux.dev>; Fri, 18 Sep 2026 08:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789719408; cv=pass; b=DMa+AjEUmJgt18n8cSqy9+/mMT3YeA5JyaWJVlQYUcetILAKsnnblK7cxiczWDEva/TmDxjH/IbKFaDpNGdj+jriwuE2IdBIDKObh0gzZjujtywmtb0RaKksh7nvmxoyKUfYyUm+Z9rGZjQLSWSmslYeNwxim47RZtR7Ehdl+Us=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789719408; c=relaxed/simple;
	bh=TNDOvls3vgiRBkknnAdh3h0dArjFRoCxPy7si575vY4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kdik2J5PYmIKJlbDru6Eg1ZZaFReyGNqWKdvHNwtRCNs9ZeR6N3MVTagzAvAsG9HvroidF8IJ/MyGnWjDMRhWuPE/yasUTn94G8nXiXwINsF6c9NPpS/8MY4dg3mxdbzZXxKu6Y5RdxSmd3sCCeG7RrG6OzHos+nHuUF1zxfPuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b=XSZtcLTR; arc=pass smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b="XSZtcLTR"
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2a1f611461so13784266b.1
        for <patches@lists.linux.dev>; Fri, 18 Sep 2026 01:16:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789719400; cv=none;
        d=google.com; s=arc-20260327;
        b=VK+SeJ/vC+0mvdOT8mSSToE3x63Y3OsKaZw4ahZ8IaDzTu7gZWpXTXwbyOmDQZARGK
         bGvhNZooD2ASgzOFj2r4iZ15qMRFZ2rA0gcPRg4etnLgNttxs11ky6rE43Ze3vw36oig
         s9wF606kpGh7rpwSwcUWoWguSRhzfq4XTIVZjbjEEDsnWJ7sMhNEYo4nANO6KG+Alabh
         VPdfPF/spnSTgbftLOlVwFpNizW2Jsi74ha4RRon4q4ceyk5Irhpnjj/kEhex+iN+VYj
         5A8Hojkw3/s0WvaUotOhqXB25O05UlC868X4YF9/zvzqm31R6yL7vv0vbbepBn9hxd3Z
         lBdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QK2RniNBtO2vqqVkyo1sh54+0yZPIP2ozVhRKL6eWs4=;
        fh=u36Hlx7HDqtldxJb+EP4nWQCXzffP7312UQEAMgXScM=;
        b=b3fxFVndQGL+Yx/rs9i+Shq0Hd3BJNtzLI9W/ITm/94Nh9rOTnq8PE1/WTVm6YMqeT
         dmsQ7ukYzJJ5IexEhkvc3HOPvtAgRqwPQe4oS7cvOmkf7RV6bxtp2XrbfuZpABZ7/ugZ
         Ua4nC1O3ZqR3TCIPGo0hv7jRh3mGQkkU1K0BtGhs7U1Z7BTkpHelxlyTmV3ul389xvGo
         NsutdN3YFgNYeH2IqVdS1ilnH503vpeCmSKtWroe2hjb81FhQaLDNe0p0DRKJ8b99RmO
         1ABh6mmLDpJjnp9wZk2slNJM2e9J+fedCUEm30OyGYuCYZ17Moz69jsTuOR7O8N1t89Q
         aXVg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20251104.gappssmtp.com; s=20251104; t=1789719400; x=1790324200; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QK2RniNBtO2vqqVkyo1sh54+0yZPIP2ozVhRKL6eWs4=;
        b=XSZtcLTRpRgXcc/gEfpxZopToDmJXReCoy0F/zQ4ROXOOokc9Sf2m94DsyJC0TpHOG
         WjiahpHssVxIhbNZgAGJLSsKZ2kgTZ2CiMRzAEsXV8vnzjTdTa7lD7kErS1Qp4wClmLB
         4rJDjMz5zRa7o1BgrFR9BNObISE3lT10bwsMRmnnSAFvUrfAoFH7NmuJYRBYcPLIoCGQ
         YzSulK5cJN/bvScSh+ndSVeuULrgt7KKa8CJpVJvrlwKG9Rxarjs5q26IAlFJacRjdPI
         646uhSuueZWhQFtXfouw44z6C6gwgJOQ4sZ7iZeHj8KfZHkfTC7m7mdxZnkBbua5HxWN
         rdPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789719400; x=1790324200;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QK2RniNBtO2vqqVkyo1sh54+0yZPIP2ozVhRKL6eWs4=;
        b=TsCYwdnP+jwcQY0GgdDdPwOrnA+n+GSwNcQh92ja14RUnPFoCzXi84ggq2yZojQ6GX
         3gWzjI9ULDBYYAsagqQaqaKGPcHvDb20nEL17w5kPiP/jDeKWfV3pb7r+lBSsPG9JFz2
         /CvCsYblyQfpBTpq6W0SlZwfsFrasvlofgpi12q6/U3w2DQq6rasKpivukQPh3K2IuR/
         yeUaAZKPutSreViz33rq0KY2tljRVMQOYDHT/mT/Wr0g+q7IX6y6Yb35ZXXF3pzOkEoW
         SpnW72md8UxNxkxkrxU45u9Zhorp7uqAq3QmfOWQa/+OEKIXUjteMw4hdndLhWHQoF+u
         XskA==
X-Forwarded-Encrypted: i=1; AKwUvBwKDrn9McX0vPJwgB1CxO+Ka/k3obE6lwsas9nZgESTdj3atVZS1sqCf9KfNHtXMkGENOzGkNzl@lists.linux.dev
X-Gm-Message-State: AFuF++kn6HDf3uc2RlwlJafUD7VN69ugI8zuei9LRYRfyoZYyTMTqa0P
	C7LprDcExPFMFS5xDjDGuDz59PMnjzipeZobY2jT48UCmN8wcM3/kHSJQ3Ujcqcy2WbSQvLlGzG
	yapDs7RwSGhV8JeOa2KyVI5fqgAh9W3Hj/gzzKKD81g==
X-Gm-Gg: AYBFou2rriFrTaVeH8UhNjD6lst/wJRIYTm9WZ3FdyFTD2aO1kpnNG2jcbw2BnryJfm
	gewoXLfIrsYtzGfVqT98ws2W7oVwHj56NAx918Cxcs10wm6JRcjru4EejlUMepRIHI/5pc7+4Pq
	UFco3KO8mjVo9LZ7Eow2MuyGBkz46e4ilWQVApFYKGvt4nz722BjmD5eHPlcXL5dY29Y3C1EV+O
	2Cl6Ky5662Hlph94IUHZdT43tzyvboWFwzSZHzcr7Gf4uR9uMjJyZM9Deff26JxafQiVjHLhNuv
	g6HPq3g4XIB4AhVZ1LofQotRGMpSdHSncnvCwXIZsHfGXGjYqSlRQDXgjSkdMFYD8AtFbo6Jm7/
	RMazVJOh++gV2oBeQtiUDAezvw4eYUiKRJfwNpaGrUyXm70GN1MA6+xTW58Vc4t94wcrHYnvnCt
	vx6kQqUFxAR1onxXLHvrLD0w==
X-Received: by 2002:a17:907:1c94:b0:c25:f7db:4be9 with SMTP id
 a640c23a62f3a-c2a16555e01mr184141366b.15.1789719399510; Fri, 18 Sep 2026
 01:16:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260917151350.597953846@linuxfoundation.org>
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Fri, 18 Sep 2026 13:46:01 +0530
X-Gm-Features: AcwNN1XZmitjPyByb4HhRsoztvZ-v5CbuVYZ54pDo3GeAR4HAdHrMWruHo8HW08
Message-ID: <CAG=yYwmjqJ6jBZb0UJPbcxTyv=eFs_GmNmu0sNR9Vbm0FAx=qg@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/733] 7.2.7-rc1 review
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

 Compiled and booted  7.2.7-rc1 (using qemu-system-x86_64)

No new typical dmesg regressions .

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
