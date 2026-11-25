Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617945;
	b=aQqA5xLiS5ZKboiDffFfv/ijqQxKdquk/jglKYbM7ImjmTcHqQibZstv+um3vDbhpA9E
	 H9OV3pK3yrFnQoullae8Nay1hc8nzbO/KZHaNZvieexuOAvQ4TGWRRX6MIy9+X8tOBNcV
	 noKkp1b5OgbGWEeSKrq5sUgozdWkPGmYJAQw1fCbyPeZk1ThMDFibE3otYxnODCEf3pNJ
	 /xze2i06qCtpI1pihoWYG3DX0Hi77tvyMzyHDK5dwYCTlgDCag1yDKbJYvmj9S9GKKE4X
	 BNI6nk9CGoyriMZB1TNny1VJ8kScids64SxfXXu12rrlmZgWsWs+aOMSwHE47gkUZjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=z8PHSX1qp510J1VwsmvP1fwtXZT9J4eSYikYFBir3fA=;
	b=tRKhSkDRaVRXllWrrV5t+DwDWgy2wOJNO5F033fHkNBJnK/GaAfnlze81Oupo1+ZTcq7
	 ioRGyGgZRSN3Q8tm+ljzUHG6aidBLJ+rvaccFtF3vR1AmEPoT6GoDnbXR+2OGe4tor14b
	 P4HUYBfov4uOT5QKr+ALEoV2/yRmbFLawlDbjoGIa76pHsh9N6IB18S/KNm9RWYBWosUY
	 aK01+SJYZTuDtHZy7gH1IzObEg2/VHMGViRfqwt5DdfQoqAo2+ZnuRW6f680DoyFJHZv9
	 IP0LAIW/2Uq4bg1HYRHQOug2LiLD3gcf3fVIZEY6+6wUHOmr8h0qwHw8oqfXitEwSPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RBSYnCKI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D87606A321;
	Wed, 25 Nov 2026 14:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RBSYnCKI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F4E1F000C4;
	Wed, 25 Nov 2026 14:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795617945;
	bh=z8PHSX1qp510J1VwsmvP1fwtXZT9J4eSYikYFBir3fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBSYnCKIRh55LgWVywJ9Q9E9Ki+4JJEpI/OxpAc3hPOq0OgAh7FFz6XadUtyk6LRy
	 3hv4Ppd987Fy3xavzDX/p/kgNLsuEw5PsIN76yqOSbsl0UC4OE/EMaC0ELWyEKfQQ+
	 H5UUM3AA7iN562qFOjngIAmNUN0FUTp8/TZD+weYn7KiEZGZ3sk67ncVDwKrnlCCvj
	 39TfPNM7QtF3ZHhwnGaDkAhSVuXcQZeLdJzZN7EUZS9gShT4OYvTKv7NKnY6DL1cqy
	 L4ZREjOOJLA9SbJZMHQed6UrpnwPxFCXoLHYuoImJxF7pgU+FdnHFijHZvars5TmhD
	 rM9EoAnoK/KPw==
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
Subject: Re: [PATCH 7.3 0000/1005] 7.3.7-rc1 review
Date: Wed, 25 Nov 2026 06:45:36 -0800
Message-ID: <20261125144537.89279-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
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

On Wed, 25 Nov 2026 15:22:18 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.3.7 release.
> There are 1005 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
