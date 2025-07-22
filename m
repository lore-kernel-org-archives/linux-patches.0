Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66382E371F;
	Tue, 22 Jul 2025 22:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753222418; cv=none; b=oUSEEpe6oh/nAqLmfq3kEWIkZbsLsWkxShdVcrWTf9Y9RE4leIbT3o4cp/6XiD1ozw39lyGH28YYcmKvj+u3WUebICT7XYln9CeD71G2BVOwUgYSTsEqfoloDWJFfgNa6pfhprQKKdAIyynA4ZQOv3vqFQ/PHdNBnS0R6AqqTCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753222418; c=relaxed/simple;
	bh=1wM0fS+x8e/wZRKYniPy5bHPg8HbNCvIekCDmAOvAw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6a0dff5j99TK3paaUU1SZbZoXVRRYInOsXWmjrQ3T42ZYguXaJPd8ZdN7bd7xnr4Ztq3aH0rSj0IkfDlN1RLTKhY8WWpo2Uqr6jov8gimhV/tRGmj5ShGWurY//6iv48Ub+Pwe+UDP6CI7qjgOfWfPWa8LXLtxu9Kk/DOqChOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIwcQeb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIwcQeb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2040DC4CEEB;
	Tue, 22 Jul 2025 22:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753222416;
	bh=1wM0fS+x8e/wZRKYniPy5bHPg8HbNCvIekCDmAOvAw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIwcQeb3T3LrbPNTp49DW1KiKav1nxtEfAkbrUJ9Jiw4iO0m1o4E/XTdJilhTzF92
	 14k5bSWuKN6yLfzKwsRurlm9e8qIUP9AWF9n/NJJjdk5ibvldVvcVRdP2u3nMPR6aJ
	 YQdSiYG2XpCVbiSCeSlTHjuFLOznDziHGisT/Rob0HxzXMV3gBaGIoKy6Yw8Amrlal
	 WrustEr80TySCqJ4WwDM+8eDOTjtpA6DkBzqanvt2aoG+VoQeKySXDRBEwVXVm4zZA
	 +OugUYcrpuhzeKfhfvx68EhXSHM18yCVNQRoOiFtUedhb9TbO5P343TO6zg/flpgl+
	 3LCZJXlpXhYUA==
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
Subject: Re: [PATCH 6.6 000/111] 6.6.100-rc1 review
Date: Wed, 23 Jul 2025 00:13:24 +0200
Message-ID: <20250722221324.1684664-1-ojeda@kernel.org>
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 22 Jul 2025 15:43:35 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.100 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
