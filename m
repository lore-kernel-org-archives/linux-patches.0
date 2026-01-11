Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E342A33C53D;
	Sun, 11 Jan 2026 13:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768139938; cv=none; b=TpqqadBUf6MVxw3DgJ7ZCr2NXWUjWqzgK11zf6ZSges0g9swNxXji+CVp5uC/+A6pi42qcIy/xQmxkbPYH/3XunjceeLb9bLQcFNE41sZCIrUF/71WvQiSduodC9dgX2phZxNtZuYp6a0ltecH5sSnBbTdXKP7WG42Z29fUCka8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768139938; c=relaxed/simple;
	bh=rN6z0J8lbP/MELcsAsFSXrEVkj3IcYWmmG9UdzYY0nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2ivyGxm5stoSnZOlDL4HxKxE8s71YY+ij8lJkPdsHpTRAH4HCMxVj65rCvZJupZwzDBBe/mkWpMXjYCJPm1xMMudAtUzB4my3XAvqpbMq9e4vT2LjUYOaksYtT4924FThdfOVFI2aeZnAmQgXykHeTMl4Z9mTQuyMR16bERelU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AS+5sURa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AS+5sURa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31383C4CEF7;
	Sun, 11 Jan 2026 13:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768139937;
	bh=rN6z0J8lbP/MELcsAsFSXrEVkj3IcYWmmG9UdzYY0nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AS+5sURaix/Wfjw8P0TEHJAk395yovn85f744bl8+PzWEEUU6xY9DlbyPY1j7KY2F
	 E2WGoqG+IvkSLx9IT/ZH/NeKnaxVZAIUVlZ3F8aUcwup+ZNFstpf4ivoUGzpm1j8av
	 cw9bf2VijF1paFAQ1zuahROVOZyiXzXlAx92MRQ0X4ihe+EARWGpHEXqOCtKkhj4dA
	 PZ5VOM3M4URPruAY6SkAn43Ei4SVV/FATc+2u1Z3zTaM8zesuoFfHTpmg8KJIdPZzz
	 SDxU63dHf1ndfI/MpEdcLUn52YAWBFr8lGCBVUHIgCHyKSsKKiaVBBbDzb9+h5/LMp
	 EyYjOOHLwM9ng==
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
Subject: Re: [PATCH 6.1 000/633] 6.1.160-rc2 review
Date: Sun, 11 Jan 2026 14:58:44 +0100
Message-ID: <20260111135844.165322-1-ojeda@kernel.org>
In-Reply-To: <20260110135319.581406700@linuxfoundation.org>
References: <20260110135319.581406700@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 10 Jan 2026 17:27:38 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.160 release.
> There are 633 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 12 Jan 2026 13:51:43 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
