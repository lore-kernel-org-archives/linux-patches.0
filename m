Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E0B266A7;
	Wed,  9 Jul 2025 15:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752074178; cv=none; b=Bwr8u9SnHUeqn+pM9oG5OPV6FZYXtQTy+hbvlwTGOJgalQVYrtSQgCO1ur395lGhDkR7oczG1fWXX9RIryamTuD09XhqdkZzspRUIfS7CzxCTWzTeeLjaV7El7hN7JA955Q9JxWm8WJC1ToYOB93Kj+e2kQisu63EXmzjCHSppE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752074178; c=relaxed/simple;
	bh=FafOrDaNv45R/bYwkrA8BWtU++g4AyrU5XWfPCnWKI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMkW0yV64QBwZ+lFj9+l3UOCAKU1jOQlIcw7kipCJY9Sm8LOmBmJJTnDIbd4UpLYnxOil/so0rcl3FBGqOYf2bCf4BlqTuNXYf4HwKUvb9a/84vZ/updMgOWC0g7mBRFkdtEx5ZCb+dWPZga2T1nNY14/9ry96bKBMv5jpt2W/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ThF4fCQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ThF4fCQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECA7C4CEEF;
	Wed,  9 Jul 2025 15:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752074177;
	bh=FafOrDaNv45R/bYwkrA8BWtU++g4AyrU5XWfPCnWKI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThF4fCQ6DfJxlyWS8b6f+jIsAd3LK6W5df0NoUFOB+ML+KFkzQL1O33JjRClszKmz
	 jTvQ1YN6Tq1fbXJedzoIC1BF+L54h7Rqkgv1svhyolyCSwY13Y6Andx0vom9uEpS43
	 LR01N2x2GEWs2BU3twRfr+YVgW/xkOUzw5tXExFkJougWlodQcuyteWkZE94/h/b1s
	 y5IjMnqwYJ81UKeIn5pnZW1T/U8oyHXchuE0rAb4dPafECU7D+Lh3vFloUXILquokh
	 5O/6bcS8AW0JUK1PeGK+LqQa8mWWxfen4LtcleRuBbjvVEr+u7VTpXtDEPQyT+1Y0c
	 7gFoqcoTnB8aA==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.6 000/130] 6.6.97-rc2 review
Date: Wed,  9 Jul 2025 17:16:05 +0200
Message-ID: <20250709151605.840617-1-ojeda@kernel.org>
In-Reply-To: <20250708183253.753837521@linuxfoundation.org>
References: <20250708183253.753837521@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 08 Jul 2025 20:33:42 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.97 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jul 2025 18:32:37 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
