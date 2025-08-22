Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4122F3612
	for <patches@lists.linux.dev>; Fri, 22 Aug 2025 09:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755855087; cv=none; b=WQs0qvpcQ+OV/CQxloTtk4xcoi8ODbHTQXW95Kyl0uzfrcJMq1e9gXA5J76XtgFvKhmcf++03h53ikpQYCl9tXDgI2t7MlDKcamtgwTFvwN+PHChdtXKYirluQfaerTcIsHzeU5mLWczPlXR0ovqGUaALe7ptvHoToV3r5sas1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755855087; c=relaxed/simple;
	bh=0208ISyKu10cUE7W9YgFPUpUsfgz36ubVskvnrbBoYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iT134NnY49TknTbgc40HHmQjVeDNBeh7iF8iDAVAAEnCFQ0EZLM5i4zq1Vf8WGz3T3g+lyGxiMFWWIMR7aZekrlbJ1xtnGe02g4liPJPHsdeVLRKqeFf5+WpEVUE+KZYtcR/1HFP2qXELkZvLjPiXy9EsuL0M9AqP1+0HqAFw3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g1rRow4f; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g1rRow4f"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3b9e4193083so1469298f8f.3
        for <patches@lists.linux.dev>; Fri, 22 Aug 2025 02:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755855065; x=1756459865; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xg8+uWPzi2Mjr9MpPBcmahRsPpi30DI4NUSUxz6VBQs=;
        b=g1rRow4f4LbZXiPFi2jYs+Plo5ZuWGdZa8T50tNAT3NOotVUjc5w2QswUuIOxTGUFG
         yrVJDoGqXpfggKSaz/6djy5kEtqK+E6EZQNYhzmw5G7z7NEP/O6/UOzq8nEpaG22umSv
         47zuV+8i/muygGiCADG+OYZHDRIiOl4JR8nzxVckODqXp2HzE+n5lw5JwcZxP7vLeFW/
         3caAFeAEpk01H40oQnp1nX32bmOOQJYyJTMNr0X1CiyQNR0ORwoISLU7o4woiQqpnMRm
         W4S4NjHc3PE0WGxgCXkDRhiBCmBDI9IfYsNS9P0gcgcZYokxtd9HsskvOyqGhB77XZ4K
         2kDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755855065; x=1756459865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xg8+uWPzi2Mjr9MpPBcmahRsPpi30DI4NUSUxz6VBQs=;
        b=QEG/khs9AID/UOmwmNxZ4H0HhsMNVRQqocdTBpXMPnoreEnAxXso2CsTDxlJ9TM0lp
         dT40QIYq4hZVmC8WkMq77HXyCHwR5A3WpBesX1DhMeSTA3InY8tn2d29ysL/cMfUOyVC
         PbbXMnIedcPNoaJSdEjTIXwf0SQgnIF2pe2g25khIS/WV0Yj5Uhsudy6bHHMDI1kqYZZ
         boFQj5HvgXdYUbV0OIF0c6csEwkEDYBmNkLhdBhk1CN7APD2mCGs7VeoeGdJ5yGgEGjg
         g9anByKOQoEPSQA/MAFCvrAotgdeW5qSjMG2MwLuz4YIibhXX0bpj/JFcW5Xqs3UwvYY
         pqQA==
X-Forwarded-Encrypted: i=1; AJvYcCWcE5mamVmbUtd+V9ygHI53lY4bTcACfcTJ9wf/J3YRyitJuoJBItM8yxQ4BgKtEa3zTKsb9oRg@lists.linux.dev
X-Gm-Message-State: AOJu0YxEdz44dC5gh/o2Rg8/JElxX8Jj9XJFqm1Rth3MnT/DCwQuIkUZ
	mpvCBJzSw1MwiJRkkaPWdfC0cCJKt884Vj0bqyFqDSWnRgD1RWj28C0LInnyjH8ySaY=
X-Gm-Gg: ASbGncvexx75M/y9t41+Jq35wK5BVGkcjmxWxDteJ3So2zw6NYhVRO1j/oxceruMOgz
	9hqgDFFg/5NrCeFaLT3yoCnYLEMv7ouObGeoG+5ZbI1zQl1vQjykBLhLeIewRfTRoNojFxFNfOV
	vRnHkPmM2SkfJ5FVF7NFmtsUIzxsR+TsX6RKFRvWMtuxJ9/vwy+dYBIRaooplyZLN83LBgBvDo9
	8RUrUsNRr1nSFY4K57FwEV0k4Cdsu/kiYEITRhBKmCm95/MjFmn/NXBqj855qE+QnEY6O4/1vbv
	TKZ9gBnCAquUSmYnEgn1pkVfE1aAvZvnCZiXUvKiGpwwLlNZ0N6ickxbz+re8he/Ot+LpTDjLq2
	jpI1AWKQZudyoXQDDjn8Hu+s77Ys=
X-Google-Smtp-Source: AGHT+IETQifX60xNpED57w605gzuRtVMT1h5myncjmf4CiJxMRcoa/HpI34Al4mQ3T46Kr36eWGX/Q==
X-Received: by 2002:a05:6000:18ad:b0:3b8:fb31:a42d with SMTP id ffacd0b85a97d-3c5dc6385e1mr1345579f8f.34.1755855065462;
        Fri, 22 Aug 2025 02:31:05 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c598e067b1sm3192314f8f.59.2025.08.22.02.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 02:31:04 -0700 (PDT)
Date: Fri, 22 Aug 2025 12:31:00 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, Joseph Qi <jiangqi903@gmail.com>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Ben Copeland <benjamin.copeland@linaro.org>
Subject: Re: [PATCH 6.16 000/564] 6.16.2-rc2 review
Message-ID: <aKg41GMffk9t1p56@stanley.mountain>
References: <20250819122844.483737955@linuxfoundation.org>
 <CA+G9fYsjac=SLhzVCZqVHnHGADv1KmTAnTdfcrnhnhcLuko+SQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsjac=SLhzVCZqVHnHGADv1KmTAnTdfcrnhnhcLuko+SQ@mail.gmail.com>

On Wed, Aug 20, 2025 at 08:06:01PM +0530, Naresh Kamboju wrote:
> On Tue, 19 Aug 2025 at 18:02, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.16.2 release.
> > There are 564 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 21 Aug 2025 12:27:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.2-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> As I have reported last week on 6.16.1-rc1 as regression is
> still noticed on 6.16.2-rc2.
> 
> WARNING: CPU: 0 PID: 7012 at fs/jbd2/transaction.c:334 start_this_handle
> 
> Full test log:
> ------------[ cut here ]------------
> [  153.965287] WARNING: CPU: 0 PID: 7012 at fs/jbd2/transaction.c:334
> start_this_handle+0x4df/0x500

The problem is that we only applied the last two patches in:
https://lore.kernel.org/linux-ext4/20250707140814.542883-1-yi.zhang@huaweicloud.com/

Naresh is on vacation until Monday, but he tested the patchset on
linux-next and it fixed the issues.  So we need to cherry-pick the
following commits.

1bfe6354e097 ext4: process folios writeback in bytes
f922c8c2461b ext4: move the calculation of wbc->nr_to_write to mpage_folio_done()
ded2d726a304 ext4: fix stale data if it bail out of the extents mapping loop
2bddafea3d0d ext4: refactor the block allocation process of ext4_page_mkwrite()
e2c4c49dee64 ext4: restart handle if credits are insufficient during allocating blocks
6b132759b0fe ext4: enhance tracepoints during the folios writeback
95ad8ee45cdb ext4: correct the reserved credits for extent conversion
bbbf150f3f85 ext4: reserved credits for one extent during the folio writeback
57661f28756c ext4: replace ext4_writepage_trans_blocks()

They all apply cleanly to 6.16.3-rc1.

regards,
dan carpenter


