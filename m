Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049101F1313;
	Wed, 11 Feb 2026 13:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770817544; cv=none; b=dEQw5ywdwyqDkM+IRWdqhjKrP2hOafN/oT9wlizm8M9/BmrfkRM4NaA+mIAPcnn2YT47uJUvFmJyQMw85K9KCgMANMmVAZDCeynpDDFCBKsN2xzV7fDi90yFp3IfD28JwTLl3CfZNHEfW+Id0pRFxl0b9pb2Z2sbRLr1yrlOjc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770817544; c=relaxed/simple;
	bh=S0pvBMng9yVBlzAqntdZxbxTR0L6CGcOdMMRmvtqZ/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdILhaPiPU6JfV/bzXGzw8p/NVvqPTqar3saDnRoEjI7QzBhbFQHYp+NeqxSGQoyGzvXND29cYARHwudnaNiLsYLvTD75aTfZ/ZCCsSX6ywjEA1ZgypTUyawO6+/nePEIm+kJ3e0qG7/XIFYPkUWrsb5ZOyYgFiq0Xzj86ur76g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KfhaG2bd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KfhaG2bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07144C4CEF7;
	Wed, 11 Feb 2026 13:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770817543;
	bh=S0pvBMng9yVBlzAqntdZxbxTR0L6CGcOdMMRmvtqZ/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfhaG2bdgeWHLG06A5zVvd/sph2MJTyOx9b8Yv9z7P9WAjEb7kwPvjvE44bZDSugm
	 QQdcNTAIjQW3M8mAW1gs/6/j9Uc1PMmkjdlR9DZd99tL31W/u/90T5j6hOamPLMd+R
	 AGNLVZ630FRgt9QM7BuWmfpbAtnvWF7nW7bmItQdblPCg6VqirpsKZQFBkelOBTstl
	 HenNjSeH3A7W8OlAivaMyhkmjA/lLy3uKcTKkhs4MEeRLeS7qWOyty0lPAkhl0dmOQ
	 6gnfl315XIfTa1AoUQ3MlDGorpXbXkHDrgLfzDdW+CCKxIEGSOOK7j0jZRwnJMY7ZZ
	 oHZrraLdqmu6Q==
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
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
Date: Wed, 11 Feb 2026 14:45:33 +0100
Message-ID: <20260211134533.11183-1-ojeda@kernel.org>
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 09 Feb 2026 15:21:13 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
