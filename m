Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F37E74418
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 20:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709152785; cv=none; b=R/6wgEJ0D+S/wL5ZCizZT55hE4GCBxmyDvZwaQODVOgL6aRg7og37OzzIHneMrWetiYWENHTgACv9cOr5x0bYgFcWYJSVULwfut0arNGaeL0pd76lAG+oQGsRlbzGFBUa6OHaAVgJJa3zI8+8wDhEbhIodvMG1YVrLu87IMt3Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709152785; c=relaxed/simple;
	bh=XGVStHb8y9qSUzs6dep3cN+bk9roRYQbeBfT9knwOIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXFPOs+gjOUqSook8+y2hA9k8vUM4OT1mV7OuBWMXpzLDfokbIumy8iawiACw/Fe81KzuNIvhldf9d84TTdiH/N4P2DUWbtnbMj/nT1fx0SLydnm83HvLkYNIenPotAg+tI9M3+EVoORERNUjCHOB6txlZnFC+EnI2CsBKeVKBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=fVxgmahr; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fVxgmahr"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-29996cc6382so75123a91.3
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 12:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709152783; x=1709757583; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SN804jzc01partIzI2Ah9KqFEvJhnq4W2RCgOUJ5uBM=;
        b=fVxgmahrS3BWDqmJiCZ9xH3N9pfE0kWfo56iG+FtKGVJCDUwlfUGitPog4Wk3X9VtC
         848N7mYgkx8Rvw5zIbSCX4dV61lc72hdfjxorE7oggqibpJaCHNeXcxji2pWBXOHYez6
         BI9MgFXems7sQlQtYeBEBDI4v/xePaUQrkoz0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709152783; x=1709757583;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SN804jzc01partIzI2Ah9KqFEvJhnq4W2RCgOUJ5uBM=;
        b=ozRb+iIxuq1FEjPqOOtQo4o+FOkBKl9FEFTvNrQQCgdvapjGAfGI9MuRjNAoXPA5Ys
         G15FeRAg5qGikHUCuIcKsG+Id6fTSpaps2crQDvTyPslNZ4NDEfkRqcbQLW2CWrKqIck
         dSC5qDp9GKWJzQr9lJ0lSkrXqpU0AQnpT+AI8Owv0nWo41BKxpUzcZp034+Sb10K9cLG
         +weo+VlPooaEBie6G3z5ZRXvmQ88FBTqKJqZH7+LZr4nWs0SigQhtKkKESQmajCT3kP/
         RYMOf27mDLDy81FNVE2uM43hlXEjsPh9eVmavhle1AS+hxEfH/SwpGKPnU0cyybgwCXK
         JrnA==
X-Forwarded-Encrypted: i=1; AJvYcCXq7bwkvTDzyRQ0CzgE24jkv9lZxz7/LWuxEnjMFrkmKXIMX82pwJT51CkuMYG0JVfetzvgNGnxhHRmebe1NYpsRW9EZFiUTQ==
X-Gm-Message-State: AOJu0YzA8jJARdJZagMT6ai+BAZ3NeUayHH8e8+mujoQTBylxVrdxhkG
	H0ry+EOGzC/qhP9WXYecYKizJqYOLhPcyyZNKYOKt/tizJNG5UT7Rl8QrJRppw==
X-Google-Smtp-Source: AGHT+IFLfWxA/Th4MZy8uxTVg4Aj3LQW9lYFKKfkZwp409nzeV0dHtSQ5wDsY3J6R2HhEBTSJ2b2OQ==
X-Received: by 2002:a17:90b:314e:b0:299:4a63:9e50 with SMTP id ip14-20020a17090b314e00b002994a639e50mr298019pjb.14.1709152783512;
        Wed, 28 Feb 2024 12:39:43 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id f4-20020a17090a4a8400b00299a0efa221sm29805pjh.35.2024.02.28.12.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 12:39:42 -0800 (PST)
Date: Wed, 28 Feb 2024 12:39:42 -0800
From: Kees Cook <keescook@chromium.org>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/122] 5.10.211-rc1 review
Message-ID: <202402281231.F7A20FCE@keescook>
References: <20240227131558.694096204@linuxfoundation.org>
 <Zd53aNc1aFrCYxFd@codewreck.org>
 <2024022804-askew-stung-cba8@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024022804-askew-stung-cba8@gregkh>

On Wed, Feb 28, 2024 at 07:06:38AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Feb 28, 2024 at 08:59:36AM +0900, Dominique Martinet wrote:
> > Greg Kroah-Hartman wrote on Tue, Feb 27, 2024 at 02:26:01PM +0100:
> > > Kees Cook <keescook@chromium.org>
> > >     net: dev: Convert sa_data to flexible array in struct sockaddr
> > > (ca13c2b1e9e4b5d982c2f1e75f28b1586e5c0f7f in this tree,
> > > b5f0de6df6dce8d641ef58ef7012f3304dffb9a1 upstream)
> > 
> > This commit breaks build of some 3rd party wireless module we use here
> > (because sizeof(sa->sa_data) no longer works and needs to use
> > sa_data_min)

Just FYI, it's possible that things using sizeof(sa->sa_data) were buggy
to begin with since the struct size isn't actually dictated by that size
(it's only the minimum possible size).

> > With that said I guess it really is a dependency on the arp_req_get
> > overflow, so probably necessary evil, and I don't think we explicitly
> > pretend to preserve APIs for 3rd party modules so this is probably
> > fine... The new warnings that poped up (and were reported in other
> > messages) a probably worth checking though.
> 
> We NEVER preserve in-kernel APIs for any out-of-tree code as obviously,
> we have no idea what out-of-tree code is actually using, so it would be
> impossible to do so.
> 
> Also, it's odd that a driver is hit by this as no in-kernel driver was,
> so perhaps it's using the wrong api to start with :)

The reason is that most drivers don't want this size (see above) and
all the in-tree code that did need adjustment got adjusted (visible in
the referenced patch). :) But that's the risk of an out-of-tree driver:
it doesn't get those fixes automatically.

Out of curiosity, which drivers broke and what's needed to get them into
upstream (or at least staging)?

-Kees

-- 
Kees Cook
