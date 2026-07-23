Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D197D4908AD
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 19:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784833445; cv=none; b=s7+zdTbOKu48LUQ88/VmF3J3JaU3K/JZMMeKHqceiVddKPFXEPgEQCC5wSq4D2iP6WZhpShD20Mgx971HksOKRWXP/CaP4j8AffOpxYOLdXjdPZCkUHzB3LlrncecCU/CrGMP8zGg5PIxF4FtE1hi1BzgPxoKmoaaEZl3JWGVRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784833445; c=relaxed/simple;
	bh=xqkEes2Sr+uqomYYX2puoB0NFCWLBHQ7JfyhggUMl+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYWHIyIYflhW2UA+IeXBSrh3Ox/iMMVaGUdLnyw3IyGiUr40P9FLXXXfHKyvlUAakalYTM1Tad39eJDvq8P4A2VsKhTdDCOTlm8XznJMCEnGIHIPkFnhqjP9f9J1/3NgwoS59Ju6cayBJKug7rX7ccWBdDhhDt1kLshkn8fsco4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=UBs9cZJb; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="UBs9cZJb"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4h5gWq2LkHzKn65;
	Thu, 23 Jul 2026 21:03:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1784833431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RRk0vriKs14+09h9t4u0WCXxYxcGMXop4UZw6HoprNs=;
	b=UBs9cZJbrYqfVowCJ83otiuTIUIC4wnKyz06Jl34PhWzDnsx+IdKbv2vlfp9tzsI9vU266
	hyLgYg1NnIhbjJ7idMG2TDvviL90KA1VMALITtGt2FDPrgkgfkvcLKtVgoLKR6KoJiRF4o
	FH+6owf7+nNqb6kODtV7ork/KE9f3T74re79aMg/Chfd5/KF+F1YSa39OgpKn8BTetC6ki
	jRWp8KwYXGyArVT8Ke5N/gKVHv4iXOSG/U2mTNnEggrad2IEteEsL6D0wrco+vwC4pabkH
	UmWiYKCqNsJJ4ElOOEmZ/Sfjjz9Ta0+Dc85AG8ZyZSDF0bkidDofoNyZxW3VDA==
Date: Thu, 23 Jul 2026 21:03:44 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 0000/2079] 7.1.5-rc2 review
Message-ID: <amJlVJqZPzYc8hWJ@bb-82jq>
References: <20260722142947.085426486@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260722142947.085426486@linuxfoundation.org>
X-MBO-RS-META: 3cz5yifgz951g1eg67f8prnaimwdseuk
X-MBO-RS-ID: 227e5e6274c8a0c67a0

On Wed, Jul 22, 2026 at 04:32:05PM +0200, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.1.5 release.
>There are 2079 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.
>
>Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
>Anything received after that time might be too late.

Build and boot tested for x86_64, i386, arm64.

Tested-by: Benjamin Boortz <bennib@mailbox.org>

