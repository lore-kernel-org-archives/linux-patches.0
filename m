Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FEF42E8F0;
	Sun, 18 Oct 2026 18:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792347768; cv=none; b=dOi/2fZzwTyYXFgKuaXTP3Q8gvwU8yaTgz99WSnaBHLW3cq3/LF6BtvFfGwyVXViG95ESR8RyOBCwQcwVPow1QMNjwH5NJ0hdWdjK9UsjIEn3gLaeBI2/gZtnXGx6teIsA7kFJb8dbh5qh0h0hqe/2jSJPk2WgDVO7+xIpfxJbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792347768; c=relaxed/simple;
	bh=w3f8nnOhrpDvKnFy/PDsV54pX8IsNy9Gy1aojE3/sqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiQqADMbP2QUPSgRSDErczTe0vh2yGg85Wi6sZOdIih04HgW87773z/iFrzxwB3lzA4HC5i8VaQtu6498lGJRixnXnreidk06WwkcQioCGJvXgtbhAyjbb1Zwlj6iqQ2RL0QEAJwJw3NZsBP38pOSd9twNCUlZ49s+O+pK0CQnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RddeYA2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RddeYA2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9561F000C4;
	Sun, 18 Oct 2026 18:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792347765;
	bh=4EC4ZAqnkcehz0PXUia4zuS6AQ0G5SF9jBU4dORYNIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RddeYA2djG2gV9OqmLzMnmVMA1gE43+Pee0UgBgEMqZviJ3tNTrw45vuVVNc3pr7j
	 AmvwkspbP7fR2C8nC5/tmZn2WZv/aOmc0SsHEsPwlflmNeFeMmvDmFpSGj9BYD3TiC
	 Ag5RwVlvohKU6aXWuiFcPDdSb0a9OGrC/6+UstBinH5675XVWOmq5j6KOXaFqR9AVA
	 FXyE5Ddzwp1+TZjpmdNAcVPfBTXRUFgMWjErQ0SMgiryvH80mQ8a86Ad96Z7dalRYG
	 HhueCH5pkhx4i7TSiN8D1sHlUVvWeiONgok6i9ygr3GwnhUje5/t6a3l12YHwCugw4
	 /R8xYzfWDFDhw==
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
Subject: Re: [PATCH 6.12 000/869] 6.12.114-rc1 review
Date: Sun, 18 Oct 2026 11:22:37 -0700
Message-ID: <20261018182237.376990-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 17 Oct 2026 17:47:21 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.114 release.
> There are 869 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
