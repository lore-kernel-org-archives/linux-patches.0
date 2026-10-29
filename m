Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793285285;
	b=TQi3SEEu3UYvIM+b+H7BHEDMG1c3dxmVXvQ7Xj3kWx3zpy7gEUSxlcYPoEzAtIKriGwR
	 drdyxRMsHwrFVq07W7zmYnWCfBn65TkXvOMe+rTop++s4/pGI2YJ2jVWgxE4XD5/bsGyQ
	 OZ0jerS5kBCxi30YB/2BKxrkpzsQIovSSF3LV5kTP0pfjQ2DRZbKbotNlJ8XUMCc2QPOo
	 KyXZiUmZ5VJXZbp6DyBatS/nPkd0yjE1dszu7VBSfgOPjhAmkjlpb2PbZWDQeFcdSvzYp
	 eHCvgC9MCXmGxQzeHJICpwb1OTUQ/8v67owwTe1NUeADGoMs2ewbFFRG+B8baQr0iaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793285285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jB8BfScQMXTgXSxZvQoXCx7WipvdPQJ8tFcm6t/PrMw=;
	b=c6VMkeZcFYeRGkne1EW36A1Io+2tH9mYBrUjcHFYZVjv24epzmi8dsZZV6j9djmSZazw
	 mddIb9W3Ifbv4h9cumxUI/ufhT8E63lihPgl3dZSZQD5/eimDQnLrnrpnBFyuWz1KNiMz
	 6z08s6FIhT0oJ6cIZyok7CxIO42UvJCNvAoT0TzmqwFFx89sGqef5Oq1LsbrhXkFRx+aF
	 FHHUNztwilAm6yPLUK3kiBztXWndWGz8SGtSHfj0wMboe2R+jwHKCnqU72lrf5olhb2kH
	 iHOE7EybgugFnyA4wBgJEGuIUHlyvYWJF/qOFKgpDD0WP6JAqJBNlNXhllsc75XyGNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jJ9cr+X1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C386A606A31A;
	Thu, 29 Oct 2026 14:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jJ9cr+X1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25CC1F031E2;
	Thu, 29 Oct 2026 14:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793285284;
	bh=jB8BfScQMXTgXSxZvQoXCx7WipvdPQJ8tFcm6t/PrMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJ9cr+X1yYxGB7RG4hznD/dDZ4WvBkrCk1l2dhsn4NPqXuWBiv8P38DDA6HizGKJW
	 BzMFxurX7MSECIyLC3bQRCrlthBhGu7A+U0lTOAFuqlaVyILEWhA5RfKkstI91hnqF
	 q9mAT3BKBv5+OrUAqWucmVr3a5gAChgwFi09qwe6OG822M8IYgf18SywrFPJ0c/OpH
	 x3+s/nfgfH+Qkuub68vHx1X+FpggOGFBSwp+laeVDdAgA0yxiNmcbs1PC2LOtU7Jbi
	 vW+PycyFi/bsx/pOK0t8rL4R5yI4CNeJqoG7jpwEGT+sATyZkoZNzSozDsplGJIaRY
	 l5lWRt63VoqFQ==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 0000/1879] 6.1.191-rc2 review
Date: Thu, 29 Oct 2026 07:47:56 -0700
Message-ID: <20261029144756.150394-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029073135.159947193@linuxfoundation.org>
References: 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 29 Oct 2026 08:33:04 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.191 release.
> There are 1879 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Oct 2026 07:28:30 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
