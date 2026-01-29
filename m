Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5DB25D216;
	Thu, 29 Jan 2026 20:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769718868; cv=none; b=bHgYuzXV5eFlguSG1c43tS4lNAvyHKch1pA79Kh5emGd9qgnykc0P6OV979S01pHTRxH8LzzpTYWnfBZ9yNeGjZCOTdkq0GsuZbLr9G/5BLkiP0WDpJNBJOAdGITlHbGx5Vh+TKhR7ozWuqvQ7g9MuS5yTzsBCvXdrjO49lwddM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769718868; c=relaxed/simple;
	bh=lpREL73FoGx1jd4AkVf/RAlMgzzI570dNOqypN4JHwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6HpjYSe2jXgyaxCi9BLxQerReS4PJMTFFqmqT06r7CKbrE2L2vo1tIYYG7Uilb4syKAlf9id97Chm1KciVKzV9I1oFDcTPWxCQEgNJbWRElCU0NqjmamH+G8AONim6z+VyKEQbYrK+yiVfJsu+ORi/eAoLAnxfrIxcxrR8jMtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sEP36gJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sEP36gJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AB6C4CEF7;
	Thu, 29 Jan 2026 20:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769718868;
	bh=lpREL73FoGx1jd4AkVf/RAlMgzzI570dNOqypN4JHwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEP36gJ5Y41vimrwk+6WEDGFByGi430jaUNl1xM+4pKPnMb6dmdh0YkqobgNwLs3W
	 gCtKmT1ze6w/Df9IRROFXqVPHJWGXMJpPH9gdkcR31vMCws/d1OTP3FJX9oreV0mbv
	 LmBiXr5VF+RxBp/yaKw3/xhvF2UNMxpV56fDhC8mG5WZWZklt0tgQPVF9wFCpjH4BW
	 w2iFUSDjNhVOAgeMKQ9GI6DpR0qFYEa3O7eJ/QAeQNyOzham+ZyR8kQxMCmQVdTh12
	 BHsVb3gK5l+ExLZzCC9H8JmgoF4cHNvIYQzOmfXsEveUqWJYd7+l1c5i3TrL5SJM8q
	 nYEU302XUY5dA==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.6 000/254] 6.6.122-rc1 review
Date: Thu, 29 Jan 2026 21:34:13 +0100
Message-ID: <20260129203413.45705-1-ojeda@kernel.org>
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 28 Jan 2026 16:19:36 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.122 release.
> There are 254 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
