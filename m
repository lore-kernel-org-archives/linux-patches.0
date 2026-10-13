Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCC53C13EE;
	Tue, 13 Oct 2026 14:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791900857; cv=none; b=sIHd0xOBD27xIQ/ubyX1oFqbcmbJgQ9lGk0HcCO7CKrtNAABOgMEb0f/hoTtOUSgu5ZPS6KRfAxSZxx3FEPQYqxlEN+T5TyiLb11COMRWclUXdKcz6ctFGtFL45kcvpnUBemkMbUBpvVX9eLF4YJNRCOQRYo+Mt1e5PQxyPMFTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791900857; c=relaxed/simple;
	bh=1nBqBx8TqWNOjEvH/WES8I0pZ0SsukrRFsMlrNlO+Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMtTRi2Ms462D6crzHOiuw1vexuQIqKSGkeFwFwsFgbvarUrcSUvXgXIdRKrCaVRFrZtVsPWukCHC5CT3NA9i75vK4HWkOMipiKzmqJ4fWl2HFlqmxlyGWMq1FIjK9PWLKrRac7+31m1AU4xhXQvZaL2w0mnqL7ngNPg+K+2aWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LbxRxs1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LbxRxs1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F43B1F000FF;
	Tue, 13 Oct 2026 14:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791900856;
	bh=CW169wUSC4LBvuyho8fVwdKuExUFBNWDbjmLeSCNwgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LbxRxs1AAinc9+ONYGy0hCYZmHRwnAq+mpZ2dvj/atKvideGHT4GNS4LjpOOCb1PY
	 DQDZSZq7nwkAsjVIRPbEulhT3q5f3BQHWF1Mlbv2Hn9UJnYkabBbj1lbiB6Mij4qPv
	 S52ETu3w1ZRpYRdD4PrCye5js/C2Th4IHmpvkEJ1zWK6woZP67531pLtTjw1w3G8CR
	 KWNx7D3DD74myz8YZjuF9dnhwiZZOePMXEywaiEsitDEnQkPN5tZkJREjL+KC06Yde
	 hCOI33DUi4OXrhgXY44QTUI94zQpfts1GmN6V7js655L2nPn0RbG85+B/K37qCPM/v
	 xiZ/0qkZ/TOXg==
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
Subject: Re: [PATCH 6.12 000/497] 6.12.113-rc1 review
Date: Tue, 13 Oct 2026 07:14:07 -0700
Message-ID: <20261013141408.139524-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 13 Oct 2026 13:32:47 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.113 release.
> There are 497 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.113-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
