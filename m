Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04C633CD2;
	Thu, 10 Oct 2024 11:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728558992; cv=none; b=Ei/PrjCJK39h7YkvEGLsgN/6aCxrLDLNu7+Nf8YMZ3XN7RVlkIl681Lb3lV9k31g4XdLUIwwPRCy19+/kp5eerECTiG0qInCdT5FMO7sGTf8G0uCGZQLJFYYQD3jiyxn7L8FCQR0BHbr8W818dxT8qDRos/FUIUqAo0Pw2mrdmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728558992; c=relaxed/simple;
	bh=MuiucDyIZsey9FoFIxtSbpdBAKLMfR3IEx+A5iRDpRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI2KEjmak9f1wJjxxwQ56eRgH1F57Obeil2vuC/KWMhjZS2BRH4a4w/CwLRkkxyXtOeKvhPai/F+r7dI2T7qT2Ong8v3e9xnMJcBjcBRhxpiMzlOszMWIu/x+zTrR2GJf8HXvpVIMmezLEqJJmqPo9aDEOmhuhjzBOm3NooQxNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H37yc6OI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H37yc6OI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD92C4CEC5;
	Thu, 10 Oct 2024 11:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728558992;
	bh=MuiucDyIZsey9FoFIxtSbpdBAKLMfR3IEx+A5iRDpRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H37yc6OI1/TpNKQO6irAJ8ZsrsCWXts0FkcvVCZEunxu0t1sHRChtpucmdgBzgqMS
	 4HnnLuHkIR0SgH9tyK5kACeeMgerjDVQz5UsiKZUYogK7U8ISkPSRetAwxMFslyQht
	 E4Y4EHaHw6rc8bosUyYtpgFsxt1sr3YnAfpFGiHUX1OeRpK7I4Fmj5QDcqhrGoW5C6
	 rp1XsCUMnzWT+8jJLmGLshBJj3Rs2/g0SWhdbDqI7H+vvJVhG2cUOdSYV4io8B+fxM
	 GPrXNrtn2OdatfpRi62mmG/XnlWQQpRuD/Lv55FORpSJYeIeZrraDPvqGN7xsz000v
	 Qs7fLFNiSWdoQ==
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
Subject: Re: [PATCH 6.10 000/482] 6.10.14-rc1 review
Date: Thu, 10 Oct 2024 13:16:19 +0200
Message-ID: <20241010111619.119190-1-ojeda@kernel.org>
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 08 Oct 2024 14:01:03 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.14 release.
> There are 482 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
