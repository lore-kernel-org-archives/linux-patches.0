Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9E53DE44D;
	Thu,  9 Apr 2026 15:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775749151; cv=none; b=abm4TGkLh29oawIyLQ7S0d53UBLJY6+u31wNlCU69gh3V1mSK2DHqYquZyTiUFKdduUfh0pODoBiZkFUG4+fI8m5nUF4deZBhdpq65XgP3GhCjWGsKDJpCwZO1IrGC1UYqveaPajEWbxy/6lh3h9T/N26naj+Jo7gHnJAWKtK54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775749151; c=relaxed/simple;
	bh=AEeUX2SQdCTAmhUr44kqm08QLCmXgxQOLC8qM/EqwxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFw+fSf7+DL8AjPdSVtJYnHXZxNYt7vQqijlX5axm5NzLvQNxIY5kAg5ub2PmvrUaAG0F4OGZdXTOlmTWZFf86V07GSpZ1nWcozbwmLSVQDM+7eCvlnMzFwuPyDn3BTKkmJiqGTCFf04iUSY8+6F0O/AG/cJvBvLZ14sJewvhYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDcDHtJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDcDHtJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2675C116C6;
	Thu,  9 Apr 2026 15:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775749151;
	bh=AEeUX2SQdCTAmhUr44kqm08QLCmXgxQOLC8qM/EqwxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDcDHtJ1eGecHB0ySf1aux6IMYyVbGsrF4Ausr5KlOQD3WqN5/w/dDCs/7tbIpyAQ
	 JsJFkZx8mnkMIGYIEEQs1TyAmxyO/SEuoTIT2pOdtVltzLXfjpoq0rAKXxVYmF3xCh
	 sbH75IZeKqHq2T2WBPKOjOqCTOnuDuIBz1panvF0bUGnxSTgV9zooOgjnXja+Q96UF
	 sX9AykfUr4ZsfcPVTVAF/oiDfOpVPSHY2dUIjAK4WjsEPG3MuHsHD69Q6xwfh6IO41
	 y5R87URAEOPMp5Res4lu7xZsmQHoIJqyKTX0vbLw4rSd71L4hfxsd0tKcymgqDwFiN
	 BkGoYkzzJ3puA==
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
Subject: Re: [PATCH 6.1 000/312] 6.1.168-rc1 review
Date: Thu,  9 Apr 2026 17:38:48 +0200
Message-ID: <20260409153848.32578-1-ojeda@kernel.org>
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 08 Apr 2026 19:58:37 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.168 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
