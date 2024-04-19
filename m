Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF50F622
	for <patches@lists.linux.dev>; Fri, 19 Apr 2024 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713530197; cv=none; b=cqvrOPaJ/EgZqRwWW53NIZIrUY5XLCWAng7uTQ5ccYaVijj1SVdiNEBC7RqrQdy/JzCzPGjh7thFpmr7lcs++qJPlD2XORFTyJWRlBt4QpFTdDuVEhVa40Ra3rW3vy9nr2NnBVd5pYlI9O5r8Spu00zLIaJ0NmzYgw+ficlLU/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713530197; c=relaxed/simple;
	bh=hmMFJYJeLShGfYoil0Tx2J0V4mfm9GoN40TdvPb4CIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nkVKg6ZuQaS+Xl84B/5OrDTLlEI3hY9h583fQmoeNI+FPGi1GyDelxKJIHLKnUh8p+MAFXlII0k8h7cQQYQc8ll5saVpWp0+JODmbFXZcBt9oyF4/WjjS/CvB00Un678fJhdnA4fD4WWk5D9mlyJ2MT1P9AXwogK0i5TxITqvEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NBqOk1nd; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NBqOk1nd"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e4c4fb6af3so14083125ad.0
        for <patches@lists.linux.dev>; Fri, 19 Apr 2024 05:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713530195; x=1714134995; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AJ2O6fzXkdIMQAVMScv0OWxTVLp0wpG13C0/RNc+3ls=;
        b=NBqOk1ndK9I2o8DCXrPJtT7xOY6+clHYjW/k+F8sbt7fnduiiFgs+nneMtzBNPXp6d
         DouZXcpoCFv4YdzzNQ3bfhQkDITcYtGD3aIbQlne8ln9n1EqlbZwvPLOBRAUb6yV9XYp
         3K86FZJXxUpgNm9ExNnGouGC4igYecrf590itSwFjqn4TBVdTZdY45mqAbLsU9Sn7id9
         Ux/uxomuH9rsSt4J8cypPBmXzzVDE+Exl6mYUYehtQRpubbXH/NSbClB7e+vPSGepZcx
         YzJ2za8oqj8GSpDZI1fgVDk7V2OxlJ6rn0LNJi3wzDQU+AW0qejZWTl4q4riOO/Lb+1W
         oeeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713530195; x=1714134995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AJ2O6fzXkdIMQAVMScv0OWxTVLp0wpG13C0/RNc+3ls=;
        b=p0VOANxvl03FguCohxA3aDBa92JvR6m8geDxmcSmrDziMfOEjq1hZ6K+/2s8rnH4cL
         t3+WYJJPJv0LP9U7rF+VPKwdwhHFXARP+PUIwJZ3Bvp67Xfjoa6+/TUjQw2Q6cIfXwUM
         yXL9TFaXQ0VsHeXQ2hAAm/d9wN+Z9gJRxNaoFpZFqhP1HPZqL9ZC5sckWB53tAEZVXiu
         30TslaVaxxzRR5XN/VTXnOOffYqWLLMEBTzrcaiI5yAabXUVZ7gIlICcWoRiYxOmfkKr
         R6KjVG2NFgjnno1xkkfD8hd5mCd+oUJQ9ZzYzI0QZDKS+q698iFavu4TM0uPrplcXacu
         2AKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTwJEkdOBXxLLDFcdNJMKtmndvEniuKOy8egZZI/7oIIM0Ayxe/QoxPzfGgsXwoA/sAenRDUCwJeT6PgX2zRXmBKULp8JfYg==
X-Gm-Message-State: AOJu0YxLQMDA+pu6/19OinNfOWZoZbY9W7XS0NSbQIMwQSD7Vf9nYgDo
	GtxA3iu8b6s6DtoEwGew4eP7gsSjd9IJEgEmrZw6kvgtloK/lQO1
X-Google-Smtp-Source: AGHT+IFxgn0ysmSSHGx6XdXzvTnX2ZwfJP200Gp3ut8JQa89cvJ04M5UYd4nVRbx+nvCju4zW1da/g==
X-Received: by 2002:a17:903:2290:b0:1e4:7bf1:521 with SMTP id b16-20020a170903229000b001e47bf10521mr8262391plh.19.1713530195012;
        Fri, 19 Apr 2024 05:36:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id kh5-20020a170903064500b001e47bf10536sm3240883plb.69.2024.04.19.05.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 05:36:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 19 Apr 2024 05:36:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Phillip Pearson <philpearson@google.com>
Subject: Re: [PATCH 5.4 000/215] 5.4.274-rc1 review
Message-ID: <a5c09590-edfe-4fef-8edc-75a39b92446e@roeck-us.net>
References: <20240411095424.875421572@linuxfoundation.org>
 <787e0ac1-cb31-47d9-8200-3f6a3b4119dd@roeck-us.net>
 <c5d0c7f7-96a0-4806-b3b6-269d9189037d@roeck-us.net>
 <2024041949-strained-steadfast-13cf@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024041949-strained-steadfast-13cf@gregkh>

On Fri, Apr 19, 2024 at 12:41:02PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 18, 2024 at 12:38:59PM -0700, Guenter Roeck wrote:
> > On Thu, Apr 18, 2024 at 12:25:21PM -0700, Guenter Roeck wrote:
> > > On Thu, Apr 11, 2024 at 11:53:29AM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.4.274 release.
> > > > There are 215 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > [ ... ]
> > > > 
> > > > Sean Christopherson <seanjc@google.com>
> > > >     KVM: Always flush async #PF workqueue when vCPU is being destroyed
> > > > 
> > > 
> > > This backport is bad. In kvm_setup_async_pf(), it removes a call to
> > > kvm_get_kvm(). However, it does not remove the call to kvm_put_kvm()
> > > in its error handler. Also see upstream commit 7863e346e108 ("KVM:
> > > async_pf: Cleanup kvm_setup_async_pf()") which explains that one of
> > > the error paths in kvm_setup_async_pf() which is not supposed to be
> > > observed can be observed after all.
> > > 
> > 
> > Reverting the above commit from v5.4.y fixes the problem. Alternatively,
> > applying commit 7863e346e108 on top of v5.4.274 fixes it as well.
> > 
> > I added Phillip Pearson to Cc:; he did all the testing and can provide
> > additional information if needed.
> 
> So which is recommended, revert or add the other commit?
> 
We decided to apply 7863e346e108.

https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/5465806

Guenter
