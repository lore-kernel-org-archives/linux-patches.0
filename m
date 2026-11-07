Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.227.220.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794080048;
	b=qRu65gWGIT+3amMKrZPbJR5r9PFLkC+ZtiDZNOunfzB2TBB6YRxu9M+7674/VjJPanSs
	 LwjjkjyF98Aa2ZFPOfT2XfCkcA5Nm7SmHhRavQRrpAog2kthN6duB8rvhaNbRdOPu6MXI
	 9yCgx/i4fNGJ067W2D16mKhhbD0uqKrUmRFKLyJBN+Q59LHM3TclhFg3UeSYCxL89cQLn
	 eI6zkx7g7GnbIL5g0xjcgZYsJlNYo1DQpf2JjHzWFBJMsG9di77ULXsLYZbzRWGXcO/20
	 uQnk5dYDFFlP+Xq2NxqenCWVLlJnvmLTDYVcbBRvWDwRmxU+SSw5VdNIQMXAkGCP0fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794080048;
	h=DMARC-Filter:Date:DKIM-Signature:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=iSm02S9UFPqyxcXJfE/yMCdmauGWZNHUIjvGtZ/NnKU=;
	b=XUJZmVgj6tVPalamXf5pcJ1PFF2zjo9gkJaoDm07TsYNLsqFPGcVXxSU3AVv2bAOmdrf
	 zp7TifpvxFqtD1HjwRYTTv6C5vQ3kETuWnxCYkzI3XxxPZ6gXjObapMm6tpkxPqFI9NOP
	 FlfgG0NyqNLN4rCILNq0qhnz86iNR10+MLHcQ8udFLFLQHYFrZQD++wuwyMgl6xLCbR3c
	 WzW4jz82QBWNtq77r0uwAA4p6argYmUhAYHKf4h8Rj4ILbpNmhqw97iLN5ZTLeAcvHjcK
	 vgCNdHj7c2nmnaJAB/FHqiEWk1OEua/lyx4nLAN5ujgB/jLQDlnkt1HnLxxVK2yj0RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mareichelt.com;
	spf=pass smtp.mailfrom=mareichelt.com;
	dkim=pass header.d=mareichelt.com header.i=@mareichelt.com header.a=rsa-sha256 header.s=202107 header.b=33XC+mGy;
	arc=none smtp.remote-ip=91.227.220.155
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA9E606A326
	for <patches@lists.linux.dev>; Sat,  7 Nov 2026 19:34:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BA9E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mareichelt.com header.i=@mareichelt.com header.a=rsa-sha256 header.s=202107 header.b=33XC+mGy
Date: Sat, 7 Nov 2026 20:33:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mareichelt.com;
	s=202107; t=1794080039;
	bh=iSm02S9UFPqyxcXJfE/yMCdmauGWZNHUIjvGtZ/NnKU=;
	h=Date:From:To:Cc:Subject:Message-ID:Mail-Followup-To:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:date:
	 author:from:to:subject:message-id:in-reply-to:references:
	 mail-followup-to:openpgp:mime-version:content-type:
	 content-transfer-encoding:author:from:subject:date:to:cc:
	 resent-author:resent-date:resent-from:resent-sender:resent-to:
	 resent-cc:resent-reply-to:resent-message-id:in-reply-to:references:
	 mime-version:content-type:content-transfer-encoding:
	 content-disposition:content-id:content-description:message-id:
	 mail-followup-to:openpgp;
	b=33XC+mGykPVMszVlywKf/jjOHp5XTiedLZF4e1fTb8HbS5AtU2UN3RO0ez+c1EjRK
	 DC9OnYYVTawu0zRm0NYsNQB/k4G3+A15KpSLBWaAYQw7moDVG8XAKm1zAirljB1MQi
	 eUrXHuKxKlGlyBgquCKMXEVpfPszguhHQMKCwc/rkbYMnHmchPJ7v1l01FNy35Z39A
	 9sQZ+jM4C/Afxv9pzo+puukdbjo9Px6gr3h9RjjIm72hU3Tx86GhCbs2anlG0UZG8N
	 d4kklCVB+uLztThKADVQUZVbrSSEWurJ2p3zaQVj5jXndMFuZejKhhS9M6IBbyYpSv
	 kUc6Rz5hSR21A==
From: Markus Reichelt <lkt+2023@mareichelt.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
Message-ID: <20261107193358.GA6808@pc21.mareichelt.com>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
References: <20261107134939.434104957@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.3.4 release.
> There are 1257 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.

7.3.4-rc1 compiles on x86_64 (Xeon E5-1620 v2, Slackware64-15.0),
and boots & runs on x86_64 (AMD Ryzen 5 7520U, Slackware64-current).
No regressions observed during boot & my custom tests.

I did not observe the build error already reported in this thread.

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
