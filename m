Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2C7395240;
	Sun, 18 Oct 2026 18:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792347595; cv=none; b=JWMXMg1LV/3wrWwBtVsYkXfyHNQBueU1c8Vg3wYlc5uxfX9AqMuiffSbgrWvohGPhzxQJq3TTdJGGhFY0kJUTPwbLMDyRXRNOt/CZ8gHHh3adCPD5MKJLG3lmdK/5g9HymVgP8ct1kRY/C+bskkeHo4g7uJaMOtqv/KTzp3Mhn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792347595; c=relaxed/simple;
	bh=xjH/zN8fLYhvRAB90baDFXN0UkJ99xOlJVwneJ5p8wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvWMOW/z8NWoqRoe+kO/l+GLODI9hhpMhezPUN9f9XRYoAAQPm9pTZVpn753L3Ot9umxUlzgoN4cZ7wAOnrI/ojok0k22zh9r/fZs8MUgWJAbDyCLkRXCIwtcJZn0bEvrURZ7TXKDQMyBOzWD4zgdJjDBhqmky39jiXACqTZHAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JiDyzIuh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JiDyzIuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC571F000C4;
	Sun, 18 Oct 2026 18:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792347594;
	bh=Hr95qZg8wqighuNV9l8lqKCelK6yoIercusfePq6BFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JiDyzIuhSEEkq8DoGewphQfZM/OIGCLqHQyWjlZHvh96MYA7FV8d1BE9wOT/xmWJc
	 zelLNldbhT9CiSclKaT/1v0hSMGIsMiecwhMFA6q1FC+uT1Iwo/JLA/Tz3r338Mh8z
	 T7dyCLvtmwr3vQLFbyfUkWy6u0aQhg9GP9RGlf21bKWAd3f6aMHbUBCy0N72GrrAqx
	 YRxMUVunYUE1cP5f4d4PslXhFiNBsU7qly1JYMfj5xcNJ0E+JrTgZZS47FFist56sL
	 QrnZaQz8C4kwI8w8YZ0sVhuC0cGVtf9naebxDFJWkQTxREqoJh0HbZvcUJd+8TRtsQ
	 vvKyF+PDdNl7Q==
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
Subject: Re: [PATCH 7.2 00/10] 7.2.12-rc1 review
Date: Sun, 18 Oct 2026 11:19:45 -0700
Message-ID: <20261018181946.376674-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 17 Oct 2026 17:54:29 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.2.12 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
