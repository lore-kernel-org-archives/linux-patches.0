Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC0B3382DC
	for <patches@lists.linux.dev>; Sun, 11 Jan 2026 11:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768131384; cv=none; b=uddjVXbXdeQVL21pZ5IT1ePn7C/tglke4V40/UAR7eVfkkeAvUvbhKvrUxG8t98kRQR35js5+r58KCVAprJADGnyRH1c/irivnSEIn98wiM6GsDKsWUxeSwu1/Uqf92c/UkOREsJ17SUAF8fQxFVPsCHFTo5QO5Gp4lo3UhS3TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768131384; c=relaxed/simple;
	bh=WA2+qR7GJIrlDkE/8m2agQnhKKxdGQn++j4tKhGUs6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQL7LlPm/HZZbOvnCoKmgvTX3/FzVF3n5IEuXyvmKMKDR8vXQSov0RuySTj1csGu+N5G/fUojd0z48j+k2qbiDuhkS27hI+iBxU1n21pAORckqi1tQiJU3MOTXgArURbISKpghzJpxr0nqk+ptdEhAJ+HTD0stCmFSo9aE1LqTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c56vd/ul; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c56vd/ul"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47d3ffa6720so53977285e9.0
        for <patches@lists.linux.dev>; Sun, 11 Jan 2026 03:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768131381; x=1768736181; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZI3ApSSp9u/jOiH3pWaGfMUo9z/yXLRfpgRERhRlFg=;
        b=c56vd/ul8PGRc6XHwP/iD1fe9paUAxFCXKxMjykXI3WYa0c7zjRlNUVVwhRw6yG0lU
         z3G+qjzfpD3YwbBhFIWYYVZ1zBAG10Jp24F+zbKsJZtMVEIKT2rVDEOcHwltzVRnEE5C
         3mnkFTDslaelbPXUl4Ap4MF/G0X0cerAZa1DWTvhlhC7bdWWt+opy/S4p43LdRRA+5eX
         e2zWyamQKFqc5021/RSFMBCoPPYNwKln9S8CT+HqDWeapAyXtbcKYGN/W1tUK3HZ7ovY
         7ySM7NTsJJ8aa8VhjIhtZ9hyGBlrsDcYRB8CX5CNegAKNZtQgwb7pfbXYnJywbVqFK9z
         1bzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768131381; x=1768736181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SZI3ApSSp9u/jOiH3pWaGfMUo9z/yXLRfpgRERhRlFg=;
        b=RljuVQ38sLM+9ooA8XAg3QkT+UcDsPOOrMEUPt6ybLzTGllvqo/mi6wfub1x0pMCfk
         Yy9BxiFNNkN0pKiw/ujaHnFC1Rpe2agxVUTgDr6sYcBjRDNi8zowe5uF8ETlsdWA8ceh
         i6vnufkOl0IpF2T8Pxh216GhKvIBdBzc9Wr/QDxKkfNAmIeUk1rLz969LiA1BdzSty2n
         Ln62Pf0b4I1j4n0fAQQiqnKtRr/PBvIZnrhe4n9+Xr1CyHzaljaTJRdBWtT3EmtFXXDT
         oISH1fW7X0+leuIbu1VTfU5hxePxdPpfPU2o505+6UbAUSlyzojbUCIkOgNzxLHYv+je
         g2DA==
X-Forwarded-Encrypted: i=1; AJvYcCVaA//hTgoAh/TexwO9pwDip7cQ6CT5zwjVNKa+275Sz2Frbs1JcNIw3HDCV+sx0ACBPjhKUV/l@lists.linux.dev
X-Gm-Message-State: AOJu0YxR/UWuc2VaMOrO9kBPXTzUmpBTNqo5U11eRJgBV35/9BRBGeyZ
	2yQLTLOsyuOVGlug0b1BbMgrHF4dGO3hzWW/Hjzul8yuOqciQWajH7ho
X-Gm-Gg: AY/fxX6ZIvHJFG2dcDTsVgV15QgkfA2irUkYQMHGxBaS7B7YOo2vIjQdYEQnHDtHQpD
	7eN3MRiGzGGWcA5Sc+B70tQ4Bc95/38OFUbQldAkcJJ7Hys20vbKMPGKs+4IDoxsrZ/RCUeQQiu
	pGcWHInGahVB/4I4qZ4pyT1OE+83Km2sqzzrZMUba8AWQ2aKkbtc1GJNfETkLmIO0Xby/Xoztk/
	aL1V1bDb7i/CeOKkPkShXa8HSQnNsuWXASk1/oq68ldDvfol0jUwHyXeIGnjK3wndrwabQp5YFk
	x2/3ZaEmuWE1Xx9EILuqommz4WJA6lmvxUkSH+DB7lqaKAQPEtPNoxI0PEYH3u04MUwkF5ZBgkH
	68rFSHAkq6MQ7gOkWxStVIJaA4h3jHwQycGmTOWTh8RNGhCH53E9yHFbKil9mfI+nqspphf/oly
	sdq3lv7cI=
X-Google-Smtp-Source: AGHT+IFSg1iNVQHqnhtkbEsO4YlvooAwoO0jT3KKmSnsT9EAf57O0ht0v/OFdFfQ+b23tsFmCK60EQ==
X-Received: by 2002:a05:600c:1e24:b0:477:5cc6:7e44 with SMTP id 5b1f17b1804b1-47d84b18ccfmr169969785e9.11.1768131380879;
        Sun, 11 Jan 2026 03:36:20 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-432bd0daa84sm32553508f8f.2.2026.01.11.03.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 03:36:20 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: macro@orcam.me.uk
Cc: kernel-janitors@vger.kernel.org,
	linmag7@gmail.com,
	linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mattst88@gmail.com,
	patches@lists.linux.dev,
	richard.henderson@linaro.org
Subject: Re: [PATCH 1/1] alpha: trivial: remove ^L chars
Date: Sun, 11 Jan 2026 14:35:05 +0300
Message-ID: <20260111113505.2146705-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <alpine.DEB.2.21.2601061310110.45251@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2601061310110.45251@angie.orcam.me.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"Maciej W. Rozycki" <macro@orcam.me.uk>:
>  As a matter of interest, why would the presence of ^L characters cause 
> any issues?  That is just another instance of white space and it has been 

I have shell script, which allows me to remove given config (for example,
CONFIG_NET) from whole Linux source tree. To do this, this script parses
.c files, Kconfig files and makefiles. So, I want them to be as predictable
and easy-to-parse as possible.

P. S. I don't see your emails in my gmail inbox (not even in spam folder).

-- 
Askar Safin
