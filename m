Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CA933B6F8
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 06:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775025992; cv=none; b=TqzA5cG/ox3dq+/QvuMy9hVCuHY5hY5HkAT7YXYvEpC7Wn9kGJw8RkvS14/2alZcgDZTiqPg/mI69zlggwcVK/e84JfCzSuU5z5MdYCSPqhLrbxfG2Hqf4G1Qs0IsXxOE7E/z/BnQntQe5Xnf5NqJlvIwya6atbqs1wXpx0pUAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775025992; c=relaxed/simple;
	bh=xXzW+65AUtNVhFirsNyqNF1LErcC8Sn0eiTM3AesVx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gCurR4T+Nn74hCcZrp9ZZK9oaZidzXU3PTQYLaiAER7lGJbuadxX6wZRNzvizCArrjoieLeEVaAiZRSdy6JS8nYmFgYFCsdwYkZ8fGRIOC2G1WzTbmMRsq5l36wWhEeF62LoYZwovN7lj22myEdRFxxu9it8XNAqZKJEpu7BVLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EQT0rMN2; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EQT0rMN2"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-483487335c2so69008085e9.2
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 23:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775025989; x=1775630789; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m8lYhF7PdfMApbjhxZ68ZX7eTs6X6qz1n2+1EZqNXEk=;
        b=EQT0rMN2dTi6surfoVJB/hB7STHeKoKIj247lbkrmiBeJ/SSdxO6Ke1tBbvnJF9B6R
         7mnL1bfb2/WiRkfU8lxhtiwK14reBtyfO0H3FFtIaEfAQrflRf0u3eCPyLT3dPdLFsTn
         w1g81mDOYY1xy1ajKv170uG7Dcnhx+Ftl+6Ev0Jtp84naD/l1A503VaEioljNU6BH+z9
         NufIjlq+UwyGL6eSQzC33hvLvDA7QVw2+6BQL82n0y1GkfsCm7yHA2MGh8u06VHddnKV
         v/UkDK4Qe4kWmfpLLdyGnwMImgJ7wXjtA8nmVUpKTc6l4NxD2df+8rD57Zyc5USVIh+y
         pv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775025989; x=1775630789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m8lYhF7PdfMApbjhxZ68ZX7eTs6X6qz1n2+1EZqNXEk=;
        b=P0znBtdUkbJCw8/F3hHPy55/iLzEh+CcjlRNhCc13pDkPGBDSBBCH1CWHWSsCB2XmF
         3DTTtzv6NTu1bp/oGh9PWk+4VI/yCz8F2dQ8BL9mhjQxjmj9Gd/Cf5yRU+8aOUL2cFbb
         4ZzLAXJMj1ZQBHZGgpW+pba0RBsLvax3WNsuBZzkSIY79yOkQVJnEGY9VxCWebrWIymD
         ZOutadfkvt4dCX1b+uOlNLp0qjXTb+hpNhVMmljNzBTxAb+qg+/TMXbPJ4X7ZIosR2K5
         xA9VbNS7DrSpENwkC0tghdf4iXtvR/nq7mIzmMrSqJSR0edZnuXX3v6vbOAY3f1shF7a
         qtww==
X-Forwarded-Encrypted: i=1; AJvYcCWAvQL1o/0CdEdni0Kknauv3oE0O/b+ov7QaV0PZ6kmsr4hkadyZKPKWTUHUe9mKq1fRovVbyQX@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2ckI3e6X6LH2KZMs8X8CcaxTAmxHjhX39MLfupjwgY6eLSD/U
	L6D9Rprs77SbiM5noxukjH5YIVK4hgIVdojy5Zy5DjD9hBicbnI6aJL4ZgWhaaFgXcY=
X-Gm-Gg: ATEYQzzeUkZFGvsI2iewlkw4doAZQ0AvZjKH4Dy0I3iIDFoIMfKdRVYsAUXw3mGigfn
	Y2XOsK5aUt7eWnwe4c/udEBFrd2F8JL7/Uf7ob2JGxWS9GganEADEA885c03GZDWRt5ebBTRe+p
	OQyRp/PfwcKEvNe1XADlrVwRd5HysxMrMZ33431OInMtwlWm0N1PMORNSOlBTyq5Z2FR/KUOdsa
	/z5FFa9hon69uE2/JxcUh9R5zjAjgN09eM1wZ5pWxjiKUJ6XSe834p0W2ZBw2FkXLm9F78Ga+pw
	qaUidp1X1lP1/sP23pIrkFJUVaONe1oDWcl56zyqYM00GbDU8Btx8qZx8l+3ADZCSroVEh7FpNy
	WTwpA4Zv1r2Pb1y2pWSw5IPSp8ZnT9FkU2tXxBK3q8KO47lHZb7Eh2x4OasPd2cWxOfyltouA/o
	iF0D+v0wEIhnZ81cmJ+9GmpBHrxT9eRzruQj5UcjnWpi7y6zgK
X-Received: by 2002:a05:600c:354d:b0:487:386:3714 with SMTP id 5b1f17b1804b1-48883597e29mr34288005e9.17.1775025988963;
        Tue, 31 Mar 2026 23:46:28 -0700 (PDT)
Received: from u94a (114-140-80-217.adsl.fetnet.net. [114.140.80.217])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427a27f2sm183118535ad.67.2026.03.31.23.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 23:46:28 -0700 (PDT)
Date: Wed, 1 Apr 2026 14:46:19 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/309] 6.18.21-rc1 review
Message-ID: <5m7e37jxpt3wpvw2hcmnfwztpawc5jxex4eesw7tqta7khqm4o@nzoltl24l7nw>
References: <20260331161753.468533260@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>

On Tue, Mar 31, 2026 at 06:18:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.21 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/23814574909/job/69410511555

[...]
