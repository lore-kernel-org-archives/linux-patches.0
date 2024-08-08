Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ECA18A6DF;
	Thu,  8 Aug 2024 10:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723113453; cv=none; b=aRLKDAUfSKcZKImcWrekhfvvvfl4iRLgy5kqG46Rb/bynNj5KKSBTD4y6TJggoua4EHMbDEn26u5pu1J8Im/1CNY5THwAO1erEqU12aDS4lZu+PCGencpECsnImp0lftsNuatGWw5VPRyptVUZKIr9BsuUO0KDnnpEl6ml4peTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723113453; c=relaxed/simple;
	bh=LkzIbKDJ/VzzDWsc37apyOD3Hdgy+syEuBhFPXlNn6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sS93Sd8/ymC4v9GsBLw2jwBEJ3CgMLDmxAoT6SBm0noeG3m+cbv5ARkrWfPZA8tZD+RqkxsI6wfIrUJSjH1OEVgZhFUgUzg1bKkoTYoFDXhpqICwFlDAjeo6FZGy2fZtkVq4hG3J9EEhzPZKQrpSEAPSKNWKkX2JFXaXqAduZgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SfPmCf9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SfPmCf9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3C1C32782;
	Thu,  8 Aug 2024 10:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723113453;
	bh=LkzIbKDJ/VzzDWsc37apyOD3Hdgy+syEuBhFPXlNn6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfPmCf9zKzLliV9VzaDP6ENjOg9hss0mSWjPSpBcXDpXgjzpWB/ndaQvsg81avvOs
	 oNDuyUTChTXFK1WuiXSsNDkEaf0U6Q6igkUKtg892kZAcm7NX/6SKEP6yf5oNIvUQJ
	 Qw7wmcCkjRbumLvmcPqv9A8caVzFXzCx40ICvqPMQZsBVVxBQrQnlSrMwFvXtiiiUZ
	 w55cvIMdWNSRS4neHIiZ22ll4xQJb/eibJiSQBnL2KY+xviNc4DwXJj5iMD3IE7SJ4
	 iMGn1PfbZNKE8YaqUbOdvERhYp/rpaUvQ0JI0MGwXPEHgDv0GJqVs6uuv6ZucyCUNg
	 +1LnfKeBmRnLw==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
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
Subject: Re: [PATCH 6.6 000/121] 6.6.45-rc1 review
Date: Thu,  8 Aug 2024 12:37:12 +0200
Message-ID: <20240808103712.378589-1-ojeda@kernel.org>
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 07 Aug 2024 16:58:52 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.45 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 Aug 2024 14:59:53 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
