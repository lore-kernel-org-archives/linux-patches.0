Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08184386C3A
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 08:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772526086; cv=none; b=O9v2iihyWenb4K51qHkSht3GQ+Jya506tDg18gXQSysg5ma2eEvAsnjF/TQYRrbdYMyxQ4FAzqT1OHs+RhcRYJcpJHeCJfUNXts1dDtHs1aYyP12uVMz/c3tNYT9eeNyp6u5woUSFDBWXGKLjFAVtWO65bnzRNeEYhRspoPYFhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772526086; c=relaxed/simple;
	bh=HMjix7nn+rlLHJ+Xqy2CBH+I9ChBHp1MJ/cHxYoi9Ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQS8EzNl4Tkrcnb8mCk5SnZMe3w4IoQtrU7cgxSPciMIZFpCj29Vc9LnB25dN8eKytvah4dgLz9nCi1MWhaDnd2hK5DzF53rUS/ITncWP2GkHgZzDQo4SXs1vm8j1R7T+VEgn4mi+dlS/0Mq9FprntHw45uxopSm0cDQAQ4RB9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NNfnlMcj; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NNfnlMcj"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48378136adcso31541395e9.1
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 00:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772526081; x=1773130881; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B7saHVIBjA9v1GsKN8+JTVIr11TDoV8ZDa1PdETlNag=;
        b=NNfnlMcjTzV4tRE8LvcBNjVWWUmb5vwYRO079/M5jBlFTjJ9GApYsVp/yWTLsa+dwj
         tnG1fcFR2FXXibq7yv/gQL4hcRGH/SwzjU7DEFW4z9ruoG9t7cP48GvF6fPMjJ2Rco3H
         qBb9/hzCAXLfk3kwDkiab0idYSrYp4y9QcKI9++5iidy/GHK0pTPM643p7tFS9MNMhLj
         djOarroccRMa83JlhFVg5nBtxf//j1nG6s4QzEjSF1LNyNucCJ4CETq5bFfwRbxY9xip
         1vW0RqlBdRLpUeZmOIBxQaSkVRkFUmgjtYyAqI7nFLaCSQ8Ev1npchcQOhWr6l6UIwyU
         GwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772526081; x=1773130881;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B7saHVIBjA9v1GsKN8+JTVIr11TDoV8ZDa1PdETlNag=;
        b=cSJ0OvCA3k89fVrntCSH8pvKsWhjENuX1XBvBRIu/hE33CtH1H2II2P2vOnapa0apN
         3Gv9f1wTLI9lhH0PfojaFyXGcScWEUH3UZj4iwpddMghvOGizOqyw4AQn/CGGA5CSXPU
         ybdvnkH/6OEwzTlk1rzVKWu9lpDewOQ+53pW0Iguj7iYfwpxPkAztSG48ZOyFuiWBSzK
         wlgkein2R3iHedMG/gFWvg5diwn2j8UigunVGR/8jMv0Qs5kH/L1pUIeSKMAk1fAa+az
         nTn0rLlhuAs9Q8n/nvXmL1Jze/yy2oJyWyiBTe24o1S5db9/b1DAyAiopHYi/4h7FDoW
         2lEw==
X-Forwarded-Encrypted: i=1; AJvYcCUvKcJf84VZ50YvfixulmhqS+nGTgflRENIQm3Bvxo//nKm0WBmGop/nygp4/npe9PtW1YnW/FK@lists.linux.dev
X-Gm-Message-State: AOJu0YxCdBG0UKInHPzGPrnq7hBIxU1UqVHclh3cqdPaacoX2yAh8zzK
	djLgOE0X44Da7CRG/2k9XLgy4uWHzwk6cB7hVaDinajS2TkayHCmohN5dxJPUsOqxjA=
X-Gm-Gg: ATEYQzwQbOhh9dMkdQqhgQKPujHJwnXyFOEeHhnAoaxqvQIW2+9wh1PutLVkFMlYLzQ
	iBluyNLS2dZXaMAH7NX9bWXlQELONv9e1bW4tiBF87aeA+/x0QKKsXTli00e/7Ta3/gu45K5Vr/
	zt5Lcu1S/5PsiTnja5DS11pxPMegtkiu7NmuBQfvKIiDvzFWSRmI8Vuxv6BzBjy3xtg1LCwwmjK
	O/Whx4B/ZRwRZPHRIvwO6QenKvEq8+BmWVwA4Od9NkLB8k5C3T5671QbAUfjF2G04SLKTsYgGVa
	S50rt9eZZAgwufeUiBaVD+32a9mWKFdWrYKNqpDLx/CHt/xCQeIKds27ZkXwhUPhdBtM0tNKUOk
	ygac1l3YsbspnaFBEkBMSPiFg0mSb6nvu1W8JrUC0ueEaz5JHbcYv5eWYgha4uGMlxBijKWq+j4
	gX28KpE2EVFXeoWKMbf9s=
X-Received: by 2002:a05:600c:621b:b0:477:9b35:3e49 with SMTP id 5b1f17b1804b1-483c9bb1e1fmr246792445e9.3.1772526081319;
        Tue, 03 Mar 2026 00:21:21 -0800 (PST)
Received: from u94a ([2401:e180:88b0:32b4:4c71:af95:b813:9623])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a01054dsm19898230b3a.43.2026.03.03.00.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 00:21:20 -0800 (PST)
Date: Tue, 3 Mar 2026 16:21:13 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/757] 6.18.16-rc2 review
Message-ID: <qarpj22ywzvj7pwqz4xgey5nyi3adxv2q644xsbbipnziqlt3z@wwovneujmibe>
References: <20260302160853.2519610-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302160853.2519610-1-sashal@kernel.org>

On Mon, Mar 02, 2026 at 11:08:53AM -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.18.16 release.
> There are 757 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:08:47 PM UTC 2026.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/22590800040/job/65447954911

[...]
