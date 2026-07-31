Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D7738C2D8
	for <patches@lists.linux.dev>; Fri, 31 Jul 2026 18:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785524274; cv=none; b=ncXcck3SxAiG6aTef0izYnK/bWPBeny5053IyGstzjr4knOEKJTm09y+uXStyMyaDk4AsVGu58XvLRXc3Jo2mrnNVDbQD77M4rEJevS2Bv06oFtvaHIRvNL/V6zj2xO4RTdrHOLtCK93yrBzexBpzRh9zFCC2qTwyK5L6E3a/uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785524274; c=relaxed/simple;
	bh=Hko3BJeZwp+HGAH3hd7xZ7UJtDZCNx48AOx5Wrv+K9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QbLC5YBmViIoig/PoejQ9EPWow6YEGHV7payLQYjBF/CUZppkc9ZGTME9T/uDo+vuAKtjGqq80JCo9uA55UvbfvVBDUPrJlwvIrFTXrYG7VcGlH6Scwo5dHcdVdXPY075EXZidnnshWmIaaXJLr49ySuJRW5e6FRpfTnWlk/naQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=ptlgBUTj; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="ptlgBUTj"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4hBb126DhqzKw1X;
	Fri, 31 Jul 2026 20:57:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1785524262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4iJMtubR+SHDe0LgxOq+Qn/Y1NJqEBJQpXJFnFHrS50=;
	b=ptlgBUTjSL+n4ZWg37ww9Ve2CKUDrfp2CBaJ9l3f+MbwfnkrE56Q9hNVYiJr27e4IT+CM3
	cHGJVKgRcPEOX/Zp8mGR3PgeXfEssKGw4TiYpbh8Io3DV4Xw8EFfukAw4v3JN1KPzeM759
	JDo6SAvHixf3qA50dW91wGAzNb89tMHlclVKpcK84sLFAQxIusy892bLHscy5jjis4cF9a
	GdjdK6CZ5etEBzPde8fxyTdzPFm3PXGX3CbYUPjgADquHdjKqlpg7PJe2TG1WX8VGrweho
	kvhbzQXwl5jOCpBn/6SpMzMhG/ofcPgB1zHdIpfZUQ4POI14h2njMenGVsE+5A==
Date: Fri, 31 Jul 2026 20:57:35 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
Message-ID: <amzvlD2Npdj_8Zhm@bb-82jq>
References: <20260730141444.267951807@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
X-MBO-RS-ID: db423c81f70cde1e56e
X-MBO-RS-META: ykzk873bpdwgfocygogmuy5gyppjhh5a

On Thu, Jul 30, 2026 at 04:04:33PM +0200, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.1.6 release.
>There are 744 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.
>
>Responses should be made by Sat, 01 Aug 2026 14:13:38 +0000.
>Anything received after that time might be too late.

Build and boot tested with qemu for x86_64, i386, arm64 and riscv and different configurations. No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>

