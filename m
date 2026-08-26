Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFFA3AAF58
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 19:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787773144; cv=none; b=MJEEZkYETNguUxMiNXiXy2JVpodrVjibDwCV4WkwlTIpxXnZL0rArvpmZKswOwCPPsmofhw9NGfuq4W2abok/AdzYeqzyErpuEQ2AJxL8kj9ATxPiV6iiC3Fq3RtTN2VJL0+ORdQRJnTc9t/wGY3eaFAk+QBeNYtz1ePmdHC8GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787773144; c=relaxed/simple;
	bh=AA/BGTL2S3XMxwGg/58Czr8zL32xkEY+GT6/oyQl3mA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/1VSTsDJZar5++oRKMyyZBDBO1V+OY14dUxb445HJea2eP0O55PWJHp38+3XMP1RwOGoYvZCVM0ZY9LG42uu74C+PRlyrbvJnBclBjuBiqZgwhRvAPPXieni0jE1zyFPiiU+ddqrS1ThiJAMe4UDTIGUcLhfhTwY2HSe37r4rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=oy6Esnnz; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="oy6Esnnz"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4hVZhG6L8lzKmKj;
	Wed, 26 Aug 2026 21:38:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1787773118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MA8xgY6lFgswJaekVKairbLo7hXjLWI2za31UoN0A+c=;
	b=oy6EsnnzwpsIy7TZ0LBrCKNAS+K5XC1dISOx27mp+WZPkqXzlFkAZv6oIGHWx/CzXxEDN3
	cvZz6Pmvc2bRhJgJ3hn9Zq57cisUtu/+8JiGK4t+fFeuR8MRZSY36l5jXYwszbQhofqzp5
	kjrPYCIZZAFejZz5M5AzGzmcn8MVBSFcTlG/mVrNYrD7R+VXS8UzqKceMqpNZaWUBHyQqI
	sQc3CfdlshJnbHI8w42373xH06x03JEFtqW6TLWd5WEpIZWxhznA0/tIv3IMtOJ2+zGENo
	kczN24ZpwMLPqRna944hhOMSrcmX9cvrGhO/oJ+i3Z5gRpptqraegf5TNnlLTA==
Date: Wed, 26 Aug 2026 21:38:31 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.2 00/82] 7.2.1-rc1 review
Message-ID: <ao9Ac28NYdh_88vX@bb-82jq>
References: <20260825132541.560541185@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
X-MBO-RS-ID: f8f17d60210f8e1f026
X-MBO-RS-META: n5krh63ypba6ncahwomuqo1ti3gfpeta

On Tue, Aug 25, 2026 at 03:24:47PM +0200, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.2.1 release.
>There are 82 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>
