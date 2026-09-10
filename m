Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF003414409
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 21:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789074500; cv=none; b=Za7AEA8JnOZSdhrLGaB+ljQe/FX5bJhrE0AC8PHJ0U7dhmvIFM9qqwgGJ68S34HVwciBWolu7eIRxKC8X+B8ac1Tgnf8vzTvxTp7Swgx3tueg1fLoatyFol2Bmfx/L/2pvzyJ9D6cBAVrQCTE+aip4Gd/U5XXs9kOxebqI/Zjlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789074500; c=relaxed/simple;
	bh=sbVTlb38J1O5Bk4QlUeLcjkWEWVtQTnkJZHOFKn9/Gw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EL82dDZaNhPhA0ktEkPigxZ86B35gBXHCxaVoQpy4YSr2oPA7tVaRy+RY+68yEt7Ju5/14aB8vROP7jc/i5LLQlL0VUpyEw/xWGETFKDkQyZVDtHendfnINNwWJhqqvSCBn1yZVRN8sgc9F3fSV93iUrsmAoL3NXnH3eehGPlYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=joXq15Eo; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="joXq15Eo"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4hgqyd3cKSz8v1p;
	Thu, 10 Sep 2026 23:08:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1789074489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VZ2uv/XZd6dkl9VRfWfT3lp6ZKhNUYXM3plJ72H6MDA=;
	b=joXq15EoNn3AU3RK4FKO9RWUK01Ra2mMA+5g3IXXFQjejVxFjPmU/sCblplgA3dafdE5O1
	s+Xq0LO9a3pVDATpvwM/ZMLhN1uWonTwJa4MNGigDoiXHNXA92SiMSuxz87zi7X5cSEBX3
	kRD1mVkFin1yPSpBiNXmg4zP1lNm9/WrZrMbQYvmIYNDQCVxa/LdT+ptSsDZxrp4yP9ujI
	b2CFfwcLUnxfCXvUAydlM/JCFJo3lWp3hFgU6tsWX9K8jFTt7iHj+9KD9F/gKo9kykVFWe
	i2vv8ns0qNVNelnQnoKHz5SeTD+2vS9MgmbABmWhzLMGGXfICiNVzxSAx/sYtQ==
Date: Thu, 10 Sep 2026 23:08:02 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/556] 7.2.5-rc1 review
Message-ID: <aqMbwVNlNLC2Jdnh@bb-82jq>
References: <20260909134230.441546314@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
X-MBO-RS-META: 6rxe9q8sqqdcnwb8zausftb65ba3iki1
X-MBO-RS-ID: c4eb3d609c4d3c6f85a

On Wed, Sep 09, 2026 at 03:34:40PM +0200, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.2.5 release.
>There are 556 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>
