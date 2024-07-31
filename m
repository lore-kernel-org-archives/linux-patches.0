Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B30175B1
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 16:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722444416; cv=none; b=M+BNJ/M3R9Ge8u7TKGsuLUH+JdcVLE+sR+tH7a9DLhoSsxzjzkSowJn/owstE1pdH98N/0vWVphZaVjz8HJzq+mI1kJr9IKxl9tyYIwTO8IHVDe20atQrhs8JjLAj7IDKqiM4MTmdLhcMNzVqFo91zCjsdreCDYa1y3scSInw6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722444416; c=relaxed/simple;
	bh=DPC7a/ItVVS/ZUsDBa3A34Cag7H61CGwBsA/cvnuO+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fwEj4TpseF9tLPur/aQ8CKSGc/0Y+g8OsxgfCu3XB0588OmuUOm38TByhxZflyMXtFxiS0bimB4rJieQROgB3oWphzC389iLCKHkdEiCLqicUnLtx3d3wpAH1Bp6h718yNfvz6PJ1UIvmBZ0GmkcCZ+I7+RZ0j58YPsBXn4xXlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hEhqLF0r; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hEhqLF0r"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-250ca14422aso3656680fac.0
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 09:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722444413; x=1723049213; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Y17BSh/uyhoM7VykjQAyLacxqXElZzql32CV9WyQ20=;
        b=hEhqLF0rqzE4dtSvPlTZ1saNz7ZSyksH4+1ksUFWVrm51OUTU8YKvWwg5/e8hal4tm
         Q26p/QrvbBBLi5kAm3xZsSQP9vL9oi59xM3cjrwvnjswo9f3DiHOHSy5456Vx1LH3JrQ
         xZw8CmDfcBpApayBZdKqYhzc57+IT9BB+iJOk77lqFjMQCoFya39/2s22Sy6NEeyUUcr
         5gXj7/kV66BFffH8bYKtxJBaSrlQCLbZgbnA5Gv0sIxG5yBjGbvVehSbzOABI46lH7n2
         KGdFSnVCP+k4g5eb3/6Q8H6uF63kTlBqJxY6XYajwHTjjvPSYHzeS6ebBYf7dXWM3pQL
         4O4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722444413; x=1723049213;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Y17BSh/uyhoM7VykjQAyLacxqXElZzql32CV9WyQ20=;
        b=ctC+2F0rw8IQVnXWyz+/6KuZIE8bvHwAGJwASi4SEuFSJhh1TMO+4i0l6OqST7kqA8
         HKfUY1seNj04tCyvPYtxwHH0e/Fu5SOImop8086QJFuNGnp1AO1Fg/JPI5J4WV2l3wAS
         QN4TiPYTMumOgSlSxROd15NyblKcau2blxfDMnljxxR8fklOi/0KcJvwU4zR8MWO9xGE
         QnU/mEipU1Bs8PG1js4UUUUUN30AujAOXxpO7/1tL7nkR1imZsP3Zxa7pGrXn9C3/7PS
         2LpqtgOp26Ua7rSterK2oYHkTHqXSkd9xxBg1tlhi639b1I7Jo4I0XA2PIzKIJnYPaS3
         RvhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUE+jaCCxCwINpLqZx9rxAkYy3LoPpqX0g6zBBQyOFuuic20f1g7AUzs/+G64beDKuW1RNukng6ZH3+6QlWOLByoNWmHarkVA==
X-Gm-Message-State: AOJu0YwC1DyCdLDYOjDVGNMSyP9S8F28ee1P1/q1CcsOByIfEInPh+c/
	p/5mQ/voAzvba+9GT2vZiScUYr+MB2fBpl6Ai3TXSoHlq5T9yk88nRNl4h0fC/o=
X-Google-Smtp-Source: AGHT+IFRqHHmQ3zAhsmwrlSOV1mFp0GjcMDmn6Si4PesAAvwXnlJVIJpEu0YlsAaasZvPrDHo57arg==
X-Received: by 2002:a05:6871:aa06:b0:267:e2b2:ec52 with SMTP id 586e51a60fabf-267e2b304ffmr14807007fac.49.1722444413477;
        Wed, 31 Jul 2024 09:46:53 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:c572:4680:6997:45a1])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-26577239eccsm2721257fac.53.2024.07.31.09.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jul 2024 09:46:53 -0700 (PDT)
Date: Wed, 31 Jul 2024 11:46:51 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jens Axboe <axboe@kernel.dk>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-block <linux-block@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc1 review
Message-ID: <ea202d37-7460-4e45-9e19-6a2b23ada0a0@suswa.mountain>
References: <20240730151615.753688326@linuxfoundation.org>
 <CA+G9fYuGGbhKgt6dD2pBCK1y4M3-KUhPZcw21gYtUFzQ32KLdg@mail.gmail.com>
 <ad4543e3-53bf-4e2c-8a3c-1e21b9cfa246@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad4543e3-53bf-4e2c-8a3c-1e21b9cfa246@kernel.dk>

On Wed, Jul 31, 2024 at 10:13:26AM -0600, Jens Axboe wrote:
> > ----------
> >   ## Build
> > * kernel: 6.1.103-rc1
> > * git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > * git commit: a90fe3a941868870c281a880358b14d42f530b07
> > * git describe: v6.1.102-441-ga90fe3a94186
> > * test details:
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.102-441-ga90fe3a94186
> 
> I built and booted 6.1.103-rc3 and didn't hit anything. Does it still
> trigger with that one? If yes, how do I reproduce this?
> 
> There are no deadline changes since 6.1.102, and the block side is just
> some integrity bits, which don't look suspicious. The other part this
> could potentially be is the sbitmap changes, but...
> 

I believe these were fixed in -rc2.  We're on -rc3 now.

regards,
dan carpenter
