Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769713C3F41
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 21:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785447368; cv=none; b=U1h6kJ0oAGLxj6B8KkWz1t3nwaUpxzDD//AVc++vN/vJNeg5k0xfsZ6n2wD7Nbin+qAV0rJBjWwLzdGaIlEwjUKmywbWAQHXIZOQ80T3xlcQxf0OP7c5SpkGL1h5WgRV4Xsf5iUnxd3eZDFj78tC1pMrmUtWagRwuR0umB9UBd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785447368; c=relaxed/simple;
	bh=t96RDEcl6CXhzibWckAmming0/q+sT2PEsl5Qk0Iqsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fU+sC3i02zo///slZ4QKNgupL8iey1UN7doUIUSs0Vqr+Y02gCUAYXmwJcv5oJN2pl4J4gxZvNkg/4JMOrLddguXq2IVnVy1aViD9ssyzY1aV67iXxEEW8zeba5F+OwwRSP86+HZTGgfPxq1mmyEmnZln8plw0H3M3mouE9/5MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=TcI3Y46L; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="TcI3Y46L"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e54f8c051so18273885a.3
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 14:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1785447364; x=1786052164; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=P4b5HVjknF32GrMD5EBEIPgReTPIc+hiy18z2+IkE/0=;
        b=TcI3Y46L2b+629yxHJs/+mgoZ520Pckrm5gvj15B5/e1Oi542xuBt/sGO6Dd1ocIw1
         sN/4Mm04I8PCSfvfXr8ZxM+GVvakkrPQrxEeB54+1g6VzMaIu+BLhaJz4cmsxqKcNMlr
         g3u20Jk+W5TH6q70vOFTBtFXZa9prSGpa+4rc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785447364; x=1786052164;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P4b5HVjknF32GrMD5EBEIPgReTPIc+hiy18z2+IkE/0=;
        b=YgNF7BAk0NTb81bT6jzy4zSS2LgkH1ipsYWpsndBhHZjSzrd1NPVwVTeKx6p70bwxP
         /Lu4xawCr1P2sUc1bF9KBhjwH6TTFQoYCUPLBnzCGkJC1keKZoNFHLEmfmESsEo4nYCD
         5KO3HIAGmtjs1niIHAl+EC/ZdE2cIoE+5+qub8fj9bPFHLl65wrHvWlL+ajoweT6493o
         hslEiKmtEfTyD9z2lz2LNTwOjgYWCQiwmdgTVTVgv5emTlYaWVvFdu6shnhQRpxzuRiJ
         vsqyB7AwuERTPqt3sJ6dbeayWGpXljpD2r/dZ5Ki78salXzyPAgK5BzK6EolAmHzv614
         YoXg==
X-Forwarded-Encrypted: i=1; AHgh+Rp7MlNyyUW7gt04k4GfBWNSoK1hW1sQoXGNyD513f2oHksbdSg4V19Pwh/83u/QPy+2tCJIEQJl@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+NRU2z30WWC1/VnVVCsn+w5hW4hQnvfN2ufKcsylfzcaYMql2
	8sTwd/Lwj9UnAUHP1F7aMs8kHEAyP/QsMEVFtrUc+FL6Mjuj61CpKlugs72VUd2cxQ==
X-Gm-Gg: AR+sD12qNRvADPhyFmKwGTY2I5xU3gqF6/EPt7eHG7/NBn6XtivVA2tNl5VcDXF1cTY
	T82m7eu7G1mtwk7lYiQwQehzdypdzSTJlNqKkmCEcCHAFY63mweP6/2ASrd9Bbxk8QoMDVO4DY/
	UfPdz6zHM8+z3rpu4NFVFk36da/kB2jXIkZ+UeGAjXLd+c30xuzxo5mytV4F2CqyDYS+mt6ToNw
	L5WGG/uW2y+AIVyJu8hrgx9vTXB5Wq1vjBbThZ4bRLZjUhJZOK6MklzXrfn8sL3vkwloKEvFIlu
	IbDwlCzX1vaX1rKYoUPgJf4if2wGL9JjntnXwxFkk4rnwVIi/K31XIlws2yaO85dAWPniyupAjj
	UdQ0GrRmTQtiNGFOuwCTxS/xmwJszgShB6jQOOTfWgMME+KmCmJYZBNUdRJUvgWBUEhbdrm4c1q
	B8Cqftvt3srM5m+NF9oQaVxcD03c+lPq33YJIXlHMdc6W1L0vc/1+VTTH8Ry8g2MtvZ6G0lgNE8
	Z0=
X-Received: by 2002:a05:620a:2913:b0:915:9e84:85d1 with SMTP id af79cd13be357-93485fabb95mr460292785a.23.1785447364224;
        Thu, 30 Jul 2026 14:36:04 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.1.58])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933e7318323sm499000985a.23.2026.07.30.14.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 14:36:03 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 30 Jul 2026 15:36:00 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
Message-ID: <amvDwI_I71ltT9CQ@fedora64.linuxtx.org>
References: <20260730141444.267951807@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>

On Thu, Jul 30, 2026 at 04:04:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.6 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
