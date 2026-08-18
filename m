Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1226F37A488
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 20:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787084020; cv=none; b=GJeyw+VLiN038cmc9LXGyrY25XzNgz6lrk+jl3zhhv9hzpMaNsaTgfnpeZfrOQZi2RkCEv5BocPUXxoAcQngkGHu8jkZglXbMS9krg6uAMwC0WmC4GjpqDd4oqQkvVL9Rys6SQ0XGM75ytP6T63Y60bLfDP0CB0rxG9I7te5Q8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787084020; c=relaxed/simple;
	bh=eZjAup4eGbroV0/OaH7ZmgKjzK88pCs6o/iA8k1eXc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OtJ32kc9C1hz+4MQOx2/HBPeECJO3Bv7OeeQ7y2gPW2VRLkUPFUeFS7mxqs1Z9S7mWB1U7CfkcTHxCUPEkpqVaPVRQoGLzVngH0QRmkuCV9QYm3EcNihxZgrzWfHEZVwiz5s+VfKx0f5X3pp8xN3s1m1bqHAnrtXuZ3pw6LfxXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=ibX9YUX6; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="ibX9YUX6"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4hPgr93VH4z8v5D;
	Tue, 18 Aug 2026 22:13:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1787084009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jD8GR30d1Dcx3GqaVVyX5l3MiNzwY2T2qCzTizitDzE=;
	b=ibX9YUX63zrkKFqf0BKZ0ZjMzQxnT2SR6lZpB2cOdQKyv74J43UjEfby/IF7FLQ2KiCUvW
	QpUvRRpbKLkKkKz5x25+IYAHugPAZtnXi9Q4/HmZWAhoHWLRvTgt0fC/RV/dZP8M35poxX
	BSDyAFAreWX1ELLt3jWDqP9ncOgqG5Q/9Frqv4OPGiqvdYUKlc9rdTwtwYQWpGxSoZx7EY
	fFWLv0fPlPLWxrHL1Jpc7bKO/3S4ySoE7cYxf4AqEpSXFxC/iBn2FpzYGRqWtVo78cS4HN
	/CWlxu8qa2Fh8b2VyYWCwJHcBOwtVvk///zJn6JczMEGtFTSl9/3ZoB4x5Lp6w==
Date: Tue, 18 Aug 2026 22:13:21 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/271] 7.1.9-rc1 review
Message-ID: <aoS8d-lhZFJoBQQB@bb-82jq>
References: <20260817132536.752504388@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
X-MBO-RS-META: ueaoj3hjon1rpquib78wtsnxk65iiiug
X-MBO-RS-ID: 3db4939b4158daa1b75

On Mon, Aug 17, 2026 at 03:28:45PM +0200, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.1.9 release.
>There are 271 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>
