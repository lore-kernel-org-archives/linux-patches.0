Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E28438F9C
	for <patches@lists.linux.dev>; Thu, 21 Aug 2025 15:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755789152; cv=none; b=XTfRu71QL35a2zBOWtlLcyUWRO+mb5gaavt3waoFuoz9KCOEyfujM8UaMkWsZGiXG1gRmwP43ZLvl/69MlIXRYkfgQEQsWFFLwgPjCKTuMvcZzVykHb2X3r0m2oaFIKbK6CCvz4c/Y3VJcONbSq8oJjoO71j72beVEaIuRQ6evY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755789152; c=relaxed/simple;
	bh=+t8snXkKmcjjxAr5BHCKqum+mz+VMESzAYGS5C3LXnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oJqCQMjaCAvIdJGDjNYSqzc+1liJQofwTbTO0bk6fNXDMApVbpSiy/eqLD6ijEK4gWL29DID/V+oXps5unlctjore3clwxxzARw08yaUvp/nEsSkRf+yAGwJmxsb8Np6IsjdBohbmcnWnG4aUzu7gKIrpD5nTBSf9N/+4V/MZqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZHEuHM/V; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZHEuHM/V"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-32326789e06so925215a91.1
        for <patches@lists.linux.dev>; Thu, 21 Aug 2025 08:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755789150; x=1756393950; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=66DlkmYsPsoYSqdkPK/KdDv1XaJYGY0dUdLFlLXTfd4=;
        b=ZHEuHM/VRqv5w9/G/F/57CiFJk+wmpQkSA5kS026m+/D8wbShiVtb6Uj3muf5IsWSO
         Wr4p9ehSAhrSkQHi5fw8gPAjdMc4j1gc9lF169cDD0FZ8Foa+2uS6jYYropjhHu8DG74
         yfhsPDnuSjeT+zss/B8ebNfvEqL6r4UxOMz1wmdwX7NFIMPqFsS6G3JBOC2EdmbSQk51
         2q6gIuqmrRGFiZRGoz3TPGMRDebH5KLlXArfHCvO5FFX0Ll0wFReZCsJhhdz3l6jj82F
         Ls8q0JDdjmVPrX6OVd6DwHVcAO4tLoCYi2Cne5ZH2bRdbIQ0YH/hu3hDDObd/lBG4CmX
         8Nnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755789150; x=1756393950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=66DlkmYsPsoYSqdkPK/KdDv1XaJYGY0dUdLFlLXTfd4=;
        b=k5xIlsVWzPj3kiF+C4Sq3a4qS0FtEPtw6ek+FAJcVxkld8iy0N3Kzi0dtLzP1sOPHF
         e9OseE8GReDDcmK978YpmiGDnLOW6Cpyz1Jdizj81arCjNIEEfBllFICy4DJHPOCFsFb
         iVNaRjiezKfzcAB7DcvvFz++LVKRW0h4GewhtY8TCVjcu452CQEOFwIasNzXHDk4Nn6G
         ZMYU2nCI0L/7LEYnhgWx2mkYNHZWpZN3map+uYjQcRrYn5y7g6T6Ho3MqEaX+rYYiyda
         4D6GPXOcblL3yy0dv5zXkBjl/TV4P47FoVKhBDAf4j8k475J1eu4Uc0il6SHCCU/CUqV
         0fbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYb2BFMKBb8VinUKb7jviIqopFwNy2IBagfpHInED9FpNvAu1BNTcsYGp1sNht7U5wcNecKEBM@lists.linux.dev
X-Gm-Message-State: AOJu0YxTUjgeVzUlKg/N3g2zKKYcz8HBNCKps6XNgzpwYzaksIEtr2k2
	rTbIx716eF0VpscmglDtpUezSRCss9/JF94EC8fTFdPcACm19xvgSQgM
X-Gm-Gg: ASbGncvFGGfEM8rOS9+U0jGTWpxjHAY7c+noVrpUq1ZUEME9dn+edhsOCMPZ4FeWZBw
	j5SLSzXey8Mo48oU/LtYreuh6aJe5xCK8lnaKdpQTDxyZ4pXVYNjVmT27LTeeGun2FNZmggu9BU
	BNyQdYQkg8NJUAcS7nrwkcCyM3YPal2FxtfNqScnvZuWNN0s4EnVaS8gkmlcG37kDLGPxsdjF1Y
	k/e3zhiN6xdLvqXNll/f5nHl2YHRr64hatrVt5RdQwIKtSpKtnnCEcmtHuOYvaiK1KRRq6CNVjm
	/U3qEOIKHI0wQPfpEFev7jkOjHydz+D5+JIJf6+hgQ/NXNaiag3Ubj57HGSkbHwu1tFP8oclHoP
	pNzMKOfR9xrzdY9NmTMYhRoPku8ejTLteoX29FUuE4qPscw==
X-Google-Smtp-Source: AGHT+IGuF10wSRyOdJQ8u9SwxmTQNE7Yfpm2eiqD8pnVDjHTYzs4E2tneYeJRUzpKjax9uwed+ExsQ==
X-Received: by 2002:a17:90b:5746:b0:321:abd4:b108 with SMTP id 98e67ed59e1d1-324ed11995dmr4378690a91.12.1755789149706;
        Thu, 21 Aug 2025 08:12:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-325123e7902sm52128a91.6.2025.08.21.08.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 08:12:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 21 Aug 2025 08:12:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.12 000/438] 6.12.43-rc2 review
Message-ID: <63e25fdb-095a-40eb-b341-75781e71ea95@roeck-us.net>
References: <20250819122820.553053307@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819122820.553053307@linuxfoundation.org>

On Tue, Aug 19, 2025 at 02:31:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.43 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Aug 2025 12:27:16 +0000.
> Anything received after that time might be too late.
> 

Build reference: v6.12.43
Compiler version: arm-linux-gnueabi-gcc (GCC) 14.3.0
Assembler version: GNU assembler (GNU Binutils) 2.44

Configuration file workarounds:
    "s/CONFIG_FRAME_WARN=.*/CONFIG_FRAME_WARN=0/"

Building arm:allmodconfig ... failed
--------------
Error log:
drivers/net/can/ti_hecc.c: In function 'ti_hecc_start':
drivers/net/can/ti_hecc.c:386:21: error: implicit declaration of function 'BIT_U32'; did you mean 'BIT_ULL'? [-Wimplicit-function-declaration]
  386 |         mbx_mask = ~BIT_U32(HECC_RX_LAST_MBOX);
      |                     ^~~~~~~
      |                     BIT_ULL

There is no BIT_U32 in v6.12.y. The same build error is seen in v6.15.11,
which is also missing the definition of BIT_U32. Odd that no one seems
to have noticed this. Am I missing something ?

Guenter
