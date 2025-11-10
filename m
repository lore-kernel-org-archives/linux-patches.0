Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E720D2E62BE
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 23:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817848; cv=none; b=fKg0doP+Nx9bPWdm5btma7/ntQcx3a4ZciNtXmfF3Z5XY1gGnMp2NfzHO3njlWZKxZf44wulptPggxS4y9HMEuPLrP6WMxZFEm8eEzBVs2eYCXbR0KWBiqeXETJBbV4AYBi5AvnDQugb9BVYu4w5dqUYdj2GyfbMc4OgwR9jt/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817848; c=relaxed/simple;
	bh=rXO4cV7y/7KRb7+PNQISNcMuBYWSEWB/8HSqi1ED97Q=;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:
	 Mime-Version:Content-Type; b=KmyRPJKxcPWoa0MPS27YJiJO6kdVDHvJ7c7ixlWsNsX47VyX/MaM/MlPwOTLKjaQVEQl9YWdXpzrcfnx4buu//bhY+pmBWnhBSTiyaz5fZfZ4wf/B7WdhoLXG1rWVLqPS7Gi9N6h9y4iaqrGN1Odr0hn9AqNJw2zCFUq9CdFyVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IEz8owQr; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IEz8owQr"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so1646662b3a.1
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 15:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762817846; x=1763422646; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sONTki0cwOLfaZkpfYHcU55+KIViW3n5GsMd/O6clDo=;
        b=IEz8owQrmtj0PxTjXU99lw4MztLQUs+FewtU8sN4DK+rE8w0PL97o/pfxtFKTbPXZZ
         gJvTGli3VyhFjYLv12bREKUyfEGCFqRrB5tlQ6+UU2aN/Rx8ymXQynD+PO3f2QRTvl9a
         W4PfgoUBTLCy5WWLUU86NYgwCSCFajhi7KHpgVjf5RxwDWNQBDepZq+tZZ6F4s8R0/Je
         ZZ9f2ZOd3e25ZAcPfOy5hs7yqCdYCB6w6+sA+XYLDPK+7crcZrLrfFMwgJ1R5IgyYIlc
         RKH0N1XGk6dNlR/51ZNxAo1LwIwMRjBMTa9lfSzbYwEFyUP3osOUFjoG1CsKpexzVCrJ
         3tYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762817846; x=1763422646;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sONTki0cwOLfaZkpfYHcU55+KIViW3n5GsMd/O6clDo=;
        b=TaXyvGb2GN+QcF6kfcwmN1f/e7ad+tde8Fs3zkvFqE0ZIBsH0TT2Js1PgpiKLgFK1c
         vTh4K+tThmxdHuHP1wsGu+tXhGEZga9MIce7x4uIqoP54WYO8ymYyNhyOc13x6sJvsWc
         8b4xV+FtY7JV4NfsdjX0dvdej3ID//1oasrj412uul/CYg55QPDTkSyFRICeG6saDnzw
         sfMZHYIYFIT2f7lH/bMMNKzqbe+p1COsWFnAjGe+VL1X2g+jhH8nge2P3hBgd/lNMD8h
         RflSJb9aJaR8P0p9Ihg8TE5Ypyp/NY/b8dAKT4VjyOpPJWpag3LT9Nh4f/Q6p5/WnzxN
         1tkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcTQV7How0d8rnn7CL7bT6gq13LDKoDGJhYdLB6dMprZTWCmjhjyn7X7A3ILgQH90OeyagzxJE@lists.linux.dev
X-Gm-Message-State: AOJu0YyHt+ElHJDNo4jdjg/ipfZ31BUKDmLtT5ezogwNxvumX9kTm2NQ
	EJNs1Wt4GlQQ2j+qK7+vxCWto8rSSqP1UcOz667t+1Zr2azL3ha9cAeM
X-Gm-Gg: ASbGnct0zfS6Ey7iO1OJuor5FAEEeS0XrTKzxyR1/ZBR/H+wlbX6qiiw5odPUkskm4M
	jQ2EN7Yeuqki4i0EIWDSNUXE/UMbYokAqyLzPHKT3pOgfTMHuu3c2J0OwxdJXGtrd7bHdgB8fui
	DDxGE7rqQLlKgsxHNAYsEOliSztoCTv5B1gmdSzhSpzeJBu5yvrp0v92+JrWQOxbjc8mxUk28tN
	dGrh7rP802+Z39Rqvha7S1EI83p4VIGqs6aN1zFqcSorUYcqBxZSMbPAXhVCNQ0Jb80uIVhXEMX
	6d13bbvmiqmReqONlrNHIM2tJ6soTZGZv9DEJbrWKTQ6Cr5QoXsuhtHLTeFPDihxAL7q1V41elb
	gEAY5a8ldqhj+nvhRLAGOS3VN6qBQCnfreIQb8DL6zNnJaiiOCteg2KYSDEOll4u72hCbZR8/Ax
	2/HYEtYD9KftP7/+HEEynUqXX9xmqmSVgRDIrLV4DS+01RiG98UBJYB7gUVV9yoXVz
X-Google-Smtp-Source: AGHT+IHk0TS6U1teQSHT2W5LJ/UoVkLAhqZnFd416dWAUwj/XxNWZoZkE3GEbfX7u/ERSkanItOk1A==
X-Received: by 2002:a05:6a21:6da0:b0:2df:b68d:f73 with SMTP id adf61e73a8af0-353a3355034mr14081651637.34.1762817846261;
        Mon, 10 Nov 2025 15:37:26 -0800 (PST)
Received: from localhost (p5332007-ipxg23901hodogaya.kanagawa.ocn.ne.jp. [180.34.120.7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba8ffd3f6easm14277596a12.21.2025.11.10.15.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 15:37:25 -0800 (PST)
Date: Tue, 11 Nov 2025 08:37:20 +0900 (JST)
Message-Id: <20251111.083720.572544715756974945.fujita.tomonori@gmail.com>
To: ojeda@kernel.org
Cc: fujita.tomonori@gmail.com, alex.gaynor@gmail.com, tmgross@umich.edu,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
 boqun.feng@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
 lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
 dakr@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 3/3] rust: net: phy: follow usual comment conventions
From: FUJITA Tomonori <fujita.tomonori@gmail.com>
In-Reply-To: <20251110122223.1677654-3-ojeda@kernel.org>
References: <20251110122223.1677654-1-ojeda@kernel.org>
	<20251110122223.1677654-3-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Mon, 10 Nov 2025 13:22:23 +0100
Miguel Ojeda <ojeda@kernel.org> wrote:

> Examples should aim to follow the usual conventions, which makes
> documentation more consistent with code and itself, and it should also
> help newcomers learn them more easily.
> 
> Thus change the comments to follow them.
> 
> Link: https://docs.kernel.org/rust/coding-guidelines.html#comments
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/kernel/net/phy/reg.rs | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
