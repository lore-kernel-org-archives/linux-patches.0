Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793285412;
	b=yqqxNg6vzkPDJW29wrU5KE2mdsVuC3CiG8Tt8sP8vcBMEIc6yHKiL8j8drkQdtkmvVBO
	 gVtMAmiOLzW+zFETzOch091VrrxHi7eoQaagKtN9jit5K0bt1nk/sin/6gAEB+WK4k/wO
	 vNR05Zy0S5PevQsaYhQutwiePx3Dm4bj/UzvmH4shiMHmZ/+DGtZXnYi+3CmPvnlaxhAf
	 QN9UdaxH9YLsMhGyrqXUemyyQIMnnC/xXLHYMg2Al6yWYmBbSXxCSCZjQLHCDPhB7jXps
	 aYOV8qL+xxFiIWfR7Ruxc4z7ZaBDcpT8v7duEPZd9MEofT079RA9DEmC+fqr6Up+9ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793285412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=kWqnO1UgfDPN6rS/8LTd8UF++MMyI/O7nvnh6rAurxI=;
	b=AgdYK25fcg8lNA7BbZDflzE1trABT4rMJzfEqoBPV0nFEcJV80Iw94h4zZqlHrYJ2wsh
	 xEi67wtVu3Ey78XW8QQHK0FyO1xOTUox5sq2rAMJ3Dj/uCPlvu9wQPRBKDNgXM1aefjsh
	 XQVr8QJtsnedq5s+VGHLWfIaIhDoUtkWwvtV8nxI8JInCsGtulm9TOH4+HYT0Po5SQQhs
	 ctdOjy+Vg38C8eqp2Asj2mrrv4f61/YfB8YprqIupiGOQAoRlKot47LoLizc39SfvMkyb
	 UTF0XY3jXNwY7hNBhUNG3yq2W4s0fwwblte8C0b8UzDIUuduMYOxoN19OWpu08ZN+Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MkKzF8oV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC414606A334;
	Thu, 29 Oct 2026 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MkKzF8oV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4FF1F031E1;
	Thu, 29 Oct 2026 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793285411;
	bh=kWqnO1UgfDPN6rS/8LTd8UF++MMyI/O7nvnh6rAurxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MkKzF8oVgUpOyhlKRdLy5XYBlbdSx8MoD4XPloC3B18kh8lIR79ma6y/MdxWev+Re
	 NXiEpQxo5Kt8q2Kaf5d74HJRdVmgfyoKn6iAvohWJHB0RfBf+GzM3+LSGrxm7NT7E2
	 5GPVY78QoQIPSyY6WGZjDoDCXkbQLvpKCKKvH4p4HSKV2WZyH3chfSVAY3P+7+k4Zu
	 FzHP3Tqxc/OGbMtaC/+gAmgnVWHNBnigd/6L+Z31rWb6u2b+E47ZAdmYgLOy2Dc5jv
	 ZrLls7xnoda9aJJfmqUljhnZj0KxGdEcRZLboGnmmWlPOijoQU7YlEIM03wA1x6JnI
	 Uc3v1hyjkk6zg==
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
Subject: Re: [PATCH 5.15 000/571] 5.15.224-rc1 review
Date: Thu, 29 Oct 2026 07:50:03 -0700
Message-ID: <20261029145003.150545-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
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

On Wed, 28 Oct 2026 17:52:27 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.224 release.
> There are 571 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
