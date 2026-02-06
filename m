Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453212E54D3
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 05:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770357223; cv=none; b=r3KvYCFVaVW+B1TQrZQFqIcCC7w1/jGt7cfpMg4kFVg0A8XKElEZJ8U6XCCB1aWVic013T7vQiJyL0zPma1ciwykTojbenSnL7/5par20PVSHN4WXux3pSGlsC4BUuxESXgl4gaOM3WLQC3smMW+A/3UEpX+khAF633waa4tZmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770357223; c=relaxed/simple;
	bh=CpCoabRKPh4PQOEGC2+tUnh+EMTtnU1w4cwVugMieuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7mNTJQNZjMwBR8tI51GbR17XMMd380tDHaZ9vxlkPZgRJZhEzCUlcXARXAvaUOBrg/SEZCSV072y+H5OBSRcfFs2DNpiePfP62arDcREG/W12eJu7Nw6vxXLX6yQQa2zT2/pLK1hPaVFYYF460pPEwKX39Af2uXmIfdtYTfPK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZXQhAqmF; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZXQhAqmF"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4806d23e9f1so19334605e9.2
        for <patches@lists.linux.dev>; Thu, 05 Feb 2026 21:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770357222; x=1770962022; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/4JtE3qnqshh2jJl6h63kPh5x+A4w2hQm6dtv26xRB0=;
        b=ZXQhAqmFAh+o/A2jb4xN30BPPmIbIELEgrrXxsylJs1mC5IHOQA4NmEZ9e+e2DSXkJ
         IB71Hl5J0EWHH4r6/N0ASDVCMYkxA2UjlYyjuadpaM4sxJoUiePSeJ3zQcORvajQO93y
         pPTh8XjD3opslDJQjmDOl4rqY7DhrFx5zBxoHgpv2KpmGnST7W9O/ldfRyHX1z4ryAcE
         bBPFthikpoyGVXWCAuMIyJFH/87fVvrXqvQy9lqWoSFtMpKAe+h+583e0qEjo4t0mp2P
         fKbh/i8hP/oft9gjXSTzO5lUrc+t2AFP1NVKwG/zzwgHUBXe9QCriaVocCBNaSDvMb/B
         5LRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770357222; x=1770962022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/4JtE3qnqshh2jJl6h63kPh5x+A4w2hQm6dtv26xRB0=;
        b=pYz6kLbmMuA7vOidfKn9E+xnJJsptK4mWZHAWQmSF4kizmV2yjvrtg83dn5WzVJeHR
         z3hdk6buwQP4nA5pUD5YhkjT8w/phygZRt2UqsvSt/G6fLmIQ5Nbc3xyI+bvS/UQOBig
         l/dNEfUG1pngEadT434FK7iJfRuiiZSCeU+FDRiLmtdESL3qPwlaZ7WOTasUmNuAAIuW
         21dXNUjvEkkD96h1NxitCCw18TOTIHwcz0kOBJ/pUNmOAwvj6dLu8oFZRgeZN13ZjHfP
         e4y+WSC+Cbtwdfr6Iwb0/Nji0zjVyJ3cMOawZky1WkUOIlY4R5nseJdA4O37fK67V5FS
         8rAg==
X-Forwarded-Encrypted: i=1; AJvYcCUrDyrIbaLzMe2fZJFWICYm/qjtXe0IDBWXLzty81jOqTt6mcHZXdQI0v9Js0v1TNJBTNrJOUX7@lists.linux.dev
X-Gm-Message-State: AOJu0YwVr8NcZTsIOl8D8kYdjPspz2ELHq2fPdcMB5yGUHiNccHR0Ypt
	JYD8RKKQElGfJkqs4GFKfwqDVFw1CgVpBB9TwMAlz1YFH8rKpydRIHLb8q2iBgt68NU=
X-Gm-Gg: AZuq6aI1YHh6w1LwfWZflgNqaqHe/t91SdKtg5RWETcACU40OykX245liU3EvlfNql2
	Ho2oYPBiXsoGUgRPvcQAimINL8NM0ghjk5t2TpVKMGRMtSs/kdtztu/C+ZpWhfIOu0N38yevtF9
	xv2RYkT4VQB+SAH5XupcRk9PYptEcJrUhhBMnPcWENh46URvhiVNAhqIB8vO7A0Bxh9AYbzWfoq
	ki+d/qazTFaQSJPZ9iu/sZLagFr1pMLTzoRNee1izQxayVBMYGhM4+N9h1hfiq0Pw6/lbaqCV8D
	rkMaB3ZVbcwY3SDz1B2tl5xiu1dJamW5yT8RvB9fxluORnU88Cdtanf9yc/NYYKnkWAEIOSHL91
	gNeroAyowgpONLW77KfKxLGI+xYKubbvFwpLd0rWucm42yfzoXDuPzZ8s//FJ55aoFwwWCY80wQ
	S09oHQQ+MT8WDlGDp55tWgYiaj9zH0ecsIjw==
X-Received: by 2002:a05:600c:4f8a:b0:480:3230:6c9b with SMTP id 5b1f17b1804b1-483201dd004mr21171385e9.7.1770357221652;
        Thu, 05 Feb 2026 21:53:41 -0800 (PST)
Received: from u94a (110-28-26-119.adsl.fetnet.net. [110.28.26.119])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48320728774sm26993835e9.14.2026.02.05.21.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 21:53:41 -0800 (PST)
Date: Fri, 6 Feb 2026 13:53:27 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 00/87] 6.12.69-rc1 review
Message-ID: <ea7clhl6deykiqn2klghwgt4jtcvyjoigv2oyvzqwzgrcnbks5@mpax7k4545e7>
References: <20260204143846.906385641@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>

On Wed, Feb 04, 2026 at 03:39:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.69 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/21724288947/job/62662113810
