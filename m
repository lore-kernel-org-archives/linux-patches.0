Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C32735E1A5
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 19:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787773175; cv=none; b=LFk8n5tjebpdJe7XkpR/sh8OpC5LkD8WDbqz34BF7OQjyIxn8OuiMR7jID47Z/m20TfRfwnTtU7okrvvumkZK7TmDjT1DIOKQyM60aTBjljm5WzfpwLpe3NsrEqefsSxnVx0VwXR+/sR4UxtWhqO6C8fccwxSYmnoRNynM8A7tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787773175; c=relaxed/simple;
	bh=skEDRxBctVPcHpLPAZFWr+DQhZJUM12KzvSYEE0v1z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujSxPdMD2qFBEpBGn3Dp7Ikz5vK8Mkxu1kbSSqB8kuVk/WlfRrSlrMdUgMjwuL5p4orsqI+N7CAT44PF3ba92TGlZ17gyF8/6UTjnaBgy/g/CxhwRyu450vCL6Jb6Pkb3L9BsKUDZKkGQ3Qx1Kwyg0UH/s3HsPggie+Y4JkDotc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=dkaMDHos; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="dkaMDHos"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4hVZj00tw9zMlBB;
	Wed, 26 Aug 2026 21:39:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1787773156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U8OdF8TfuY8EBOwjQouk+UHE5SoY4gvqYtzvwGUl3bE=;
	b=dkaMDHosBNcqGweg23nddqvt87ReoBvosMyBw9F4p/lzol0hNFY2TDrLWwZf31armayQSA
	C5IDnaD16qBbhOUjErXO8ROOU3W2IB4w/Ceq6ATSzUtgat0Q80NeMSyxorkcBQuGSbwE6T
	m2GBYq+AYo5XnHFZVyTV/+DZQ0q/T7dANtW1/X3MU28XxJU8AMIXCpA5+6NUAnSDMqmDHB
	GXEmUsbcre+mahXMjruSFSLhp4Lny4xXsTZHtwRHbMqYEiDXFcjhRuPXRbUToAssoUVDUp
	2hfntUtx/hXx4BF4E892uZP+NPOUYTNRdWQe2CyY68HLt2k/X1iSNyontNPSfw==
Date: Wed, 26 Aug 2026 21:39:09 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/101] 7.1.11-rc1 review
Message-ID: <ao9Axe1RjN1UQJNW@bb-82jq>
References: <20260825132541.986300899@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
X-MBO-RS-ID: cab39988496e970a0f7
X-MBO-RS-META: arnita3im76gb4pcm5e91jrk47qjb7g4

On Tue, Aug 25, 2026 at 03:24:38PM +0200, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.1.11 release.
>There are 101 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>

