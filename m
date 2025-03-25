Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C16719B3EC;
	Tue, 25 Mar 2025 18:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742927368; cv=none; b=ozcUzuo8OEK5gNaoelndYsI104iVfx2lSSXtKNowsfGo3QTIyTAkWlG02WmkN1qyCIV+hLqBxGq8o6xpeNksurIe9lboLCj10PfEoeDUFG7/ru0q63CjZoO8TT8njTf7AHOsQ1WJIPCwudfqNpUlSRWnQ1ue8RF2C6kgbYtwmCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742927368; c=relaxed/simple;
	bh=mTXVqqguPsRe6ntV6gd8EkY+O1gJwPKnl633P4VnJN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U91cU9qBVWW0XlP2k4CzCXEdBDwJ3h8goy9F4F6QsgkTwDTH+tTa9aeiZ7ycZiIX0wtxDe0529sPHpT15vwYnLf0y5TTyylUmbwC0a+AbS6+YbMJhrqIf829fDmqor7n953YzC8Quppj8qb+7fdMnzZzk67ZottFkgls0mAjVj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cAjqCBYo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cAjqCBYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD54C4CEE4;
	Tue, 25 Mar 2025 18:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742927367;
	bh=mTXVqqguPsRe6ntV6gd8EkY+O1gJwPKnl633P4VnJN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAjqCBYoTun6cegMQJQbv5edV2et/iYNYRexZBAQmeFLln2M1VggncTQxXAMcwFHZ
	 d+PA++OBi8AmV/JJTTmuDiELksobPpYn1DD2bUW1zkqTnCagIDQ7PFQS126BQQl+dw
	 phNdw4QcvliJbsj382BH9x+nctFM3wMiKAV6VkHBw6QSISTIxNV69Ta3vK3GpTGB9Y
	 A6BeHljnRq5N2ar9mGCcANGMRzAkDM5Sg06mHEeuDqb21cckvmLpURNng7esy4KNta
	 gzSgifXuhmiBUSdYhuosQFgpaUCANoUSbTJvbJLrvizm/AK6Pm5ODZlxmUsvYIOXws
	 ZpBAxWBJJd2vQ==
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
Subject: Re: [PATCH 6.13 000/119] 6.13.9-rc1 review
Date: Tue, 25 Mar 2025 19:29:15 +0100
Message-ID: <20250325182915.56442-1-ojeda@kernel.org>
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 25 Mar 2025 08:20:58 -0400 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.9 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
