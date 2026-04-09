Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498E42F99BD
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 06:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775715451; cv=none; b=Avoj6XpudSSC6a8G942+/2BnG3QsbPtoWGdAnvpV52IoFE6avFpVkKGgeyib5huaTyPKzxPzpiUFzRtKfo82zJoUAqUVbaxNG/5xYM958YE++0WPd04879DbzE24DCCEHenQQSrUGEpKj8UuKwcSsPWv0uMeJUkLTuBvGvLhuZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775715451; c=relaxed/simple;
	bh=EWjF2b4rXxKCWu3HaKDT+3RFuI5E/0Jsdwx++BW4dk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bsak1nSixNg16fUwHrLSOj5VpbKQSbsJRhT42wnGwIMoRcCQp0fViCoWDidL1I/LTwzhrGJ9Q05L9363BtIQsueyfBX9WyobZ7g2AmZc9ANrLaAM4w/QGopqmupDrC0/JIxVj0IrVZcWk0yNEAYY9RraXKotUNj0sR1ECGtZKBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N5hNhORY; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N5hNhORY"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488a29e6110so4821895e9.3
        for <patches@lists.linux.dev>; Wed, 08 Apr 2026 23:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775715449; x=1776320249; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mDrGyPf5KZiGiOwAjBOl/DPFbvx6Itcj9Gvj/s6+2Bo=;
        b=N5hNhORYPeAYmPK3ntrWRifa9Ckoftsgs0oRhO0zq/j3uyzpVwkutHnL5xw3/Fr14n
         +0fOw1VSMd8nIq4vpLX4D/FJknrp7djYRPCebIc90DS5f/XqcmCqIGnFsqG0+TAhWppP
         BGzvkUNnk4zoLbsM0ym6QXziADeG3Ljsq794CjAYkhzN8fGqyNMcJuYnsmOkWJpfWtFK
         7L+Fs9byo6J/V3jIziHQDbDhlpDrwn3LZNyOoZU6JuPjkKWyggaZZrv4VTahzGdkFDI2
         xJVGJkqmtP9r3A2jzHBPcfTrERxraa3ey0fmuUJmXcbvyTB61I4I/uJwUgEI7/GfekVH
         EUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775715449; x=1776320249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mDrGyPf5KZiGiOwAjBOl/DPFbvx6Itcj9Gvj/s6+2Bo=;
        b=Skntab7u0tao+z90YKT1DCKdiRr2Bp8ZhrQ6V0iclaADo7vx/7R1FYMoVS5LMNeUtC
         hDkydwiZ9eqG5jIRGKJZVamwZrd/m/+chz1lpzvDe6hC/zyxzUoW2mVIT7IZ+x26ztw4
         kSZtRvYEUBNoTKIarzy340ff0Y7F5naom3hHH8ULa63UQINiufP8aZiwQbR7837TJzwc
         OPtqlEnQruvo0elH3uZMzUeFXjcNx8Ogqmd/JuukZMenLZxsYrTYosN3K2eXdDRSL5H0
         FrUN8h/kD+XRaZJNGDzKWaZ8ZcOqIY/og9MeC2N84Pgn/sorOnpl6AHg/r1WZCzMRQH7
         Q2yA==
X-Forwarded-Encrypted: i=1; AJvYcCUW3gF9Yilc2s3iCeBHmC3rnoMcY1WjB9jB6rqdm1h70CpMpJ8bQ8IKguY6A14X8VL5MnqFfZST@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+F3YkUfwhLCZyv0HTAiDQfTGNeXPS3b8mTNEUgOnGU1iwmPRf
	FSYflfLFN2oNj06QI1eDGPBFZ6q0wINAFyK37kTWEKiN6tWWwnb+/TCY3SnrQDqkHgA=
X-Gm-Gg: AeBDietnzkCfbGPAxNa/coQyjsgbHdw0vC4/7arpVNdReoGKXHqcxvMYSQfqjJVxfR7
	L9kZQhYoM2SBJNSwgag5UmJewKU3p0z/ibNMfMmtW60uB2IxvENwS5YkzPclQqznenWRSNWRh2Y
	gG4WCRe+F3NJlj8+KNI58ACQ2gw8e1ADvktWZZtXpmKyIvku1SHPtCSqaAPBn63abR4+aE8dR4L
	GEm15RmJWASrAaUJh40bAXja75RVibct52X2lilVrMMGN1HpXLLW8mcnjYE1O+DNWslJ3IIsdTF
	lyM6DZbv/OH5IVJujwR+bL4o9n2ksFV4GaHOiHKPr790J7IQLXhrJz6GMjgwGEf546eQYxW0AWH
	2e7H8Jdn7G+e8PfZGLOqEF765ErJaKCEyuBh99LJNTZZlaaEXoSEfCDbvRIFCwXF/SDB7404RIl
	DCag1tQ/S3dMoIyL5aK2GgaSLxnEljCaboe53yr7N3lmD64X26
X-Received: by 2002:a05:600c:3b99:b0:485:4453:401d with SMTP id 5b1f17b1804b1-488996b0125mr346755695e9.2.1775715448685;
        Wed, 08 Apr 2026 23:17:28 -0700 (PDT)
Received: from u94a (114-140-130-35.adsl.fetnet.net. [114.140.130.35])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-953fba6da8bsm17515550241.10.2026.04.08.23.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 23:17:27 -0700 (PDT)
Date: Thu, 9 Apr 2026 14:17:09 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/242] 6.12.81-rc1 review
Message-ID: <rmfosjlqusclu6usquiajpf4rx6ytkimfxao4kpk7pc6vwsoe6@4ocmyszvliuk>
References: <20260408175927.064985309@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>

On Wed, Apr 08, 2026 at 08:00:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.81 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/24153838933/job/70487760115

[...]
