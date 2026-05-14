Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1C226D4CA;
	Thu, 14 May 2026 12:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778761910; cv=none; b=QwhKyUGcxTbQh2oF5CkqpTcZmGsWyjTPnDzJa87n8wC+GcKGjFrk9oCveBZPO4uPCkTQN//zR9oNssJakcalYg6TqcCjVttxYUH9r4xBVxRWLEWYafuAC3pRKbF7L/447+/nfivFhqkvDXLr6cMwTxaaRFplWf74Q0yEAlS9S+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778761910; c=relaxed/simple;
	bh=Kdy4Mftwo1hwWK6xhLBVe9sc+CM809ZEf01+zkfD+l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwN1E++YJT6YGrVUH05oo0+emAFX4ESqU2RCK2VbAdAhxKB+gkTywCASt/HNaU4Ml2PiDXQBtZiTiaDRO0tM1OVGtVkPJzN2mmuJ0+PN0i3mqOwVtbTyM0/NYKSOEoAA8SPPl0BscgHDBOc7WlpWw1G2cLv00tWV6JhHY1XRDnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ll5KPs8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ll5KPs8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39900C2BCB3;
	Thu, 14 May 2026 12:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778761910;
	bh=Kdy4Mftwo1hwWK6xhLBVe9sc+CM809ZEf01+zkfD+l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ll5KPs8EigMKyfqLr5aJO1zLLI5YxDq8sO+s9E9e3SyEZ0LiyiKO0RQHrBMr9+G/7
	 9dN4UiSK49VQOE/wyhDLOeWOAzPW0vWDda7ia8mDV6kewJsO77ciY2dNDJ7ztCyqL/
	 qaMKLOgwe7oL7rROSfnjIbFHBszCOs6Ump/4HdM5eaZ1SD1fLUqyyIIkJ+9vT0U1/c
	 CNRpS4KYNyVZ06G6eiWgm9MiICAT95Bv0IuUxIZ6QzHTi4H1+WRe9iAhGn/4ZfBFh4
	 KQzrVTBusdfdbYPpzqbi9HiXMkzyQ2NKcsOm8u/2R/n+VKTn8nqnSK1MspCBcVe8Cr
	 iLoLLDP3njWMg==
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
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/202] 6.12.88-rc2 review
Date: Thu, 14 May 2026 14:31:39 +0200
Message-ID: <20260514123139.417098-1-ojeda@kernel.org>
In-Reply-To: <20260513153743.326058350@linuxfoundation.org>
References: <20260513153743.326058350@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 13 May 2026 18:17:18 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.88 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 15 May 2026 15:37:24 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

The pin-init Clippy warnings I reported for -rc1 are gone, as expected.

There is another warning that will go away if these are applied:

  https://lore.kernel.org/stable/20260512201618.304954-1-ojeda@kernel.org/

Thanks!

Cheers,
Miguel
