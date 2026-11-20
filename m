Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.227.220.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795193806;
	b=z5ajmg2lf8tE/pTUTJCkGyzoOAT3h50E4rl/sQyIQqIz5TpDANn7LMUFSFCOWPd0ghKH
	 b9xpoT6R6Y4krtyaG+jRCj5j+BeRM5x8M/5WsXzXU3r4q7ZisHelOweLgRQgKDDfleGMq
	 CnhtwDN/07vL0nWZx4gQbFoXzw4TJIgMgAL7GWBZoxd7KMO85S4pnOCNQ1xJ7gAZ8Yws3
	 8QisFx3fHP3iF20PEKbfmYuolAqgV3XHjvmQNw8hBph7jgFIH4M9UjVCWkUrS6wXx8gwJ
	 ZqGbt74Di+3btQoOAxX9hlxCadLG1YNgMKslVk22C2hTPyiJCPfkx/Q1reUnvq7rxCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795193806;
	h=DMARC-Filter:Date:DKIM-Signature:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=UF3tBrp7AmCGqTxRBYYwq5H6DC/5oBCZhMCinEbaHIY=;
	b=zmLLmU5O5yLwTnVB+muqipvgZu4aJWC6ThmEl507SGgzGQfs+3UhA1qs1d5Mc+pQy9fJ
	 hYqDz4BEtdQyplP0etHnX5tfznbsuNN7XAyGKjXMM1jFM9O3kR9lxJ7SO1c1qiWqZIXDb
	 px2aZHkbJyuWx0lCcvo4n1v0eqpB2z7gzAm50EZZO8NYMHFeSxzpeaFiJfGP4oZJIITKv
	 UpmOq6LMhacxmoAjxt23XBNtw0IKPZ49S20yOi9cuWpbiL0+C1blGKQ0kV/COdwypzwF1
	 7CoxuKDBqrgdeGakPcjbWcaXolxJiOjmaZ0R1Heanc4pML1XhlR9GpyhjFr1vEVXp6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mareichelt.com;
	spf=pass smtp.mailfrom=mareichelt.com;
	dkim=pass header.d=mareichelt.com header.i=@mareichelt.com header.a=rsa-sha256 header.s=202107 header.b=TDXZPbGb;
	arc=none smtp.remote-ip=91.227.220.155
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E09606A33F
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 16:56:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46E09606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mareichelt.com header.i=@mareichelt.com header.a=rsa-sha256 header.s=202107 header.b=TDXZPbGb
Date: Fri, 20 Nov 2026 17:56:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mareichelt.com;
	s=202107; t=1795193794;
	bh=UF3tBrp7AmCGqTxRBYYwq5H6DC/5oBCZhMCinEbaHIY=;
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
	b=TDXZPbGbP2h1tbiArKR5dldDCi30Ki1vMzYiT30SGjgXo6qjSWIycospiH4UXKdyh
	 Mq5PVw7WIg7Y2c/EYWKMlqHuh4VrJaC3Pa0Qohy3qB4ytm60xgpBJWY1AROZYXPfz5
	 ql/ZPjYQD1RVRrF2qe7e35hWw3AbIwwAcXZx94ui7o+VU6n9BbZ2hl5p2R6zjozMXF
	 eZIhKO8V7MHrWVe7ZpiBMKU6LUekGGcd5vLHL6M4JZOBxyoCXTO8iaA/kr2spplB7I
	 P7uoeM6UY2j2pQZxDXZhja4Xsv3nx607wDbSPLI5HiOCHBtNS7Hxi5XNTOB9FdcUPX
	 U88in7c7hfnTQ==
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
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
Message-ID: <20261120165633.GB32322@pc21.mareichelt.com>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
References: <20261120055248.913352689@linuxfoundation.org>
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
In-Reply-To: <20261120055248.913352689@linuxfoundation.org>

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2642 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.

7.3.6-rc2 compiles on x86_64 (Xeon E5-1620 v2, Slackware64-15.0),
and boots & runs on x86_64 (AMD Ryzen 5 7520U, Slackware64-current).
No regressions observed during boot & my custom tests.

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
