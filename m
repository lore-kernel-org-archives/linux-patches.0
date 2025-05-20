Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6F22620E5;
	Tue, 20 May 2025 19:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747769006; cv=none; b=DCVbKM0mQ02cNK8jIo0Haeeaw5DX9BxW/L3Md93Hg7dA1OpAu3vSJEN4poZL5YPkIUNJS0uFx/bR+cYIq9ebmpWlQ9t3jTwACkzoSKUEM9umpdfyDj3gQ5kTXRYhtKFndH6hl8An6Fo2WFm8VjhzxRTXQzIm5DL20QG37FMkm2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747769006; c=relaxed/simple;
	bh=aMN6ArfGvBy1UBJLtxcWD5AdjBrLm6dMrbJQ6p1GdS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSsKq7A1CtH324YOOz3K1TYXSl2bTC1XuyOhk36S47gUZF8WGXe3E8Up08WAoUCahc55AdGEfIlr2zFAJI31fb/cRjzGBqxgoMLb+S4F5ISgIJv52hb0AtQICDi4OuM52VvOYRe8ySuBdhpSrVokU6lbLwOKmWGUDWnOVSQdfDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TS79f4eK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TS79f4eK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806A5C4CEEF;
	Tue, 20 May 2025 19:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747769006;
	bh=aMN6ArfGvBy1UBJLtxcWD5AdjBrLm6dMrbJQ6p1GdS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TS79f4eKq1TC0al3v5u4S6INf//eo0Cpyj8AGPhrlhGOZsN3jJkbGYk8cH4Qaopkt
	 vmFa+9ef9Ft343P07O6/IYkH+trUDYXCQTUjKmSS36B3/IB37K8wZvs1SFi0PSuRAa
	 RzD5E4Ch91HwN6hMPgwBoppKwYp0uHQu0COVm3po/Dvxr7reySMbUfFc8nvPbDXOcT
	 hTfiKOjmR5eSQqxKMlptgVLPs1oJeXcsWKmPr4S5+lDLae65k6BNXpyxx1NQ/fYNQH
	 /uL788HFQDxpS++mrywEqs05QHjFgQdse+POnMXHryL/FskUY0Rp7+YrNTrOfcYDuE
	 P064dEH7WMEpw==
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
Subject: Re: [PATCH 6.6 000/117] 6.6.92-rc1 review
Date: Tue, 20 May 2025 21:23:13 +0200
Message-ID: <20250520192313.889970-1-ojeda@kernel.org>
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 20 May 2025 15:49:25 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.92 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
