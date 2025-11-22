Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5615C185B48;
	Sat, 22 Nov 2025 23:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763854663; cv=none; b=aBXJM+0trViMN1bVML6xZPAv4LSPoCEurbzP5mTEgxj0BlcRuCNQbse+zgQc6Wt1Mpx/UJBvGNXRK5U7xlRi+4XroFNl5oGsVSRospAOJex+EV+R3apq4KSNcNX1jMS4ar9Tz31CQ0bjrhVhJ7DkjGh93FOKrqRUI5OS97RZs24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763854663; c=relaxed/simple;
	bh=pH8hS7q3oakAfpz7fHbbtOQAga/aBiz++fUXMBSuIaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8iccPQoU8Lh6pIEFliaTMK/zrdzV96C0B1vX645cGxWHu1hf1d5sB/OqeApE0JwBfgoUtat8Rh1f3lsClG5xc8Ab2+edY5ERkF9Tdn/0zpc6lH9pRjQ9eQxZg71Yq+XnB4q27LhHVL+VVJqipltvQO8xspLAQZMrd+044GLiwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cn2MXWUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cn2MXWUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E586C4CEF5;
	Sat, 22 Nov 2025 23:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763854662;
	bh=pH8hS7q3oakAfpz7fHbbtOQAga/aBiz++fUXMBSuIaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cn2MXWUSkpSxAHabJvff7INIs0AhBtawN7Vq/ScY1n6XA95fGtV6tI+/pnUjUbNBT
	 +ccRG77ehMO4ZnlAxbut6V5NGEsLc/RFKiS+rmV4yiLTusZ2zApjaZjr2ZOnr+T912
	 VrNOFU4TDzkX2CbYoyl+zPqzCgcyAMZEG8q1e/PKHCxYCccQA+SEoA6gl4/sLRTKHb
	 EohQ3XPVcPQmLYtE9GGr3xP7pKquTHcosQ3lTaH/cvrW8ifCDZT5eVZ1uyG1n5519h
	 GvQ7iSACTefatvIZsJQNRmsHFY6TOt0SZcZQQAPA52FSiGfxBDdl+yMTpWQtaXeXQ3
	 abFhMsjvcbgzQ==
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
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
Date: Sun, 23 Nov 2025 00:37:34 +0100
Message-ID: <20251122233734.1722827-1-ojeda@kernel.org>
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 21 Nov 2025 14:10:27 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.59 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
